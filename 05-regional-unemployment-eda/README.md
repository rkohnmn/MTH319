# Regional US Unemployment: Exploratory Time Series Analysis & STL Decomposition

An exploratory time series analysis examining multi-regional monthly unemployment across five diverse US economic centers over 34 years (1990–2023), isolating economic shocks and business cycles via STL decomposition.

## What I Worked On
- Processed 408 monthly observations across five counties: Lehigh (PA), Philadelphia (PA), Palm Beach (FL), San Francisco (CA), and Anchorage (AK).
- Restructured data into a long-format tidy `tsibble` to enable multi-series comparative time plots.
- Evaluated regional cross-correlations, identifying strong macroeconomic synchronization among urban industrial centers (Lehigh and Philadelphia, $r = 0.940$) versus geographic divergence (Palm Beach and Anchorage, $r = 0.609$).
- Conducted **STL decomposition** on Lehigh County unemployment to isolate the underlying trend-cycle from annual seasonal employment fluctuations.
- Overlaid raw vs. seasonally adjusted unemployment trajectories, pinpointing the acute impacts of the 2008 Great Recession and the April 2020 COVID-19 pandemic spike (reaching 16.2%).
- Analyzed autocorrelation across 60 lags (5-year window), uncovering cyclical business patterns characterized by a statistically significant negative trough around 60 months.

## Tools
- **Language:** R (v4.4+)
- **Packages:** `tsibble`, `feasts`, `fable`, `tidyverse` (`dplyr`, `ggplot2`, `readr`, `tidyr`), `lubridate`, `GGally`

## Files
- `analysis.R`: Clean R script performing data reshaping, multi-county comparative plotting, STL decomposition, and autocorrelation analysis.
- `data/Unemployment_Combined.csv`: Monthly unemployment rate series compiled from the Federal Reserve Bank of St. Louis (FRED).
- `data/README.md`: Data source documentation and county code identifiers.
- `figures/`: High-resolution figures displaying Lehigh Valley unemployment, all-county overlays, and the 60-month ACF business cycle.

## Results / Takeaways
- **Macroeconomic Shocks vs. Seasonality:** Major historical spikes (e.g., COVID-19 surge to >16% in Lehigh Valley) completely dominate seasonal fluctuations, persisting clearly in the seasonally adjusted series.
- **Cross-Regional Synchronization:** Northeastern industrial counties (Lehigh and Philadelphia) exhibit near-perfect synchronization ($r = 0.940$), whereas tourism-driven (Palm Beach) and resource-driven (Anchorage) counties diverge during regional economic shifts.
- **Business Cycle Evidence:** Autocorrelation remains positive through ~29 months before dipping into negative territory near 60 months, reflecting standard 5-year macroeconomic expansion and contraction phases.

## Running the Analysis
From the repository root or project directory:
```r
# In R / RStudio
source("05-regional-unemployment-eda/analysis.R")
```
Or from the command line:
```bash
Rscript 05-regional-unemployment-eda/analysis.R
```
