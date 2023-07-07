
mod_portal_server <- function(id) {
  
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    ## OUTPUTS #################################################################
    output$my_map <- renderLeaflet({
      leaflet(options = leafletOptions(minZoom = 8)) |>
        addProviderTiles(layerId = "basemap", provider = "Esri.WorldGrayCanvas") |>
        setView(125, -9, zoom = 8) |>
        setMaxBounds(lng1 = 124, lat1 = -10, lng2 = 128, lat2 = -8) #|>
        # leaflet.multiopacity::addOpacityControls(
        #   group = c("lf_grid_luc"),
        #   renderOnLayerAdd = TRUE
        # )
                                                 
    })
    
    ## OBSERVERS ###############################################################
    
    ## Update basemap aka tiles ------------------------------------------------
    observeEvent(input$basemap, {
      leafletProxy("my_map") |>
        removeTiles("basemap") |>
        addProviderTiles(layerId = "basemap", input$basemap)
    })
    
    ## Show/hide grid layout ------------------------------------------------
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
    
    ## Show/hide grid visual interpretation frames
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
    
    ## LULUCF ##################################################################
    
    ## Land use change ---------------------------------------------------------
    observeEvent({
      input$grid_luc
      input$grid_luc_tr
    }, {
      if(input$grid_luc) {
        shinyjs::show("grid_luc_tr")
        shinyjs::show("legend_luc")
        pal_luc <- colorFactor(palette_redd, sf_AD$redd_FRL)
        leafletProxy("my_map") |>
          clearGroup(group = "lf_grid_luc") |>
          clearControls() |>
          # addPolygons(
          #   data = sf_AD, group = "lf_grid_luc", stroke = FALSE, smoothFactor = 0.3,
          #   fillColor = ~pal_luc(redd_FRL), fillOpacity = 1
          # ) |>
          addPolygons(
            data = sf_AD, group = "lf_grid_luc", stroke = FALSE, smoothFactor = 0.3,
            fillColor = ~pal_luc(redd_FRL), fillOpacity = input$grid_luc_tr
          ) |>
          addLegend(
            data = sf_AD, pal = pal_luc, values = ~redd_FRL, group = "lf_grid_luc",
            position = "topright", title = NA, opacity = 0.8
          )
      } else {
        shinyjs::hide("grid_luc_tr")
        shinyjs::hide("legend_luc")
        leafletProxy("my_map") |>
          clearGroup(group = "lf_grid_luc") |>
          clearControls()
      }
    })
    
    ## Land use annual ---------------------------------------------------------
    observeEvent({
      input$grid_lu
      input$grid_lu_tr
      input$grid_lu_year
    }, {
      # print(input$grid_lu_tr)
      
      sf_lu <- sf_AD %>% 
        dplyr::select(id, lu_id = sym(paste0("lu_end", input$grid_lu_year))) %>%
        left_join(lu_conv, by = "lu_id") %>%
        mutate(land_use = forcats::fct_reorder(lu_id, lu_no))
      
      pal_lu <- colorFactor(palette_lu, sf_lu$land_use)
      
      if(input$grid_lu) {
        shinyjs::show("grid_lu_tr")
        shinyjs::show("grid_lu_year")
        shinyjs::show("legend_lu")
        leafletProxy("my_map") |>
          clearGroup(group = "lf_grid_lu") |>
          clearControls() |>
          addPolygons(
            data = sf_lu, group = "lf_grid_lu", stroke = FALSE, smoothFactor = 0.3,
            fillOpacity = input$grid_lu_tr, fillColor = ~pal_lu(land_use)
          ) |>
          addLegend(
            data = sf_lu, pal = pal_lu, values = ~land_use, group = "lf_grid_lu",
            position = "topright", title = NA, opacity = 0.8
          )
      } else {
        shinyjs::hide("grid_lu_tr")
        shinyjs::hide("grid_lu_year")
        shinyjs::hide("legend_lu")
        leafletProxy("my_map") |>
          clearGroup(group = "lf_grid_lu") |>
          clearControls()
      }
    })
    
  }) ## END module server function
  
}