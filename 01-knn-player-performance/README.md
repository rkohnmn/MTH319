# K-Nearest Neighbors Classification of Esports Player Performance

A supervised machine learning analysis predicting professional *Counter-Strike 2* player performance tiers from tactical in-game metrics using K-Nearest Neighbors (KNN) with 5-fold cross-validation.

## What I Worked On
- Discretized continuous player Kill-Death ($K/D$) ratios into five competitive tiers based on natural distribution spreads.
- Engineered aggregate features: multi-kill rounds (`mk`) and 1-vs-X clutch conversion rates (`OvP`).
- Performed bivariate exploratory analysis with boxplots and scatterplot matrices (`GGally::ggpairs`).
- Implemented feature centering and scaling, demonstrating its necessity for Euclidean distance algorithms.
- Tuned the hyperparameter $k \in [1, 30]$ via 5-fold cross-validation on an 80/20 train/test split.
- Conducted hypothesis testing on feature subsets (Headshots + Clutches, Multi-kills + MVPs, Opening Kills + Opening Deaths).
- Evaluated out-of-sample generalization with confusion matrix diagnostics, sensitivity, specificity, and scenario predictions.

## Tools
- **Language:** R (v4.4+)
- **Packages:** `caret`, `class`, `tidyverse` (`dplyr`, `ggplot2`, `readr`), `mosaic`, `janitor`, `skimr`, `GGally`

## Files
- `analysis.R`: Clean, executable R script performing the end-to-end data cleaning, EDA, tuning, and evaluation pipeline.
- `report.md`: Complete academic report with embedded exploratory and diagnostic figures.
- `data/Player_Kills.csv`: Cleaned tournament player match statistics from the PGL Major Copenhagen 2024.
- `data/README.md`: Data dictionary, provenance, and feature engineering notes.
- `figures/`: Visualizations including $K/D$ distributions, feature boxplots, $k$-tuning error curves, and confusion matrix diagnostics.

## Results / Takeaways
- **Opening Duels Drive Rating:** Opening kills (`first_kill_count`) served as the single most predictive metric ($42.4\%$ CV accuracy alone), outperforming multi-variable models.
- **Clutch Independence:** 1-vs-X clutch percentage showed virtually zero correlation with overall $K/D$ tier, confirming that clutch ability is a situational specialty rather than a volume driver.
- **Model Evaluation:** The final model achieved 36.3% test accuracy (95% CI: $[17.2\%, 59.3\%]$) with high specificity ($>0.72$) across classes, effectively classifying median-tier players while struggling on extreme outliers due to class sparsity.

## Running the Analysis
From the repository root or project directory:
```r
# In R / RStudio
source("01-knn-player-performance/analysis.R")
```
Or from the command line:
```bash
Rscript 01-knn-player-performance/analysis.R
```
