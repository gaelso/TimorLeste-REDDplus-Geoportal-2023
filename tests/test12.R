library(shiny)
library(leaflet)
library(mapview) #to get the franconia dataset
library(htmltools)

colors <- colorFactor(palette = c("Red", "Green", "Blue"),
                      levels = c("Oberfranken","Mittelfranken", "Unterfranken"))

module_UI <- function(id){
  ns <- NS(id)
  sidebarLayout(
    sidebarPanel(
      checkboxInput(inputId = ns("add_layer"), label = "Add layer"),
      shinyjs::hidden(sliderInput(
        inputId = ns("opacity_sliderinput"), label = NULL, min = 0, max = 1, step = 0.1, 
        value = 1, ticks = FALSE 
      ))
    ),
    mainPanel(
      leafletOutput(outputId = ns("my_map"), width = "100%", height = "100vh")
    )
  )
}

module_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    output$my_map = renderLeaflet({
      leaflet() %>% 
        addProviderTiles("CartoDB.Positron", group = "CartoDB.Positron") %>% 
        # addLayersControl(baseGroups = "CartoDB.Positron",overlayGroups = c("Districts", "Names"),position = "topleft") %>%
        htmlwidgets::onRender(
          "function(el,x,data){
                     var map = this;
                     var evthandler = function(e){
                        console.log('hello world');
                        var layers = map.layerManager.getVisibleGroups();
                        console.log('VisibleGroups: ', layers); 
                        console.log('Target value: ', +e.value);
                        layers.forEach(function(group) {
                          var layer = map.layerManager._byGroup[group];
                          console.log('currently processing: ', group);
                          Object.keys(layer).forEach(function(el){
                            if(layer[el] instanceof L.Polygon){;
                            console.log('Change opacity of: ', group, el);
                             layer[el].setStyle({fillOpacity:+e.value});
                            }
                          });
                          
                        })
                     };
              $('#test-opacity_sliderinput').on('shiny:inputchanged', evthandler)}
          ")
    })
    
    observeEvent(input$add_layer, {
      if(input$add_layer){
        shinyjs::show("opacity_sliderinput")
        leafletProxy("my_map") %>%
          addPolygons(data = franconia, fillColor = ~colors(district), fillOpacity = input$opacity_sliderinput, weight =  1, group = "Districts", label = ~NAME_ASCI)
      } else {
        shinyjs::hide("opacity_sliderinput")
        leafletProxy("my_map") %>%
          clearGroup("Districts")
      }
      
    })
    
  })
}


ui <- fluidPage(
  shinyjs::useShinyjs(),
  module_UI("test")
  
)


server <- function(input, output) {
  
  module_server("test")
  
}

shinyApp(ui = ui, server = server)