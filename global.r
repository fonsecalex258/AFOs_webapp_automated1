#hello world
# adding more lines of text to chek the push 
library(shinydashboard)
library(shinycssloaders)
library(shinyWidgets)
library(leaflet)
library(plotly)
library(timevis)
library(tidyverse)
library(DT)
library(readxl)
library(tesseract)
#library(magick)

###
load("RData")

initialize_cache <- function(){
  
  required_files <- c(
    "included_cache_2.rds",
#    "excluded_cache.rds",
    "cross_base_cache.rds",
    "included_cache_1.rds",
    "forest_case_cache.rds",
#  "refs_cache.rds",
    "forest_cohort_cache.rds"
  )
  
  missing_files <- required_files[!file.exists(required_files)]
  
  if(length(missing_files) > 0){
    
    stop(
      paste0(
        "❌ Missing cache files:\n",
        paste(missing_files, collapse = "\n"),
        "\n\n👉 Run: source('update_cache.R') before launching the app."
      )
    )
    
  } else {
    message("✅ Cache available")
  }
}


initialize_cache()

#included_df        <- readRDS("included_cache.rds")
included_df2        <- readRDS("included_cache_1.rds")
included_df  <- readRDS("included_cache_2.rds")

names(included_df2)[11] <- 'Country'

#included_df <- included_df2 %>%
#  select(
#    Refid,
#    Author,
#    Title,
#    DOI,
#    ISSN,
#    Journal,
#    Year,
#    Country
#  )

#saveRDS(included_df, "included_cache_f.rds")


included_df <- included_df %>%
  #rename(Refid = ID) %>%
  mutate(Refid = as.numeric(Refid))



#names(included_df1)[11] <- 'Country'


#included_subset <- included_df1 %>%
#  select(
#    Refid,
#    Author,
#    Title,
#    DOI,
#    ISSN,
#    Journal,
#    Year,
#    Country
#  )

#saveRDS(included_subset, "included_subset_cache.rds")

#inclusion123 <- readRDS("inclusion_cache.rds")
forest_case_df <- readRDS("forest_case_cache.rds")
#### Exclusion data
timelineV02 <- readxl::read_xlsx("datasets/timeline_V01.xlsx")
#exclusion <- readxl::read_xlsx("datasets/excluded.xlsx")
cross_clean <- readRDS("cross_base_cache.rds")

#######
#cafo_map <- readxl::read_xlsx("datasets/included.xlsx")

cafo_map <- included_df2
#names(cafo_map)[11] <- 'Country'
#names(cafo_map)[13] <- 'Country'

#names(cafo_map)[8] <- 'Country'

#cafoo_map <- cafo_map %>% group_by(Country) %>% 
#  summarise(`Number_of_Studies` = n())%>%
#  mutate(long = ifelse(Country == "Germany", 10.44768,
#                       ifelse(Country == "Netherlands", 5.2913,ifelse(Country == "USA", -98.5795, ifelse(Country=="Norway", 8.468946, ifelse(Country=="Mexico", -102.552784, ifelse(Country=="Canada", -106.346771, ifelse(Country=="UK", -3.435973, 2.213749))) ))))) %>% 
#  mutate(lat = ifelse(Country == "Germany", 51.165691,
#                      ifelse(Country == "Netherlands", 52.132633,ifelse(Country == "USA", 37.09024, ifelse(Country=="Norway", 60.472024, ifelse(Country=="Mexico", 23.634501, ifelse(Country=="Canada", 56.130366, ifelse(Country=="UK", 55.378051, 46.227638))) )))))

# Summarize the number of studies by country
cafoo_map_sum <- cafo_map %>%
  group_by(Country) %>%
  summarise(Number_of_Studies = n())


# ==============================
# EXCLUDED DATA (FROM CACHE)
# ==============================

#excluded_data <- function(){
  
#  if(!file.exists("excluded_cache.rds")){
#    stop("❌ excluded_cache.rds not found. Run update_all_caches.R first.")
#  }
  
#  df <- readRDS("excluded_cache.rds")
  
  # Ensure character types (VERY IMPORTANT to avoid DT / grepl errors)
#  df[] <- lapply(df, function(x) as.character(x))
  
#  return(df)
#}

# Function to get latitude and longitude
get_lat_long <- function(country_name) {
  # Use world.cities dataset from maps package to find lat/long
  location <- maps::world.cities %>% 
    filter(country.etc == country_name) %>%
    summarise(lat = mean(lat), long = mean(long))
  
  # If no match is found, return NA
  if (nrow(location) == 0) {
    return(c(NA, NA))
  } else {
    return(c(location$lat, location$long))
  }
}

# Apply the function to get latitude and longitude
lat_long <- t(sapply(cafoo_map_sum$Country, get_lat_long))
cafoo_map <- cafoo_map_sum %>%
  mutate(lat = lat_long[,1], long = lat_long[,2])


# View the summary with lat and long
#print(summary)
cafo_map1_clean <- cafo_map %>%
  mutate(
    Last_Name = str_split_fixed(Author, ",", 2)[,1],  # Extract last name before the comma
    authors = paste(Last_Name, "et al.", Year),        # Combine last name with "et al." and Year
    weblink = paste0("<a href='https://doi.org/", DOI, "'>", authors, "</a>")
  ) %>%
  select(weblink, Year, Refid, Country, authors)  # Include lat and long

# Create a grouped data frame with concatenated weblinks for each country
grouped_df <- cafo_map1_clean %>%
  group_by(Country) %>%
  summarise(
    weblinks = paste(weblink, collapse = "<br>"),  # Concatenate weblinks for each country
    .groups = 'drop'
  )

###### create the long and lat variables in another dataset by matching the country variable across two datasets in R

cafo_map1_df <- cafo_map1_clean %>%
  left_join(cafoo_map, by = "Country")


old_cross_s_df <- read_excel("datasets/old_cross_sectional.xlsx")
old_cross_s_df$Refid <- as.character(old_cross_s_df$Refid)
included_df$Refid <- as.character(included_df$Refid)
old_cross_s <- old_cross_s_df %>%
  left_join(included_df %>% select(Refid, Country), by = "Refid")


