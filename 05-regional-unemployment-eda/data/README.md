# Dataset: Regional US County-Level Unemployment Rates

## Overview
This dataset contains monthly unemployment rates for five economically and geographically diverse counties across the United States from January 1990 through December 2023.

- **Primary File:** `Unemployment_Combined.csv`
- **Time Span:** January 1990 – December 2023 (408 monthly observations per county)
- **Granularity:** Monthly ($[1M]$)

## Origin & Acquisition
- **Source:** Federal Reserve Bank of St. Louis Economic Data (FRED) ([fred.stlouisfed.org](https://fred.stlouisfed.org))
- **Series Included:**
  - Lehigh County, PA (`PALEHI7URN`)
  - Philadelphia County, PA (`PAPILA3URN`)
  - Palm Beach County, FL (`FLPALM5URN`)
  - San Francisco County, CA (`CASANF0URN`)
  - Anchorage Borough, AK (`AKANCH1URN`)

## Variables
| Variable | Type | Description |
| :--- | :--- | :--- |
| `date` | Date / `yearmonth` | Month and year of the observation |
| `Lehigh` | Numeric (%) | Monthly unemployment rate for Lehigh County, Pennsylvania |
| `Philadelphia`| Numeric (%) | Monthly unemployment rate for Philadelphia County, Pennsylvania |
| `Palm Beach` | Numeric (%) | Monthly unemployment rate for Palm Beach County, Florida |
| `SanFrancisco` | Numeric (%) | Monthly unemployment rate for San Francisco County, California |
| `Anchorage` | Numeric (%) | Monthly unemployment rate for Anchorage Municipality, Alaska |
