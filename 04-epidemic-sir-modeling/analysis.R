# ==============================================================================
# Numerical Simulation and Sensitivity Analysis of the SIR Epidemic Model
# Author: Robert Thomas Kohn
# Course: MTH 319 - Predictive Statistics, Muhlenberg College
# ==============================================================================

# --- Load Required Libraries ---
library(deSolve)
library(ggplot2)

# --- 1. Model Definition (Coupled Non-Linear ODEs) ---
# Compartments: Susceptible (S), Infectious (I), Recovered (R)
# Parameters: beta (transmission rate), gamma (recovery rate)
sir_model <- function(time, state, parameters) {
  with(as.list(c(state, parameters)), {
    dS <- -beta * S * I
    dI <-  beta * S * I - gamma * I
    dR <-  gamma * I
    
    list(c(dS, dI, dR))
  })
}

# --- 2. Baseline Outbreak Simulation (14-Day Trajectory) ---
# Parameters calibrated to the 1978 English boarding school influenza outbreak:
# N = 763, I_0 = 3, beta = 0.0026, gamma = 0.5
N <- 763
init_values <- c(S = N - 3, I = 3, R = 0)
parameters  <- c(beta = 0.0026, gamma = 0.5)
times       <- seq(1, 14, by = 0.1)

sir_output <- ode(y = init_values, times = times, func = sir_model, parms = parameters)
sir_df     <- as.data.frame(sir_output)

# Plot 14-day outbreak progression
p14 <- ggplot(sir_df, aes(x = time)) +
  geom_line(aes(y = S, color = "Susceptible"), linewidth = 1.1) +
  geom_line(aes(y = I, color = "Infectious"), linewidth = 1.1) +
  geom_line(aes(y = R, color = "Recovered"), linewidth = 1.1) +
  labs(
    title    = "SIR Model Outbreak Dynamics (14-Day Horizon)",
    subtitle = "Population N = 763, I0 = 3, beta = 0.0026, gamma = 0.5",
    x        = "Time (days)",
    y        = "Population Count",
    color    = "Compartment"
  ) +
  scale_color_manual(values = c("Susceptible" = "#2F5597", "Infectious" = "#C00000", "Recovered" = "#548235")) +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold"), legend.position = "bottom")

print(p14)

# Evaluate Day 7 Peak Metrics
day7 <- sir_df[which.min(abs(sir_df$time - 7)), ]
cat("Day 7 Status:\n")
cat("  Susceptible:", round(day7$S), "\n")
cat("  Infectious: ", round(day7$I), "\n")
cat("  Recovered:  ", round(day7$R), "\n")

# --- 3. Long-Term Equilibrium (365 Days) ---
times_long <- seq(0, 365, by = 1)
sir_long   <- as.data.frame(ode(y = init_values, times = times_long, func = sir_model, parms = parameters))

cat("\nEquilibrium Comparison (Day 14 vs Day 165):\n")
cat("  Day 14  - S:", round(sir_long[15, "S"]), " I:", round(sir_long[15, "I"]), " R:", round(sir_long[15, "R"]), "\n")
cat("  Day 165 - S:", round(sir_long[166, "S"]), " I:", round(sir_long[166, "I"]), " R:", round(sir_long[166, "R"]), "\n")

# --- 4. Sensitivity Analysis: Initial Infected Seeding (I_0) ---
cat("\nSensitivity to Initial Infected (I_0 at Day 7, N ~ 1000):\n")
for (i_init in c(0, 1, 10, 100)) {
  pop_tot <- 1000 + i_init
  init_s  <- c(S = 1000, I = i_init, R = 0)
  out_s   <- as.data.frame(ode(y = init_s, times = seq(1, 14, by = 1), func = sir_model, parms = parameters))
  d7_s    <- out_s[out_s$time == 7, ]
  cat(sprintf("  I_0 = %3d -> Day 7: S = %4.0f, I = %4.0f, R = %4.0f\n", i_init, d7_s$S, d7_s$I, d7_s$R))
}

# --- 5. Sensitivity Analysis: Transmission Rate (beta) ---
cat("\nSensitivity to Transmission Rate beta (Day 7, gamma = 0.5, I_0 = 1):\n")
for (b_val in c(0.0001, 0.001, 0.002, 0.004)) {
  parms_b <- c(beta = b_val, gamma = 0.5)
  init_b  <- c(S = 1000, I = 1, R = 0)
  out_b   <- as.data.frame(ode(y = init_b, times = seq(1, 14, by = 1), func = sir_model, parms = parms_b))
  d7_b    <- out_b[out_b$time == 7, ]
  cat(sprintf("  beta = %0.4f -> Day 7: S = %4.0f, I = %4.0f, R = %4.0f\n", b_val, d7_b$S, d7_b$I, d7_b$R))
}

# --- 6. Sensitivity Analysis: Recovery Rate (gamma) ---
cat("\nSensitivity to Recovery Rate gamma (Day 7, beta = 0.0012, I_0 = 1):\n")
for (g_val in c(0.01, 0.10, 0.50, 0.75)) {
  parms_g <- c(beta = 0.0012, gamma = g_val)
  init_g  <- c(S = 1000, I = 1, R = 0)
  out_g   <- as.data.frame(ode(y = init_g, times = seq(1, 14, by = 1), func = sir_model, parms = parms_g))
  d7_g    <- out_g[out_g$time == 7, ]
  cat(sprintf("  gamma = %0.2f -> Day 7: S = %4.0f, I = %4.0f, R = %4.0f\n", g_val, d7_g$S, d7_g$I, d7_g$R))
}
