library(shinydashboard)
library(shiny)
library(leaflet)
library(tidyverse)
library(plotly)



dashboardPage(

  dashboardHeader(
    title = span( tagList( icon("lungs-virus"), "Coronavirus"))
    ),
  
  dashboardSidebar(
    width = 230,
    sidebarMenu(
      selectizeInput('regions', 'Multi-select Regions', 
                     choices = unique(df$region), 
                     multiple = TRUE, 
                     width = 'auto'),
      dateRangeInput("date", "Enter Date Range", 
                     start = '2020/01/22', end = max(df$date),
                     min = '2020/01/22', max =max(df$date)),
      menuItem("Current Statistics", tabName = "Core", icon = icon('th')),
      menuItem("Coronavirus Datatable", tabName = "Core2", icon = icon('table')),
      menuItem("Confirmed by Country", tabName = "Core3", icon = icon('bar-chart-o')),
      menuItem("Deaths by Country", tabName = "Menu1", icon = icon('bar-chart-o')),
      menuItem("US Confirmed Cases (June)", tabName = "Menu2", icon = icon('table')),
      menuItem("GA Monthly Trend", tabName = "Menu3", icon = icon('chart-line')),
      menuItem("Recovery Rate", tabName = "Menu4", icon = icon('medkit')),
      menuItem("First Recovered Case", tabName = "Menu5", icon = icon('ambulance')),
      menuItem("Global Confirmed Cases", tabName = "Menu6", icon = icon('map')),
      menuItem("Developers", tabName = "Devs", icon = icon('address-card')),
      menuItem("Sources", tabName = "Sauce", icon = icon("github-square"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "Core",
              h3("Current Statistics"),
              box(title = "Global totals",
                  footer = "Edit totals with end date",
                  solidHeader = TRUE, 
                  verbatimTextOutput("text"))
      ),
      tabItem(tabName = "Core2",
              box(title = 'Coronavirus Datatable',
                  dataTableOutput('table'))
              ),
      tabItem(tabName = "Core3",
              box(title = "Top 5 Countries with Highest Confirmed Cases",
                  solidHeader = TRUE, 
                  plotOutput("plot"))
              ),
      tabItem(tabName = "Menu1", 
              box(
                title = "Top 5 Countries with Most Deaths",
                solidHeader = TRUE, 
                plotOutput("plot2")
              )
      ),
      tabItem(tabName = "Menu2",
              box(
                title = "US States Confirmed Cases in June 2020",
                id = 'tab2',
                height = 'auto',
                solidHeader = TRUE, 
                dataTableOutput("table2")
              )
      ),
      tabItem(tabName = "Menu3",
              box(
                title = "Monthly GA Trends in Confirmed Cases",
                id = 'tab2',
                height = 'auto',
                solidHeader = TRUE, 
                plotlyOutput("plot3")
              )
      ),
      tabItem(tabName = "Menu4",
              box(
                title = "Global Recovery Rate",
                id = 'tab5',
                height = 'auto',
                solidHeader = TRUE, 
                dataTableOutput('table3')
              )
      ),
      tabItem(tabName = "Menu5",
              box(
                title = "First Recovered Persons in the US",
                id = 'tab6',
                height = 'auto',
                width = 'auto',
                solidHeader = TRUE, 
                verbatimTextOutput('text2')
              )),
      tabItem(tabName = "Menu6",
              box(
                title = "Global Map of Coronavirus",
                id = 'tab6',
                solidHeader = TRUE, 
                leafletOutput('map')
              )),
      tabItem(tabName = "Devs",
              box(
                  title = "Kevin Chen",
                  id = "KC",
                  textOutput("reach"), 
                  a("Linkedin", href="https://www.linkedin.com/in/kevinchen404/", target="_blank"),
                  a("Github", href="https://github.com/kchen11", target="_blank")
                ),
              box(title = "Shayela Alam",
                  id = "SA"
                  ),
              box(title = "Samuel Doan",
                  id = "SD"
                  )
              ),
      tabItem(tabName = "Sauce",
              box(title = "Coronavirus Data Source",
                  id = 'link',
                  textOutput('saucy'),
                  a("Github", href="https://github.com/CSSEGISandData/COVID-19", target="_blank"))
              )
    )
  ),
  title = "Coronavirus Dashboard"
)
