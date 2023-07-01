
## Load packages

library(sf)
library(tmap)
library(tidyverse)
library(shiny)
library(shiny.i18n)

## Set legend colors

pal_redd <- c("#36B0C7", "#D60602", "#207A20", "grey10")


pal_lu <- c('#0f6f09', '#7a8bff', '#1fff10', '#aa6510', '#0a2dd5', '#28b9ff', '#ff4be9', 
            "#f1ff18", '#f1ff18', '#f1ff18', '#ff8f1c', 'grey10', 'grey10', 'grey10')


## Load data

sf_country <- st_read("data/TImorLeste.geoJSON")

sf_AD <- st_read("data/AD-spatial-grid.geoJSON")

## Recreate AD visual interpretation 1 ha squares
if (!("AD-spatial-square.geoJSON" %in% list.files("data"))) {
  
  sf_AD_centroid <- sf_AD %>% st_centroid()
  
  AD_square <- sf_AD_centroid %>%
    st_transform(32751) %>% 
    mutate(
      x = st_coordinates(.)[,1],
      y = st_coordinates(.)[,2]
    ) %>%
    as_tibble() %>%
    select(seqnum, id, x, y) %>%
    mutate(
      x1 = x - 50,
      y1 = y + 50,
      x2 = x + 50,
      y2 = y + 50,
      x3 = x + 50,
      y3 = y - 50,
      x4 = x - 50,
      y4 = y - 50
    ) %>% 
    rowwise() %>%
    mutate(
      poly = list(cbind(c(x1, x2, x3, x4, x1), c(y1, y2, y3, y4, y1)))
    )
  
  sf_AD_square_init <- map_dfr(1:nrow(AD_square), function(x){
    coords <- AD_square$poly[[x]]
    st_polygon(list(coords)) |>
      st_sfc(crs = 32751) |>
      st_as_sf()
    })
  
  sf_AD_square <- sf_AD_square_init |>
    st_transform(crs = 4326) |>
    mutate(
      id = AD_square$id,
      seqnum = AD_square$seqnum
    )
  
  st_write(sf_AD_square, "data/AD-spatial-square.geoJSON")
  st_write(sf_AD_square, "data/AD-spatial-square.kml")
  
  rm(AD_square, sf_AD_square_init, sf_AD_square)

}

sf_AD_square <- st_read("data/AD-spatial-square.geoJSON")

tmap_mode("view")
tm_basemap("Esri.WorldImagery") +
tm_shape(sf_AD_square) + tm_borders(col = "red")

