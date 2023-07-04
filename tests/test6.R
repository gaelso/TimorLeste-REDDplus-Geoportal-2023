
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
    
    franconia %>% leaflet() %>% 
      addProviderTiles("CartoDB.Positron", group = "CartoDB.Positron") %>% 
      addPolygons(fillColor = ~colors(district),weight =  1, group = "Districts") %>%
      addPolygons(label = ~NAME_ASCI,weight =  1, group = "Names", fillColor = "Grey") %>%
      addLayersControl(baseGroups = "CartoDB.Positron",overlayGroups = c("Districts", "Names"),position = "topleft")
  })
  
  
  observeEvent(input$opacity_sliderinput, {
    
    leafletProxy("my_map") %>%
      
      removeControl("opacity_slide") %>%
      addControl(layerId = "opacity_slide", html = "<input id=\"OpacitySlide\" type=\"range\" min=\"0\" max=\"1\" step=\"0.1\" value=\"0.5\">") %>%   # Add Slider
      htmlwidgets::onRender(
        "function(el,x,data){
                     var map = this;
                     var evthandler = function(e){
                        var layers = map.layerManager.getVisibleGroups();
                        console.log('VisibleGroups: ', layers); 
                        console.log('Target value: ', +e.target.value);
                        layers.forEach(function(group) {
                          var layer = map.layerManager._byGroup[group];
                          console.log('currently processing: ', group);
                          Object.keys(layer).forEach(function(el){
                            if(layer[el] instanceof L.Polygon){;
                            console.log('Change opacity of: ', group, el);
                             layer[el].setStyle({fillOpacity:+e.target.value});
                            }
                          });
                          
                        })
                     };
              $('#OpacitySlide').mousedown(function () { map.dragging.disable(); });
              $('#OpacitySlide').mouseup(function () { map.dragging.enable(); });
              $('#OpacitySlide').on('input', evthandler)}
          ")
    
  })
  
}



##
## Run the application #########################################################
##

shinyApp(ui = ui, server = server)


