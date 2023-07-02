
library(ggplot2)

ui <- fillPage(
  
  theme = bslib::bs_theme(bootswatch = "darkly"),
  
  titlePanel("A themed plot"),
  
  fillRow(flex = c(1, 2),
    p("test test testtest test test test test test testtest test test test test "),
    plotOutput("plot", height = "100%")
    )
  )


server <- function(input, output, session) {
  thematic::thematic_shiny()
  
  output$plot <- renderPlot({
    ggplot(mtcars, aes(wt, mpg)) +
      geom_point() +
      geom_smooth()
  }, res = 96)
}

shinyApp(ui, server)
