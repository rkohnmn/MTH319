# Predicting Esports Match Round Outcomes Using Decision Trees and Ensemble Methods

A multi-class predictive modeling project classifying competitive round victory conditions in *Counter-Strike* using Single Classification Trees (`rpart`), Bootstrap Aggregation (Bagging), and Random Forests.

## What I Worked On
- Processed and filtered professional esports match telemetry, removing anomalous technical reset rounds.
- Engineered and factored multi-categorical predictors (team buy states, map names, score differentials).
- Fit a baseline single classification tree with recursive partitioning (`rpart`) and visualized decision boundaries via `rpart.plot`.
- Evaluated tree complexity parameters (`printcp`), root node errors, and variable importance scores.
- Implemented **Bagged Classification Trees** (`randomForest`, $mtry = 7$) and **Random Forests** ($mtry = 2$) across 100 bootstrap trees.
- Diagnosed out-of-bag (OOB) error rates, class-level misclassifications, and Mean Decrease Gini variable importance.
- Assessed practical performance on competitive gameplay scenarios (full buys vs. eco rounds across competitive maps).

## Tools
- **Language:** R (v4.4+)
- **Packages:** `rpart`, `rpart.plot`, `randomForest`, `tidyverse` (`dplyr`, `ggplot2`, `readr`), `mosaic`, `janitor`, `skimr`

## Files
- `analysis.R`: Clean, executable R script supporting both sample test data and full dataset execution.
- `report.md`: Complete academic report featuring tactical interpretations, economic distributions, and critical reflection.
- `data/sample_round_data.csv`: Lightweight sample (first 50 rounds) for immediate syntax verification without large file downloads.
- `data/README.md`: Data dictionary, schema, and Kaggle download instructions for the full dataset.
- `figures/`: Barplots of outcome frequencies, economic boxplots, tree diagrams, and ensemble variable importance charts.

## Results / Takeaways
- **Economy Drives Victory:** Across all models, **team round spend amounts** (`ctRoundSpendMoney`, `tRoundSpendMoney`) and buy categories (`ctBuyType`) ranked as the dominant split variables, whereas map identity contributed negligible predictive power.
- **Model Progression:**
  - Single Decision Tree: 66.7% error rate (yields a direct, intuitive rule: CT Full Buy $\rightarrow$ CT Win).
  - Bagged Classification Tree: 60.0% OOB error rate.
  - Random Forest: **56.3% OOB error rate** (lowest error rate).
- **Class Imbalance Challenges:** Rare strategic outcomes (time expiring, bomb defusal) suffered high misclassification rates ($>70\%$), indicating that collapsing outcomes into binary sides (`CT Win` vs. `T Win`) would significantly bolster practical predictive accuracy.

## Running the Analysis
From the repository root or project directory:
```r
# In R / RStudio (runs automatically on sample data, or on full data if placed in data/)
source("03-decision-trees-round-outcomes/analysis.R")
```
Or from the command line:
```bash
Rscript 03-decision-trees-round-outcomes/analysis.R
```
