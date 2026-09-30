# Dataset: CS:GO Competitive Match Round Data

## Overview
This directory contains schema details and a lightweight sample for the Counter-Strike esports round-by-round match dataset used to evaluate classification trees, bagging, and random forests.

- **Sample File Provided:** `sample_round_data.csv` (first 50 rounds, included for syntax verification and immediate testing)
- **Full Dataset Filename:** `csgo-round-data.csv` (~10 MB, ~30,000+ competitive round observations)

## Download Instructions (Full Dataset)
Because raw match logs exceed Git recommended size thresholds, the full dataset should be downloaded directly from Kaggle:

1. **Source URL:** [CS:GO Esports Matches Round Data on Kaggle](https://www.kaggle.com/datasets/livanoff/csgo-esport-matches-round-data)
2. **Author:** LIvanoff
3. **Download Steps:**
   - Download `csgo-round-data.csv` from Kaggle.
   - Place `csgo-round-data.csv` into this directory: `data/csgo-round-data.csv`.
   - `analysis.R` automatically detects the full file when present; otherwise, it runs against `sample_round_data.csv`.

## Data Cleaning Notes
- **Anomalous Reset Rounds:** Rounds with `roundEndReason == "GameStart"` represent warmup or technical server restarts and are excluded prior to model fitting.
- **Categorical Factors:** Variables such as `mapName`, `ctBuyType`, `tBuyType`, and `roundEndReason` are converted to factors.

## Variable Dictionary
| Variable | Type | Description |
| :--- | :--- | :--- |
| `roundEndReason` | Factor (Target) | Round victory condition: `BombDefused`, `TargetBombed`, `CTWin` (elimination), `TerroristsWin` (elimination), `TargetSaved` (time expired) |
| `mapName` | Factor | Competitive map (e.g. `de_anubis`, `de_mirage`, `de_inferno`, `de_ancient`) |
| `ctScore` | Numeric | Running round score for Counter-Terrorist team |
| `tScore` | Numeric | Running round score for Terrorist team |
| `ctRoundSpendMoney` | Numeric | Total economy cash spent by CT team for the round ($USD) |
| `tRoundSpendMoney` | Numeric | Total economy cash spent by T team for the round ($USD) |
| `ctBuyType` | Factor | CT economic buy state: `Full Eco`, `Semi Eco`, `Semi Buy`, `Full Buy` |
| `tBuyType` | Factor | T economic buy state: `Full Eco`, `Semi Eco`, `Semi Buy`, `Full Buy` |
