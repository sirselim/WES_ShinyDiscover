library(shiny)
library(shinythemes)
library(DT)

shinyUI(fluidPage(
  
  includeCSS("styles.css"),
  # theme = shinytheme("cerulean"),
  headerPanel('WESTARC: visual results discovery for exome sequence data'),
  sidebarPanel(width = 2,
    textInput("SampleID", label = "Enter SampleID", value="DG1051"),
    checkboxGroupInput('show_vars', 
                       'Columns in results to show:', 
                       names(tier0),
                       selected = names(tier0))
    # helpText('We can select specific columns.')
  ),
  mainPanel(
    tabsetPanel(
      tabPanel('Tier0 variants',
               dataTableOutput("mytable1")),
      tabPanel('Tier1 variants',
               dataTableOutput("mytable2")),
      tabPanel('Tier2 variants',
               dataTableOutput("mytable3")),
      tabPanel('Tier3 variants',
               dataTableOutput("mytable4")),
      tabPanel('MutationAssessor variants',
               dataTableOutput("mytable5"))
    )
  )
))

