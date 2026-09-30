# Time Series Analysis, STL Decomposition, and Forecasting of "Karambit" Trends

An empirical time series investigation analyzing 14 years of Google Trends search volume for the gaming digital asset "Karambit," evaluating decomposition, benchmark models, and exponential smoothing state-space forecasts.

## What I Worked On
- Structured and formatted 169 monthly periods (2011–2025) into a tidy `tsibble` time series index.
- Applied **STL decomposition** (Seasonal and Trend decomposition using Loess) to isolate macro trend cycles from seasonal fluctuations and remainder shocks.
- Evaluated sample autocorrelation across 24 lags, revealing trend persistence exceeding 1.75 years.
- Benchmarked eight competing time series forecasting methods:
  - Baselines: Mean, Naive, Seasonal Naive, Drift (Random Walk with Drift).
  - State-Space: Simple Exponential Smoothing (SES), Holt's Linear Trend ($\text{ETS}(A,A,N)$), Seasonal ETS ($\text{ETS}(A,N,A)$), Holt-Winters Additive ($\text{ETS}(A,A,A)$).
- Ranked models using Root Mean Squared Error (RMSE) and Mean Absolute Error (MAE).
- Generated a 2-year probabilistic forecast with 50% and 95% confidence intervals and future path simulation.

## Tools
- **Language:** R (v4.4+)
- **Packages:** `tsibble`, `feasts`, `fable`, `fabletools`, `tidyverse` (`dplyr`, `ggplot2`, `readr`), `lubridate`, `janitor`

## Files
- `analysis.R`: Clean, standalone R script executing data formatting, decomposition, model fitting, and forecasting.
- `report.md`: Formal academic paper detailing historical gaming context, methodology, and model interpretation.
- `data/KarambitTrends.csv`: 14-year worldwide Google Trends monthly search index data.
- `data/README.md`: Provenance, search parameters, and domain context.
- `figures/`: Time plots, seasonal sub-series plots, STL component charts, ACF plots, and 2-year forecast confidence bands.

## Results / Takeaways
- **Trend vs. Seasonality:** Trend dominates total variance, with search volume surging during the 2014–2016 skin market boom and resurging during the 2022–2023 CS2 announcement.
- **Model Selection:** The **Seasonal ETS model ($\text{ETS}(A,N,A)$)** achieved the lowest overall error ($\text{RMSE} = 4.53$, $\text{MAE} = 3.17$), outperforming both simple trend models and naive benchmarks.
- **Forecast Projections:** The 24-month horizon projects recurring April peaks (~41.0) and October troughs (~36.3), capturing consumer interest patterns while uncertainty intervals appropriately expand over time.

## Running the Analysis
From the repository root or project directory:
```r
# In R / RStudio
source("02-time-series-search-forecasting/analysis.R")
```
Or from the command line:
```bash
Rscript 02-time-series-search-forecasting/analysis.R
```
