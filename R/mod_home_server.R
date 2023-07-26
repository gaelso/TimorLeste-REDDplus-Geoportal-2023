
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
        shinyjs::show("calc_en")
        shinyjs::hide("calc_te")
        shinyjs::show("info_en")
        shinyjs::hide("info_te")
      } else {
        shinyjs::hide("intro_en")
        shinyjs::show("intro_te")
        shinyjs::hide("spatial_en")
        shinyjs::show("spatial_te")
        shinyjs::hide("calc_en")
        shinyjs::show("calc_te")
        shinyjs::show("info_te")
        shinyjs::hide("info_en")
      }
      
    })
    
    observeEvent(input$to_portal, {
      rv$to_portal <- input$to_portal
    })
    
    observeEvent(input$to_calc, {
      rv$to_calc <- input$to_calc
    })
    
    observeEvent(input$to_info, {
      rv$to_info <- input$to_info
    })
    
  }) ## END module server function
  
}