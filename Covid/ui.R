library(shinydashboard)
library(shinydashboardPlus)
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
      menuItem("Current Statistics", tabName = "Core", icon = icon('calendar')),
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
      tabItem(
        tabName = "Core",
        fluidRow(
          tabBox(
            tabPanel("Global totals", verbatimTextOutput("text"), 
                     icon = icon('th')),
            tabPanel("Top 5 Countries with Highest Confirmed Cases", 
                     plotOutput("plot"), icon = icon('bar-chart-o')),
            tabPanel("Coronavirus Datatable", dataTableOutput("table"), 
                     icon = icon('table'))
          ),
          box(
            width = 2,
            selectizeInput('regions', 'Multi-select Regions', 
                           choices = unique(df$region), 
                           multiple = TRUE, 
                           width = 'auto'),
            
            dateRangeInput("date", "Enter Date Range", 
                           start = '2020/01/22', end = max(df$date),
                           min = '2020/01/22', max = max(df$date))
          )
        )
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

      tabItem(tabName = "Sauce",
              box(title = "Coronavirus Data Source",
                  id = 'link',
                  textOutput('saucy'),
                  a("Github", href="https://github.com/CSSEGISandData/COVID-19", target="_blank")),
              box(title = "Icon Data Source",
                  id = 'link',
                  textOutput('saucyicon'),
                  a("Flaticon", href="https://www.flaticon.com/", target="_blank")
              )
              ),
      tabItem(tabName = "Devs",
              widgetUserBox(
                title = "Kevin Chen",
                subtitle = "Data Analyst",
                type = 2,
                src = "https://cdn.frankerfacez.com/emoticon/290036/4",
                background = TRUE,
                backgroundUrl = "https://images.unsplash.com/photo-1470290449668-02dd93d9420a?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D",
                closable = TRUE,
                "Feel free to reach out!",
                a("Linkedin", href="https://www.linkedin.com/in/kevinchen404/", target="_blank"),
                a("Github", href="https://github.com/kchen11", target="_blank")
              ),
              widgetUserBox(
                title = "Shayela Alam",
                subtitle = "Data Analyst",
                type = 2,
                src = "https://www.flaticon.com/svg/static/icons/svg/843/843331.svg",
                background = TRUE,
                backgroundUrl = "https://images.unsplash.com/photo-1604430931972-c2cd5e10004f?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D",
                closable = TRUE
              ),
              widgetUserBox(
                title = "Samuel Doan",
                subtitle = "Cybersecurity Specialist",
                type = 2,
                src = "https://www.flaticon.com/svg/static/icons/svg/2716/2716612.svg",
                background = TRUE,
                backgroundUrl = "https://images.unsplash.com/photo-1604093882750-3ed498f3178b?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D ",
                closable = TRUE
              )
      )
    )
  ),
  title = "Coronavirus Dashboard"
)