#cross_base_df <- cross_clean

cross_base_df <- read_excel("datasets/distiller_cross.xlsx")
cross_base_df$Refid <- as.character(cross_base_df$Refid)
cross_base_clean <- cross_base_df[, -((ncol(cross_base_df) - 4):ncol(cross_base_df))]

cross_base_filt <- cross_base_clean %>% filter(!Refid %in% c(4, 5, 6, 7, 9, 11, 13, 15)) 
cross_base <- cross_base_filt %>%
  left_join(included_df %>% select(Refid, Country), by = "Refid")

forest_cross <- bind_rows(cross_base, old_cross_s)
forest_cross1_df <- bind_rows(cross_base, old_cross_s)

######### cration of a new dataset based on newest distiller form
#forest_cross <- read_excel("datasets/distiller_cross_1.xlsx")
#forest_cross1 <- read_excel("datasets/distiller_cross_1.xlsx")
#forest_cohort_df <- read_excel("datasets/distiller_cohort.xlsx")
#forest_case_df <- read_excel("datasets/distiller_casecontrol.xlsx")

forest_case_df <- readRDS("forest_case_cache.rds")
forest_case_df$Refid <- as.character(forest_case_df$Refid)

forest_cohort_df <- readRDS("forest_cohort_cache.rds")
forest_cohort_df$Refid <- as.character(forest_cohort_df$Refid)


#forest_cohort_df$Refid <- as.character(forest_cohort_df$Refid)
#forest_case_df$Refid <- as.character(forest_case_df$Refid)
#forest_cross$Refid <- as.character(forest_cross$Refid)
#forest_cross1$Refid <- as.character(forest_cross1$Refid)

#df <- df %>%
#  rename(new_column_name = old_column_name)

forest_cohort <- forest_cohort_df %>%
  rename('outcome'  = 'Outcome variable') %>%
  rename('exposure' = 'Community health/animal exposure measure') %>%
  mutate(effect_measure = ifelse(effect_measure == "OR  - ROR", "OR", effect_measure))

#### To add the values for the Refid without extaction in distiller

values_for_refid <- list(
  "Ever smell odor from a farm with animals when at home" = list("No", "1", "NA", "NA", "Yes", "1.51", "2.86", "0.80", NA, NA, NA, NA),
  "Live within 1 mile of a swine or poultry CAFO" = list("No", "1", "NA", "NA", "Yes", "0.6", "1.16", "0.31", NA, NA, NA, NA),
  "Permitted farrowing swine per square mile of block group" = list("0", "1", "NA", "NA", ">0-149", "1.99", "4", "0.99", ">149", "0.42", "1.13", "0.15"),
  "Permitted non-farrowing swine per square mile of block group" = list("0", "1", "NA", "NA", ">0-149", "2.04", "6.85", "0.61", ">149", "0.95", "1.68", "0.54"),
  "Permitted swine per square mile of block group" = list("0", "1", "NA", "NA", ">0-149", "4.76", "16.69", "1.36", ">149", "0.95", "1.72", "0.53")
)

# Vectorized mutate function using case_when for better readability
forest_case_new <- forest_case_df %>%
  mutate(
    subcategory1 = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[1]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[1]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[1]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[1]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[1]],
      TRUE ~ subcategory1  # Keep original value if no matches
    ),
    subcategory1_EM = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[2]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[2]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[2]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[2]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[2]],
      TRUE ~ subcategory1_EM
    ),
    subcategory1_UL = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[3]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[3]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[3]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[3]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[3]],
      TRUE ~ subcategory1_UL
    ),
    subcategory1_LL = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[4]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[4]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[4]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[4]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[4]],
      TRUE ~ subcategory1_LL
    ),
    # Repeat the above pattern for subcategory2, subcategory3, etc.
    subcategory2 = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[5]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[5]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[5]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[5]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[5]],
      TRUE ~ subcategory2  # Keep original value if no matches
    ),
    subcategory2_EM = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[6]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[6]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[6]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[6]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[6]],
      TRUE ~ subcategory2_EM
    ),
    subcategory2_UL = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[7]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[7]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[7]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[7]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[7]],
      TRUE ~ subcategory2_UL
    ),
    subcategory2_LL = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[8]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[8]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[8]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[8]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[8]],
      TRUE ~ subcategory2_LL
    ),
    
    subcategory3 = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[9]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[9]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[9]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[9]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[9]],
      TRUE ~ subcategory3  # Keep original value if no matches
    ),
    subcategory3_EM = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[10]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[10]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[10]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[10]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[10]],
      TRUE ~ subcategory3_EM
    ),
    subcategory3_UL = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[11]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[11]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[11]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[11]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[11]],
      TRUE ~ subcategory3_UL
    ),
    subcategory3_LL = case_when(
      grepl("Ever smell odor from a farm with animals when at home", exposure) ~ values_for_refid[["Ever smell odor from a farm with animals when at home"]][[12]],
      grepl("Live within 1 mile of a swine or poultry CAFO", exposure) ~ values_for_refid[["Live within 1 mile of a swine or poultry CAFO"]][[12]],
      grepl("Permitted farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted farrowing swine per square mile of block group"]][[12]],
      grepl("Permitted non-farrowing swine per square mile of block group", exposure) ~ values_for_refid[["Permitted non-farrowing swine per square mile of block group"]][[12]],
      grepl("Permitted swine per square mile of block group", exposure) ~ values_for_refid[["Permitted swine per square mile of block group"]][[12]],
      TRUE ~ subcategory3_LL
    )
  )


values_for_refid0 <- list(
  "Pig density in municipal area" = list("Pig density", "1.37", "1.87", "1.01"),
  "Cow density in municipal area" = list("Cow density", "2.28", "4.45", "1.17"),
  "Veal calf density" = list("Veal calf density", "1.37", "1.72", "1.08")
)

