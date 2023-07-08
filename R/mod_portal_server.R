
mod_portal_server <- function(id) {
  
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    ## OUTPUTS #################################################################
    output$my_map <- renderLeaflet({
      leaflet(options = leafletOptions(minZoom = 8)) |>
        addProviderTiles(layerId = "basemap", provider = "Esri.WorldGrayCanvas") |>
        setView(125, -9, zoom = 8) |>
        setMaxBounds(lng1 = 124, lat1 = -10, lng2 = 128, lat2 = -8) |>
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
              $('#tab_portal-redd_opacity').on('shiny:inputchanged', evthandler);
              $('#tab_portal-lu_opacity').on('shiny:inputchanged', evthandler)}
          ")
                                                 
    })
    
    ## OBSERVERS ###############################################################
    
    ## Update basemap aka tiles ------------------------------------------------
    observeEvent(input$basemap, {
      leafletProxy("my_map") |>
        removeTiles("basemap") |>
        addProviderTiles(layerId = "basemap", input$basemap)
    })
    
    ## Show/hide grid layout ------------------------------------------------
    ## Sampling grid hexagons
    observeEvent(input$grid_layout, {
      if(input$grid_layout){
        leafletProxy("my_map") |>
          addPolygons(
            data = sf_AD, group = "lf_grid_layout", fill = NA, color = "darkorange", weight = 1
          )
      } else {
        leafletProxy("my_map") |>
          clearGroup(group = "lf_grid_layout")
      }
    })
    
    ## Sampling grid grid visual interpretation frames
    observeEvent(input$grid_square, {
      if(input$grid_square){
        leafletProxy("my_map") |>
          addPolygons(
            data = sf_AD_square, group = "lf_AD_square", fill = NA, color = "red", weight = 2
          )
      } else {
        leafletProxy("my_map") |>
          clearGroup(group = "lf_AD_square")
      }
    })
    
    ## Land use and land use change --------------------------------------------
    ## ++ REDD+ Activities ++
    observeEvent(input$redd_hex, {
      if(input$redd_hex) {
        shinyjs::show("redd_opacity")
        shinyjs::show("redd_legend")
        pal_luc <- colorFactor(palette_redd, sf_AD$redd_FRL)
        leafletProxy("my_map") |>
          # clearGroup(group = "lf_grid_luc") |>
          clearControls() |>
          addPolygons(
            data = sf_AD, group = "lf_grid_luc", stroke = FALSE, smoothFactor = 0.3,
            fillColor = ~pal_luc(redd_FRL), fillOpacity = input$redd_opacity
          ) |>
          addLegend(
            data = sf_AD, pal = pal_luc, values = ~redd_FRL, group = "lf_grid_luc",
            position = "topright", title = NA, opacity = 0.8
          )
      } else {
        shinyjs::hide("redd_opacity")
        shinyjs::hide("redd_legend")
        leafletProxy("my_map") |>
          clearGroup(group = "lf_grid_luc") |>
          clearControls()
      }
    })
    
    ## ++ Land use annual ++
    observeEvent({
      input$lu_hex
      input$lu_year
    }, {
      
      sf_lu <- sf_AD %>% 
        dplyr::select(id, lu_id = sym(paste0("lu_end", input$lu_year))) %>%
        left_join(lu_conv, by = "lu_id") %>%
        mutate(land_use = forcats::fct_reorder(lu_id, lu_no))
      
      pal_lu <- colorFactor(palette_lu, sf_lu$land_use)
      
      if(input$lu_hex) {
        shinyjs::show("lu_opacity")
        shinyjs::show("lu_year")
        shinyjs::show("lu_legend")
        leafletProxy("my_map") |>
          clearGroup(group = "lf_lu_hex") |>
          clearControls() |>
          addPolygons(
            data = sf_lu, group = "lf_lu_hex", stroke = FALSE, smoothFactor = 0.3,
            fillOpacity = input$lu_opacity, fillColor = ~pal_lu(land_use)
          ) |>
          addLegend(
            data = sf_lu, pal = pal_lu, values = ~land_use, group = "lf_lu_hex",
            position = "topright", title = NA, opacity = 0.8
          )
      } else {
        shinyjs::hide("lu_opacity")
        shinyjs::hide("lu_year")
        shinyjs::hide("lu_legend")
        leafletProxy("my_map") |>
          clearGroup(group = "lf_lu_hex") |>
          clearControls()
      }
    })
    
  }) ## END module server function
  
}