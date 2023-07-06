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
library(leaflet)
library(tmap)
library(sf)
library(dplyr)
library(forcats)
library(shinyjs)
library(shiny.i18n)

sf_country   <- st_read("data/TimorLeste.geoJSON", quiet = T)
sf_AD        <- st_read("data/AD-spatial-grid2.geoJSON", quiet = T)
sf_AD_square <- st_read("data/AD-spatial-square.geoJSON", quiet = T)

# pal_redd <- tibble(
#   redd_FRL = c("AF", "DF", "StableF", "StableNF"),
#   redd_color = c("#36B0C7", "#D60602", "#207A20", "grey10"),
#   redd_FRL_name = c("Afforestation", "Deforestation", "Stable Forest", "Stable Non-Forest")
# )

palette_redd <- c("#36B0C7", "#D60602", "#207A20", "grey10")

palette_lu <- c('#0f6f09', '#7a8bff', '#1fff10', '#aa6510', '#0a2dd5', '#28b9ff', '#ff4be9', 
                "#f1ff18", '#f1ff18', '#f1ff18', '#ff8f1c', 'grey10', 'grey10', 'grey10')

lu_conv <- tibble(
  lu_id = c("FC", "C", "FDL", "FP", "G", "MF", "FMH", "FML", "FM", "O", "OWL", "S", "SH", "W"),
  lu_no = c(   5,  11,     3,    7,   8,    6,     1,     2,    4,  14,    10,  12,    9,  13)
)

pal_luc <- colorFactor(palette_redd, sf_AD$redd_FRL)

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
source("R/mod_portal_UI.R", local = TRUE)
source("R/mod_portal_server.R", local = TRUE)

##
## UI ##########################################################################
##

ui <- tagList(
  shinyjs::useShinyjs(),
  shiny.i18n::usei18n(i18n),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  #htmltools::includeCSS("style.css"),
  htmltools::htmlDependency(
  name = "flag-icons", 
  version = "6.6.6",
  src = c(href="https://cdn.jsdelivr.net/gh/lipis/flag-icons@6.6.6/"), 
  stylesheet = "css/flag-icons.min.css"
  ),
  page_navbar(
    title = i18n$t("Timor Leste REDD+ Geoportal"),
    theme = bs_theme(
      version = 5,
      bootswatch = "minty",
      base_font = font_google("Montserrat"),
      code_font = font_google("Fira Code"),
      heading_font = font_google("Quicksand")
    ),
    fillable = "portal",
    bg = "#f8f9fa",
    
    #nav_item(div(style = "margin-right:40px;")),
    
    nav_panel(title = i18n$t("Home"), value = "home", icon = icon("campground"), p("Whereas disregard and contempt for human rights have resulted"), language_selector),
    
    nav_panel(title = i18n$t("Portal"), value = "portal", icon  = icon("map"), 
              mod_portal_UI("tab_portal")),
    
    nav_panel(title = i18n$t("Calculations"), value = "calc", icon = icon("chart-line"), p("calculations")),
    
    nav_spacer(),
    
    nav_item(language_selector)
  )
)
  
#   # Sidebar with a slider input for number of bins 
#   sidebarLayout(
#     
#     sidebarPanel(
#       
#       ## Select base layer aka tiles
#       h4(i18n$t("Base map layers")),
#       selectInput(
#         inputId = "basemap", 
#         label = NULL,
#         choices = c("ESRI gray canvas"   = "Esri.WorldGrayCanvas",
#                     "ESRI world imagery" = "Esri.WorldImagery",
#                      "OpenTopoMap"       = "OpenTopoMap",
#                      "OpenStreetMap"     = "OpenStreetMap.Mapnik"),
#         selected = "Esri.WorldGrayCanvas"
#         ),
#       
#       br(),
#       
#       ## Select layouts
#       h4(i18n$t("Grid layouts")),
#       checkboxInput(inputId = "grid_layout", label = i18n$t("Activity Data grid")),
#       checkboxInput(inputId = "grid_square", label = i18n$t("Activity Data visual interpretation frames")),
#       
#       br(),
#       
#       ## Select interpretation results
#       h4(i18n$t("Land use and land use change")),
#       checkboxInput(inputId = "grid_luc", label = i18n$t("Land use change")),
#       shinyjs::hidden(sliderInput(
#           inputId = "grid_luc_tr", label = NULL, min = 0, max = 1, step = 0.1, 
#           value = 1, ticks = FALSE, 
#           )),
#       shinyjs::hidden(div(
#       id = "legend_luc", 
#       em(i18n$t("Legend: AF = Afforestation, DF = Deforestation, SF = Stable Forest, SNF = Stable Non-Forest"))
#       )),
#       checkboxInput(inputId = "grid_lu", label = i18n$t("Annual land use")),
#       shinyjs::hidden(sliderInput(
#           inputId = "grid_lu_tr", label = NULL, min = 0, max = 1, step = 0.1, 
#           value = 1, ticks = FALSE, 
#           )),
#         shinyjs::hidden(sliderInput(
#           inputId = "grid_lu_year", label = NULL, min = 2017, max = 2021, step = 1, 
#           value = 2021, ticks = FALSE, sep = ""
#         )),
#       shinyjs::hidden(div(
#         id = "legend_lu",
#         em(i18n$t("Legend: FMH = Highland Moist Forest, FML = Lowland Moist Forest, FDL = Lowland Dry foret, FM = Montane Forest, FC = Coastal Forest, MF = Mangrove Forest, FP = Forest Plantation, G = Grassland, SH = Shrubland, OWL = Other Wooded Land, C = Cropland, S = Settlement, W = Wetland, O = Other Land"))
#       ))
#       
#     ), ## End sidebarPanel
#     
#     ## Show the leaflet
#     mainPanel(
#       
#       leafletOutput("my_map", width = "100%", height = "80vh")
#       
#       )
#     
#   ) ## End sidebarLayout
# ) ## End fluidPage



