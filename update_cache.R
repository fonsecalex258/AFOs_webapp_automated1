# ==============================
# RUN EVERYTHING
# ==============================

source("cache_functions.R")

library(readxl)
library(dplyr)


cat("Getting token...\n")
token <- get_distiller_token()





#inclusion2 <- get_inclusion_report(token)


# INCLUDED
#cat("Updating INCLUDED...\n")
### inc_raw <- get_saved_report(saved_report_id_included, project_id, token)
### inc_df  <- extract_included_table(inc_raw)
### saveRDS(inc_df, "included_cache.rds")
# INCLUDED (FULL DATASET – 28 COLUMNS)

cat("Updating INCLUDED...\n")

inc_raw <- get_saved_report(saved_report_id_included, project_id, token)

included_full <- extract_included_table_full(inc_raw)

saveRDS(included_full, "included_cache_1.rds")

cat("✅ INCLUDED UPDATED:", nrow(included_full), "rows,", ncol(included_full), "cols\n")


# LIGHT dataset (for tables/UI)
included_light <- included_full %>%
  rename(Country = What.is.the.location.of.the.study.population..country..) %>%
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

saveRDS(included_light, "included_cache_2.rds")


#cat("Updating INCLUDED...\n")

#inc_raw <- get_saved_report(saved_report_id_included, project_id, token)

#included_df1 <- extract_included_table_clean(inc_raw)

#saveRDS(included_df1, "included_cache_1.rds")

#cat("✅ INCLUDED:", nrow(included_df), "rows,", ncol(included_df), "cols\n")
# ==============================
# CROSS (FOREST DATA)
# ==============================

cat("Updating CROSS DATA...\n")

# 1. Load template (this defines structure)
template <- readxl::read_excel("datasets/distiller_cross.xlsx")
expected_cols <- names(template)

# 2. Get raw data from Distiller
cross_raw <- get_saved_report(
  saved_report_id = 6019,
  project_id = project_id,
  token = token
)

# 3. Extract
df <- extract_cross_table(cross_raw)

# 4. Clean names to match Excel
names(df) <- make.names(names(df), unique = TRUE)

# 5. ADD missing columns (CRITICAL STEP)
missing_cols <- setdiff(expected_cols, names(df))

for(col in missing_cols){
  df[[col]] <- NA_character_
}

# 6. (Optional but very useful) detect unexpected columns
extra_cols <- setdiff(names(df), expected_cols)
if(length(extra_cols) > 0){
  message("⚠️ Extra columns from API not in template: ", paste(extra_cols, collapse = ", "))
}

# 7. Keep ONLY template columns in correct order
df <- df[, expected_cols]

# 8. Match column types with template (prevents Shiny bugs)
for(col in expected_cols){
  class(df[[col]]) <- class(template[[col]])
}

# 9. Save
saveRDS(df, "cross_base_cache.rds")

cat("✅ CROSS DATA UPDATED: ", nrow(df), " rows\n")

# ==============================
# CASE-CONTROL CLEAN DATA
# ==============================

cat("Updating CASE-CONTROL DATA...\n")

# 1. Load template (defines structure)
template_case <- readxl::read_excel("datasets/distiller_casecontrol.xlsx")
expected_cols_case <- names(template_case)

# 2. Get raw data from Distiller
case_raw <- get_saved_report(
  saved_report_id = 6021,
  project_id = project_id,
  token = token
)

# 3. Extract
df_case <- extract_casecontrol_table(case_raw)

# 4. Clean names (match Excel structure)
names(df_case) <- make.names(names(df_case), unique = TRUE)

# 5. Add missing columns (CRITICAL)
missing_cols <- setdiff(expected_cols_case, names(df_case))

for(col in missing_cols){
  df_case[[col]] <- NA_character_
}

# 6. Warn if API has extra columns
extra_cols <- setdiff(names(df_case), expected_cols_case)
if(length(extra_cols) > 0){
  message("⚠️ Extra columns (case-control): ", paste(extra_cols, collapse = ", "))
}

# 7. Keep ONLY template columns in correct order
df_case <- df_case[, expected_cols_case]

# 8. Match types with template (prevents Shiny errors)
for(col in expected_cols_case){
  class(df_case[[col]]) <- class(template_case[[col]])
}

# 9. Save cache
saveRDS(df_case, "forest_case_cache.rds")

cat("✅ CASE-CONTROL DATA UPDATED: ", nrow(df_case), " rows\n")


# ==============================
# COHORT CLEAN DATA
# ==============================

cat("Updating COHORT DATA...\n")

# 1. Load template (defines structure)
template_cohort <- readxl::read_excel("datasets/distiller_cohort.xlsx")
expected_cols_cohort <- names(template_cohort)

# 2. Get raw data from Distiller
cohort_raw <- get_saved_report(
  saved_report_id = 6023,
  project_id = project_id,
  token = token
)

# 3. Extract
df_cohort <- extract_cohort_table(cohort_raw)

# 4. Clean names (match Excel structure)
names(df_cohort) <- make.names(names(df_cohort), unique = TRUE)

# 5. Add missing columns (CRITICAL)
missing_cols <- setdiff(expected_cols_cohort, names(df_cohort))

for(col in missing_cols){
  df_cohort[[col]] <- NA_character_
}

# 6. Warn if API has extra columns
extra_cols <- setdiff(names(df_cohort), expected_cols_cohort)
if(length(extra_cols) > 0){
  message("⚠️ Extra columns (cohort): ", paste(extra_cols, collapse = ", "))
}

# 7. Keep ONLY template columns in correct order
df_cohort <- df_cohort[, expected_cols_cohort]

# 8. Match types with template (prevents Shiny errors)
for(col in expected_cols_cohort){
  class(df_cohort[[col]]) <- class(template_cohort[[col]])
}

# 9. Save cache
saveRDS(df_cohort, "forest_cohort_cache.rds")

cat("✅ COHORT DATA UPDATED: ", nrow(df_cohort), " rows\n")



# EXCLUDED
#cat("Updating EXCLUDED...\n")
exc_raw <- get_saved_report(saved_report_id_excluded, project_id, token)
exc_df  <- extract_excluded_table(exc_raw)
exc_df  <- extract_exclusion_reason(exc_df)
saveRDS(exc_df, "excluded_cache.rds")

# PRISMA
#cat("Updating PRISMA...\n")
#refs_df <- get_all_references(project_id, token)
#saveRDS(refs_df, "refs_cache.rds")



cat("\n✅ ALL CACHES UPDATED SUCCESSFULLY\n")
