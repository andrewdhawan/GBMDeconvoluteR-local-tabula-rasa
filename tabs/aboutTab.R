# UI-elements for About tab
tabPanel(title = "About", icon = icon("info-circle"),
         
         tagList(
           tags$head(
             includeCSS("www/styles.css")
           )
         ),
         
         panel_div(class_type = "primary",panel_title = "Data Processing",content = includeMarkdown("tabs/about_sections/Processing.Rmd")),
         panel_div(class_type = "primary",panel_title = "Classification",content = includeMarkdown("tabs/about_sections/Classification.Rmd")),
         # panel_div(class_type = "primary",panel_title = "Funding",
         #          content = HTML ('<a href ="http://www.seveballesteros.com"><img src="seve.jpg" height = "135"  width = "405"></a>')),
         panel_div(class_type = "primary",panel_title = "App Info",content = includeMarkdown("tabs/about_sections/App_info.Rmd")),
         panel_div(class_type = "primary",panel_title = "Session Info",content = htmlOutput("sessionInfo")),
         panel_div(class_type = "primary",panel_title = "License",content = includeMarkdown("tabs/about_sections/License.Rmd"))

)