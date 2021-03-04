function (input, output, session) {
  
  output$user<- renderUser({
    tagList(
      dashboardUser(
        name = "SuperStore Data Insights",
        image = NULL,
        title = "Mahesh",
        subtitle = "Author",
        footer = NULL
      )
    )
  })
  
  thm <- hc_theme_merge(
    hc_theme_darkunica(),
    hc_theme(
      chart = list(
        backgroundColor = "transparent"
      ),
      title = list(
        style = list(
          color = "white",
          fontSize = "25px"
        )
      ),
      legend = list(
        itemStyle = list(
          # fontFamily = "Tangerine",
          color = "#ffa20d"
        ),
        itemHoverStyle = list(
          color = "gray"
        )
      )
    )
  )
  
  w<- Waiter$new()
  observeEvent(input$files,{
    if(is.null(input$files)||input$files == 0)
    {
      sendSweetAlert(session = session, title = "Error", text = "No Records Present", type = "error")
    }
    else
    {
      w$show()
      # shinyFileChoose(input, 'files', roots = c('wd' = 'C:/Users/'), 
      #                 defaultPath='C:/Users/')
      
      output$dtout <- DT::renderDataTable({
        if(str_sub(input$files$name, -3) != "xls"){
            # sendSweetAlert(session = session, title = "Error", text = "No Records Present", type = "error") 
            shinyalert("Error.....!", "Please Select .xls file.", type = "error")
          }
          
        else
        {
          FinalData <- readxl::read_xls(input$files$datapath)
          head(FinalData, 10)
          # print(colnames(data))
          datatable(FinalData, 
                    options = list(
                      dom = 't',
                      scroller = TRUE,
                      scrollX = TRUE, 
                      "pageLength" = 100),
                    rownames = FALSE
          )
        }
          
      })
      
      w$hide()
    }
    
    
  })
  
  observeEvent(input$Insights,{
      w$show()
      
      # updateTabItems(session, "tabs", "Data_Analysis")
      # updateTabsetPanel(session, "intabset4", selected = "Analysis")
      updateTabsetPanel(session, "statsTab", selected = "tab2")
      # updateTabItems(session = getDefaultReactiveDomain(), inputId = "tab2", selected = "stcg")
      w$hide()
    
  })
  
  
  observeEvent(input$Insights2,{
    if(is.null(input$Insights2)||input$Insights2==0)
    {
      sendSweetAlert(session = session, title = "Error", text = "No Records Present", type = "error")
    }
    else
    {
      w$show()
      
      output$sales<-renderHighchart({
        Fdata <- readxl::read_xls(input$files$datapath)[, c("Order Date","Category", "Sales")]
        # Fdata <- readxl::read_xls("Sample - Superstore.xls")[, c("Category", "Order Date", "Sales")]
        Fdata<- as.data.frame(Fdata)
        Fdata$Year <- year(as.Date(Fdata$`Order Date`))
        Fdata$month <- month(as.Date(Fdata$`Order Date`))
        Fdata$month_name <- month.name[month(as.Date(Fdata$`Order Date`))]
        
        Year_Chart <- Fdata[Fdata$Year == input$tablem,]
        
        F_data <- as.data.frame(Year_Chart %>% group_by(Category, month, month_name) %>% summarise(Mean_Sales= mean(Sales)))
        F_data$month_name<- factor(F_data$month_name, levels = month.name)
        F_data$month_name<- F_data$month_name
        
        F_data$Mean_Sales<- round(F_data$Mean_Sales, 2)
        
        Furniture_data <- F_data %>% filter(Category == "Furniture")
        Furniture_data$month_name<- factor(Furniture_data$month_name, levels = month.name)
        Furniture_data$month_name<- Furniture_data$month_name
        
        Supplies_data <- F_data %>% filter(Category == "Office Supplies")
        Supplies_data$month_name<- factor(Supplies_data$month_name, levels = month.name)
        Supplies_data$month_name<- Supplies_data$month_name
        
        Technology_data <- F_data %>% filter(Category == "Technology")
        Technology_data$month_name<- factor(Technology_data$month_name, levels = month.name)
        Technology_data$month_name<- Technology_data$month_name
        
        print("F_data")
        print(head(F_data))
        
        hc <- highchart() %>% 
          hc_xAxis(categories = F_data$month_name) %>% 
          hc_add_series(
            name = "Furniture", data = Furniture_data$Mean_Sales
          ) %>% 
          hc_add_series(
            name = "Office Supplies", data = Supplies_data$Mean_Sales
          ) %>% 
          hc_add_series(
            name = "Technology",
            data = Technology_data$Mean_Sales
          ) %>%
          hc_legend(
            align = "left",
            verticalAlign = "top",
            layout = "vertical",
            x = 0, y = 100) %>%
          hc_tooltip(
            crosshairs = TRUE,
            backgroundColor = "#ffa20d",
            shared = TRUE, 
            borderWidth = 5
          ) %>%
          hc_xAxis(
            labels = list(style = list(fontSize = "10px", color = "#ffa20d"))
          ) %>% hc_yAxis(
            labels = list(style = list(fontSize = "10px", color = "#ffa20d"))
          )
        
        hc  %>%
          hc_add_theme(thm)
      })
      
      
      
      output$distr<- renderHighchart({
        
        sales_distribution <- as.data.frame(readxl::read_xls(input$files$datapath) 
                                           %>% group_by(Region, Category) %>% summarise(Sales = sum(Sales)))
        
        sales_distribution$Sales <- round(sales_distribution$Sales,2)
        
        hc1<- hchart(sales_distribution, "column", hcaes(x = Region, y = Sales, group = Category)) %>%
          hc_legend(
            align = "left",
            verticalAlign = "top",
            layout = "vertical",
            x = 0, y = 100) %>%
          hc_tooltip(
            crosshairs = TRUE,
            backgroundColor = "#ffa20d",
            shared = TRUE, 
            borderWidth = 5
          ) %>%
          hc_xAxis(
            labels = list(style = list(fontSize = "10px", color = "#ffa20d"))
          ) %>% hc_yAxis(
            labels = list(style = list(fontSize = "10px", color = "#ffa20d"))
          )
        
        hc1  %>%
          hc_add_theme(thm)
      })
      
      w$hide()
    }
    
  })
  
  
  
  observeEvent(input$Insights3,{
    w$show()
    
    # updateTabItems(session, "tabs", "Data_Analysis")
    # updateTabsetPanel(session, "intabset4", selected = "Analysis")
    updateTabsetPanel(session, "statsTab", selected = "tab3")
    # updateTabItems(session = getDefaultReactiveDomain(), inputId = "tab2", selected = "stcg")
    w$hide()
    
  })
  
  
  
  observeEvent(input$DInsights,{
    if(is.null(input$DInsights)||input$DInsights ==0)
    {
      sendSweetAlert(session = session, title = "Error", text = "No Records Present", type = "error")
    }
    else
    {
      w$show()

      output$dtout1<- DT::renderDataTable({
        
        if (!is.null(input$files)){
          if(str_sub(input$files$name, -3) == "xls"){
            clust_data <- readxl::read_xls(input$files$datapath)[, c("Order Date", "Customer ID", "Order ID", "Quantity", "Sales", "Profit")]
            clust_data$year <- year(clust_data$`Order Date`)
            Clust_In <- clust_data[clust_data$year %in% input$p1, ]
            last_order <- max(Clust_In$`Order Date`)
            
            clust_data1 <- as.data.frame(clust_data %>% group_by(`Customer ID`) %>% 
                               summarise(Quantity = sum(Quantity),
                                        Sales = sum(Sales),
                                        Recency = as.numeric(last_order - max(`Order Date`)),
                                        Frequency_Order = length(`Order ID`),
                                        Overall_Profit = sum(Profit)))
            
            clust_data1$Scaled_Recency <- (clust_data1$Recency - mean(clust_data1$Recency))/sd(clust_data1$Recency)
            clust_data1$Scaled_Frequency <- (clust_data1$Frequency_Order - mean(clust_data1$Frequency_Order))/sd(clust_data1$Frequency_Order)
            clust_data1$Scaled_Profit <- (clust_data1$Overall_Profit - mean(clust_data1$Overall_Profit))/sd(clust_data1$Overall_Profit)
            
            
            x <- c(7:9)
            y <- c(1:6)
            z <- c(y, x)
            
            set.seed(100)
            
            Main_clusters <- kmeans(clust_data1[,x], centers = input$p2, iter.max = input$p3)
            
            clust_data1$Cluster_Group <- Main_clusters$cluster
            
            clust_data2 <- as.data.frame(clust_data1 %>% group_by(Cluster_Group) %>% 
                                        summarise(Total_Customer = length(`Customer ID`),
                                                  Average_Recency = round(mean(Recency)),
                                                  Overall_Sales = round(sum(Sales)),
                                                  All_Profit = round(sum(Overall_Profit))))
            
            clust_data2$Overall_Sales <- format(clust_data2$Overall_Sales,big.mark=",",trim = FALSE)
            clust_data2$All_Profit <- format(clust_data2$All_Profit,big.mark=",",trim = FALSE)
            clust_data2 <- clust_data2[order(clust_data2$All_Profit), ]
            
            datatable(clust_data2, 
                      options = list(dom = 't',
                                     scroller = TRUE,
                                     scrollX = TRUE, 
                                     "pageLength" = input$p2),
                      rownames = FALSE)
            }
        }
      })

      w$hide()
    }
  })
  
  
  
  
}