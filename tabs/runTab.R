# UI-elements for Tools tab
tabPanel(title = "Run", icon = icon("running", lib = "font-awesome"),
         
         tagList(
           tags$head(includeCSS("www/styles.css"))
           ),
         
         sidebarLayout(
           
           fluid = FALSE,
           
           sidebarPanel(# Add image to the top of the run sidebarPanel:
             # img(src = "GlioVis_tools.jpg", class="responsive-image"),
             # br(),br(),
             
             wellPanel(
               strong("Upload Data",
                  helpModal(modal_title ="Upload Data Format",
                            link = "helpupload", 
                            help_file = includeMarkdown("tools/help/help_uploading.Rmd"))
                  ),
               
               # helpText("Please upload an Excel spreadsheet or text-based file with tab, 
               # comma or semi-colon separators. Samples must in columns and genes in rows. 
               # The first column should contain either gene symbols or gene ENSEMBL IDs:"),
               # 
               # br(),
               # 
               # img(src = "Example_input.png", class="responsive-image"),
               # 
               br(),
               
               
               fileInput(inputId = "upFile", 
                         label = "Select expression data file:",
                         accept=c("text/csv", 
                                  "text/comma-separated-values,text/plain", 
                                  ".csv", ".txt",".xlsx")
                         )
               ),
             
             wellPanel(
               radioButtons(inputId = "sep", label = "Separator",  
                            choices = c(Comma = ",", Semicolon = ";", Tab="\t"), 
                            selected = ",", inline = TRUE)
             ),
             
             
             wellPanel(
               radioButtons(inputId = "quote", label = "Quote", 
                            choices = c(None = "", "Double Quote" = '"', "Single Quote" = "'"), 
                            selected = '"', inline = TRUE)
             ),
             
             wellPanel(
             radioButtons(inputId = "tumour_intrinsic", 
                          label = strong("Tumour Intrinsic genes",
                                         helpModal(modal_title ="Tumour Intrinsic Genes",
                                                   link = "helptumourintrinsic", 
                                                   help_file = includeMarkdown("tools/help/help_tumour_intrinsic.Rmd")),
                          " :"),
                          choices = c("Yes" = "Yes", 
                                      "No" = "No"),
                          inline = T)
             ),
             br(),br(),
             
             # input.tabTools == 'DeconvoluteME'  & output.finishedUploading
             conditionalPanel(
               condition = "output.finishedUploading",
               actionButton(inputId = "goDec", 
                            label = "RUN DECONVOLUTION", 
                            class= "btn-success"),
               br()
               )
           
             ),
           
           mainPanel(
             
             # tabsetPanel(
               tabsetPanel(id = "tabTools",
                           tabPanel(title = "Scores", id = "deconvScores",
                                    busy(),
                                    DT::dataTableOutput(outputId = "deconvScore")
                           ),
                           tabPanel(title = "Barchart", id = "deconvBarPlot",
                                    busy(),
                                    plotOutput(outputId = "deconvBoxPlot", height = "100%")
                           )
                           # ,tabPanel(title = "Heatmap", id = "deconvHeatmap",
                           #          busy(),
                           #          plotOutput(outputId = "deconvHeatmap", height = 1000)
                           # )
               )
           )
         )
)

