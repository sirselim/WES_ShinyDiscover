library(shiny)
library(biomartr)
library(DT)

shinyUI(fluidPage(
  
  # theme = "lumen.css",
  includeCSS("www/styles.css"),

  headerPanel('WESTARC: visual results discovery for exome sequence data'),
  
  sidebarPanel(width = 2, 
  conditionalPanel(condition="input.conditionedPanels==1",
                   helpText('Enter a SampleID and use the Tier tabs to filter exome variants based on the below variables.'),
                   textInput("SampleID", label = "Enter SampleID", value="DG1051"),
                   checkboxGroupInput('show_vars', 'Columns in results to show:', names(tier0), selected = names(tier0))
  ),
  conditionalPanel(condition="input.conditionedPanels==2",
                   helpText('This tab presents a list of variants that are all annotated as MutationAssessor "highly" damaging.'),
                   helpText('For more detailed information the URL link will take you to the variant listing on MutationAssessor.'),
                   textInput("SampleID", label = "Enter SampleID", value="DG1051"),
                   checkboxGroupInput('show_vars2', 'Columns in results to show:', names(MA.table), selected = names(MA.table))
  ),
  conditionalPanel(condition="input.conditionedPanels==3",
                   helpText('This tab allows you to enter a gene, or list of genes (comma seperated), 
                            and retrieve a list of GO terms associtated with each gene.'),
                   helpText('i.e. input: "DDO, FTO, ATXN1" and press submit.'),
                   helpText('Note: as this is accessing the GO servers it can take a min or two, please be patient.')
  )),
  
  mainPanel(
    tabsetPanel(id = "conditionedPanels",
      tabPanel('Tier0 variants', value=1,
               dataTableOutput("mytable1")),
      tabPanel('Tier1 variants', value=1,
               dataTableOutput("mytable2")),
      tabPanel('Tier2 variants', value=1,
               dataTableOutput("mytable3")),
      tabPanel('Tier3 variants', value=1,
               dataTableOutput("mytable4")),
      tabPanel('MutationAssessor variants', value=2,
               dataTableOutput("mytable5")),
      tabPanel('GO search', value=3,
               fluidRow(
                 column(11, textInput("GeneSymbol", label = "Enter gene symbol", value="", width = '100%')),
                 column(1, align = 'right', actionButton(inputId = "submit_loc", label = "Submit"), class = 'rightAlign')
               ),
               verbatimTextOutput('GO_genes'),
               dataTableOutput("GOtable"))
    )
  )
))

