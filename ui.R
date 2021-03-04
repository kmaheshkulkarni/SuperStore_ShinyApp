dashboardPage(
  
  freshTheme = "pdash.css",
  
  header = dashboardHeader(
    title = "Superstore",
    fixed = TRUE,
    rightUi = userOutput("user")
  ),
  
  sidebar = dashboardSidebar(disable = TRUE),
  
  body = dashboardBody(
    
    tabItem(
      tabName = "stcg",
      tabsetPanel(
        id= "statsTab",
        side = "right",
        type = "tabs",
        vertical = FALSE,
        
        tabPanel(
          "Data Overview",
          
          fluidRow(
            column(3,
                   # shinyFilesButton('files', label='File select', title='Please select a file', multiple=FALSE)
                   fileInput('files', 'Upload the Superstore data xls file', accept = c(".xls"))
            )
          ),
          
          fluidRow(
            box(
              title = "Data Table", 
              closable = FALSE, 
              width = 12,
              status = "warning", 
              solidHeader = FALSE, 
              collapsible = TRUE,
              
              fluidRow(
                column(12,
                       align="center",
                       DT::dataTableOutput("dtout") %>% withSpinner(color="#f2a900")
                )
                
              )
              
            )
            
            
          ),
          
          fluidRow(
            column(2, 
                   actionBttn(inputId = "Insights", label = "Get Insights", style = "fill")
            )
          )
          
          
        ),
        
        tabPanel(
          "Data Analysis",
          value = "tab2",
          
          fluidRow(
            column(2, 
                   pickerInput("tablem","Select Year",
                               choices = c("2016", "2017", "2018", "2019"),
                               options = list(`live-search` = TRUE))
            ),
            
            column(2, 
                   actionBttn(inputId = "Insights2", label = "Get Insights", style = "fill")
            )
          ),
          
          fluidRow(
            box(
              title = "Sales Trend", 
              closable = FALSE, 
              width = 12,
              # height = "500px",
              status = "warning", 
              solidHeader = FALSE, 
              collapsible = TRUE,
              label = boxLabel(
                text = 1,
                status = "danger"
              ),
              highchartOutput("sales", width = "100%") %>% withSpinner(color="#f2a900")
              
            ),
            
            box(
              title = "Sales Distribution", 
              closable = FALSE, 
              width = 12,
              # height = "500px",
              status = "warning", 
              solidHeader = FALSE, 
              collapsible = TRUE,
              label = boxLabel(
                text = 1,
                status = "danger"
              ),
              highchartOutput("distr", width = "100%") %>% withSpinner(color="#f2a900")
              
            )
            
          ),
          
          
          fluidRow(
            column(2, 
                   actionBttn(inputId = "Insights3", label = "More Insights", style = "fill")
            )
          )
          
        ),
        
        tabPanel(
          "Clustering Analysis",
          value = "tab3",
          fluidRow(
                column(2,
                       pickerInput("p1","Select Year",
                                   choices = c("2018", "2019"), selected = "2018",
                                   options = list(`live-search` = FALSE))
                ),

                column(2,
                       pickerInput("p2","Select Clusters",
                                   choices = c("05", "10", "15", "20"), selected = "05",
                                   options = list(`live-search` = FALSE))
                ),
                column(2,
                       pickerInput("p3","Select Iterations",
                                   choices = c("05", "10", "15", "20"),selected = "05",
                                   options = list(`live-search` = FALSE))
                ),
                column(2,
                       actionBttn(inputId = "DInsights", label = "Get Insights", style = "fill")
                )
         ),
              fluidRow(
                box(
                  title = "Summary", 
                  closable = FALSE, 
                  width = 12,
                  # height = "500px",
                  status = "warning", 
                  solidHeader = FALSE, 
                  collapsible = TRUE,
                  DT::dataTableOutput("dtout1") %>% withSpinner(color="#f2a900")
                  
                )
              )
          #   
          
          
          
          
        )
        
      )
      
    )
    
    
  ),
  
  footer = dashboardFooter(
    fixed = FALSE,
    left = tagList(a(href="https://www.datazymes.com/", "DataZymes")
    ),
    
    right = a("©DataZymes")
  ), 
  
  preloader = list(html = tagList(spin_1(), "Loading ..."), color = "#343a40"),
  
  fullscreen = TRUE,
  
)