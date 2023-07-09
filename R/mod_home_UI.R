

mod_home_UI <- function(id){
  
  ## From https://shiny.rstudio.com/articles/modules.html
  # `NS(id)` returns a namespace function, which was save as `ns` and will
  # invoke later.
  ns <- NS(id)
  
  ## UI elements wrapped in a tagList() function
  # tagList(
    
    layout_columns(
      col_widths = c(4, 4, 4, 12),
      row_heights = c(1, 5),
      card(
        card_header(h4("FREL")),
        div(icon("arrow-up"), "412,532 tCO2e/year", class = "frl-card"),
        class = "bg-secondary"
      ),
      card(
        card_header(h4("Removals")),
        div(icon("arrow-down"), "-747,694 tCO2e/year", class = "frl-card"),
        class = "bg-primary"
      ),
      card(
        card_header(h4("FRL")),
        div(icon("arrow-down"), "-335,162 tCO2e/year", class = "frl-card"),
        class = "bg-info"
      ),
      card(
        #card_header(h4("Welcome to Timor Leste REDD+ Geoportal")),
        # img(src = "banner_en3.png"),
        br(),
        h4("Placeholder for home content", style = "text-align: center;"),
        br()
      )
    )
    
    
  
  # ) ## END tagList
  
} ## END module UI function
