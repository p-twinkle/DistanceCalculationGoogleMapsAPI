# ---------------------------Google API Call for Map distance----------------------------

# Read raw uber data file
set.seed(1)
raw_data <- read.csv("inputfile.csv")
dim(raw_data)

# User Input
# API_key <- 'Enter_your_api_key'

# function to get map distance from Google Maps API
get_map_distance <- function(pickup, dropoff, API_key)
{
  # Construct the URL
  url <- paste0("https://maps.googleapis.com/maps/api/distancematrix/json?origins=",
                pickup, "&destinations=", dropoff, "&key=", API_key)
  
  # Make the request
  response <- httr::GET(url)
  
  # Parse the response
  response_content <- httr::content(response, as = "text")
  response_json <- jsonlite::fromJSON(response_content)
  
  # Check the status and extract the distance
  if (response_json$status == "OK")
  {
    # Get the distance in meters
    distance_meters <- response_json$rows$elements[[1]]$distance$value
    # Convert the distance to kilometers
    distance_miles <- distance_meters / 1609.344
    print(paste("Distance:", distance_miles, "miles"))
  }
  else
  {
    print("Error:", response_json$error_message)
    distance_miles <- NULL
  }
  return(distance_miles)
}

# new_data <- head(raw_data)
new_data <- raw_data %>%
  mutate(pickup=paste(pickup_latitude, pickup_longitude, sep=','),
         dropoff=paste(dropoff_latitude, dropoff_longitude, sep=',')
  )

# final data
df <- new_data[new_data$pickup != new_data$dropoff, ]

# Set seed for reproducibility
set.seed(123)

# Function to split the data frame into batches of 20000 rows
split_into_batches <- function(df, batch_size) {
  split(df, ceiling(seq_along(rownames(df)) / batch_size))
}

# Split the data frame into batches of 20000 rows
batch_size <- 20000
batches <- split_into_batches(df, batch_size)

# Print the number of batches and the first few rows of each batch
length(batches)

# Define the function to process each batch and get the map distance using API call
process_batch <- function(batch) {
  batch$distance_miles <- apply(batch, 1, function(row){
    get_map_distance(
      pickup = row["pickup"]
      ,dropoff = row["dropoff"]
      ,API_key = API_key)
  })
  return(batch)
}

# Initialize an empty list to store the processed batches
processed_batches <- list()

# Process each batch and store the results in processed_batches
for (i in seq_along(batches)) {
  processed_batches[[i]] <- process_batch(batches[[i]], API_key)
  print(paste("Processed batch", i, "of", length(batches)))
}

# Combine all processed batches to form the final data
final_df <- do.call(rbind, processed_batches)
# write the csv to use later
write.csv(final_df, "google_api_distance.csv")

# ---------------------------------------- END ------------------------------------------
