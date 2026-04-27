library(ggplot2)
library(ggiraph)
library(scales)
library(ggtext)
library(patchwork)
library(DT)
library(huxtable)
library(dplyr)
library(data.table)
library(formattable)
library(DT)
library(shiny)
library(shinyBS)
library(shinyjs)
library(shinydashboard)
library(shinyWidgets)
library(dplyr)
library(rsvg)
library(rio)
library(DiagrammeRsvg)
library(DiagrammeR)
library(shinyjs)
library(tesseract)
#library(magick)
library(gridExtra)
library(grid)
library(patchwork)
library(cowplot)
#library(tableHTML)

#token <- get_distiller_token()
# ==============================
# DISTILLER TOKEN WITH AUTO REFRESH   # ==============================
# INCLUDED STUDIES WITH CACHE ADDED ON 03/03/2026 to cache and add excel download bottons 
# ==============================
# ==============================

#distiller_token <- reactiveVal(NULL)
#token_time <- reactiveVal(NULL)

#generate_token <- function() {
#  cat("Generating new Distiller token...\n")
#  new_token <- get_distiller_token()
#  distiller_token(new_token)
#  token_time(Sys.time())
#}

# Initial token generation
#generate_token()

#results_test <- read_excel("flowchart_01.xlsx")
#results_test_L2_exlclude <- results_test$Level2_Records_Exclueded
#results_test_search <- results_test$Records_Identified_Searching
#results_test_remove_N <- results_test$Records_after_dup_remove_N
#results_test_L2_screen <- results_test$Level2_Records_Screened


#img <- image_read("flowchart_01.PNG")
#text <- image_ocr(img)
#lines <- strsplit(text, " ")[[1]]

#df <- data.frame(line = lines, stringsAsFactors = FALSE)
most_recent_date <- timelineV02$date[nrow(timelineV02)]
formatted_date <- format(most_recent_date, "%B %d, %Y")


dat <- data.frame(
  country = c('us', 'nl', 'de')
  
)

#dat$flag1 <- sprintf ('<img src = "http://flagpedia.net/data/flags/mini/%s.png" height="52" ></img>', dat$country)
dat$flag1 <- sprintf ('<img src = "https://flagpedia.net/data/flags/w2560/%s.png" height="52" ></img>', dat$country)

#My APA-format theme
apatheme=theme_bw(base_size = 23)+
  theme(panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.border=element_blank(),
        axis.line=element_line(),
        strip.text.y.left = element_text(size = 27,angle = 90),
        axis.text.y = element_text(hjust = 23),
        axis.title.y = element_text(face = "bold", size=25),
        text=element_text(family='Times', size=29),
        legend.position='none')

bg.picker <- function(z){
  if(is.na(z)){return("black")}
  else if(z == "Low"){return("forestgreen")}
  else if(z == "Moderate"){return("lightgreen")}
  else if(z == "High"){return("pink")}
  else if(z == "Serious"){return("salmon")}
  else if(z == "Critical"){return("red")}
  else if(z == "Uncertain"){return("wheat")}
  #else if( z > 20 & z <= 80){return("yellow")}
  #else {return("pink")}
}

##### color for new domains
bg.picker1 <- function(z){
  if(is.na(z)){return("black")}
  else if(z == "Low"){return("forestgreen")}
  else if(z == "Likely Low"){return("lightgreen")}
  else if(z == "Likely High"){return("pink")}
  else if(z == "High"){return("red")}
  else if(z == "Unclear risk of bias for one or more key domains."){return("wheat")}
  else if(z == "Low risk of bias for all key domains."){return("forestgreen")}
  else if(z == "High risk of bias for one or more key domains."){return("red")}
  #else if( z > 20 & z <= 80){return("yellow")}
  #else {return("pink")}
}

