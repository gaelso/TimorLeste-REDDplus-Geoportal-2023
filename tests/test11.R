


library(shiny)
library(bslib)
library(crosstalk)
library(leaflet)
library(dplyr)
library(forcats)



##
## UI ##########################################################################
##

ui <- page_fillable(
  title = "Timor Leste REDD+ Geoportal",
  theme = bs_theme(
    version = 5,
    bootswatch = "minty",
    base_font = font_google("Merriweather"),
    code_font = font_google("Fira Code"),
    heading_font = font_google("Quicksand", wght = 700)
  ),
  bg = "#f8f9fa",
  card(layout_sidebar(
    sidebar = accordion(
      accordion_panel(
        "test",
        radioButtons(
          inputId = "basemap", 
          label = NULL,
          choices = c("ESRI gray canvas"   = "Esri.WorldGrayCanvas",
                      "ESRI world imagery" = "Esri.WorldImagery",
                      "OpenTopoMap"       = "OpenTopoMap",
                      "OpenStreetMap"     = "OpenStreetMap.Mapnik"),
          selected = "Esri.WorldGrayCanvas"
        )
      )
    ),
    leafletOutput("my_map")
  ))
)

server <- function(input, output, session) {
  
  output$my_map = renderLeaflet({
    leaflet(options = leafletOptions(minZoom = 8)) |>
      addProviderTiles(layerId = "basemap", provider = "Esri.WorldGrayCanvas") |>
      setView(125, -9, zoom = 8) |>
      setMaxBounds(lng1 = 124, lat1 = -10, lng2 = 128, lat2 = -8)
  })
  
  observeEvent(input$basemap, {
    leafletProxy("my_map") |>
      removeTiles("basemap") |>
      addProviderTiles(layerId = "basemap", input$basemap)
  })
  
}


shinyApp(ui = ui, server = server)