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
            menuItem("general", tabName = "general", icon = icon("dashboard")),
            menuItem("Widgets", tabName = "widgets", icon = icon("th"))
        )),

        # Main page
    dashboardBody(
        tabItems(
            # First tab content
            tabItem(tabName = "general",
        fluidRow(
            valueBoxOutput("observaciones"),
            valueBoxOutput("familias"),
            valueBoxOutput("rich_nutrient")
        ),
        fluidRow(
            box(title = "Biodiversity",
                solidHeader = T,
                width = 6,
                collapsible = T,
                div(DT::DTOutput("biodiversity"), style = "font-size: 70%;")),
            box(title = "Publishers", solidHeader = T,
                width = 6, collapsible = T,
                plotlyOutput("Pub"))
        ),
        fluidRow(
            box(title = "Tipo de regitro",
                solidHeader = T,
                width = 6,
                collapsible = T,
                plotlyOutput("Obs")),
            box(title = "...", solidHeader = T,
                width = 8, collapsible = T,
                plotlyOutput("..."))
        )
        
    ),
    # Second tab content
    tabItem(tabName = "widgets",
            h2("Widgets tab content")
    )
        )
    )
))
