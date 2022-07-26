# This is the user-interface definition for the GBMDeconvoluteR Shiny web application. 
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyUI( 
  
  navbarPage(title = div(
    div(
      id = "img-id", img(src = "test.png", height = "60px", width = "170px")) 
    ),
             collapsible = TRUE,
             windowTitle = "GBMDeconvoluteR", 
             fluid = TRUE, 
             footer = includeHTML("tools/footer.html"), 
             id = "nav",
             source("tabs/Home/homeTab.R", local = TRUE)$value,
             source("tabs/Run/runTab.R", local = TRUE)$value,
             source("tabs/About/aboutTab.R", local = TRUE)$value
  )
)
