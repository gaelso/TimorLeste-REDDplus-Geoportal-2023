
shinyServer(function(input, output, session) {
  
  ## Initial Disclaimer ###################################################
  sendSweetAlert(
    session = session,
    title =  NULL,
    text = div(
      h3(icon("info-circle"), HTML("&nbsp;"), strong("Tuyên bố từ chối trách nhiệm"), 
         style = "text-align: center; color: #f13c1f;"),
      br(),
      h5("Ứng dụng web này được xây dựng trên phiên bản thử nghiệm của cơ sở 
            dữ liệu Hệ thống giám sát tài nguyên rừng của Cục Kiểm lâm Việt Nam. 
            Mục tiêu của công cụ là giới thiệu cách sử dụng dữ liệu FRMS để giám 
               sát các Kế hoạch và hành động REDD ở cấp tỉnh."),
      h5(strong("Thông tin và số được cung cấp trong bản demo này không được cập nhật. 
                Chúng có thể không đầy đủ và có lỗi.")),
      h5(strong("KHÔNG nên sử dụng chúng để đưa ra bất kỳ kết luận nào về hiện 
                trạng rừng ở bất kỳ tỉnh nào được trình bày.")), 
      br(),
      h3(icon("info-circle"), HTML("&nbsp;"), strong("Disclaimer"), 
         style = "text-align: center; color: #f13c1f;"),
      br(),
      h5("This web application is built on a testing version of the 
               Forest Resource Monitoring System database from the 
               Vietnam Forest Protection Department. The objective of the tool is 
               to showcase how FRMS data can be used to monitor REDD+ Action Plans 
               at Provincial Level."),
      h5(strong("The information and numbers provided in this demo are not updated. 
                      They may be incomplete and contain errors.")),
      h5(strong("They should NOT be used to draw any conclusion on the current status 
                      of forests in any of the provinces presented.")),
      class = "disclaimer"
    ),
    #type = "error", 
    html = TRUE,
    closeOnClickOutside = FALSE
  )
  
  
  ## sidebarPanel outputs for all indicator tabs ##########################
  output$prov <- output$prov2 <- output$prov3 <- renderUI({ prap_react()$province_selected })
  output$date <- output$date2 <- output$date3 <- renderUI({ prap_react()$last_data })
  output$cols <- output$cols2 <- output$cols3 <- function() { color_code() }
  
  
  ## Translation for code_lists ###########################################
  tr_envi <- reactiveValues()
  
  ## Apply translation
  observeEvent(input$lang, {
    
    ## From i18n (for navbar titles, headers, figure labels, table titles)
    print(paste("Language change!", input$lang))
    shiny.i18n::update_lang(session, input$lang)
    
    
    ## From code lists for figure legends and facets 
    ##  (code lists joins within server output scripts) 
    if (input$lang == "en") {
      
      tr_envi$ff <- f_fun %>%
        mutate(forest_func = forest_func_en) %>%
        select(fun_code, forest_func) %>%
        distinct()
      
      tr_envi$ffs <- f_fun_sub %>%
        mutate(forest_func_sub = name_en, forest_func = forest_func_en) %>%
        select(forest_func_sub_code, forest_func_sub, forest_func_code, fun_code, forest_func)
      
      tr_envi$ct <- change_type %>%
        mutate(change = name_en, edits = edits_en) %>%
        select(change_type_id, change, edits_id, edits)
      
      tr_envi$ft <- f_type %>%
        mutate(forest_type = en) %>%
        select(forest_type_code, forest_type) %>%
        mutate(forest_type =  str_replace(
          string = forest_type,
          pattern = "Rehabilitation secondary evergreen broadleaved forest on soil mountain", 
          replacement = "Rehabilitation secondary \nevergreen broadleaved \nforest on soil mountain"
        ))
      
      tr_envi$fi <- incident %>%
        mutate(incident = en) %>%
        select(code, incident)
      
      tr_envi$fo <- owner %>%
        mutate(owner_type = en)  %>%
        select(code, owner_type)
      
      
    } else {
      
      tr_envi$ff <- f_fun %>%
        mutate(forest_func = forest_func_vi) %>%
        select(fun_code, forest_func) %>%
        distinct()
      
      tr_envi$ffs <- f_fun_sub %>%
        mutate(forest_func_sub = name_vi, forest_func = forest_func_vi) %>%
        select(forest_func_sub_code, forest_func_sub, forest_func_code, fun_code, forest_func)
      
      tr_envi$ct <- change_type %>%
        mutate(change = name, edits = edits) %>%
        select(change_type_id, change, edits_id, edits)
      
      tr_envi$ft <- f_type %>%
        mutate(forest_type = vi) %>%
        select(forest_type_code, forest_type)
      
      tr_envi$fi <- incident %>%
        mutate(incident = vi) %>%
        select(code, incident)
      
      tr_envi$fo <- owner %>%
        mutate(owner_type = vi)  %>%
        select(code, owner_type)
      
    } ## End if lang
    
  }) ## End observeEvent
  
  
  ## 
  ## Server script for each tab ###########################################
  ##
  
  source("R-app/server/home.R", local = T)
  
  source("R-app/server/provinces2.R", local = T)
  
  source("R-app/server/overview.R", local = T)
  
  source("R-app/server/indicators.R", local = T)
  
  source("R-app/server/checks.R", local = T)
  
  source("R-app/server/about.R", local = T)
  
  
}) ## END shinyServer

