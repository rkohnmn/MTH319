# ==============================================================================
# Counter-Strike 2: Predicting Kill-Death Category Using K-Nearest Neighbors (KNN)
# Author: Robert Thomas Kohn
# Course: MTH 319 - Predictive Statistics, Muhlenberg College
# ==============================================================================

# --- Load Libraries ---
library(tidyverse)
library(caret)
library(class)
library(mosaic)
library(janitor)
library(skimr)
library(GGally)

# --- 1. Data Loading & Preprocessing ---
# Load cleaned player kills dataset from PGL CS2 Major Copenhagen 2024
data_path <- "data/Player_Kills.csv"
if (!file.exists(data_path)) {
  # Fallback if run from project root
  data_path <- "01-knn-player-performance/data/Player_Kills.csv"
}

player_data <- read_csv(data_path, show_col_types = FALSE)

# Rename 1vP to OvP if present (1-vs-X clutch percentage)
if ("1vP" %in% names(player_data)) {
  player_data <- player_data %>% rename(OvP = `1vP`)
}

# Inspect summary of raw Kill-Death ratio
favstats(~kd, data = player_data)

# Discretize continuous KD ratio into 5 meaningful competitive performance tiers:
# Low End KD (< 0.75), Low Mid KD [0.75, 0.90), Mid KD [0.90, 1.05),
# High Mid KD [1.05, 1.20), High End KD (>= 1.20)
player_data <- player_data %>%
  mutate(
    kd_cat = factor(
      case_when(
        kd < 0.75 ~ "Low End KD",
        kd >= 0.75 & kd < 0.90 ~ "Low Mid KD",
        kd >= 0.90 & kd < 1.05 ~ "Mid KD",
        kd >= 1.05 & kd < 1.20 ~ "High Mid KD",
        TRUE ~ "High End KD"
      ),
      levels = c("Low End KD", "Low Mid KD", "Mid KD", "High Mid KD", "High End KD")
    )
  )

table(player_data$kd_cat)

# --- 2. Exploratory Data Analysis & Bivariate Distributions ---
# Predictor variables:
# mk (multi-kill rounds), OvP (1vX clutch win %), mvp (round MVP awards),
# headshot_count, first_kill_count (opening kills), first_death_count (opening deaths)

predictor_vars <- c("mk", "OvP", "mvp", "headshot_count", "first_kill_count", "first_death_count")

# Boxplots of individual predictors across KD performance categories
bwplot(mk ~ kd_cat, data = player_data, main = "Multi-Kill Rounds by KD Category", xlab = "Category", ylab = "Multi-Kills")
bwplot(mvp ~ kd_cat, data = player_data, main = "MVPs by KD Category", xlab = "Category", ylab = "MVPs")
bwplot(headshot_count ~ kd_cat, data = player_data, main = "Headshot Count by KD Category", xlab = "Category", ylab = "Headshots")
bwplot(OvP ~ kd_cat, data = player_data, main = "1vX Clutch Win % by KD Category", xlab = "Category", ylab = "1vX %")
bwplot(first_kill_count ~ kd_cat, data = player_data, main = "Opening Kills by KD Category", xlab = "Category", ylab = "Opening Kills")
bwplot(first_death_count ~ kd_cat, data = player_data, main = "Opening Deaths by KD Category", xlab = "Category", ylab = "Opening Deaths")

# Missing values check
pk_clean <- na.omit(player_data)

# --- 3. Feature Scaling & Train/Test Partitioning ---
# Scale and center numerical predictors for distance-based KNN
scaled_data <- pk_clean
scaled_data[, predictor_vars] <- scale(pk_clean[, predictor_vars])

set.seed(420) # Reproducible partition
train_index <- createDataPartition(scaled_data$kd_cat, p = 0.80, list = FALSE)
train_set <- scaled_data[train_index, ]
test_set  <- scaled_data[-train_index, ]

# --- 4. 5-Fold Cross Validation for Hyperparameter Tuning (Full Model) ---
cv_control <- trainControl(method = "cv", number = 5, preProc = c("center", "scale"))

# Train KNN across 30 candidate values of K
knn_full <- train(
  kd_cat ~ mk + OvP + mvp + headshot_count + first_kill_count + first_death_count,
  data = train_set,
  method = "knn",
  tuneLength = 30,
  trControl = cv_control
)

