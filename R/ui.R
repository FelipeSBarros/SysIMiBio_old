#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(

    # Application title
    dashboardHeader(title = "SysIMiBio"),

    # Sidebar with a slider input for number of bins
    dashboardSidebar(
        sidebarMenu(
            menuItem("General", tabName = "General", icon = icon("dashboard")),
            menuItem("Taxonomia", tabName = "Taxonomia", icon = icon("th"))
        )),

        # Main page
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "General",
        fluidRow(
            valueBoxOutput("observaciones"),
            valueBoxOutput("familias"),
            valueBoxOutput("species")
        ),
        fluidRow(
            box(title = "Publishers", solidHeader = T,
                width = 6, collapsible = T,
                plotly::plotlyOutput("Pub")),
            box(title = "Año de la observación",
                solidHeader = T,
                width = 6,
                collapsible = T,
                plotly::plotlyOutput("Ano"))
        ),
        fluidRow(
            box(title = "Tipo de regitro",
                solidHeader = T,
                width = 6,
                collapsible = T,
                plotly::plotlyOutput("Obs")),
            box(title = "...", solidHeader = T,
                width = 6, collapsible = T,
                plotly::plotlyOutput("..."))
        )
        
    ),
    
    # Second tab content
            tabItem(tabName = "Taxonomia",
                    #h2("teste"))
        fluidRow(
            box(
                title = "Taxon rank", 
                solidHeader = T,
                width = 6, 
                collapsible = T,
                plotly::plotlyOutput("TRank")),
            box(
                title = "Taxon Statuts",
                solidHeader = T,
                width = 6, 
                collapsible = T,
                plotly::plotlyOutput("TStatus")
                )
            ))
    ))
))