# Optimized mutate function with correct matching
forest_case_1 <- forest_case_new %>%
  mutate(
    subcategory1 = ifelse(
      grepl("Pig density in municipal area", exposure), values_for_refid0[["Pig density in municipal area"]][[1]],
      ifelse(grepl("Cow density in municipal area", exposure), values_for_refid0[["Cow density in municipal area"]][[1]],
             ifelse(grepl("Veal calf density", exposure), values_for_refid0[["Veal calf density"]][[1]], subcategory1)
      )
    ),
    subcategory1_EM = ifelse(
      grepl("Pig density in municipal area", exposure), values_for_refid0[["Pig density in municipal area"]][[2]],
      ifelse(grepl("Cow density in municipal area", exposure), values_for_refid0[["Cow density in municipal area"]][[2]],
             ifelse(grepl("Veal calf density", exposure), values_for_refid0[["Veal calf density"]][[2]], subcategory1_EM)
      )
    ),
    subcategory1_UL = ifelse(
      grepl("Pig density in municipal area", exposure), values_for_refid0[["Pig density in municipal area"]][[3]],
      ifelse(grepl("Cow density in municipal area", exposure), values_for_refid0[["Cow density in municipal area"]][[3]],
             ifelse(grepl("Veal calf density", exposure), values_for_refid0[["Veal calf density"]][[3]], subcategory1_UL)
      )
    ),
    subcategory1_LL = ifelse(
      grepl("Pig density in municipal area", exposure), values_for_refid0[["Pig density in municipal area"]][[4]],
      ifelse(grepl("Cow density in municipal area", exposure), values_for_refid0[["Cow density in municipal area"]][[4]],
             ifelse(grepl("Veal calf density", exposure), values_for_refid0[["Veal calf density"]][[4]], subcategory1_LL)
      )
    )
  )


#df <- df %>%
#  mutate(measure = ifelse(measure == "OR - ROR", "OR", measure))

######
#forest_cross <-  forest_cross %>% mutate(authors = ifelse(Refid%in%testtimeline$Refid, testtimeline$authors, ""))
#forest_cross$authors <- testtimeline$authors[match(forest_cross$Refid, testtimeline$Refid)]
forest_cross$authors <- cafo_map1_df$authors[match(forest_cross$Refid, cafo_map1_df$Refid)]


#forest_cross1 <-  forest_cross1 %>% mutate(authors = ifelse(Refid%in%testtimeline$Refid, testtimeline$authors, ""))
#forest_cross1$authors <- testtimeline$authors[match(forest_cross1$Refid, testtimeline$Refid)]
#forest_cross1$authors <- cafo_map1_df$authors[match(forest_cross1$Refid, cafo_map1_df$Refid)]

#forest_cohort <-  forest_cohort %>% mutate(authors = ifelse(Refid%in%testtimeline$Refid, testtimeline$authors, ""))
#forest_cohort$authors <- testtimeline$authors[match(forest_cohort$Refid, testtimeline$Refid)]
forest_cohort$authors <- cafo_map1_df$authors[match(forest_cohort$Refid, cafo_map1_df$Refid)]

#forest_case_1 <-  forest_case_1 %>% mutate(authors = ifelse(Refid%in%testtimeline$Refid, testtimeline$authors, ""))
#forest_case_1$authors <- testtimeline$authors[match(forest_case_1$Refid, testtimeline$Refid)]
forest_case_1$authors <- cafo_map1_df$authors[match(forest_case_1$Refid, cafo_map1_df$Refid)]

######### to include country
#forest_cross <-  forest_cross %>% mutate(authors = ifelse(Refid%in%testtimeline$Refid, testtimeline$authors, ""))
#forest_cross$Country <- testtimeline$country[match(forest_cross$Refid, testtimeline$Refid)]
forest_cross$Country <- cafo_map1_df$Country[match(forest_cross$Refid, cafo_map1_df$Refid)]

#forest_cross1 <-  forest_cross1 %>% mutate(authors = ifelse(Refid%in%cafo_map1_df$Refid, cafo_map1_df$authors, ""))
cafo_map1_df$Refid <- as.character(cafo_map1_df$Refid)

forest_cross1 <-  forest_cross1_df %>% 
  left_join(cafo_map1_df %>% select(Refid, authors), by = "Refid")
#forest_cross1$Country <- cafo_map1_df$country[match(forest_cross1$Refid, cafo_map1_df$Refid)]

#forest_cohort <-  forest_cohort %>% mutate(authors = ifelse(Refid%in%testtimeline$Refid, testtimeline$authors, ""))
#forest_cohort$Country <- testtimeline$country[match(forest_cohort$Refid, testtimeline$Refid)]
forest_cohort$Country <- cafo_map1_df$Country[match(forest_cohort$Refid, cafo_map1_df$Refid)]


#forest_case_1 <-  forest_case_1 %>% mutate(authors = ifelse(Refid%in%testtimeline$Refid, testtimeline$authors, ""))
#forest_case_1$Country <- testtimeline$country[match(forest_case_1$Refid, testtimeline$Refid)]
forest_case_1$Country <- cafo_map1_df$Country[match(forest_case_1$Refid, cafo_map1_df$Refid)]


###with this work only for cross
#forest_sabado <- read_excel("datasets/distiller_cross.xlsx")

forest_sabado <- cross_clean

################
mangos <- forest_cross %>% select(Refid, category)
mangos1 <- forest_cohort %>% select(Refid, category)
mangos2 <- forest_case_1 %>% select(Refid, category)



mangosT <- bind_rows(mangos, mangos1, mangos2)


reyes<- mangosT %>% distinct()
reyes1 <- reyes%>% filter(category=="Lower Respiratory")
reyes2 <- reyes%>% filter(category=="Upper Respiratory")
reyes3 <- reyes%>% filter(category=="Gastrointestinal condition")
reyes4 <- reyes%>% filter(category=="Antimicrobial resistance")
reyes5 <- reyes%>% filter(category=="Infectious conditions")


cafo_map1 <- cafo_map1_df %>%
  mutate(LR = ifelse(Refid %in% reyes1$Refid, "Yes", "No")   ) %>%
  mutate(Gastro = ifelse(Refid %in% reyes3$Refid, "Yes", "No")   )  %>%
  mutate(UR = ifelse(Refid %in% reyes2$Refid, "Yes", "No")   )  %>%
  mutate(Antimicro = ifelse(Refid %in% reyes4$Refid, "Yes", "No")   ) %>%
  mutate(Infectious = ifelse(Refid %in% reyes5$Refid, "Yes", "No")   )





