
mod_about_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ##
  ## UI Elements #################################################################
  ##
  
  
  
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
