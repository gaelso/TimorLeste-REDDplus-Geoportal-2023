

mod_portal_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ## UI elements wrapped in a tagList() function
  #tagList(
    
    card(full_screen = T, layout_sidebar(
      padding = 0, 
      
      ## Sidebar ###############################################################
      sidebar = sidebar(
        width = "336px",
        accordion(
          open = TRUE, #"accordion_hexmaps",
          multiple = TRUE,
          
          ## Basemap layer -------------------------------------------------------
          accordion_panel(
            title = i18n$t("Base map layers"),
            value = "accordion_basemap",
            layout_column_wrap(
              width = NULL,
              style = css(grid_template_columns = "5fr 1fr"),
              prettyRadioButtons(
                inputId = ns("basemap"), 
                label = NULL,
                choices = c("ESRI gray canvas"   = "Esri.WorldGrayCanvas",
                            "ESRI world imagery" = "Esri.WorldImagery",
                            #"OpenTopoMap"       = "OpenTopoMap",
                            "OpenStreetMap"     = "OpenStreetMap.Mapnik"),
                selected = "Esri.WorldGrayCanvas"
              ),
              actionButton(
                inputId = ns("info_layer"), 
                label = bsicons::bs_icon("info-circle", class = "text-primary", size = "20px"), 
                #class = "btn-primary",
                style = "padding:0; margin-left:auto; margin-bottom: auto; 
                line-height:20px !important; border:0; background-color:var(--bs-accordion-active-bg);"
              )
            )
          ),
          
          ## Grid layouts --------------------------------------------------------
          accordion_panel(
            title = i18n$t("Grid layouts"),
            value = "accordion_grids",
            layout_column_wrap(
              width = NULL,
              style = css(grid_template_columns = "5fr 1fr"),
              card(card_body(
                style = "padding:0;",
                fill = FALSE,
                fillable = FALSE,
                checkboxInput(
                  inputId = ns("grid_layout"), 
                  label = i18n$t("Activity Data sampling grid")
                ),
                checkboxInput(
                  inputId = ns("change_layout"), 
                  label = i18n$t("Activity Data changes")
                ),
                checkboxInput(
                  inputId = ns("grid_square"), 
                  label = i18n$t("Visual interpretation frames")
                )
              ), style = "border:0;", fill = FALSE, fillable = FALSE),
              actionButton(
                inputId = ns("info_grid"), 
                label = bsicons::bs_icon("info-circle", class = "text-primary", size = "20px"), 
                #class = "btn-primary",
                style = "padding:0; margin-left:auto; margin-bottom: auto; 
                line-height:20px !important; border:0; background-color:var(--bs-accordion-active-bg);"
              )
            )
          ),
          
          ## Hex maps ------------------------------------------------------------
          accordion_panel(
            title = i18n$t("Land use and land use change hexmaps"),
            value = "accordion_hexmaps",
            layout_column_wrap(
              width = NULL,
              style = css(grid_template_columns = "5fr 1fr"),
              prettyRadioButtons(
                inputId = ns("hexmap"),
                label = NULL,
                choices = c(
                  "None" = "none",
                  "REDD+ activities hexmap" = "redd_hex",
                  "Annual land use hexmap" = "lu_hex"
                ),
                selected = "none"
              ),
              actionButton(
                inputId = ns("info_redd"), 
                label = bsicons::bs_icon("info-circle", class = "text-primary", size = "20px"), 
                #class = "btn-primary",
                style = "padding:0; margin-left:auto; margin-bottom: auto; 
                line-height:20px !important; border:0; background-color:var(--bs-accordion-active-bg);"
              )
            ),
            
            ## ++ REDD+ activities controls ++
            shinyjs::hidden(sliderInput(
              inputId = ns("redd_opacity"), label = NULL, min = 0, max = 1, step = 0.1,
              value = 1, ticks = FALSE
            )),
            shinyjs::hidden(div(
              id = ns("redd_abbreviations"), 
              em(i18n$t("Legend abbreviations:")),
              p(em("AF = Afforestation, DF = Deforestation, SF = Stable Forest, SNF = Stable Non-Forest")),
              style = "font-size: small; margin-bottom: 1rem;" 
            )),
            
            ## ++ Land use annual controls ++ 
            shinyjs::hidden(sliderInput(
              inputId = ns("lu_opacity"), 
              label = NULL, min = 0, max = 1, step = 0.1, value = 1, 
              ticks = FALSE
            )),
            shinyjs::hidden(sliderInput(
              inputId = ns("lu_year"), 
              label = NULL, min = 2017, max = 2021, step = 1, value = 2021, 
              ticks = FALSE, sep = ""
            )),
            shinyjs::hidden(div(
              id = ns("lu_abbreviations"),
              em(i18n$t("Legend abreviations:")),
              p(em("FMH = Highland Moist Forest, FML = Lowland Moist Forest, FDL = Lowland Dry foret, FM = Montane Forest, FC = Coastal Forest, MF = Mangrove Forest, FP = Forest Plantation, G = Grassland, SH = Shrubland, OWL = Other Wooded Land, C = Cropland, S = Settlement, W = Wetland, O = Other Land")),
              style = "font-size: small; margin-bottom: 1rem;"
            ))
          )
        )
      ),
      
      ## Main panel
      leafletOutput(outputId = ns("map"))
      
    ))
    
  #) ## END tagList
  
} ## END module UI function