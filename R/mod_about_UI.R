
mod_about_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ##
  ## UI Elements #################################################################
  ##
  about_redd <- card(
    card_header(h5("What is REDD+?")),
    card_body(
      p("REDD+ stands for "),
      p("such as hat are REDD+ activities The data presented here are average levels of GHG emissions and removals from REDD+ activities, in tCO2e/year, used as a baseline (or reference level) against which future performances on emission reductions can be compared.")
    )
  )
  
  about_er <- card(
    card_header(h5("Method: Emissions and Removals")),
    card_body(
      p("placeholder for ER equation"),
      p("$$E = AD \\times EF$$")
    )
  )
  
  ##
  ## UI organization #############################################################
  ##
  
  # UI elements wrapped in a tagList() function
  tagList(
    
    layout_column_wrap(
      width = 1/2,
      about_redd,
      about_er
    )
    
  )
  
} ## END module UI function
