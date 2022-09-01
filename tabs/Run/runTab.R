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
          
          selectInput(inputId = "markergenelist",
                      label = tags$div(class = "deconv_option_header",
                                       "Marker Gene List",
                                       shiny::actionLink("marker_genelist_help", 
                                                         label = img(src="Icons/help.svg", 
                                                                     class = "help_icon"))
                      ),
                      
                      choices = c("Ajaib et.al (2022)","Ruiz-Moreno et.al (2022)"),
                      selected = c("Ajaib et.al (2022)"),
                      multiple = FALSE,
                      width = '200px',
                      ),
          br(),
          
          radioButtons(inputId = "tumour_intrinsic",
                       label = tags$div(class = "deconv_option_header",
                                        "Tumour Intrinsic Genes",
                                        shiny::actionLink("TI_genes_help", 
                                                          label = img(src="Icons/help.svg", 
                                                                      class = "help_icon"))
                                        ),
                       
                       choices = c("Yes" = TRUE,
                                   "No" = FALSE),
                       
                       inline = TRUE)

        ),
        
        # SIDEBAR PANEL END ----
        
        # MAIN PANEL UI START ----
        
        mainPanel(
          
          tabsetPanel(id = "main_runpage_panel",
                      type = "tabs",
                      
            # File upload
            tabPanel(
              title = "Data",
              id = "uploaded_tab",
              value = "data_selected",
              DT::dataTableOutput(outputId = "uploaded_data") %>% 
                shinycssloaders::withSpinner(image = "gifs/Busy_running.gif",
                                             image.width = "50%")
              ),
            
            # Markers
            tabPanel(
              title = "Markers", 
              id = "marker_tab",
              value = "markers_selected",
              
              DT::dataTableOutput(outputId = "deconv_markers") %>% 
                shinycssloaders::withSpinner(image = "gifs/Busy_running.gif",
                                             image.width = "50%")
                     ),
            
            # Scores 
            tabPanel(
              title = "Scores",
              id = "scores_tab",
              value = "scores_selected",
              
              DT::dataTableOutput(outputId = "deconv_scores") %>% 
                shinycssloaders::withSpinner(image = "gifs/Busy_running.gif",
                                             image.width = "50%")
              ),
            
            # Bar plot
            tabPanel(
              title = "Bar Plot",
              id = "barplot_tab",
              value = "barplot_selected", 
              
              style = c("height:575px;overflow-y: scroll;"),
              
              div(id="plot_download_options",
              style ="display: flex;justify-content: center; align-items: flex-start;",
                  
                  uiOutput("filetype_select",
                           style="display: inline-block;vertical-align:top;width:50px;"),

                  uiOutput("download_button", class = "btn-download",
                           style="display: inline-block;vertical-align:top;width:100px;")
                  ),
              
        
              plotOutput(outputId = "scores_plot") %>%
                shinycssloaders::withSpinner(image = "gifs/Busy_running.gif",
                                             image.width = "50%")
              
                     ),
            
            ), # END TABSETPANEL
          
        # MAIN PANEL UI END ----
        
        ) # END MAINPANEL
    
      ) # END SIDEBARLAYOUT
  
  ) # END RUN DIV

) # END TABPANEL

