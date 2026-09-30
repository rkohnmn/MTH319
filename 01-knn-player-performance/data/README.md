# Dataset: PGL CS2 Major Copenhagen 2024 Player Performance

## Overview
This dataset contains competitive player match statistics from the PGL Counter-Strike 2 Major held in Copenhagen, Denmark in 2024. The original match records were gathered by Vansh Bordia and published on Kaggle.

- **Primary File:** `Player_Kills.csv`
- **Observations:** 80 professional player tournament records
- **Variables:** 41 raw and feature-engineered metrics

## Origin & Acquisition
- **Source:** Kaggle ([PGL CS2 Major Copenhagen 2024 Data](https://www.kaggle.com/datasets/vanshbordia/pgl-cs2-major-copenhagen-2024-data))
- **Author/Collector:** Vansh Bordia
- **License / Terms:** Open access educational Kaggle dataset

## Data Cleaning & Feature Engineering Performed
1. **Decimal and Formatting Corrections:** Fixed missing decimal points in raw kill/death calculations present in the initial export.
2. **Multi-Kill Aggregation (`mk`):** Engineered column summing all multi-kill rounds ($2\text{k} + 3\text{k} + 4\text{k} + 5\text{k}$) recorded for each player.
3. **Clutch Percentage (`OvP` / `1vP`):** Calculated ratio of 1-vs-X clutch rounds won relative to total clutch attempts ($\frac{\text{1vX won}}{\text{1vX attempted}} \times 100$).
4. **Target Discretization (`kd_cat`):** Discretized continuous $K/D$ ratio into five competitive performance tiers:
   - `Low End KD`: $K/D < 0.75$
   - `Low Mid KD`: $0.75 \le K/D < 0.90$
   - `Mid KD`: $0.90 \le K/D < 1.05$
   - `High Mid KD`: $1.05 \le K/D < 1.20$
   - `High End KD`: $K/D \ge 1.20$

## Variable Dictionary
| Variable | Type | Description |
| :--- | :--- | :--- |
| `name` | Character | Player in-game alias |
| `team_name` | Character | Esports organization / team name |
| `kd` | Numeric | Kill-to-death ratio ($K/D$) |
| `mk` | Numeric | Total multi-kill rounds (2k through 5k) |
| `OvP` (`1vP`) | Numeric | 1-vs-X clutch win rate percentage |
| `mvp` | Numeric | Total Most Valuable Player awards |
| `headshot_count` | Numeric | Total headshot eliminations |
| `first_kill_count`| Numeric | Opening kills (entry frags) secured |
| `first_death_count`| Numeric | Opening deaths suffered |
| `adr` | Numeric | Average damage per round |
| `kast` | Numeric | Percentage of rounds with kill, assist, survived, or traded |
