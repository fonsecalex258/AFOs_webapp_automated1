library(httr)
library(jsonlite)
library(dplyr)






BASE_URL <- "https://v1serv-prod.evidencepartners.com"

# ==============================
# USER CONFIG
# ==============================

# DistillerSR credentials are intentionally NOT stored in this file.
# They are requested at runtime so this script can be safely pushed to GitHub.

project_id <- 36598

saved_report_id_included <- 5372
saved_report_id_excluded <- 5427

# ==============================
# AUTHENTICATION
# ==============================

get_distiller_token <- function(){
  
  if(!requireNamespace("rstudioapi", quietly = TRUE)){
    stop("❌ Package 'rstudioapi' is required for credential entry.")
  }
  
  # Ask for username
  username <- rstudioapi::showPrompt(
    title = "DistillerSR authentication",
    message = "Enter your DistillerSR username:",
    default = ""
  )
  
  # Ask for password
  password <- rstudioapi::askForPassword(
    prompt = "Enter your DistillerSR password"
  )
  
  if(!nzchar(username) || !nzchar(password)){
    stop("❌ Missing DistillerSR credentials")
  }
  
  auth_response <- POST(
    paste0(BASE_URL, "/api/v1/auth/"),
    authenticate(username, password, type = "basic"),
    accept_json()
  )
  
  cat("Authentication status:", status_code(auth_response), "\n")
  
  if(status_code(auth_response) != 200){
    stop("❌ DistillerSR authentication failed")
  }
  
  content(auth_response)$token
}

# ==============================
# GENERIC API CALL
# ==============================

get_saved_report <- function(saved_report_id, project_id, token){
  
  response <- POST(
    paste0(BASE_URL, "/api/v1/datarama/query"),
    add_headers(
      Authorization = paste("Bearer", token),
      `Content-Type` = "application/json"
    ),
    body = toJSON(
      list(
        saved_report_id = saved_report_id,
        project_id = project_id
      ),
      auto_unbox = TRUE
    )
  )
  
  stop_for_status(response)
  
  fromJSON(
    content(response, "text", encoding = "UTF-8"),
    simplifyVector = FALSE
  )
}

# ==============================
# INCLUDED TABLE
# ==============================
#cat("Getting token...\n")
#token <- get_distiller_token()

extract_included_table <- function(parsed){
  
  rows <- lapply(parsed, function(ref){
    
    doi     <- ifelse(!is.null(ref$tags$DOI), ref$tags$DOI, "")
    issn    <- ifelse(!is.null(ref$tags$ISSN), ref$tags$ISSN, "")
    journal <- ifelse(!is.null(ref$tags$Journal), ref$tags$Journal, "")
    year    <- ifelse(!is.null(ref$tags$Year), ref$tags$Year, "")
    
    country <- ""
    
    if(length(ref$data_sets) > 0){
      dataset <- ref$data_sets[[1]]
      
      for(q in dataset$data){
        if(grepl("location of the study population", q$question, ignore.case = TRUE)){
          country <- q$response$text
        }
      }
    }
    
    data.frame(
      Author = ref$author,
      Title = ref$title,
      DOI = doi,
      ISSN = issn,
      Journal = journal,
      Year = year,
      Country = country,
      stringsAsFactors = FALSE
    )
  })
  
  df <- bind_rows(rows)
  df$ID <- seq_len(nrow(df))
  
  df[, c("ID", setdiff(names(df), "ID"))]
}




#####
# Alex

