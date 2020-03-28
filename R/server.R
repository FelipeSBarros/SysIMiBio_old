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
                 "observaciones", icon = icon("eye"), color = "green")
    })
    
    # total familias
    output$familias <- renderValueBox({
        n <- as.data.frame(bio %>% summarise(count = n_distinct(Family)))
        valueBox(n, "Familias", icon = icon("group"), color = "yellow")
    })
    # total species
    output$species <- renderValueBox({
        n <- as.data.frame(bio %>% summarise(count = n_distinct(scientificName)))
        valueBox(n, "Especies", icon = icon("tree"), color = "orange")
    })
    
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
        
    # ano de la observacion
    output$Ano <- plotly::renderPlotly({
        anoData <- bio %>%
            group_by(year) %>% 
            summarise(Observaciones = count()) %>% 
            arrange(desc(Observaciones))
        
        anoPlot <- anoData %>% 
            ggplot(aes(x = year, y = Observaciones)) +
            geom_col() + theme_minimal()
        ggplotly(anoPlot)})
    
    # TaxonRank
    output$TRank <- plotly::renderPlotly({
        trankData <- bio %>%
            group_by(taxonRank) %>% 
            summarise(Observaciones = count()) %>% 
            arrange(desc(Observaciones))
        
        trankPlot <- trankData %>% 
            ggplot(aes(x = taxonRank, y = Observaciones)) +
            geom_col() + theme_minimal()
        ggplotly(trankPlot)})
    
    # TaxonStatus
    output$TStatus <- plotly::renderPlotly({
        tstatusData <- bio %>%
            group_by(taxonomicStatus) %>% 
            summarise(Observaciones = count()) %>% 
            arrange(desc(Observaciones))
        
        tstatusPlot <- tstatusData %>% 
            ggplot(aes(x = taxonomicStatus, y = Observaciones)) +
            geom_col() + theme_minimal()
        ggplotly(tstatusPlot)})
    })
