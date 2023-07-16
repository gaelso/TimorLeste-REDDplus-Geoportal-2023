
mod_home_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ##
  ## UI Elements ###############################################################
  ##
  
  ## Intro ---------------------------------------------------------------------
  home_intro <- card(
    class = "--bs-dark",
    #card_header(h4("Welcome to Timor Leste REDD+ Geoportal")),
    img(
      src = "banner_en3.png",
      style = "width: 100%; max-width: 1200px; margin-left: auto; margin-right: auto;"
    ),
    h4("Welcome!"),
    p("This portal shows spatial data and tables from Timor Leste National Forest Monitoring System (NFMS)."), 
    p("The information presented here shows how human activities in Timor Leste Forests, for example deforestation or afforestation, contribute to climate change."),
    p("This information is part of the REDD+ mechanism to fight against climate change, as introduced by the United Nations Framework Convention on Climate Change.")
  )
  
  ## Highlights ----------------------------------------------------------------
  home_highlights <-  card(
    layout_column_wrap(
      width = "240px",
      #height = "240px", 
      fill = FALSE,
      style = "margin-top: auto; margin-bottom: auto;",
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
  
  ## Spatial -------------------------------------------------------------------
  home_spatial <- card(
    h5("Spatial data"),
    p("The REDD+ Geoportal displays spatial information on land use and land use change during the reference period 2017-2021."),
    p("It includes the hexagonal sampling grid for activity data and the visual interpretation results: annual land use and REDD+ activities"),
    p("To see the data go to:"),
    p("PORTAL")
  )
  
  ## Calculations --------------------------------------------------------------
  home_calc <- card(
    h5("Calculations"),
    p("The spatial data is interpreted into annual land use change matrices (Activity Data) and completed by carbon stock changes associated with each category of land use change (Emission Factors)."),
    # p("When sampling points (both activity data and forest inventory plots) values are aggregated, the sampling uncertainty is added."),
    p("The matrices are then aggregated into annual greenhouse gas emissions and removals from the forestry sector."),
    p("To see the matrices and carbon accounting results, go to:"), 
    p("CALCULATIONS")
  )
  
  ## About ---------------------------------------------------------------------
  home_about <- card(
    h5("About"),
    p("This portal was developed to improve Transparency on greenhouse gas emissions and removals of Timor Leste's forestry sector."),
    p("The portal aslo includes information on the context around this portal, what is REDD+, some of the technical terms associated, as well as the methods for data collection and analysis."),
    p("To access to this information, go to:"),
    p("ABOUT")
  )
  
  ##
  ## UI organization ###########################################################
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