################
#forest_cross_event <- forest_cross %>% filter(event_state == "Event")
#forest_cross_state <- forest_cross %>% filter(event_state == "State")
forest_cross <- forest_cross %>% filter(rare_outcome == "Yes" | health_event=="Yes")
forest_cross1 <- forest_cross1 %>% filter(is.na(Differential_information_bias) & is.na(Differential_information_bias_1_V2))

################# Antimicrobial

#ar_forest <- forest_data_ar() %>% filter(Categorized.class==selected_class())



########## fOR all cross-sectional



rty <-(c("subcategory1","subcategory2", "subcategory3","subcategory4","subcategory5", "subcategory6") %in% names(forest_cross))
forest_cross <-  forest_cross %>% mutate(IDD = c(1:nrow(forest_cross)))
forest_cross <- forest_cross %>% mutate( IDD_2 = paste(forest_cross$IDD, "Cross-sectional" ))

if (sum(rty)==6 ) {
  yis0 <- forest_cross[c(9,13,17,21,25,29)]
  yis <- forest_cross[c(10,14,18,22,26,30)]
  yis1 <- forest_cross[c(11,15,19,23,27,31)]
  yis2 <- forest_cross[c(12,16,20,24,28,32)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cross$outcome, each = 6)
  authors <- rep(forest_cross$authors, each = 6)
  Country <- rep(forest_cross$Country, each = 6)
  mm <- rep(forest_cross$effect_measure, each = 6)
  Exposure.measure <- rep(forest_cross$exposure, each = 6)
  Categorized.class <- rep(forest_cross$category, each = 6)
  IDD <- rep(forest_cross$IDD, each = 6)
  IDD_2 <- rep(forest_cross$IDD_2, each = 6)
  
  up_forest_melo <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_melo1 <- up_forest_melo[complete.cases(up_forest_melo),]
}else if (sum(rty)==5){
  yis0 <- forest_cross[c(9,13,17,21,25)]
  yis <- forest_cross[c(10,14,18,22,26)]
  yis1 <- forest_cross[c(11,15,19,23,27)]
  yis2 <- forest_cross[c(12,16,20,24,28)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cross$outcome, each = 5)
  authors <- rep(forest_cross$authors, each = 5)
  mm <- rep(forest_cross$effect_measure, each = 5)
  Country <- rep(forest_cross$Country, each = 5)
  Exposure.measure <- rep(forest_cross$exposure, each = 5)
  Categorized.class <- rep(forest_cross$category, each = 5)
  IDD <- rep(forest_cross$IDD, each = 5)
  IDD_2 <- rep(forest_cross$IDD_2, each = 5)
  
  up_forest_melo <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_melo1 <- up_forest_melo[complete.cases(up_forest_melo),]
}else if (sum(rty)==4){
  yis0 <- forest_cross[c(9,13,17,21)]
  yis <- forest_cross[c(10,14,18,22)]
  yis1 <- forest_cross[c(11,15,19,23)]
  yis2 <- forest_cross[c(12,16,20,24)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cross$outcome, each = 4)
  authors <- rep(forest_cross$authors, each = 4)
  mm <- rep(forest_cross$effect_measure, each = 4)
  Country <- rep(forest_cross$Country, each = 4)
  Exposure.measure <- rep(forest_cross$exposure, each = 4)
  Categorized.class <- rep(forest_cross$category, each = 4)
  IDD <- rep(forest_cross$IDD, each = 4)
  IDD_2 <- rep(forest_cross$IDD_2, each = 4)
  
  up_forest_melo <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2,authors, Country)
  up_forest_melo1 <- up_forest_melo[complete.cases(up_forest_melo),]
}else if (sum(rty)==3){
  yis0 <- forest_cross[c(9,13,17)]
  yis <- forest_cross[c(10,14,18)]
  yis1 <- forest_cross[c(11,15,19)]
  yis2 <- forest_cross[c(12,16,20)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cross$outcome, each = 3)
  authors <- rep(forest_cross$authors, each = 3)
  mm <- rep(forest_cross$effect_measure, each = 3)
  Country <- rep(forest_cross$Country, each = 3)
  Exposure.measure <- rep(forest_cross$exposure, each = 3)
  Categorized.class <- rep(forest_cross$category, each = 3)
  IDD <- rep(forest_cross$IDD, each = 3)
  IDD_2 <- rep(forest_cross$IDD_2, each = 3)
  
  up_forest_melo <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_melo1 <- up_forest_melo[complete.cases(up_forest_melo),]
}
##############
###### For Health States
##########

rty3 <-(c("subcategory1","subcategory2", "subcategory3","subcategory4","subcategory5", "subcategory6") %in% names(forest_cross1))
forest_cross_state <-  forest_cross1 %>% 
  mutate(IDD = c(1:nrow(forest_cross1)), 
         IDD_2 = paste(IDD, "Cross-sectional" ))