#forest <- forest %>% mutate(inter = ifelse(is.na(lowerci), yi, paste(forest$yi,"[",forest$lowerci, ",", forest$upperci,"]")), Reference = paste(forest$id, ".", forest$study))
#forest123 <- forest123 %>% mutate( Reference = paste(forest123$id, ".", forest123$study))
#forest123 <- forest123 %>% mutate( Reference = paste(forest123$study, "(", forest123$id,")"))
shinyServer(function(input, output){ 
  
  #source("reactive.R", local = TRUE)
  #source("forestROBPlot.R",  local = TRUE)
  #source("forestROBPlotExperiment.R", local = TRUE)
  #  observeEvent(input$chk, {
  #    if (input$chk) hide('mytable1234') else show('mytable1234')
  #  })
  
  
  ## descriptive plots ####
  ## * switch text ####
  output$eda_text <- renderUI({
    switch(
      input$eda_btn,
      "sp" = p("Most articles were published in North America and some in Europe."),
      "ts" = p("This plot shows the date of publication of studies included in the review"),
      "coef" = p("The following table shows the number of reported outcomes grouped in broad categories (i.e lower and upper respiratory tracts, MRSA etc) 
                    for the relevant studies included in the last review. We observe that nearly 500 outcomes were extracted from the 16 publications and 10 study populations. For several study populations, numerous correlated outcomes were compared with
numerous correlated exposures. This approach increases
the potential to discover important associations and also
increases the potential for identification of false associations due to random error (increased type 1 error)."),
      "tabl" = p("The following list contains the titles of the articles included in this review.")
    )
  })
  ## * switch plot ####
  output$eda_plot <- renderUI({
    switch(
      input$eda_btn,
      "sp" = fluidRow(
        column(width = 6, leafletOutput("map") %>% withSpinner()),
        #column(width = 6, plotlyOutput("geobar"),dataTableOutput('mytable1234') %>% withSpinner())#,
        column(width = 6, plotlyOutput("geobar") %>% withSpinner())),
      "ts" = timevisOutput("timeline"),
      "coef" = plotOutput("measure_all", hover = "plot_hover") %>% withSpinner()#,
      #"tabl" = DT::dataTableOutput("mytable1234")
    )
  })
  
  ##
  ############# generation of weblink #############
#  cafo_map1 <- cafo_map %>%
#    mutate(
#      Last_Name = str_split_fixed(Author, ",", 2)[,1],  # Extract last name before the comma
#      authors = paste(Last_Name, "et al.", Year)        # Combine last name with "et al." and Year
#    ) %>%
#    select(-Last_Name)  # Remove the intermediate Last_Name column if no longer needed
  
  
#  cafo_map1 <- cafo_map1 %>%
#    mutate(
#      weblink = paste0("<a href='", "https://doi.org/", DOI, "'>", authors, "</a>")
#    )
  
  # Create a subset with specific columns
#  subset_df <- cafo_map1 %>%
#    select(weblink, Year, Refid, Country, authors)

  
 
  output$map <- renderLeaflet({
    # Process cafo_map to include weblinks

    
  ## * geographic distribution ####
  # Create the map
  leaflet(cafoo_map) %>% 
    addProviderTiles(providers$Esri,
                     options = providerTileOptions(noWrap = TRUE)) %>%  
    setView(-40.679728, 34.738366, zoom = 2) %>%  ## Set/fix the view of the map 
    addCircleMarkers(lng = ~long, lat = ~lat,
                     radius = 5, # Adjust the radius as needed
                     popup = ~paste("<b>Country:</b> ", Country, "<br>", grouped_df$weblinks)
    )
})

  ###
  
  refs_data <- reactive({
    
    if(!file.exists("refs_cache.rds")){
      stop("❌ refs_cache.rds not found. Run cache script first.")
    }
    
    readRDS("refs_cache.rds")
  })
  
  last_screening_date <- reactive({
    timeline <- readxl::read_excel("datasets/timeline_V01.xlsx")
    timeline$date <- as.Date(timeline$date)
    format(max(timeline$date, na.rm = TRUE), "%B %d, %Y")
  })
  
  n_identified <- reactive({ nrow(refs_data()) })
  
  n_excluded_screen <- reactive({
    refs_data() %>% dplyr::filter(level == 1) %>% nrow()
  })
  
  n_fulltext_excluded <- reactive({
    refs_data() %>% dplyr::filter(level == 2) %>% nrow()
  })
  
  n_included_total <- reactive({
    refs_data() %>% dplyr::filter(level == 4) %>% nrow()
  })
  
  n_screened <- reactive({ n_identified() - 15 })
  
  n_full_text <- reactive({
    (n_fulltext_excluded() + n_included_total()) - 15
  })
  
  n_included_new <- reactive({
    n_full_text() - n_fulltext_excluded()
  })
  
  n_total_included <- reactive({
    n_included_total()
  })
  
  build_prisma_graph <- reactive({
    
    DiagrammeR::grViz(paste0("
    digraph PRISMA {
    graph [layout = neato, splines=ortho]

    node [shape = box, style = solid, width = 3]

    prev_header [label='Previous review', style='filled', fillcolor='lightgrey', pos='1,9!']

    header [
    label='Identification of new studies via databases and registers',
    style='filled',
    fillcolor='gold',
    width=8,
    pos='8,9!'
    ]

    prev_studies [label='Studies included until 2014\\n(n = 15)', pos='1,7!']

    screened [
    label='Records screened through\\n", last_screening_date(), "\\n(n = ", n_screened(), ")',
    pos='6,7!'
    ]

    records_excluded [
    label='Records excluded\\n(n = ", n_excluded_screen(), ")',
    pos='10,7!'
    ]

    full_text [
    label='Full-text articles assessed\\n(n = ", n_full_text(), ")',
    pos='6,5!'
    ]

    full_excluded [
    label='Full-text articles excluded\\n(n = ", n_fulltext_excluded(), ")',
    pos='10,5!'
    ]

    included_new [
    label='New studies included in update\\n(n = ", n_included_new(), ")',
    pos='6,3!'
    ]

    included_total [
    label='Total studies included in review\\n(n = ", n_total_included(), ")',
    pos='6,1!'
    ]

    screened -> records_excluded
    screened -> full_text
    full_text -> full_excluded
    full_text -> included_new
    included_new -> included_total
    prev_studies -> included_total [constraint=false]

    }
    "))
  })
  
  output$prisma <- DiagrammeR::renderGrViz({
    build_prisma_graph()
  })
  
  output$download_prisma <- downloadHandler(
    filename = function() paste0("PRISMA_", Sys.Date(), ".png"),
    content = function(file){
      svg <- DiagrammeRsvg::export_svg(build_prisma_graph())
      rsvg::rsvg_png(charToRaw(svg), file = file, width = 1400)
    }
  )
  
  #####
  #  output$geobar <- renderPlotly({
  #    gg <- cafo2 %>% distinct() %>%
  #      group_by(Country) %>% summarise(Count = n()) %>% 
  #      mutate(Country = forcats::fct_reorder(factor(Country), Count)) %>%
  #      ggplot(aes(x = Country, y = Count)) + 
  #      geom_bar(aes(fill = Country), stat = "identity") +
  #      scale_fill_brewer(palette = "Set2")
  #    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
  #  })
  ###########
  ########### BAr chart of coutries
  output$geobar <- renderPlotly({
    gg <- cafoo_map %>% ggplot(aes(x = reorder(Country, `Number_of_Studies`), y = `Number_of_Studies`)) + 
      geom_bar(aes(fill = Country), stat = "identity") +
      scale_fill_brewer(palette = "Set2")+labs(x = "Country", y = "Number of Studies")+theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
  })
  
  ###########
  ########### 
  ########### * timeline ####

  
  output$timeline <- renderTimevis({
    
    
    # Convert Year column to a valid date format (e.g., first day of the year)
    cafo_map1$start_date <- as.Date(paste0(cafo_map1$Year, "-01-01"))
    
    # Create the data frame for the timeline
    datt1 <- data.frame(
      id = 1:nrow(cafo_map1),   
      content = cafo_map1$weblink,
      start = cafo_map1$start_date,  # Use the new start_date column
      end = NA
    )
    
    # Render the timeline
    timevis(datt1, showZoom = F)
  })
  
  
  ## * outcome ####
  output$measure_all <- renderPlot({
    colnames(dataset)[which(names(dataset) == "Categorized.class")] <- "Broad Outcome Category"
    dataset %>% ggplot(aes(x = paperInfo ) ) +
      geom_bar(aes(fill = `Broad Outcome Category`)) + coord_flip() + 
      scale_fill_brewer(palette = "Set3") +
      #labs(x = "", fill = "Health Outcome Group") +
      labs(x = "", fill = "Broad Outcome Category") +
      xlab("Paper") +
      ylab("Number of Reported Outcomes") + 
      theme(plot.background = element_rect(fill = "#BFD5E3"),
            panel.background = element_rect(fill = "white"),
            axis.line.x = element_line(color = "grey"))
    #ggplotly(gg, tooltip = c('Broad Outcome Category', 'count')) %>% config(displayModeBar = T)
    
    
  })
  
  ## forest fitlers ####
  selected_class <- reactive({
    case_when(
      grepl("low_rsp", input$sidebar) ~ "Lower Respiratory",
      grepl("up_rsp", input$sidebar) ~ "Upper Respiratory",
      grepl("ar_rsp", input$sidebar) ~ "Antimicrobial resistance",
      grepl("ic_rsp", input$sidebar) ~ "Infectious conditions",
      grepl("gi_rsp", input$sidebar) ~ "Gastrointestinal condition",
      
      TRUE ~ "Other"
    )
  }) 
  selected_id <- reactive({
    dataset %>% filter(Categorized.class==selected_class()) %>% 
      pull(Refid) %>% unique()
  })
  
  
  ##### only measure of association
  output$expo_var_1_low <- renderUI({
    choices1 <- low_forest$effect_z
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
    
  })
  
  ### up
  
  output$expo_var_1_up <- renderUI({
    #choices1 <- forest_sabado$effect_measure
    choices1 <- up_forest$effect_z
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_up",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
  })
  
  ####  filter for study AR
  output$expo_var_1_ar_susi <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- ar_forest$authors
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ar_susi",
                "Study",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ####  filter for study Upper
  output$expo_var_1_up_susi <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- up_forest$authors
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_up_susi",
                "Study",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  #### filter for low authors
  output$expo_var_1_low_susi <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- low_forest$authors
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low_susi",
                "Study",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  #### filter for low authors for state
  output$expo_var_1_low_state_susi <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- low_forest_state$authors
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low_state_susi",
                "Study",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  #### filter for ic authors
  output$expo_var_1_ic_susi <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- ic_forest$authors
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ic_susi",
                "Study",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  #### filter for GI authors
  output$expo_var_1_gi_susi <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- gi_forest$authors
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_gi_susi",
                "Study",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  
  
  ###### filter for  AR country 
  output$expo_var_1_ar_susi_country <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- ar_forest$Country
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ar_susi_country",
                "Country",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for  upper country 
  output$expo_var_1_up_susi_country <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- up_forest$Country
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_up_susi_country",
                "Country",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for  Low country 
  output$expo_var_1_low_susi_country <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- low_forest$Country
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low_susi_country",
                "Country",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for  Low country for state
  output$expo_var_1_low_state_susi_country <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- low_forest_state$Country
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low_state_susi_country",
                "Country",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for  IC country 
  output$expo_var_1_ic_susi_country <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- ic_forest$Country
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ic_susi_country",
                "Country",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  
  ###### filter for  GI country 
  output$expo_var_1_gi_susi_country <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- gi_forest$Country
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_gi_susi_country",
                "Country",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  
  ###### filter for AR outcome 
  output$expo_var_1_ar_outcome <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- ar_forest$Outcome.variable
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ar_outcome",
                "Outcome",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for Upper outcome 
  output$expo_var_1_up_outcome <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- up_forest$Outcome.variable
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_up_outcome",
                "Outcome",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  
  ###### filter for Low R outcome 
  output$expo_var_1_low_outcome <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- low_forest$Outcome.variable
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low_outcome",
                "Outcome",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  
  ###### filter for Low R outcome 
  output$expo_var_1_low_state_outcome <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- low_forest_state$Outcome.variable
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low_state_outcome",
                "Outcome",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for IC R outcome 
  output$expo_var_1_ic_outcome <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- ic_forest$Outcome.variable
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ic_outcome",
                "Outcome",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for IC R outcome 
  output$expo_var_1_gi_outcome <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- gi_forest$Outcome.variable
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_gi_outcome",
                "Outcome",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  
  ###### filter for AR exposure 
  output$expo_var_1_ar_exposure <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- ar_forest$Exposure.measure
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ar_exposure",
                "Exposure",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for upper exposure 
  output$expo_var_1_up_exposure <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- up_forest$Exposure.measure
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_up_exposure",
                "Exposure",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  
  ###### filter for Low exposure 
  output$expo_var_1_low_exposure <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- low_forest$Exposure.measure
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low_exposure",
                "Exposure",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  
  ###### filter for Low exposure for state
  output$expo_var_1_low_state_exposure <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- low_forest_state$Exposure.measure
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low_state_exposure",
                "Exposure",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for IC exposure 
  output$expo_var_1_ic_exposure <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- ic_forest$Exposure.measure
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ic_exposure",
                "Exposure",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  ###### filter for GI exposure 
  output$expo_var_1_gi_exposure <- renderUI({
    #choices1 <- forest_joint$effect_z
    choices1 <- gi_forest$Exposure.measure
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_gi_exposure",
                "Exposure",
                choices = unique(choices1), 
                options = list(`actions-box` = TRUE),
                #choices = unique(choices1),
                selected = choices1,
                
                multiple = T)
    
  })
  
  
  
  ####AR test123
  output$expo_var_1_ar <- renderUI({
    choices1 <- ar_forest$effect_z
    #choices1 <- forest_joint$Outcome.variable
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ar",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
  })
  ##########
  output$expo_var_1_low_state <- renderUI({
    choices1 <- low_forest_state$effect_z
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_low_state",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
  })
  
  ########## 
  output$expo_var_1_up_state <- renderUI({
    choices1 <- up_forest_state1$effect_z_state
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    selectInput("expo_b_up_state",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
  })
  ### AR
  
  output$expo_var_1_ar_state <- renderUI({
    choices1 <- up_forest_state1$effect_z_state
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    selectInput("expo_b_ar_state",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
  })
  
  #### GI STATES
  output$expo_var_1_gi_state <- renderUI({
    choices1 <- up_forest_state1$effect_z_state
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    selectInput("expo_b_gi_state",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
  })
  
  #### IC STATES
  output$expo_var_1_ic_state <- renderUI({
    choices1 <- up_forest_state1$effect_z_state
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    selectInput("expo_b_ic_state",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
  })
  

  ### IC
  
  output$expo_var_1_ic <- renderUI({
    #choices1 <- forest_sabado$effect_measure
    choices1 <- ic_forest$effect_z
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_ic",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
  })
  
  #### GI
  
  output$expo_var_1_gi <- renderUI({
    #choices1 <- forest_sabado$effect_measure
    choices1 <- gi_forest$effect_z
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    pickerInput("expo_b_gi",
                "Effect size measure",
                choices = unique(choices1), 
                selected = choices1[1])
    
  })
  
  
  ### Neuro
  
  
  
  output$expo_var_2 <- renderUI({
    choices2 <- forest$t_expo
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    selectInput("expo_c",
                "Type of Exposure",
                choices = unique(choices2),
                
                selected = choices2[1])
  })
  
  #### Upper R
  
  output$expo_var_2_up <- renderUI({
    choices2 <- forest$t_expo
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    selectInput("expo_c_up",
                "Type of Exposure",
                choices = unique(choices2),
                
                selected = choices2[1])
  })
  
  #### AR
  
  output$expo_var_2_ar <- renderUI({
    choices2 <- forest$t_expo
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    selectInput("expo_c_ar",
                "Type of Exposure",
                choices = unique(choices2),
                
                selected = choices2[1])
  })
  
  #### Gastro
  
  output$expo_var_2_gi <- renderUI({
    choices2 <- forest$t_expo
    #forest %>%
    #filter(mm == selected_state()) %>%
    #pull(mm) %>% unique() %>% sort() 
    selectInput("expo_c_gi",
                "Type of Exposure",
                choices = unique(choices2),
                
                selected = choices2[1])
  })
  
  #### Neuro
  
  
  output$selected_var <- renderText({ 
    
    
    d = nrow ((cafo_map1))
    
    
    paste("This page provides basic descriptive information of studies included 
    in the living systematic review. ","The last search was conducted on March 31 st, 2023."," A total of ", d, " studies have been included 
    to date.", "The geographical distribution and the date of publications of the studied 
          populations are visualized in the graphics provided.")
  })
  
  
  output$upper_pairs <- renderText({ 
    
    upper_rob_1 <- ROB_joint_tl %>% filter(category== 'Upper Respiratory')
    
    sat1 <- forest_cross %>% filter(category=="Upper Respiratory")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat2 <- forest_cohort %>% filter(category=="Upper Respiratory")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat3 <- forest_case %>% filter(category=="Upper Respiratory")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    
    forest_joint_up <-  bind_rows(sat1,sat2,sat3)
    
    
    
    timedata2 <- cafo_map1  %>% filter(UR=="Yes")  
    d = nrow ((up_forest))
    s = nrow ((timedata2))
    u = nrow ((forest_joint_up))
    k = nrow((upper_rob_1))
    
    paste("Of the", s,"studies reporting upper respiratory outcomes,", u, " conditions (listed in the 'Outcomes Categorized as Upper Respiratory' tab) were identified,", k,"exposure-outcome pairs were identified as providing estimates of contrast incidences, and", d, "effect measures were extracted from them (listed in 'Incidence Forest Plot' section).")
  })
  
  
  observeEvent(input$link_to_tabpanel_b, {
    newvalue <- "included"
    updateTabItems(getDefaultReactiveDomain(), "sidebar", newvalue)
  }) 
  
  observeEvent(input$link_to_tabpanel_a, {
    newvalue <- "excluded"
    updateTabItems(getDefaultReactiveDomain(), "sidebar", newvalue)
  }) 
  
  observeEvent(input$link_to_tabpanel_c, {
    newvalue <- "roses"
    updateTabItems(getDefaultReactiveDomain(), "sidebar", newvalue)
  })  
 
  output$upper_rob_text <- renderText({ 
    upper_rob_1 <- ROB_joint_tl %>% filter(category== 'Upper Respiratory')
    
    a = length(which(upper_rob_1$`Question 1` != "NA"))
    b = length(which(upper_rob_1$`Question 2` != "NA"))
    c = length(which(upper_rob_1$`Question 3` != "NA"))
    d = length(which(upper_rob_1$`Question 4` != "NA"))
    e = length(which(upper_rob_1$`Question 5` != "NA"))
    f = length(which(upper_rob_1$`Question 6` != "NA"))
    g = length(which(upper_rob_1$`Question 7` != "NA"))
    h = length(which(upper_rob_1$`Question 8` != "NA"))
    i = length(which(upper_rob_1$`Question 9` != "NA"))
    j = length(which(upper_rob_1$`Question 10` != "NA"))
    
    
    #sat1 <- forest_cross %>% filter(category=="Upper Respiratory")%>%
    #  group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    #  sat2 <- forest_cohort %>% filter(category=="Upper Respiratory")%>%
    #   group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    # sat3 <- forest_case %>% filter(category=="Upper Respiratory")%>%
    #    group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    
    # forest_joint_up <-  bind_rows(sat1,sat2,sat3)
    
    
    
    timedata2 <- cafo_map1  %>% filter(UR=="Yes")  
    w = nrow ((upper_rob_1))
    s = nrow ((timedata2))
    #u = nrow ((forest_joint_up))
    
    #paste("Of the", s,"studies reporting upper respiratory outcomes,", u, " conditions (listed in the 'Outcomes Categorized as Upper Respiratory' tab) were identified, and", d, "exposure-outcome pairs were extracted.")
    paste("Of the", s, "studies reporting upper airway outcomes,", w,"exposure-outcome pairs were extracted. Of these,", a, "pairs were evaluated with Question 1,", b, "pairs with Question 2,", c, "pairs with Question 3,", d, "pairs with Question 4,", e, "pairs pairs with Question 5,", f, "pairs with Question 6,", g, "pairs with Question 7,", h, "pairs with Question 8,", i, "pairs with Question 9, and", j, "pairs with Question 10.")
    
  })
  
  
####### TExt for lower respiratory RofB section
  
  output$lower_rob_text <- renderText({ 
    lower_rob_1 <- ROB_joint_tl %>% filter(category== 'Lower Respiratory')
    
    a = length(which(lower_rob_1$`Question 1` != "NA"))
    b = length(which(lower_rob_1$`Question 2` != "NA"))
    c = length(which(lower_rob_1$`Question 3` != "NA"))
    d = length(which(lower_rob_1$`Question 4` != "NA"))
    e = length(which(lower_rob_1$`Question 5` != "NA"))
    f = length(which(lower_rob_1$`Question 6` != "NA"))
    g = length(which(lower_rob_1$`Question 7` != "NA"))
    h = length(which(lower_rob_1$`Question 8` != "NA"))
    i = length(which(lower_rob_1$`Question 9` != "NA"))
    j = length(which(lower_rob_1$`Question 10` != "NA"))
    
    
    #sat1 <- forest_cross %>% filter(category=="Upper Respiratory")%>%
    #  group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    #  sat2 <- forest_cohort %>% filter(category=="Upper Respiratory")%>%
    #   group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    # sat3 <- forest_case %>% filter(category=="Upper Respiratory")%>%
    #    group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    
    # forest_joint_up <-  bind_rows(sat1,sat2,sat3)
    
    
    
    timedata2 <- cafo_map1  %>% filter(LR=="Yes")  
    w = nrow ((lower_rob_1))
    s = nrow ((timedata2))
    #u = nrow ((forest_joint_up))
    
    #paste("Of the", s,"studies reporting upper respiratory outcomes,", u, " conditions (listed in the 'Outcomes Categorized as Upper Respiratory' tab) were identified, and", d, "exposure-outcome pairs were extracted.")
    paste("Of the", s, "studies reporting lower airway outcomes,", w,"exposure-outcome pairs were extracted. Of these,", a, "pairs were evaluated with Question 1,", b, "pairs with Question 2,", c, "pairs with Question 3,", d, "pairs with Question 4,", e, "pairs pairs with Question 5,", f, "pairs with Question 6,", g, "pairs with Question 7,", h, "pairs with Question 8,", i, "pairs with Question 9, and", j, "pairs with Question 10.")
    
  })
  
  
   
  ## flow chart ####
  ## * intro #####
  output$flow_intro_text <- renderUI({
    switch(
      input$flow_btn,
      "sp" = p(br(),"The flow diagram depicts the flow of information through the different phases of a systematic review. It maps out the number of records identified, included and excluded."),
      "ts" = p(br(),"This timeline shows the number of new searches, when a revision update was made and the number of new records added to the body of work.", br())
      
    )
  })
  
  
  
  
  ## lower respiratory ####
  ## * intro #####
  output$low_res_intro_text <- renderUI({
    switch(
      input$low_res_btn,
      "sp" = p(br(),"Articles related to lower respiratory disease were published in Germany, United States and Netherlands."),
      "ts" = p(br(),"This timeline shows the date of publication of references in which outcome related to lower respiratory tract were studied."),
      "coef" = p(br(),"The following table shows all the outcomes that were categorized as lower respiratory tract.")
    )
  })
  
  #####copying for upper
  
  output$up_res_intro_text <- renderUI({
    switch(
      input$up_res_btn,
      "sp" = p(br(),"Most articles related to upper respiratory disease were published in United States, Netherlands and Germany."),
      "ts" = p(br(),"This timeline shows the date of publication of references in which outcome related to upper respiratory tract were studied."),
      "coef" = p(br(),"The following table shows all the outcomes that were categorized as upper respiratory tract.")
    )
  })
  
  #####copying for AMR
  output$ar_res_intro_text <- renderUI({
    switch(
      input$ar_res_btn,
      "sp" = p(br(),"Most articles related to Antimicrobial resistance were published in United States and Netherlands"),
      "ts" = p(br(),"This timeline shows the date of publication of references in which outcome related to Antimicrobial resistance were studied. "),
      "coef" = p(br(),"The following table shows all the outcomes that were categorized as Antimicrobial resistance outcomes.")
    )
  })
  
  #####copying for Infectious conditions
  output$ic_res_intro_text <- renderUI({
    switch(
      input$ic_res_btn,
      "sp" = p(br(),"Most articles related to Infectious conditions were published in Mexico and Netherlands"),
      "ts" = p(br(),"This timeline shows the date of publication of references in which outcome related to Infectious conditions were studied. "),
      "coef" = p(br(),"The following table shows all the outcomes that were categorized as Infectious condition outcomes.")
    )
  })
  
  #####copying for GI
  
  output$gi_res_intro_text <- renderUI({
    switch(
      input$gi_res_btn,
      "sp" = p(br(),"Articles related to Gastrointestinal diseases were published in United States, the Netherlands and Canada."),
      "ts" = p(br(),"This timeline shows the date of publication of references in which outcome related to gastrointestinal tract were studied."),
      "coef" = p(br(),"The following table shows all the outcomes that were categorized as gastrointestinal conditions.")
    )
  })
  
  #### Flow chart
  
  output$flow_intro_plot <- renderUI({
    switch(
      input$flow_btn,
      "sp" = fluidRow(
        #column(width = 12, DiagrammeR::grVizOutput(outputId = "plot1", width = "90%", height = "750px") %>% withSpinner())),
        column(width = 12, downloadButton("download_prisma", "Download PRISMA (PNG)"), DiagrammeR::grVizOutput(outputId = "prisma", width = "75%", height = "750px") %>% withSpinner())),
        "ts" = timevisOutput("timeline_news"),
      #"coef" = plotlyOutput("measure_all_low_res") %>% withSpinner()
      
    )
  })
  
  
  
  output$low_res_intro_plot <- renderUI({
    switch(
      input$low_res_btn,
      "sp" = fluidRow(
        column(width = 6, leafletOutput("map_low_res") %>% withSpinner()),
        column(width = 6, plotlyOutput("geobar_low_res") %>% withSpinner())),
      "ts" = timevisOutput("timeline_low_res"),
      #"coef" = plotlyOutput("measure_all_low_res") %>% withSpinner()
      "coef" = dataTableOutput("measure_all_low_res") %>% withSpinner()
    )
  })
  
  #######copying for uppper
  
  output$up_res_intro_plot <- renderUI({
    switch(
      input$up_res_btn,
      "sp" = fluidRow(
        column(width = 6, leafletOutput("map_up_res") %>% withSpinner()) ,
        column(width = 6, plotlyOutput("geobar_up_res") %>% withSpinner())),
      "ts" = timevisOutput("timeline_up_res"),
      #"coef" = plotlyOutput("measure_all_low_res") %>% withSpinner()
      "coef" = dataTableOutput("measure_all_up_res") %>% withSpinner()
    )
  })
  
  #######copying for AMR
  
  output$ar_res_intro_plot <- renderUI({
    switch(
      input$ar_res_btn,
      "sp" = fluidRow(
        column(width = 6, leafletOutput("map_ar_res") %>% withSpinner()) ,
        column(width = 6, plotlyOutput("geobar_ar_res") %>% withSpinner())),
      "ts" = timevisOutput("timeline_ar_res"),
      #"coef" = plotlyOutput("measure_all_low_res") %>% withSpinner()
      "coef" = dataTableOutput("measure_all_ar_res") %>% withSpinner()
    )
  })
  
  ####### Infectious conditions
  
  
  
  output$ic_res_intro_plot <- renderUI({
    switch(
      input$ic_res_btn,
      "sp" = fluidRow(
        column(width = 6, leafletOutput("map_ic_res") %>% withSpinner()) ,
        column(width = 6, plotlyOutput("geobar_ic_res") %>% withSpinner())),
      "ts" = timevisOutput("timeline_ic_res"),
      #"coef" = plotlyOutput("measure_all_low_res") %>% withSpinner()
      "coef" = dataTableOutput("measure_all_ic_res") %>% withSpinner()
    )
  })
  
  #######copying for GI
  
  output$gi_res_intro_plot <- renderUI({
    switch(
      input$gi_res_btn,
      "sp" = fluidRow(
        column(width = 6, leafletOutput("map_gi_res") %>% withSpinner()) ,
        column(width = 6, plotlyOutput("geobar_gi_res") %>% withSpinner())),
      "ts" = timevisOutput("timeline_gi_res"),
      #"coef" = plotlyOutput("measure_all_low_res") %>% withSpinner()
      "coef" = dataTableOutput("measure_all_gi_res") %>% withSpinner()
    )
  })
  
  
  
  ## ** geographic distribution ####
  output$map_low_res <- renderLeaflet({
    
    subset_low <- cafo_map1 %>% filter(LR == "Yes")
    
    # Create a grouped data frame with concatenated weblinks for each country
    grouped_df_lr <- subset_low %>%
      group_by(Country) %>%
      summarise(
        weblinks = paste(weblink, collapse = "<br>"),  # Concatenate weblinks for each country
        .groups = 'drop'
      )
    
    # Join the grouped_df_lr back to subset_low to ensure each location has the correct weblinks
    subset_low <- subset_low %>%
      left_join(grouped_df_lr, by = "Country")
    
    # Render the leaflet map
    leaflet(subset_low) %>% 
      addProviderTiles(providers$Esri,
                       options = providerTileOptions(noWrap = TRUE)) %>%  
      setView(-40.679728, 34.738366, zoom = 2) %>%  # Set/fix the view of the map 
      addCircleMarkers(lng = ~long, lat = ~lat,
                       popup = ~paste("<b>Country:</b> ", Country, "<br>", weblinks)
      )
  })
  
  
  output$map <- renderLeaflet({
    # Process cafo_map to include weblinks
    
    
    ## * geographic distribution ####
    # Create the map
    leaflet(cafoo_map) %>% 
      addProviderTiles(providers$Esri,
                       options = providerTileOptions(noWrap = TRUE)) %>%  
      setView(-40.679728, 34.738366, zoom = 2) %>%  ## Set/fix the view of the map 
      addCircleMarkers(lng = ~long, lat = ~lat,
                       radius = 5, # Adjust the radius as needed
                       popup = ~paste("<b>Country:</b> ", Country, "<br>", grouped_df$weblinks)
      )
  })
  
  #####copying for upper
  
  output$map_up_res <- renderLeaflet({
    
    subset_ur <- cafo_map1%>% filter(UR=="Yes")

    # Create a grouped data frame with concatenated weblinks for each country
    grouped_df_ur <- subset_ur %>%
      group_by(Country) %>%
      summarise(
        weblinks = paste(weblink, collapse = "<br>"),  # Concatenate weblinks for each country
        .groups = 'drop'
      )
    
    # Join the grouped_df_lr back to subset_low to ensure each location has the correct weblinks
    subset_ur <- subset_ur %>%
      left_join(grouped_df_ur, by = "Country")
    
    leaflet(subset_ur) %>% 
      addProviderTiles(providers$Esri,
                       options = providerTileOptions(noWrap = TRUE)) %>%  
      setView(-40.679728, 34.738366, zoom = 2) %>%  ## Set/fix the view of the map 
      addCircleMarkers(lng = ~long, lat = ~lat,
                 #radius = log(cafoo$`Number of Studies`)*8,
                 popup =  ~paste("<b>Country:</b> ", Country, "<br>",weblinks )
                 )
  })
  
  #####copying for AMR
  
  output$map_ar_res <- renderLeaflet({
    
    subset_ar <- cafo_map1%>% filter(Antimicro=="Yes")
    
    # Create a grouped data frame with concatenated weblinks for each country
    grouped_df_ar <- subset_ar %>%
      group_by(Country) %>%
      summarise(
        weblinks = paste(weblink, collapse = "<br>"),  # Concatenate weblinks for each country
        .groups = 'drop'
      )
   
    # Join the grouped_df_lr back to subset_low to ensure each location has the correct weblinks
    subset_ar <- subset_ar %>%
      left_join(grouped_df_ar, by = "Country") 
    
    leaflet(subset_ar) %>% 
      addProviderTiles(providers$Esri,
                       options = providerTileOptions(noWrap = TRUE)) %>%  
      setView(-40.679728, 34.738366, zoom = 2) %>%  ## Set/fix the view of the map 
      addCircleMarkers(lng = ~long, lat = ~lat,
                 #radius = log(cafoo$`Number of Studies`)*8,
                 popup =  ~paste("<b>Country:</b> ", Country, "<br>",weblinks )
      )
  })
  
  ##### Infectious conditions
  
  output$map_ic_res <- renderLeaflet({
    
    

    subset_inf <- cafo_map1 %>% filter(Infectious=="Yes")
    
    # Create a grouped data frame with concatenated weblinks for each country
    grouped_df_inf <- subset_inf %>%
      group_by(Country) %>%
      summarise(
        weblinks = paste(weblink, collapse = "<br>"),  # Concatenate weblinks for each country
        .groups = 'drop'
      )
    
    # Join the grouped_df_lr back to subset_low to ensure each location has the correct weblinks
    subset_inf <- subset_inf %>%
      left_join(grouped_df_inf, by = "Country")  
    
    leaflet(subset_inf) %>% 
      addProviderTiles(providers$Esri,
                       options = providerTileOptions(noWrap = TRUE)) %>%  
      setView(-40.679728, 34.738366, zoom = 2) %>%  ## Set/fix the view of the map 
      addCircleMarkers(lng = ~long, lat = ~lat,
                 #radius = log(cafoo$`Number of Studies`)*8,
                 popup =  ~paste("<b>Country:</b> ", Country, "<br>", weblinks )
      )
  })
  
  ####copying for GI
  
  output$map_gi_res <- renderLeaflet({
    

    subset_gi <- cafo_map1 %>% filter(Gastro=="Yes")
    
    # Create a grouped data frame with concatenated weblinks for each country
    grouped_df_gi <- subset_gi %>%
      group_by(Country) %>%
      summarise(
        weblinks = paste(weblink, collapse = "<br>"),  # Concatenate weblinks for each country
        .groups = 'drop'
      )
    
    # Join the grouped_df_lr back to subset_low to ensure each location has the correct weblinks
    subset_gi <- subset_gi %>%
      left_join(grouped_df_gi, by = "Country")   
    
    leaflet(subset_gi) %>% 
      addProviderTiles(providers$Esri,
                       options = providerTileOptions(noWrap = TRUE)) %>%  
      setView(-40.679728, 34.738366, zoom = 2) %>%  ## Set/fix the view of the map 
      addCircleMarkers(lng = ~long, lat = ~lat,
                 #radius = log(cafoo$`Number of Studies`)*8,
                 popup =  ~paste("<b>Country:</b> ", Country, "<br>", weblinks )
      )
  })
  
  ####copying for Neurologic
  
  
  
  #  output$geobar_low_res <- renderPlotly({
  #    gg <- cafo2 %>% filter(Refid %in% selected_id()) %>% distinct() %>%
  #      group_by(Country) %>% summarise(Count = n()) %>%
  #      mutate(Country = forcats::fct_reorder(factor(Country), Count)) %>%
  #      ggplot(aes(x = Country, y = Count)) +
  #      geom_bar(aes(fill = Country), stat = "identity") +
  #      scale_fill_brewer(palette = "Set2")
  #    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
  #  })
  
  #######
  output$geobar_low_res <- renderPlotly({
    gg <- cafo_map1 %>% filter(LR=="Yes")%>%
      #distinct()%>% group_by(country) %>% summarise(Count = n())%>%
      ggplot(aes(x = Country)) +
      geom_bar(aes(fill = Country)) +
      scale_fill_brewer(palette = "Set2")+labs(x = "Country", y = "Number of Studies")+theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
  })
  
  ########copying for up
  
  output$geobar_up_res <- renderPlotly({
    gg <- cafo_map1 %>% filter(UR=="Yes")%>%
      #distinct()%>% group_by(country) %>% summarise(Count = n())%>%
      ggplot(aes(x = Country)) +
      geom_bar(aes(fill = Country)) +
      scale_fill_brewer(palette = "Set2")+labs(x = "Country", y = "Number of Studies")+theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
  })
  
  ########copying for AMR
  
  output$geobar_ar_res <- renderPlotly({
    gg <- cafo_map1 %>% filter(Antimicro=="Yes")%>%
      #distinct()%>% group_by(country) %>% summarise(Count = n())%>%
      ggplot(aes(x = Country)) +
      geom_bar(aes(fill = Country)) +
      scale_fill_brewer(palette = "Set2")+labs(x = "Country", y = "Number of Studies")+theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
  })
  
  ########copying for Infectious
  
  output$geobar_ic_res <- renderPlotly({
    gg <- cafo_map1 %>% filter(Infectious=="Yes")%>%
      #distinct()%>% group_by(country) %>% summarise(Count = n())%>%
      ggplot(aes(x = Country)) +
      geom_bar(aes(fill = Country)) +
      scale_fill_brewer(palette = "Set2")+labs(x = "Country", y = "Number of Studies")+theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
  })
  
  ########copying for GI
  
  output$geobar_gi_res <- renderPlotly({
    gg <- cafo_map1 %>% filter(Gastro=="Yes")%>%
      #distinct()%>% group_by(country) %>% summarise(Count = n())%>%
      ggplot(aes(x = Country)) +
      geom_bar(aes(fill = Country)) +
      scale_fill_brewer(palette = "Set2")+labs(x = "Country", y = "Number of Studies")+theme(axis.text.x = element_text(angle = 45, vjust = 0.5, hjust=1))
    ggplotly(gg, tooltip = c("x", "y")) %>% layout(showlegend = FALSE)
  })
  
  ########copying for Neurologic
  
  
  ## ** timeline ####
  output$timeline_low_res <- renderTimevis({
    
    # Convert Year column to a valid date format (e.g., first day of the year)
    cafo_map1$start_date <- as.Date(paste0(cafo_map1$Year, "-01-01"))
    ## Only select authors and year information columns
    timedata2 <- cafo_map1  %>% filter(LR=="Yes")
    
    
  
    ## Insert into a dataframe 
    datt2 <- data.frame(
      ## make it reactive
      id = 1:nrow(timedata2),   
      content = timedata2$weblink,
      start = timedata2$start_date,
      end = NA
    )
    timevis(datt2, showZoom = F)
  })
  

  ## ** Timeline for new studies ####
 
  output$timeline_news <- renderTimevis({
    
    # Prepare the data for the timeline
    newrecords <- data.frame(
      id = 1:nrow(timelineV02),
      content = paste("Relevant records:", timelineV02$New_Records),  # Dynamic content based on New_Records
      start = as.character(timelineV02$date),  # Convert dates to character
      end = rep(NA, nrow(timelineV02))  # Keep end dates as NA
    )
    
    # Create the timeline
    timevis(newrecords, showZoom = FALSE)
  })

  
  
  #######copying for up
  
  output$timeline_up_res <- renderTimevis({
    # Convert Year column to a valid date format (e.g., first day of the year)
    cafo_map1$start_date <- as.Date(paste0(cafo_map1$Year, "-01-01"))
    ## Only select authors and year information columns
    timedata2 <- cafo_map1  %>% filter(UR=="Yes") 
    ## Insert into a dataframe 
    datt2 <- data.frame(
      ## make it reactive
      id = 1:nrow(timedata2),   
      content = timedata2$weblink,
      start = timedata2$start_date,
      end = NA
    )
    timevis(datt2, showZoom = F)
  })
  
  #######copying for AMR
  
  output$timeline_ar_res <- renderTimevis({
    # Convert Year column to a valid date format (e.g., first day of the year)
    cafo_map1$start_date <- as.Date(paste0(cafo_map1$Year, "-01-01"))
    ## Only select authors and year information columns
    timedata2 <- cafo_map1  %>% filter(Antimicro=="Yes")  
    ## Insert into a dataframe 
    datt2 <- data.frame(
      ## make it reactive
      id = 1:nrow(timedata2),   
      content = timedata2$weblink,
      start = timedata2$start_date,
      end = NA
    )
    timevis(datt2, showZoom = F)
  })
  
  ##### copying for GI
  
  output$timeline_gi_res <- renderTimevis({
    # Convert Year column to a valid date format (e.g., first day of the year)
    cafo_map1$start_date <- as.Date(paste0(cafo_map1$Year, "-01-01"))
    ## Only select authors and year information columns
    timedata2 <- cafo_map1  %>% filter(Gastro=="Yes") 
    ## Insert into a dataframe 
    datt2 <- data.frame(
      ## make it reactive
      id = 1:nrow(timedata2),   
      content = timedata2$weblink,
      start = timedata2$start_date,
      end = NA
    )
    timevis(datt2, showZoom = F)
  })
  
  #######copying for Infectious
  output$timeline_ic_res <- renderTimevis({
    # Convert Year column to a valid date format (e.g., first day of the year)
    cafo_map1$start_date <- as.Date(paste0(cafo_map1$Year, "-01-01"))
    ## Only select authors and year information columns
    timedata2 <- cafo_map1  %>% filter(Infectious=="Yes") 
    ## Insert into a dataframe 
    datt2 <- data.frame(
      ## make it reactive
      id = 1:nrow(timedata2),   
      content = timedata2$weblink,
      start = timedata2$start_date,
      end = NA
    )
    timevis(datt2, showZoom = F)
  })
  
  
  
  ##### table outcomes Lower R
  
  output$measure_all_low_res <- DT::renderDataTable({
   # sat <- dataset %>% filter(Categorized.class==selected_class())%>%
  #    group_by(Categorized.class, Outcome.variable) %>%summarise(Frequency = length(Outcome.variable))
   # names(sat)[1] <- "Outcome category"
  #  names(sat)[2] <- "Outcome variable analyzed"
   # names(sat)[3] <- "Number of times the variable was analyzed"
    
  #  DT::datatable(sat, rownames = FALSE,escape = FALSE, options = list(ordering=F, bFilter=T, pageLength = 50))
  #####
    sat1 <- forest_cross %>% filter(category=="Lower Respiratory")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat2 <- forest_cohort %>% filter(category=="Lower Respiratory")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat3 <- forest_case %>% filter(category=="Lower respiratory")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    
      forest_joint_low <-  bind_rows(sat1,sat2,sat3)  
      sat4 <-  forest_joint_low %>% group_by(category, outcome) %>%summarise(Frequency = length(outcome))
      sat5 <- sat4 %>% select(category, outcome)  
      
      names(sat5)[1] <- "Outcome category"
      names(sat5)[2] <- "Outcome assessed"
    
      DT::datatable(sat5, rownames = FALSE,escape = FALSE, options = list(autoWidth = TRUE, ordering=F, bFilter=T, pageLength = 50, columnDefs = list(list(className = 'dt-center', targets = "_all")))) 
  })
  
  #######copying for up
  
  output$measure_all_up_res <- DT::renderDataTable({
    sat1 <- forest_cross %>% filter(category=="Upper Respiratory")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat2 <- forest_cohort %>% filter(category=="Upper Respiratory")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat3 <- forest_case %>% filter(category=="Upper Respiratory")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    
    forest_joint_low <-  bind_rows(sat1,sat2,sat3)  
    sat4 <-  forest_joint_low %>% group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    sat5 <- sat4 %>% select(category, outcome)  
    
    names(sat5)[1] <- "Outcome category"
    names(sat5)[2] <- "Variables analyzed in the studies"
    
    DT::datatable(sat5, rownames = FALSE,escape = FALSE, options = list(ordering=F, bFilter=T, pageLength = 50, columnDefs = list(list(className = 'dt-center', targets = "_all")))) 
    })
  
  #######copying for AMR
  
  output$measure_all_ar_res <- DT::renderDataTable({
    sat1 <- forest_cross %>% filter(category=="Antimicrobial resistance")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat2 <- forest_cohort %>% filter(category=="Antimicrobial resistance")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat3 <- forest_case %>% filter(category=="Antimicrobial resistance")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    
    forest_joint_low <-  bind_rows(sat1,sat2,sat3)  
    sat4 <-  forest_joint_low %>% group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    sat5 <- sat4 %>% select(category, outcome)  
    
    names(sat5)[1] <- "Outcome category"
    names(sat5)[2] <- "Variables analyzed in the studies"
    
    DT::datatable(sat5, rownames = FALSE,escape = FALSE, options = list(ordering=F, bFilter=T, pageLength = 50, columnDefs = list(list(className = 'dt-center', targets = "_all")))) 
  })
  
  ########### for IC
  output$measure_all_ic_res <- DT::renderDataTable({
    sat1 <- forest_cross %>% filter(category=="Infectious conditions")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat2 <- forest_cohort %>% filter(category=="Infectious conditions")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat3 <- forest_case %>% filter(category=="Infectious conditions")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    
    forest_joint_low <-  bind_rows(sat1,sat2,sat3)  
    sat4 <-  forest_joint_low %>% group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    sat5 <- sat4 %>% select(category, outcome)  
    
    names(sat5)[1] <- "Outcome category"
    names(sat5)[2] <- "Variables analyzed in the studies"
    
    DT::datatable(sat5, rownames = FALSE,escape = FALSE, options = list(ordering=F, bFilter=T, pageLength = 50, columnDefs = list(list(className = 'dt-center', targets = "_all")))) 
  })
  
  
  
  
  #######copying for GI
  
  output$measure_all_gi_res <- DT::renderDataTable({
    sat1 <- forest_cross %>% filter(category=="Gastrointestinal condition")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat2 <- forest_cohort %>% filter(category=="Gastrointestinal condition")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    sat3 <- forest_case %>% filter(category=="Gastrointestinal condition")%>%
      group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    
    
    forest_joint_low <-  bind_rows(sat1,sat2,sat3)  
    sat4 <-  forest_joint_low %>% group_by(category, outcome) %>%summarise(Frequency = length(outcome))
    sat5 <- sat4 %>% select(category, outcome)  
    
    names(sat5)[1] <- "Outcome category"
    names(sat5)[2] <- "Variables analyzed in the studies"
    
    DT::datatable(sat5, rownames = FALSE,escape = FALSE, options = list(ordering=F, bFilter=T, pageLength = 50, columnDefs = list(list(className = 'dt-center', targets = "_all")))) 
    
  })
  
  #######copying for Neurologic
  
  
  
  ## ** outcome ####
  # output$measure_all_low_res <- renderPlotly({
  # browser()
  #   gg_low_res <- dataset %>%
  #    filter(`Categorized.class` == selected_class()) %>% 
  #   ggplot(aes(x = paperInfo)) +
  #     geom_bar(aes(fill = Outcome.variable)) + coord_flip() +
  #     scale_fill_brewer(palette = "Set3") +
  #     labs(x = "", fill = "Health Outcome Group") +
  #    xlab("Study") +
  #     ylab("Number of Reported Outcomes") + 
  #     theme(plot.background = element_rect(fill = "#BFD5E3"),
  #          panel.background = element_rect(fill = "white"),
  #          axis.line.x = element_line(color = "grey"))
  #  ggplotly(gg_low_res) %>% layout(showlegend = FALSE)
  # })
  
  
  #####################
  ## * forest plot ####
  #####################
  selected_state_low <- reactive({
    input$plot_low_selected
  })
  
  ##### For Upper
  
  selected_state_up <- reactive({
    input$plot_up_selected
  })
  
  ##### For AR
  
  selected_state_ar <- reactive({
    input$plot_ar_selected
  })
  
  
  selected_state_ic <- reactive({
    input$plot_ic_selected
  })
  
  ##### For Gastro
  
  selected_state_gi <- reactive({
    input$plot_gi_selected
  })
  
  ##### For Neuro
  
  
  
  #####
  
  forest_data <- reactive({
    
    forest_data <- forest %>% filter(
      effect_z == input$expo_b &  t_expo == input$expo_c)
  })
  
  
  #output$low_rsp_dt <- DT::renderDataTable({
  #  forest_data()
  #newdatas <- forest_data()[c(1,2)]
  #})
  
  output$out1 <- renderInfoBox({
    infoBox("How to use a forest plot",  
            a("Click here to go to the tutorial", onclick = "openTab('tutorial')", href="#", style = "font-size: 90%;"),
            icon = icon("chalkboard-teacher"), color = "blue"
    )
  }) 
  #### for Upper R 
 # output$out12 <- renderInfoBox({
#    infoBox("How to use a forest plot",  
#            a("Click here to go to the tutorial", onclick = "openTab('tutorial')", href="#", style = "font-size: 90%;"),
#            icon = icon("chalkboard-teacher"), color = "blue"
#    )
#  })
  
  #### for AR 
#  output$out12_ar <- renderInfoBox({
#    infoBox("How to use a forest plot",  
#            a("Click here to go to the tutorial", onclick = "openTab('tutorial')", href="#", style = "font-size: 90%;"),
#            icon = icon("chalkboard-teacher"), color = "blue"
#    )
#  })
  
  #### for GI 
#  output$out12_gi <- renderInfoBox({
#    infoBox("How to use a forest plot",  
#            a("Click here to go to the tutorial", onclick = "openTab('tutorial')", href="#", style = "font-size: 90%;"),
#            icon = icon("chalkboard-teacher"), color = "blue"
#    )
#  })
  
  #### for Neuro 
  output$out12_Neur <- renderInfoBox({
    infoBox("How to use a forest plot",  
            a("Click here to go to the tutorial", onclick = "openTab('tutorial')", href="#", style = "font-size: 90%;"),
            icon = icon("chalkboard-teacher"), color = "blue"
    )
  })
  
  
  ##### For Lower R

   forest_data_low <- reactive({
    
    forest_data_low <- low_forest %>% filter(
      authors %in%  input$expo_b_low_susi , Country %in% input$expo_b_low_susi_country , Outcome.variable %in% input$expo_b_low_outcome , Exposure.measure %in% input$expo_b_low_exposure)
  
  })
  
  output$plot_low <- renderGirafe({
    low_forest <- forest_data_low() %>% filter(effect_z == input$expo_b_low )
    g <- nrow(low_forest)
    low_forest[g+1,]<- NA
    low_forest <-  low_forest%>% mutate(id2 = c(1:(g+1)))
    
    #up_forest[g+1,3] <- "OUTCOME"
    low_forest[g+1,15] <- "EXPOSURE"
    low_forest[g+1,17] <- "SUBCATEGORY"
    #low_forest[g+1,15] <- "POINT ESTIMATE(95% CI)"
    low_forest[g+1,4] <- "CATEGORY"
    low_forest[g+1,13] <- "OUTCOME"
    low_forest[g+1,11] <- "STUDY"
    
    
    
    validate(
      need(low_forest$Outcome.variable!= "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    

    fonseca <- ggplot(low_forest,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      #geom_errorbarh(aes(xmax = upperci, xmin = lowerci), height = 0.15) +
      geom_errorbarh(aes(xmax = ifelse(upperci>6, 6, upperci),  xmin = lowerci), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(low_forest$yi),max(low_forest$yi)))+
      #scale_y_continuous(limits = c(5, nrow(low_forest)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
     
      #scale_x_continuous(breaks = seq(-3,10,1))+
      #scale_y_continuous(breaks = seq(1,g,3)) +
      
      scale_y_discrete('id2')+
      scale_x_continuous( if (input$expo_b_low == "Incidence Odds Ratio (OR)") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_low == "Incidence Density Ratio (IDR)"){name = "Prevalence ratio (95% CI)"},
                          limits=c(0, 6)
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            axis.text.x = element_text(size = 20),
            axis.title.x = element_text(size = 20),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            legend.position = "none"
      )
    
    
    
    
    fonseca3 <- ggplot(data = low_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      scale_y_discrete('id2')+
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    low_forest[g+1,19] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca2 <- ggplot(data = low_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      
      geom_text_interactive(aes(x = 1, label = shortsubcat , tooltip = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 1.5, label = inter_95), size= 5.1,hjust = 0)+
      geom_text(aes(x = 2.2,label = authors),size= 5.1,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      scale_y_discrete('id2')+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    
    high1 <- nrow(low_forest)/2
    
    girafe( code = print(fonseca3 + fonseca + fonseca2), width_svg = 25, height_svg = high1,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            )
            
    )
    
    
  })   
  
  
  
  
  ##### For Upper R
  forest_data_up <- reactive({
    
    forest_data_up <- up_forest %>% filter(
      authors %in%  input$expo_b_up_susi , Country %in% input$expo_b_up_susi_country , Outcome.variable %in% input$expo_b_up_outcome , Exposure.measure %in% input$expo_b_up_exposure )
  })
  
  output$plot_up <- renderGirafe({
    up_forest <- forest_data_up() %>% filter(effect_z == input$expo_b_up)
    
    validate(
  
        need(up_forest$Outcome.variable!= "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    
    
    
    g <- nrow(up_forest)
    up_forest[g+1,]<- NA
    up_forest <-  up_forest%>% mutate(id2 = c(1:(g+1)))
    
    up_forest[g+1,13] <- "OUTCOME"
    up_forest[g+1,15] <- "EXPOSURE"
    up_forest[g+1,17] <- "SUBCATEGORY"
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    #up_forest_state1[g+1,4] <- "CATEGORY"
    up_forest[g+1,11] <- "STUDY"
    
    
    
    
    
    
    
    
    ###
    #g <- nrow(up_forest)
    #up_forest[gunter+1,]<- NA
    
    #up_forest$id2 <- c(1:(g+1))
    #up_forest$id2 <- seq(1,(g+1))
    
    #up_forest[nrow(up_forest)+1,]<- "NEA"
    ##
    
    
    
    
    ###
    #up_forest[nrow(up_forest),3] <- "OutcomeNEA"
    
    ##
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca <- ggplot(up_forest,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      geom_errorbarh(aes(xmax = ifelse(upperci>7, 7, upperci), xmin = lowerci), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(up_forest$lowerci),max(up_forest$upperci)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
      #scale_x_continuous(breaks = seq(-3,10,1))+
      scale_y_discrete('id2')+
      scale_x_continuous( if (input$expo_b_up == "Incidence Odds Ratio (OR)") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_up == "Incidence Density Ratio (IDR)"){name = "Prevalence ratio (95% CI)"}
                          
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            
            legend.position = "none"
      )
    
    
    
    
    fonseca3 <- ggplot(data = up_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      scale_y_discrete('id2')+
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    up_forest[g+1,19] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca2 <- ggplot(data = up_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      
      geom_text_interactive(aes(x = 1, label = shortsubcat , tooltip = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 1.5, label = inter_95), size= 5.1,hjust = 0)+
      geom_text(aes(x = 2.2,label = authors),size= 5.1,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      scale_y_discrete('id2')+
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    #high1 <- nrow(up_forest)/2
    
    high2 <- nrow(up_forest)/2
    
    girafe( code = print(fonseca3 + fonseca + fonseca2), width_svg = 25, height_svg = high2,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            ))
    
    
  })   
  ############ AR
  
  
  forest_data_ar <- reactive({
    
    forest_data_ar <- ar_forest %>% filter(
       authors %in%  input$expo_b_ar_susi & Country %in% input$expo_b_ar_susi_country & Outcome.variable %in% input$expo_b_ar_outcome & Exposure.measure %in% input$expo_b_ar_exposure)
    
    
  })
  
  output$plot_ar <- renderGirafe({
    ar_forest <- forest_data_ar() %>% filter(effect_z == input$expo_b_ar )
    g <- nrow(ar_forest)
    ar_forest[g+1,]<- NA
    ar_forest <-  ar_forest%>% mutate(id2 = c(1:(g+1)))
    
    ar_forest[g+1,13] <- "OUTCOME"
    ar_forest[g+1,15] <- "EXPOSURE"
    ar_forest[g+1,17] <- "SUBCATEGORY"
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    #up_forest_state1[g+1,4] <- "CATEGORY"
    ar_forest[g+1,11] <- "STUDY"
    
    
    
    
    validate(
      need(ar_forest$Outcome.variable!= "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    
    
    ###
    #g <- nrow(up_forest)
    #up_forest[gunter+1,]<- NA
    
    #up_forest$id2 <- c(1:(g+1))
    #up_forest$id2 <- seq(1,(g+1))
    
    #up_forest[nrow(up_forest)+1,]<- "NEA"
    ##
    
    
    
    
    ###
    #up_forest[nrow(up_forest),3] <- "OutcomeNEA"
    
    ##
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca <- ggplot(ar_forest,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      geom_errorbarh(aes(xmax = ifelse(upperci>7, 7, upperci), xmin = lowerci), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(ar_forest$yi),max(ar_forest$yi)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
      #scale_x_continuous(breaks = seq(-3,10,1))+
      scale_y_continuous(breaks = seq(1,g,3)) +
      scale_x_continuous( if (input$expo_b_ar == "Incidence Odds Ratio (OR)") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_ar == "Incidence Density Ratio (IDR)"){name = "Prevalence ratio (95% CI)"}
                          
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            
            legend.position = "none"
      )
    
    
    
    
    fonseca3 <- ggplot(data = ar_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    ar_forest[g+1,19] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca2 <- ggplot(data = ar_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      
      geom_text_interactive(aes(x = 1, label = shortsubcat , tooltip = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 1.4, label = inter_95), size= 5.1,hjust = 0)+
      geom_text(aes(x = 2.2,label = authors),size= 5.1,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    #high1 <- nrow(up_forest)/2
    
    high5 <- nrow(ar_forest)/2
    
    girafe( code = print(fonseca3 + fonseca + fonseca2), width_svg = 25, height_svg = high5+1.3,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            ))
    
    
  })
  
  
  ############ IC
  
  
  forest_data_ic <- reactive({
    
    forest_data_ic <- ic_forest %>% filter(
      authors %in%  input$expo_b_ic_susi , Country %in% input$expo_b_ic_susi_country , Outcome.variable %in% input$expo_b_ic_outcome , Exposure.measure %in% input$expo_b_ic_exposure)
    
    
  })
  
  output$plot_ic <- renderGirafe({
    ic_forest <- forest_data_ic() %>% filter(effect_z == input$expo_b_ic )
    g <- nrow(ic_forest)
    ic_forest[g+1,]<- NA
    ic_forest <-  ic_forest%>% mutate(id2 = c(1:(g+1)))
    
    ic_forest[g+1,13] <- "OUTCOME"
    ic_forest[g+1,15] <- "EXPOSURE"
    ic_forest[g+1,17] <- "SUBCATEGORY"
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    #up_forest_state1[g+1,4] <- "CATEGORY"
    ic_forest[g+1,11] <- "STUDY"
    
    
    
    
    validate(
      need(ic_forest$Outcome.variable!= "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    
    
    ###
    #g <- nrow(up_forest)
    #up_forest[gunter+1,]<- NA
    
    #up_forest$id2 <- c(1:(g+1))
    #up_forest$id2 <- seq(1,(g+1))
    
    #up_forest[nrow(up_forest)+1,]<- "NEA"
    ##
    
    
    
    
    ###
    #up_forest[nrow(up_forest),3] <- "OutcomeNEA"
    
    ##
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca <- ggplot(ic_forest,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      geom_errorbarh(aes(xmax = ifelse(upperci>7, 7, upperci), xmin = ifelse(lowerci>7, NA, lowerci)), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(ic_forest$yi),max(ic_forest$yi)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
      #scale_x_continuous(breaks = seq(-3,10,1))+
      scale_y_continuous(breaks = seq(1,g,3)) +
      scale_x_continuous( if (input$expo_b_ic == "Incidence Odds Ratio (OR)") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_ic == "Incidence Density Ratio (IDR)"){name = "Prevalence ratio (95% CI)"},
                          limits=c(0, 7)
                          
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            
            legend.position = "none"
      )
    
    
    
    
    fonseca3 <- ggplot(data = ic_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    ic_forest[g+1,19] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca2 <- ggplot(data = ic_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1, label = shortsubcat , tooltip = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 1.5, label = inter_95), size= 5.1,hjust = 0)+
      geom_text(aes(x = 2.2,label = authors),size= 5.1,hjust = 1)+
      
      
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    #high1 <- nrow(up_forest)/2
    
    high12 <- nrow(ic_forest)/2
    
    girafe( code = print(fonseca3 + fonseca + fonseca2), width_svg = 25, height_svg = high12+1.3,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            ))
    
    
  })
  
  
  ##### AR
  
  ##### For GI
  forest_data_gi <- reactive({
    
    forest_data_gi <- gi_forest %>% filter(
      authors %in%  input$expo_b_gi_susi , Country %in% input$expo_b_gi_susi_country , Outcome.variable %in% input$expo_b_gi_outcome , Exposure.measure %in% input$expo_b_gi_exposure)
    
  })
  
  output$plot_gi <- renderGirafe({
    gi_forest <- forest_data_gi() %>% filter(effect_z == input$expo_b_gi )
    g <- nrow(gi_forest)
    gi_forest[g+1,]<- NA
    gi_forest <-  gi_forest%>% mutate(id2 = c(1:(g+1)))
    
    gi_forest[g+1,13] <- "OUTCOME"
    gi_forest[g+1,15] <- "EXPOSURE"
    gi_forest[g+1,17] <- "SUBCATEGORY"
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    #up_forest_state1[g+1,4] <- "CATEGORY"
    gi_forest[g+1,11] <- "STUDY"
    
    
    
    
    validate(
      need(gi_forest$Outcome.variable!= "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    
    
    ###
    #g <- nrow(up_forest)
    #up_forest[gunter+1,]<- NA
    
    #up_forest$id2 <- c(1:(g+1))
    #up_forest$id2 <- seq(1,(g+1))
    
    #up_forest[nrow(up_forest)+1,]<- "NEA"
    ##
    
    
    
    
    ###
    #up_forest[nrow(up_forest),3] <- "OutcomeNEA"
    
    ##
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca <- ggplot(gi_forest,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      geom_errorbarh(aes(xmax = ifelse(upperci>7, 7, upperci), xmin = ifelse(lowerci>7, NA, lowerci)), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(gi_forest$yi),max(gi_forest$yi)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
      #scale_x_continuous(breaks = seq(-3,10,1))+
      scale_y_continuous(breaks = seq(1,g,3)) +
      scale_x_continuous( if (input$expo_b_gi == "Incidence Odds Ratio (OR)") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_gi == "Incidence Density Ratio (IDR)"){name = "Prevalence ratio (95% CI)"},
                          limits=c(0, 7)
                          
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            
            legend.position = "none"
      )
    
    
    
    
    fonseca3 <- ggplot(data = gi_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    gi_forest[g+1,19] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca2 <- ggplot(data = gi_forest, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1, label = shortsubcat , tooltip = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 1.5, label = inter_95), size= 5.1,hjust = 0)+
      geom_text(aes(x = 2.2,label = authors),size= 5.1,hjust = 1)+
      
      
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    #high1 <- nrow(up_forest)/2
    
    high12 <- nrow(gi_forest)/2
    
    girafe( code = print(fonseca3 + fonseca + fonseca2), width_svg = 25, height_svg = high12+1.3,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            ))
    
    
  })
  
  ############For lower states
  ############################################
  ##### For lower R STATES
  forest_data_low_state <- reactive({
    
    forest_data_low_state <- low_forest_state %>% filter(
      authors %in%  input$expo_b_low_state_susi , Country %in% input$expo_b_low_state_susi_country , Outcome.variable %in% input$expo_b_low_state_outcome , Exposure.measure %in% input$expo_b_low_state_exposure )
  })
  
  output$plot_low_state <- renderGirafe({
    up_forest_state1 <- forest_data_low_state() %>% filter(effect_z == input$expo_b_low_state )
    g <- nrow(up_forest_state1)
    up_forest_state1[g+1,]<- NA
    up_forest_state1 <-  up_forest_state1%>% mutate(id2 = c(1:(g+1)))
    
    up_forest_state1[g+1,13] <- "OUTCOME"
    up_forest_state1[g+1,15] <- "SUBCATEGORY"
    up_forest_state1[g+1,17] <- "EXPOSURE"
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    #up_forest_state1[g+1,4] <- "CATEGORY"
    up_forest_state1[g+1,11] <- "STUDY"
    
    ###

    ##
    validate(
      need(up_forest_state1$Outcome.variable != "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    
    
    ###
    #g <- nrow(up_forest)
    #up_forest[gunter+1,]<- NA
    
    #up_forest$id2 <- c(1:(g+1))
    #up_forest$id2 <- seq(1,(g+1))
    
    #up_forest[nrow(up_forest)+1,]<- "NEA"
    ##
    
    
    
    
    ###
    #up_forest[nrow(up_forest),3] <- "OutcomeNEA"
    
    ##
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca_state <- ggplot(up_forest_state1,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      geom_errorbarh(aes(xmax = upperci, xmin = lowerci), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(up_forest_state1$yi),max(up_forest_state1$yi)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
      #scale_x_continuous(breaks = seq(-3,10,1))+
      scale_y_discrete('id2')+
      scale_x_continuous( if (input$expo_b_low_state == "Incidence Odds Ratio (OR)") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_low_state == "Incidence Density Ratio (IDR)"){name = "Prevalence ratio (95% CI)"}
                          
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            
            legend.position = "none"
      )
    
    fonseca3_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      scale_y_discrete('id2')+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    up_forest_state1[g+1,19] <- "POINT ESTIMATE(95% CI)"
    
    fonseca2_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1, label = shortsubcat , tooltip = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 1.4, label = inter_95), size= 5.1,hjust = 0)+
      geom_text(aes(x = 2.2,label = authors),size= 5.1,hjust = 1)+
      
      
      scale_y_discrete('id2')+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    
    high2 <- nrow(up_forest_state1)/2
    
    
    
    girafe( code = print(fonseca3_state + fonseca_state + fonseca2_state), width_svg = 22, height_svg = high2+1.3,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            )
            
    )
    
    
  })
  ##### For Upper R STATES
  forest_data_up_state <- reactive({
    
    forest_data_up_state <- up_forest_state1 %>% filter(
      effect_z_state == input$expo_b_up_state )
  })
  
  output$plot_up_state <- renderGirafe({
    up_forest_state1 <- forest_data_up_state() %>% filter(Categorized.class==selected_class())
    g <- nrow(up_forest_state1)
    up_forest_state1[g+1,]<- NA
    up_forest_state1 <-  up_forest_state1%>% mutate(id2 = c(1:(g+1)))
    
    up_forest_state1[g+1,12] <- "OUTCOME"
    up_forest_state1[g+1,14] <- "EXPOSURE"
    up_forest_state1[g+1,16] <- "SUBCATEGORY"
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    #up_forest_state1[g+1,4] <- "CATEGORY"
    up_forest_state1[g+1,11] <- "STUDY"
    
    
    
    
    validate(
      need(up_forest_state1$Outcome.variable != "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    
    
    
    ###
    #g <- nrow(up_forest)
    #up_forest[gunter+1,]<- NA
    
    #up_forest$id2 <- c(1:(g+1))
    #up_forest$id2 <- seq(1,(g+1))
    
    #up_forest[nrow(up_forest)+1,]<- "NEA"
    ##
    
    
    
    
    ###
    #up_forest[nrow(up_forest),3] <- "OutcomeNEA"
    
    ##
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca_state <- ggplot(up_forest_state1,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      geom_errorbarh(aes(xmax = upperci, xmin = lowerci), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(up_forest_state1$yi),max(up_forest_state1$yi)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
      #scale_x_continuous(breaks = seq(-3,10,1))+
      scale_y_continuous(breaks = seq(1,g,3)) +
      scale_x_continuous( if (input$expo_b_up_state == "OR") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_up_state == "PR"){name = "Prevalence ratio (95% CI)"}
                          
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            
            legend.position = "none"
      )
    
    fonseca3_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    up_forest_state1[g+1,18] <- "POINT ESTIMATE(95% CI)"
    
    fonseca2_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text(aes(x = 1,label = authors),size= 5.1,hjust = 0)+
      geom_text_interactive(aes(x = 1.4, label = shortsubcat , tooltip = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 2.2, label = inter_95), size= 5.1,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    
    high2 <- nrow(up_forest_state1)/2
    
    
    
    girafe( code = print(fonseca3_state + fonseca_state + fonseca2_state), width_svg = 22, height_svg = high2+1.3,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            )
            
    )
    
    
  })
  
  ###### AR for states
  
  forest_data_ar_state <- reactive({
    
    forest_data_ar_state <- up_forest_state1 %>% filter(
      effect_z_state == input$expo_b_ar_state )
  })
  
  output$plot_ar_state <- renderGirafe({
    up_forest_state1 <- forest_data_ar_state() %>% filter(Categorized.class==selected_class())
    g <- nrow(up_forest_state1)
    up_forest_state1[g+1,]<- NA
    up_forest_state1 <-  up_forest_state1%>% mutate(id2 = c(1:(g+1)))
    
    up_forest_state1[g+1,12] <- "OUTCOME"
    up_forest_state1[g+1,14] <- "EXPOSURE"
    up_forest_state1[g+1,7] <- "SUBCATEGORY"
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    #up_forest_state1[g+1,4] <- "CATEGORY"
    up_forest_state1[g+1,11] <- "STUDY"
    
    
    
    
    validate(
      need(up_forest_state1$Outcome.variable != "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    
    
    
    ###
    #g <- nrow(up_forest)
    #up_forest[gunter+1,]<- NA
    
    #up_forest$id2 <- c(1:(g+1))
    #up_forest$id2 <- seq(1,(g+1))
    
    #up_forest[nrow(up_forest)+1,]<- "NEA"
    ##
    
    
    
    
    ###
    #up_forest[nrow(up_forest),3] <- "OutcomeNEA"
    
    ##
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca_state <- ggplot(up_forest_state1,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      geom_errorbarh(aes(xmax = upperci, xmin = lowerci), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(up_forest_state1$yi),max(up_forest_state1$yi)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
      #scale_x_continuous(breaks = seq(-3,10,1))+
      scale_y_continuous(breaks = seq(1,g,3)) +
      scale_x_continuous( if (input$expo_b_up_state == "OR") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_up_state == "PR"){name = "Prevalence ratio (95% CI)"}
                          
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            
            legend.position = "none"
      )
    
    fonseca3_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    up_forest_state1[g+1,16] <- "POINT ESTIMATE(95% CI)"
    
    fonseca2_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text(aes(x = 1,label = authors),size= 5.1,hjust = 0)+
      geom_text(aes(x = 1.4, label = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 2.2, label = inter_95), size= 5.1,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    
    high2 <- nrow(up_forest_state1)/2
    
    
    
    girafe( code = print(fonseca3_state + fonseca_state + fonseca2_state), width_svg = 22, height_svg = high2+1.3,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            )
            
    )
    
    
  })
  
  ###### GI for states
  
  forest_data_gi_state <- reactive({
    
    forest_data_gi_state <- up_forest_state1 %>% filter(
      effect_z_state == input$expo_b_gi_state )
  })
  
  output$plot_gi_state <- renderGirafe({
    up_forest_state1 <- forest_data_gi_state() %>% filter(Categorized.class==selected_class())
    
    
    
    validate(
      need(up_forest_state1$Outcome.variable != "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    
    g <- nrow(up_forest_state1)
    up_forest_state1[g+1,]<- NA
    up_forest_state1 <-  up_forest_state1%>% mutate(id2 = c(1:(g+1)))
    
    up_forest_state1[g+1,12] <- "OUTCOME"
    up_forest_state1[g+1,14] <- "EXPOSURE"
    up_forest_state1[g+1,7] <- "SUBCATEGORY"
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    #up_forest_state1[g+1,4] <- "CATEGORY"
    up_forest_state1[g+1,11] <- "STUDY"
    
    
    
    

    
    
    
    ###
    #g <- nrow(up_forest)
    #up_forest[gunter+1,]<- NA
    
    #up_forest$id2 <- c(1:(g+1))
    #up_forest$id2 <- seq(1,(g+1))
    
    #up_forest[nrow(up_forest)+1,]<- "NEA"
    ##
    
    
    
    
    ###
    #up_forest[nrow(up_forest),3] <- "OutcomeNEA"
    
    ##
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca_state <- ggplot(up_forest_state1,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      geom_errorbarh(aes(xmax = upperci, xmin = lowerci), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(up_forest_state1$yi),max(up_forest_state1$yi)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
      #scale_x_continuous(breaks = seq(-3,10,1))+
      scale_y_discrete('id2')+
      scale_x_continuous( if (input$expo_b_up_state == "OR") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_up_state == "PR"){name = "Prevalence ratio (95% CI)"}
                          
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            
            legend.position = "none"
      )
    
    fonseca3_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      scale_y_discrete('id2')+
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    up_forest_state1[g+1,16] <- "POINT ESTIMATE(95% CI)"
    
    fonseca2_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text(aes(x = 1,label = authors),size= 5.1,hjust = 0)+
      geom_text(aes(x = 1.4, label = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 2.2, label = inter_95), size= 5.1,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      scale_y_discrete('id2')+
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    
    high2 <- nrow(up_forest_state1)/2
    
    
    
    girafe( code = print(fonseca3_state + fonseca_state + fonseca2_state), width_svg = 22, height_svg = high2+1.3,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            )
            
    )
    
    
  })
  
  ###### IC for states
  
  forest_data_ic_state <- reactive({
    
    forest_data_ic_state <- up_forest_state1 %>% filter(
      effect_z_state == input$expo_b_ic_state )
  })
  
  output$plot_ic_state <- renderGirafe({
    up_forest_state1 <- forest_data_ic_state() %>% filter(Categorized.class==selected_class())
    g <- nrow(up_forest_state1)
    up_forest_state1[g+1,]<- NA
    up_forest_state1 <-  up_forest_state1%>% mutate(id2 = c(1:(g+1)))
    
    up_forest_state1[g+1,12] <- "OUTCOME"
    up_forest_state1[g+1,14] <- "EXPOSURE"
    up_forest_state1[g+1,7] <- "SUBCATEGORY"
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    #up_forest_state1[g+1,4] <- "CATEGORY"
    up_forest_state1[g+1,11] <- "STUDY"
    
    
    
    
    validate(
      need(up_forest_state1$Outcome.variable != "", "There are no records for the effect size (ES) and health outcome selected, please make another selection.")
    )
    
    
    
    ###
    #g <- nrow(up_forest)
    #up_forest[gunter+1,]<- NA
    
    #up_forest$id2 <- c(1:(g+1))
    #up_forest$id2 <- seq(1,(g+1))
    
    #up_forest[nrow(up_forest)+1,]<- "NEA"
    ##
    
    
    
    
    ###
    #up_forest[nrow(up_forest),3] <- "OutcomeNEA"
    
    ##
    #up_forest[g+1,6] <- "POINT ESTIMATE(95% CI)"
    
    
    
    fonseca_state <- ggplot(up_forest_state1,aes(yi,id2, col=IDD_2)) + 
      geom_point_interactive(
        aes(data_id = IDD_2, tooltip = yi), size = 7, shape=18
        
      )+
      #geom_point_interactive(size=5, shape=18) +
      geom_errorbarh(aes(xmax = upperci, xmin = lowerci), height = 0.15) +
      #coord_cartesian(xlim= c(min(up_forest$yi),max(up_forest$yi)))+
      
      coord_cartesian(xlim= c(min(up_forest_state1$yi),max(up_forest_state1$yi)))+
      geom_vline(xintercept = 1, linetype = "longdash") +
      #scale_x_continuous(breaks = seq(-3,10,1))+
      scale_y_continuous(breaks = seq(1,g,3)) +
      scale_x_continuous( if (input$expo_b_up_state == "OR") {name = "Odds Ratio (95% confidence interval)"}
                          
                          
                          else if (input$expo_b_up_state == "PR"){name = "Prevalence ratio (95% CI)"}
                          
      )+
      #labs(x="Adjusted Odds Ratio", y="")+
      theme(axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            panel.grid.major=element_blank(),
            panel.grid.minor=element_blank(),
            
            legend.position = "none"
      )
    
    fonseca3_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text_interactive(aes(x = 1,label = short, tooltip = Outcome.variable),size= 5.1,hjust = 0) + 
      #geom_text(aes(x = 2.2, label = Outcome.variable), size= 3.4)+
      geom_text_interactive(aes(x = 2, label = shortexpo,tooltip = Exposure.measure),size= 5.1,hjust = 1) +
      #geom_text(aes(x = 4, label = Subcategory), size= 3.4,hjust = 1)+
      #geom_text(aes(x = 5, label = inter1), size= 3.4,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    up_forest_state1[g+1,16] <- "POINT ESTIMATE(95% CI)"
    
    fonseca2_state <- ggplot(data = up_forest_state1, aes(y = id2)) +
      #geom_hline(aes(yintercept = Outcome.variable), size = 7) +
      geom_text(aes(x = 1,label = authors),size= 5.1,hjust = 0)+
      geom_text(aes(x = 1.4, label = Subcategory),size= 5.1, hjust = 0) +
      geom_text(aes(x = 2.2, label = inter_95), size= 5.1,hjust = 1)+
      geom_hline(aes(yintercept=c(g+0.5)))+
      # +
      #geom_text(aes(x = 3, label = Subcategory), hjust = 1)
      scale_colour_identity() +
      theme_void()
    
    
    high2 <- nrow(up_forest_state1)/2
    
    
    
    girafe( code = print(fonseca3_state + fonseca_state + fonseca2_state), width_svg = 22, height_svg = high2+1.3,
            options = list(
              opts_selection(
                type = "single", css = "fill:#0c0000;stroke:black;"),
              opts_hover(css = "fill:#0c0000;stroke:black;cursor:pointer;")
            )
            
    )
    
    
  })
  
  #### For AR
  
  
  
  #### For Gastro
  
  
  
  #### For Neuro ELIMINATED
  
  
  
  
  
  
  
  #
  #forest1 <- forest[c(-1,-2,-3, -4, -5, -6, -7, -8, -9, -10, -11, -12)]
  #The dt output code
  output$my_table <- renderDataTable({
    
    out <- forest[forest$Reference %in% selected_state(), ]
    if( nrow(out) < 1 ) return(NULL)
    row.names(out) <- NULL
    #datatable(out ,selection='single')
    #out
    
    #newdata <- out[c(-1,-3, -4, -5,-6,-7,-15, -16, -17, -18)]
    newdata <- out[c(1, 10, 11, 12, 13, 14,15, 16, 17)]
    tablereac <- as.datatable(formattable(newdata,align = c("l", rep("c", NCOL(newdata) - 1)), list(
      #CPOE = color_tile("white", "green"),
      #VERBAL = color_tile("white", "red"),
      #WRITTEN = color_tile("white", "red"),
      Confounding = formatter("span",
                              style = x ~ style(display  = "block",
                                                "border-radius" = "50%",
                                                height="30px",
                                                margin="auto",
                                                width="30px",
                                                "font-size"="9px", 
                                                "line-height"="30px",
                                                "text-align"="center",
                                                "padding-right" = "4px",
                                                color = "black",
                                                "background-color" = sapply(x,bg.picker))
                              
      ),
      "Selection of participants" = formatter("span",
                                              style = x ~ style(display  = "block",
                                                                "border-radius" = "50%",
                                                                height="30px",
                                                                margin="auto",
                                                                width="30px",
                                                                "font-size"="9px", 
                                                                "line-height"="30px",
                                                                "text-align"="center",
                                                                "padding-right" = "4px",
                                                                color = "black",
                                                                "background-color" = sapply(x,bg.picker))),
      
      "Measurement of exposure" = formatter("span",
                                            style = x ~ style(display  = "block",
                                                              "border-radius" = "50%",
                                                              height="30px",
                                                              margin="auto",
                                                              width="30px",
                                                              "font-size"="9px", 
                                                              "line-height"="30px",
                                                              "text-align"="center",
                                                              "padding-right" = "4px",
                                                              color = "black",
                                                              "background-color" = sapply(x,bg.picker))),
      "Missing Data" = formatter("span",
                                 style = x ~ style(display  = "block",
                                                   "border-radius" = "50%",
                                                   height="30px",
                                                   margin="auto",
                                                   width="30px",
                                                   "font-size"="9px", 
                                                   "line-height"="30px",
                                                   "text-align"="center",
                                                   "padding-right" = "4px",
                                                   color = "black",
                                                   "background-color" = sapply(x,bg.picker))),
      "Measurement of outcome" = formatter("span",
                                           style = x ~ style(display  = "block",
                                                             "border-radius" = "50%",
                                                             height="30px",
                                                             margin="auto",
                                                             width="30px",
                                                             "font-size"="10px", 
                                                             "line-height"="30px",
                                                             "text-align"="center",
                                                             "padding-right" = "4px",
                                                             color = "black",
                                                             "background-color" = sapply(x,bg.picker))),
      "Selection of reported results" = formatter("span",
                                                  style = x ~ style(display  = "block",
                                                                    "border-radius" = "50%",
                                                                    height="30px",
                                                                    margin="auto",
                                                                    width="30px",
                                                                    "font-size"="9px", 
                                                                    "line-height"="30px",
                                                                    "text-align"="center",
                                                                    "padding-right" = "4px",
                                                                    color = "black",
                                                                    "background-color" = sapply(x,bg.picker))),
      "Measurement of interventions" = formatter("span",
                                                 style = x ~ style(display  = "block",
                                                                   "border-radius" = "50%",
                                                                   height="30px",
                                                                   margin="auto",
                                                                   width="30px",
                                                                   "font-size"="9px", 
                                                                   "line-height"="30px",
                                                                   "text-align"="center",
                                                                   "padding-right" = "4px",
                                                                   color = "black",
                                                                   "background-color" = sapply(x,bg.picker))),
      
      "Overall" = formatter("span",
                            style = x ~ style(display  = "block",
                                              "border-radius" = "50%",
                                              height="30px",
                                              margin="auto",
                                              width="30px",
                                              "font-size"="9px", 
                                              "line-height"="30px",
                                              "text-align"="center",
                                              "padding-right" = "4px",
                                              color = "black",
                                              "background-color" = sapply(x,bg.picker)))
      
      
    )), rownames = FALSE, escape = F, selection = c("single"),class="compact",options = list(ordering=F, bFilter=F))
    
    
  })
  
  #### For upper R
  
  
  
  
  #### For AR
  
  
  
  #### For GI
  
  
  
  #### For Neuro
  
  
  
  
  #reactive table based on the selected row 
  tbl_reactive <- reactive({
    #t(input$filter(forest123, study == selected_state()))
    gew <- forest123[forest123$Reference %in% selected_state(), ]
    gew<- gew[c(12, 4, 5, 6, 7, 8, 9, 10, 11)]
    t(gew[as.numeric(input$my_table_rows_selected[1]),])
    #t(forest123[as.character(input$my_table_rows_selected[1]),])
    #t(forest123[input$my_table_rows_selected %in% selected_state())
    #t(forest123[selected_state(), ])
  })
  
  
  
  ##### For upper R
  
  #  tbl_reactive_up <- reactive({
  #t(input$filter(forest123, study == selected_state()))
  #    gew1 <- forest_sabado[forest_sabado$IDD %in% selected_state_up(), ]
  #    gew1<- gew1[c(25, 26,27)]
  #    t(gew1[1,])
  #t(forest123[as.character(input$my_table_rows_selected[1]),])
  #t(forest123[input$my_table_rows_selected %in% selected_state())
  #t(forest123[selected_state(), ])
  
  #  })
  ######## lower 
  tbl_reactive_low <- reactive({
    
    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias_6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2_6'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 3_6'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 4_6'] <- 'Question 9. Can we be confident in the assessment of outcome?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias 2_6'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
#    names(ROB_joint)[names(ROB_joint) == 'Question 1'] <- 'Question 1. Can we be confident in the assessment of exposure?'
#    names(ROB_joint)[names(ROB_joint) == 'Question 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
#    names(ROB_joint)[names(ROB_joint) == 'Question 3'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
#    names(ROB_joint)[names(ROB_joint) == 'Question 4'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
#    names(ROB_joint)[names(ROB_joint) == 'Question 5'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
#    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
#    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
#    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
#    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
#    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
    
#    names(ROB_joint)[names(ROB_joint) == 'Question 6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
#    names(ROB_joint)[names(ROB_joint) == 'Question 7'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
#    names(ROB_joint)[names(ROB_joint) == 'Question 8'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
#    names(ROB_joint)[names(ROB_joint) == 'Question 9'] <- 'Question 9. Can we be confident in the assessment of outcome?'
#    names(ROB_joint)[names(ROB_joint) == 'Question 10'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
    
    
    
    gew1low <- ROB_joint[ROB_joint$IDD_2 %in% selected_state_low(), ]
    
    if(is.na(gew1low$"Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?")){gew1low <- gew1low[c(1,2, 3, 4, 5)]} else {gew1low <- gew1low[c(1, 5, 9, 10, 11, 12, 13)]}    
    
    #gew1<- gew1[c(1,2, 3, 4, 5, 9,10)]
    t(gew1low[1,])
    
  }) 
  
  
  #####
  tbl_reactive_up <- reactive({
    #gew1 <- ROB_joint[ROB_joint$IDD_2 %in% selected_state_up(), ]
    #if(is.na(gew1$"Differential information 3")){gew1 <- gew1[c(1,2, 3, 4, 5)]} else {gew1 <- gew1[c(1,2, 3, 4, 5, 9, 10)]}    
            #gew1<- gew1[c(1,2, 3, 4, 5, 9,10)]
    #t(gew1[1,])
    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias_6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2_6'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 3_6'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 4_6'] <- 'Question 9. Can we be confident in the assessment of outcome?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias 2_6'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
    #    names(ROB_joint)[names(ROB_joint) == 'Question 1'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 3'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 4'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 5'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
    #    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    #    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    #    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
    
    #    names(ROB_joint)[names(ROB_joint) == 'Question 6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 7'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 8'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 9'] <- 'Question 9. Can we be confident in the assessment of outcome?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 10'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
    
    
    
    gew1up <- ROB_joint[ROB_joint$IDD_2 %in% selected_state_up(), ]
    
    if(is.na(gew1up$"Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?")){gew1up <- gew1up[c(1,2, 3, 4, 5)]} else {gew1up <- gew1up[c(1, 5, 9, 10, 11, 12, 13)]}    
    
    #gew1<- gew1[c(1,2, 3, 4, 5, 9,10)]
    t(gew1up[1,])
    
    
  })
  
  ##### For AR
  
  tbl_reactive_ar <- reactive({

    
    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias_6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2_6'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 3_6'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 4_6'] <- 'Question 9. Can we be confident in the assessment of outcome?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias 2_6'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
    #    names(ROB_joint)[names(ROB_joint) == 'Question 1'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 3'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 4'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 5'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
    #    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    #    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    #    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
    
    #    names(ROB_joint)[names(ROB_joint) == 'Question 6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 7'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 8'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 9'] <- 'Question 9. Can we be confident in the assessment of outcome?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 10'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
    
    
    
    gew1ar <- ROB_joint[ROB_joint$IDD_2 %in% selected_state_ar(), ]
    
    if(is.na(gew1ar$"Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?")){gew1ar <- gew1ar[c(1,2, 3, 4, 5)]} else {gew1ar <- gew1ar[c(1, 5, 9, 10, 11, 12, 13)]}    
    
    #gew1<- gew1[c(1,2, 3, 4, 5, 9,10)]
    t(gew1ar[1,])
    
  })
  
  ##### For Ic
  
  tbl_reactive_ic <- reactive({
    
    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias_6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2_6'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 3_6'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 4_6'] <- 'Question 9. Can we be confident in the assessment of outcome?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias 2_6'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
    #    names(ROB_joint)[names(ROB_joint) == 'Question 1'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 3'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 4'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 5'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
    #    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    #    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    #    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
    
    #    names(ROB_joint)[names(ROB_joint) == 'Question 6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 7'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 8'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 9'] <- 'Question 9. Can we be confident in the assessment of outcome?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 10'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
    
    
    
    gew1ic <- ROB_joint[ROB_joint$IDD_2 %in% selected_state_ic(), ]
    
    if(is.na(gew1ic$"Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?")){gew1ic <- gew1ic[c(1,2, 3, 4, 5)]} else {gew1ic <- gew1ic[c(1, 5, 9, 10, 11, 12, 13)]}    
    
    #gew1<- gew1[c(1,2, 3, 4, 5, 9,10)]
    t(gew1ic[1,])
    
  })
  
  ##### For GI
  
  tbl_reactive_gi <- reactive({
    
    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias_6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 2_6'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 3_6'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
    names(ROB_joint)[names(ROB_joint) == 'Differential information 4_6'] <- 'Question 9. Can we be confident in the assessment of outcome?'
    names(ROB_joint)[names(ROB_joint) == 'Selection bias 2_6'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
    #    names(ROB_joint)[names(ROB_joint) == 'Question 1'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 3'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 4'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 5'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
    #    names(ROB_joint)[names(ROB_joint) == 'Differential information'] <- 'Question 1. Can we be confident in the assessment of exposure?'
    #    names(ROB_joint)[names(ROB_joint) == 'Differential information 2'] <- 'Question 2. Can we be confident that those who were exposed had developed the outcome of interest and unexposed had not?'
    #    names(ROB_joint)[names(ROB_joint) == 'Selection bias'] <- 'Question 3. Were those who were exposed and developed the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Selection_bias 2'] <- 'Question 4. Were those who were exposed and did not develop the outcome of interest properly selected?'
    #    names(ROB_joint)[names(ROB_joint) == 'Confounding'] <- 'Question 5. Was statistical adjustment carried out for important confounding variables?'
    
    
    #    names(ROB_joint)[names(ROB_joint) == 'Question 6'] <- 'Question 6. Was selection of exposed and non-exposed cohorts drawn from the same population?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 7'] <- 'Question 7. Can we be confident that the outcome of interest was not present at start of study?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 8'] <- 'Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 9'] <- 'Question 9. Can we be confident in the assessment of outcome?'
    #    names(ROB_joint)[names(ROB_joint) == 'Question 10'] <- 'Question 10. Was the follow up of cohorts adequate?'
    
    
    
    
    gew1gi <- ROB_joint[ROB_joint$IDD_2 %in% selected_state_gi(), ]
    
    if(is.na(gew1gi$"Question 8. Can we be confident in the assessment of the presence or absence of prognostic factors?")){gew1gi <- gew1gi[c(1,2, 3, 4, 5)]} else {gew1gi <- gew1gi[c(1, 5, 9, 10, 11, 12, 13)]}    
    
    #gew1<- gew1[c(1,2, 3, 4, 5, 9,10)]
    t(gew1gi[1,])
    
  })
  
  
  
  ##### to include in the new version of forest plot for upper respiratory
  output$alexander1 <- renderDataTable({
    
    
    out23up <- ROB_joint_tl[ROB_joint_tl$IDD_2 %in% selected_state_up(), ]
    if( nrow(out23up) < 1 ) return(NULL)
    row.names(out23up) <- NULL
    #datatable(out ,selection='single')
    #out
    
    if(is.na(out23up$"Question 8")){out23up <- out23up[c(1, 2, 3, 4, 5)]} else {out23up <- out23up[c(1, 5, 10, 11, 12, 13, 14)]}
    
    #out23up <- out23up[c(2, 1, 3, 4, 5)]
    #newdata <- out[c(-1,-3, -4, -5,-6,-7,-15, -16, -17, -18)]
    #newdata23up <- out23up[c(10, 11, 12, 13, 14,15, 16, 17)]
    tablereac23up <- as.datatable(formattable(out23up,align = c("l", rep("c", NCOL(out23up) - 1)), list(
      #CPOE = color_tile("white", "green"),
      #VERBAL = color_tile("white", "red"),
      #WRITTEN = color_tile("white", "red"),
      "Question 1" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))
                               
      ),
      "Question 2" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))
      ),
      
      "Question 3" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 4" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 5" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Overall bias" = formatter("span",
                                 style = j ~ style(display  = "block",
                                                   "border-radius" = "50%",
                                                   height="50px",
                                                   margin="auto",
                                                   width="50px",
                                                   "font-size"="9px", 
                                                   "line-height"="50px",
                                                   "text-align"="center",
                                                   "padding-right" = "4px",
                                                   color = "black",
                                                   "background-color" = sapply(j,bg.picker1))),
      "Question 6" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 8" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 9" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 10" = formatter("span",
                                style = j ~ style(display  = "block",
                                                  "border-radius" = "55%",
                                                  height="55px",
                                                  margin="auto",
                                                  width="55px",
                                                  "font-size"="11px", 
                                                  "line-height"="55px",
                                                  "text-align"="center",
                                                  "padding-right" = "4px",
                                                  color = "black",
                                                  "background-color" = sapply(j,bg.picker1))),
      
      "Question 7" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1)))
      
      
    )), rownames = F, escape = F, selection = c("single"),class="compact",options = list(ordering=F, bFilter=F))
    
    
  })
  
  
  ####### traffic for lower
  output$alexander2 <- renderDataTable({
    
    #names(ROB_joint_tl)[names(ROB_joint_tl) == 'Misclassification of exposure'] <- 'Question 1'
    #names(ROB_joint_tl)[names(ROB_joint_tl) == 'Misclassification of outcome'] <- 'Question 2'
    #names(ROB_joint_tl)[names(ROB_joint_tl) == 'Selection bias'] <- 'Question 3'
    #names(ROB_joint_tl)[names(ROB_joint_tl) == 'Selection_bias 2'] <- 'Question 4'
    #names(ROB_joint_tl)[names(ROB_joint_tl) == 'Confounding'] <- 'Question 5'
    
    out23low <- ROB_joint_tl[ROB_joint_tl$IDD_2 %in% selected_state_low(), ]
    if( nrow(out23low) < 1 ) return(NULL)
    row.names(out23low) <- NULL
    #datatable(out ,selection='single')
    #out
    
    if(is.na(out23low$"Question 8")){out23low <- out23low[c(1, 2, 3, 4, 5)]} else {out23low <- out23low[c(1, 5, 10, 11, 12, 13, 14)]}
    
    #out23up <- out23up[c(2, 1, 3, 4, 5)]
    #newdata <- out[c(-1,-3, -4, -5,-6,-7,-15, -16, -17, -18)]
    #newdata23up <- out23up[c(10, 11, 12, 13, 14,15, 16, 17)]
    tablereac23low <- as.datatable(formattable(out23low,align = c("l", rep("c", NCOL(out23low) - 1)), list(
      #CPOE = color_tile("white", "green"),
      #VERBAL = color_tile("white", "red"),
      #WRITTEN = color_tile("white", "red"),
      "Question 1" = formatter("span",
                                                  style = j ~ style(display  = "block",
                                                                    "border-radius" = "55%",
                                                                    height="55px",
                                                                    margin="auto",
                                                                    width="55px",
                                                                    "font-size"="11px", 
                                                                    "line-height"="55px",
                                                                    "text-align"="center",
                                                                    "padding-right" = "4px",
                                                                    color = "black",
                                                                    "background-color" = sapply(j,bg.picker1))
                                                  
      ),
      "Question 2" = formatter("span",
                                                 style = j ~ style(display  = "block",
                                                                   "border-radius" = "55%",
                                                                   height="55px",
                                                                   margin="auto",
                                                                   width="55px",
                                                                   "font-size"="11px", 
                                                                   "line-height"="55px",
                                                                   "text-align"="center",
                                                                   "padding-right" = "4px",
                                                                   color = "black",
                                                                   "background-color" = sapply(j,bg.picker1))
      ),
      
      "Question 3" = formatter("span",
                                   style = j ~ style(display  = "block",
                                                     "border-radius" = "55%",
                                                     height="55px",
                                                     margin="auto",
                                                     width="55px",
                                                     "font-size"="11px", 
                                                     "line-height"="55px",
                                                     "text-align"="center",
                                                     "padding-right" = "4px",
                                                     color = "black",
                                                     "background-color" = sapply(j,bg.picker1))),
      "Question 4" = formatter("span",
                                     style = j ~ style(display  = "block",
                                                       "border-radius" = "55%",
                                                       height="55px",
                                                       margin="auto",
                                                       width="55px",
                                                       "font-size"="11px", 
                                                       "line-height"="55px",
                                                       "text-align"="center",
                                                       "padding-right" = "4px",
                                                       color = "black",
                                                       "background-color" = sapply(j,bg.picker1))),
      "Question 5" = formatter("span",
                                style = j ~ style(display  = "block",
                                                  "border-radius" = "55%",
                                                  height="55px",
                                                  margin="auto",
                                                  width="55px",
                                                  "font-size"="11px", 
                                                  "line-height"="55px",
                                                  "text-align"="center",
                                                  "padding-right" = "4px",
                                                  color = "black",
                                                  "background-color" = sapply(j,bg.picker1))),
      "Overall bias" = formatter("span",
                                 style = j ~ style(display  = "block",
                                                   "border-radius" = "50%",
                                                   height="50px",
                                                   margin="auto",
                                                   width="50px",
                                                   "font-size"="9px", 
                                                   "line-height"="50px",
                                                   "text-align"="center",
                                                   "padding-right" = "4px",
                                                   color = "black",
                                                   "background-color" = sapply(j,bg.picker1))),
      "Question 6" = formatter("span",
                                               style = j ~ style(display  = "block",
                                                                 "border-radius" = "55%",
                                                                 height="55px",
                                                                 margin="auto",
                                                                 width="55px",
                                                                 "font-size"="11px", 
                                                                 "line-height"="55px",
                                                                 "text-align"="center",
                                                                 "padding-right" = "4px",
                                                                 color = "black",
                                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 8" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 9" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 10" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      
      "Question 7" = formatter("span",
                                               style = j ~ style(display  = "block",
                                                                 "border-radius" = "55%",
                                                                 height="55px",
                                                                 margin="auto",
                                                                 width="55px",
                                                                 "font-size"="11px", 
                                                                 "line-height"="55px",
                                                                 "text-align"="center",
                                                                 "padding-right" = "4px",
                                                                 color = "black",
                                                                 "background-color" = sapply(j,bg.picker1)))
      
      
    )), rownames = F, escape = F, selection = c("single"),class="compact",options = list(ordering=F, bFilter=F))
    
    
  })
  
  
  ####### traffic for AR
  output$alexander3 <- renderDataTable({
    
    
    out23ar <- ROB_joint_tl[ROB_joint_tl$IDD_2 %in% selected_state_ar(), ]
    if( nrow(out23ar) < 1 ) return(NULL)
    row.names(out23ar) <- NULL
    #datatable(out ,selection='single')
    #out
    
    if(is.na(out23ar$"Question 8")){out23ar <- out23ar[c(1, 2, 3, 4, 5)]} else {out23ar <- out23ar[c(1, 5, 10, 11, 12, 13, 14)]}
    
    #out23up <- out23up[c(2, 1, 3, 4, 5)]
    #newdata <- out[c(-1,-3, -4, -5,-6,-7,-15, -16, -17, -18)]
    #newdata23up <- out23up[c(10, 11, 12, 13, 14,15, 16, 17)]
    tablereac23ar <- as.datatable(formattable(out23ar,align = c("l", rep("c", NCOL(out23ar) - 1)), list(
      #CPOE = color_tile("white", "green"),
      #VERBAL = color_tile("white", "red"),
      #WRITTEN = color_tile("white", "red"),
      "Question 1" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))
                               
      ),
      "Question 2" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))
      ),
      
      "Question 3" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 4" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 5" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Overall bias" = formatter("span",
                                 style = j ~ style(display  = "block",
                                                   "border-radius" = "50%",
                                                   height="50px",
                                                   margin="auto",
                                                   width="50px",
                                                   "font-size"="9px", 
                                                   "line-height"="50px",
                                                   "text-align"="center",
                                                   "padding-right" = "4px",
                                                   color = "black",
                                                   "background-color" = sapply(j,bg.picker1))),
      "Question 6" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 8" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 9" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 10" = formatter("span",
                                style = j ~ style(display  = "block",
                                                  "border-radius" = "55%",
                                                  height="55px",
                                                  margin="auto",
                                                  width="55px",
                                                  "font-size"="11px", 
                                                  "line-height"="55px",
                                                  "text-align"="center",
                                                  "padding-right" = "4px",
                                                  color = "black",
                                                  "background-color" = sapply(j,bg.picker1))),
      
      "Question 7" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1)))
      
      
    )), rownames = F, escape = F, selection = c("single"),class="compact",options = list(ordering=F, bFilter=F))
    
    
  })
  
  #### AR
  output$alexander4 <- renderDataTable({
    
    
    out23gi <- ROB_joint_tl[ROB_joint_tl$IDD_2 %in% selected_state_gi(), ]
    if( nrow(out23gi) < 1 ) return(NULL)
    row.names(out23gi) <- NULL
    #datatable(out ,selection='single')
    #out
    
    if(is.na(out23gi$"Question 8")){out23gi <- out23gi[c(1, 2, 3, 4, 5)]} else {out23gi <- out23gi[c(1, 5, 10, 11, 12, 13, 14)]}
    
    #out23up <- out23up[c(2, 1, 3, 4, 5)]
    #newdata <- out[c(-1,-3, -4, -5,-6,-7,-15, -16, -17, -18)]
    #newdata23up <- out23up[c(10, 11, 12, 13, 14,15, 16, 17)]
    tablereac23gi <- as.datatable(formattable(out23gi,align = c("l", rep("c", NCOL(out23gi) - 1)), list(
      #CPOE = color_tile("white", "green"),
      #VERBAL = color_tile("white", "red"),
      #WRITTEN = color_tile("white", "red"),
      "Question 1" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))
                               
      ),
      "Question 2" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))
      ),
      
      "Question 3" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 4" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 5" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Overall bias" = formatter("span",
                                 style = j ~ style(display  = "block",
                                                   "border-radius" = "50%",
                                                   height="50px",
                                                   margin="auto",
                                                   width="50px",
                                                   "font-size"="9px", 
                                                   "line-height"="50px",
                                                   "text-align"="center",
                                                   "padding-right" = "4px",
                                                   color = "black",
                                                   "background-color" = sapply(j,bg.picker1))),
      "Question 6" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 8" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 9" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 10" = formatter("span",
                                style = j ~ style(display  = "block",
                                                  "border-radius" = "55%",
                                                  height="55px",
                                                  margin="auto",
                                                  width="55px",
                                                  "font-size"="11px", 
                                                  "line-height"="55px",
                                                  "text-align"="center",
                                                  "padding-right" = "4px",
                                                  color = "black",
                                                  "background-color" = sapply(j,bg.picker1))),
      
      "Question 7" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1)))
      
      
    )), rownames = F, escape = F, selection = c("single"),class="compact",options = list(ordering=F, bFilter=F))
    
    
  })
  
  #### IC
  output$alexander5 <- renderDataTable({
    
    
    out23ic <- ROB_joint_tl[ROB_joint_tl$IDD_2 %in% selected_state_ic(), ]
    if( nrow(out23ic) < 1 ) return(NULL)
    row.names(out23ic) <- NULL
    #datatable(out ,selection='single')
    #out
    
    if(is.na(out23ic$"Question 8")){out23ic <- out23ic[c(1, 2, 3, 4, 5)]} else {out23ic <- out23ic[c(1, 5, 10, 11, 12, 13, 14)]}
    
    #out23up <- out23up[c(2, 1, 3, 4, 5)]
    #newdata <- out[c(-1,-3, -4, -5,-6,-7,-15, -16, -17, -18)]
    #newdata23up <- out23up[c(10, 11, 12, 13, 14,15, 16, 17)]
    tablereac23ic <- as.datatable(formattable(out23ic,align = c("l", rep("c", NCOL(out23ic) - 1)), list(
      #CPOE = color_tile("white", "green"),
      #VERBAL = color_tile("white", "red"),
      #WRITTEN = color_tile("white", "red"),
      "Question 1" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))
                               
      ),
      "Question 2" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))
      ),
      
      "Question 3" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 4" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 5" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Overall bias" = formatter("span",
                                 style = j ~ style(display  = "block",
                                                   "border-radius" = "50%",
                                                   height="50px",
                                                   margin="auto",
                                                   width="50px",
                                                   "font-size"="9px", 
                                                   "line-height"="50px",
                                                   "text-align"="center",
                                                   "padding-right" = "4px",
                                                   color = "black",
                                                   "background-color" = sapply(j,bg.picker1))),
      "Question 6" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 8" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 9" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1))),
      "Question 10" = formatter("span",
                                style = j ~ style(display  = "block",
                                                  "border-radius" = "55%",
                                                  height="55px",
                                                  margin="auto",
                                                  width="55px",
                                                  "font-size"="11px", 
                                                  "line-height"="55px",
                                                  "text-align"="center",
                                                  "padding-right" = "4px",
                                                  color = "black",
                                                  "background-color" = sapply(j,bg.picker1))),
      
      "Question 7" = formatter("span",
                               style = j ~ style(display  = "block",
                                                 "border-radius" = "55%",
                                                 height="55px",
                                                 margin="auto",
                                                 width="55px",
                                                 "font-size"="11px", 
                                                 "line-height"="55px",
                                                 "text-align"="center",
                                                 "padding-right" = "4px",
                                                 color = "black",
                                                 "background-color" = sapply(j,bg.picker1)))
      
      
    )), rownames = F, escape = F, selection = c("single"),class="compact",options = list(ordering=F, bFilter=F))
    
  })
  
  ##### to include in the new version of forest plot for lower respiratory
  
  
  
  ####
  
  ##### For Neuro
  
  
  #here's the table displayed in our modal
  
  output$modal_table_low <- DT::renderDataTable({
    tbl_reactive_low()
  })
  
  ### for Upper R
  
  output$modal_table_up <- DT::renderDataTable({
    tbl_reactive_up()
  })
  
  ### for AR
  
  output$modal_table_ar <- DT::renderDataTable({
    tbl_reactive_ar()
  })
  
  ### for IC
  
  output$modal_table_ic <- DT::renderDataTable({
    tbl_reactive_ic()
  })
  
  ### for GI
  
  output$modal_table_gi <- DT::renderDataTable({
    tbl_reactive_gi()
  })
  
  ### for Neuro
  
  
  
  #our modal dialog box
  
  ######  for Lower R
  myModal_low <- function(failed=FALSE){
    modalDialog(
      div(dataTableOutput('alexander2'), style = "font-size:95%"),
      hr(),
      div(dataTableOutput('modal_table_low'), style = "font-size:95%"),
      #width= "fit-content",
      size = c("l"),
      easyClose = TRUE
      
    )
  }
  
  #### for IC 
  
  myModal_ic <- function(failed=FALSE){
    modalDialog(
      div(dataTableOutput('alexander5'), style = "font-size:95%"),
      hr(),
      div(dataTableOutput('modal_table_ic'), style = "font-size:95%"),
      #width= "fit-content",
      size = c("l"),
      easyClose = TRUE
      
    )
  }
  
  #### for Upper R
  
  myModal_up <- function(failed=FALSE){
    modalDialog(
      div(dataTableOutput('alexander1'), style = "font-size:95%"),
      hr(),
      div(dataTableOutput('modal_table_up'), style = "font-size:95%"),
      #width= "fit-content",
      size = c("l"),
      easyClose = TRUE
      
    )
  }
  
  #### for AR
  
  myModal_ar <- function(failed=FALSE){
    modalDialog(
      div(dataTableOutput('alexander3'), style = "font-size:95%"),
      hr(),
      div(dataTableOutput('modal_table_ar'), style = "font-size:95%"),
      #width= "fit-content",
      size = c("l"),
      easyClose = TRUE
      
    )
  }
  
  #### for GI
  
  myModal_gi <- function(failed=FALSE){
    modalDialog(
      div(dataTableOutput('alexander4'), style = "font-size:95%"),
      hr(),
      div(dataTableOutput('modal_table_gi'), style = "font-size:95%"),
      #width= "fit-content",
      size = c("l"),
      easyClose = TRUE
      
    )
  }
  
  #### for Neuro
  
  
  
  ###################event to trigger the modal box to appear
  #observeEvent(input$my_table_rows_selected,{
  #observeEvent(input$selected_state,{
  #  showModal(myModal())
  
  #}) 
  
  ### For upper R
  observeEvent(selected_state_up(),{
    #observeEvent(input$selected_state,{
    showModal(myModal_up())
    
  }) 
  
  ##### for lower
  observeEvent(selected_state_low(),{
    #observeEvent(input$selected_state,{
    showModal(myModal_low())
    
  })  
  
  
  ### For AR
  observeEvent(selected_state_ar(),{
    #observeEvent(input$selected_state,{
    showModal(myModal_ar())
    
  }) 
  
  
  ### For IC
  observeEvent(selected_state_ic(),{
    #observeEvent(input$selected_state,{
    showModal(myModal_ic())
    
  }) 
  
  ### For GI
  observeEvent(selected_state_gi(),{
    #observeEvent(input$selected_state,{
    showModal(myModal_gi())
    
  }) 
  
  #####Included_data for the incuded studies 
