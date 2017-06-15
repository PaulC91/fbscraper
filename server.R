library(shiny)
library(Rfacebook)
library(tidyverse)
library(lubridate)
library(DT)
library(shinyjs)
library(openxlsx)

function(input, output, session) {
  
  shinyjs::disable("go")
  shinyjs::disable("downloadData")
  
  observe({
    token <- input$token
    group_id <- input$group_id
    n_posts <- input$n_posts
    
    if ( (!is.null(token))&(!is.null(group_id))&(!is.null(n_posts)) ) {
      # enable the submit button
      shinyjs::enable("go")
    }
  })
  
  observe({
    if ( (!is.null(scrape())) ) {
      # enable the download button
      shinyjs::enable("downloadData")
    }
  })
  
  # date function ------------------------------
  format.facebook.date <- function(datestring) {
    date <- as.POSIXct(datestring, format = "%Y-%m-%dT%H:%M:%S+0000", tz = "GMT")
  }
  
  scrape <- eventReactive(input$go, {
    withProgress(message = 'Scraping Data...',
                 value = 0, {
                   for (i in 1:15) {
                     incProgress(1/15)
                   }
                   token <- input$token
                   group_id <- input$group_id
                   n_posts <- input$n_posts
                   #period1 <- paste("1 january", input$period[1], "00:00", sep = " ")
                   #period1 <- input$period[1]
                   #period2 <- paste(day(Sys.Date()), tolower(months(as.Date(Sys.Date()))), 
                    #                input$period[2], "00:00", sep = " ")
                   #period2 <- input$period[2]
                   
                   
                   group_scrape <- getGroup(group_id, token, feed = TRUE, n = n_posts)
                   
                   link_names <- callAPI(paste0("https://graph.facebook.com/v2.9/", group_id, 
                                                "?fields=feed.limit(", n_posts, "){name}"), token)
                   link_names <- dplyr::bind_rows(lapply(link_names$feed$data, as.data.frame))
                   
                   final <- merge(group_scrape, link_names, by = "id")
                   final <- final[complete.cases(final[,12]),] %>%
                     mutate(created_time = format.facebook.date(created_time),
                            Link = paste0("<a href='",link,"' target='_blank'>","open link...","</a>"),
                            Date = as.Date(created_time, format = "%d/%m/%y")) %>%
                     select(`Posted By` = from_name, Track = name, Date, Likes = likes_count,
                            Comments = comments_count, link, Link) %>%
                     arrange(desc(Date))
                   
                   return(final)
                 })
    
    
  })
  
  output$table <- DT::renderDataTable({
    datatable(select(scrape(), -link), rownames = F, filter = 'top', escape = FALSE,
              options = list(
                columnDefs = list(list(className = 'dt-center', targets = '_all'))))
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste0('fb_scrape_', Sys.Date(), '.xlsx') },
    content = function(file) {
      write.xlsx(select(scrape(), -Link), file, sheetName = "TUNES", colWidths = "auto")
    }
  )
  
  observeEvent(input$go, {
    removeUI(
      selector = "#xyz"
    )
  })
  
}