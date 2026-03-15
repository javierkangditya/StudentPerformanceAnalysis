# =============================================
# 04_Modeling.R
# =============================================
# This script performs:
# 1. Train/Test split
# 2. Linear Regression modeling & evaluation
# 3. Random Forest modeling, evaluation & feature importance
# 4. XGBoost modeling & evaluation
# All outputs (tables, plots) are saved to the output folder
# =============================================

# -----------------------------
# Load necessary libraries
# -----------------------------
library(caret)
library(randomForest)
library(xgboost)
library(dplyr)

set.seed(123)

# -----------------------------
# 1. Split data (Train/Test)
# -----------------------------
train_index <- createDataPartition(data_fe$Exam_Score, p = 0.8, list = FALSE)
train_data <- data_fe[train_index, ]
test_data <- data_fe[-train_index, ]

# -----------------------------
# 2. Linear Regression
# -----------------------------
lm_model <- lm(Exam_Score ~ ., data = train_data)
lm_pred <- predict(lm_model, newdata = test_data)

# Evaluation
lm_rmse <- sqrt(mean((lm_pred - test_data$Exam_Score)^2))
lm_r2 <- cor(lm_pred, test_data$Exam_Score)^2
message(paste("Linear Regression RMSE:", round(lm_rmse, 2), "R²:", round(lm_r2, 2)))

# -----------------------------
# 3. Random Forest
# -----------------------------
rf_model <- randomForest(Exam_Score ~ ., data = train_data, ntree = 100)
rf_pred <- predict(rf_model, newdata = test_data)

# Evaluation
rf_rmse <- sqrt(mean((rf_pred - test_data$Exam_Score)^2))
rf_r2 <- cor(rf_pred, test_data$Exam_Score)^2
message(paste("Random Forest RMSE:", round(rf_rmse, 2), "R²:", round(rf_r2, 2)))

# Feature importance
rf_importance <- importance(rf_model)
rf_importance_df <- data.frame(Feature = rownames(rf_importance), Importance = rf_importance[,1])
rf_importance_df <- rf_importance_df[order(-rf_importance_df$Importance), ]

# Save feature importance table
dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)
write.csv(rf_importance_df, "output/tables/rf_feature_importance.csv", row.names = FALSE)

# -----------------------------
# 4. XGBoost
# -----------------------------
# Convert all features to numeric using model.matrix (dummy encoding)
train_matrix <- model.matrix(Exam_Score ~ ., train_data)[,-1]  # remove intercept
train_label <- train_data$Exam_Score

test_matrix <- model.matrix(Exam_Score ~ ., test_data)[,-1]

# Fit XGBoost
xgb_model <- xgboost(
  data = train_matrix, 
  label = train_label, 
  nrounds = 100, 
  objective = "reg:squarederror", 
  verbose = 0
)
xgb_pred <- predict(xgb_model, test_matrix)

# Evaluation
xgb_rmse <- sqrt(mean((xgb_pred - test_data$Exam_Score)^2))
xgb_r2 <- cor(xgb_pred, test_data$Exam_Score)^2
message(paste("XGBoost RMSE:", round(xgb_rmse, 2), "R²:", round(xgb_r2, 2)))