#  included_data <- reactive({
    
#    validate(
#      need(file.exists("included_light.rds"),
#           "Included cache file not found")
#    )
    
#    readRDS("included_light.rds")
#  })
  
  included_data <- reactive({
    readRDS("included_cache_2.rds")
  })
  
  excluded_data <- reactive({
    
    validate(
      need(file.exists("excluded_cache.rds"),
           "Excluded data not available")
    )
    
    df <- readRDS("excluded_cache.rds")
    
    # enforce character (good practice)
    df[] <- lapply(df, as.character)
    
    df
  })
  
  
  ### For Neuro
  
  
  
  output$mytable1234 <- DT::renderDataTable({
    #datatable(df())
    #DT::datatable(ROB_joint_tl, escape = FALSE, options = list(ordering=F, bFilter=F, pageLength = 20))
    DT::datatable(cafo3, escape = FALSE, options = list(ordering=F, bFilter=F, pageLength = 20))
  })
  
#  output$exclusionF <- DT::renderDataTable({
    #datatable(df())
    #DT::datatable(ROB_joint_tl, escape = FALSE, options = list(ordering=F, bFilter=F, pageLength = 20))
#    DT::datatable(exclusionF, escape = FALSE, rownames = FALSE,options = list(autoWidth = TRUE,ordering=F, bFilter=T, pageLength = 20))
#  })
  
  output$confo <- DT::renderDataTable({
    #datatable(df())
    #DT::datatable(ROB_joint_tl, escape = FALSE, options = list(ordering=F, bFilter=F, pageLength = 20))
    DT::datatable(ROB_confounding, escape = FALSE, options = list(autoWidth = TRUE,ordering=F, bFilter=T, pageLength = 20))
  })
  
  
