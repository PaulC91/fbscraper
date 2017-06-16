
library(shiny)
library(DT)

fluidPage(
  
  #theme = "bootstrap.css",
  tags$head(
    tags$style(HTML("
                    @import url('https://fonts.googleapis.com/css?family=Roboto+Condensed');
                    
                    * {
                    font-family: 'Roboto Condensed', sans serif;
                    }

                    body {
                    background-color: #f5f5f5
                    }
                    "))
    ),
  
  shinyjs::useShinyjs(),
  
  div(id = "apptitle", class = "row", width = 12,
      style = paste0("background-color:#3b5998; margin-bottom:15px; text-align:center;
                     padding-top:5px; padding-bottom:5px"),
      tags$strong(h4("Facebook Music Group Explorer", style = "color:white"))
      ),
  
  titlePanel(title = "", windowTitle = "FB Music Scraper"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("token", label=p("Access Token - get one ", a("here", href="https://developers.facebook.com/tools/explorer",
                                                             target="_blank")), value = NULL, width = NULL, placeholder = "Paste your access token here"),
      tags$hr(),
      textInput("group_id", label="Group ID", value = NULL, width = NULL, placeholder = "Paste Group/Page ID here"),
      tags$hr(),
      #sliderInput("period", "Get posts within timeframe...", min = ymd("2015/01/01"), max = ymd(Sys.Date()),
       #           value = c(ymd("2015/01/01"), ymd(Sys.Date()), timeFormat="%Y-%m-%d")), #, step=1, sep = "")),
      textInput("n_posts", label="Number of Posts to scrape", value = NULL, width = NULL, placeholder = "facebook doesn't like more than 250 :("),
      tags$hr(),
      actionButton("go", "Submit"),
      downloadButton('downloadData', 'Download Data')
      #h4("Step 4:"),
      #downloadButton("pptxdownload", "Generate Powerpoint")
    ),
    
    mainPanel(
      tags$div(id = "xyz",
               tags$h4("Scrape data from your favourite facebook music groups"),
               tags$p("If, like me, you have a few groups on facebook where you share music with friends, or even just
                      follow a few pages that regularly post links to music on youtube or soundcloud, you might find it
                      frustratingly difficult to access posts from months/years gone by."),
               tags$p("Facebook's group search function rarely returns what you're looking for and scrolling down to find that one track
                      someone posted a few months back that no one can remember the name of can take an age."),
               tags$p("Cue the facebook music explorer; a shiny app that can scrape the data of any posts containing
                      a link in a facebook group/page."),
               tags$p("Unfortunately, to access the facebook API you'll have to head over to facebook's", 
                      tags$a("developer site,", href="https://developers.facebook.com/tools/explorer",
                             target="_blank"), "log in, and get yourself an access token (make sure to allow
                      permissions to access all your content). The tokens only last 2 hours so you'll have to grab 
                      a new one each time you want to grab your tunes."),
               tags$p("Once that's done, paste it in the box top left then paste in your group id (the 15 digit
                      number that comes after the /group/ part of the url). You can also scrape public pages! Try something 
                      like 'panoramabarmusic' or 'Phonica.Records' if you're into that sorta thing. Lastly type how many 
                      posts you want to try and scrape. Facebook says it doesn't like more than 250 but I've managed 
                      to get up to ~800 without it failing. Anything above that will most likely boot you off the server."),
               tags$p("If all goes to plan you should soon be looking at a fully filterable + searchable datatable of all 
                      those tracks you and your mates have spent hours curating. There's also the option of downloading 
                      all the data to an excel file so you can have an archive stored locally."),
               tags$p("Although I'm suggesting this be used for music purposes, you can use it to scrape any page/group where
                      there are links present. So feel to scrape that funny cat videos group you're the admin of."),
               tags$p("Finally, if you're into #rstats and want to dig a bit deeper into the facebook scraping world
                      then definitely check out the great", tags$a("Rfacebook", href="https://github.com/pablobarbera/Rfacebook",
                                                                   target="_blank"), "package, which this app utilises - thank you Pablo Barbera!"),
               tags$p("Shoot me a note on", tags$a("twitter", href="https://twitter.com/paulcampbell91",
                                                   target="_blank"),"if you have any questions. Happy Scraping!")
               ),
      DT::dataTableOutput("table")
    )
  ),
  br(),
  br(),
  br(),
  br(),
  div(id = "appfooter", class = "footer navbar-fixed-bottom", width = 12,
      style = paste0("background-color:#f5f5f5; margin-bottom:0px; text-align:center;
                     padding-top:5px; padding-bottom:5px"),
      #tags$p("PROTOTYPE TESTING VERSION", style = "color:#A6C0C5"),
      tags$p("© Culture of Insight Ltd (2017). All Rights Reserved", style = "color:#A6C0C5")
      )
)