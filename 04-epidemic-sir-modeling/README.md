# Numerical Simulation and Sensitivity Analysis of the SIR Epidemic Model

A computational applied mathematics project implementing systems of non-linear Ordinary Differential Equations (ODEs) to simulate infectious disease transmission dynamics and evaluate parameter sensitivity.

## What I Worked On
- Formulated the classical **Susceptible-Infectious-Recovered (SIR)** compartmental epidemic model as a system of coupled differential equations:
  $$\frac{dS}{dt} = -\beta \cdot S \cdot I$$
  $$\frac{dI}{dt} = \beta \cdot S \cdot I - \gamma \cdot I$$
  $$\frac{dR}{dt} = \gamma \cdot I$$
- Implemented numerical integration using the `deSolve` package (`ode` solver) with calibrated parameters from the 1978 English boarding school influenza epidemic ($N = 763$, $I_0 = 3$, $\beta = 0.0026$, $\gamma = 0.5$).
- Simulated both acute outbreak dynamics (14-day window) and long-term herd immunity equilibrium (365-day horizon).
- Conducted multi-parameter perturbation sensitivity experiments:
  - Variation in initial infectious seeding: $I_0 \in \{0, 1, 10, 100\}$.
  - Variation in transmission rate: $\beta \in \{0.0001, 0.001, 0.002, 0.004\}$.
  - Variation in recovery rate: $\gamma \in \{0.01, 0.10, 0.50, 0.75\}$.
- Programmed customized, publication-ready multi-compartment visualizations in `ggplot2`.

## Tools
- **Language:** R (v4.4+)
- **Packages:** `deSolve`, `ggplot2`

## Files
- `analysis.R`: Fully self-contained script formulating the ODE system, executing numerical simulations, and generating sensitivity tables.
- `figures/fig1_sir_simulation.png`: Trajectory plot showing the progression of Susceptible, Infectious, and Recovered populations over 14 days.

## Results / Takeaways
- **Baseline Outbreak Peak:** Under baseline parameters, the epidemic peaks sharply at Day 7 ($I = 230$, $S = 68$, $R = 465$), exhausting susceptible hosts and rapidly concluding the active wave by Day 14 ($S = 16$, $I = 7$).
- **Long-Term Balance:** Running the simulation to 365 days demonstrates that 16 individuals (~2.1% of the population) escape infection entirely due to herd immunity dampening transmission before complete exhaustion.
- **Sensitivity Dynamics:**
  - Increasing $\beta$ from $0.001$ to $0.004$ accelerates the epidemic peak, reducing susceptible survivors at Day 7 from 964 down to 1.
  - Increasing $\gamma$ (faster recovery / effective medical intervention) dampens spread; at $\gamma = 0.75$, Day 7 active infections drop to 14, effectively preventing a widespread outbreak.

## Running the Analysis
From the repository root or project directory:
```r
# In R / RStudio
source("04-epidemic-sir-modeling/analysis.R")
```
Or from the command line:
```bash
Rscript 04-epidemic-sir-modeling/analysis.R
```
