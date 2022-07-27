# UI-elements for the Run page
# this page consists of a tab panel where the options are set on a sidebar panel
# which will be on the left side of the page and then the results will be displayed
# on a main tabbed panel on the right hand side of the page.

tabPanel(
  
  title = "Run", icon = icon("running", lib = "font-awesome"),
  
  tagList(tags$head(includeCSS("www/styles.css"))),
  
  
  sidebarLayout(
    
    fluid = FALSE,
    
    # SIDEBAR PANEL START ----
    
    sidebarPanel = sidebarPanel(
      
      # br(), 
     
      # UPLOAD DATA WELL PANEL 
      # wellPanel(
        
        tags$h4("Upload Data"),
        
        helpModal(modal_title ="Uploading Data",
                  link = "helpupload", 
                  help_file = includeMarkdown("tools/help/help_uploading.Rmd")
                  ),
        # br(),
        
        fileInput(inputId = "upload_file", 
                  multiple = FALSE,
                  label = "",
                  buttonLabel = "Browse...",
                  accept=c(".csv", ".tsv", ".xlsx")),
        
      # ),
      hr(class = "hr_runpanel"),
      
      br(), 
      
      # RUN DECONVOLUTION WELL PANEL
      # wellPanel(
        
        tags$h4("Deconvolution"),
        
        helpModal(modal_title ="Deconvolution Options",
                  link = "helptumourintrinsic",
                  help_file = includeMarkdown("tools/help/help_tumour_intrinsic.Rmd")),
        
        br(), br(),
        
        radioButtons(inputId = "tumour_intrinsic",
                     label = tags$div(class = "deconv_option_header",
                                      "Tumour Intrinsic Genes"
                                      ),
                     # ("Tumour Intrinsic Genes Only:"),
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
                 DT::dataTableOutput(outputId = "uploaded_data")
        ),
        
        # Markers
        tabPanel(title = "2. Markers", 
                 id = "marker_tab",
                 busy(),
                 DT::dataTableOutput(outputId = "deconv_markers")
        ),
        
        # Scores 
        tabPanel(title = "3. Scores", 
                 id = "scores_tab",
                 busy(),
                 DT::dataTableOutput(outputId = "deconv_scores")
        ),
        
        # Barplot
        tabPanel(title = "4. Bar Plot", 
                 id = "barplot_tab",
                 busy(),
                 uiOutput("download_button"),
                 
                 # downloadButton(outputId = "downloadData"),
                 
                 plotOutput(outputId = "scores_plot", 
                            height = "100%",
                            width = "100%")
                 
        )
      )
    )
    
    # MAIN PANEL UI END ----
  
  )
)

