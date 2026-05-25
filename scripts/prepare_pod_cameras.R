library(sf)
library(tidygeocoder)
library(dplyr)

pod_cameras <- st_read("data/pod_cameras.geojson", quiet = TRUE) |>
  st_transform(4326)

# Extract lon/lat as plain columns for reverse geocoding
coords <- st_coordinates(pod_cameras)
pod_df <- pod_cameras |>
  st_drop_geometry() |>
  mutate(
    lon = coords[, 1],
    lat = coords[, 2],
    camera_number = as.integer(sub("marker_", "", marker_id))
  )

# Reverse geocode via OSM/Nominatim (free; ~1 req/s, ~12 min for 717 points)
# full_results = TRUE gives back individual address components (postcode, road, etc.)
message("Reverse geocoding ", nrow(pod_df), " POD cameras via Nominatim — this takes ~12 minutes...")
geocoded <- pod_df |>
  reverse_geocode(
    lat = lat,
    long = lon,
    method = "osm",
    address = addr,
    full_results = TRUE,
    verbose = FALSE
  )

# Pull out the fields we want; fall back to NA if the column wasn't returned
pull_col <- function(df, col) if (col %in% names(df)) df[[col]] else NA_character_

enriched <- geocoded |>
  mutate(
    address = pull_col(geocoded, "display_name"),
    zip     = pull_col(geocoded, "postcode"),
    street  = pull_col(geocoded, "road")
  ) |>
  select(marker_id, camera_number, address, zip, street, lon, lat)

# Re-attach geometry and write out
pod_enriched <- st_as_sf(enriched, coords = c("lon", "lat"), crs = 4326)

st_write(pod_enriched, "data/pod_cameras.geojson", delete_dsn = TRUE, quiet = TRUE)
message("Saved enriched GeoJSON to data/pod_cameras.geojson (", nrow(pod_enriched), " features)")
