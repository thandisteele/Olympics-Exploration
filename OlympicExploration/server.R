summerolympics <- read_csv("summer.csv")
winterolympics <-  read_csv("winter.csv")
introduction <- read_csv("introduction_of_women_olympic_sports.csv")
library(tidyverse)
library(shiny)
library(plotly)
library(readr)
library(forcats)

countriesList <- unique(summerolympics$Country)
countrieslistw <- unique(winterolympics$Country)
sportslist <- unique(introduction$Sports)

top20Countries <- summerolympics %>% group_by(Country) %>%
    summarize(medalCount = n()) %>%
    arrange(desc(medalCount)) %>%
    slice_head(n = 20)

top20CountriesW <- winterolympics %>% group_by(Country) %>%
    summarize(medalCount = n()) %>% arrange(desc(medalCount)) %>%
    slice_head(n = 20)

firstsports <- introduction %>% arrange(Sports, desc(Year)) %>% slice_head(n=20)


shinyServer(function(input, output, session) {
    
    sdata <- reactive({
        if (input$button == "topcountries") {
            df <- summerolympics %>% filter(Country %in% top20Countries$Country)
        } else {
            df <- summerolympics %>% filter(Country %in% input$countries)
        }
        df <- filter(df, Year >= input$year[1] & Year <= input$year[2])
        return(df)
    })
    
    
    output$splot <- renderPlotly({
        splot <- sdata() %>% 
            select(Country, Medal) %>%
            ggplot(aes(x=forcats::fct_infreq(Country), fill =factor(Medal, levels = c("Bronze", "Silver", "Gold"))))+ geom_bar(stat = "count", position = "stack") +  scale_fill_manual(values = c("cyan3", "deepskyblue3", "dodgerblue4")) + xlab("") + ylab("")+
            guides(fill=guide_legend(title="")) +
            theme(axis.text.x = element_text(size=10, angle=45))
        
        ggplotly(splot, tooltip=c("count"))
    })
    
    
    output$table <- DT::renderDataTable(DT::datatable({
        data <- summerolympics
        if (input$country != "All") {
            data <- data[data$Country == input$country,] 
        }
        if (input$sport != "All") {
            data <- data[data$Sport == input$sport,]
        }
        if (input$gender != "All") {
            data <- data[data$Gender == input$gender,]
        }
        if (input$medal != "All") {
            data <- data[data$Medal == input$medal,]
        }
        data      
    }))
    
    
    wdata <- reactive({
        
        if (input$buttonw == "topcountries1") {
            df1 <- winterolympics[winterolympics$Country %in% top20CountriesW$Country,]
        } 
        else {
            df1 <- winterolympics[winterolympics$Country %in% input$countries1,]  
        }
        df1 <- filter(df1, Year >= input$year1[1] & Year <= input$year1[2])
        return(df1)
    })
    
    output$wplot <- renderPlotly({
        wplot <- wdata() %>% 
            select(Country, Medal) %>%
            ggplot(aes(x=forcats::fct_infreq(Country), fill =factor(Medal, levels = c("Bronze", "Silver", "Gold"))))+ geom_bar(stat = "count", position = "stack") +  scale_fill_manual(values = c("coral2", "brown2", "firebrick4")) + xlab("") + ylab("")+
            guides(fill=guide_legend(title="")) +
            theme(axis.text.x = element_text(size=10, angle=45))
        
        ggplotly(wplot, tooltip=c("count")) 
    })
    
    
    
    
    
    
    
    
    output$tablew <- DT::renderDataTable(DT::datatable({
        data1 <- winterolympics
        if (input$country2 != "All") {
            data1 <- data1[data1$Country == input$country2,] 
        }
        if (input$sport2 != "All") {
            data1 <- data1[data1$Sport == input$sport2,]
        }
        if (input$gender2 != "All") {
            data1 <- data1[data1$Gender == input$gender2,]
        }
        if (input$medal2 != "All") {
            data1 <- data1[data1$Medal == input$medal2,]
        }
        data1        
    }))
    
    
    observeEvent(input$button3, {
        updateSelectInput(session, "sport1", choices = sportslist)
    })
    
    
    introdata <- reactive({
        if (input$button3 == "top") {
            df4 <- introduction %>% filter(Sports %in% firstsports$Sports)
        }
        else 
            if (input$button3 == "sport1") {
                req(input$sport1)
                df4 <- introduction %>% filter(Sports %in% input$sport1)
            }
        return(df4)
    })
    
    
    output$plot3 <- renderPlotly({
        plot3 <- introdata() %>%
            ggplot(aes(x= Year, y = Sports)) + geom_line(aes(group = Sports)) + 
            geom_point(aes(color = Gender, size = 12, alpha = 0.5)) + xlab("") + ylab("") 
        ggplotly(plot3,tooltip=c("Year"))
    })
})
