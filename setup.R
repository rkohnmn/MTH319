# ==============================================================================
# Environment Setup and Dependency Installation
# R / Statistical Computing Portfolio - Robert Kohn
# ==============================================================================

# Required CRAN packages across all projects
required_packages <- c(
  # Core Data Manipulation & Visualization
  "tidyverse",    # ggplot2, dplyr, tidyr, readr, purrr, stringr
  "lubridate",    # Date and time parsing
  "janitor",      # Data cleaning and name hygiene
  "skimr",        # Summary statistics
  "mosaic",       # Formula-based statistics and favstats
  "GGally",       # Pairs plots and correlation matrices

  # Supervised Learning & Machine Learning
  "caret",        # Cross-validation, model training, and metrics
  "class",        # K-Nearest Neighbors (KNN) algorithms
  "rpart",        # Recursive partitioning and decision trees
  "rpart.plot",   # Tree structure visualization
  "randomForest", # Bagging and Random Forests

  # Time Series Analysis & Forecasting
  "tsibble",      # Tidy temporal data frames
  "feasts",       # Feature extraction and statistics for time series (STL, ACF)
  "fable",        # Forecasting models (ETS, ARIMA, benchmarks)

  # Applied Mathematics & Differential Equations
  "deSolve"       # Numerical integration of ODE systems
)

# Identify missing packages
missing_packages <- required_packages[!(required_packages %in% installed.packages()[, "Package"])]

# Install missing packages
if (length(missing_packages) > 0) {
  message(sprintf("Installing %d missing package(s): %s", length(missing_packages), paste(missing_packages, collapse = ", ")))
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
} else {
  message("All required packages are already installed and up to date.")
}

# Verify package loading
message("\nVerifying package loading...")
for (pkg in required_packages) {
  suppressPackageStartupMessages(
    loaded <- require(pkg, character.only = TRUE, quietly = TRUE)
  )
  if (loaded) {
    message(sprintf("  [OK] %s", pkg))
  } else {
    warning(sprintf("  [FAIL] Could not load %s", pkg))
  }
}
message("\nEnvironment setup complete. Ready to run coursework analyses.")