######
extract_included_table_full <- function(parsed){
  
  library(dplyr)
  
  # -----------------------------
  # STEP 1: COLLECT ALL QUESTIONS (GLOBAL SCHEMA)
  # -----------------------------
  
  all_questions <- character()
  
  for(ref in parsed){
    
    if(length(ref$data_sets) == 0) next
    
    # Use ONLY first dataset with level 3
    ds <- NULL
    for(d in ref$data_sets){
      if(!is.null(d$level) && d$level == 3){
        ds <- d
        break
      }
    }
    
    if(is.null(ds)) next
    
    for(q in ds$data){
      qname <- q$question
      qname <- gsub("\r|\n", " ", qname)
      qname <- trimws(qname)
      
      all_questions <- unique(c(all_questions, qname))
    }
  }
  
  # Clean names ONCE globally
  clean_names <- make.names(all_questions, unique = TRUE)
  question_map <- setNames(clean_names, all_questions)
  
  # -----------------------------
  # STEP 2: BUILD ROWS WITH FIXED STRUCTURE
  # -----------------------------
  
  rows <- list()
  
  for(ref in parsed){
    
    # --- BASE FIELDS (always present)
    row <- list(
      Refid = as.character(ref$refid),
      Author = as.character(ref$author),
      Title  = as.character(ref$title)
    )
    
    # --- TAGS (DOI, ISSN, etc.)
    if(!is.null(ref$tags)){
      for(tag_name in names(ref$tags)){
        row[[tag_name]] <- as.character(ref$tags[[tag_name]])
      }
    }
    
    # --- INITIALIZE ALL QUESTIONS AS NA
    for(q in clean_names){
      row[[q]] <- NA_character_
    }
    
    # --- FILL FROM DATASET
    if(length(ref$data_sets) > 0){
      
      ds <- NULL
      for(d in ref$data_sets){
        if(!is.null(d$level) && d$level == 3){
          ds <- d
          break
        }
      }
      
      if(!is.null(ds)){
        
        for(q in ds$data){
          
          raw_name <- q$question
          raw_name <- gsub("\r|\n", " ", raw_name)
          raw_name <- trimws(raw_name)
          
          clean_name <- question_map[[raw_name]]
          
          value <- NA_character_
          
          if(!is.null(q$response$answer) && q$response$answer != ""){
            value <- q$response$answer
          } else if(!is.null(q$response$text) && q$response$text != ""){
            value <- q$response$text
          }
          
          row[[clean_name]] <- as.character(value)
        }
      }
    }
    
    rows[[length(rows) + 1]] <- row
  }
  
  # -----------------------------
  # STEP 3: BUILD DATAFRAME
  # -----------------------------
  
  df <- bind_rows(lapply(rows, function(x){
    as.data.frame(x, stringsAsFactors = FALSE)
  }))
  
  # -----------------------------
  # STEP 4: FORCE COLUMN ORDER
  # -----------------------------
  
  base_cols <- c("Refid", "Author", "Title")
  
  tag_cols <- setdiff(
    names(df),
    c(base_cols, clean_names)
  )
  
  final_cols <- c(base_cols, tag_cols, clean_names)
  
  # Ensure all exist
  for(col in final_cols){
    if(!col %in% names(df)){
      df[[col]] <- NA_character_
    }
  }
  
  df <- df[, final_cols]
  
  # -----------------------------
  # STEP 5: FINAL SAFETY
  # -----------------------------
  
  # Remove accidental duplicates (should not happen, but just in case)
  df <- df[, !duplicated(names(df))]
  
  # Guarantee types
  df <- df %>%
    mutate(
      Refid = as.character(Refid)
    )
  
  return(df)
}
# ==============================
# HELPER
# ==============================

get_response <- function(q){
  if(!is.null(q$response$answer)) return(q$response$answer)
  if(!is.null(q$response$text)) return(q$response$text)
  return(NA)
}



# ==============================
# EXCLUDED TABLE
# ==============================

extract_excluded_table <- function(parsed){
  
  rows <- lapply(parsed, function(ref){
    
    year <- ifelse(!is.null(ref$tags$Year), ref$tags$Year, "")
    
    English <- NA
    Primary <- NA
    Exposure <- NA
    Individual <- NA
    Intensive <- NA
    Unit <- NA
    Measurement <- NA
    
    if(length(ref$data_sets) > 0){
      dataset <- ref$data_sets[[1]]
      
      for(q in dataset$data){
        qtext <- tolower(q$question)
        resp  <- tolower(get_response(q))
        
        if(grepl("english", qtext)) English <- resp
        if(grepl("primary research", qtext)) Primary <- resp
        if(grepl("comparative association", qtext)) Exposure <- resp
        if(grepl("individual human", qtext)) Individual <- resp
        if(grepl("concentrated or intensive", qtext)) Intensive <- resp
        if(grepl("unit of measurement", qtext)) Unit <- resp
        if(grepl("survey instrument", qtext)) Measurement <- resp
      }
    }
    
    data.frame(
      Author = ref$author,
      Title = ref$title,
      Year = year,
      English = English,
      Primary = Primary,
      Exposure = Exposure,
      Individual = Individual,
      Intensive = Intensive,
      Unit = Unit,
      Measurement = Measurement,
      stringsAsFactors = FALSE
    )
  })
  
  bind_rows(rows)
}

extract_exclusion_reason <- function(df){
  
  df %>%
    mutate(
      Reason = case_when(
        grepl("no", English, ignore.case = TRUE) ~ "Not in English",
        grepl("no", Primary, ignore.case = TRUE) ~ "Not primary research",
        grepl("no", Exposure, ignore.case = TRUE) ~ "No relevant exposure",
        grepl("no", Individual, ignore.case = TRUE) ~ "Not individual-level",
        grepl("no", Intensive, ignore.case = TRUE) ~ "Not intensive AFO",
        grepl("no", Unit, ignore.case = TRUE) ~ "Poor exposure measurement",
        grepl("no", Measurement, ignore.case = TRUE) ~ "No relevant outcome",
        TRUE ~ NA_character_
      )
    )
}



#####



# ==============================
# ALL REFERENCES (PRISMA)
# ==============================

get_all_references <- function(project_id, token){
  
  url <- paste0(BASE_URL, "/api/v1/projects/", project_id, "/references?page_size=500")
  
  all_refs <- list()
  i <- 1
  
  repeat {
    
    cat("Fetching batch:", i, "\n")
    
    res <- GET(url, add_headers(Authorization = paste("Bearer", token)))
    stop_for_status(res)
    
    parsed <- fromJSON(content(res, "text", encoding = "UTF-8"))
    refs <- parsed$references
    
    if(is.null(refs) || length(refs) == 0) break
    
    all_refs[[i]] <- refs
    
    next_url <- parsed[["ep-api-paging"]][["next"]]
    
    if(is.null(next_url) || next_url == "") break
    
    url <- next_url
    i <- i + 1
  }
  
  bind_rows(all_refs)
}

