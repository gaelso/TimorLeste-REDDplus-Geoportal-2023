ui <- fillPage(
  titlePanel(title = "TEST"),
  fillRow(
  plotOutput("plotLeft", height = "100%"),
  fillCol(
    plotOutput("plotTopRight", height = "100%"),
    plotOutput("plotBottomRight", height = "100%")
  )
))

server <- function(input, output, session) {
  output$plotLeft <- renderPlot(plot(cars))
  output$plotTopRight <- renderPlot(plot(pressure))
  output$plotBottomRight <- renderPlot(plot(AirPassengers))
}

shinyApp(ui, server)