if (sum(rty3)==6 ) {
  yis0 <- forest_cross_state[c(9,13,17,21,25,29)]
  yis <- forest_cross_state[c(10,14,18,22,26,30)]
  yis1 <- forest_cross_state[c(11,15,19,23,27,31)]
  yis2 <- forest_cross_state[c(12,16,20,24,28,32)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cross_state$outcome, each = 6)
  authors <- rep(forest_cross_state$authors, each = 6)
  mm <- rep(forest_cross_state$effect_measure, each = 6)
  Country <- rep(forest_cross_state$Country, each = 6)
  Exposure.measure <- rep(forest_cross_state$exposure, each = 6)
  Categorized.class <- rep(forest_cross_state$category, each = 6)
  IDD <- rep(forest_cross_state$IDD, each = 6)
  IDD_2 <- rep(forest_cross_state$IDD_2, each = 6)
  
  up_forest_state <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_state1 <- up_forest_state[complete.cases(up_forest_state),]
}else if (sum(rty3)==5){
  yis0 <- forest_cross_state[c(9,13,17,21,25)]
  yis <- forest_cross_state[c(10,14,18,22,26)]
  yis1 <- forest_cross_state[c(11,15,19,23,27)]
  yis2 <- forest_cross_state[c(12,16,20,24,28)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cross_state$outcome, each = 5)
  authors <- rep(forest_cross_state$authors, each = 5)
  mm <- rep(forest_cross_state$effect_measure, each = 5)
  Country <- rep(forest_cross_state$Country, each = 5)
  Exposure.measure <- rep(forest_cross_state$exposure, each = 5)
  Categorized.class <- rep(forest_cross_state$category, each = 5)
  IDD <- rep(forest_cross_state$IDD, each = 5)
  IDD_2 <- rep(forest_cross_state$IDD_2, each = 5)
  
  up_forest_state <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_state1 <- up_forest_state[complete.cases(up_forest_state),]
}else if (sum(rty3)==4){
  yis0 <- forest_cross_state[c(9,13,17,21)]
  yis <- forest_cross_state[c(10,14,18,22)]
  yis1 <- forest_cross_state[c(11,15,19,23)]
  yis2 <- forest_cross_state[c(12,16,20,24)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cross_state$outcome, each = 4)
  authors <- rep(forest_cross_state$authors, each = 4)
  mm <- rep(forest_cross_state$effect_measure, each = 4)
  Country <- rep(forest_cross_state$Country, each = 4)
  Exposure.measure <- rep(forest_cross_state$exposure, each = 4)
  Categorized.class <- rep(forest_cross_state$category, each = 4)
  IDD <- rep(forest_cross_state$IDD, each = 4)
  IDD_2 <- rep(forest_cross_state$IDD_2, each = 4)
  
  up_forest_state <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_state1 <- up_forest_state[complete.cases(up_forest_state),]
}else if (sum(rty3)==3){
  yis0 <- forest_cross_state[c(9,13,17)]
  yis <- forest_cross_state[c(10,14,18)]
  yis1 <- forest_cross_state[c(11,15,19)]
  yis2 <- forest_cross_state[c(12,16,20)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cross_state$outcome, each = 3)
  authors <- rep(forest_cross_state$authors, each = 3)
  mm <- rep(forest_cross_state$effect_measure, each = 3)
  Country <- rep(forest_cross_state$Country, each = 3)
  Exposure.measure <- rep(forest_cross_state$exposure, each = 3)
  Categorized.class <- rep(forest_cross_state$category, each = 3)
  IDD <- rep(forest_cross_state$IDD, each = 3)
  IDD_2 <- rep(forest_cross_state$IDD_2, each = 3)
  
  up_forest_state <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_state1 <- up_forest_state[complete.cases(up_forest_state),]
}


############for case-control
rty1 <-(c("subcategory1","subcategory2", "subcategory3","subcategory4","subcategory5", "subcategory6") %in% names(forest_case_1))


forest_case <-  forest_case_1 %>% 
  mutate(IDD = c(1:nrow(forest_case_1)))  %>% 
  mutate( IDD_2 = paste(IDD, "C-C" ))

