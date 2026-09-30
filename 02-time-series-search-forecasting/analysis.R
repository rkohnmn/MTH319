# ==============================================================================
# Time Series Analysis, STL Decomposition, and Forecasting of "Karambit" Trends
# Author: Robert Thomas Kohn
# Course: MTH 319 - Predictive Statistics, Muhlenberg College
# ==============================================================================

# --- Load Required Libraries ---
library(tidyverse)
library(tsibble)
library(feasts)
library(fable)
library(lubridate)
library(janitor)

# --- 1. Data Loading & Time Series Wrangling ---
data_path <- "data/KarambitTrends.csv"
if (!file.exists(data_path)) {
  # Fallback if run from project root
  data_path <- "02-time-series-search-forecasting/data/KarambitTrends.csv"
}

# Read monthly Google Trends search popularity (2011 - 2025)
# Convert string Month (YYYY-MM) into tsibble yearmonth index
karambit_data <- read_csv(data_path, show_col_types = FALSE) %>%
  clean_names() %>%
  mutate(month = yearmonth(month)) %>%
  as_tsibble(index = month)

cat("Time series span:", format(start(karambit_data$month)), "to", format(end(karambit_data$month)), "\n")
cat("Total observations:", nrow(karambit_data), "monthly periods\n")

# --- 2. Exploratory Time Series Plots ---
# Overall Time Plot
time_plot <- autoplot(karambit_data, karambit) +
  labs(
    title = "Karambit Search Popularity Time Series (2011 - 2025)",
    subtitle = "Worldwide Google Trends Index (Monthly)",
    x = "Date (Monthly)",
    y = "Search Popularity (0 - 100)"
  ) +
  theme_minimal()
print(time_plot)

# Annual Seasonal Plot
seasonal_plot <- gg_season(karambit_data, karambit) +
  labs(
    title = "Seasonal Pattern of Karambit Search Popularity",
    subtitle = "Annual overlays highlighting spring peaks and autumn troughs",
    x = "Month",
    y = "Search Popularity"
  ) +
  theme_minimal()
print(seasonal_plot)

# --- 3. STL Decomposition & Autocorrelation ---
# STL decomposition (Seasonal and Trend decomposition using Loess)
stl_decomp <- karambit_data %>%
  model(STL(karambit)) %>%
  components()

# Plot decomposition components (Trend, Seasonal, Remainder)
stl_plot <- autoplot(stl_decomp) +
  labs(
    title = "STL Decomposition of Karambit Search Popularity",
    x = "Date"
  ) +
  theme_minimal()
print(stl_plot)

# Seasonal component plot across years
seasonal_comp_plot <- gg_season(stl_decomp, season_year) +
  labs(
    title = "Seasonal Component of Karambit Search Popularity",
    y = "Seasonal Effect",
    x = "Month"
  ) +
  theme_minimal()
print(seasonal_comp_plot)

# Autocorrelation Function (ACF) up to 24 lags (2 years)
acf_plot <- karambit_data %>%
  ACF(karambit, lag_max = 24) %>%
  autoplot() +
  labs(
    title = "Autocorrelation Plot (ACF) - Max Lag 24 Months",
    x = "Lag (Months)",
    y = "Autocorrelation"
  ) +
  theme_minimal()
print(acf_plot)

# Original series vs Seasonally Adjusted series
adj_plot <- autoplot(karambit_data, karambit, color = "black") +
  autolayer(stl_decomp, season_adjust, color = "red") +
  labs(
    title = "Karambit Search Popularity: Original (Black) vs Seasonally Adjusted (Red)",
    x = "Date",
    y = "Search Popularity"
  ) +
  theme_minimal()
print(adj_plot)

# --- 4. Model Training & Accuracy Comparison ---
# Fit standard benchmark and exponential smoothing models
models <- karambit_data %>%
  model(
    mean        = MEAN(karambit),
    naive       = NAIVE(karambit),
    sznl_naive  = SNAIVE(karambit ~ lag("year")),
    drift       = RW(karambit ~ drift()),
    SES         = ETS(karambit ~ error("A") + trend("N") + season("N")),
    Trend_ETS   = ETS(karambit ~ error("A") + trend("A") + season("N")),
    Szn_ETS     = ETS(karambit ~ error("A") + trend("N") + season("A")),
    TSETS       = ETS(karambit ~ error("A") + trend("A") + season("A"))
  )

# Model accuracy comparison
model_acc <- accuracy(models) %>%
  select(.model, RMSE, MAE, MAPE, MASE) %>%
  arrange(RMSE)

cat("\nModel Comparison Ranked by RMSE:\n")
print(model_acc)

# Select best performing model based on minimum RMSE
best_model <- models %>% select(Szn_ETS)

# --- 5. Probabilistic Forecasting (2-Year Horizon) ---
forecast_2yrs <- best_model %>%
  forecast(h = "2 years")

# Print forecast prediction intervals (50% and 95%)
forecast_intervals <- hilo(forecast_2yrs, level = c(50, 95))
cat("\nSample 2-Year Forecast Intervals (First 6 Months):\n")
print(head(forecast_intervals, 6))

# Plot forecast with prediction intervals (with ggplot2 4.0.0 compatibility fallback)
tryCatch({
  forecast_plot <- autoplot(karambit_data, karambit) +
    autolayer(forecast_2yrs, level = c(50, 95)) +
    ggtitle("2-Year Forecast for Karambit Search Popularity")
  print(forecast_plot)
}, error = function(e) {
  fc_df <- as_tibble(forecast_2yrs) %>%
    mutate(
      lower95 = hilo(karambit, 95)$lower,
      upper95 = hilo(karambit, 95)$upper
    )
  p <- ggplot() +
    geom_line(data = as_tibble(karambit_data), aes(x = as.Date(month), y = karambit)) +
    geom_line(data = fc_df, aes(x = as.Date(month), y = .mean), color = "blue", linewidth = 1) +
    geom_ribbon(data = fc_df, aes(x = as.Date(month), ymin = lower95, ymax = upper95), alpha = 0.2, fill = "blue") +
    labs(title = "2-Year Forecast for Karambit Search Popularity (ETS)", x = "Date", y = "Search Popularity") +
    theme_minimal()
  print(p)
})

# --- 6. Future Path Simulation ---
set.seed(420)
yr2_sim <- best_model %>%
  generate(h = "2 years", times = 1)

tryCatch({
  sim_plot <- autoplot(karambit_data, karambit) +
    autolayer(yr2_sim, color = "red") +
    ggtitle("Simulated Future for Karambit Search Popularity")
  print(sim_plot)
}, error = function(e) {
  p_sim <- ggplot() +
    geom_line(data = as_tibble(karambit_data), aes(x = as.Date(month), y = karambit)) +
    geom_line(data = as_tibble(yr2_sim), aes(x = as.Date(month), y = .sim), color = "red", linetype = "dashed") +
    labs(title = "Simulated Future for Karambit Search Popularity", x = "Date", y = "Search Popularity") +
    theme_minimal()
  print(p_sim)
})


