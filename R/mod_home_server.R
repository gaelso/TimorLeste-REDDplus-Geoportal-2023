
mod_home_server <- function(id, r_lang, rv) {
  
  moduleServer(id, function(input, output, session) {
    
    ns <- session$ns
    
    ## OUTPUTS #################################################################
    
    
    ## OBSERVERS ###############################################################
    
    observeEvent(r_lang(), {
      
      if (r_lang() == "en") {
        shinyjs::show("intro_en")
        shinyjs::hide("intro_te")
        shinyjs::show("spatial_en")
        shinyjs::hide("spatial_te")
      } else {
        shinyjs::hide("intro_en")
        shinyjs::show("intro_te")
        shinyjs::hide("spatial_en")
        shinyjs::show("spatial_te")
      }
      
    })
    
    observeEvent(input$to_portal, {
      rv$to_portal <- input$to_portal
    })
    
    
  }) ## END module server function
  
}