if (sum(rty1)==6 ) {
  yis0 <- forest_case[c(9,13,17,21,25,29)]
  yis <- forest_case[c(10,14,18,22,26,30)]
  yis1 <- forest_case[c(11,15,19,23,27,31)]
  yis2 <- forest_case[c(12,16,20,24,28,32)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_case$outcome, each = 6)
  authors <- rep(forest_case$authors, each = 6)
  mm <- rep(forest_case$effect_measure, each = 6)
  Country <- rep(forest_case$Country, each = 6)
  Exposure.measure <- rep(forest_case$exposure, each = 6)
  Categorized.class <- rep(forest_case$category, each = 6)
  IDD <- rep(forest_case$IDD, each = 6)
  IDD_2 <- rep(forest_case$IDD_2, each = 6)
  
  up_forest_case <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_case1 <- up_forest_case[complete.cases(up_forest_case),]
}else if (sum(rty1)==5){
  yis0 <- forest_case[c(9,13,17,21,25)]
  yis <- forest_case[c(10,14,18,22,26)]
  yis1 <- forest_case[c(11,15,19,23,27)]
  yis2 <- forest_case[c(12,16,20,24,28)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_case$outcome, each = 5)
  authors <- rep(forest_case$authors, each = 5)
  mm <- rep(forest_case$effect_measure, each = 5)
  Country <- rep(forest_case$Country, each = 5)
  Exposure.measure <- rep(forest_case$exposure, each = 5)
  Categorized.class <- rep(forest_case$category, each = 5)
  IDD <- rep(forest_case$IDD, each = 5)
  IDD_2 <- rep(forest_case$IDD_2, each = 5)
  
  up_forest_case <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_case1 <- up_forest_case[complete.cases(up_forest_case),]
}else if (sum(rty1)==4){
  yis0 <- forest_case[c(9,13,17,21)]
  yis <- forest_case[c(10,14,18,22)]
  yis1 <- forest_case[c(11,15,19,23)]
  yis2 <- forest_case[c(12,16,20,24)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_case$outcome, each = 4)
  authors <- rep(forest_case$authors, each = 4)
  mm <- rep(forest_case$effect_measure, each = 4)
  Country <- rep(forest_case$Country, each = 4)
  
  Exposure.measure <- rep(forest_case$exposure, each = 4)
  Categorized.class <- rep(forest_case$category, each = 4)
  IDD <- rep(forest_case$IDD, each = 4)
  IDD_2 <- rep(forest_case$IDD_2, each = 4)
  
  up_forest_case <- data.frame(
    IDD, IDD_2, Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_case1 <- up_forest_case[complete.cases(up_forest_case),]
}else if (sum(rty1)==3){
  yis0 <- forest_case[c(9,13,17)]
  yis <- forest_case[c(10,14,18)]
  yis1 <- forest_case[c(11,15,19)]
  yis2 <- forest_case[c(12,16,20)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_case$outcome, each = 3)
  authors <- rep(forest_case$authors, each = 3)
  mm <- rep(forest_case$effect_measure, each = 3)
  Country <- rep(forest_case$Country, each = 3)
  Exposure.measure <- rep(forest_case$exposure, each = 3)
  Categorized.class <- rep(forest_case$category, each = 3)
  IDD <- rep(forest_case$IDD, each = 3)
  IDD_2 <- rep(forest_case$IDD_2, each = 3)
  
  up_forest_case <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_case1 <- up_forest_case[complete.cases(up_forest_case),]
}

##########

############for cohort
rty2 <-(c("subcategory1","subcategory2", "subcategory3","subcategory4","subcategory5", "subcategory6") %in% names(forest_cohort))

forest_cohort <-  forest_cohort %>% 
  mutate(IDD = c(1:nrow(forest_cohort))) %>% 
  mutate( IDD_2 = paste(IDD, "Cohort" ))

if (sum(rty2)==6 ) {
  yis0 <- forest_cohort[c(9,13, 17, 21, 25, 29)]
  yis <- forest_cohort[c(10, 14, 18, 22, 26, 30)]
  yis1 <- forest_cohort[c(11, 15, 19, 23, 27, 31)]
  yis2 <- forest_cohort[c(12, 16, 20, 24,28, 32)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cohort$outcome, each = 6)
  authors <- rep(forest_cohort$authors, each = 6)
  mm <- rep(forest_cohort$effect_measure, each = 6)
  Country <- rep(forest_cohort$Country, each = 6)
  Exposure.measure <- rep(forest_cohort$exposure, each = 6)
  Categorized.class <- rep(forest_cohort$category, each = 6)
  IDD <- rep(forest_cohort$IDD, each = 6)
  IDD_2 <- rep(forest_cohort$IDD_2, each = 6)
  
  up_forest_cohort <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_cohort1 <- up_forest_cohort[complete.cases(up_forest_cohort),]
}else if (sum(rty2)==5){
  yis0 <- forest_cohort[c(9, 13, 17, 21, 25)] 
  yis <- forest_cohort[c(10, 14, 18, 22, 26)]  
  yis1 <- forest_cohort[c(11, 15, 19, 23, 27)] 
  yis2 <- forest_cohort[c(12, 16, 20, 24, 28)]  
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cohort$outcome, each = 5)
  authors <- rep(forest_cohort$authors, each = 5)
  mm <- rep(forest_cohort$effect_measure, each = 5)
  Country <- rep(forest_cohort$Country, each = 5)
  Exposure.measure <- rep(forest_cohort$exposure, each = 5)
  Categorized.class <- rep(forest_cohort$category, each = 5)
  IDD <- rep(forest_cohort$IDD, each = 5)
  IDD_2 <- rep(forest_cohort$IDD_2, each = 5)
  
  up_forest_cohort <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_cohort1 <- up_forest_cohort[complete.cases(up_forest_cohort),]
}else if (sum(rty2)==4){
  yis0 <- forest_cohort[c(9, 13, 17, 21)]
  yis <- forest_cohort[c(10, 14, 18, 22)]
  yis1 <- forest_cohort[c(11, 15, 19, 23)]
  yis2 <- forest_cohort[c(12, 16, 20, 24)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cohort$outcome, each = 4)
  authors <- rep(forest_cohort$authors, each = 4)
  mm <- rep(forest_cohort$effect_measure, each = 4)
  Country <- rep(forest_cohort$Country, each = 4)
  Exposure.measure <- rep(forest_cohort$exposure, each = 4)
  Categorized.class <- rep(forest_cohort$category, each = 4)
  IDD <- rep(forest_cohort$IDD, each = 4)
  IDD_2 <- rep(forest_cohort$IDD_2, each = 4)
  
  up_forest_cohort <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_cohort1 <- up_forest_cohort[complete.cases(up_forest_cohort),]
}else if (sum(rty2)==3){
  yis0 <- forest_cohort[c(9, 13, 17)]
  yis <- forest_cohort[c(10, 14, 18)]
  yis1 <- forest_cohort[c(11, 15, 19)]
  yis2 <- forest_cohort[c(12, 16, 20)]
  tinto0 <- data.frame(Subcategory=c(t((yis0))))
  tinto <- data.frame(yi=c(t((yis))))
  tinto1 <- data.frame(upperci=c(t((yis1))))
  tinto2 <- data.frame(lowerci=c(t((yis2))))
  
  Outcome.variable <- rep(forest_cohort$outcome, each = 3)
  authors <- rep(forest_cohort$authors, each = 3)
  mm <- rep(forest_cohort$effect_measure, each = 3)
  Country <- rep(forest_cohort$Country, each = 3)
  Exposure.measure <- rep(forest_cohort$exposure, each = 3)
  Categorized.class <- rep(forest_cohort$category, each = 3)
  IDD <- rep(forest_cohort$IDD, each = 3)
  IDD_2 <- rep(forest_cohort$IDD_2, each = 3)
  
  up_forest_cohort <- data.frame(
    IDD, IDD_2,Outcome.variable, Categorized.class,Exposure.measure,mm,tinto0, tinto, tinto1, tinto2, authors, Country)
  up_forest_cohort1 <- up_forest_cohort[complete.cases(up_forest_cohort),]
}



#up_forest_cohort1$yi=as.numeric(levels(up_forest_cohort1$yi))[up_forest_cohort1$yi]
#up_forest_case1$yi=as.numeric(levels(up_forest_case1$yi))[up_forest_case1$yi]
#up_forest_melo1$yi=as.numeric(levels(up_forest_melo1$yi))[up_forest_melo1$yi]

forest_joint <-  bind_rows(up_forest_cohort1,up_forest_case1, up_forest_melo1)
forest_joint[,8]=as.numeric(forest_joint[,8])
forest_joint[,9]=as.numeric(forest_joint[,9])
forest_joint[,10]=as.numeric(forest_joint[,10])
#####for state
up_forest_state1[,8]=as.numeric(up_forest_state1[,8])
up_forest_state1[,9]=as.numeric(up_forest_state1[,9])
up_forest_state1[,10]=as.numeric(up_forest_state1[,10])

