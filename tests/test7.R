

library(shiny)
library(leaflet)
library(mapview) #to get the franconia dataset
library(htmltools)

colors <- colorFactor(palette = c("Red", "Green", "Blue"),
                      levels = c("Oberfranken","Mittelfranken", "Unterfranken"))

ui <- fluidPage(
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    
    sidebarPanel(
      sliderInput(
        inputId = "opacity_sliderinput", label = NULL, min = 0, max = 1, step = 0.1, 
        value = 1, ticks = FALSE 
      )
    ), ## End sidebarPanel
    
    mainPanel(
      leafletOutput("my_map", width = "100%", height = "100vh")
    )
    
  ) ## End sidebarLayout
)## End fluidPage



##
## Server ######################################################################
##

server <- function(input, output) {
  
  output$my_map = renderLeaflet({
    
    leaflet() %>% 
      addProviderTiles("CartoDB.Positron", group = "CartoDB.Positron")
  })
  
  
  observeEvent(input$opacity_sliderinput, {
    
    leafletProxy("my_map") %>%
      clearGroup("Districts") %>%
      addPolygons(data = franconia, fillColor = ~colors(district), weight =  1, group = "Districts",
                  fillOpacity = input$opacity_sliderinput
      )
  })
  
}



##
## Run the application #########################################################
##

shinyApp(ui = ui, server = server)




