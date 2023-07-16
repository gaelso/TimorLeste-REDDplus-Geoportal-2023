
mod_about_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ##
  ## UI Elements #################################################################
  ##
  about_redd <- card(
    card_header("What is REDD+?"),
    card_body(
      p("REDD+ stands for "),
      p("such as hat are REDD+ activities The data presented here are average levels of GHG emissions and removals from REDD+ activities, in tCO2e/year, used as a baseline (or reference level) against which future performances on emission reductions can be compared.")
    )
  )
  
  
  ##
  ## UI organization #############################################################
  ##
  
  # UI elements wrapped in a tagList() function
  tagList(
    
    br(),
    h4("Placeholder for about section", style = "text-align: center;"),
    br()
    
  )
  
} ## END module UI function
