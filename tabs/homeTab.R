# UI-elements for Home tab
tabPanel(title = "Home", icon = icon("home", lib = "font-awesome"),
         tagList(
           tags$head(
             includeCSS("www/styles.css"),
             tags$script(type="text/javascript",
                         src="https://platform-api.sharethis.com/js/sharethis.js#property=62a6096405284b00197c54c9&product=inline-follow-buttons",
                         async="async"),
             includeScript("tools/google-analytics.js"),
             tags$script(type="text/javascript", src = "busy.js"),
             tags$link(rel="shortcut icon", href="./logo_bar.bmp"),
             tags$script(type="text/javascript", "var switchTo5x=true"),
             tags$script(type="text/javascript", src="http://w.sharethis.com/button/buttons.js"),
             tags$script(type="text/javascript",'stLight.options({publisher: "675b3562-a081-470a-9fc4-3dd6a712209d", doNotHash: true, doNotCopy: true, hashAddressBar: false})')
           )
         ),
         
         div(id = "home",
             br(),
             # This line below is for the sliding title 
             # a(href ="https://www.cnio.es/eventos/index.asp?ev=1&cev=136",div(class="simple-ss",id="simple-ss")),
             img(src = "Gliodeconv_logo2.png", width = 900),
             div(class="intro-divider"),
             
             p(class = "lead", "Welcome to", 
               strong("GBMDeconvoluteR!"), "-  a shiny based web application for estimating the population 
               abundance of tissue-infiltrating immune and stromal cell populations within high grade, 
               brain tumour expression profiles."),
             
             h3(class = "outer", "How does it work?"),
             p(class = "outer"," This web-app is very easy to use:"),
             tags$ol(
               tags$li('Click the "Run" tab at the top of the page'),
               tags$li("Upload your gene expression data (in the correct format)"),
               tags$li('Click "RUN DECONVOLUTION" button to obtain scores'),
               tags$li("Once completed, download or mannully browse the estimated cell-population abundances.")
             ),
             
             h3(class = "outer", "Which gene ID can I use?"),
             p(class = "outer",'Currently only', 
               a("HGNC-approved", href="http://www.genenames.org"), 
               "Gene Symbols and",  
               a("ENSEMBL IDs", href="https://www.ensembl.org/info/genome/stable_ids/index.html"), "are supported."),
             
             h3(class = "outer", "Can I download my results data?"),
             p(class = "outer",'Yes, this is', strong("strongly recommended"), 'for reproducibility
             and further downstream analysis. Once the run has completed, all abundance esitmates can be downloded
             as a .csv format.'),
             
             h3(class = "outer", "Can I download the plots?"),
             p(class = "outer",'Yes, all the plots can be downloaded in various formats: 
               .pdf, .bmp, .jpeg, .tiff or .jpg.'),
             
             
             h3(class = "outer", "Can I use the results for my publication?"),
             p(class = "outer", strong("Of course!"), 'If you do so, please include references for the dataset(s) you used and cite: 
               "[placeholder for paper ref]"', 
               a("(placeholder paper ref link).", 
               href="", target="_blank")),
             
             # p(class = "outer","Please adhere to the",  a("TCGA publication guidelines", href="http://cancergenome.nih.gov/publications/publicationguidelines"),
             #   "when using TCGA data in your publications."),
             
             h3(class = "outer", "I have more questions, how can I reach you?"),
             p(class = "outer",'You can contact us by ', 
               a("email", href="mailto:gliovis.app@gmail.com"),
               'or through social media (for more details see the about section)', 
               ),
             br(), hr()
             # tags$blockquote(class="pull-right",
             #                 tags$p(style = 'font-style:italic;',"No great discovery was ever made without a bold guess."),
             #                 tags$small("Isaac Newton")),
             
         )
         
)
