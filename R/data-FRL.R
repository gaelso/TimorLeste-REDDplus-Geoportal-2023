
library(dplyr)
library(readxl)
library(plotly)
library(htmlwidgets)

##
## LOAD DATA ###################################################################
##

frl <- readxl::read_xlsx(
  path = "data/tl_frl_modified_submission_calculations-202307-forShiny.xlsx",
  sheet = "Modified-FRL-data"
  )
  
frl



##
## Make plotly graphs for home value boxes #####################################
##

## Deforestation ---------------------------------------------------------------
vb_df <- plot_ly(
  data = frl, x = ~year, y = ~area_df
  ) |> 
  add_bars(
    marker = list(color = 'rgba(255, 255, 255, 0.4)'),
    hovertemplate = "%{y} ha <extra></extra>"
  ) |>
  add_trace(
    type = 'scatter', 
    mode = 'markers',
    marker = list(
      color = 'rgb(255, 255, 255)',
      lines = list(color = 'rgb(255, 255, 255, 1.0)'),
      size = 6
      ),
    hovertemplate = "%{y} ha <extra></extra>"
  ) |>
  add_lines(
    y = ~AVG_area_df, color = I("white"), alpha = 0.6,
    hoverinfo = 'skip'
  ) |>
  layout(
    bargap = 0.95,
    showlegend = FALSE,
    xaxis = list(visible = F, showgrid = F, title = "", fixedrange = T),
    yaxis = list(visible = F, showgrid = F, title = "", fixedrange = T),
    #hovermode = "x",
    margin = list(t = 0, r = 0, l = 0, b = 0),
    font = list(color = "white"),
    paper_bgcolor = "transparent",
    plot_bgcolor = "transparent"
  ) |>
  config(displayModeBar = F) |>
  htmlwidgets::onRender(
    "function(el) {
      var ro = new ResizeObserver(function() {
         var visible = el.offsetHeight > 200;
         Plotly.relayout(el, {'xaxis.visible': visible});
      });
      ro.observe(el);
    }"
  )
vb_df %>% layout(plot_bgcolor = "black")


## Afforestation ---------------------------------------------------------------
vb_af <- plot_ly(
  data = frl, x = ~year, y = ~area_af
) |> 
  add_bars(
    marker = list(color = 'rgba(255, 255, 255, 0.4)'),
    hovertemplate = "%{y} ha <extra></extra>"
  ) |>
  add_trace(
    type = 'scatter', 
    mode = 'markers',
    marker = list(
      color = 'rgb(255, 255, 255)',
      lines = list(color = 'rgb(255, 255, 255, 1.0)'),
      size = 6
    ),
    hovertemplate = "%{y} ha <extra></extra>"
  ) |>
  add_lines(
    y = ~AVG_area_af, color = I("white"), alpha = 0.6,
    hoverinfo = 'skip'
  ) |>
  layout(
    bargap = 0.95,
    showlegend = FALSE,
    xaxis = list(visible = F, showgrid = F, title = "", fixedrange = T),
    yaxis = list(visible = F, showgrid = F, title = "", fixedrange = T),
    #hovermode = "x",
    margin = list(t = 0, r = 0, l = 0, b = 0),
    font = list(color = "white"),
    paper_bgcolor = "transparent",
    plot_bgcolor = "transparent"
  ) |>
  config(displayModeBar = F) |>
  htmlwidgets::onRender(
    "function(el) {
      var ro = new ResizeObserver(function() {
         var visible = el.offsetHeight > 200;
         Plotly.relayout(el, {'xaxis.visible': visible});
      });
      ro.observe(el);
    }"
  )
vb_af %>% layout(plot_bgcolor = "black")

# vb_af <- plot_ly(data = frl) |>
#   add_trace(
#     x = ~year, y = ~area_af,
#     type = 'scatter', mode = 'lines', #line = list(shape = "spline"),
#     color = I("white"), span = I(1),
#     fill = 'tozeroy', alpha = 0.2
#   ) |>
#   layout(
#     xaxis = list(visible = F, showgrid = F, title = "", fixedrange = T, autosize = T),
#     yaxis = list(visible = F, showgrid = F, title = "", fixedrange = T),
#     hovermode = "x",
#     margin = list(t = 0, r = 0, l = 0, b = 0, pad = 4),
#     font = list(color = "white"),
#     paper_bgcolor = "transparent",
#     plot_bgcolor = "transparent",
#     showlegend = FALSE
#   ) |>
#   config(displayModeBar = F)
