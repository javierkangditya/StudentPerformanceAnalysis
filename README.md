# StudentPerformanceAnalysis

## Project Overview
This project analyzes factors affecting students' exam scores and builds predictive models.

## Folder Structure
- `Data/Raw` : original datasets  
- `Data/Processed` : cleaned and feature-engineered datasets  
- `Notebooks` : R Markdown notebooks documenting the workflow  
- `Scripts` : separate R scripts for each pipeline step  
- `Output/Figures` : plots from EDA and evaluation  
- `Output/Tables` : summary statistics, feature importance, average scores  
- `Output/Models` : trained models saved as RDS  

## Pipeline
1. **Data Cleaning** – handle missing values, duplicates, correct data types  
2. **Exploratory Data Analysis (EDA)** – numeric and categorical analysis, correlations, plots  
3. **Feature Engineering** – scaling numeric features, creating interaction features  
4. **Modeling** – Linear Regression, Random Forest, XGBoost  
5. **Evaluation** – Predicted vs Actual plots, model performance metrics  

## How to Run
1. Open RStudio project  
2. Run R scripts in order or knit R Markdown notebooks  
3. Make sure required packages are installed: `tidyverse`, `readxl`, `ggplot2`, `caret`, `randomForest`, `xgboost`, `openxlsx`, `corrplot`  

## Key Insights
- Numeric features like study hours and attendance have the strongest impact on exam scores  
- Linear Regression model performed best in predicting exam scores  
- Interaction features with near-zero correlation were removed  

## References
Student Performance Factors by Lai Ng. on Kaggle(dataset)
