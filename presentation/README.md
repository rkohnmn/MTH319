# Coursework Capstone Presentation

**Title:** MTH 319 Predictive Statistics: Project Synthesis Presentation  
**Author:** Robert Thomas Kohn  
**Instructor:** Dr. Russell  
**Course:** MTH 319 - Predictive Statistics, Muhlenberg College  

---

## Overview
This directory contains the original presentation slide deck delivered as the cumulative capstone for MTH 319 (Predictive Statistics). It synthesizes the three core computational and statistical modeling projects completed during the semester:

1. **K-Nearest Neighbors (KNN):** Predicting player Kill-Death categories in *Counter-Strike 2*.
2. **Time Series Forecasting:** Analyzing and forecasting *Karambit* Google Trends popularity.
3. **Decision Trees & Ensembles:** Predicting round outcomes in *Counter-Strike* using classification trees, bagging, and random forests.

## Included Presentation File
- `MTH_319_Final_Presentation.pptx`: The original PowerPoint presentation created and presented by Robert Kohn.

## Slide Structure & Key Takeaways
- **Slide 1: Title Slide**  
  *MTH-319 Cumulative Presentation* – Robert Kohn (Dr. Russell's Class).
- **Slide 2: Overview**  
  Summary of topics: K-Nearest Neighbors, Time Series Forecasting, and Tree-Based Methods.
- **Slide 3: KNN Project Takeaways**  
  - Tested tactical metrics (multi-kills, 1vP, opening duels) against $K/D$ tiers.
  - Opening kills yielded the highest predictive accuracy (46.7% paired; 42.4% alone).
  - Highlights class imbalance challenges: modal Mid/Low-Mid tiers dominate the dataset.
  - Concludes that simple nearest-neighbor averaging struggles with extreme player categories.
- **Slide 4: Time Series Project Takeaways**  
  - 14-year trend analysis (2011–2025) of Karambit search popularity.
  - Major cycle (2015–2020) and minor cycle (2022–2025 CS2 launch).
  - Seasonal Exponential Smoothing model selected as optimal; April seasonal peaks and October troughs.
- **Slide 5: Decision Tree & Ensemble Project Takeaways**  
  - Multi-class round outcome prediction.
  - Single tree isolates Counter-Terrorist buy type as primary decision node.
  - Bagging and Random Forests identify team round spend amounts as dominant predictors.
  - Highlights error rate reduction from 66.7% (single tree) to 56.3% (Random Forest).
- **Slide 6: Conclusion & Questions**
