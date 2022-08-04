# UI-elements for the Run page
# this page consists of a tab panel where the options are set on a sidebar panel
# which will be on the left side of the page and then the results will be displayed
# on a main tabbed panel on the right hand side of the page.

tabPanel(
  
  title = "Run", icon = icon("running", lib = "font-awesome"),
  
  tagList(tags$head(includeCSS("www/styles.css"))),
  
  div(id = "run",
      
      sidebarLayout(
        
        fluid = FALSE,
        
        # SIDEBAR PANEL START ----
        
        sidebarPanel = sidebarPanel(
          
          # br(), 
          
          # UPLOAD DATA WELL PANEL 
          
          tags$h4("Upload Data"),
          
          shiny::actionLink(inputId = "upload_help",
                            label = img(src="Icons/help.svg", 
                                        class = "help_icon")),
          
          
          fileInput(inputId = "upload_file", 
                    multiple = FALSE,
                    label = "",
                    buttonLabel = "Browse...",
                    accept=c(".csv", ".tsv", ".xlsx")),
          
          
          hr(class = "hr_runpanel"),
          
          br(), 
          
          # RUN DECONVOLUTION WELL PANEL
          
          tags$h4("Deconvolution"),
          
          br(), br(),
          
          radioButtons(inputId = "tumour_intrinsic",
                       label = tags$div(class = "deconv_option_header",
                                        "Tumour Intrinsic Genes",
                                        shiny::actionLink("TI_genes_help", 
                                                          label = img(src="Icons/help.svg", 
                                                                      class = "help_icon"))
                       ),
                       
                       choices = c("Yes" = TRUE,
                                   "No" = FALSE),
                       
                       inline = TRUE),
          
          # RUN DECONVOLUTION BUTTON
          conditionalPanel(
            
            condition = "output.finishedUploading",
            
            hr(class = "hr_runpanel"),
            
            actionButton(inputId = "deconvolute_button",
                         icon = icon("brain",class = "icon"),
                         label = "Deconvolute",
                         class= "btn-success")
          )
        ),
        
        # SIDEBAR PANEL END ----
        
        # MAIN PANEL UI START ----
        
        mainPanel(
          
          tabsetPanel(
            id = "main_runpage_panel",
            # File upload
            tabPanel(title = "1. Uploaded Data",
                     id = "uploaded_tab",
                     DT::dataTableOutput(outputId = "uploaded_data") %>% 
                       
                       withSpinner(image = "gifs/Busy_running.gif",
                                   image.width = "50%")
            ),
            
            # Markers
            tabPanel(title = "2. Markers", 
                     id = "marker_tab",
                     DT::dataTableOutput(outputId = "deconv_markers") %>% 
                       
                       withSpinner(image = "gifs/Busy_running.gif",
                                   image.width = "50%")
            ),
            
            # Scores 
            tabPanel(title = "3. Scores", 
                     id = "scores_tab",
                     DT::dataTableOutput(outputId = "deconv_scores") %>% 
                       
                       withSpinner(image = "gifs/Busy_running.gif",
                                   image.width = "50%")
            ),
            
            # Bar plot
            tabPanel(title = "4. Bar Plot", 
                     id = "barplot_tab",
                     
                     style = c("height:575px;overflow-y: scroll;"),
                     
                     uiOutput("filetype_select", 
                              style = "display: inline-block; 
                                   border-color: #b0aece;
                                   width: 100px; 
                                   margin-top: 15px;" ),
                     
                     uiOutput("download_button",
                              class = "btn-download",
                              style = "display: inline-block;"),
                     
                     # busy(),
                     
                     plotOutput(outputId = "scores_plot") %>% 
                       
                       withSpinner(image = "gifs/Busy_running.gif",
                                   image.width = "50%")
                     
            )
          )
        )
        
        # MAIN PANEL UI END ----
        
      )
      
  )
)

