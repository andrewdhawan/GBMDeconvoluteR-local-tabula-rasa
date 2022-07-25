# This is the user-interface definition for the GBMDeconvoluteR Shiny web application. 
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

shinyUI( 
  
  navbarPage(title = div(
    div(
      id = "img-id",
      img(src = "test.png",
          height = "50px",
          width = "150px"
          )
    ),
    strong("")
  ),
             collapsible = TRUE,
             windowTitle = "GBMDeconvoluteR", 
             fluid = TRUE, 
             footer = includeHTML("tools/footer.html"), 
             id = "nav",
             source("tabs/homeTab.R", local = TRUE)$value,
             source("tabs/runTab.R", local = TRUE)$value,
             source("tabs/aboutTab.R", local = TRUE)$value
  )
)
