
mod_home_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ##
  ## UI Elements #################################################################
  ##
  
  ## Intro -----------------------------------------------------------------------
  home_intro <- card(
    class = "bg-light",
    #card_header(h4("Welcome to Timor Leste REDD+ Geoportal")),
    img(
      src = "banner_en3.png",
      style = "width: 100%; max-width: 1200px; margin-left: auto; margin-right: auto;"
    ),
    h4("Welcome!"),
    p("This portal shows spatial data and tables from Timor Leste National Forest Monitoring System (NFMS)."), 
    p("The information presented here is used for Timor Leste engagment in REDD+, the mechanism to reduce greenhouse gas (GHG) emissions from Deforestation, Forest Degradation, plus the role of sustainable forest management, conservation and enhancement of forest carbon stocks."),
    
  )
  
  ## Highlights -------------------------------------------------------------------
  home_highlights <-  card(
    layout_column_wrap(
      width = "240px",
      #height = "240px", 
      fill = FALSE,
      value_box(
        title = "FREL",
        value = "412,532",
        showcase = bsicons::bs_icon("arrow-up", size = NULL),
        theme_color = "secondary"
      ),
      value_box(
        title = "Removals",
        value = "-747,694",
        showcase = bsicons::bs_icon("arrow-down", size = NULL),
        theme_color = "primary"
      ),
      value_box(
        title = "FRL",
        value = "-335,162",
        showcase = bsicons::bs_icon("arrow-down-up", size = NULL),
        theme_color = "info"
      )
    ),
    div(
      em("Forest Reference (Emission) Levels 2017-2021 (tCO2e/year)"),
      style = "text-align: center; font-size: small;"
    )
  )
  
  ## Spatial ---------------------------------------------------------------------
  home_spatial <- card(
    h5("Spatial data"),
    p("The REDD+ geoportal displays spatial information on land use and land use change during the reference period 2017-2021."),
    p("It includes the hexagonal sampling grid for activity data and the visual interpretation results: annual land use and REDD+ activities"),
    p("")
  )
  ## Tables ----------------------------------------------------------------------
  home_calc <- card(
    h5("Calculations"),
    p("The spatial data is interpreted into annual land use change matrices and completed by carbon stock change associated with each category of land use change."),
    p("When sampling points (both activity data and forest inventory plots) values are agregated, the sampling uncertainty is added."),
    p("The matrices are then further aggregated to REDD+ activities per year and their average emissions and removals over the reference period."),
    p("To see the matrices and carbon accounting results, go to: CALCULATIONS"),
  )
  ## About -----------------------------------------------------------------------
  home_about <- card(
    h5("About"),
    p("The data presented here are average levels of GHG emissions and removals from REDD+ activities, in tCO2e/year, used as a baseline (or reference level) against which future performances on emission reductions can be compared."),
    p("More information about REDD+, methods for carbon accounting and REDD+ GHG emissions and removals go to: ABOUT"),
  )
  
  ##
  ## UI organization #############################################################
  ##
  
  # UI elements wrapped in a tagList() function
  tagList(
    
    layout_column_wrap(
      width = "300px",
      home_intro,
      home_highlights,
    ),
    
    br(),
    
    layout_column_wrap(
      width = "200px",
      home_spatial,
      home_calc,
      home_about
    ), 
    
    br()
    
  )
  
} ## END module UI function

# tagList(
# 
#   ## FREL/FRL cards --------------------------------------------------------
#   card(
#     layout_columns(
#       fill = FALSE,
#       value_box(
#         title = "FREL",
#         value = "412,532",
#         showcase = bsicons::bs_icon("arrow-up", size = NULL),
#         theme_color = "secondary"
#       ),
#       value_box(
#         title = "Removals",
#         value = "-747,694",
#         showcase = bsicons::bs_icon("arrow-down", size = NULL),
#         theme_color = "primary"
#       ),
#       value_box(
#         title = "FRL",
#         value = "-335,162",
#         showcase = bsicons::bs_icon("arrow-down-up", size = NULL),
#         theme_color = "info"
#       )
#     ),
# 
#     div(
#       em("Forest Reference (Emission) Levels 2017-2021 (tCO2e/year)"),
#       style = "text-align: center; font-size: small;"
#     )
# 
#   ),
# 
#   ## Intro -----------------------------------------------------------------
#   card(
#     #card_header(h4("Welcome to Timor Leste REDD+ Geoportal")),
#     img(
#       src = "banner_en3.png",
#       style = "width: 100%; max-width: 1200px; margin-left: auto; margin-right: auto;"
#     ),
#     h4("Welcome!"),
#     p("This portal shows spatial data and tables related to Timor Leste engagment in REDD+, the mechanism to reduce greenhouse gas (GHG) emissions from Deforestation, Forest Degradation, plus the role of sustainable forest management, conservation and enhancement of forest carbon stocks.")
#   ),
# 
#   ## Details ---------------------------------------------------------------
#   card(
#     h5("Presentation of the data"),
#     p("More specifically the data presented here are average levels of GHG emissions and removals from REDD+ activities, in tCO2e/year, used as a baseline or reference level against which future performances on emission reductions can be compared."),
#     h4(
#       "Placeholder for home content",
#       style = "text-align: center; margin-top: auto; margin-bottom: auto;"
#     ),
#   )
# )