library(markdown)
library(shiny)
library(plotly)
library(readr)
library(shinythemes)
summerolympics <- read_csv("/Users/thandisteele/Documents/STAT 310/OlympicsExtravaganza/summer.csv")
winterolympics <-  read_csv("/Users/thandisteele/Documents/STAT 310/OlympicsExtravaganza/winter.csv")
#yeti #unitedred
shinyUI(fluidPage(theme = shinytheme("flatly"),
                  navbarPage("Olympics",
                             navbarMenu("Summer Olympics",
                                        tabPanel("Bar",  
                                                 sidebarLayout(
                                                     sidebarPanel(
                                                         sliderInput("year", "", min=1896, max=2016, value=c(1896, 2016), sep =""),
                                                         radioButtons("button", "Options", choices = list("Top 20 Countries" = "topcountries", "Select Countries" = "countries")),
                                                         conditionalPanel(condition="input.button == 'countries'", selectInput("countries", "Select Countries", choices = countriesList, multiple = TRUE))),
                                                     mainPanel(plotlyOutput("splot"))
                                                 )),
                                        
                                        tabPanel("Search",
                                                 fluidRow(
                                                     column(3,
                                                            selectInput("sport",
                                                                        "Sport:",
                                                                        c("All",
                                                                          unique(as.character(summerolympics$Sport))))
                                                     ),
                                                     
                                                     column(3,
                                                            selectInput("country",
                                                                        "Country:",
                                                                        c("All",
                                                                          unique(as.character(summerolympics$Country))))
                                                     ),
                                                     column(3,
                                                            selectInput("gender",
                                                                        "Gender:",
                                                                        c("All",
                                                                          unique(as.character(summerolympics$Gender))))
                                                     ),
                                                     column(3,
                                                            selectInput("medal",
                                                                        "Medal:",
                                                                        c("All",
                                                                          unique(as.character(summerolympics$Medal))))
                                                     )),
                                                 DT::dataTableOutput("table")
                                        )),
                             navbarMenu("Winter Olympics",
                                        tabPanel("Bar",  
                                                 sidebarLayout(
                                                     sidebarPanel(
                                                         sliderInput("year1", "", min=1924, max=2019, value=c(1924, 2019), sep =""),
                                                         radioButtons("buttonw", "Options", choices = list("Top 20 Countries" = "topcountries1", "Select Countries" = "countries1")),
                                                         conditionalPanel(condition="input.buttonw == 'countries1'", selectInput("countries1", "Select Countries", choices = countrieslistw, multiple = TRUE))),
                                                     mainPanel(plotlyOutput("wplot"))
                                                 )),
                                        
                                        tabPanel("Search",
                                                 fluidRow(
                                                     column(3,
                                                            selectInput("sport2",
                                                                        "Sport:",
                                                                        c("All",
                                                                          unique(as.character(winterolympics$Sport))))
                                                     ),
                                                     
                                                     column(3,
                                                            selectInput("country2",
                                                                        "Country:",
                                                                        c("All",
                                                                          unique(as.character(winterolympics$Country))))
                                                     ),
                                                     column(3,
                                                            selectInput("gender2",
                                                                        "Gender:",
                                                                        c("All",
                                                                          unique(as.character(winterolympics$Gender))))
                                                     ),
                                                     column(3,
                                                            selectInput("medal2",
                                                                        "Medal:",
                                                                        c("All",
                                                                          unique(as.character(winterolympics$Medal))))
                                                     )),
                                                 
                                                 DT::dataTableOutput("tablew")
                                        )),
                             tabPanel("Introduction of Sports",  
                                      sidebarLayout(
                                          sidebarPanel(
                                              radioButtons("button3", "Options", choices = list("10 Sports" = "top", "Select Sports" = "sport1")),
                                              conditionalPanel(condition="input.button3 == 'sport1'", selectInput("sport1", "Select Sports", choices = sportslist, multiple = TRUE))),
                                          mainPanel(plotlyOutput("plot3"))
                                      )))))


