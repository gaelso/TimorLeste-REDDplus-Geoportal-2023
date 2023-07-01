
## Define UI
shinyUI(
  
  fluidPage(
    
    shinyjs::useShinyjs(),
    
    shiny.i18n::usei18n(i18n),
    
    includeCSS("style.css"),
    
    tags$div(class="watermark", list("DEMO")),
    
    tags$div(class="watermark2", list("DO NOT USE THE DATA")),
    
    tags$head(tags$style(HTML("a {color: #0D19A3}"))), #Color for links
    
    theme = shinythemes::shinytheme("flatly"),
    #shinythemes::themeSelector(),
    
    ## Application banner ###################################################
    titlePanel(
      title = div(img(src="img/banner_en.png", width = '100%')),
      windowTitle = "Timor Leste REDD+ Geoportal"
    ),
    
    # conditionalPanel(
    #   condition = "input.lang == 'en'", 
    #   titlePanel(
    #     title = div(img(src="banner_en.png", width = '100%')),
    #     windowTitle = "Timor Leste REDD+ Geoportal"
    #   )
    # ),
    # conditionalPanel(
    #   condition = "input.lang == 'tt'", 
    #   titlePanel(
    #     title = div(img(src="banner_tt.png", width = '100%')),
    #     windowTitle = "PRAP Monitoring"
    #   )
    # ),
    
    # fluidRow(
    #   column(
    #     width = 6,
    #     radioGroupButtons(
    #       inputId = "lang",
    #       label = "",
    #       choiceNames = c(
    #         '<i class="enlogo"></i>English' ,
    #         '<i class="vnlogo"></i>Tetun'
    #       ),
    #       choiceValues = i18n$get_languages(),
    #       selected = 'en',
    #       #selected = i18n$get_key_translation(),
    #       # choiceValues = c("en", "vi"),
    #       # checkIcon = list(
    #       #   yes = icon("ok", 
    #       #              lib = "glyphicon")),
    #       justified = FALSE
    #     ), 
    #     tags$script("$(\"input:radio[name='lang']\").parent().css('padding', '5px');"),
    #     tags$script("$(\"input:radio[name='lang']\").parent().css('font-size', '12px');"),
    #     style = "height: 40px;"
    #   ),
    #   column(
    #     width = 6,
    #     a(href="http://vietnam-redd.org/en/home/index/", img(src = "vn-redd1.png", alt="Vietnam REDD+", title="Vietnam REDD+ Website", style="float:right; height:40px;padding-top:5px;")),
    #     a(href="http://vietnamnrap.net/#/", img(src = "nrap.png", alt="NRAP", title="NRAP monitoring", style="float:right; height:40px;padding-top:5px;padding-right:10px;"))
    #   ),
    #   style = "height: 40px; background: #2c3e50; margin: 0px; position: relative; z-index: 1000;"
    # ),
    
    ## Navbarpage setup #####################################################
    navbarPage(
      id = "navbar", title = NULL, selected = "home",
      
      ## Icons on right side of navbar in home script !!!Replaced by the fluidRow() with language bar!!!
      
      tabPanel(title = "Home"     , value = "home" , icon = icon("campground"), mod_home_UI("tab_home")),
      tabPanel(title = "Geoportal", value = "geo"  , icon = icon("map")       , mod_geo_UI("tab_geo")  ),
      tabPanel(title = "Tables"   , value = "tab"  , icon = icon("table")     , mod_tab_UI("tab_tab")  ),
      tabPanel(title = "About"    , value = "about", icon = icon("info")      , mod_geo_UI("tab_about"))
    )
      
      ## --- Load tabs ui ---------------------------------------------------
      source("R-app/ui/home.R", local = TRUE)$value,
      
      source("R-app/ui/provinces.R", local = TRUE)$value,
      
      source("R-app/ui/overview.R", local = TRUE)$value,
      
      source("R-app/ui/indicators.R", local = TRUE)$value,
      
      source("R-app/ui/checks.R", local = TRUE)$value,
      
      source("R-app/ui/about.R", local = TRUE)$value
      
    ) ## End NavBarPage
    
  ) ## End fluidPage
  
) ## The End 