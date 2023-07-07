

mod_portal_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ## UI elements wrapped in a tagList() function
  #tagList(
    
    card(layout_sidebar(
      
      ## Sidebar ###############################################################
      sidebar = accordion(
        open = "accordion_lulucf",
        
        ## Basemap layer -------------------------------------------------------
        accordion_panel(
          title = i18n$t("Base map layers"),
          value = "accordion_basemap",
          radioButtons(
            inputId = ns("basemap"), 
            label = NULL,
            choices = c("ESRI gray canvas"   = "Esri.WorldGrayCanvas",
                        "ESRI world imagery" = "Esri.WorldImagery",
                        "OpenTopoMap"       = "OpenTopoMap",
                        "OpenStreetMap"     = "OpenStreetMap.Mapnik"),
            selected = "Esri.WorldGrayCanvas"
          )
        ),
        
        ## Grid layouts --------------------------------------------------------
        accordion_panel(
          title = i18n$t("Grid layout"),
          value = "accordion_grids",
          checkboxInput(
            inputId = ns("grid_layout"), 
            label = i18n$t("Activity Data grid")
            ),
          checkboxInput(
            inputId = ns("grid_square"), 
            label = i18n$t("Activity Data visual interpretation frames")
          )
        ),
        
        ## Hex maps ------------------------------------------------------------
        accordion_panel(
          title = i18n$t("Land use and land use change"),
          value = "accordion_lulucf",
          
          ## Lannd use channge Hexes
          checkboxInput(
            inputId = ns("grid_luc"), 
            label = i18n$t("REDD+ activities hex map")
          ),
          shinyjs::hidden(sliderInput(
            inputId = ns("grid_luc_tr"), label = NULL, min = 0, max = 1, step = 0.1,
            value = 1, ticks = FALSE,
          )),
          shinyjs::hidden(div(
            id = ns("legend_luc"), 
            em(i18n$t("Legend: AF = Afforestation, DF = Deforestation, SF = Stable Forest, SNF = Stable Non-Forest"))
          )),
          
          ## Land use annual 
          checkboxInput(
            inputId = ns("grid_lu"), 
            label = i18n$t("Annual land use hex map")
            ),
          shinyjs::hidden(sliderInput(
            inputId = ns("grid_lu_tr"), 
            label = NULL, min = 0, max = 1, step = 0.1, value = 1, 
            ticks = FALSE, 
          )),
          shinyjs::hidden(sliderInput(
            inputId = ns("grid_lu_year"), 
            label = NULL, min = 2017, max = 2021, step = 1, value = 2021, 
            ticks = FALSE, sep = ""
          )),
          shinyjs::hidden(div(
            id = ns("legend_lu"),
            em(i18n$t("Legend: FMH = Highland Moist Forest, FML = Lowland Moist Forest, FDL = Lowland Dry foret, FM = Montane Forest, FC = Coastal Forest, MF = Mangrove Forest, FP = Forest Plantation, G = Grassland, SH = Shrubland, OWL = Other Wooded Land, C = Cropland, S = Settlement, W = Wetland, O = Other Land"))
          ))
        )
      ),
      
      ## Main panel
      leafletOutput(outputId = ns("my_map"))
      
    ))
    
  #) ## END tagList
  
} ## END function home_UI()