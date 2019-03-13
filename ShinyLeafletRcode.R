##Shiny App for interactive visualization

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      # numericInput(
      #   inputId = 'n_rows',
      #   label = "How many rows, bro?",
      #   value = 10
      #   
      # ),
      # actionButton(
      #   inputId = 'button',
      #   label = 'show'
      # ),
      #visual separation
      
      hr(),
      
      selectInput(inputId = "pickup",
                  label = "Pickup Location:",
                  choices = c("Bronx", 
                              "Brooklyn",
                              "Manhattan",
                              "Queens"
                  ),
                  selected = "Queens"),
      
      selectInput(inputId = "dropoff",
                  label = "Dropoff Location:",
                  choices = c("Bronx", 
                              "Brooklyn",
                              "Manhattan",
                              "Queens",
                              "StatenIsand"),
                  selected = "Manhattan")
      
    ),
    
    mainPanel(
      tableOutput(
        outputId = "datatable"
      ),
      
      leafletOutput("mymap")  
      
    )
    
  )
)


server <- function(input,output, session){
  
  # observeEvent(input$button, {
  #   cat("Showing", input$n_rows, "rows \n")
  # })
  
  
  
  df <- eventReactive(c(input$pickup, input$dropoff), {
    subset(data_small, pickup_borough == input$pickup & dropoff_borough == input$dropoff)
  }
  
  )
  
  # output$datatable <- renderTable({
  #   df()
  # })
  
  
  output$mymap <- renderLeaflet({
    maps <-leaflet(df())%>%
      addProviderTiles(providers$CartoDB.Positron)
    
    maps %>% setView(-74.000, 40.740, zoom = 12) %>%
      addCircleMarkers(~Dropoff_longitude, ~Dropoff_latitude, weight = 1, radius = 1, 
                       stroke = TRUE, fillOpacity = 0.1, color = "blue")%>%
      addCircleMarkers(~Pickup_longitude, ~Pickup_latitude, weight = 1, radius = 1, stroke = TRUE, fillOpacity = 0.1, color="red")
    
  })
  
  #df2 <- eventReactive(input)
  
}
shinyApp(ui = ui, server = server)