###### Reduce label size on the forest plot
forest_joint$short <- ifelse(is.na(word(forest_joint$Outcome.variable, 1, 4)), forest_joint$Outcome.variable, word(forest_joint$Outcome.variable, 1, 4))
forest_joint$numberofwords <- sapply(strsplit(forest_joint$Outcome.variable, " "), length)
forest_joint$short <- ifelse(forest_joint$numberofwords>=5, paste(forest_joint$short, "..." ), forest_joint$short)


forest_joint$shortexpo <- ifelse(is.na(word(forest_joint$Exposure.measure, 1, 5)), forest_joint$Exposure.measure, word(forest_joint$Exposure.measure, 1, 5))
forest_joint$numberofwordsexpo <- sapply(strsplit(forest_joint$Exposure.measure, " "), length)
forest_joint$shortexpo <- ifelse(forest_joint$numberofwords>=6, paste(forest_joint$shortexpo, "..." ), forest_joint$shortexpo)

forest_joint$shortsubcat <- ifelse(is.na(word(forest_joint$Subcategory, 1, 5)), forest_joint$Subcategory, word(forest_joint$Subcategory, 1, 5))
forest_joint$numberofwordssubcat <- sapply(strsplit(forest_joint$Subcategory, " "), length)
forest_joint$shortsubcat <- ifelse(forest_joint$numberofwordssubcat>=5, paste(forest_joint$shortsubcat, "..." ), forest_joint$shortsubcat)

forest_joint <- forest_joint %>% mutate(inter_95 = ifelse(is.na(lowerci), paste(forest_joint$yi), paste(forest_joint$yi,"[",forest_joint$lowerci,",", forest_joint$upperci,"]")))
######
up_forest_state1$short <- ifelse(is.na(word(up_forest_state1$Outcome.variable, 1, 4)), up_forest_state1$Outcome.variable, word(up_forest_state1$Outcome.variable, 1, 4))
up_forest_state1$numberofwords <- sapply(strsplit(up_forest_state1$Outcome.variable, " "), length)
up_forest_state1$short <- ifelse(up_forest_state1$numberofwords>=5, paste(up_forest_state1$short, "..." ), up_forest_state1$short)

up_forest_state1$shortsubcat <- ifelse(is.na(word(up_forest_state1$Subcategory, 1, 4)), up_forest_state1$Subcategory, word(up_forest_state1$Subcategory, 1, 4))
up_forest_state1$numberofwordssubcat <- sapply(strsplit(up_forest_state1$Subcategory, " "), length)
up_forest_state1$shortsubcat <- ifelse(up_forest_state1$numberofwordssubcat>=4, paste(up_forest_state1$shortsubcat, "..." ), up_forest_state1$shortsubcat)


up_forest_state1$shortexpo <- ifelse(is.na(word(up_forest_state1$Exposure.measure, 1, 5)), up_forest_state1$Exposure.measure, word(up_forest_state1$Exposure.measure, 1, 5))
up_forest_state1$numberofwordsexpo <- sapply(strsplit(up_forest_state1$Exposure.measure, " "), length)
up_forest_state1$shortexpo <- ifelse(up_forest_state1$numberofwords>=6, paste(up_forest_state1$shortexpo, "..." ), up_forest_state1$shortexpo)

up_forest_state1 <- up_forest_state1 %>% mutate(inter_95 = ifelse(is.na(lowerci), paste(up_forest_state1$yi), paste(up_forest_state1$yi,"[",up_forest_state1$lowerci,",", up_forest_state1$upperci,"]")))






##########
ar_forest <- forest_joint %>% filter(Categorized.class=="Antimicrobial resistance")
ar_forest$effect_z <- ar_forest$mm
ar_forest$effect_z[ar_forest$effect_z == 'PR'] <- 'Incidence Density Ratio (IDR)'
ar_forest$effect_z[ar_forest$effect_z == 'OR'] <- 'Incidence Odds Ratio (OR)'
ar_forest$effect_z[ar_forest$effect_z == 'PR - RR - HR'] <- 'Incidence Odds Ratio (OR)'

# for lower respiratory
low_forest <- forest_joint %>% filter(Categorized.class=="Lower Respiratory")
low_forest$effect_z <- low_forest$mm
low_forest$effect_z[low_forest$effect_z == 'PR'] <- 'Incidence Density Ratio (IDR)'
low_forest$effect_z[low_forest$effect_z == 'OR'] <- 'Incidence Odds Ratio (OR)'
low_forest$effect_z[low_forest$effect_z == 'PR - RR - HR'] <- 'Incidence Odds Ratio (OR)'

# for lower respiratory states
low_forest_state <- up_forest_state1 %>% filter(Categorized.class=="Lower Respiratory")
low_forest_state$effect_z <- low_forest_state$mm
low_forest_state$effect_z[low_forest_state$effect_z == 'PR'] <- 'Incidence Density Ratio (IDR)'
low_forest_state$effect_z[low_forest_state$effect_z == 'OR'] <- 'Incidence Odds Ratio (OR)'
low_forest_state$effect_z[low_forest_state$effect_z == 'PR - RR - HR'] <- 'Incidence Odds Ratio (OR)'

# for upper respiratory
up_forest <- forest_joint %>% filter(Categorized.class=="Upper Respiratory")
up_forest$effect_z <- up_forest$mm
up_forest$effect_z[up_forest$effect_z == 'PR'] <- 'Incidence Density Ratio (IDR)'
up_forest$effect_z[up_forest$effect_z == 'OR'] <- 'Incidence Odds Ratio (OR)'
up_forest$effect_z[up_forest$effect_z == 'PR - RR - HR'] <- 'Incidence Odds Ratio (OR)'

# for IC respiratory
ic_forest <- forest_joint %>% filter(Categorized.class=="Infectious conditions")
ic_forest$effect_z <- ic_forest$mm
ic_forest$effect_z[ic_forest$effect_z == 'PR'] <- 'Incidence Density Ratio (IDR)'
ic_forest$effect_z[ic_forest$effect_z == 'OR'] <- 'Incidence Odds Ratio (OR)'
ic_forest$effect_z[ic_forest$effect_z == 'PR - RR - HR'] <- 'Incidence Odds Ratio (OR)'

