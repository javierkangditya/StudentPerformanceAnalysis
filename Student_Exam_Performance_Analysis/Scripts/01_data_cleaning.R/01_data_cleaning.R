# ============================================
# 01_data_cleaning.R
# Purpose: Clean raw student performance data
# ============================================

# Load required libraries
library(readxl)
library(tidyverse)
library(openxlsx)

# --------------------------------------------
# 1. Load raw dataset
# --------------------------------------------

data <- read_excel("Data/Raw/StudentPerformanceFactors.xlsx")

# Preview dataset
glimpse(data)
head(data)

# --------------------------------------------
# 2. Data Cleaning
# --------------------------------------------

# Remove duplicate rows
data <- data %>% distinct()

# Remove rows with missing values
data <- data %>% drop_na()

# Convert Yes/No columns to numeric (1 = Yes, 0 = No)
yesno_cols <- sapply(data, function(x) all(x %in% c("Yes", "No")))
data[, yesno_cols] <- lapply(data[, yesno_cols], function(x) ifelse(x == "Yes", 1, 0))

# Check cleaned dataset
glimpse(data)
summary(data)

# --------------------------------------------
# 3. Save processed dataset
# --------------------------------------------

# Create Processed folder if it does not exist
dir.create("Data/Processed", showWarnings = FALSE)

# Save cleaned dataset
write.xlsx(data, "Data/Processed/StudentPerformanceFactors_clean.xlsx")

# --------------------------------------------
# End of script
# --------------------------------------------