##
## Server ######################################################################
##

server <- function(input, output, session) {
  
  observeEvent(input$language, {
    shiny.i18n::update_lang(language = input$language)
    })
  
  mod_portal_server("tab_portal")
  
}
# server <- function(input, output) {
#   
#   output$my_map = renderLeaflet({
#     
#     leaflet(options = leafletOptions(minZoom = 8)) |>
#       addProviderTiles(layerId = "basemap", provider = "Esri.WorldGrayCanvas") |>
#       setView(125, -9, zoom = 8) |>
#       setMaxBounds(lng1 = 124, lat1 = -10, lng2 = 128, lat2 = -8)
# 
#   })
#   
#   ## Update basemap aka tiles --------------------------------------------------
#   observeEvent(input$basemap, {
#     leafletProxy("my_map") |>
#       removeTiles("basemap") |>
#       addProviderTiles(layerId = "basemap", input$basemap)
#   })
#   
#   ## Grid layouts --------------------------------------------------------------
#   ## Show/hide grid layout
#   observeEvent(input$grid_layout, {
#     # print(input$grid_layout)
#     if(input$grid_layout){
#       leafletProxy("my_map") |>
#         addPolygons(
#           data = sf_AD, group = "lf_grid_layout", fill = NA, color = "darkorange", weight = 1
#           )
#     } else {
#       leafletProxy("my_map") |>
#         clearGroup(group = "lf_grid_layout")
#     }
#   })
#   
#   ## Show/hide grid visual interpretation frames
#   observeEvent(input$grid_square, {
#     # print(input$grid_square)
#     if(input$grid_square){
#       leafletProxy("my_map") |>
#         addPolygons(
#           data = sf_AD_square, group = "lf_AD_square", fill = NA, color = "red", weight = 2
#           )
#     } else {
#       leafletProxy("my_map") |>
#         clearGroup(group = "lf_AD_square")
#     }
#   })
#   
#   ## Show/hide land use change hexes
#   observeEvent({
#     input$grid_luc
#     input$grid_luc_tr
#     }, {
#       # print(input$grid_luc_tr)
#       if(input$grid_luc) {
#         shinyjs::show("grid_luc_tr")
#         shinyjs::show("legend_luc")
#         leafletProxy("my_map") |>
#           clearGroup(group = "lf_grid_luc") |>
#           clearControls() |>
#           addPolygons(
#             data = sf_AD, group = "lf_grid_luc", stroke = FALSE, smoothFactor = 0.3,
#             fillOpacity = input$grid_luc_tr, fillColor = ~pal_luc(redd_FRL)
#           ) |>
#           addLegend(
#             data = sf_AD, pal = pal_luc, values = ~redd_FRL, group = "lf_grid_luc",
#             position = "topright", title = NA, opacity = 0.8
#           )
#       } else {
#         shinyjs::hide("grid_luc_tr")
#         shinyjs::hide("legend_luc")
#         leafletProxy("my_map") |>
#           clearGroup(group = "lf_grid_luc") |>
#           clearControls()
#       }
#     })
#   
#   ## Show/hide land use per year hexes
#   observeEvent({
#     input$grid_lu
#     input$grid_lu_tr
#     input$grid_lu_year
#   }, {
#     # print(input$grid_lu_tr)
#     
#     sf_lu <- sf_AD %>% 
#       dplyr::select(id, lu_id = sym(paste0("lu_end", input$grid_lu_year))) %>%
#       left_join(lu_conv, by = "lu_id") %>%
#       mutate(land_use = forcats::fct_reorder(lu_id, lu_no))
#     
#     pal_lu <- colorFactor(palette_lu, sf_lu$land_use)
#     
#     if(input$grid_lu) {
#       shinyjs::show("grid_lu_tr")
#       shinyjs::show("grid_lu_year")
#       shinyjs::show("legend_lu")
#       leafletProxy("my_map") |>
#         clearGroup(group = "lf_grid_lu") |>
#         clearControls() |>
#         addPolygons(
#           data = sf_lu, group = "lf_grid_lu", stroke = FALSE, smoothFactor = 0.3,
#           fillOpacity = input$grid_lu_tr, fillColor = ~pal_lu(land_use)
#         ) |>
#         addLegend(
#           data = sf_lu, pal = pal_lu, values = ~land_use, group = "lf_grid_lu",
#           position = "topright", title = NA, opacity = 0.8
#         )
#     } else {
#       shinyjs::hide("grid_lu_tr")
#       shinyjs::hide("grid_lu_year")
#       shinyjs::hide("legend_lu")
#       leafletProxy("my_map") |>
#         clearGroup(group = "lf_grid_lu") |>
#         clearControls()
#     }
#   })
#   
# }



##
## Run the application #########################################################
##

shinyApp(ui = ui, server = server)
