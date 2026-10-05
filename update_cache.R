source("cache_functions.R")

library(readxl)
library(dplyr)
library(jsonlite)

# ==============================
# DEFINE UPDATE VERSION
# ==============================

# Example:
# "2026_03_31"

cache_version <- format(Sys.Date(), "%Y_%m_%d")

# Create versioned cache directory
cache_dir <- file.path("cache", cache_version)

if(!dir.exists(cache_dir)){
  dir.create(cache_dir, recursive = TRUE)
}

cat("=====================================\n")
cat("Updating cache version:", cache_version, "\n")
cat("Cache directory:", cache_dir, "\n")
cat("=====================================\n")

# ==============================
# GET TOKEN
# ==============================

cat("Getting token...\n")
cat("Enter your DistillerSR credentials when prompted.\n")
token <- get_distiller_token()

# ==============================
# INCLUDED
# ==============================

cat("Updating INCLUDED...\n")

inc_raw <- get_saved_report(
  saved_report_id_included,
  project_id,
  token
)

included_full <- extract_included_table_full(inc_raw)

saveRDS(
  included_full,
  file.path(cache_dir, "included_cache_1.rds")
)

cat("✅ INCLUDED UPDATED:",
    nrow(included_full),
    "rows,",
    ncol(included_full),
    "cols\n")

# LIGHT dataset
included_light <- included_full %>%
  rename(
    Country = What.is.the.location.of.the.study.population..country..
  ) %>%
  select(
    Refid,
    Author,
    Title,
    DOI,
    ISSN,
    Journal,
    Year,
    Country
  )

saveRDS(
  included_light,
  file.path(cache_dir, "included_cache_2.rds")
)

# ==============================
# CROSS (FOREST DATA)
# ==============================

cat("Updating CROSS DATA...\n")

template <- read_excel("datasets/distiller_cross.xlsx")
expected_cols <- names(template)

cross_raw <- get_saved_report(
  saved_report_id = 6019,
  project_id = project_id,
  token = token
)

df <- extract_cross_table(cross_raw)

names(df) <- make.names(names(df), unique = TRUE)

missing_cols <- setdiff(expected_cols, names(df))

for(col in missing_cols){
  df[[col]] <- NA_character_
}

extra_cols <- setdiff(names(df), expected_cols)

if(length(extra_cols) > 0){
  message(
    "⚠️ Extra columns from API not in template: ",
    paste(extra_cols, collapse = ", ")
  )
}

df <- df[, expected_cols]

for(col in expected_cols){
  class(df[[col]]) <- class(template[[col]])
}

saveRDS(
  df,
  file.path(cache_dir, "cross_base_cache.rds")
)

cat("✅ CROSS DATA UPDATED:",
    nrow(df),
    "rows\n")

# ==============================
# CASE-CONTROL DATA
# ==============================

cat("Updating CASE-CONTROL DATA...\n")

template_case <- read_excel(
  "datasets/distiller_casecontrol.xlsx"
)

expected_cols_case <- names(template_case)

case_raw <- get_saved_report(
  saved_report_id = 6021,
  project_id = project_id,
  token = token
)

df_case <- extract_casecontrol_table(case_raw)

names(df_case) <- make.names(
  names(df_case),
  unique = TRUE
)

missing_cols <- setdiff(
  expected_cols_case,
  names(df_case)
)

for(col in missing_cols){
  df_case[[col]] <- NA_character_
}

extra_cols <- setdiff(
  names(df_case),
  expected_cols_case
)

if(length(extra_cols) > 0){
  message(
    "⚠️ Extra columns (case-control): ",
    paste(extra_cols, collapse = ", ")
  )
}

df_case <- df_case[, expected_cols_case]

for(col in expected_cols_case){
  class(df_case[[col]]) <- class(template_case[[col]])
}

saveRDS(
  df_case,
  file.path(cache_dir, "forest_case_cache.rds")
)

cat("✅ CASE-CONTROL DATA UPDATED:",
    nrow(df_case),
    "rows\n")

# ==============================
# COHORT DATA
# ==============================

cat("Updating COHORT DATA...\n")

template_cohort <- read_excel(
  "datasets/distiller_cohort.xlsx"
)

expected_cols_cohort <- names(template_cohort)

cohort_raw <- get_saved_report(
  saved_report_id = 6023,
  project_id = project_id,
  token = token
)

df_cohort <- extract_cohort_table(cohort_raw)

names(df_cohort) <- make.names(
  names(df_cohort),
  unique = TRUE
)

missing_cols <- setdiff(
  expected_cols_cohort,
  names(df_cohort)
)

for(col in missing_cols){
  df_cohort[[col]] <- NA_character_
}

extra_cols <- setdiff(
  names(df_cohort),
  expected_cols_cohort
)

if(length(extra_cols) > 0){
  message(
    "⚠️ Extra columns (cohort): ",
    paste(extra_cols, collapse = ", ")
  )
}

df_cohort <- df_cohort[, expected_cols_cohort]

for(col in expected_cols_cohort){
  class(df_cohort[[col]]) <- class(template_cohort[[col]])
}

saveRDS(
  df_cohort,
  file.path(cache_dir, "forest_cohort_cache.rds")
)

cat("✅ COHORT DATA UPDATED:",
    nrow(df_cohort),
    "rows\n")

# ==============================
# EXCLUDED
# ==============================

cat("Updating EXCLUDED...\n")

exc_raw <- get_saved_report(
  saved_report_id_excluded,
  project_id,
  token
)

exc_df <- extract_excluded_table(exc_raw)

exc_df <- extract_exclusion_reason(exc_df)

saveRDS(
  exc_df,
  file.path(cache_dir, "excluded_cache.rds")
)

# ==============================
# PRISMA / REFERENCES
# ==============================

cat("Updating PRISMA...\n")

refs_df <- get_all_references(
  project_id,
  token
)

saveRDS(
  refs_df,
  file.path(cache_dir, "refs_cache.rds")
)

# ==============================
# UPDATE METADATA
# ==============================

metadata <- list(
  cache_version = cache_version,
  update_date = as.character(Sys.Date()),
  included_records = nrow(included_full),
  cross_records = nrow(df),
  casecontrol_records = nrow(df_case),
  cohort_records = nrow(df_cohort),
  total_references = nrow(refs_df)
)

write_json(
  metadata,
  path = file.path(cache_dir, "metadata.json"),
  pretty = TRUE,
  auto_unbox = TRUE
)

# ==============================
# UPDATE "LATEST" POINTER
# ==============================

writeLines(
  cache_version,
  con = "cache/latest_version.txt"
)

# ==============================
# FINISHED
# ==============================

cat("\n=====================================\n")
cat("✅ ALL CACHES UPDATED SUCCESSFULLY\n")
cat("Version:", cache_version, "\n")
cat("Location:", cache_dir, "\n")
cat("=====================================\n")