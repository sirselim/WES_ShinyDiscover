## shiny server
shinyServer(function(input, output, session) {
  
  # create sampleID
  output$currentSample <- renderText({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    currentSample <- as.character(input$SampleID)
    as.character(currentSample)
    
  })
  
  # reactive file timestamp
  observeEvent(input$SampleID, {
    file.time <<- format(Sys.time(), "%a_%b_%d_%Y")
  })

  ### reactive file monitoring
  ##
  # reactive monitoring of results files
  has.new.files <- function() {
    unique(list.files(HOMEDIR, recursive = T, pattern = '.csv', full.names = T))
  }
  get.files <- function() {
    list.files(HOMEDIR, recursive = T, pattern = '.csv', full.names = T)
  }
  # store as a reactive instead of output
  res_files <- reactivePoll(30000, session, checkFunc = has.new.files, valueFunc = get.files)

  ##
  # reactive monitoring of mutationassessor files
  new.mut.files <- function() {
    unique(list.files(HOMEDIR, recursive = T, pattern = '_MutationAssessor_links_', full.names = T))
  }
  get.mut.files <- function() {
    list.files(HOMEDIR, recursive = T, pattern = '_MutationAssessor_links_', full.names = T)
  }
  # store as a reactive instead of output
  mut_files <- reactivePoll(30000, session, checkFunc = new.mut.files, valueFunc = get.mut.files)

  ## set up for download button
  # reactive monitoring of final report files
  new.report.files <- function() {
    unique(list.files(HOMEDIR, recursive = T, pattern = '_report.docx', full.names = T))
  }
  get.report.files <- function() {
    list.files(HOMEDIR, recursive = T, pattern = '_report.docx', full.names = T)
  }
  # store as a reactive instead of output
  report_files <- reactivePoll(30000, session, checkFunc = new.report.files, valueFunc = get.report.files)

  ## set up for download button
  # reactive monitoring of log files
  new.log.files <- function() {
    unique(list.files(HOMEDIR, recursive = T, pattern = '.log', full.names = T))
  }
  get.log.files <- function() {
    list.files(HOMEDIR, recursive = T, pattern = '.log', full.names = T)
  }
  # store as a reactive instead of output
  log_files <- reactivePoll(30000, session, checkFunc = new.log.files, valueFunc = get.log.files)

  ## set up for download button
  # reactive monitoring of all files in compressed format (tar.gz)
  new.zipped.files <- function() {
    unique(list.files(HOMEDIR, recursive = T, pattern = '.tar.gz', full.names = T))
  }
  get.zipped.files <- function() {
    list.files(HOMEDIR, recursive = T, pattern = '.tar.gz', full.names = T)
  }
  # store as a reactive instead of output
  zipped_files <- reactivePoll(30000, session, checkFunc = new.zipped.files, valueFunc = get.zipped.files)
  ###
  
  # create reactive data for table
  tier0 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res_files()[grep(input$SampleID, res_files(), fixed = T)]
    tier0.file <- sample.list[grep('Tier0', sample.list)]
    tier0 <- read.csv(tier0.file, head = T, as.is = T)
    # strange issue with newer VEP, adds '%3D' to syn ammino acid output - quick fix for now
    tier0$AAchange <- gsub('.*%3D', '.', tier0$AAchange)
    # create a URL link to NCBI for SNPs
    tier0$dbSNP <- unlist(lapply(tier0$dbSNP, createSNPLink))
    # create a URL button link to GnomAD
    tier0$GnomAD <- createGnomADLink(tier0)
    # create a URL button link to GnomAD
    # tier0$ClinGen <- unlist(lapply(tier0$gene, createHUGOLink))
    return(tier0)

  })
  # create reactive data for table
  tier1 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res_files()[grep(input$SampleID, res_files(), fixed = T)]
    tier1.file <- sample.list[grep('Tier1', sample.list)]
    tier1 <- read.csv(tier1.file, head = T, as.is = T)
    # strange issue with newer VEP, adds '%3D' to syn ammino acid output - quick fix for now
    tier1$AAchange <- gsub('.*%3D', '.', tier1$AAchange)
    # create a URL link to NCBI for SNPs
    tier1$dbSNP <- unlist(lapply(tier1$dbSNP, createSNPLink))
    # create a URL button link to GnomAD
    tier1$GnomAD <- createGnomADLink(tier1)
    # create a URL button link to GnomAD
    # tier1$ClinGen <- unlist(lapply(tier1$gene, createHUGOLink))
    return(tier1)
    
  })
  # create reactive data for table
  tier2 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res_files()[grep(input$SampleID, res_files(), fixed = T)]
    tier2.file <- sample.list[grep('Tier2', sample.list)]
    tier2 <- read.csv(tier2.file, head = T, as.is = T)
    # strange issue with newer VEP, adds '%3D' to syn ammino acid output - quick fix for now
    tier2$AAchange <- gsub('.*%3D', '.', tier2$AAchange)
    # create a URL link to NCBI for SNPs
    tier2$dbSNP <- unlist(lapply(tier2$dbSNP, createSNPLink))
    # create a URL button link to GnomAD
    tier2$GnomAD <- createGnomADLink(tier2)
    # create a URL button link to GnomAD
    # tier2$ClinGen <- unlist(lapply(tier2$gene, createHUGOLink))
    return(tier2)
    
  })
  # create reactive data for table
  tier3 <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    sample.list <- res_files()[grep(input$SampleID, res_files(), fixed = T)]
    tier3.file <- sample.list[grep('Tier3', sample.list)]
    tier3 <- read.csv(tier3.file, head = T, as.is = T)
    # strange issue with newer VEP, adds '%3D' to syn ammino acid output - quick fix for now
    tier3$AAchange <- gsub('.*%3D', '.', tier3$AAchange)
    # create a URL link to NCBI for SNPs
    tier3$dbSNP <- unlist(lapply(tier3$dbSNP, createSNPLink))
    # create a URL button link to GnomAD
    tier3$GnomAD <- createGnomADLink(tier3)
    # create a URL button link to GnomAD
    # tier3$ClinGen <- unlist(lapply(tier3$gene, createHUGOLink))
    return(tier3)
    
  })
  
  # create reactive data for MutationAssessor data if available
  MA.table <- reactive({
    
    validate(
      need(input$SampleID != '', "Please select a valid SampleID")
    )
    
    MA.list <- mut_files()[grep(input$SampleID, mut_files(), fixed = T)]
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
 
  # wait for the list of genes to be submitted and then generate GO terms and table
  GO_tbl <- eventReactive(input$submit_loc, {

    validate(
      need(input$GeneSymbol != '', "Please select a valid gene symbol")
    )

    # grab gene(s)
    genes <- as.character(unlist(strsplit(input$GeneSymbol, ", ")))
    # create GO table to render
    GO_tbl <- go.data[grep(paste0(paste(paste0('^', genes), collapse = '$|'), '$'), go.data$gene),]
    GO_tbl <- GO_tbl[!duplicated(GO_tbl$goterm),]
    GO_tbl$ontology <- goterms[grep(paste(GO_tbl$goterm, collapse = '|'), names(goterms))]
    # generate links
    GO_tbl$goterm <- createGOLink(GO_tbl$goterm)
    GO_tbl$uniprot <- createUniProtLink(GO_tbl$uniprot)
    GO_tbl$pubmed <- createPMIDLink(GO_tbl$pubmed)
    return(GO_tbl)

  })

  # when table is generated render it for the UI
  output$GOtable = renderDataTable({

    GO_tbl()[]

  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE, selection = 'single',
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 6: ', htmltools::em('A list of GO terms for selected gene(s).')
  ), plugins = 'natural', server = T,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                 buttons = list('copy', 'print', list(
                   extend = 'collection',
                   buttons = list(list(extend = 'csv', filename = paste0(input$SampleID, '_GOterms_', file.time)),
                                  list(extend = 'excel', filename = paste0(input$SampleID, '_GOterms_', file.time)),
                                  list(extend = 'pdf', filename = paste0(input$SampleID, '_GOterms_', file.time))),
                   text = 'Download'
                 ))))

  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable1 = renderDataTable({
    
    validate(
      need(try(nrow(tier0() > 0)), paste0("WARNING: sample not found (", input$SampleID, ')'))
    )
    
    tier0()[, input$show_vars, drop = FALSE]
    
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE, selection = 'single',
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 1: ', htmltools::em('A list of variants passing the filter criteria for Tier0 (gene panel variants).')
  ), plugins = 'natural', server = T,
      options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                     "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                     buttons = list('copy', 'print', list(
                       extend = 'collection',
                       buttons = list(list(extend = 'csv', filename = paste0('VCF-DART_tier0_filtered_', file.time)), 
                                      list(extend = 'excel', filename = paste0('VCF-DART_tier0_filtered_', file.time)),
                                      list(extend = 'pdf', filename = paste0('VCF-DART_tier0_filtered_', file.time))),
                       text = 'Download'
                     ))))

  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable2 = renderDataTable({
    
    validate(
      need(try(nrow(tier1() > 0)), paste0("WARNING: sample not found (", input$SampleID, ')'))
    )
    
    tier1()[, input$show_vars, drop = FALSE]
    
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE, selection = 'single',
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 2: ', htmltools::em('A list of variants passing the filter criteria for Tier1.')
  ), plugins = 'natural', server = T,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                    buttons = list('copy', 'print', list(
                      extend = 'collection',
                      buttons = list(list(extend = 'csv', filename = paste0('VCF-DART_tier1_filtered_', file.time)), 
                                     list(extend = 'excel', filename = paste0('VCF-DART_tier1_filtered_', file.time)),
                                     list(extend = 'pdf', filename = paste0('VCF-DART_tier1_filtered_', file.time))),
                      text = 'Download'
                    ))))

  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable3 = renderDataTable({
    
    validate(
      need(try(nrow(tier2() > 0)), paste0("WARNING: sample not found (", input$SampleID, ')'))
    )
    
    tier2()[, input$show_vars, drop = FALSE]
    
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE, selection = 'single',
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 3: ', htmltools::em('A list of variants passing the filter criteria for Tier2.')
  ), plugins = 'natural', server = T,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                    buttons = list('copy', 'print', list(
                      extend = 'collection',
                      buttons = list(list(extend = 'csv', filename = paste0('VCF-DART_tier2_filtered_', file.time)), 
                                     list(extend = 'excel', filename = paste0('VCF-DART_tier2_filtered_', file.time)),
                                     list(extend = 'pdf', filename = paste0('VCF-DART_tier2_filtered_', file.time))),
                      text = 'Download'
                    ))))
  
  # customize the length drop-down menu; display 10 rows per page by default
  output$mytable4 = renderDataTable({
    
    validate(
      need(try(nrow(tier3() > 0)), paste0("WARNING: sample not found (", input$SampleID, ')'))
    )
    
    tier3()[, input$show_vars, drop = FALSE]
    
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE, selection = 'single',
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 4: ', htmltools::em('A list of variants passing the filter criteria for Tier3.')
  ), plugins = 'natural', server = T,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                    buttons = list('copy', 'print', list(
                      extend = 'collection',
                      buttons = list(list(extend = 'csv', filename = paste0('VCF-DART_tier3_filtered_', file.time)), 
                                     list(extend = 'excel', filename = paste0('VCF-DART_tier3_filtered_', file.time)),
                                     list(extend = 'pdf', filename = paste0('VCF-DART_tier3_filtered_', file.time))),
                      text = 'Download'
                    ))))

  output$mytable5 = renderDataTable({
    
    validate(
      need(try(nrow(MA.table() > 0)), paste0("WARNING: sample not found (", input$SampleID, ')'))
    )
    
    MA.table()[, input$show_vars2, drop = FALSE]
    
  }, escape = FALSE, extensions = 'Buttons', filter = "bottom", rownames= FALSE, selection = 'single',
  caption = htmltools::tags$caption(
    style = 'caption-side: bottom; text-align: center;',
    'Table 5: ', htmltools::em('A list of variants predicted as being potentially most damaging (Mutation Assessor High risk), including URL to variant information.')
  ), plugins = 'natural', server = T,
  options = list(orderClasses = TRUE, lengthMenu = c(10, 25, 50, 100, 200), pageLength = 10,
                 "dom" = 'T<"clear">lBfrtip', columnDefs = list(list(type = "natural", targets = "_all")),
                 buttons = list('copy', 'print', list(
                   extend = 'collection',
                   buttons = list(list(extend = 'csv', filename = paste0('VCF-DART_MutationAssessor_filtered_', file.time)), 
                                  list(extend = 'excel', filename = paste0('VCF-DART_MutationAssessor_filtered_', file.time)),
                                  list(extend = 'pdf', filename = paste0('VCF-DART_MutationAssessor_filtered_', file.time))),
                   text = 'Download'
                 ))))

  ## report download
      output$downloadData <- downloadHandler(
        filename <- function() {
          paste0(input$SampleID, "_clinical_report", ".docx")
        },

        content <- function(file) {
          file.copy(paste0(report_files()[grep(input$SampleID, report_files(), fixed = T)]), file)
        },
        contentType = "text/docx"
      )
  
  ## log file download
      output$downloadData_log <- downloadHandler(
        filename <- function() {
          paste0(input$SampleID, "_annotation_logfile", ".log")
        },

        content <- function(file) {
          file.copy(paste0(log_files()[grep(input$SampleID, log_files(), fixed = T)]), file)
        },
        contentType = "text/log"
      )

  ## compressed data file download
      output$downloadData_all <- downloadHandler(
        filename <- function() {
          paste0(input$SampleID, "_vcfdart_output", ".tar.gz")
        },

        content <- function(file) {
          file.copy(paste0(zipped_files()[grep(input$SampleID, zipped_files(), fixed = T)]), file)
        }
      )

})
