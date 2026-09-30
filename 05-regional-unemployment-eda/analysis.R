# ==============================================================================
# Regional US Unemployment: Exploratory Time Series Analysis & STL Decomposition
# Author: Robert Thomas Kohn
# Course: MTH 319 - Predictive Statistics, Muhlenberg College
# ==============================================================================

# --- Load Required Libraries ---
library(tidyverse)
library(tsibble)
library(feasts)
library(fable)
library(lubridate)
library(GGally)

# --- 1. Data Loading & Preprocessing ---
data_path <- "data/Unemployment_Combined.csv"
if (!file.exists(data_path)) {
  data_path <- "05-regional-unemployment-eda/data/Unemployment_Combined.csv"
}

# Load monthly unemployment rate for 5 US counties (1990 - 2023):
# Lehigh (PA), Philadelphia (PA), Palm Beach (FL), San Francisco (CA), Anchorage (AK)
unemployment_raw <- read_csv(data_path, show_col_types = FALSE)

unemployment_wide <- unemployment_raw %>%
  mutate(date = yearmonth(date)) %>%
  filter(date < yearmonth("2024-01"))

cat("Dataset period:", format(min(unemployment_wide$date)), "to", format(max(unemployment_wide$date)), "\n")
cat("Total monthly observations per county:", nrow(unemployment_wide), "\n")

# --- 2. Cross-Regional Correlation & Scatterplot Matrix ---
# Correlation matrix between county unemployment rates
county_cols <- c("Lehigh", "Philadelphia", "Palm Beach", "SanFrancisco", "Anchorage")
cor_matrix <- cor(unemployment_wide[, county_cols], use = "complete.obs")
cat("\nCounty Unemployment Rate Correlation Matrix:\n")
print(round(cor_matrix, 3))

# Highest correlation: Lehigh & Philadelphia (r = 0.940)
# Lowest correlation: Palm Beach & Anchorage (r = 0.609)

# --- 3. Long-Format Conversion & Multi-County Time Plot ---
unemployment_long <- unemployment_wide %>%
  pivot_longer(!date, names_to = "County", values_to = "UnempRate") %>%
  as_tsibble(index = date, key = County)

# Plot all counties together
plot_all <- unemployment_long %>%
  autoplot(UnempRate) +
  labs(
    title = "Unemployment Rate Comparison Across 5 US Counties (1990 - 2023)",
    x = "Date",
    y = "Unemployment Rate (%)",
    color = "County"
  ) +
  theme_minimal()
print(plot_all)

# --- 4. Lehigh County STL Decomposition ---
lehigh_ts <- unemployment_wide %>%
  select(date, Lehigh) %>%
  as_tsibble(index = date)

# Fit STL Decomposition (Seasonal and Trend decomposition using Loess)
stl_lehigh <- lehigh_ts %>%
  model(STL(Lehigh)) %>%
  components()

# Plot decomposition
plot_stl <- autoplot(stl_lehigh) +
  labs(
    title = "STL Decomposition of Lehigh County Unemployment Rate",
    x = "Date"
  ) +
  theme_minimal()
print(plot_stl)

# Plot original series with seasonally adjusted series overlay
plot_adj <- autoplot(lehigh_ts, Lehigh, color = "black") +
  autolayer(stl_lehigh, season_adjust, color = "red") +
  labs(
    title = "Lehigh County Unemployment: Raw (Black) vs Seasonally Adjusted (Red)",
    subtitle = "Major spikes during 2008 Financial Crisis and 2020 COVID-19 pandemic",
    x = "Date",
    y = "Unemployment Rate (%)"
  ) +
  theme_minimal()
print(plot_adj)

# --- 5. Autocorrelation & Macroeconomic Business Cycles ---
# ACF up to 60 lags (5-year cycle)
acf_lehigh <- lehigh_ts %>%
  ACF(Lehigh, lag_max = 60)

plot_acf <- autoplot(acf_lehigh) +
  labs(
    title = "Autocorrelation Function (ACF) - Lehigh County (Max Lag = 60 Months)",
    subtitle = "Autocorrelation remains significant until ~29 months; negative trough near 60 months reflects ~5-year business cycle",
    x = "Lag (Months)",
    y = "Autocorrelation"
  ) +
  theme_minimal()
print(plot_acf)

cat("\nAnalysis complete. Visualizations reflect economic shocks, seasonal employment, and macroeconomic cycles.\n")
