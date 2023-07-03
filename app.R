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
library(shinyjs)
library(shiny.i18n)

sf_country   <- st_read("data/TimorLeste.geoJSON", quiet = T)
sf_AD        <- st_read("data/AD-spatial-grid.geoJSON", quiet = T)
sf_AD_square <- st_read("data/AD-spatial-square.geoJSON", quiet = T)

pal_redd <- tibble(
  redd_FRL = c("AF", "DF", "StableF", "StableNF"),
  redd_color = c("#36B0C7", "#D60602", "#207A20", "grey10"),
  redd_FRL_name = c("Afforestation", "Deforestation", "Stable Forest", "Stable Non-Forest")
)


pal_lu <- c('#0f6f09', '#7a8bff', '#1fff10', '#aa6510', '#0a2dd5', '#28b9ff', '#ff4be9', 
            "#f1ff18", '#f1ff18', '#f1ff18', '#ff8f1c', 'grey10', 'grey10', 'grey10')


sf_AD_pal <- sf_AD |>
  left_join(pal_redd, by = "redd_FRL")

pal <- colorFactor(pal_redd$redd_color, sf_AD$redd_FRL)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title or banner
  titlePanel(
    title = div(img(src="banner_en3.png", width = '100%')),
    windowTitle = "Timor Leste REDD+ Geoportal"
  ),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    sidebarPanel(
      
      ## Select base layer aka tiles
      selectInput(
        inputId = "basemap", 
        label = "Choose a base map layer",
        choices = c("ESRI gray canvas"   = "Esri.WorldGrayCanvas",
                    "ESRI World imagery" = "Esri.WorldImagery",
                     "OpenTopoMap"       = "OpenTopoMap",
                     "OpenStreetMap"     = "OpenStreetMap.Mapnik"),
        selected = "Esri.WorldGrayCanvas"
        ),
      
      hr(),
      
      h5("Add grid layouts"),
      checkboxInput(inputId = "grid_layout", label = "Show the Activity Data grid"),
      checkboxInput(inputId = "grid_square", label = "Show the Activity Data visual interpretation frames"),
      
      hr(),
      
      radioButtons(
        inputId = "AD_select", 
        label   = "Choose what information to display on the Activity Data", 
        choiceNames = list(
          "None",
          "REDD+ activities",
          "Annual land use"
        ), 
        choiceValues = list(
          "none",
          "redd_activity",
          "annual_lu"
        ), 
        selected = "none"
      )
      
      
    ), ## End sidebarPanel
    
    ## 
    
    # Show the leaflet
    mainPanel(
      
      leafletOutput("my_map", width = "100%", height = "80vh")
      
      )
    
  ) ## End sidebarLayout
)## End fluidPage

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$my_map = renderLeaflet({
    
    leaflet(options = leafletOptions(minZoom = 8)) |>
      addProviderTiles(layerId = "basemap", provider = "Esri.WorldGrayCanvas") |>
      setView(125, -9, zoom = 8) |>
      setMaxBounds(lng1 = 124, lat1 = -10, lng2 = 128, lat2 = -8)
    
    # tm_basemap(server = input$basemap) +
    #   tm_shape(sf_country) + tm_borders(col = "red") +
    #   tm_shape(sf_AD) + tm_polygons(col = "redd_FRL", border.col = NA, palette = pal_redd) +
    #   tm_shape(sf_AD_square) + tm_borders(col = "yellow")

  })
  
  ## Update basemap aka tiles
  observeEvent(input$basemap, {
    leafletProxy("my_map") |>
      removeTiles("basemap") |>
      addProviderTiles(layerId = "basemap", input$basemap)
  })
  
  ## Show/hide grid layout
  observeEvent(input$grid_layout, {
    #print(input$grid_layout)
    if(input$grid_layout){
      leafletProxy("my_map") |>
        addPolygons(data = sf_AD, group = "lf_grid_layout", fill = NA, color = "darkorange", weight = 0.8)
    } else {
      leafletProxy("my_map") |>
        clearGroup(group = "lf_grid_layout")
    }
  })
  
  ## Show/hide grid visual interpretation frames
  observeEvent(input$grid_square, {
    print(input$grid_square)
    if(input$grid_square){
      leafletProxy("my_map") |>
        addPolygons(data = sf_AD_square, group = "lf_AD_square", fill = NA, color = "red", weight = 2)
    } else {
      leafletProxy("my_map") |>
        clearGroup(group = "lf_AD_square")
    }
  })
  
  ## Show Activity Data
  observeEvent(input$AD_select, {
    
    if(input$AD_select == "none") {
      leafletProxy("my_map") |>
        clearGroup(group = "lf_redd_activity") |>
        clearGroup(group = "lf_annual_lu")
      
    } else if (input$AD_select == "redd_activity"){
      leafletProxy("my_map") |>
        clearGroup(group = "lf_annual_lu") |>
        addPolygons(
          data = sf_AD_pal, group = "lf_redd_activity", stroke = FALSE, smoothFactor = 0.3, 
          fillOpacity = 1, fillColor = ~pal(redd_FRL)
          ) |>
        addLegend(data = sf_AD_pal, pal = pal, values = ~redd_FRL, group = "lf_redd_activity",
                  position = "topright",
                  title = "REDD+ Activities",
                  opacity = 0.8
        )

    }
    
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
