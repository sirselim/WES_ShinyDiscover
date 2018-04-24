# 
createLink <- function(val) {
  sprintf('<a href="%s" target="_blank" class="btn btn-primary">Link to Variant</a>',val)
}

# shiny server
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

  # observeEvent(
  #   eventExpr = input[["submit_loc2"]],
  #   handlerExpr = {
  #     validate(
  #       need(input$GeneSymbol != '', "Please select a valid gene symbol")
  #     )
  #     
  #   }
  # )
  
  # show genes being input int realtime
  # output$hgnc_gene <- renderPrint({
  #   
  #   hgncgenes <- as.character(unlist(strsplit(input$hgncSymbol, ", ")))
  #   cat("Your selected gene:\n")
  #   print(hgncgenes)
  #   
  # }
  # )
  
  # # wait for the list of genes to be submitted and then generated GO terms and table
  # BMsearch <- eventReactive(input$submit_loc2, {
  # 
  #   validate(
  #     need(input$hgncSymbol != '', "Please select a valid gene symbol")
  #   )
  # 
  #   hgncgene <- as.character(unlist(strsplit(input$hgncSymbol, ", ")))
  #   gene.search <- getBM(attributes = c("hgnc_symbol","entrezgene", "chromosome_name", "start_position", "end_position"), 
  #                        filters = c("hgnc_symbol"), values = hgncgene, mart = ensembl54)
  #   gene.search$chromosome_name <- paste0('chr', gene.search$chromosome_name)
  #   gene.search <- gene.search[grep('chr[0-9]', gene.search$chromosome_name),]
  #   
  # })
  
  # # show genes being input int realtime
  # output$BMgene <- renderDataTable({
  #   
  #   # cat("BioMart annotation (hg19/GRCh37):\n")
  #   BMsearch()[]
  #   
  # }, rownames= FALSE, selection = list(target = 'cell', mode = "single"),
  # caption = htmltools::tags$caption(
  #   style = 'caption-side: bottom; text-align: center;',
  #   'Table 7: ', htmltools::em('Gene annotation retrieved from BioMart (hg19/GRCh37).')
  # ), options = list(dom = 't'))
  # 
  # # allow user to select gene to plot from table
  # output$SelectedGene <- renderPrint(as.character(input$BMgene_cell_clicked)[3])
  
  # #
  # SelectedGene <- reactive({
  #   
  #   validate(
  #     need(input$BMgene_cell_clicked != '', "Please select a valid gene symbol from the BioMart table.")
  #   )
  #   
  #   SelectedGene <- parse(text=as.character(input$BMgene_cell_clicked)[[3]])
  #   # SelectedGene <- as.list(SelectedGene)
  #   return(SelectedGene)
  # })
  
  # #
  # BamFile <- eventReactive(input$submit_loc2, {
  #   
  #   validate(
  #     need(input$hgncSymbol != '', "Please select a valid gene symbol")
  #   )
  #   
  #   # bam file to search
  #   bam.file <- bam.list[grep(input$SampleID, bam.list, fixed = T)]
  #   
  # })
  # 
  # # show bam file being input in realtime
  # output$BamFile <- renderPrint({
  #   
  #   cat("Bam file in use (NOTE: for testing purposes):\n")
  #   BamFile()[]
  #   
  # }
  # )
  
  # # create annotation plot
  # output$VizPlot <- renderPlot({
  #   
  #   # validate(
  #   #   need(input$BMgene_cell_clicked != '', "Please select a gene symbol from the above table")
  #   # )
  #   # library('Gviz')
  #   # gene.search <- BMsearch()[]
  #   # gene.search <- as.character(input$BMgene_cell_clicked)[3]
  #   gene.out <- SelectedGene()[]
  #   gene.search <- getBM(attributes = c("hgnc_symbol","entrezgene", "chromosome_name", "start_position", "end_position"), 
  #                        filters = c("hgnc_symbol"), values = gene.out, mart = ensembl54)
  #   gene.search$chromosome_name <- paste0('chr', gene.search$chromosome_name)
  #   gene.search <- gene.search[grep('chr[0-9]', gene.search$chromosome_name),]
  #   
  #   # # bam file to search
  #   bam.file <- BamFile()[]
  #   # bam.file <- bam.list[grep(input$SampleID, bam.list, fixed = T)]
  #   # asign bam file and prepare coverage and alignment tracks
  #   alTrack <- Gviz::AlignmentsTrack(bam.file, isPaired=F) #Read bam file
  #   # create gtrack
  #   gtrack <- Gviz::GenomeAxisTrack()
  #   # create dtrack
  #   dtrack <- Gviz::DataTrack(range=bam.file, genome="hg19", name="Coverage", chromosome=gene.search$chromosome_name[[1]],
  #                       type = "histogram", col.histogram= "#377EB8", fill="#377EB8") # need to check this if want multiple genes
  #   # create ideogram track
  #   itrack <- Gviz::IdeogramTrack(genome="hg19", chromosome=gene.search$chromosome_name[[1]]) #requires internet connection
  #   # create transcript track
  #   grtrack <- Gviz::GeneRegionTrack(TxDb.Hsapiens.UCSC.hg19.knownGene, genome = "hg19", chromosome=gene.search$chromosome_name[[1]], 
  #                              name="TxDb.Hsapiens.UCSC.hg19") # need to check this if want multiple genes
  #   # get transcript info for selected gene
  #   # gene <- symbolToGene(gene.search$hgnc_symbol[[1]]) # need to check this if want multiple genes
  #   # transcript.out <- geneToTranscript(gene)
  #   # tran.start <- transcript.out@ranges@start[1]
  #   # tran.end <- data.frame(transcript.out@ranges[length(transcript.out)])[[2]]
  #   ##
  #   # gene <- paste0('^', gene.search$hgnc_symbol[[1]], '$')
  #   # tran.start <- min(ucsc.genes[grep(gene, ucsc.genes$V4),]$V2)
  #   # tran.end <- max(ucsc.genes[grep(gene, ucsc.genes$V4),]$V3)
  #   ##
  #   tran.start <- gene.search$start_position[[1]]
  #   tran.end <- gene.search$end_position[[1]]
  #   # create plot
  #   Gviz::plotTracks(list(itrack, gtrack, grtrack, alTrack), from = tran.start, to = tran.end)
  #   
  # }, res = 150, height = 650)
  
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