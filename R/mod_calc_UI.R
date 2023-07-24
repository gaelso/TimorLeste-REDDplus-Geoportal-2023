
mod_calc_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ##
  ## UI Elements ###############################################################
  ##
  
  calc_info <- card(
    h4("Calculation steps"),
    p(bsicons::bs_icon("1-circle"), "Emission Factors come from forest and other land uses' carbon stock."),
    br(),
    p(bsicons::bs_icon("2-circle"), "Activity data com from land use change spatial samples."),
  ) 
  
  
  ## Emission factors ----------------------------------------------------------
  calc_ef_table <- card(
    p("Placeholder EF table"),
    #print(as_tibble(sf_AD) |> slice_head(n = 10))
  )
  
  calc_ef_graph <- card(
    p("placeholder EF graph")
  )
  
  calc_ef <- card(
    card_header(bsicons::bs_icon("1-circle-fill", size = "1.5rem", class = "text-primary"), "Emission and Removal Factors - EF"),
    layout_column_wrap(
      width = 1/2,
      calc_ef_table,
      calc_ef_graph
    )
  )
  
  calc_ad <- card(
    p("placeholder AD")
  )
  
  calc_data <- card(
    calc_ef,
    calc_ad
  )
    
  
  ## UI elements wrapped in a tagList() function
  tagList(
    
    layout_columns(
      col_widths = c(4, 8),
      calc_info, 
      calc_data
    )
    
  ) ## END tagList
  
} ## END module UI function
