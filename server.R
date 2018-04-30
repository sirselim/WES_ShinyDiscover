## define functions to use throughout server script
# create an html button linking out to Mutation Assessor which can be rendered in Shiny (by DT)
createLink <- function(val) {
  sprintf('<a href="%s" target="_blank" class="btn btn-primary">Link to Variant</a>', val)
}
# create an html link to NCBI for SNPs which can be rendered in Shiny (by DT)
createSNPLink <- function(val) {
  # if there are mutiple snps split and unlist them
  val <- unlist(strsplit(val, split = ';'))
  snp <- NULL
  # loop through multiple snps if present
  for (i in val) {
    # check if there is no snp ID, make NA if so
    if (i == ".") {
      snp <- "NA"
      # else create html links for each snp present
    } else {
      snp <- paste(snp, sprintf(paste0('<a href="https://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?rs=%s" target="_blank">', i, '</a>'), i), sep = ';')
    }
  }
  # clean up leading ';' if present
  snp <- gsub('^;<', '<', snp)
}

## shiny server
shinyServer(function(input, output) {
  
  # create sampleID
  output$currentSample <- renderText({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    currentSample <- as.character(input$SampleID)
    as.character(currentSample)
    
  })
  
  # create reactive data for table
  tier0 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res.list[grep(input$SampleID, res.list, fixed = T)]
    tier0.file <- sample.list[grep('Tier0', sample.list)]
    tier0 <- read.csv(tier0.file, head = T, as.is = T)
    # strange issue with newer VEP, adds '%3D' to syn ammino acid output - quick fix for now
    tier0$AAchange <- gsub('.*%3D', '.', tier0$AAchange)
    # create a URL link to NCBI for SNPs
    tier0$dbSNP <- unlist(lapply(tier0$dbSNP, createSNPLink))
    return(tier0)

  })
  # create reactive data for table
  tier1 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res.list[grep(input$SampleID, res.list, fixed = T)]
    tier1.file <- sample.list[grep('Tier1', sample.list)]
    tier1 <- read.csv(tier1.file, head = T, as.is = T)
    # strange issue with newer VEP, adds '%3D' to syn ammino acid output - quick fix for now
    tier1$AAchange <- gsub('.*%3D', '.', tier1$AAchange)
    # create a URL link to NCBI for SNPs
    tier1$dbSNP <- unlist(lapply(tier1$dbSNP, createSNPLink))
    return(tier1)
    
  })
  # create reactive data for table
  tier2 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res.list[grep(input$SampleID, res.list, fixed = T)]
    tier2.file <- sample.list[grep('Tier2', sample.list)]
    tier2 <- read.csv(tier2.file, head = T, as.is = T)
    # strange issue with newer VEP, adds '%3D' to syn ammino acid output - quick fix for now
    tier2$AAchange <- gsub('.*%3D', '.', tier2$AAchange
    # create a URL link to NCBI for SNPs
    tier2$dbSNP <- unlist(lapply(tier2$dbSNP, createSNPLink))
    return(tier2)
    
  })
  # create reactive data for table
  tier3 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res.list[grep(input$SampleID, res.list, fixed = T)]
    tier3.file <- sample.list[grep('Tier3', sample.list)]
    tier3 <- read.csv(tier3.file, head = T, as.is = T)
    # strange issue with newer VEP, adds '%3D' to syn ammino acid output - quick fix for now
    tier3$AAchange <- gsub('.*%3D', '.', tier3$AAchange
    # create a URL link to NCBI for SNPs
    tier3$dbSNP <- unlist(lapply(tier3$dbSNP, createSNPLink))
    return(tier3)
    
  })
  
  # create reactive data for MutationAssessor data if available
  MA.table <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    MA.list <- MutAssess.links[grep(input$SampleID, MutAssess.links, fixed = T)]
    MA.table <- read.table(MA.list, head = T, as.is = T)
    # clean up gene symbol (this could be moved out to an external script...)
    MA.table$GENESYM <-
      sapply(sapply(strsplit(MA.table$GENESYM, ";"), unique), paste, collapse = ";") %>% 
      gsub('^.;', '', .) %>%
      gsub(';.$', '', .)
    # ceate the URL link button to Mutation Assessor
    MA.table$URL <- createLink(MA.table$URL)
    # create a URL link to NCBI for SNPs
    MA.table$RSNO <- unlist(lapply(MA.table$RSNO, createSNPLink))
    return(MA.table)
    
  })
  
  # add a submit button to wait for user to input all desired genes
  observeEvent(
    eventExpr = input[["submit_loc"]],
    handlerExpr = {
      validate(
        need(input$GeneSymbol != '', "Please select a valid gene symbol")
      )
      
    }
  )
  
  # show genes being input int realtime
  output$GO_genes <- renderPrint({
    
    genes <- as.character(unlist(strsplit(input$GeneSymbol, ", ")))
    cat("Your selected gene(s):\n")
    print(genes)
    
  }
  )
 
  # wait for the list of genes to be submitted and then generated GO terms and table
  GO_tbl <- eventReactive(input$submit_loc, {

    validate(
      need(input$GeneSymbol != '', "Please select a valid gene symbol")
    )

    genes <- as.character(unlist(strsplit(input$GeneSymbol, ", ")))
    # search_gene <- unlist(strsplit(search_gene, split = ', '))
    GO_tbl <- getGO(organism = "Homo sapiens", genes = genes, filters = "hgnc_symbol")
    GO_tbl

  })

  # when table is generated render it for the UI
  output$GOtable = renderDataTable({

    GO_tbl()[]

  }, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 6: ', htmltools::em('A list of GO terms for selected gene(s).')
  ), plugins = 'natural', server = F,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                 buttons = list('copy', 'print', list(
                   extend = 'collection',
                   buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_GOterms_', file.time)),
                                  list(extend = 'excel', filename = paste0(input$SampleID, '_GOterms_', file.time)),
                                  list(extend = 'pdf', filename = paste0(input$SampleID, '_GOterms_', file.time))),
                   text = 'Download'
                 ))))

  # potential to implement some sorting and ordering based on 'enriched' GO terms
  # output$GOenrich = renderDataTable({
  #
  #   head(sort(table(GO_tbl$goslim_goa_description), decreasing = T), n = 10)
  #
  # })
    
  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable1 = renderDataTable({
    
    validate(
      need(try(nrow(tier0() > 0)), paste0("Warning: data missing for ", input$SampleID))
    )
    
    tier0()[, input$show_vars, drop = FALSE]
    
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
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
    
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
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
    
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
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
    
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE,
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
    
    MA.table()[, input$show_vars2, drop = FALSE]
    
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