#  output$inclusionF <- DT::renderDataTable({
    #datatable(df())
    #DT::datatable(ROB_joint_tl, escape = FALSE, options = list(ordering=F, bFilter=F, pageLength = 20))
#    DT::datatable(inclusionF, rownames = FALSE, escape = FALSE, options = list(autoWidth = TRUE, bFilter=T, pageLength = 20, ordering=F))
#  })
  
  #####
  output$included_table <- renderDT({
    
    req(included_data())
    
    datatable(
      included_data(),
      rownames = FALSE,
      options = list(pageLength = 10)
    )
  })
  

  
  
  excluded_clean <- reactive({
    
    excluded_data() %>%
      dplyr::select(
        # Refid,
        Author,
        Title,
        Year,
        Reason
      )
    
  })
  
  
  output$excluded_table <- DT::renderDT({
    
    req(excluded_clean())
    
    datatable(
      excluded_clean(),
      rownames = FALSE,
      options = list(pageLength = 10)
    )
    
  })
  #### Download botton for included studies ###
  
  output$download_csv <- downloadHandler(
    filename = function() {
      paste0("LivingSR_Included_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(
        included_data(),
        file,
        row.names = FALSE
      )
    }
  )
  
  #### Download botton for included studies ###
  
  output$download_excel <- downloadHandler(
    filename = function() {
      paste0("LivingSR_Included_", Sys.Date(), ".xlsx")
    },
    content = function(file) {
      writexl::write_xlsx(
        included_data(),
        path = file
      )
    }
  )
  
  
  ###
  
  output$mytable12345 <- DT::renderDataTable({
    #datatable(df())
    #DT::datatable(ROB_joint_tl, escape = FALSE, options = list(ordering=F, bFilter=F, pageLength = 20))
    DT::datatable(cafo4, escape = FALSE, options = list(ordering=F, bFilter=F, pageLength = 20))
  })
  
  
  
  ## * risk of bias ####
  ##### Remember that ## means that it was the original code that works prevously