# for GI respiratory
gi_forest <- forest_joint %>% filter(Categorized.class=="Gastrointestinal condition")
gi_forest$effect_z <- gi_forest$mm
gi_forest$effect_z[gi_forest$effect_z == 'PR'] <- 'Incidence Density Ratio (IDR)'
gi_forest$effect_z[gi_forest$effect_z == 'OR'] <- 'Incidence Odds Ratio (OR)'
gi_forest$effect_z[gi_forest$effect_z == 'PR - RR - HR'] <- 'Incidence Odds Ratio (OR)'


#up_forest_melo$id2 <- c(1:(nrow(up_forest_melo)))
#up_forest_melo[nrow(up_forest_melo)+1,1] <- "OUTCOME"
#up_forest_melo[g+1,2] <- "CATEGORY"
#up_forest_melo[g+1,3] <- "EXPOSURE"
#up_forest_melo[g+1,5] <- "SUBCATEGORY"
#up_forest_melo[g+1,6] <- "EFFECT MEASURE"
#########
#forest123 <- read_excel("datasets/forest123.xlsx")
#forest <- forest %>% mutate(inter = ifelse(is.na(lowerci), yi, paste(forest$yi,"[",forest$lowerci, ",", forest$upperci,"]")), Reference = paste(forest$id, ".", forest$study))
forest <- forest %>% mutate(inter = ifelse(is.na(lowerci), paste("Effect size =",forest$yi,"\n Outcome:",forest$Outcome.variable), paste("Effect size (95% CI) =",forest$yi,"[",forest$lowerci, ",", forest$upperci,"]","\n Outcome:",forest$Outcome.variable)), Reference = paste(forest123$study, "(",forest123$id, ")"))
#forest <- forest %>% mutate(inter1 = ifelse(is.na(lowerci), paste("Effect size =",forest$yi,"\n Outcome:",forest$Outcome.variable), paste("Effect size (95% CI) =",forest$yi,"[",forest$lowerci, ",", forest$upperci,"]","\n Outcome:",forest$Outcome.variable)))
forest <- forest %>% mutate(inter1 = ifelse(is.na(lowerci), paste(forest$yi), paste(forest$yi,"[",forest$lowerci,",", forest$upperci,"]")))
#forest123 <- forest123 %>% mutate( Reference = paste(forest123$id, ".", forest123$study))
forest123 <- forest123 %>% mutate( Reference = paste(forest123$study, "(",forest123$id, ")" ))
#inclusion123 <- readRDS("inclusion_cache.rds")
#### change names
forest$effect_z <- forest$mm
forest$effect_z[forest$effect_z == 'OR'] <- 'Odds Ratio (OR)'
forest$effect_z[forest$effect_z == 'PR'] <- 'Prevalence Ratio (PR)'
forest$effect_z[forest$effect_z == 'beta'] <- 'beta coefficient of the variable'
forest$effect_z[forest$effect_z == 'beta p value'] <- 'p value of the beta coefficient of the variable'
forest$effect_z[forest$effect_z == 'OR p value'] <- 'p value of the Odds Ratio'
#### change names
#forest_joint$effect_z[forest_joint$effect_z == 'OR'] <- 'Odds Ratio (OR)'
#forest$effect_z[forest$effect_z == 'PR'] <- 'Prevalence Ratio (PR)'

forest_joint$effect_z <- forest_joint$mm
up_forest_state1$effect_z_state <- up_forest_state1$mm
forest_joint$effect_z[forest_joint$effect_z == 'PR'] <- 'Incidence Density Ratio (IDR)'
forest_joint$effect_z[forest_joint$effect_z == 'OR'] <- 'Incidence Odds Ratio (OR)'


up_forest_state1$effect_z_state[up_forest_state1$effect_z_state == 'PR'] <- 'Prevalence Ratio (PR)'
up_forest_state1$effect_z_state[up_forest_state1$effect_z_state == 'OR'] <- 'Prevalence Odds Ratio (OR)'


#forest_cross_event$effect_z[forest_cross_event$effect_z == 'OR'] <- 'Odds Ratio (OR)'
#forest_cross_event$effect_z[forest_cross_event$effect_z == 'PR'] <- 'Prevalence Ratio (PR)'
#forest_cross_event$effect_z[forest$effect_z == 'beta'] <- 'beta coefficient of the variable'
#forest_cross_event$effect_z[forest$effect_z == 'beta p value'] <- 'p value of the beta coefficient of the variable'
#forest_cross_event$effect_z[forest$effect_z == 'OR p value'] <- 'p value of the Odds Ratio'




###### alternative dataset for map
#cafo_map <- readxl::read_xlsx("datasets/geoloction_cafos.xlsx")

#names(cafo_map)[9] <- 'Country'
#cafoo_map <- cafo_map %>% group_by(Country) %>% 
#  summarise(`Number_of_Studies` = n())%>%
#  mutate(long = ifelse(Country == "Germany", 10.44768,
#                       ifelse(Country == "Netherlands", 5.2913,ifelse(Country == "USA", -98.5795, ifelse(Country=="Norway", 8.468946, ifelse(Country=="Mexico", -102.552784, ifelse(Country=="Canada", -106.346771, ifelse(Country=="UK", -3.435973, 2.213749))) ))))) %>% 
#  mutate(lat = ifelse(Country == "Germany", 51.165691,
#                      ifelse(Country == "Netherlands", 52.132633,ifelse(Country == "USA", 37.09024, ifelse(Country=="Norway", 60.472024, ifelse(Country=="Mexico", 23.634501, ifelse(Country=="Canada", 56.130366, ifelse(Country=="UK", 55.378051, 46.227638))) )))))

















color_table <- tibble(
  Bias = c("High", "Likely High", "Likely Low", "Low", "Uncertain"),
  #Color = c(RColorBrewer::brewer.pal(4, "RdYlGn"), "#bdbdbd")
  #Color = c("red", "salmon","lightgreen","forestgreen" , "wheat")
  Color = c("forestgreen", "lightgreen","salmon","red" , "wheat")
)
pal <- color_table$Color
names(pal) <- color_table$Bias


