#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(tmap)
library(sf)
library(dplyr)

sf_country   <- st_read("data/TImorLeste.geoJSON", quiet = T)
sf_AD        <- st_read("data/AD-spatial-grid.geoJSON", quiet = T)
sf_AD_square <- st_read("data/AD-spatial-square.geoJSON", quiet = T)

pal_redd <- c("#36B0C7", "#D60602", "#207A20", "grey10")


pal_lu <- c('#0f6f09', '#7a8bff', '#1fff10', '#aa6510', '#0a2dd5', '#28b9ff', '#ff4be9', 
            "#f1ff18", '#f1ff18', '#f1ff18', '#ff8f1c', 'grey10', 'grey10', 'grey10')


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel(
    title = div(img(src="banner_en3.png", width = '100%')),
    windowTitle = "Timor Leste REDD+ Geoportal"
  ),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    sidebarPanel(
      
      selectInput(
        inputId = "basemap", 
        label = "Choose a base map layer",
        choices = c("ESRI gray canvas"   = "Esri.WorldGrayCanvas",
                    "ESRI World imagery" = "Esri.WorldImagery",
                     "OpenTopoMap"       = "OpenTopoMap",
                     "OpenStreetMap"     = "OpenStreetMap.Mapnik"),
        selected = "Esri.WorldGrayCanvas"
        )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      
      leafletOutput("my_map", width = "100%", height = "80vh")
      
      )
    
  ) ## End sidebarLayout
)## End fluidPage

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$my_map = renderLeaflet({
    
    leaflet(options = leafletOptions(minZoom = 8)) %>%
      addProviderTiles(layerId = "basemap", provider = "Esri.WorldGrayCanvas") %>%
      setView(125, -9, zoom = 8) %>%
      setMaxBounds(lng1 = 124, lat1 = -10, lng2 = 128, lat2 = -8)
    
    # tm_basemap(server = input$basemap) +
    #   tm_shape(sf_country) + tm_borders(col = "red") +
    #   tm_shape(sf_AD) + tm_polygons(col = "redd_FRL", border.col = NA, palette = pal_redd) +
    #   tm_shape(sf_AD_square) + tm_borders(col = "yellow")

  })
  
  ## Update basemap aka tiles
  observeEvent(input$basemap, {
    leafletProxy("my_map") %>%
      removeTiles("basemap") %>%
      addProviderTiles(layerId = "basemap", input$basemap)
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