##  output$bias <- renderPlot({
  
    
  ##    r22_1$'Type of Bias' <- as.character(r22_1$'Type of Bias')
  ##    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of exposure'] <- "Question 1"
  ##   r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of outcome'] <- "Question 2"
  ##   r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection bias'] <- "Question 3"
  ##   r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection_bias 2'] <- "Question 4"
  ##   r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Confounding'] <- "Question 5"
    
    
    #gg <- r22 %>% filter(Refid %in% selected_id()) %>% 
  ##  r22_1 %>% filter(category==selected_class()) %>%
  ##    ggplot(aes(x = factor(`Type of Bias`, level = c('Question 10', 'Question 9', 'Question 8', 'Question 7', 'Question 6', 'Question 5', 'Question 4', 'Question 3', 'Question 2', 'Question 1')), fill = Bias )) + 
  ##    geom_bar(position = "fill") + coord_flip() + 
  ##    scale_fill_manual(values = color_table$Color)  +
  ##    ylab("Proportion of Health Outcomes")+
  ##    xlab(" ")+

  ##    theme(
  ##      axis.text=element_text(size=13, face= "bold"),
  ##     plot.caption = element_text(hjust = 0, face= "italic", size=16),
  ##     plot.title.position  =  "panel"
  ##    )
    
  ##})
  