# ==============================
# CROSS-SECTIONAL (FOREST PLOT CLEAN DATA)
# ==============================

# ==============================
# CROSS-SECTIONAL (FOREST PLOT CLEAN DATA)
# ==============================

# ==============================
# CROSS TABLE (CORRECT VERSION)
# ==============================

extract_cross_table <- function(parsed){
  
  rows <- list()
  all_questions <- character()
  
  for(ref in parsed){
    
    if(length(ref$data_sets) == 0) next
    
    for(ds in ref$data_sets){
      
      if(ds$level != 3) next
      if(ds$form != "Outcomes extraction_ ROB Cross-sectional") next
      if(tolower(ds$user) != "sarah_totton") next
      
      row <- list(
        Refid = as.character(ref$refid),
        User = as.character(ds$user),
        Level = as.character(ds$level)
      )
      
      for(q in ds$data){
        
        qname <- q$question
        qname <- gsub("\r|\n", " ", qname)
        qname <- trimws(qname)
        
        value <- NA_character_
        
        if(!is.null(q$response$answer) && q$response$answer != ""){
          value <- q$response$answer
        } else if(!is.null(q$response$text) && q$response$text != ""){
          value <- q$response$text
        }
        
        row[[qname]] <- as.character(value)
        
        # Track all possible columns dynamically
        all_questions <- unique(c(all_questions, qname))
      }
      
      rows[[length(rows) + 1]] <- row
    }
  }
  
  # Convert safely
  df <- dplyr::bind_rows(lapply(rows, function(x){
    as.data.frame(x, stringsAsFactors = FALSE)
  }))
  
  # Ensure ALL columns exist (important!)
  base_cols <- c("Refid", "User", "Level")
  all_cols  <- unique(c(base_cols, all_questions))
  
  for(col in all_cols){
    if(!col %in% names(df)){
      df[[col]] <- NA_character_
    }
  }
  
  # Order columns: base first, then rest
  df <- df[, all_cols]
  
  # Clean names like Distiller
  names(df) <- make.names(names(df), unique = TRUE)
  
  # Match types
  df$Level <- suppressWarnings(as.numeric(df$Level))
  
  return(df)
}

# ==============================
# CASE-CONTROL TABLE (FOREST DATA)
# ==============================

extract_casecontrol_table <- function(parsed){
  
  rows <- list()
  
  for(ref in parsed){
    
    if(length(ref$data_sets) == 0) next
    
    for(ds in ref$data_sets){
      
      # Filter: Level 3 + correct form + correct user
      if(ds$level != 3) next
      if(ds$form != "Outcomes extraction_ROB Case-control") next
      if(tolower(ds$user) != "sarah_totton") next
      
      row <- list(
        Refid = as.character(ref$refid),
        User  = as.character(ds$user),
        Level = as.character(ds$level)
      )
      
      for(q in ds$data){
        
        qname <- q$question
        
        # Clean names (IMPORTANT)
        qname <- gsub("\r|\n", " ", qname)
        qname <- trimws(qname)
        
        value <- NA_character_
        
        if(!is.null(q$response$answer) && q$response$answer != ""){
          value <- q$response$answer
        } else if(!is.null(q$response$text) && q$response$text != ""){
          value <- q$response$text
        }
        
        row[[qname]] <- as.character(value)
      }
      
      rows[[length(rows) + 1]] <- row
    }
  }
  
  df <- dplyr::bind_rows(lapply(rows, function(x){
    as.data.frame(x, stringsAsFactors = FALSE)
  }))
  
  return(df)
}

# ==============================
# COHORT TABLE (FOREST DATA)
# ==============================

extract_cohort_table <- function(parsed){
  
  rows <- list()
  
  for(ref in parsed){
    
    if(length(ref$data_sets) == 0) next
    
    for(ds in ref$data_sets){
      
      # Filter: Level 3 + correct form + correct user
      if(ds$level != 3) next
      if(ds$form != "Outcomes extraction_ROB Cohort") next
      if(tolower(ds$user) != "sarah_totton") next
      
      row <- list(
        Refid = as.character(ref$refid),
        User  = as.character(ds$user),
        Level = as.character(ds$level)
      )
      
      for(q in ds$data){
        
        qname <- q$question
        
        # Clean names
        qname <- gsub("\r|\n", " ", qname)
        qname <- trimws(qname)
        
        value <- NA_character_
        
        if(!is.null(q$response$answer) && q$response$answer != ""){
          value <- q$response$answer
        } else if(!is.null(q$response$text) && q$response$text != ""){
          value <- q$response$text
        }
        
        row[[qname]] <- as.character(value)
      }
      
      rows[[length(rows) + 1]] <- row
    }
  }
  
  df <- dplyr::bind_rows(lapply(rows, function(x){
    as.data.frame(x, stringsAsFactors = FALSE)
  }))
  
  return(df)
}

# ==============================
# ALIGN WITH EXCEL STRUCTURE
# ==============================

