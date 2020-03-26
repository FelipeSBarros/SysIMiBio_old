library(shiny)
library(dbplyr)
library(dplyr)
library(ggplot2)
library(plotly)
library(shinydashboard)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # connecting to database
    con <- DBI::dbConnect(RSQLite::SQLite(), '../db.sqlite3')
    
    bio <- tbl(con, "biodiversity_gbif")
    
    # total registros
    output$observaciones <- renderValueBox({
        n <- as.data.frame(bio %>% count())
        valueBox(n, 
                 "observaciones", icon = icon("eye"), color = "yellow")
    })
    
    # total familias
    output$familias <- renderValueBox({
        n <- as.data.frame(bio %>% summarise(count = n_distinct(Family)))
        valueBox(n, 
                 "Familias", icon = icon("group"), color = "green")
    })
    # "gbifID", "Publisher", "BasisOfRecord", "EventDate", "Year"
    
    # Origen de los datos
    output$Pub <- plotly::renderPlotly({
        pubData <- bio %>%
            group_by(Publisher) %>% 
            summarise(Observaciones = count()) %>% 
            arrange(desc(Observaciones))
        
        pubPlot <- ggplot(pubData, aes(x = publisher, y = Observaciones)) + 
            geom_col() + theme_minimal()
        ggplotly(pubPlot) })
    
    # tipo de observacion
    output$Obs <- plotly::renderPlotly({
        obsData <- bio %>%
            group_by(basisOfRecord) %>% 
            summarise(Observaciones = count()) %>% 
            arrange(desc(Observaciones))
        
        obsPlot <- obsData %>% 
            ggplot(aes(x = basisOfRecord, y = Observaciones)) +
            geom_col() + theme_minimal()
        ggplotly(obsPlot) })
        
    # ano de observacion
    bio %>%
        group_by(year) %>% 
        summarise(Observaciones = count()) %>% 
        arrange(desc(Observaciones)) %>% 
        ggplot(aes(x = year, y = Observaciones)) + geom_col()
    
    
    

})