#  output$bias_up <- renderPlotly({
    #gg <- r22 %>% filter(Refid %in% selected_id()) %>% 
#    gg <- r22 %>% filter(Categorized.class==selected_class()) %>% 
#      ggplot(aes(x = `Type of Bias`, fill = Bias)) + 
#      geom_bar(position = "fill") + coord_flip() + 
#      scale_fill_manual(values = color_table$Color) + 
#      scale_x_discrete(labels = rev(c("Overall", "Confounding", "Measurement of Exposure", 
#                                      "Measurement of Outcome", "Measurement of Interventions","Missing Data", "Selection of Participants",
#                                      "Selection of Reported Result"))) +
#      ylab("Proportion")
#    ggplotly(gg)
#  })
  
  ###### Updated Rof B plot for lower
  
  output$bias <- renderPlotly({
    
    r22_1$'Type of Bias' <- as.character(r22_1$'Type of Bias')
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of exposure'] <- "Question 1"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of outcome'] <- "Question 2"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection bias'] <- "Question 3"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection_bias 2'] <- "Question 4"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Confounding'] <- "Question 5"
    
    
    #levels(r22_1$`Type of Bias`) <- gsub(" ", "\n", levels(r22_1$`Type of Bias`))
    #gg <- r22 %>% filter(Refid %in% selected_id()) %>% 
    gg <- r22_1 %>% filter(category==selected_class()) %>%
      ggplot(aes(x = factor(`Type of Bias`, level = c('Question 10', 'Question 9', 'Question 8', 'Question 7', 'Question 6', 'Question 5', 'Question 4', 'Question 3', 'Question 2', 'Question 1')), fill = Bias)) + 
      
      geom_bar(position = "fill") + 
      scale_x_discrete(labels = label_wrap(50))+
      scale_y_continuous(labels = scales::percent)+
      coord_flip() + 
      geom_text(aes(label = scales::percent(..count../tapply(..count.., ..x.. ,sum)[..x..])),
                position = position_fill(vjust = 0.5),
                stat = "count")+
      
      scale_fill_manual(values = color_table$Color)  +
      ylab("Percentage of Health Outcomes")+
      xlab(" ")+
      
      theme(
        axis.text=element_text(size=13, face= "bold"),
        plot.caption = element_text(hjust = 0, face= "italic", size=16),
        plot.title.position  =  "panel"
      )
    
    ggplotly(gg, tooltip = c("fill")) %>% config(modeBarButtonsToRemove = c('zoom2d','pan2d', 'select2d', 'lasso2d', 'zoomIn', 'zoomOut', 'autoScale', 'resetScale', 'hoverClosestCartesian', 'hoverCompareCartesian'))
    
    #ggplot(gg)
  })
  

  #######
  output$bias_up <- renderPlotly({

    r22_1$'Type of Bias' <- as.character(r22_1$'Type of Bias')
#    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of exposure'] <- "Question 1"
#    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of outcome'] <- "Question 2"
#    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection bias'] <- "Question 3"
#    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection_bias 2'] <- "Question 4"
#    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Confounding'] <- "Question 5"
    

    #levels(r22_1$`Type of Bias`) <- gsub(" ", "\n", levels(r22_1$`Type of Bias`))
    #gg <- r22 %>% filter(Refid %in% selected_id()) %>% 
    gg <- r22_1 %>% filter(category==selected_class()) %>%
      ggplot(aes(x = factor(`Type of Bias`, level = c('Question 10', 'Question 9', 'Question 8', 'Question 7', 'Question 6', 'Question 5', 'Question 4', 'Question 3', 'Question 2', 'Question 1')), fill = Bias)) + 
   
      geom_bar(position = "fill") + 
      scale_x_discrete(labels = label_wrap(50))+
      scale_y_continuous(labels = scales::percent)+
      coord_flip() + 
      geom_text(aes(label = scales::percent(..count../tapply(..count.., ..x.. ,sum)[..x..])),
                position = position_fill(vjust = 0.5),
                stat = "count")+
      
      scale_fill_manual(values = color_table$Color)  +
      ylab("Percentage of Health Outcomes")+
      xlab(" ")+
      
      theme(
        axis.text=element_text(size=13, face= "bold"),
        plot.caption = element_text(hjust = 0, face= "italic", size=16),
        plot.title.position  =  "panel"
       )
    
    ggplotly(gg, tooltip = c("fill")) %>% config(modeBarButtonsToRemove = c('zoom2d','pan2d', 'select2d', 'lasso2d', 'zoomIn', 'zoomOut', 'autoScale', 'resetScale', 'hoverClosestCartesian', 'hoverCompareCartesian'))
      
    #ggplot(gg)
  })
  
  ####
  #######
  output$bias_ic <- renderPlot({
    r22_1$'Type of Bias' <- as.character(r22_1$'Type of Bias')
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of exposure'] <- "Question 1"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of outcome'] <- "Question 2"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection bias'] <- "Question 3"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection_bias 2'] <- "Question 4"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Confounding'] <- "Question 5"
    
    
    #levels(r22_1$`Type of Bias`) <- gsub(" ", "\n", levels(r22_1$`Type of Bias`))
    #gg <- r22 %>% filter(Refid %in% selected_id()) %>% 
    r22_1 %>% filter(category==selected_class()) %>%
      ggplot(aes(x = factor(`Type of Bias`, level = c('Question 10', 'Question 9', 'Question 8', 'Question 7', 'Question 6', 'Question 5', 'Question 4', 'Question 3', 'Question 2', 'Question 1')), fill = Bias)) + 
      
      geom_bar(position = "fill") + 
      scale_x_discrete(labels = label_wrap(50))+
      coord_flip() + 
      
      scale_fill_manual(values = color_table$Color)  +
      ylab("Proportion of Health Outcomes")+
      xlab(" ")+
      
      theme(
        axis.text=element_text(size=13, face= "bold"),
        plot.caption = element_text(hjust = 0, face= "italic", size=16),
        plot.title.position  =  "panel"
      )
    
    
    
