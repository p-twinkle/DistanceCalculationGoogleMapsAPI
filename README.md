```md
# Distance Calculation using Google Maps API in R

## Project Overview
This project provides an R script to extract distance data between locations using the Google Maps API. The script processes input coordinates (latitude, longitude) for pickup and dropoff locations, fetches the distance via API calls, and processes data in batches of 20,000 rows for efficiency.

## Installation & Setup

### Prerequisites
Before running the script, ensure you have:
- R (version 3.6+ recommended)
- A Google Maps API Key (with Distance Matrix API enabled)
- Required R libraries installed

### Install Required Libraries
Run the following command in R:
```r
install.packages(c("httr", "jsonlite", "dplyr"))
```

### Google Maps API Key Setup
1. Get your API key from [Google Cloud Console](https://console.cloud.google.com/).
2. Enable the **Google Maps Distance Matrix API**.
3. Store your API key in an environment variable or pass it directly in the script:
```r
API_key <- "YOUR_GOOGLE_API_KEY"
```

## Input Requirements

The script requires a CSV file (`inputfile.csv`) with pickup and dropoff latitude/longitude coordinates.

### Required Columns in the Input CSV
| Column Name        | Description                               | Example            |
|-------------------|---------------------------------------|------------------|
| `pickup_latitude` | Latitude of the pickup location      | `40.7128`        |
| `pickup_longitude`| Longitude of the pickup location     | `-74.0060`       |
| `dropoff_latitude`| Latitude of the dropoff location     | `34.0522`        |
| `dropoff_longitude`| Longitude of the dropoff location   | `-118.2437`      |

### Example Input File (`inputfile.csv`)
```
pickup_latitude,pickup_longitude,dropoff_latitude,dropoff_longitude
40.7128,-74.0060,34.0522,-118.2437
41.8781,-87.6298,29.7604,-95.3698
37.7749,-122.4194,47.6062,-122.3321
```

## How to Run the Script
1. Place your `inputfile.csv` in the working directory.
2. Open **RStudio** or an R terminal.
3. Run the script:
```r
source("distance_extraction.R")
```
4. The script will process the data in batches and save the results in a CSV file.

### Key Functions in the Script
- `get_map_distance(pickup, dropoff, API_key)`: Fetches distance from Google Maps API.
- `split_into_batches(df, batch_size)`: Splits data into batches of 20,000 rows for efficient API calls.
- `process_batch(batch)`: Calls API and adds distance column for each batch.
- `write.csv(final_df, "google_api_distance.csv")`: Saves the final output.

## Output Format

The script generates a CSV file (`google_api_distance.csv`) with computed distances.

### Example Output (`google_api_distance.csv`)
| pickup_latitude | pickup_longitude | dropoff_latitude | dropoff_longitude | distance_miles |
|----------------|----------------|----------------|----------------|---------------|
| 40.7128 | -74.0060 | 34.0522 | -118.2437 | 2445.56 |
| 41.8781 | -87.6298 | 29.7604 | -95.3698 | 1081.95 |
| 37.7749 | -122.4194 | 47.6062 | -122.3321 | 808.24 |

## Customization & Enhancements
- **Traffic-based Distance:** Modify API calls to include `departure_time=now` for real-time data.
- **Address-based Locations:** Allow users to input addresses instead of lat-long coordinates.
- **Parallel Processing:** Use multithreading to speed up API calls.

## API Usage & Cost Considerations
Google Maps API has quota limits and billing considerations:
- Free tier allows 2,500 API calls per day.
- Paid plans allow 100,000+ calls with pricing based on usage.
- To avoid exceeding limits, consider caching responses or optimizing batch sizes.

## License
This project is open-source under the MIT License. Contributions and modifications are welcome.
```

This is a **fully formatted and professional README** that you can **copy and paste directly into your GitHub repository**. Let me know if any modifications are needed.