print(knn_full)
best_k <- knn_full$results$k[which.max(knn_full$results$Accuracy)]
cat("Optimal K (Centered/Scaled):", best_k, "with CV Accuracy:", max(knn_full$results$Accuracy), "\n")

# Plot K vs Error Rate (Centered/Scaled)
plot(
  knn_full$results$k, (1 - knn_full$results$Accuracy),
  type = "b", pch = 19, col = "darkblue",
  main = "K Value vs Error Rate (Centered & Scaled)",
  xlab = "K", ylab = "Cross-Validation Error Rate"
)

# Uncentered comparison model
knn_uncentered <- train(
  kd_cat ~ mk + OvP + mvp + headshot_count + first_kill_count + first_death_count,
  data = train_set,
  method = "knn",
  tuneLength = 30,
  trControl = trainControl(method = "cv", number = 5)
)
plot(
  knn_uncentered$results$k, (1 - knn_uncentered$results$Accuracy),
  type = "b", pch = 19, col = "darkred",
  main = "K Value vs Error Rate (Uncentered)",
  xlab = "K", ylab = "Cross-Validation Error Rate"
)

# --- 5. Feature Subset Evaluation ---
# Pairing 1: Headshots + Clutches
rep1 <- train(kd_cat ~ headshot_count + OvP, data = train_set, method = "knn", tuneLength = 30, trControl = cv_control)
cat("Pair 1 (Headshots + 1vP) - Best K:", rep1$results$k[which.max(rep1$results$Accuracy)],
    "Accuracy:", max(rep1$results$Accuracy), "Error Rate:", 1 - max(rep1$results$Accuracy), "\n")

# Pairing 2: Multi-Kills + MVPs
rep2 <- train(kd_cat ~ mk + mvp, data = train_set, method = "knn", tuneLength = 30, trControl = cv_control)
cat("Pair 2 (Multi-Kills + MVPs) - Best K:", rep2$results$k[which.max(rep2$results$Accuracy)],
    "Accuracy:", max(rep2$results$Accuracy), "Error Rate:", 1 - max(rep2$results$Accuracy), "\n")

# Pairing 3: Opening Kills + Opening Deaths
rep3 <- train(kd_cat ~ first_kill_count + first_death_count, data = train_set, method = "knn", tuneLength = 30, trControl = cv_control)
cat("Pair 3 (First Kills + First Deaths) - Best K:", rep3$results$k[which.max(rep3$results$Accuracy)],
    "Accuracy:", max(rep3$results$Accuracy), "Error Rate:", 1 - max(rep3$results$Accuracy), "\n")

# Single Predictor Confirmation Tests
oki <- train(kd_cat ~ first_kill_count, data = train_set, method = "knn", tuneLength = 30, trControl = cv_control)
odi <- train(kd_cat ~ first_death_count, data = train_set, method = "knn", tuneLength = 30, trControl = cv_control)

cat("Opening Kills Alone - Accuracy:", max(oki$results$Accuracy), "Error Rate:", 1 - max(oki$results$Accuracy), "\n")
cat("Opening Deaths Alone - Accuracy:", max(odi$results$Accuracy), "Error Rate:", 1 - max(odi$results$Accuracy), "\n")

# --- 6. Final Model & Out-of-Sample Evaluation ---
# Fit final model using primary predictor (Opening Kills) across full dataset
final_knn <- train(
  kd_cat ~ first_kill_count,
  data = player_data,
  method = "knn",
  tuneLength = 30,
  trControl = cv_control
)

# Predict on test set
test_pred <- predict(final_knn, newdata = test_set)
conf_mat <- confusionMatrix(test_pred, test_set$kd_cat)
print(conf_mat)

# --- 7. Scenario Predictions for New Player Profiles ---
favstats(~first_kill_count, data = player_data)

# Test low (0), average (30), and elite (120) opening kill counts
new_players <- data.frame(first_kill_count = c(0, 30, 120))
predictions <- predict(final_knn, newdata = new_players)

cat("Scenario Predictions:\n")
cat("  0 Opening Kills (Low End):", as.character(predictions[1]), "\n")
cat(" 30 Opening Kills (Near Mean):", as.character(predictions[2]), "\n")
cat("120 Opening Kills (Elite Performer):", as.character(predictions[3]), "\n")
