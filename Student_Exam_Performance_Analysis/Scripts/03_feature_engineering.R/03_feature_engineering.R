# =============================================
# 03_Feature_Engineering.R
# Feature Engineering
# =============================================
# Tasks:
# 1. Scaling numeric features
# 2. Creating interaction features
# 3. Checking correlation of interaction features with Exam_Score
# 4. Dropping irrelevant interaction features
# 5. Saving processed dataset ready for modeling
# =============================================

library(dplyr)
library(ggplot2)

# -----------------------------
# 1. Copy original data
# -----------------------------
data_fe <- data
# Keep original cleaned dataset intact

# -----------------------------
# 2. Scale numeric features
# -----------------------------
numeric_cols <- c("Hours_Studied", "Sleep_Hours", "Previous_Scores", "Attendance")
data_fe[numeric_cols] <- scale(data_fe[numeric_cols])
# Standardize numeric features so mean=0 and sd=1

# -----------------------------
# 3. Create interaction features
# -----------------------------
data_fe <- data_fe %>%
  mutate(
    Study_Attendance = Hours_Studied * Attendance,
    Sleep_Study = Sleep_Hours * Hours_Studied
  )
# Interaction features capture combined effects of study, sleep, and attendance

# -----------------------------
# 4. Save feature-engineered dataset
# -----------------------------
write.csv(data_fe,
          "Data/Processed/StudentPerformanceFactors_feature_engineered.csv",
          row.names = FALSE)
# Save dataset after feature engineering for initial analysis

# -----------------------------
# 5. Interaction Features vs Exam Score
# -----------------------------
interaction_features <- c("Study_Attendance", "Sleep_Study")

# Ensure output folder exists
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)

for(feat in interaction_features){
  
  # Calculate Pearson correlation
  cor_val <- cor(data_fe[[feat]], data_fe$Exam_Score, use = "complete.obs")
  message(paste("Correlation between", feat, "and Exam_Score:", round(cor_val, 3)))
  
  # Scatter plot with regression line
  p <- ggplot(data_fe, aes_string(x = feat, y = "Exam_Score")) +
    geom_point(alpha = 0.5, color = "steelblue") +
    geom_smooth(method = "lm", color = "red", se = FALSE) +
    theme_minimal() +
    labs(
      title = paste(feat, "vs Exam Score (Correlation:", round(cor_val, 2), ")"),
      x = feat,
      y = "Exam Score"
    )
  
  # Save plot
  plot_file <- paste0("output/figures/", tolower(feat), "_vs_exam_score.png")
  ggsave(plot_file, plot = p, width = 6, height = 4)
  
  # Print plot
  print(p)
}

# -----------------------------
# 6. Drop irrelevant interaction features
# -----------------------------
# Study_Attendance and Sleep_Study show near-zero correlation
# with Exam_Score and are removed for modeling
data_fe <- data_fe %>%
  select(-c(Study_Attendance, Sleep_Study))

# Check updated dataset
glimpse(data_fe)

# Save final cleaned & feature-engineered dataset
write.csv(data_fe,
          "Data/Processed/StudentPerformanceFactors_feature_engineered_cleaned.csv",
          row.names = FALSE)
# Final dataset ready for modeling