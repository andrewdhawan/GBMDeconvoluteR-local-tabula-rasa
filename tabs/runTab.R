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
      
      br(), 
     
      # UPLOAD DATA WELL PANEL 
      wellPanel(
        
        tags$h4("Upload Data"),
        
        helpModal(modal_title ="Uploading Data",
                  link = "helpupload", 
                  help_file = includeMarkdown("tools/help/help_uploading.Rmd")
                  ),
        br(),
        
        fileInput(inputId = "upload_file", 
                  multiple = FALSE,
                  label = "",
                  buttonLabel = "Select File...",
                  accept=c(".csv", ".tsv", ".xlsx")
        )
        
        # conditionalPanel(
        #   condition = "output.finishedUploading",
        #   actionButton(inputId = "view_data", 
        #                label = "View", 
        #                class= "btn-success")
        #   )
        
      ),
      
      br(), 
      
      # RUN DECONVOLUTION WELL PANEL
      wellPanel(
        
        tags$h4("Deconvolute"),
        
        helpModal(modal_title ="Deconvoluting Expression Profiles",
                  link = "helptumourintrinsic",
                  help_file = includeMarkdown("tools/help/help_tumour_intrinsic.Rmd")),
        
        br(), br(),
        
        radioButtons(inputId = "tumour_intrinsic",
                     label = strong("Tumour Intrinsic Genes Only"),
                     choices = c("Yes" = "Yes",
                                 "No" = "No"),
                     inline = TRUE),
        
        br(),
        
        # RUN DECONVOLUTION BUTTON
        conditionalPanel(
          
          condition = "output.finishedUploading",
          
          actionButton(inputId = "deconvolute_button",
                       label = "Run",
                       class= "btn-success")
          )
        ),
    ),
    
    # SIDEBAR PANEL END ----

    # MAIN PANEL UI START ----
    
    mainPanel(
      
      tabsetPanel(
        id = "main_runpage_panel",
        
        # File upload
        tabPanel(title = "Uploaded",
                 id = "uploaded_data",
                 busy(),
                 DT::dataTableOutput(outputId = "uploaded_data")
        ),
        
        # Scores 
        tabPanel(title = "Scores", 
                 id = "deconvScores",
                 busy(),
                 DT::dataTableOutput(outputId = "deconv_scores")
        ),
        
        # Markers
        tabPanel(title = "Markers", 
                 id = "deconvScores",
                 busy(),
                 DT::dataTableOutput(outputId = "deconv_markers")
        ),
        
        # Barplot
        tabPanel(title = "Barchart", 
                 id = "deconvBarPlot",
                 busy(),
                 plotOutput(outputId = "deconvBoxPlot", 
                            height = "100%")
        )
      )
    )
    
    # MAIN PANEL UI END ----
  
  )
)

