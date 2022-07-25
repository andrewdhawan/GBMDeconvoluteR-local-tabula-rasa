# UI-elements for About tab
tabPanel(title = "About", icon = icon("info-circle"),
         
         tagList(
           tags$head(
             includeCSS("www/styles.css")
           )
         ),
         panel_div(class_type = "primary",panel_title = "How It Work?",content = includeMarkdown("tabs/about_sections/How_does_It_work.Rmd")),
         panel_div(class_type = "primary",panel_title = "Data Processing",content = includeMarkdown("tabs/about_sections/Processing.Rmd")),
         panel_div(class_type = "primary",panel_title = "Interpreting Scores",content = includeMarkdown("tabs/about_sections/Interperting_scores.Rmd")),
         panel_div(class_type = "primary",panel_title = "App Info",content = includeMarkdown("tabs/about_sections/App_info.Rmd")),
         panel_div(class_type = "primary",panel_title = "Session Info",content = htmlOutput("sessionInfo")),
         panel_div(class_type = "primary",panel_title = "License",content = includeMarkdown("tabs/about_sections/License.Rmd"))

)