library(shiny)

createLink <- function(val) {
  sprintf('<a href="%s" target="_blank" class="btn btn-primary">Link to Variant</a>',val)
}

shinyServer(function(input, output) {

  # create reactive data for table
  tier0 <- reactive({
    
    sample.list <- res.list[grep(input$SampleID, res.list)]
    tier0.file <- sample.list[grep('Tier0', sample.list)]
    tier0 <- read.csv(tier0.file, head = T, as.is = T)

  })
  # create reactive data for table
  tier1 <- reactive({
    
    sample.list <- res.list[grep(input$SampleID, res.list)]
    tier1.file <- sample.list[grep('Tier1', sample.list)]
    tier1 <- read.csv(tier1.file, head = T, as.is = T)
    
  })
  # create reactive data for table
  tier2 <- reactive({
    
    sample.list <- res.list[grep(input$SampleID, res.list)]
    tier2.file <- sample.list[grep('Tier2', sample.list)]
    tier2 <- read.csv(tier2.file, head = T, as.is = T)
    
  })
  # create reactive data for table
  tier3 <- reactive({
    
    sample.list <- res.list[grep(input$SampleID, res.list)]
    tier3.file <- sample.list[grep('Tier3', sample.list)]
    tier3 <- read.csv(tier3.file, head = T, as.is = T)
    
  })
  
  # create reactive data for MutationAssessor data if available
  MA.table <- reactive({
    
    MA.list <- MutAssess.links[grep(input$SampleID, MutAssess.links)]
    MA.table <- read.table(MA.list, head = T, as.is = T)
    
  })
  
  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable1 = renderDataTable({
    tier0()[, input$show_vars, drop = FALSE]
  }, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
      options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100), pageLength = 10,
                     "dom" = 'T<"clear">lBfrtip',
                     buttons = list('copy', 'print', list(
                       extend = 'collection',
                       buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_tier0_filtered')), 
                                      list(extend = 'excel', filename = paste0(input$SampleID, '_tier0_filtered')),
                                      list(extend = 'pdf', filename = paste0(input$SampleID, '_tier0_filtered'))),
                       text = 'Download'
                     ))))

  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable2 = renderDataTable({
    tier1()[, input$show_vars, drop = FALSE]
  }, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
     options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100), pageLength = 10,
                     "dom" = 'T<"clear">lBfrtip',
                    buttons = list('copy', 'print', list(
                      extend = 'collection',
                      buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_tier1_filtered')), 
                                     list(extend = 'excel', filename = paste0(input$SampleID, '_tier1_filtered')),
                                     list(extend = 'pdf', filename = paste0(input$SampleID, '_tier1_filtered'))),
                      text = 'Download'
                    ))))

  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable3 = renderDataTable({
    tier2()[, input$show_vars, drop = FALSE]
  }, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
      options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100), pageLength = 10,
                    "dom" = 'T<"clear">lBfrtip',
                    buttons = list('copy', 'print', list(
                      extend = 'collection',
                      buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_tier2_filtered')), 
                                     list(extend = 'excel', filename = paste0(input$SampleID, '_tier2_filtered')),
                                     list(extend = 'pdf', filename = paste0(input$SampleID, '_tier2_filtered'))),
                      text = 'Download'
                    ))))
  
  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable4 = renderDataTable({
    tier3()[, input$show_vars, drop = FALSE]
  }, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
      options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100), pageLength = 10,
                    "dom" = 'T<"clear">lBfrtip',
                    buttons = list('copy', 'print', list(
                      extend = 'collection',
                      buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_tier3_filtered')), 
                                     list(extend = 'excel', filename = paste0(input$SampleID, '_tier3_filtered')),
                                     list(extend = 'pdf', filename = paste0(input$SampleID, '_tier3_filtered'))),
                      text = 'Download'
                    ))))

  output$mytable5 = renderDataTable({
    MA.out <- MA.table()
    MA.out$URL <- createLink(MA.out$URL)
    return(MA.out)
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip',
                 buttons = list('copy', 'print', list(
                   extend = 'collection',
                   buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_tier3_filtered')), 
                                  list(extend = 'excel', filename = paste0(input$SampleID, '_tier3_filtered')),
                                  list(extend = 'pdf', filename = paste0(input$SampleID, '_tier3_filtered'))),
                   text = 'Download'
                 ))))
  
})

