# Dataset: Google Trends Search Popularity for "Karambit"

## Overview
This dataset captures monthly worldwide search interest for the search term **"Karambit"** between March 2011 and March 2025. 

- **Primary File:** `KarambitTrends.csv`
- **Time Span:** March 2011 – March 2025 (169 monthly periods)
- **Granularity:** Monthly ($[1M]$)

## Origin & Acquisition
- **Source:** Google Trends ([trends.google.com](https://trends.google.com))
- **Query Term:** `Karambit`
- **Region:** Worldwide (All categories)
- **Collected Date:** March 2025

## Context & Historical Significance
The Karambit is a traditional Southeast Asian curved blade that rose to global cultural prominence as one of the most prestigious virtual cosmetic weapon skins in *Counter-Strike: Global Offensive* (released August 2013 with the *Arms Deal* update) and *Counter-Strike 2*.

The 14-year time window captures:
1. **Pre-Release Baseline (2011–2013):** Baseline knife interest prior to introduction in Valve's gaming ecosystem.
2. **First Boom Cycle (2014–2016):** Explosive rise in search interest following the CS:GO skin trading and esports boom.
3. **Maturity & Correction (2017–2021):** Stabilization of search interest.
4. **Resurgence (2022–2024):** Secondary boom driven by the announcement and global release of *Counter-Strike 2*.

## Variables
| Variable | Type | Description |
| :--- | :--- | :--- |
| `Month` | Character (`YYYY-MM`) | Year and month of the observation period |
| `Karambit` | Numeric ($0 - 100$) | Google Trends normalized search interest index (100 = peak popularity) |
