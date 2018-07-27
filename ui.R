# required packages
require('shiny')
require('DT')
require('magrittr')

# shiny ui
shinyUI(fluidPage(
  
  # custom CSS style
  # theme = "lumen.css",
  includeCSS("www/styles.css"),

  headerPanel('VCF-DART Viewer: visual results discovery for NGS variant data'),
  
  sidebarPanel(width = 2, 
  conditionalPanel(condition="input.conditionedPanels==1",
                   helpText('Enter a SampleID and use the Tier tabs to filter exome variants based on the below variables.'),
                   textInput("SampleID", label = "Enter SampleID", value=""),
                   checkboxGroupInput('show_vars', 'Columns in results to show:', names(tier0), selected = names(tier0))
  ),
  conditionalPanel(condition="input.conditionedPanels==2",
                   helpText('This tab presents a list of variants that are all annotated as MutationAssessor and Mutation Taster "highly" damaging.'),
                   helpText('For more detailed information the URL link will take you to the variant listing on MutationAssessor.'),
                   # textInput("SampleID", label = "Enter SampleID", value="DG1051"), # there is an issue here with selecting wrong sample
                   checkboxGroupInput('show_vars2', 'Columns in results to show:', names(MA.table), selected = names(MA.table))
  ),
  conditionalPanel(condition="input.conditionedPanels==3",
                   helpText('This tab allows you to enter a gene, or list of genes (comma seperated), 
                            and retrieve a list of GO terms associtated with each gene.'),
                   helpText('i.e. input: "DDO, FTO, ATXN1" and press submit.'),
                   helpText('Note: as this is accessing the GO servers it can take a min or two, please be patient.')
  ),
  conditionalPanel(condition="input.conditionedPanels==4",
                   helpText('Biodalliance Embedded Genome Viewer.'),
                   helpText('NOTE: this is now functioning but still under development.')
  ),
  conditionalPanel(condition="input.conditionedPanels==5",
                   helpText('Downloads section (TESTING).'),
                   helpText('NOTE: this section is still under development.')),
  conditionalPanel(condition="input.conditionedPanels==6",
                   helpText('Help section (TESTING).'),
                   helpText('NOTE: this section is still under development.'))
  ),
  
  mainPanel(
    tabsetPanel(id = "conditionedPanels",
      tabPanel('Tier0 variants', value=1,
               helpText("NOTE: This  tier consists of all genes known to cause the conditions being investigated."),
               dataTableOutput("mytable1")),
      tabPanel('Tier1 variants', value=1,
               helpText("NOTE: This tier consists of all genes in families or superfamilies which include the first tier genes, 
                        in addition to any genes known to cause conditions or symptoms related to the primary analysis question."),
               dataTableOutput("mytable2")),
      tabPanel('Tier2 variants', value=1,
               helpText("NOTE: This tier consists of genes in metabolic pathways known to be involved in 
                        causing the conditions being investigated."),
               dataTableOutput("mytable3")),
      tabPanel('Tier3 variants', value=1,
               helpText("NOTE: This tier includes all other genes and loci not included in the first three."),
               dataTableOutput("mytable4")),
      tabPanel('MutationAssessor variants', value=2,
               h3('MutationAssessor variants for ',textOutput('currentSample', inline = T), align = "center"),
               dataTableOutput("mytable5")),
      tabPanel('GO search', value=3,
               fluidRow(
                 column(11, textInput("GeneSymbol", label = "Enter gene symbol", value="", width = '100%')),
                 column(1, align = 'right', actionButton(inputId = "submit_loc", label = "Submit"), class = 'rightAlign')
               ),
               verbatimTextOutput('GO_genes'),
               dataTableOutput("GOtable")),
      tabPanel('Biodalliance Genome Viewer', value=4,
               includeHTML('biodall.html')),
      tabPanel('Downloads', value=5,
              tags$h1("Clinical Report Document"),
              helpText("Click below to download the generated clinical report (.docx) for this sample."),
              downloadButton("downloadData", label = "Download Report"),
              HTML('<hr style="color: black;">'),
              tags$h1("Run Log File"),
              helpText("Click below to download the log file (.log) for this samples annotation run."),
              downloadButton("downloadData_log", label = "Download Log File"),
              HTML('<hr style="color: black;">'),
              tags$h1("All files (compressed)"),
              helpText("Click below to download a compressed file (tar.gz) containing the run directory with all data and results."),
              downloadButton("downloadData_all", label = "Download All Data")),
      tabPanel('Help', value=6,
               tags$h1("Help / Getting Started [...under construction...]"),
               includeHTML('help.html'))
    )
  )
))