#    gg <- r22_1 %>% filter(category==selected_class()) %>%
#      ggplot(aes(x = factor(`Type of Bias`, level = c('Question 10', 'Question 9', 'Question 8', 'Question 7', 'Question 6', 'Question 5', 'Question 4', 'Question 3', 'Question 2', 'Question 1')), fill = Bias)) + 
#      geom_bar(position = "fill") + coord_flip() + 
#      scale_fill_manual(values = color_table$Color)  +
#      ylab("Proportion")+
#      xlab(" ")
#    ggplotly(gg)
  })
  
  
  ####
  
  output$bias_ar <- renderPlot({
    r22_1$'Type of Bias' <- as.character(r22_1$'Type of Bias')
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of exposure'] <- "Question 1"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of outcome'] <- "Question 2"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection bias'] <- "Question 3"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection_bias 2'] <- "Question 4"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Confounding'] <- "Question 5"
    
    
    #levels(r22_1$`Type of Bias`) <- gsub(" ", "\n", levels(r22_1$`Type of Bias`))
    #gg <- r22 %>% filter(Refid %in% selected_id()) %>% 
    r22_1 %>% filter(category==selected_class()) %>%
      ggplot(aes(x = factor(`Type of Bias`, level = c('Question 10', 'Question 9', 'Question 8', 'Question 7', 'Question 6', 'Question 5', 'Question 4', 'Question 3', 'Question 2', 'Question 1')), fill = Bias)) + 
      
      geom_bar(position = "fill") + 
      scale_x_discrete(labels = label_wrap(50))+
      coord_flip() + 
      
      scale_fill_manual(values = color_table$Color)  +
      ylab("Proportion of Health Outcomes")+
      xlab(" ")+
      
      theme(
        axis.text=element_text(size=13, face= "bold"),
        plot.caption = element_text(hjust = 0, face= "italic", size=16),
        plot.title.position  =  "panel"
      )
    
    
    
