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
               strong("GBMDeconvoluteR!"), "-  a Shiny-based web application for estimating the population 
               abundance of tissue-infiltrating immune and stromal cell populations within grade IV glioblastoma (GBM), 
               brain tumour expression profiles."),
             
             h3(class = "outer", "How does it work?"),
             p(class = "outer"," This web-app is very easy to use:"),
             tags$ol(
               tags$li('Select the', tags$b(tags$em('Run')), "tab"),
               tags$li("Upload your gene expression data"),
               tags$li('Click', tags$b(tags$em('Deconvolute')), 'to obtain your cell-type abundances'),
               tags$li("View your estimated cell-population abundances, markers and available plots")
             ),
             
             h3(class = "outer", "Which gene ID can I use?"),
             p(class = "outer",'Currently only', 
               a("HGNC-approved", href="http://www.genenames.org"), 
               "Gene Symbols are supported."
               ),
               # a("ENSEMBL IDs", href="https://www.ensembl.org/info/genome/stable_ids/index.html"), 
               # "are supported."),
             
             h3(class = "outer", "Can I download my scores for further analysis?"),
             p(class = "outer", tags$b('Yes!'), 'this is strongly recommended for reproducibility.'),
             p(class = "outer", 'Once your run has completed, any abundance estimates and markers can be downloded (in various formats) from thier respective tabs.'),
             
             h3(class = "outer", "Can I download the plots?"),
             p(class = "outer", tags$b('Yes!'),'all plots can be downloaded from thier respective tabs.'),
             
             
             h3(class = "outer", "Can I use the results for my publication?"),
             p(class = "outer", tags$b("Of course!"), 'If you do so, please include references for the dataset(s) you used and cite:'), 
             p(class = "outer", '"[placeholder for paper ref]"', 
                a("(placeholder paper ref link).", href="", target="_blank")
                ),
             
             h3(class = "outer", "I have more questions, how can I reach you?"),
             p(class = "outer",'More details can be found in the', 
               tags$b(tags$em('About')), 'tab.'),
             p(class = "outer",'Alternativley, you can contactus by ', 
               a("email", href="mailto:gliovis.app@gmail.com"),
               'or through social media.')
             
             # br(), 
             # hr()
         )
         
)
