# =====================================
# 02_EDA.R
# Exploratory Data Analysis (EDA)
# =====================================

library(ggplot2)
library(dplyr)
library(corrplot)
library(openxlsx)

# -----------------------------
# Create folders for output
# -----------------------------
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)

# -----------------------------
# 1. Summary Statistics
# -----------------------------
summary_table <- data.frame(summary(data))

# Save summary table to CSV
write.csv(summary_table, "output/tables/summary_stats.csv", row.names = FALSE)
# This table includes min, max, mean, median, and quartiles for numeric features

# Print to console
print(summary_table)

# -----------------------------
# 2. Distribution of Exam Score
# -----------------------------
hist_plot <- ggplot(data, aes(x = Exam_Score)) +
  geom_histogram(binwidth = 5, fill = "steelblue", color = "black") +
  theme_minimal() +
  labs(title = "Distribution of Exam Scores", x = "Exam Score", y = "Count")

# Save plot
ggsave("output/figures/hist_exam_score.png", plot = hist_plot, width = 6, height = 4)

# Print plot
print(hist_plot)

# -----------------------------
# 3. Study Hours vs Exam Score
# -----------------------------
study_plot <- ggplot(data, aes(x = Hours_Studied, y = Exam_Score)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  theme_minimal() +
  labs(title = "Hours Studied vs Exam Score", x = "Hours Studied", y = "Exam Score")

# Save plot
ggsave("output/figures/study_vs_score.png", plot = study_plot, width = 6, height = 4)

# Print plot
print(study_plot)

# -----------------------------
# 4. Sleep Hours vs Exam Score
# -----------------------------
sleep_plot <- ggplot(data, aes(x = Sleep_Hours, y = Exam_Score)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", color = "red", se = FALSE) +
  theme_minimal() +
  labs(title = "Sleep Hours vs Exam Score", x = "Sleep Hours", y = "Exam Score")

# Save plot
ggsave("output/figures/sleep_vs_score.png", plot = sleep_plot, width = 6, height = 4)

# Print plot
print(sleep_plot)

# -----------------------------
# 5. Correlation Matrix
# -----------------------------
numeric_data <- data %>% select(where(is.numeric))
cor_matrix <- cor(numeric_data)

# Save correlation matrix as PNG
png("output/figures/correlation_matrix.png", width = 800, height = 600)
corrplot(cor_matrix, method = "color", type = "upper", tl.col = "black")
dev.off()

# Print correlation plot
corrplot(cor_matrix, method = "color", type = "upper", tl.col = "black")
# Correlation heatmap showing relationships among numeric features

# -----------------------------
# 6. Boxplots and categorical EDA
# -----------------------------
categorical_cols <- c(
  "Parental_Involvement", "Access_to_Resources", "Motivation_Level",
  "Family_Income", "Teacher_Quality", "School_Type", "Peer_Influence",
  "Parental_Education_Level", "Distance_from_Home", "Gender",
  "Extracurricular_Activities", "Internet_Access", "Learning_Disabilities"
)

for(cat in categorical_cols){
  # Check if column exists
  if(!cat %in% colnames(data)){
    message(paste("Column", cat, "not found in dataset. Skipping."))
    next
  }
  
  # Print categories
  categories <- unique(data[[cat]])
  message(paste("Categories in", cat, ":", paste(categories, collapse = ", ")))
  
  # Create boxplot
  plot <- ggplot(data, aes_string(x = cat, y = "Exam_Score")) +
    geom_boxplot(fill = "steelblue", alpha = 0.7) +
    theme_minimal() +
    labs(title = paste("Exam Score vs", cat), x = cat, y = "Exam Score")
  
  # Save plot
  file_name <- paste0("output/figures/exam_score_vs_", tolower(cat), ".png")
  ggsave(file_name, plot = plot, width = 6, height = 4)
  
  # Print plot
  print(plot)
}

# -----------------------------
# 7. Average Exam Score per Category
# -----------------------------
categorical_cols_avg <- c(
  "Parental_Involvement", "Access_to_Resources", "Motivation_Level",
  "Family_Income", "Teacher_Quality", "School_Type", "Peer_Influence",
  "Parental_Education_Level", "Distance_from_Home", "Gender",
  "Tutoring", "Boolean_2", "Boolean_3"
)

for(cat in categorical_cols_avg){
  # Skip if column not present
  if(!cat %in% colnames(data)){
    message(paste("Column", cat, "not found in dataset. Skipping."))
    next
  }
  
  # Convert 0/1 boolean columns to factor
  if(is.numeric(data[[cat]]) & length(unique(data[[cat]])) == 2){
    data[[cat]] <- factor(data[[cat]], levels = c(0,1), labels = c("No","Yes"))
  }
  
  # Calculate average Exam_Score per category
  avg_table <- data %>%
    group_by(.data[[cat]]) %>%
    summarize(Average_Exam_Score = mean(Exam_Score, na.rm = TRUE),
              Count = n())
  
  cat("\n=== Average Exam_Score by", cat, "===\n")
  print(avg_table)
  
  # Save to CSV
  file_name <- paste0("output/tables/avg_score_", tolower(cat), ".csv")
  write.csv(avg_table, file_name, row.names = FALSE)
  # Table showing mean Exam_Score and count per category
}