

mod_home_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ## UI elements wrapped in a tagList() function
  tagList(
    
      ## FREL/FRL cards --------------------------------------------------------
      card(
        layout_columns(
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
        
      ),
      
      ## Intro -----------------------------------------------------------------
      card(
        #card_header(h4("Welcome to Timor Leste REDD+ Geoportal")),
        img(
          src = "banner_en3.png", 
          style = "width: 100%; max-width: 1200px; margin-left: auto; margin-right: auto;"
        ),
        h4("Welcome!"),
        p("This portal shows spatial data and tables related to Timor Leste engagment in REDD+, the mechanism to reduce greenhouse gas (GHG) emissions from Deforestation, Forest Degradation, plus the role of sustainable forest management, conservation and enhancement of forest carbon stocks.")
      ),
      
      ## Details ---------------------------------------------------------------
      card(
        h5("Presentation of the data"),
        p("More specifically the data presented here are average levels of GHG emissions and removals from REDD+ activities, in tCO2e/year, used as a baseline or reference level against which future performances on emission reductions can be compared."),
        h4(
          "Placeholder for home content", 
          style = "text-align: center; margin-top: auto; margin-bottom: auto;"
        ),
      )
  )
  
} ## END module UI function