#    gg <- r22_1 %>% filter(category==selected_class()) %>%
#      ggplot(aes(x = factor(`Type of Bias`, level = c('Question 10', 'Question 9', 'Question 8', 'Question 7', 'Question 6', 'Question 5', 'Question 4', 'Question 3', 'Question 2', 'Question 1')), fill = Bias)) + 
#      geom_bar(position = "fill") + coord_flip() + 
#      scale_fill_manual(values = color_table$Color)  +
#      ylab("Proportion")+
#      xlab(" ")
#    ggplotly(gg)
  })
  
  output$bias_gi <- renderPlot({
    r22_1$'Type of Bias' <- as.character(r22_1$'Type of Bias')
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of exposure'] <- "Question 1"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Misclassification of outcome'] <- "Question 2"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection bias'] <- "Question 3"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Selection_bias 2'] <- "Question 4"
    #    r22_1$'Type of Bias'[r22_1$'Type of Bias' == 'Confounding'] <- "Question 5"
    
    
    #levels(r22_1$`Type of Bias`) <- gsub(" ", "\n", levels(r22_1$`Type of Bias`))
    #gg <- r22 %>% filter(Refid %in% selected_id()) %>% 
    r22_1 %>% filter(category==selected_class()) %>%
      ggplot(aes(x = factor(`Type of Bias`, level = c('Question 10', 'Question 9', 'Question 8', 'Question 7', 'Question 6', 'Question 5', 'Question 4', 'Question 3', 'Question 2', 'Question 1')), fill = Bias)) + 
      
      geom_bar(position = "fill") + 
      scale_x_discrete(labels = label_wrap(50))+
      coord_flip() + 
      
      scale_fill_manual(values = color_table$Color)  +
      ylab("Proportion of Health Outcomes")+
      xlab(" ")+
      
      theme(
        axis.text=element_text(size=13, face= "bold"),
        plot.caption = element_text(hjust = 0, face= "italic", size=16),
        plot.title.position  =  "panel"
      )
    
    
     
#    gg <- r22_1 %>% filter(category==selected_class()) %>%
#      ggplot(aes(x = factor(`Type of Bias`, level = c('Question 10', 'Question 9', 'Question 8', 'Question 7', 'Question 6', 'Question 5', 'Question 4', 'Question 3', 'Question 2', 'Question 1')), fill = Bias)) + 
#      geom_bar(position = "fill") + coord_flip() + 
#      scale_fill_manual(values = color_table$Color)  +
#      ylab("Proportion")+
#      xlab(" ")
#    ggplotly(gg)
  })
  
  
  
  
  # Define reactive values
  rv <- reactiveValues()
  
  # Data Handling ----
  
  # Use template data to populate editable table
#  observe({
#    if (is.null(input$data_upload)) {
#      rv$data <- template
#    } else {
#      rv$data <- read.csv(input$data_upload$datapath)
#    }
#  })
  
  
  
  
  # Text box
  observeEvent(input$update,{
    rv$data[which(rv$data$data == "previous_studies"), "n"] <- gsub(',', '', input$previous_studies)
    rv$data[which(rv$data$data == "previous_reports"), "n"] <- gsub(',', '', input$previous_reports)
    rv$data[which(rv$data$data == "register_results"), "n"] <- gsub(',', '', input$register_results)
    rv$data[which(rv$data$data == "database_results"), "n"] <- gsub(',', '', input$database_results)
    rv$data[which(rv$data$data == "website_results"), "n"] <- gsub(',', '', input$website_results)
    rv$data[which(rv$data$data == "organisation_results"), "n"] <- gsub(',', '', input$organisation_results)
    rv$data[which(rv$data$data == "citations_results"), "n"] <- gsub(',', '', input$citations_results)
    rv$data[which(rv$data$data == "duplicates"), "n"] <- gsub(',', '', input$duplicates)
    rv$data[which(rv$data$data == "excluded_automatic"), "n"] <- gsub(',', '', input$excluded_automatic)
    rv$data[which(rv$data$data == "excluded_other"), "n"] <- gsub(',', '', input$excluded_other)
    rv$data[which(rv$data$data == "records_screened"), "n"] <- gsub(',', '', input$records_screened)
    rv$data[which(rv$data$data == "records_excluded"), "n"] <- gsub(',', '', input$records_excluded)
    rv$data[which(rv$data$data == "dbr_sought_reports"), "n"] <- gsub(',', '', input$dbr_sought_reports)
    rv$data[which(rv$data$data == "dbr_notretrieved_reports"), "n"] <- gsub(',', '', input$dbr_notretrieved_reports)
    rv$data[which(rv$data$data == "other_sought_reports"), "n"] <- gsub(',', '', input$other_sought_reports)
    rv$data[which(rv$data$data == "other_notretrieved_reports"), "n"] <- gsub(',', '', input$other_notretrieved_reports)
    rv$data[which(rv$data$data == "dbr_assessed"), "n"] <- gsub(',', '', input$dbr_assessed)
    rv$data[which(rv$data$data == "dbr_excluded"), "n"] <- input$dbr_excluded
    rv$data[which(rv$data$data == "other_assessed"), "n"] <- gsub(',', '', input$other_assessed)
    rv$data[which(rv$data$data == "other_excluded"), "n"] <- input$other_excluded
    rv$data[which(rv$data$data == "new_studies"), "n"] <- gsub(',', '', input$new_studies)
    rv$data[which(rv$data$data == "new_reports"), "n"] <- gsub(',', '', input$new_reports)
    rv$data[which(rv$data$data == "total_studies"), "n"] <- gsub(',', '', input$total_studies)
    rv$data[which(rv$data$data == "total_reports"), "n"] <- gsub(',', '', input$total_reports)
  })
  
  # Define table proxy
  proxy = dataTableProxy('mytable')
  
  # Update reactive dataset on cell edit
  observeEvent(input$mytable_cell_edit, {
    info <- input$mytable_cell_edit
    # Define edited row
    i <- info$row 
    # Define edited column (column index offset by 4, because you are hiding
    # the rownames column and the first 3 columns of the data)
    j <- info$col + 4L
    # Define value of edit
    v <- info$value
    
    # Pass edited value to appropriate cell of data stored in rv$data
    rv$data[i, j] <- coerceValue(v, rv$data[i, j])
    
    # Replace data in table with updated data stored in rv$data
    replaceData(proxy,
                rv$data,
                resetPaging = FALSE,
                rownames = FALSE)  # important
  })
  
  
  # Reactive plot ----
  
  # Create plot
  plot <- reactive({
    data <- read_PRISMAdata(rv$data)
    attach(data)
    
    
    
    
    plot <- PRISMA_flowdiagram(data,
                               interactive = FALSE,
                               #previous = include_previous,
                               other = F
    )
  })
  
  
  # Display plot
  output$plot1 <- DiagrammeR::renderDiagrammeR({
    plot <- plot()
  })
  ###########


  
  ####  
  
  # Handle downloads ----
  output$PRISMAflowdiagramPDF <- downloadHandler(
    filename = "prisma.pdf",
    content = function(file){
      prisma_pdf(plot(), 
                 file)
    }
  )
  output$PRISMAflowdiagramPNG <- downloadHandler(
    filename = "prisma.png",
    content = function(file){
      prisma_png(plot(), 
                 file)
    }
  )
  
})
