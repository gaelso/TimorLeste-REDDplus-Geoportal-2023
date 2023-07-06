# Load libraries
library(leaflet)
library(leaflet.multiopacity)
library(raster)

# Create raster example
r <- raster(xmn = -2.8, xmx = -2.79,
            ymn = 54.04, ymx = 54.05,
            nrows = 30, ncols = 30)
values(r) <- matrix(1:900, nrow(r), ncol(r), byrow = TRUE)
crs(r) <- crs("+init=epsg:4326")

# Provide layerId, group or category to show opacity controls
# If not specified, will render controls for all layers
leaflet() %>%
  addProviderTiles("Wikimedia", layerId = "Wikimedia") %>%
  addRasterImage(r, layerId = "raster") %>%
  addAwesomeMarkers(lng = -2.79545, lat = 54.04321,
                    layerId = "hospital", label = "Hospital") %>%
  addOpacityControls(layerId = c("raster", "hospital"),
                     collapsed = FALSE, position = "topright",
                     title = "Opacity Control")
