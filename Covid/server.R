library(scales)
library(DT)
library(leaflet)
library(RColorBrewer)
library(tidyverse)
library(htmlwidgets)
library(widgetframe)
library(plotly)

function(input, output, session) {

  #Core Objective 1
  output$text <- renderText({
    
    df <- df %>%
      group_by(region) %>%
      filter(date == input$date[2] & region %in% input$regions) %>%
      select(date, region, confirmed, death, recovered)
      
    paste0("The total confirmed cases in the selected regions as of ",input$date[2], " is: ", sum(df$confirmed), sep = '\n',
           "The total deaths in the selected regions as of ",input$date[2], " is: ", sum(df$death), sep = '\n',
           "The total recovered cases in the selected regions as of ",input$date[2], " is: ", sum(df$recovered))
    
  })
  #Core Objective 2
  output$plot <- renderPlot({
    
    df <- df %>%
      group_by(region) %>%
      filter(date == input$date[2] & region %in% input$regions) %>%
      arrange(desc(confirmed)) %>%
      head(5)
    
    
    plot <- df %>%
      ggplot(aes(x = reorder(region, -confirmed), y = confirmed, 
                 fill = factor(confirmed), label = df$confirmed, 
                 size =  df$confirmed)) + 
      geom_bar(stat = 'identity') + 
      labs(x = "Country") + 
      geom_text(size = 5, vjust= 1.4) + 
      scale_y_continuous(name="Confirmed", labels = comma)
    
    plot + 
      scale_fill_brewer(palette = "Reds") + 
      theme(legend.position = "none", 
            axis.text.x = element_text(size = 12.5), 
            axis.text.y = element_text(size = 12.5),
            axis.title.x = element_text(size = 15, 
                                        margin = margin(t = 7.5)), 
            axis.title.y = element_text(size = 15, 
                                        margin = margin(r = 15)),
            panel.spacing.y=unit(2, "lines") ) 
    
  })
  #Core Objective 3
  output$table <- renderDataTable({

    region <- reactive({
      filter(df, region %in% input$regions) %>%
      filter(date >= input$date[1] & date <= input$date[2])
    })
    
    datatable(region(), 
              colnames = c('Date', 'Region', 'Confirmed', 
                           'Death', 'Recovered'),
              caption = "To use this table, use the filter options: date and region", 
              extensions = c('Scroller', 'Buttons'),
              options = list(
                dom = 'Bfrtip',
                orderMulti = TRUE,
                searching = TRUE,
                scroller = TRUE,
                scrollY = 500,
                deferRender = TRUE,
                buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
              )
    )
  }, server = FALSE)
  # Menu Objective 1
  output$plot2 <- renderPlot({
    
    df <- df %>%
      group_by(region) %>%
      filter(date == max(date)) %>%
      arrange(desc(death)) %>%
      head(5)
    
    plot2 <- df %>%
      ggplot(aes(x = reorder(region,-death), y = death, fill = factor(death), 
                 label = df$death, size = df$death)) + 
      geom_bar(stat = 'identity') + 
      labs(x = "Country", y = "Deaths") + 
      scale_y_continuous(name="Death", labels = comma) + 
      geom_text(size = 5, vjust= 1.4)
    
    plot2 + 
      scale_fill_brewer(palette = "Blues") + 
      theme(legend.position = "none", 
            axis.text.x = element_text(size = 12.5), 
            axis.text.y = element_text(size = 12.5),
            axis.title.x = element_text(size = 15, 
                                        margin = margin(t = 7.5)), 
            axis.title.y = element_text(size = 15, 
                                        margin = margin(r = 15)),
            panel.spacing.y=unit(2, "lines") ) 
    
    
  })
  # Menu Objective 2
  output$table2 <- renderDataTable({
    
    ga_confirmed_june <- confirmed_us_df %>% 
      rename(region = `Country_Region`,
             sub_region = `Province_State`) %>% 
      group_by(sub_region,date, month, year) %>%
      filter(month == 6 & day == 30 & year == 2020) %>%
      summarise(confirmed = sum(confirmed), .groups = 'drop') %>%
      select_all()
    
    ga_confirmed_may <- confirmed_us_df %>% 
      rename(region = `Country_Region`,
             sub_region = `Province_State`) %>% 
      group_by(sub_region,date, month, year) %>%
      filter(month == 5 & day == 31 & year == 2020) %>%
      summarise(confirmed = sum(confirmed), .groups = 'drop') %>%
      select_all()
    
    ga_june <- ga_confirmed_june %>%
      left_join(ga_confirmed_may) %>%
      mutate(confirmed = (ga_confirmed_june$confirmed - ga_confirmed_may$confirmed)) %>%
      filter(confirmed > 1000) %>%
      select(sub_region, confirmed, month, year)
    
    
    datatable(ga_june, 
              colnames = c("Region", "Confirmed", "Month", "Year"),
              extensions = c('Responsive','Scroller', 'Buttons'),
              options = list(dom = 'Bfrtip',
                             scroller = TRUE,
                             scrollY = 500,
                             deferRender = TRUE,
                             buttons = c('copy', 'csv', 'excel', 'pdf', 'print'))
    )
  })
  # Menu Objective 3
  output$plot3 <- renderPlotly({
    
    us <- df_us %>%
      group_by(region, sub_region, date, month, year) %>%
      filter(sub_region == 'Georgia') %>%
      subset(!duplicated(substr(date, 1, 8), fromLast = TRUE)) %>%
      select_all()
    
    
    p <- us %>%
      ggplot(aes(x= date, y = confirmed), stat = "identity", label = us$confirmed) +
      geom_line(color="#69b3a2") +
      geom_area(fill="#69b3a2", alpha=0.5) + 
      scale_y_continuous(breaks = seq(0, max(us$confirmed), 50000))
    
    # Turn it interactive with ggplotly
    p <- ggplotly(p)
    
    p
    
  })
  #Menu Objective 4
  output$table3 <- renderDataTable({
    
    df <- df %>%
      mutate(recovery_rate = (round(recovered/confirmed * 100, 2))) %>%
      group_by(region) %>%
      filter(date == max(date) & confirmed > 100000) %>%
      select(region, date, confirmed, recovered, recovery_rate) %>%
      arrange(desc(recovery_rate))
    
    datatable(df, 
              colnames = c("Region", "Date", "Confirmed", "Recovered","Recovery Rates (%)"),
              caption = "Recovery Data may not reflect real-world representation 
              in some countries due to poor data recording",
              extensions = c('Responsive','Scroller', 'Buttons'),
              options = list(dom = 'Bfrtip',
                             scroller = TRUE,
                             scrollY = 500,
                             deferRender = TRUE,
                             buttons = c('copy', 'csv', 'excel', 'pdf', 'print'))
    )
  })
  #Menu Objective 5
  output$text2<- renderText({
    
    us_recovery <- recovered_cases_all %>%
      group_by(region, date, recovered) %>%
      filter(region == 'US' & recovered >= 1) %>%
      head(1) %>%
      select_all()
    
    paste0("The first recorded individuals to recover from the coronavirus in the USA was on ", 
           min(us_recovery$date), " where ", unique(us_recovery$recovered)," persons recovered.")
  })
  #Menu Objective 6
  {  
    df_map <- df_global %>%
      filter(date == max(date)) %>%
      select_all()
    
    
    mapped <-         
      leaflet() %>%
      addTiles() %>%
      addMarkers(lng = df_map$Long, lat = df_map$Lat, 
                 clusterOptions = markerClusterOptions(),
                 popup = paste("Region: ", df_map$region, "<br>",
                               "Sub-Region: ", df_map$sub_region, "<br>",
                               "Confirmed Cases: ", as.character(df_map$confirmed), "<br>",
                               "Deaths: ", as.character(df_map$death), "<br>",
                               "As of ", as.Date(df_map$date), "<br>"))
    mapped %>%
      frameWidget()
  }
  output$map <- renderLeaflet({mapped})
  #Icon Source
  output$saucyicon <- renderText({
    paste0("Source for icons")
  })
  #data source
  output$saucy <- renderText({
    paste0("New date will be released at 05:15 GMT, until the pandemic is over.", 
           sep = '\n',
          "The link can be found below!")
  })
  
}
