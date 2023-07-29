
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
    img(
      src = "banner.png",
      style = "width: 100%; max-width: 1200px; margin-left: auto; margin-right: auto;"
    ),
    div(
      id = ns("intro_en"),
      h1("Welcome!"),
      p(tags$b("Timor Leste REDD+ Geoportal"), "shows spatial and tabular data from Timor Leste National Forest Monitoring System (NFMS) in an interactive way."), 
      p("It provides insights on how human activities in Timor Leste forests, for example deforestation or afforestation, contribute to climate change."),
      #p("This information is part of the REDD+ mechanism to fight against climate change, as introduced by the United Nations Framework Convention on Climate Change (UNFCCC)."),
      p("The data presented here was submitted to the United Nations Framework Convention on Climate Change in January 2023. The submission document and its technical assessment can be found in their repository:"),
      tags$a(href = "https://redd.unfccc.int/submissions.html?country=tls", "https://redd.unfccc.int/submissions.html?country=tls")
    ),
    shinyjs::hidden(div(
      id = ns("intro_te"),
      h4("Benvimdu!"),
      h6("TO BE TRANSLATED", style = "text-align:center;"),
      p("This portal shows spatial and  tabular data from Timor Leste National Forest Monitoring System (NFMS)."), 
      p("The information presented here shows how human activities in Timor Leste Forests, for example deforestation or afforestation, contribute to climate change."),
      p("This information is part of the REDD+ mechanism to fight against climate change, as introduced by the United Nations Framework Convention on Climate Change.")
    ))
  )
  
  ## Highlights ----------------------------------------------------------------
  home_highlights <-  card(
    layout_column_wrap(
      width = "280px",
      #fixed_width = TRUE,
      #height = "240px", 
      fill = FALSE,
      style = "margin-top: auto; margin-bottom: auto;",
      value_box(
        title = i18n$t("FREL (tCO2/y)"),
        value = "412,532",
        showcase = bsicons::bs_icon("arrow-up", size = NULL),
        theme_color = "danger"
      ),
      value_box(
        title = i18n$t("FRL (tCO2/y)"),
        value = "-335,162",
        showcase = bsicons::bs_icon("arrow-down-up", size = NULL),
        theme_color = "info"
      )
    ),
    layout_column_wrap(
      width = "280px",
      #fixed_width = TRUE,
      #height = "240px", 
      fill = FALSE,
      style = "margin-top: auto; margin-bottom: auto;",
      value_box(
        title = i18n$t("Deforestation (ha/y)"),
        value = "711",
        showcase = vb_df,
        full_screen = TRUE,
        theme_color = "secondary"
      ),
      value_box(
        title = i18n$t("Afforestation (ha/y)"),
        value = "9,311",
        showcase = vb_af,
        full_screen = TRUE,
        theme_color = "primary"
      )
    ),
    div(
      em(i18n$t("Average Forest area change and Forest Reference (Emission) Levels 2017-2021.")),
      style = "text-align: center; font-size: small;"
    )
  )
  
  ## Spatial -------------------------------------------------------------------
  home_spatial <- card(
    div(
      id = ns("spatial_en"),
      h5("Spatial data"),
      p("The REDD+ Geoportal displays spatial information on land use and land use change during the reference period 2017-2021."),
      p("It includes:"),
      tags$ul(
        tags$li("Base layers to switch between canvas, high resolution images and OpenStreetMap."),
        tags$li("The hexagonal sampling grid for land use and land use change visual interpretation, including additional information on the hexagons were change was detected."),
        tags$li("Visual interpretation results: annual land use and REDD+ activities.")
      )
    ),
    shinyjs::hidden(div(
      id = ns("spatial_te"),
      h5("Spatial data"),
      h6("TO BE TRANSLATED", style = "text-align:center;"),
      h5("Spatial data"),
      p("The REDD+ Geoportal displays spatial information on land use and land use change during the reference period 2017-2021. It includes:"),
      tags$ul(
        tags$li("Base layers to switch between canvas, high resolution images and OpenStreetMap."),
        tags$li("The hexagonal sampling grid for land use and land use change visual interpretation, including additional information on the hexagons were change was detected."),
        tags$li("Visual interpretation results: annual land use and REDD+ activities.")
      )
    )),
    actionButton(
      inputId = ns("to_portal"), 
      label = i18n$t("go to Portal"), 
      class = "btn-primary",
      style = "width: 128px; margin: auto"
      )
  )
  
  ## Calculations --------------------------------------------------------------
  home_calc <- card(
    div(
      id = ns("calc_en"),
      h5("Calculations"),
      p("The spatial data is converted to annual land use change matrices (Activity Data) and completed by carbon stock changes associated with each category of land use change (Emission Factors)."),
      # p("When sampling points (both activity data and forest inventory plots) values are aggregated, the sampling uncertainty is added."),
      p("The matrices are then aggregated into annual greenhouse gas emissions and removals from the forestry sector."),
      p("To see the matrices and carbon accounting results, go to:")
    ),
    shinyjs::hidden(div(
      id = ns("calc-te"),
      h6("TO BE TRANSLATED", style = "text-align:center;"),
      h5("Calculations"),
      p("The spatial data is converted to annual land use change matrices (Activity Data) and completed by carbon stock changes associated with each category of land use change (Emission Factors)."),
      # p("When sampling points (both activity data and forest inventory plots) values are aggregated, the sampling uncertainty is added."),
      p("The matrices are then aggregated into annual greenhouse gas emissions and removals from the forestry sector and their average over the reference period consitute the FREL/FRL."),
      p("See the data in the Calculation tab.")
    )),
    actionButton(
      inputId = ns("to_calc"), 
      label = i18n$t("go to Calculations"), 
      class = "btn-primary",
      style = "width: 128px; margin: auto"
      )
  )
  
  ## About ---------------------------------------------------------------------
  home_info <- card(
    div(
      id = ns("info_en"),
      h5("More information"),
      p("This portal was developed to improve transparency on greenhouse gas emissions and removals of Timor Leste's forestry sector."),
      p("It also includes information on the context around this portal, what is REDD+, some of the technical terms associated, as well as the methods for data collection and analysis."),
      p("Find out more in the Info tab.")
    ),
    shinyjs::hidden(div(
      id = ns("info_te"),
      h6("TO BE TRANSLATED", style = "text-align:center;"),
      h5("More information"),
      p("This portal was developed to improve transparency on greenhouse gas emissions and removals of Timor Leste's forestry sector."),
      p("The portal also includes information on the context around this portal, what is REDD+, some of the technical terms associated, as well as the methods for data collection and analysis."),
      p("To access to this information, go to:")
    )),
    actionButton(
      inputId = ns("to_info"), 
      label = i18n$t("More information"), 
      class = "btn-primary",
      style = "width: 128px; margin: auto"
    )
  )
  
  ##
  ## UI organization ###########################################################
  ##
  
  # UI elements wrapped in a tagList() function
  tagList(
    
    layout_column_wrap(
      width = "300px",
      #style = css(grid_template_columns = "7fr 5fr"),
      home_intro,
      home_highlights,
    ),
    
    br(),
    
    layout_column_wrap(
      width = "200px",
      home_spatial,
      home_calc,
      home_info
    ), 
    
    br()
    
  )
  
} ## END module UI function
