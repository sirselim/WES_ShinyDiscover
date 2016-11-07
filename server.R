library(shiny)

createLink <- function(val) {
  sprintf('<a href="%s" target="_blank" class="btn btn-primary">Link to Variant</a>',val)
}

shinyServer(function(input, output) {

  # create reactive data for table
  tier0 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res.list[grep(input$SampleID, res.list, fixed = T)]
    tier0.file <- sample.list[grep('Tier0', sample.list)]
    tier0 <- read.csv(tier0.file, head = T, as.is = T)

  })
  # create reactive data for table
  tier1 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res.list[grep(input$SampleID, res.list, fixed = T)]
    tier1.file <- sample.list[grep('Tier1', sample.list)]
    tier1 <- read.csv(tier1.file, head = T, as.is = T)
    
  })
  # create reactive data for table
  tier2 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res.list[grep(input$SampleID, res.list, fixed = T)]
    tier2.file <- sample.list[grep('Tier2', sample.list)]
    tier2 <- read.csv(tier2.file, head = T, as.is = T)
    
  })
  # create reactive data for table
  tier3 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res.list[grep(input$SampleID, res.list, fixed = T)]
    tier3.file <- sample.list[grep('Tier3', sample.list)]
    tier3 <- read.csv(tier3.file, head = T, as.is = T)
    
  })
  
  # create reactive data for MutationAssessor data if available
  MA.table <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    MA.list <- MutAssess.links[grep(input$SampleID, MutAssess.links, fixed = T)]
    MA.table <- read.table(MA.list, head = T, as.is = T)
    
  })
  
  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable1 = renderDataTable({
    
    validate(
      need(try(nrow(tier0() > 0)), paste0("Warning: data missing for ", input$SampleID))
    )
    
    tier0()[, input$show_vars, drop = FALSE]
  }, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 1: ', htmltools::em('A list of variants passing the filter criteria for Tier0 (gene panel variants).')
  ), plugins = 'natural', server = F,
      options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                     "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                     buttons = list('copy', 'print', list(
                       extend = 'collection',
                       buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_tier0_filtered_', file.time)), 
                                      list(extend = 'excel', filename = paste0(input$SampleID, '_tier0_filtered_', file.time)),
                                      list(extend = 'pdf', filename = paste0(input$SampleID, '_tier0_filtered_', file.time))),
                       text = 'Download'
                     ))))

  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable2 = renderDataTable({
    
    validate(
      need(try(nrow(tier1() > 0)), paste0("Warning: data missing for ", input$SampleID))
    )
    
    tier1()[, input$show_vars, drop = FALSE]
  }, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 2: ', htmltools::em('A list of variants passing the filter criteria for Tier1.')
  ), plugins = 'natural', server = F,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                    buttons = list('copy', 'print', list(
                      extend = 'collection',
                      buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_tier1_filtered_', file.time)), 
                                     list(extend = 'excel', filename = paste0(input$SampleID, '_tier1_filtered_', file.time)),
                                     list(extend = 'pdf', filename = paste0(input$SampleID, '_tier1_filtered_', file.time))),
                      text = 'Download'
                    ))))

  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable3 = renderDataTable({
    
    validate(
      need(try(nrow(tier2() > 0)), paste0("Warning: data missing for ", input$SampleID))
    )
    
    tier2()[, input$show_vars, drop = FALSE]
  }, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 3: ', htmltools::em('A list of variants passing the filter criteria for Tier2.')
  ), plugins = 'natural', server = T,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                    buttons = list('copy', 'print', list(
                      extend = 'collection',
                      buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_tier2_filtered_', file.time)), 
                                     list(extend = 'excel', filename = paste0(input$SampleID, '_tier2_filtered_', file.time)),
                                     list(extend = 'pdf', filename = paste0(input$SampleID, '_tier2_filtered_', file.time))),
                      text = 'Download'
                    ))))
  
  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable4 = renderDataTable({
    
    validate(
      need(try(nrow(tier3() > 0)), paste0("Warning: data missing for ", input$SampleID))
    )
    
    tier3()[, input$show_vars, drop = FALSE]
  }, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 4: ', htmltools::em('A list of variants passing the filter criteria for Tier3.')
  ), plugins = 'natural', server = T,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                    buttons = list('copy', 'print', list(
                      extend = 'collection',
                      buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_tier3_filtered_', file.time)), 
                                     list(extend = 'excel', filename = paste0(input$SampleID, '_tier3_filtered_', file.time)),
                                     list(extend = 'pdf', filename = paste0(input$SampleID, '_tier3_filtered_', file.time))),
                      text = 'Download'
                    ))))

  output$mytable5 = renderDataTable({
    
    validate(
      need(try(nrow(MA.table() > 0)), paste0("Warning: data missing for ", input$SampleID))
    )
    
    MA.out <- MA.table()
    MA.out$URL <- createLink(MA.out$URL)
    return(MA.out)
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 5: ', htmltools::em('A list of variants predicted as being potentially most damaging (Mutation Assessor High risk), including URL to variant information.')
  ), plugins = 'natural', server = F,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                 buttons = list('copy', 'print', list(
                   extend = 'collection',
                   buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_MutationAssessor_filtered_', file.time)), 
                                  list(extend = 'excel', filename = paste0(input$SampleID, '_MutationAssessor_filtered_', file.time)),
                                  list(extend = 'pdf', filename = paste0(input$SampleID, '_MutationAssessor_filtered_', file.time))),
                   text = 'Download'
                 ))))
  
})

