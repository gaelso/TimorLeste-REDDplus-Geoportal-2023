
mod_portal_server2 <- function(id, r_lang) {
  
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    ##
    ## OUTPUTS #################################################################
    ##
    
    output$map <- renderLeaflet({
      
      leaflet(options = leafletOptions(minZoom = 8), data = sf_AD2) |>
        addProviderTiles(layerId = "basemap", provider = "Esri.WorldGrayCanvas") |>
        setView(125, -9, zoom = 8) |>
        setMaxBounds(lng1 = 124, lat1 = -10, lng2 = 128, lat2 = -8) |>
        addPolygons(
          layerId = ~ID,
          color = NA,
          opacity = 0.6, 
          weight = 1, 
          smoothFactor = 0.5, 
          fillOpacity = 0.1, 
          fillColor = "white",
          options = pathOptions(interactive = FALSE)
          ) |>
        addPolygons(
          data = sf_country, 
          fill = NA, 
          color = "darkred", 
          weight = 1,
          options = pathOptions(interactive = FALSE)
          ) |>
        addPolygons(
          data = sf_AD_square, 
          group = "square_group", 
          fill = NA, 
          color = "white", 
          weight = 2,
          options = pathOptions(interactive = FALSE)
        ) |>
        hideGroup("square_group") |>
        addEasyButton(easyButton(
          icon="fa-globe", title="Reset view",
          onClick=JS("function(btn, map){ map.setZoom(8); }"))) |> 
        addScaleBar(
          position = "bottomright", 
          options = scaleBarOptions(imperial = FALSE, maxWidth = 120)
        )
        
    })
    
    outputOptions(output, "map", suspendWhenHidden = FALSE)
    
    ##
    ## REACTIVES ###############################################################
    ##
    
    r_hexcolor <- reactive({
      if (input$grid_layout) "darkorange" else NA
    })
  
    r_hexfill <- reactive({
      if (input$hexmap == "none") {
        "white"
      } else if (input$hexmap == "redd_hex") {
        sf_AD2$redd_color
      } else if (input$hexmap == "lu_hex") {
        sf_AD2 %>%
          dplyr::select(id, lu_id = sym(paste0("lu_end", input$lu_year))) %>%
          left_join(palette_lu, by = "lu_id") %>%
          pull(lu_color)
      }
    })
    
    r_hexopacity <- reactive({
      if (input$hexmap == "none") {
        0.1
      } else if (input$hexmap == "redd_hex") {
        input$redd_opacity
      } else if (input$hexmap == "lu_hex") {
        input$lu_opacity
      }
    })
    
    ##
    ## OBSERVERS ###############################################################
    ##
    
    ## Update basemap aka tiles ------------------------------------------------
    observe({
      leafletProxy("map") |>
        removeTiles("basemap") |>
        addProviderTiles(layerId = "basemap", input$basemap)
    })
    
    ## Hexmap changes ----------------------------------------------------------
    observe({
      leafletProxy("map", data = sf_AD2) |>
        setShapeStyle(
          layerId = ~ID, fillColor = r_hexfill(), fillOpacity = r_hexopacity(),
          color = r_hexcolor()
        )
    })
    
    ## Add Legend --------------------------------------------------------------
    observeEvent(input$hexmap, {
      
      if (input$hexmap == "none") {
        leafletProxy("map", data = sf_AD2) |>
          removeControl(layerId = "redd_legend") |>
          removeControl(layerId = "lu_legend")
        
      } else if (input$hexmap == "redd_hex") {
        leafletProxy("map", data = sf_AD2) |>
          removeControl(layerId = "lu_legend") |>
          addLegend(
            layerId = "redd_legend", colors = palette_redd$redd_color, labels = palette_redd$redd_FRL,
            position = "topright", title = NA, opacity = 0.8
          )
        
      } else if (input$hexmap == "lu_hex") {
        leafletProxy("map", data = sf_AD2) |>
          removeControl(layerId = "redd_legend") |>
          addLegend(
            layerId = "lu_legend", colors = palette_lu$lu_color, labels = palette_lu$lu_id,
            position = "topright", title = NA, opacity = 0.8
          )
      }
      
    })
    
    ## Show/hide panel ---------------------------------------------------------
    observeEvent(input$hexmap, {

      if (input$hexmap == "redd_hex") {
        shinyjs::hide("lu_opacity")
        shinyjs::hide("lu_year")
        shinyjs::hide("lu_abbreviations")
        shinyjs::show("redd_opacity")
        shinyjs::show("redd_abbreviations")
        
      } else if (input$hexmap == "lu_hex") {
        shinyjs::hide("redd_opacity")
        shinyjs::hide("redd_abbreviations")
        shinyjs::show("lu_opacity")
        shinyjs::show("lu_year")
        shinyjs::show("lu_abbreviations")
        
      } else if (input$hexmap == 'none') {
        shinyjs::hide("redd_opacity")
        shinyjs::hide("redd_abbreviations")
        shinyjs::hide("lu_opacity")
        shinyjs::hide("lu_year")
        shinyjs::hide("lu_abbreviations")
        
      }
      
    })
    
    ## Show/hide square  frames ------------------------------------------------
    ## Sampling grid grid visual interpretation frames
    observeEvent(input$grid_square, {
      if(input$grid_square){
        leafletProxy("map") |> showGroup(group = "square_group")
      } else {
        leafletProxy("map") |> hideGroup(group = "square_group")
      }
    })
    
    ## Show/hide change Hexagons -----------------------------------------------
    observeEvent({
      input$change_layout
      r_lang()
      }, {
      if(input$change_layout & r_lang() == "en"){
        leafletProxy("map") |> 
          clearGroup(group = "change_group_te") |>
          addPolygons(
            data = sf_change,
            group = "change_group_en",
            #fillColor = "white",
            fillOpacity = 0,
            opacity = 1,
            color = "#FF1493",
            weight = 2,
            highlightOptions = highlightOptions(
              color = "#FF1493", weight = 4, bringToFront = TRUE
            ),
            popup = sf_change$label_en,
            popupOptions = popupOptions(closeButton = FALSE)
          )
      } else if(input$change_layout & r_lang() == "te"){
        leafletProxy("map") |> 
          clearGroup(group = "change_group_en") |>
          addPolygons(
            data = sf_change,
            group = "change_group_te",
            #fillColor = "white",
            fillOpacity = 0,
            opacity = 1,
            color = "#FF1493",
            weight = 2,
            highlightOptions = highlightOptions(
              color = "#FF1493", weight = 4, bringToFront = TRUE
            ),
            popup = sf_change$label_te,
            popupOptions = popupOptions(closeButton = FALSE)
          )
      } else {
        leafletProxy("map") |> 
          clearGroup(group = "change_group_en") |>
          clearGroup(group = "change_group_te")
      }
    })
  
    
    
  }) ## END module server function
  
}