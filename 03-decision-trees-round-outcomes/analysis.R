# ==============================================================================
# Counter-Strike: Predicting Round Outcomes Using Classification Trees & Ensembles
# Author: Robert Thomas Kohn
# Course: MTH 319 - Predictive Statistics, Muhlenberg College
# ==============================================================================

# --- Load Required Libraries ---
library(tidyverse)
library(rpart)
library(rpart.plot)
library(randomForest)
library(skimr)
library(mosaic)
library(janitor)

# --- 1. Data Loading & Preprocessing ---
# Checks for full dataset or loads sample dataset for demonstration
data_path <- "data/csgo-round-data.csv"
if (!file.exists(data_path)) {
  if (file.exists("data/sample_round_data.csv")) {
    data_path <- "data/sample_round_data.csv"
  } else if (file.exists("03-decision-trees-round-outcomes/data/csgo-round-data.csv")) {
    data_path <- "03-decision-trees-round-outcomes/data/csgo-round-data.csv"
  } else {
    data_path <- "03-decision-trees-round-outcomes/data/sample_round_data.csv"
  }
}

cat("Loading dataset from:", data_path, "\n")
csgo_data <- read_csv(data_path, show_col_types = FALSE)

# Clean and filter anomalous 'GameStart' technical reset rounds
csgo_data <- csgo_data %>%
  filter(roundEndReason != "GameStart") %>%
  mutate(
    mapName        = factor(mapName),
    ctBuyType      = factor(ctBuyType),
    tBuyType       = factor(tBuyType),
    roundEndReason = factor(roundEndReason)
  )

cat("Observations:", nrow(csgo_data), "rounds across", length(levels(csgo_data$mapName)), "competitive maps\n")

# --- 2. Exploratory Data Analysis & Class Distributions ---
# Univariate distribution of round end reasons
cat("\nRound End Reason Frequencies:\n")
outcome_table <- table(csgo_data$roundEndReason)
print(outcome_table)

# Bivariate distributions of team round spend and scores
favstats(ctRoundSpendMoney ~ roundEndReason, data = csgo_data)
favstats(tRoundSpendMoney  ~ roundEndReason, data = csgo_data)

# Correlation between team score and economy spend
cat("Correlation between CT Score and CT Round Spend:",
    cor(csgo_data$ctScore, csgo_data$ctRoundSpendMoney, use = "complete.obs"), "\n")

# --- 3. Single Classification Tree (rpart) ---
# Formula predicting multi-class roundEndReason from team economies, buy types, map, and score
tree_formula <- roundEndReason ~ tScore + ctScore + mapName +
  ctRoundSpendMoney + ctBuyType + tRoundSpendMoney + tBuyType

tree_model <- rpart(tree_formula, data = csgo_data, method = "class")

cat("\n--- Single Classification Tree Model ---\n")
printcp(tree_model)

# Plot decision tree structure
rpart.plot(
  tree_model,
  type = 4,
  extra = 104,
  fallen.leaves = TRUE,
  cex = 0.8,
  main = "Classification Tree for Round End Reason"
)

cat("\nVariable Importance (Single Tree):\n")
print(tree_model$variable.importance)

# --- 4. Scenario Predictions with Single Tree ---
# Real observation test
obs_real <- csgo_data[1, ]
cat("\nPrediction for First Real Observation:\n")
cat("  Actual:   ", as.character(obs_real$roundEndReason), "\n")
cat("  Predicted:", as.character(predict(tree_model, newdata = obs_real, type = "class")), "\n")

# Test 3 realistic in-game competitive economy scenarios:
# 1. Anubis: CT Full Eco ($3,000) vs T Full Buy ($20,000)
# 2. Mirage: CT Full Buy ($30,000) vs T Semi-Eco ($6,000)
# 3. Inferno Overtime: Both teams force buy with SMGs ($11,250 vs $10,000)
scenario_data <- data.frame(
  tScore = c(5, 10, 15),
  ctScore = c(10, 5, 15),
  mapName = factor(c("de_anubis", "de_mirage", "de_inferno"), levels = levels(csgo_data$mapName)),
  ctRoundSpendMoney = c(3000, 30000, 11250),
  ctBuyType = factor(c("Full Eco", "Full Buy", "Semi Buy"), levels = levels(csgo_data$ctBuyType)),
  tRoundSpendMoney = c(20000, 6000, 10000),
  tBuyType = factor(c("Full Buy", "Semi Eco", "Semi Buy"), levels = levels(csgo_data$tBuyType))
)

cat("\nPredictions on Competitive Game Scenarios (Single Tree):\n")
scenario_preds_tree <- predict(tree_model, newdata = scenario_data, type = "class")
print(data.frame(Scenario = c("Anubis CT Eco vs T Buy", "Mirage CT Buy vs T Eco", "Inferno OT Tie"), Prediction = scenario_preds_tree))

# --- 5. Bagged Classification Trees (randomForest with mtry = all) ---
# Bagging considers all 7 predictors at each split
# Only run full ensemble when sufficient data is available
if (nrow(csgo_data) >= 100) {
  set.seed(420)
  bag_model <- randomForest(
    tree_formula,
    data = csgo_data,
    mtry = 7,
    importance = TRUE,
    ntree = 100
  )
  
  cat("\n--- Bagged Classification Tree Model ---\n")
  cat("Out-of-Bag (OOB) Overall Error Rate:",
      round(bag_model$err.rate[nrow(bag_model$err.rate), "OOB"] * 100, 2), "%\n")
  
  varImpPlot(bag_model, main = "Variable Importance (Bagged Tree)")
  
  # --- 6. Random Forest Classifier ---
  # Standard random forest considers mtry = floor(sqrt(7)) = 2
  set.seed(420)
  rf_model <- randomForest(
    tree_formula,
    data = csgo_data,
    importance = TRUE,
    ntree = 100
  )
  
  cat("\n--- Random Forest Model ---\n")
  cat("Out-of-Bag (OOB) Overall Error Rate:",
      round(rf_model$err.rate[nrow(rf_model$err.rate), "OOB"] * 100, 2), "%\n")
  
  varImpPlot(rf_model, main = "Variable Importance (Random Forest)")
  
  # Compare scenario predictions across ensemble models
  cat("\nScenario Predictions (Bagging):\n")
  print(predict(bag_model, newdata = scenario_data))
  
  cat("\nScenario Predictions (Random Forest):\n")
  print(predict(rf_model, newdata = scenario_data))
} else {
  cat("\nNote: Sample dataset loaded (< 100 rows). Download full Kaggle dataset to execute 100-tree ensemble models.\n")
}
