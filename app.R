#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(bslib)
library(crosstalk)
library(leaflet)
library(leaflet.multiopacity)
library(tmap)
library(sf)
library(dplyr)
library(forcats)
library(shinyjs)
library(shiny.i18n)

sf_country   <- st_read("data/TimorLeste.geoJSON", quiet = T)
sf_AD        <- st_read("data/AD-spatial-grid2.geoJSON", quiet = T)
sf_AD_square <- st_read("data/AD-spatial-square.geoJSON", quiet = T)

sf_redd <- sf_AD %>% select(id, redd_FRL)

palette_redd <- c("#36B0C7", "#D60602", "#207A20", "grey10")

palette_lu <- c('#0f6f09', '#7a8bff', '#1fff10', '#aa6510', '#0a2dd5', '#28b9ff', '#ff4be9', 
                "#f1ff18", '#f1ff18', '#f1ff18', '#ff8f1c', 'grey10', 'grey10', 'grey10')

lu_conv <- tibble(
  lu_id = c("FC", "C", "FDL", "FP", "G", "MF", "FMH", "FML", "FM", "O", "OWL", "S", "SH", "W"),
  lu_no = c(   5,  11,     3,    7,   8,    6,     1,     2,    4,  14,    10,  12,    9,  13)
)

## Initiate translation
i18n <- Translator$new(translation_csvs_path = 'translation')
i18n$set_translation_language('en')

## UI element Language selector
language_selector <- shinyWidgets::radioGroupButtons(
  inputId = "language",
  label = NULL, 
  choiceNames = c('<i class="fi fi-gb"></i> EN', '<i class="fi fi-tl"></i> TL'),
  choiceValues = c("en", "te"),
  selected = "en"
  )

## Source modules
source("R/mod_home_UI.R", local = TRUE)
source("R/mod_home_server.R", local = TRUE)
source("R/mod_portal_UI.R", local = TRUE)
source("R/mod_portal_server.R", local = TRUE)
source("R/mod_calc_UI.R", local = TRUE)
source("R/mod_calc_server.R", local = TRUE)

##
## UI ##########################################################################
##

ui <- tagList(
  
  ## Setup ---------------------------------------------------------------------
  shinyjs::useShinyjs(),
  shiny.i18n::usei18n(i18n),
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "style.css")),
  htmltools::htmlDependency(
    name = "flag-icons",
    version = "6.6.6",
    src = c(href="https://cdn.jsdelivr.net/gh/lipis/flag-icons@6.6.6/"), 
    stylesheet = "css/flag-icons.min.css"
  ),
  tags$head(includeHTML("google-analytics.html")),
  # img(src = "banner_en3.png"),
  
  ## UI elements ---------------------------------------------------------------
  page_navbar(
    
    ## ++ Styling ++++++
    # title = NULL,
    title = div(HTML('<i class="fi fi-tl"></i>'), i18n$t("Timor Leste REDD+ Geoportal"), style = "display:inline;"),
    window_title = "TL REDD+ Geoportal",
    theme = bs_theme(
      version = 5,
      bootswatch = "minty",
      base_font = font_google("Merriweather"),
      code_font = font_google("Fira Code"),
      heading_font = font_google("Quicksand", wght = 700)
    ),
    fillable = "portal",
    bg = "#f8f9fa",
    
    ## ++ Panels +++++
    nav_panel(
      title = i18n$t("Home"), 
      value = "home", 
      icon = icon("campground"),
      mod_home_UI("tab_home") ## See R/mod_home_UI.R
      ),
    
    nav_panel(
      title = i18n$t("Portal"), 
      value = "portal", 
      icon  = icon("map"),
      mod_portal_UI("tab_portal") ## See R/mod_portal_UI.R
    ),
    
    nav_panel(
      title = i18n$t("Calculations"), 
      value = "calc", 
      icon = icon("chart-line"), 
      mod_calc_UI("tab_calc") ## See R/mod_calc_UI.R
    ),
    
    nav_spacer(),
    
    nav_item(language_selector)
    
  ) |> ## End page_navbar
    tagAppendAttributes(.cssSelector = "nav", class = "navbar-expand-lg") 
) ## End tagList
  
# 
##
## Server ######################################################################
##

server <- function(input, output, session) {
  
  observeEvent(input$language, {
    shiny.i18n::update_lang(language = input$language)
    })
  
  mod_portal_server("tab_portal")
  # ## OUTPUTS -----------------------------------------------------------------
  # output$my_map <- renderLeaflet({
  #   leaflet(options = leafletOptions(minZoom = 8)) |>
  #     addProviderTiles(layerId = "basemap", provider = "Esri.WorldGrayCanvas") |>
  #     setView(125, -9, zoom = 8) |>
  #     setMaxBounds(lng1 = 124, lat1 = -10, lng2 = 128, lat2 = -8)
  # })
  # 
  # ## OBSERVERS ---------------------------------------------------------------
  # 
  # ## Update basemap aka tiles
  # observeEvent(input$basemap, {
  #   leafletProxy("my_map") |>
  #     removeTiles("basemap") |>
  #     addProviderTiles(layerId = "basemap", input$basemap)
  # })
  
  
} ## End server


##
## Run the application #########################################################
##

shinyApp(ui = ui, server = server)
