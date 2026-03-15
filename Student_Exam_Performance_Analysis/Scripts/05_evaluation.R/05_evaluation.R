# =============================================
# 05_Evaluation.R
# =============================================
# This script creates scatter plots comparing predicted vs actual Exam Scores
# for Linear Regression, Random Forest, and XGBoost.
# It also saves the trained models as RDS files for future use.
# All outputs are saved to the output folder.
# =============================================

library(ggplot2)
library(dplyr)

# -----------------------------
# Combine predictions and actual values
# -----------------------------
pred_df <- data.frame(
  Actual = test_data$Exam_Score,
  Linear_Regression = lm_pred,
  Random_Forest = rf_pred,
  XGBoost = xgb_pred
)

# -----------------------------
# Plot Predicted vs Actual
# -----------------------------
model_names <- c("Linear_Regression", "Random_Forest", "XGBoost")

# Ensure output folder exists
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)

for(model in model_names){
  
  p <- ggplot(pred_df, aes_string(x = "Actual", y = model)) +
    geom_point(alpha = 0.5, color = "steelblue") +
    geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "red") +
    theme_minimal() +
    labs(
      title = paste("Predicted vs Actual: ", gsub("_", " ", model)),
      x = "Actual Exam Score",
      y = "Predicted Exam Score"
    )
  
  # Save plot
  plot_file <- paste0("output/figures/pred_vs_actual_", tolower(model), ".png")
  ggsave(plot_file, plot = p, width = 6, height = 4)
  
  # Print plot in console or HTML
  print(p)
}

# Dashed red line = perfect prediction (Predicted = Actual)
# Points near the line indicate good model performance

# =============================================
# Save Trained Models
# =============================================

# Ensure Models folder exists
dir.create("output/Models", recursive = TRUE, showWarnings = FALSE)

# Save Linear Regression
saveRDS(lm_model, file = "output/Models/lm_model.rds")

# Save Random Forest
saveRDS(rf_model, file = "output/Models/rf_model.rds")

# Save XGBoost
saveRDS(xgb_model, file = "output/Models/xgb_model.rds")

# All models saved as RDS files
# Can be reloaded with readRDS() for future predictions or deployment