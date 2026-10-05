dashboardPage(
  skin = "black",
  dashboardHeader(
    title = tags$span(class = "mytitle", "Living systematic review of effects of animal production on the health of surrounding communities"), 
    titleWidth = 1500
  ),
  ## menu ####
  dashboardSidebar(
    width = 265,
    sidebarMenu(
      menuItem("Background", tabName = "start", icon = icon("piggy-bank")),
      menuItem("Tutorial", tabName = "tutorial", icon = icon("chalkboard-teacher")),
      menuItem("Interpreting New Findings", tabName = "interpretation", icon = icon("key")),
      menuItem("About the Studies", tabName = "eda", icon = icon("layer-group")),
      menuItem("Studies Flowchart", tabName = "roses", icon = icon("fas fa-project-diagram")),
      # menuItem("Forest Plot", tabName = "forest", icon = icon("tree")),
      menuItem("Health Outcomes", tabName = "outcome", icon = icon("fas fa-notes-medical"),
               menuItem("Lower Respiratory", tabName = "low_rsp",
                        menuItem("Overview", tabName = "low_rsp_intro"),
                        menuItem("Prevalence Forest Plot", tabName = "low_rsp_forest_state"),
                        menuItem("Incidence Forest Plot", tabName = "low_rsp_forest"),
                        menuItem("Summary Risk of Bias", tabName = "low_rsp_risk_of_bias")),
                        #menuItem("Interpreting New Findings", tabName = "low_rsp_conclusion")),
               menuItem("Upper Respiratory", tabName = "up_rsp",
                        menuItem("Overview", tabName = "up_rsp_intro"),
                        menuItem("Prevalence Forest Plot ", tabName = "up_rsp_forest_state"),
                        menuItem("Incidence Forest Plot", tabName = "up_rsp_forest"),
                        menuItem("Summary Risk of Bias", tabName = "up_rsp_risk_of_bias")),
                        
               menuItem("Antimicrobial resistance", tabName = "ar_rsp",
                        menuItem("Overview", tabName = "ar_rsp_intro"),
                        menuItem("Prevalence Forest Plot ", tabName = "ar_rsp_forest_state"),
                        menuItem("Incidence Forest Plot", tabName = "ar_rsp_forest"),
                        menuItem("Summary Risk of Bias", tabName = "ar_rsp_risk_of_bias")),
                        
               menuItem("Infectious conditions", tabName = "ic_rsp",
                        menuItem("Overview", tabName = "ic_rsp_intro"),
                        menuItem("Prevalence Forest Plot ", tabName = "ic_rsp_forest_state"),
                        menuItem("Incidence Forest Plot", tabName = "ic_rsp_forest"),
                        menuItem("Summary Risk of Bias", tabName = "ic_rsp_risk_of_bias")),
                        
               menuItem("Gastrointestinal diseases", tabName = "gi_rsp",
                        menuItem("Overview", tabName = "gi_rsp_intro"),
                        menuItem("Prevalence Forest Plot ", tabName = "gi_rsp_forest_state"),
                        menuItem("Incidence Forest Plot", tabName = "gi_rsp_forest"),
                        menuItem("Summary Risk of Bias", tabName = "gi_rsp_risk_of_bias"))),
                        
      # ),
      
      menuItem("Included Studies", tabName = "included", icon = icon("book")),
      menuItem("Excluded Studies", tabName = "excluded", icon = icon("filter")),
   #   menuItem("Interpreting New Findings", tabName = "interpretation", icon = icon("key")),
      #menuItem("Confounding", tabName = "confounding", icon = icon("fa-solid fa-filter")),
      menuItem("Glossary of Terms", tabName = "glossary", icon = icon("fas fa-spell-check")),
      ##### exclude but with flags
      ###menuItem("Included studies", tabName = "ref", icon = icon("book")),
      
      #menuItem("Protocol Modifications", tabName = "modifications", icon = icon("fas fa-spell-check")),
      # selectInput("class",
      #             "Outcome class",
      #             choices = class_var,
      #             selected = class_var[1]),
      #uiOutput("measure"),
      #uiOutput("expo_var_1"),
      #uiOutput("expo_var_2"),
      id = "sidebar"
    )
  ),
  dashboardBody(
    tags$script(HTML("
        var openTab = function(tabName){
          $('a', $('.sidebar')).each(function() {
            if(this.getAttribute('data-value') == tabName) {
              this.click()
            };
          });
        }
      ")),
    
    tags$head(
      #tags$style(HTML(".sidebar-menu li a { font-size: 18px; }")),
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
      tags$style(HTML(".main-sidebar { font-size: 20px; }"))
    ),
    
    tabItems(
      ## background ####
      tabItem(tabName = "start",
              fluidRow(
                box(
                  width = 12, solidHeader = TRUE, status = "primary",
                  #title = "Living systematic review of effects of animal production on the health of surrounding communities",
                  title = "",
                  fluidRow(column(width = 11,
                                  br(),
                                  p("This is a systematic review of the observational studies reporting the association between health events and states and proximity to Animal Feeding Operations (AFOs). Below we describe what is a living systematic review, the background, and prior reviews. 
                                     In the next tabs, we present the data and health outcomes from the studies included.  Health outcomes 
          reported in at least two study populations are classified in the next categories: upper and lower 
          respiratory tract diseases, infectious diseases, gastroenteric conditions and, 
          antimicrobial resistance."),
                                  div(p("For an optimal visualization of this website, please use Firefox or Chrome browsers"),img(src = "firefox-logo.png", height = 33, width = 33), img(src = "mozilla.png", height = 33, width = 33)),
                                  
                                  
                                  
                                  
                                  
                                  )),
                                  hr(),
                  fluidRow( column(width = 7, 
                                   #br(),
                                   
                                   
                                   
                                   h4("What is a Living Systematic Review?"),
                                   br(), 
                                   
                                   p("A living systematic reviews is a review that is frequently updated, incorporating relevant new evidence as it becomes available.
                  This term means that rather than being a static publication in a peer-reviewed journal, 
                  the review is housed on this website allowing for more timely updates and more accessible information. The rationale for living systematic reviews is that they:"),
                                   #                  p("This process can be visualized in the this animation. Our last static systematic review about this topic was published in 2017 based on  16 relevant studies published before that year. 
                                   #   However, during the last 3 years, new studies may have been published and would need to be incorporated in  new systematic reviews. These new reviews are published on this website and updated periodically."),
                                   #                  
                                   #                  p("Through this website producers, public health officers, community leaders and community members can access
                                   # the latest summary of the available studies and a balance interpretation of the findings and their implications
                                   # in the wider body of literature will better serve the needs of the community because it"),
                                   p("1. Democratize access to the information and interpretation, and"),
                                   p("2. Provide for more timely and relevant updates"),
                                   #br(),
                                   p ("The figure on this page illustrates the living systematic review process:" ),
                                   p("1. At a starting point, a review is created that summarizes the available evidence to that point, and"),
                                   p("2. Subsequently, periodically updates to the literature search are made so that the review can be more current than a published static review." ),
                                   
                  ),
                  br(),
                  column(width = 5,div(img(src = "lsr1.gif", height = 320, width = 400), style="text-align: center;")
                  )),
                  hr(),
                  
                  fluidRow(column(width = 11,h4("Community Health and Animal Facilities"),
                                  br(),                
                                  p("In recent years there has been a growing concern about the effects that animal facilities could have on the health of members of nearby communities. This living systematic review aims to producers and members of communities that live near animal feeding operations accessible repository of studies. Specifically, the review question is:"),
                                  tags$blockquote("What is the association between animal feeding operations and the health events and states of individuals living near animal feeding operations but not actively engaged in livestock production?"), 
                                  p("This review does not assess the evidence that emissions from animal feeding operations are pollutants or contaminants measured on water, air or land."),
                                  p("The studies included in the living systematic review correspond to the studies included in our last systematic review published in 2017, updated with new studies identified and included in this updated version approaching the association between human health of surrounding communities and animal intensive production."),
                                  #p("Currently, we are developing the protocol that will guide the second update of the systematic review and the implementation of the living systematic review."),
                                  #hr()
                  ),
                  
                  br(),
                  #column(width = 5,div(img(src = "cafo.jpg", height = 290, width = 380),align = "center"),
                  #)
                  ),
                  #p("In this sense we have performed two systematic reviews summarizing the findings of publications investigating this topic.
                  #These previous studies can be consulted by clicking on the following links:"),
                  #p("1.", a("First Systematic Review", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")),
                  #p("2.", a("Second Systematic Review", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")),
                  hr(),
                  
                  
                  
                  column(width = 11, h4("Background to Previous Systematic Reviews and Living Systematic review"),
                         br(),
                         p("We had previously conducted and published two systematic review summarizing the findings of publications investigating this topic. These previous systematic review can be consulted by clicking on the following links:"),
                         p("1.", a("First Systematic Review", href = "https://journals.plos.org/plosone/article/authors?id=10.1371/journal.pone.0009530")),
                         p("2.", a("Second Systematic Review (First Update)", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")),       
                         #p(" For this new version, the format of the review changed to a living systematic review (LSR) approach. To implement the living systematic review approach and incorporate new methodological concepts that address the updated research question, we have developed a protocol to guide the review process, ( a("Second Systematic Review (First Update)", href = "https://systematicreviewsjournal.biomedcentral.com/articles/10.1186/s13643-017-0465-z")).,  New methodological aspects of this iteration of the included are:"),
                         
                         p("For this new version, the format of the review changed to a living systematic review (LSR) approach. To implement the living systematic review approach and incorporate new methodological concepts that address the updated research question, we have developed a protocol to guide the review process", a("(Click here to see the PROTOCOL).", href = "https://syreaf.org/wp-content/uploads/2021/08/Draft_Protocol_CAFO-3.pdf"),"New methodological aspects of this iteration of the included are:"),
                         tags$li("use of a risk-of-bias tool focused on three potential sources of bias in observational studies (confounding, selection bias, and differential information bias) to assess the internal validity in each study included."),
                         tags$li("Inclusion of health outcomes that were measured only using validated instruments."),
                         tags$li("health outcomes classification based on whether they provide the incidence of an event or the prevalence of a state."),
                         br(),
                         #tags$iframe(width="560", height="315", src="https://www.youtube.com/watch?v=WgJWrHFgh8s", frameborder="0", allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture", allowfullscreen=NA)
                         p("Only outcomes that provide an estimate of the incidence of a health event are eligible for the risk of bias assessment because the risk of bias tool is designed to assess three potential sources of bias (confounding, selection bias, and differential information bias), that only have meaning within a causal reasoning. Studies that provide incidence of a health event are intended to estimate / capture a causal effect.  Conversely, outcomes that provide an estimate of the prevalence of a health state are only capturing the burden of disease in a population and, therefore, it is unjustified assess elements involved in the causal system such as confounding."),
                         
                         hr(),
                  ),
                  
                  hr(), 
                  
                  column(width = 11, h4("What studies are included and excluded? "),
                         br(),
                         p("There are three fundamental steps in the process of doing a systematic review:"),
                         tags$li("Records are identified through search on databases. "),
                         tags$li("Titles and abstracts of the records identified previously are screened to evaluate if they are relevant."),
                         tags$li("We determine the eligibility of the records assessing the full-text article. Here, records are grouped in two sets, excluded an included. For a complete list of the records included and excluded, please go to the", actionLink("link_to_tabpanel_b", "Included Studies"), "and", actionLink("link_to_tabpanel_a", "Excluded Studies"), "tabs." ),
                         br(),
                         p("In the ", actionLink("link_to_tabpanel_c", "Studies Flowchart"),"tab a diagram illustrates the systematic review process."),
                         br(),
                  ),
                  
                  
                  hr(), 
                  
                  column(width = 11, h4("Information Sources"),
                         br(),
                         p("Electronic searches are conducted in MEDLINE®(via Web of Science) (2014 – 2023), CABI Global Health (via Web of Science) (2014 –
2023), Centre for Agricultural Biosciences (CAB) Abstracts (via Web of Science) (2014 – 2023), and Science Citation Index
(via Web of Science) (2014 – 2023). Auto-alerts were set up for each database to conduct quarterly."),
                           br(),
                  )
                  
                  
                  )
              )),
      ### Tutorial
      tabItem(tabName = "tutorial",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    title = "How to navigate through this website?",
                    fluidRow(
                      column(width = 12,h4("How to navigate the website?"),
                             br(),
                             HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/2camXephdKs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                      )
                    ),
                    br(),
                    hr(),
                    fluidRow( column(width = 12, h4("How to use the forest plot graph?"),
                                     br(),
                                     p("The reported effect measures were either odds ratio (OR) or prevalence ratio (PR). In the forest plot, 
                      each point represents the reported effect measure (e.g. an prevalence odds ratio) for a specific exposure-outcome relationship."),
                                     #p("The gray column in the forest plot’s left side, groups the exposures in four categories: distance, gases, odor and aerosols. While distance is considered as an indirect type of exposure, the other ones are considered as a direct type of exposure, since they involve direct contact with the individual."),
                                     #p(" The table on the right side shows the risk of bias assessment for the specific point selected previously on the forest plot. For further details about risk of bias assessment displayed in the table", a("click here", href = " http://help.magicapp.org/knowledgebase/articles/327941-tool-to-assess-risk-of-bias-in-cohort-studies"),".", 
                                     #   "Once you click on one a row, a table is going to pop-up to provide more details about the judgment made by the authors for that particular exposure-outcome relationship.  "),
                                     p("Once you click on one point, a table is going to pop-up to provide more details about the judgment made by the authors for that particular exposure-outcome relationship. The video below  provides more details about the usage of the forest plot and its annexes."),
                                     column(width = 12,
                                            br(),
                                            HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/vB44RpTPdO4" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                                     )
                    )),
                    br(),
                    hr(),
                    fluidRow(
                      column(width = 12,h4("How to navigate the Risk of Bias assessment?"),
                             br(),
                             HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/8RnEu8Q9PTU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                      )
                    )
                ))),
      ###Interpretation
      ### 
      tabItem(tabName = "interpretation",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    
                    fluidRow(
                      column(width = 12,
                             br(),
                             p(" Our objective was to create a \"living\" systematic review of research reports examining the connection between residing near an animal feeding operation (AFO) and community health outcomes. A \"living\" systematic review is not a static publication in a peer-reviewed journal but a review that resides on a website,  allowing for more frequent updates and easier access to information. This project is accessible at https://livestock-lsr.shinyapps.io/LivingSR/. It is updated every three months, most recently in September 2023. The January 2024 update is pending. This web-based platform is designed to provide the latest summaries of available studies to producers, public health officers, community leaders, and community members.

As part of this endeavor, we aimed to offer a balanced interpretation of the findings and their broader implications to better serve the community's needs. Our primary finding reveals that the published research in this field presents several limitations that hinder our ability to draw a conclusion regarding the association between exposure to AFOs and health outcomes. The major issues are:."),
                             br(),
                             h4("Inadequate reporting of the reason for controlling some variables"),
                             p("To determine whether exposure to emissions from AFOs leads to harmful human health
outcomes, we must account for other factors that may be associated with both the presence
of AFOs and poor health outcomes. Two such factors are the presence of medical deserts
(regions with low access to health care) and income levels. Areas where AFOs can legally be
located are often the same areas that lack medical facilities (hospitals, health clinics, etc.)
and other predictors of poor health outcomes. Deciding which factors to account for can be
complex. We used a method called a directed acyclic graph, which illustrates, based on the
best available scientific knowledge, proposed linkages between various factors and both AFO
exposure and human health. Interestingly, we discovered that the majority of studies did not
adequately explain why they controlled for certain factors, and when compared to a
previously published directed acyclic graph, they did not control for the correct factors. This
lack of clarity in reporting makes it challenging to conclude that the results represent a true
picture of the relationship between living near an AFO and community health. As for our
previous points, we have published materials on this issue to raise awareness, aiming to
encourage future studies to address this limitation and enhance the value of research
investments in this area. A detailed peer reviewed publications about this topic is available:"),
                             p(
                               "Fonseca Martinez, B. A., Sargeant, J. M., Totton, S. C., Wang, C., & O’Connor, A. M. (2026). ",
                               tags$em("Using directed acyclic graphs to assess collider and confounding bias in reviews of observational studies: an illustrative example using the impact of residential exposure to animal feeding operations on human health."),
                               ". ",
                               tags$em("Evidence-Based Toxicology"),
                               ", 4(1). DOI: ",
                               tags$a(
                                 href = "https://doi.org/10.1080/2833373X.2026.2658270",
                                 "10.1080/2833373X.2026.2658270",
                                 target = "_blank"
                               )
                             ),
                             #p("Of a total of 34 observational studies identified as relevant to the review, 15 were cross-sectional studies and 7 were case-control studies (see", actionLink("link_to_tabpanel_c", "Included Studies"), "), constituting more than half of the articles identified. In both types of study, we identified that no author group discussed the population assumptions required to enable readers to interpret the effect size as estimates of comparative incidence between two groups. For 56% of the effect sizes extracted from cross-sectional studies and 39% of the effect sizes extracted from case-control studies, the effect measure reported, in our opinion, could not have been interpreted as a metric of incidence."),
                             #p("Given the significant percentage of exposure-outcome effect sizes that, in our opinion, might be interpreted as providing estimates of incidence, authors should discuss the assumptions to support the causal interpretation of their results and help readers understand their study's contribution to a causal relationship in the body of work."),
                             br(),
                             h4("Studying prevalence instead of incidence"),
                             p("Our project's central question is, \"Do emissions from AFOs cause diseases in individuals residing nearby?\" To answer this question effectively, we need to examine new disease cases emerging in the population (incidence), rather than cases that already exist (prevalence). Analyzing factors associated with existing cases can lead to inaccurate conclusions. A notable analogy is studying the causes of new HIV/AIDS cases. Suppose a research group investigates factors related to existing cases of HIV. In that case, they might find an association with \"higher incomes\" suggesting that those with higher incomes are more likely to be HIV positive. However, it would be incorrect to conclude that higher incomes cause people to contract HIV. In reality, higher incomes likely contribute to longer survival with HIV, resulting in a higher number of cases in people with higher incomes compared to people with lower incomes. This issue is known as prevalence bias. In the context of AFOs and community health, many studies (16 out of 30) measured disease prevalence, making it challenging to determine if the duration of an \"asthma diagnosis\" is the same for individuals exposed to AFOs compared to those who are not. This question differs from investigating whether exposure to AFOs causes asthma. Fewer recent studies have attempted to address this issue by focusing on the acute incidence of diseases, such as the number of hospitalizations due to asthma in the past year. A detailed peer reviewed publications about this topic is available:"),
                             p(
                               "Martinez, B. A. F., Sargeant, J. M., Totton, S. C., Wang, C., & O’Connor, A. M. (2026). ",
                               tags$em("Reporting of structural population assumptions in prevalence-based studies of animal feeding operations and community health."),
                               " ",
                               tags$em("Frontiers in Public Health"),
                               ", 14:1815580. DOI: ",
                               tags$a(
                                 href = "https://doi.org/10.3389/fpubh.2026.1815580",
                                 "10.3389/fpubh.2026.1815580",
                                 target = "_blank"
                               )
                             ),
                             br(),
                             h4("Inconsistency in measures of exposure to AFOs"),
                             p("It's essential to understand that when we assert that factor A causes outcome B, we assume A always leads to B, much like turning on a light switch always illuminates a light bulb. However, in the case of AFOs and human disease, achieving a single consistent exposure has proven challenging in current studies. Current research employs four broad measures of exposure: distance of a person's residence from the AFO, density of AFOs in the area, odor from AFOs, and emissions from AFOs (e.g., sulfur, ammonia, and particulate matter), and imputed estimates based on a combination of distance, wind patterns, and emissions. This inconsistency in exposure measurement hinders our ability to conclude causation. For example, exposure to emissions at 5 kilometers upwind of a farm may differ from exposure at the same distance downwind. Consequently, we cannot accurately assess the magnitude of the impact of an AFO on community health, i.e., whether the association is strong, weak, or non-existent. Understanding the size of an effect is crucial for policy decisions, as they involve balancing benefits and harms. Currently, we have prepared manuscripts on this topic to raise awareness of this limitation, in hopes that future studies will address it, maximizing the value of investments in research on this subject. A detailed peer reviewed publications about this
topic is in preparation. "),
                            #p("Observational studies are traditionally considered to have potential limitations with respect to the ability to infer causal relations due to concerns about internal validity. Compared to randomized controlled trials, observational studies are more subject to three potential sources of bias: confounding, selection bias and information bias"),
                             
                             #p("Confounding is considered as the main bias of observational studies because without random assignment, exposure groups may differ with respect to factors other than exposure 37. Information bias, also called measurement bias, occurs when key information about exposure or outcome is either measured or collected mistakenly. Another key component where measurement is important is the assumption of consistency, a condition necessary along with exchangeability and positivity to establish causal inferences."),
                             #p("To evaluate confounding and measurement bias, we limited the study population to studies that
#estimated a metric of incidence. For confounding bias, we identify the type of effect estimated, the rationale for selecting confounders and the statistical methods used to control confounding. Similarly, we mapped on Directed acyclic graphs (DAGs) the set of variables reported in studies addressing lower airway outcomes to determine the type of effect estimated, remaining pathways of bias, and other biases. For information bias, we identified and extracted the metrics used to measure the exposure and the outcome and data sources used to derive these metrics. We evaluated the temporal relationship between measurement of the outcome and exposure. The consistency of the exposure measurement was analyzed in the extracted metrics.
#"),
                             #p("Seventeen relevant studies could have estimated metrics of incidence (see" , actionLink("link_to_tabpanel_c", "Included Studies"), ", column Incidence Estimates).Three studies included the rationale for the set of variables selected as confounders and the rationale for retention as confounders. Fifteen studies employed logistic regression suggesting they were investigating a causal relationship. No paper provided a DAG or causal pathway that supported the adjustment set included in the models. Among the studies addressing lower respiratory tract conditions, no study could estimate either the direct effect or the total effect of residential exposure to AFOs. For six studies, the major concern was the adjustment for a collider variable (smoking). For another four, failure to adjust for important confounding variables such as socioeconomic status or education meant biasing pathways remained open."),
                             #p("Measurements of exposure based on AFOs density, measurement of direct emissions, distance from home to AFOs, dispersion models and perceived odor in the home were the measures used by the authors. Health outcomes were grouped based on the anatomical system affected. Lower respiratory conditions and gastrointestinal conditions were the most commonly investigated and the main sources of information were medical records, questionnaires, and mortality records. Findings regarding the temporal relationship between exposure and outcome were mixed, with studies where it was possible to infer measurement of exposure before the outcomes, studies that assessed exposure and outcome concurrently, and others where lack of reporting prevented temporality inferences. None of the measures of exposure captured an individual exposure to a metric of AFOs exposure such as personal exposure to ammonia levels. The authors did not discuss the consistency assumption."),
                             #p("We conclude that confounding may prevent drawing causal conclusions in studies approaching lower respiratory outcomes, as the sole use of multivariate models, without exhaustive analysis for the selection, identification and retention of confounding variables using tools such as DAGs, might not capture the full spectrum of bias and on the contrary, it could generate biased estimates due to the adjustment of colliders, mediators and unnecessary adjustment of confounding variables."),
                             #p("Accurately assessing exposure to AFOs represents a methodological challenge due to the nature of the environmental contaminants involved, the instability of the levels over time, and the multiple pathways through which AFOs could affect people's health. The extensive use of proxy measures, such as distance and density of farms, which are measured only once and without considering exposure time of the subjects, may not appropriately reflect cumulative and dynamic exposure to intensive farms, impacting the causal interpretation of the body of work. Lack of the consistency in exposure measures could make it difficult to synthetize the evidence and draw causal conclusions.")
                             
                      )
                    ),
                    br(),
                    hr(),
            
                ))),
      
      
      
      ######
      
      tabItem(tabName = "glossary",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Glossary",
                    br(),
                    #actionLink("link_to_tabpanel_b", "Link to panel B_prueba perro"),
                    tags$li(tags$strong("Effect size:"), "A statistical concept that measures the strength of the relationship between two variables on a numeric scale.  For instance, if we have data on the height of men and women and we notice that, on average, men are taller than women, the difference between the height of men and the height of women is known as the effect size.  The greater the effect size, the greater the height difference between men and women."),
                    tags$li(tags$strong("Risk Ratio:"), "The risk ratio is the risk of the outcome among exposed
subjects divided by the risk of the outcome among unexposed
subjects (Knol et al 2010). The risk ratio is
sometimes referred to as the relative risk or cumulative incidence ratio."),
                    tags$li(tags$strong("Rate Ratio:"), "The rate ratio is the number of exposed people with
the outcome divided by the person-years of observation
in that group divided by the number of unexposed people
with the outcome divided by the person-years of observation
in that group (Knol et al 2010). The rate ratio is
sometimes referred to as the incidence rate or incidence density ratio."),
                    tags$li(tags$strong("Odds ratio:"), "The odds ratio is the odds of exposure (i.e, the number of
subjects exposed divided by the number of subjects not exposed) in the cases divided by the odds of
exposure in the controls. (Knol et al 2010)."),
                    
                    tags$li(tags$strong("Exposure:"), "The exposure variable is the variable that you predict will have an effect on the outcome variable, so, during your study, you will alter the exposure variable to measure what changes occur in the outcome variable."),
                    tags$li(tags$strong("Forest Plot:"), "A graph that compares several clinical or scientific studies studying the same thing. Originally developed for meta-analysis of randomized controlled trials, the forest plot is now also used for a variety of observational studies. It’s called a forest plot because of the forest of lines it produces (Lewis & Clarke, 2001)."
                            ,"Forest plots are a fairly recent invention and have only been around for a couple of decades. They play an important role in identifying beneficial drugs, procedures or other interventions that can save lives. These charts allow us to look at all of the available information, not just cherry-pick the results we like the look of (Goldacre, 2014)."),
                    tags$li(tags$strong("Outcome:"), "Outcomes (also called events or endpoints) are variables that are monitored during a study to document the impact that a given intervention or exposure has on the health of a given population. (Ferreira, J. C., & Patino, C. M. (2017)"),
                    tags$li(tags$strong("Risk of bias assessment:"), "It is one of the critical steps of a systematic review carried out in all citations passing relevance screening. Interpretation of the results reported in the primary studies depends on the design, conduct, analyses (internal validity), population, interventions and outcomes (external validity). Including an evaluation of the risk of bias in the primary studies allows a consideration of the risk of bias when interpreting the results of the review (Centre for Reviews and Dissemination (CRD), 2008; Higgins and Green, 2011)"),
                    tags$li(tags$strong("Systematic review:"), "Review that “identify, appraise and synthesize all the empirical
evidence that meets pre-specified eligibility criteria to answer a
specific research question.They use explicit, systematic methods
that are selected with a view aimed at minimizing bias, to produce
more reliable findings to inform decision making” (https://www.
cochranelibrary.com/about/about-cochrane-reviews)."),
                    br()
                    
                )
              )),
      
      ## about the studies ####
      tabItem(tabName = "eda",
              #fluidRow(
              # box(width = 12,
              #    h4("Brief Summary"),
              #   p("The literture about human health impacts of living near production animals is quite limited. In the last review, our team identified 16 studies consisting of 10 study populations to include in the analysis.
              #    Those 16 studies were conducted in only three countries. The health outcomes were lower and upper respiratory tracts, antibiotic resistance, other infectious disease, neurological, 
              #        psychological, dermatological, otologic, ocular, gastrointestinal, stress and mood, and other non-infectious health outcomes."),
              #    #column(width = 12,
              #    checkboxInput("chk", label = "Brief studies: ", value = T),
              #    useShinyjs(),
              #    box(width = 12, DT::dataTableOutput("mytable1234"))
              
              #    )),
              #  hr(),
              fluidRow(
                box(width = 12,
                    br(),
                    h4("About the studies"),
                    br(),
                    div(textOutput ("selected_var"), style="font-size: 16px; font-family: Source Sans Pro"),
                    
                    br(),
                    #p("Please click the following check box to visualize titles, year of publication and origin of the studies included. "),
                    p("Please click the next titles to view either the geographic location or timeline of the studies included"),
                    
                    #column(width = 12,
                    #checkboxInput("chk", label = "Hide table ", value = T),
                    #useShinyjs(),
                    #box(width = 12, DT::dataTableOutput("mytable1234")),
                    #DT::dataTableOutput("mytable1234"),
                    hr(),
                    #h4("Description "),
                    #p("By clicking the following tabs, you can see the geographical distribution, a publication timeline and the health outcomes approached in each of the 16 studies included."),
                    radioGroupButtons(
                      inputId = "eda_btn", justified = T, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Geographic Location of All Studies` = "sp", 
                                  `<i class='fa fa-calendar-alt'></i> Timeline of All Studies` = "ts")# INCLUDE IN CASE OF NEED OUTCOMES OF ALL STUDIES, 
                      # `<i class='fa fa-poll'></i> Health Outcome of all studies` = "coef")#,
                      #`<i class='fa fa-file-text'></i> All Studies  ` = "tabl"),
                    ),
                    
                    uiOutput("eda_text"),
                    uiOutput("eda_plot")
                    
                )
              )
      ),
      
      ### ROSES flow chart
      tabItem(tabName = "roses",
              fluidRow(
                box(width = 12,
                    br(),
                    h4("Studies Flowchart"),
                    br(),
                    p("This page provides information on the flow of information through the different phases of the review as well as a timeline with the number of studies identified each time a review update is made."),
                    #p("There was no consistent evidence of an association between exposure to animal facilities and lower respiratory tract outcomes, except when the level of odor annoyance was used as the measure of exposure."),
                    radioGroupButtons(
                      inputId = "flow_btn", justified = T, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Flow of Information` = "sp",
                                  `<i class='fa fa-calendar-alt'></i> Timelime Relevant Studies` = "ts"
                      )
                    ),
                    uiOutput("flow_intro_text"),
                    uiOutput("flow_intro_plot")
                )
              )
      ),
      
      ## low respiratory ####
      ## * introduction ####
      tabItem(tabName = "low_rsp_intro",
              fluidRow(
                box(width = 12,
                    br(),
                    h4("About the studies for Lower Respiratory outcomes"),
                    br(),
                    p("This page provides the basic descriptive information of studies included in the living systematic review that report lower respiratory outcomes. The geographical distribution and the date of publications of the studied populations are visualized in the graphics provided."),
                    #p("There was no consistent evidence of an association between exposure to animal facilities and lower respiratory tract outcomes, except when the level of odor annoyance was used as the measure of exposure."),
                    radioGroupButtons(
                      inputId = "low_res_btn", justified = T, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Geographic Distribution of Lower Respiratory Outcomes` = "sp",
                                  `<i class='fa fa-calendar-alt'></i> Timeline of Lower Respiratory Outcomes` = "ts",
                                  `<i class='fa fa-poll'></i> Outcomes Categorized as Lower Respiratory` = "coef"
                      )
                    ),
                    uiOutput("low_res_intro_text"),
                    uiOutput("low_res_intro_plot")
                )
              )
      ),
      
      tabItem(tabName = "up_rsp_intro",
              fluidRow(
                box(width = 12,
                    br(),
                    h4("About the studies for Upper Respiratory outcomes"),
                    br(),
                    p("This page provides the basic descriptive information of studies included in the living systematic review that report upper respiratory outcomes. The geographical distribution and the date of publications of the studied populations are visualized in the graphics provided."),
                    p(div(textOutput ("upper_pairs"), style="font-size: 16px; font-family: Source Sans Pro")),
                    br(),
                    radioGroupButtons(
                      inputId = "up_res_btn", justified = T, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Geographic Distribution of Upper Respiratory Outcomes` = "sp",
                                  `<i class='fa fa-calendar-alt'></i> Timeline of Upper Respiratory Outcomes` = "ts",
                                  `<i class='fa fa-poll'></i> Outcomes Categorized as Upper Respiratory` = "coef"
                      )
                    ),
                    uiOutput("up_res_intro_text"),
                    uiOutput("up_res_intro_plot")
                )
              )
      ),
      
      tabItem(tabName = "ar_rsp_intro",
              fluidRow(
                box(width = 12,
                    br(),
                    h4("About the studies for Antimicrobial Resistance outcomes"),
                    br(),
                    p("This page provides the basic descriptive information of studies included in the living systematic review that report antimicrobial resistance outcomes. The geographical distribution and the date of publications of the studied populations are visualized in the graphics provided."),
                    radioGroupButtons(
                      inputId = "ar_res_btn", justified = T, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Geographic Distribution of AMR Outcomes` = "sp",
                                  `<i class='fa fa-calendar-alt'></i> Timeline of AMR Outcomes` = "ts",
                                  `<i class='fa fa-poll'></i> Outcomes Categorized as AMR` = "coef"
                      )
                    ),
                    uiOutput("ar_res_intro_text"),
                    uiOutput("ar_res_intro_plot")
                )
              )
      ),
      
      tabItem(tabName = "ic_rsp_intro",
              fluidRow(
                box(width = 12,
                    br(),
                    h4("About the studies for Infectious outcomes"),
                    br(),
                    p("This page provides the basic descriptive information of studies included in the living systematic review that report infectious conditions. The geographical distribution and the date of publications of the studied populations are visualized in the graphics provided."),
                    radioGroupButtons(
                      inputId = "ic_res_btn", justified = T, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Geographic Distribution of Infectious conditions Outcomes` = "sp",
                                  `<i class='fa fa-calendar-alt'></i> Timeline of Infectious Conditions Outcomes` = "ts",
                                  `<i class='fa fa-poll'></i> Outcomes Categorized as Infectious Conditions` = "coef"
                      )
                    ),
                    uiOutput("ic_res_intro_text"),
                    uiOutput("ic_res_intro_plot")
                )
              )
      ),
      
      tabItem(tabName = "gi_rsp_intro",
              fluidRow(
                box(width = 12,
                    br(),
                    h4("About the studies for Gastrointestinal outcomes"),
                    br(),
                    p("This page provides the basic descriptive information of studies included in the living systematic review that report gastrointestinal conditions. The geographical distribution and the date of publications of the studied populations are visualized in the graphics provided."),
                    
                    radioGroupButtons(
                      inputId = "gi_res_btn", justified = T, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Geographic Distribution of Gastrointestinal Outcomes` = "sp",
                                  `<i class='fa fa-calendar-alt'></i> Timeline of Gastrointestinal Outcomes` = "ts",
                                  `<i class='fa fa-poll'></i> Outcomes Categorized as Gastrointestinal diseases` = "coef"
                      )
                    ),
                    uiOutput("gi_res_intro_text"),
                    uiOutput("gi_res_intro_plot")
                )
              )
      ),
      
      tabItem(tabName = "Neur_rsp_intro",
              fluidRow(
                box(width = 12,
                    p("Neurological diseases were addressed in three publications where headache and dizziness were the most analyzed responses."),
                    
                    radioGroupButtons(
                      inputId = "Neur_res_btn", justified = F, label = "",
                      choices = c(`<i class='fa fa-globe'></i> Geographic Distribution of Neurologic Outcomes` = "sp",
                                  `<i class='fa fa-calendar-alt'></i> Timeline of Neurologic Outcomes` = "ts",
                                  `<i class='fa fa-poll'></i> Outcomes Categorized as Neurological diseases` = "coef")
                    ),
                    uiOutput("Neur_res_intro_text"),
                    uiOutput("Neur_res_intro_plot")
                )
              )
      ),
      
      ## * forest plot ####
      
      
      tabItem(tabName = "low_rsp_forest",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Incidence Estimates",
                    br(),
                    #p("As a novelty in this updated review, health outcomes are categorized either as incident events or states based on whether the studies involved observing the incidence of an event or the prevalence of a state (Pearce 2012). Therefore, the effect measure for each outcome-exposure pair is presented in either a prevalent or incidence forest plot. Keep in mind that only outcomes classified as incidence of an event are eligible for risk-of-bias assessment.   "),
                    #p("Please select an effect size from the drop-down menus below. With these data we are looking at the incidence of a health outcome i.e. how common a health event is in a population. We compare incidence of the health outcome by either the incidence risk ratio (IRR), Incidence rate ratio or the incidence odds ratio (OR)."),
                    p("Observational study designs can be conducted to estimate the incidence of health 
                      events or the prevalence of health events. This forest plot summarizes information 
                      about incidence events. To determine if exposure to animal feeding operations is 
                      associated with community health, authors calculate the incidence density ratio (IRR), 
                      incidence risk ratio (IRR), or the incidence odds ratio (IOR). These ratios are called 
                      effect size measures. Below you can pick these effect size measures, and forest plots 
                      will show the associations reported. IDR, IRR, and IOR more than one suggests that the 
                      incidence of the health event occurs more in communities nearer to animal feeding operations. 
                      These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty. "),
                    p("What is measured by a study (incidence or prevalence) is a function of study design. For example, 
                      cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control 
                      designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) 
                      and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). 
                      Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions provide an 
                      estimate of the prevalence of the health state. Readers interested in this topic are directed to the original manuscripts. 
                      Health outcomes from cross-sectional studies that do not meet any of the previous conditions are considered a providing 
                      estimate of the prevalence of the health state. "),
                    p("For Effect size measures >1, there are more incident cases"),
                    p("For Effect size measures <1, there are less incident cases"),
                    br(),
                    fluidRow(
                      
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_low_outcome")
                             )),
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_low_exposure")
                             )),
                      
                      
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_low")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_low_susi")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_low_susi_country")
                             )),
                      
                      
                      infoBoxOutput("out12_low")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12, 
                             h4("Select a point: "),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_low",height="auto"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                    )                    
                )
                
                
                
              )    
              
      ),  
      
      
      tabItem(tabName = "up_rsp_forest",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Incidence Estimates",
                    br(),
                    #p("As a novelty in this updated review, health outcomes are categorized either as incident events or states based on whether the studies involved observing the incidence of an event or the prevalence of a state (Pearce 2012). Therefore, the effect measure for each outcome-exposure pair is presented in either a prevalent or incidence forest plot. Keep in mind that only outcomes classified as incidence of an event are eligible for risk-of-bias assessment.   "),
                    
                    #p("Please select an effect size from the drop-down menus below. With these data we are looking at the incidence of a health outcome i.e. how common a health event is in a population. We compare incidence of the health outcome by either the incidence risk ratio (IRR), Incidence rate ratio or the incidence odds ratio (OR)."),
                    p("Observational study designs can be conducted to estimate the incidence of health 
                      events or the prevalence of health events. This forest plot summarizes information 
                      about incidence events. To determine if exposure to animal feeding operations is 
                      associated with community health, authors calculate the incidence density ratio (IRR), 
                      incidence risk ratio (IRR), or the incidence odds ratio (IOR). These ratios are called 
                      effect size measures. Below you can pick these effect size measures, and forest plots 
                      will show the associations reported. IDR, IRR, and IOR more than one suggests that the 
                      incidence of the health event occurs more in communities nearer to animal feeding operations. 
                      These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty. "),
                    p("What is measured by a study (incidence or prevalence) is a function of study design. For example, 
                      cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control 
                      designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) 
                      and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). 
                      Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions provide an 
                      estimate of the prevalence of the health state. Readers interested in this topic are directed to the original manuscripts. 
                      Health outcomes from cross-sectional studies that do not meet any of the previous conditions are considered a providing 
                      estimate of the prevalence of the health state. "),
                    p("For Effect size measures >1, there are more incident cases"),
                    p("For Effect size measures <1, there are less incident cases"),
                    
                    
                    br(),
                    fluidRow(
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_up_outcome")
                             )),
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_up_exposure")
                             )),
                      
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_up")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_up_susi")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_up_susi_country")
                             )),
                      
                      
                      #  column(width = 4,
                      # wellPanel(
                      #  uiOutput("expo_var_2_up")
                      # )),
                      infoBoxOutput("out12")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12,
                             h4("Select a point: "),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_up",height="auto"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                    )                    
                )
                
                
                
              )    
              
      ),  
      
      
      
      tabItem(tabName = "low_rsp_forest_state",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Prevalence Estimates",
                    br(),
                    p("Observational study designs can be conducted to estimate the incidence of health events or the prevalence of health events. This forest plot summarizes information about prevalent disease. Prevalence measures the burden of disease in a community. To compare the burden of disease in a community, the authors calculate a prevalence ratio (PR) or prevalence odds ratio- these ratios are called effect size measures. Below you can pick these measures, and forest plots will show the associations reported. PR and POR estimates of more than one suggest that the health event's incidence occurs more in communities nearer to animal feeding operations. These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty."),
                    p("What is measured by a study (incidence or prevalence) is a function of study design. For example, cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions estimate health state prevalence. Readers interested in this topic are directed to the original manuscripts."),
                    p("For Effect size measures >1, there are more prevalent cases"),
                    p("For Effect size measures <1, there are less prevalent cases"),

                    br(),
                    fluidRow(
                      
                      
                      
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_low_state_outcome")
                             )),
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_low_state_exposure")
                             )),
                      
                      
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_low_state")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_low_state_susi")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_low_state_susi_country")
                             )),
                      
                      #  column(width = 4,
                      # wellPanel(
                      #  uiOutput("expo_var_2_up")
                      # )),
                      #infoBoxOutput("out12")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12,
                             h4(""),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_low_state",height="auto"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                    )                    
                )
                
                
                
              )    
              
      ),  
      
      
      tabItem(tabName = "up_rsp_forest_state",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Prevalence Estimates",
                    br(),
                    p("Observational study designs can be conducted to estimate the incidence of health events or the prevalence of health events. This forest plot summarizes information about prevalent disease. Prevalence measures the burden of disease in a community. To compare the burden of disease in a community, the authors calculate a prevalence ratio (PR) or prevalence odds ratio- these ratios are called effect size measures. Below you can pick these measures, and forest plots will show the associations reported. PR and POR estimates of more than one suggest that the health event's incidence occurs more in communities nearer to animal feeding operations. These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty."),
                    p("What is measured by a study (incidence or prevalence) is a function of study design. For example, cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions estimate health state prevalence. Readers interested in this topic are directed to the original manuscripts."),
                    p("For Effect size measures >1, there are more prevalent cases"),
                    p("For Effect size measures <1, there are less prevalent cases"),

                    br(),
                    fluidRow(
                      
                      column(width = 4,
                             wellPanel(
                               uiOutput("expo_var_1_up_state")
                             )),
                      
                      #  column(width = 4,
                      # wellPanel(
                      #  uiOutput("expo_var_2_up")
                      # )),
                      #infoBoxOutput("out12")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12,
                             h4(""),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_up_state"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                    )                    
                )
                
                
                
              )    
              
      ),  
      
      tabItem(tabName = "ar_rsp_forest_state",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Prevalence Estimates",
                    br(),
                    p("Observational study designs can be conducted to estimate the incidence of health events or the prevalence of health events. This forest plot summarizes information about prevalent disease. Prevalence measures the burden of disease in a community. To compare the burden of disease in a community, the authors calculate a prevalence ratio (PR) or prevalence odds ratio- these ratios are called effect size measures. Below you can pick these measures, and forest plots will show the associations reported. PR and POR estimates of more than one suggest that the health event's incidence occurs more in communities nearer to animal feeding operations. These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty."),
                    p("What is measured by a study (incidence or prevalence) is a function of study design. For example, cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions estimate health state prevalence. Readers interested in this topic are directed to the original manuscripts."),
                    p("For Effect size measures >1, there are more prevalent cases"),
                    p("For Effect size measures <1, there are less prevalent cases"),

                    br(),
                    fluidRow(
                      
                      column(width = 4,
                             wellPanel(
                               uiOutput("expo_var_1_ar_state")
                             )),
                      
                      #  column(width = 4,
                      # wellPanel(
                      #  uiOutput("expo_var_2_up")
                      # )),
                      #infoBoxOutput("out12")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12,
                             h4(""),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_ar_state"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                    )                    
                )
                
                
                
              )    
              
      ),  
      
      
      
      tabItem(tabName = "gi_rsp_forest_state",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Prevalence Estiamtes",
                    br(),
                    p("Observational study designs can be conducted to estimate the incidence of health events or the prevalence of health events. This forest plot summarizes information about prevalent disease. Prevalence measures the burden of disease in a community. To compare the burden of disease in a community, the authors calculate a prevalence ratio (PR) or prevalence odds ratio- these ratios are called effect size measures. Below you can pick these measures, and forest plots will show the associations reported. PR and POR estimates of more than one suggest that the health event's incidence occurs more in communities nearer to animal feeding operations. These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty."),
                    p("What is measured by a study (incidence or prevalence) is a function of study design. For example, cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions estimate health state prevalence. Readers interested in this topic are directed to the original manuscripts."),
                    p("For Effect size measures >1, there are more prevalent cases"),
                    p("For Effect size measures <1, there are less prevalent cases"),
                    br(),
                    fluidRow(
                      
                      column(width = 4,
                             wellPanel(
                               uiOutput("expo_var_1_gi_state")
                             )),
                      
                      #  column(width = 4,
                      # wellPanel(
                      #  uiOutput("expo_var_2_up")
                      # )),
                      #infoBoxOutput("out12")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12,
                             h4("Select a point:"),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_gi_state"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                    )                    
                )
                
                
                
              )    
              
      ),
      
      
      
      tabItem(tabName = "ic_rsp_forest_state",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Prevalence Estimates",
                    br(),
                    #p("As a novelty in this updated review, health outcomes are categorized either as incident events or states based on whether the studies involved observing the incidence of an event or the prevalence of a state (Pearce 2012). Therefore, the effect measure for each outcome-exposure pair is presented in either a prevalent or incidence forest plot. Keep in mind that only outcomes classified as incidence of an event are eligible for risk-of-bias assessment.   "),
                    
                    #p("Please select an effect size and a type of exposure from the drop-down menus below. With these data we are looking at the prevalence of a health outcome i.e. how common a health state is in a population. We compare prevalence of the health outcome by either the prevalence ratio (PR) or the prevalence odds ratio (OR).

#"),
                    p("Observational study designs can be conducted to estimate the incidence of health events or the prevalence of health events. This forest plot summarizes information about prevalent disease. Prevalence measures the burden of disease in a community. To compare the burden of disease in a community, the authors calculate a prevalence ratio (PR) or prevalence odds ratio- these ratios are called effect size measures. Below you can pick these measures, and forest plots will show the associations reported. PR and POR estimates of more than one suggest that the health event's incidence occurs more in communities nearer to animal feeding operations. These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty."),
p("What is measured by a study (incidence or prevalence) is a function of study design. For example, cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions estimate health state prevalence. Readers interested in this topic are directed to the original manuscripts."),
p("For Effect size measures >1, there are more prevalent cases"),
p("For Effect size measures <1, there are less prevalent cases"),
                    br(),
                    fluidRow(
                      
                      column(width = 4,
                             wellPanel(
                               uiOutput("expo_var_1_ic_state")
                             )),
                      
                      #  column(width = 4,
                      # wellPanel(
                      #  uiOutput("expo_var_2_up")
                      # )),
                      #infoBoxOutput("out12")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12,
                             
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_ic_state"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                    )                    
                )
                
                
                
              )    
              
      ),
      
      tabItem(tabName = "ar_rsp_forest",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Incidence Estimates",
                    br(),
                    #p("As a novelty in this updated review, health outcomes are categorized either as incident events or states based on whether the studies involved observing the incidence of an event or the prevalence of a state (Pearce 2012). Therefore, the effect measure for each outcome-exposure pair is presented in either a prevalent or incidence forest plot. Keep in mind that only outcomes classified as incidence of an event are eligible for risk-of-bias assessment.   "),
                    
                    #p("Please select an effect size from the drop-down menus below. With these data we are looking at the incidence of a health outcome i.e. how common a health event is in a population. We compare incidence of the health outcome by either the incidence risk ratio (IRR), Incidence rate ratio or the incidence odds ratio (OR)."),
                    p("Observational study designs can be conducted to estimate the incidence of health 
                      events or the prevalence of health events. This forest plot summarizes information 
                      about incidence events. To determine if exposure to animal feeding operations is 
                      associated with community health, authors calculate the incidence density ratio (IRR), 
                      incidence risk ratio (IRR), or the incidence odds ratio (IOR). These ratios are called 
                      effect size measures. Below you can pick these effect size measures, and forest plots 
                      will show the associations reported. IDR, IRR, and IOR more than one suggests that the 
                      incidence of the health event occurs more in communities nearer to animal feeding operations. 
                      These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty. "),
                    p("What is measured by a study (incidence or prevalence) is a function of study design. For example, 
                      cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control 
                      designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) 
                      and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). 
                      Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions provide an 
                      estimate of the prevalence of the health state. Readers interested in this topic are directed to the original manuscripts. 
                      Health outcomes from cross-sectional studies that do not meet any of the previous conditions are considered a providing 
                      estimate of the prevalence of the health state. "),
                    p("For Effect size measures >1, there are more incident cases"),
                    p("For Effect size measures <1, there are less incident cases"),
                    
                    
                    br(),
                    fluidRow(
                      
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_ar_outcome")
                             )),
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_ar_exposure")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_ar")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_ar_susi")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_ar_susi_country")
                             )),
                      
                      
                      infoBoxOutput("out12_ar")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12,
                             h4("Select a point: "),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_ar",height="auto"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                      
                    )                    
                )
                
                
                
              )    
              
      ),  
      
      
      tabItem(tabName = "gi_rsp_forest",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Incidence Estimates",
                    br(),
                    #p("As a novelty in this updated review, health outcomes are categorized either as incident events or states based on whether the studies involved observing the incidence of an event or the prevalence of a state (Pearce 2012). Therefore, the effect measure for each outcome-exposure pair is presented in either a prevalent or incidence forest plot. Keep in mind that only outcomes classified as incidence of an event are eligible for risk-of-bias assessment.   "),
                    
                    #p("Please select an effect size from the drop-down menus below. With these data we are looking at the incidence of a health outcome i.e. how common a health event is in a population. We compare incidence of the health outcome by either the incidence risk ratio (IRR), Incidence rate ratio or the incidence odds ratio (OR)."),
                    p("Observational study designs can be conducted to estimate the incidence of health 
                      events or the prevalence of health events. This forest plot summarizes information 
                      about incidence events. To determine if exposure to animal feeding operations is 
                      associated with community health, authors calculate the incidence density ratio (IRR), 
                      incidence risk ratio (IRR), or the incidence odds ratio (IOR). These ratios are called 
                      effect size measures. Below you can pick these effect size measures, and forest plots 
                      will show the associations reported. IDR, IRR, and IOR more than one suggests that the 
                      incidence of the health event occurs more in communities nearer to animal feeding operations. 
                      These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty. "),
                    p("What is measured by a study (incidence or prevalence) is a function of study design. For example, 
                      cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control 
                      designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) 
                      and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). 
                      Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions provide an 
                      estimate of the prevalence of the health state. Readers interested in this topic are directed to the original manuscripts. 
                      Health outcomes from cross-sectional studies that do not meet any of the previous conditions are considered a providing 
                      estimate of the prevalence of the health state. "),
                    p("For Effect size measures >1, there are more incident cases"),
                    p("For Effect size measures <1, there are less incident cases"),
                    
                    
                    br(),
                    fluidRow(
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_gi_outcome")
                             )),
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_gi_exposure")
                             )),
                      
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_gi")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_gi_susi")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_gi_susi_country")
                             )),
                      
                      
                      
                      infoBoxOutput("out12_gi")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12,
                             h4("Select a point: "),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_gi",height="auto"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                      
                    )                    
                )
                
                
                
              )    
              
      ),  
      
      tabItem(tabName = "ic_rsp_forest",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    br(),
                    title = "Forest Plot of Incidence Estimates",
                    br(),
                    #p("As a novelty in this updated review, health outcomes are categorized either as incident events or states based on whether the studies involved observing the incidence of an event or the prevalence of a state (Pearce 2012). Therefore, the effect measure for each outcome-exposure pair is presented in either a prevalent or incidence forest plot. Keep in mind that only outcomes classified as incidence of an event are eligible for risk-of-bias assessment.   "),
                    
                    #p("Please select an effect size from the drop-down menus below. With these data we are looking at the incidence of a health outcome i.e. how common a health event is in a population. We compare incidence of the health outcome by either the incidence risk ratio (IRR), Incidence rate ratio or the incidence odds ratio (OR)."),
                    p("Observational study designs can be conducted to estimate the incidence of health 
                      events or the prevalence of health events. This forest plot summarizes information 
                      about incidence events. To determine if exposure to animal feeding operations is 
                      associated with community health, authors calculate the incidence density ratio (IRR), 
                      incidence risk ratio (IRR), or the incidence odds ratio (IOR). These ratios are called 
                      effect size measures. Below you can pick these effect size measures, and forest plots 
                      will show the associations reported. IDR, IRR, and IOR more than one suggests that the 
                      incidence of the health event occurs more in communities nearer to animal feeding operations. 
                      These measures are uncertain, and the horizontal line on the forest plot indicates that uncertainty. "),
                    p("What is measured by a study (incidence or prevalence) is a function of study design. For example, 
                      cohort studies provide direct estimates of incidence events. Under certain assumptions, nested case-control 
                      designs (case-cohort studies, incidence density case-control studies and survivor-based case-control studies) 
                      and cross-sectional studies can also compare incidence. (Vandenbroucke et al 2012, Pearce 2004 and Reichenheim et al 2010). 
                      Health outcomes from cross-sectional studies or case-control studies that do not meet any of the assumptions provide an 
                      estimate of the prevalence of the health state. Readers interested in this topic are directed to the original manuscripts. 
                      Health outcomes from cross-sectional studies that do not meet any of the previous conditions are considered a providing 
                      estimate of the prevalence of the health state. "),
                    p("For Effect size measures >1, there are more incident cases"),
                    p("For Effect size measures <1, there are less incident cases"),
                    
                    
                    br(),
                    fluidRow(
                      
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_ic_outcome")
                             )),
                      column(width = 3,
                             wellPanel(
                               uiOutput("expo_var_1_ic_exposure")
                             )),
                      
                      
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_ic")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_ic_susi")
                             )),
                      column(width = 2,
                             wellPanel(
                               uiOutput("expo_var_1_ic_susi_country")
                             )),
                      
                      
                      infoBoxOutput("out12_ic")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 12, div(style = "height:20px"),
                             h4("Select a point: "),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_ic",height="auto"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      )
                      
                    )                    
                )
                
                
                
              )    
              
      ),  
      
      
      tabItem(tabName = "Neur_rsp_forest",
              fluidRow(
                box(width = 12, solidHeader = T, status = "primary",
                    title = "Forest Plot",
                    p("Please select an effect size and a type of exposure from the drop-down menus below."),
                    br(),
                    fluidRow(
                      
                      column(width = 4,
                             wellPanel(
                               uiOutput("expo_var_1_Neur")
                             )),
                      
                      column(width = 4,
                             wellPanel(
                               uiOutput("expo_var_2_Neur")
                             )),
                      infoBoxOutput("out12_Neur")
                      
                      
                    ),
                    
                    hr(),
                    fluidRow(
                      column(width = 5,
                             h4("Select a point: "),
                             #actionButton("reset", label = "Reset selection"),
                             ggiraph::girafeOutput("plot_Neur",height="auto"),
                             
                      ),
                      tags$head(
                        tags$style(type = "text/css",
                                   HTML("th { text-align: center; }")
                        )
                      ),
                      column(width = 7,
                             
                             h4("Selected outcome-exposure"),
                             
                             div(dataTableOutput("my_table_Neur"),style = "font-size: 65%; width: 40%;text-align: center",
                             )
                             
                             
                      )
                    )                    
                )
                
                
                
              )    
              
      ),
      
      
      
      
      ## * risk of bias ####
      tabItem(tabName = "low_rsp_risk_of_bias",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Risk of Bias for Lower Respiratory Diseases",
                    #p("Risk of Bias plot"),
                    br(),
                    p(div(textOutput ("lower_rob_text"), style="font-size: 16px; font-family: Source Sans Pro")),
                    br(),
                    #plotOutput("bias") %>% withSpinner(),
                    plotlyOutput("bias"),
                    br(),
                    div(img(src = "ROB_question_1.PNG", height = 330, width = 760), style="text-align: center;"),
                    br(),
                    p("Three potential sources of bias, confounding, selection bias, and information bias, were assessed in each health outcome present in each study included. "),
                    tags$li("Confounding is the distortion of the association between an exposure and health outcome by an extraneous, third variable called a confounder. To be a potential confounder, the variable must be statistically associated with the exposure and the outcome, and must not be on the causal pathway i.e., not being a mediator. An example of confounding: When examining the relationship between CAFOs (exposure) and asthma (health outcome), socioeconomic status (confounder) would be an important confounding factor since socioeconomic status is associated with living close to CAFO and socioeconomic status is associated with a higher incidence of asthma. "),
                    tags$li("Selection bias occurs when the selection of participants is conditioned by both the exposure and the disease status (outcome). An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), only participants with exposure to CAFOs and asthma are enrolled. "),
                    tags$li("Information Bias occurs due to inaccurate measurement of variables in a study (this includes exposure variables, outcome variables and confounding variables). Information bias includes misclassification bias (see below) as well as measurement error.  "),
                    tags$li("Misclassification Bias of the Exposure occurs when study participants who are exposed to the variable of interest are mistakenly classified as not being exposed, or when study participants who are unexposed to the variable of interest are mistakenly classified as being exposed. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants who live close to CAFO were classified as not exposed to CAFO. "),
                    tags$li("Misclassification Bias of the Outcome occurs when study participants who do not have the outcome of interest (e.g., pneumonia) are mistakenly classified as having the outcome of interest, or when study participants who have the outcome of interest are mistakenly classified as not having the outcome of interest. This can occur when a diagnostic test gives false positives and false negatives. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants with asthma were classified as participants without asthma."),
                    p("For further details about risk of bias assessment 
                    ", a("click here", href = " http://help.magicapp.org/knowledgebase/articles/327941-tool-to-assess-risk-of-bias-in-cohort-studies")),
                    br(),
                    br()
                ))), 
      ## * risk of bias upper R
      tabItem(tabName = "up_rsp_risk_of_bias",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Risk of Bias for Upper Respiratory Diseases",
                    #p("Risk of Bias plot"),
                    br(),
                    p(div(textOutput ("upper_rob_text"), style="font-size: 16px; font-family: Source Sans Pro")),
                    br(),
                    p("The following graph summarizes the results of the bias assessment for the extracted exposure-outcome pairs, using questions designed to assess three sources of bias: confounding, selection bias, and information bias."),
                    #br(paste("Of the", nrow ((timedata2)),"studies reporting upper respiratory outcomes,")),
                    #div(textOutput ("upper_pairs"), style="font-size: 16px; font-family: Source Sans Pro"),
                    br(),
                    plotlyOutput("bias_up"),
                    br(),
                    div(img(src = "ROB_question_1.PNG", height = 330, width = 760), style="text-align: center;"),
                    br(),
                    p("Three potential sources of bias, confounding, selection bias, and information bias, were assessed in each health outcome present in each study included. "),
                    tags$li("Confounding is the distortion of the association between an exposure and health outcome by an extraneous, third variable called a confounder. To be a potential confounder, the variable must be statistically associated with the exposure and the outcome, and must not be on the causal pathway i.e., not being a mediator. An example of confounding: When examining the relationship between CAFOs (exposure) and asthma (health outcome), socioeconomic status (confounder) would be an important confounding factor since socioeconomic status is associated with living close to CAFO and socioeconomic status is associated with a higher incidence of asthma. "),
                    tags$li("Selection bias occurs when the selection of participants is conditioned by both the exposure and the disease status (outcome). An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), only participants with exposure to CAFOs and asthma are enrolled. "),
                    tags$li("Information Bias occurs due to inaccurate measurement of variables in a study (this includes exposure variables, outcome variables and confounding variables). Information bias includes misclassification bias (see below) as well as measurement error.  "),
                    tags$li("Misclassification Bias of the Exposure occurs when study participants who are exposed to the variable of interest are mistakenly classified as not being exposed, or when study participants who are unexposed to the variable of interest are mistakenly classified as being exposed. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants who live close to CAFO were classified as not exposed to CAFO. "),
                    tags$li("Misclassification Bias of the Outcome occurs when study participants who do not have the outcome of interest (e.g., pneumonia) are mistakenly classified as having the outcome of interest, or when study participants who have the outcome of interest are mistakenly classified as not having the outcome of interest. This can occur when a diagnostic test gives false positives and false negatives. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants with asthma were classified as participants without asthma."),
                    p("For further details about risk of bias assessment 
                    ", a("click here", href = " http://help.magicapp.org/knowledgebase/articles/327941-tool-to-assess-risk-of-bias-in-cohort-studies")),
                    br(),
                    br()
                )
              )), 
      
      ## * risk of bias IC
      tabItem(tabName = "ic_rsp_risk_of_bias",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Risk of Bias for Infectious condition outcomes",
                    p("Risk of Bias plot"),
                    plotOutput("bias_ic") %>% withSpinner(),
                    br(),
                    div(img(src = "ROB_question_1.PNG", height = 330, width = 760), style="text-align: center;"),
                    br(),
                    p("Three potential sources of bias, confounding, selection bias, and information bias, were assessed in each health outcome present in each study included. "),
                    tags$li("Confounding is the distortion of the association between an exposure and health outcome by an extraneous, third variable called a confounder. To be a potential confounder, the variable must be statistically associated with the exposure and the outcome, and must not be on the causal pathway i.e., not being a mediator. An example of confounding: When examining the relationship between CAFOs (exposure) and asthma (health outcome), socioeconomic status (confounder) would be an important confounding factor since socioeconomic status is associated with living close to CAFO and socioeconomic status is associated with a higher incidence of asthma. "),
                    tags$li("Selection bias occurs when the selection of participants is conditioned by both the exposure and the disease status (outcome). An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), only participants with exposure to CAFOs and asthma are enrolled. "),
                    tags$li("Information Bias occurs due to inaccurate measurement of variables in a study (this includes exposure variables, outcome variables and confounding variables). Information bias includes misclassification bias (see below) as well as measurement error.  "),
                    tags$li("Misclassification Bias of the Exposure occurs when study participants who are exposed to the variable of interest are mistakenly classified as not being exposed, or when study participants who are unexposed to the variable of interest are mistakenly classified as being exposed. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants who live close to CAFO were classified as not exposed to CAFO. "),
                    tags$li("Misclassification Bias of the Outcome occurs when study participants who do not have the outcome of interest (e.g., pneumonia) are mistakenly classified as having the outcome of interest, or when study participants who have the outcome of interest are mistakenly classified as not having the outcome of interest. This can occur when a diagnostic test gives false positives and false negatives. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants with asthma were classified as participants without asthma."),
                    p("For further details about risk of bias assessment 
                    ", a("click here", href = " http://help.magicapp.org/knowledgebase/articles/327941-tool-to-assess-risk-of-bias-in-cohort-studies")),
                    br(),
                    
                    
                    br()
                ))),
      
      ## * risk of bias AR
      tabItem(tabName = "ar_rsp_risk_of_bias",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Risk of Bias for Antimicrobial resistance outcomes",
                    p("Risk of Bias plot"),
                    plotOutput("bias_ar") %>% withSpinner(),
                    br(),
                    div(img(src = "ROB_AR.PNG", height = 330, width = 760), style="text-align: center;"),
                    br(),
                    p("Three potential sources of bias, confounding, selection bias, and information bias, were assessed in each health outcome present in each study included. "),
                    tags$li("Confounding is the distortion of the association between an exposure and health outcome by an extraneous, third variable called a confounder. To be a potential confounder, the variable must be statistically associated with the exposure and the outcome, and must not be on the causal pathway i.e., not being a mediator. An example of confounding: When examining the relationship between CAFOs (exposure) and asthma (health outcome), socioeconomic status (confounder) would be an important confounding factor since socioeconomic status is associated with living close to CAFO and socioeconomic status is associated with a higher incidence of asthma. "),
                    tags$li("Selection bias occurs when the selection of participants is conditioned by both the exposure and the disease status (outcome). An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), only participants with exposure to CAFOs and asthma are enrolled. "),
                    tags$li("Information Bias occurs due to inaccurate measurement of variables in a study (this includes exposure variables, outcome variables and confounding variables). Information bias includes misclassification bias (see below) as well as measurement error.  "),
                    tags$li("Misclassification Bias of the Exposure occurs when study participants who are exposed to the variable of interest are mistakenly classified as not being exposed, or when study participants who are unexposed to the variable of interest are mistakenly classified as being exposed. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants who live close to CAFO were classified as not exposed to CAFO. "),
                    tags$li("Misclassification Bias of the Outcome occurs when study participants who do not have the outcome of interest (e.g., pneumonia) are mistakenly classified as having the outcome of interest, or when study participants who have the outcome of interest are mistakenly classified as not having the outcome of interest. This can occur when a diagnostic test gives false positives and false negatives. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants with asthma were classified as participants without asthma."),
                    p("For further details about risk of bias assessment 
                    ", a("click here", href = " http://help.magicapp.org/knowledgebase/articles/327941-tool-to-assess-risk-of-bias-in-cohort-studies")),
                    br(),
                    br()
                ))), 
      ## * risk of bias upper GI
      tabItem(tabName = "gi_rsp_risk_of_bias",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Risk of Bias for Gastrointestinal Diseases",
                    p("Risk of Bias plot"),
                    plotOutput("bias_gi") %>% withSpinner(),
                    br(),
                    div(img(src = "ROB_question_1.PNG", height = 330, width = 760), style="text-align: center;"),
                    br(),
                    p("Three potential sources of bias, confounding, selection bias, and information bias, were assessed in each health outcome present in each study included. "),
                    tags$li("Confounding is the distortion of the association between an exposure and health outcome by an extraneous, third variable called a confounder. To be a potential confounder, the variable must be statistically associated with the exposure and the outcome, and must not be on the causal pathway i.e., not being a mediator. An example of confounding: When examining the relationship between CAFOs (exposure) and asthma (health outcome), socioeconomic status (confounder) would be an important confounding factor since socioeconomic status is associated with living close to CAFO and socioeconomic status is associated with a higher incidence of asthma. "),
                    tags$li("Selection bias occurs when the selection of participants is conditioned by both the exposure and the disease status (outcome). An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), only participants with exposure to CAFOs and asthma are enrolled. "),
                    tags$li("Information Bias occurs due to inaccurate measurement of variables in a study (this includes exposure variables, outcome variables and confounding variables). Information bias includes misclassification bias (see below) as well as measurement error.  "),
                    tags$li("Misclassification Bias of the Exposure occurs when study participants who are exposed to the variable of interest are mistakenly classified as not being exposed, or when study participants who are unexposed to the variable of interest are mistakenly classified as being exposed. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants who live close to CAFO were classified as not exposed to CAFO. "),
                    tags$li("Misclassification Bias of the Outcome occurs when study participants who do not have the outcome of interest (e.g., pneumonia) are mistakenly classified as having the outcome of interest, or when study participants who have the outcome of interest are mistakenly classified as not having the outcome of interest. This can occur when a diagnostic test gives false positives and false negatives. An example of selection bias:  When examining the relationship between CAFOs (exposure) and asthma (health outcome), participants with asthma were classified as participants without asthma."),
                    p("For further details about risk of bias assessment 
                    ", a("click here", href = " http://help.magicapp.org/knowledgebase/articles/327941-tool-to-assess-risk-of-bias-in-cohort-studies")),
                    br(),
                    br()
                ))), 
      ## * risk of bias Neurologic
      tabItem(tabName = "Neur_rsp_risk_of_bias",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Risk of Bias for Neurologic conditions",
                    p("Risk of Bias plot"),
                    plotlyOutput("bias_Neur") %>% withSpinner(),
                    br(),
                    tags$li("For further details about risk of bias assessment 
                    ", a("click here", href = " http://help.magicapp.org/knowledgebase/articles/327941-tool-to-assess-risk-of-bias-in-cohort-studies")),
                    br(),
                    tags$li("The overall risk of bias for this exposure-outcome association was critical."),
                    br(),
                    br()
                ))), 
      
      
      
      ## * conclusion ####
      tabItem(tabName = "low_rsp_conclusion",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Interpretation Lower Respiratory Outcomes",
                    p("The following interpretations correspond to those findings in the last living systematic review developed by our group."),
                    tags$li("Studies reporting on AFOs and human health have not been discussing important epidemiological assumptions necessary to interpret the measure of effect as IDR and CIR which would be important for causal inference. "),
                    tags$li("Case-control studies might provide estimates of contrast incidences, and this could contribute more to elucidating a causal relationship in the body of work. However, currently it is very difficult for readers to assess these assumptions as many authors are not providing the information required. "),
                    tags$li("Confounding can prevent drawing causal conclusions in this body of work, as the sole use of multivariate models, without exhaustive analysis for the selection, identification and retention of confounding variables using tools such as DAGs, might not capture the full spectrum of bias and the contrary, could generate biased estimates due to the adjustment of colliders and unnecessary adjustment."),#"Many authors studied ordered levels of exposure (increasing or decreasing) to document a dose-response, which is important for investigation of causation. When the metric for goat exposure was a density indicator (i.e., number of goats within 5 km of the subject’s residence) and the outcome metric was pneumonia, there was evidence of an association between higher goat density and lower respiratory disease. The prevalence OR for the highest goat density (17,191–20,960) was 1.68, which indicated an increased prevalence of disease. Although the precision was moderate, all of the values within the 95% CI were associated with increased prevalence. These apparently inconsistent findings were reported by the same authors in the same study population. One explanation is that different mechanisms lead to the development of pneumonia versus asthma."),
                    #tags$li("Finding suggested that exposure to goats was strongly associated with Q fever risk. The authors used pneumonia as a potential Q fever-related outcome, because pneumonia was the most frequent diagnosis among the notified Q fever patients in the Netherlands epidemic. The authors also noted that exposure to poultry was associated with increased prevalence odds of pneumonia. This association between goats and pneumonia was likely due to Q fever, rather than particulate or gaseous emissions. The overall risk of bias was serious for all of the studies that reported prevalence ORs as measures of association."),
                    tags$li("Because there is not a clear definition of residential exposure to AFOs, measurement error always needs to be carefully considered. Studying the effect of residing in AFO areas on the development of health conditions involves the fundamental fact of properly measuring and defining exposure to these operations. In fact, the mixed results observed could reflect the multiple ways that have been used to define and measure AFO exposure. It is reasonable to assume that the potential health outcomes addressed, mostly of a chronic respiratory nature, are due to cumulative and variable exposure to emissions from farms. ")#"The overall risk of bias was serious for all of the studies that reported prevalence ORs as measures of association.")
                )
              )),
      
      tabItem(tabName = "up_rsp_conclusion",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Interpretation Upper Respiratory Outcomes",
                    #tags$li("Pending Interpretation")#,
                    p("The following interpretations correspond to those reported in the last systematic review developed by our group."),
                    tags$li("Four studies used prevalence ORs to measure associations between exposure to animal facilities and upper respiratory tract outcomes. The associations were not consistent for the subgroups objective exposure/objective outcome, objective exposure/ subjective outcome, and subjective exposure/objective outcome. The findings across dose gradient were also inconsistent. Some results indicated that compared with high-level exposures, lower- or medium-level exposures were associated with higher odds of disease."),
                    tags$li("When the measure of exposure was the level of odor annoyance, a dose-response was present if the outcome was measured subjectively (self-reported symptoms). The association was inconsistent when an objective measure of disease occurrence was assessed (specific IgE to common allergens). Moderate annoyance at odor was associated with the highest specific IgE response relative to “not at all annoyed” by odor. The precision of the result suggested the direction was consistently positive (OR = 1.71, 95% CI 1.02, 2.87). However, compared with “not at all annoyed,” individuals who responded “somewhat annoyed” (OR = 1.11, 95% CI 0.79, 1.57) and “strongly annoyed” (OR = 1.02, 95% CI 0.51, 2.03) had effect sizes more consistent with an interpretation of no effect (close to OR = 1).")
                )
              )),
      
      tabItem(tabName = "ar_rsp_conclusion",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Interpretation Antimicrobial resistance Outcomes",
                    #tags$li("Pending Interpretation.")#,
                    p("The following interpretations correspond to those reported in the last systematic review developed by our group."),
                    tags$li("There was no consistent finding for this outcome. One study used a subjective measure of exposure (odor), and the patients were aware of their Methicillin-resistant Staphylococcus aureus (MRSA) status at the time of exposure assessment. Schinasi et al. found that the odds of being MRSA-positive were greater if the subject had ever smelled farm odors when at home (OR = 1.51). The precision of this estimate was moderate, but most of the effect sizes in the 95% CI were consistent with no effect (95% CI 0.8, 2.86). However, this association was not consistently observed for the same study participants when the exposure was an objectively measured metric, and the observed results did not document a consistent dose-response."),
                    tags$li("Schinasi et al. evaluated another exposure metric in the same population (the number of farrowing swine permitted within a 1- square-mile block of the participant’s residence) and explored whether a dose-response was present. However, when compared with the lowest exposure level, the middle exposure level had a higher prevalence of MRSA carriage than higher levels of exposure. The authors reported moderate exposure using three metrics (farrowing swine, non-farrowing swine, and swine); the effect sizes and precision estimates were 1.99 (95% CI 0.99, 4.06), 2.04 (0.61, 6.85), and 4.76 (1.36, 16.69), respectively. These estimates contrasted with higher levels of exposure (>149), which were associated with a prevalence OR that suggested lower odds of nasal carriage of Methicillin-resistant Staphylococcus aureus (MRSA). "),
                    tags$li("Feingold et al. did report an association between MRSA carriage and swine (1.37, 95% CI 1.01, 1.67), cattle (2.28, 95% CI 1.17, 4.15), and veal (1.37, 95% CI 1.08, 1.72) density. They did not report any inconsistencies in association because they only reported one exposure metric (the log of municipal density). It is unclear whether other exposure metrics were evaluated but not reported. "),
                    tags$li("The overall risk of bias was serious for all antimicrobial resistance outcomes reported by Schinasi et al.  and moderate for the outcome reported by Feingold et al.")
                )
              )),
      
      tabItem(tabName = "ic_rsp_conclusion",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Interpretation Infectious condition Outcomes",
                    p("The following interpretations correspond to those reported in the last systematic review developed by our group."),
                    tags$li("Smit et al reported a strong association and clear dose-response between goat density and “other infectious disease.” However, it was actually unclear what this outcome represented, or if it duplicates a prior analysis by these authors, which evaluated respiratory disease outcomes. Smit et al described this variable as: “In the Netherlands, Q fever is registered by GPs under the ICPC code ‘other infectious disease’. Despite the broad name, ‘other infectious disease’ is normally only used for patients with Q fever or Lyme disease.” This description suggests that during a Q fever outbreak, this “other infectious disease” would likely be Q fever, which is often but not always associated with respiratory disease. "),
                    tags$li("The overall risk of bias was serious for Smit et al 2012 that reported “other infectious disease” outcomes.")
                    #tags$li("Feingold et al. did report an association between MRSA carriage and swine (1.37, 95% CI 1.01, 1.67), cattle (2.28, 95% CI 1.17, 4.15), and veal (1.37, 95% CI 1.08, 1.72) density. They did not report any inconsistencies in association because they only reported one exposure metric (the log of municipal density). It is unclear whether other exposure metrics were evaluated but not reported. "),
                    #tags$li("The overall risk of bias was serious for all antimicrobial resistance outcomes reported by Schinasi et al.  and moderate for the outcome reported by Feingold et al.")
                )
              )),
      
      tabItem(tabName = "gi_rsp_conclusion",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Interpretation Gastrointestinal Outcomes",
                    #tags$li("Pending Interpretation ")#,
                    p("The following interpretations correspond to those reported in the last systematic review developed by our group."),
                    tags$li("The associations with the exposures were reported as regression coefficients. The outcomes were self-assessed every 12 hours by each participant and represented the presence or absence of nausea, diarrhea, and poor appetite over the past 12 hours. Overall, there was no consistent direction of association between outcome and exposure. Only two effect sizes had intervals that did not include zero: poor appetite was positively associated with 12 h community-level average PM10 per 10 g/m3 (β = 0.51, 95% CI 0.12, 0.90), and nausea was negatively associated with 12 h community-level PM2.5-10 per 10 µg/m3 (β = -1.43, 95% CI -2.82, -0.04)."), 
                    tags$li("There was an overall serious risk of bias associated with these objectively measured exposures.")
                )
              )),
      
      tabItem(tabName = "Neur_rsp_conclusion",
              fluidRow(
                box(width = 12, solidHeader = TRUE, status = "primary", title = "Interpretation Neurologic Outcomes",
                    tags$li("Horton et al. and Schinasi et al. both publications described the results for the participants of the CHEIHO Study, who were asked to self-report numerous outcomes. Horton et al.reported the associations as odds ratios. Schinasi et al. reported the regression coefficients (betas) from a logistic regression model. The direction of association was not consistent; sometimes the effect size indicated a protective effect or a risk factor. For the odor metrics, the effect measure was always in the direction that indicated increased risk of health outcomes in exposed individuals. The intervals of three (hydrogen sulfide, PM10, semivolatile PM10) of the four effect sizes reported by Horton et al. were associated with estimates that indicated risk, protection, or no association."),
                    tags$li("The overall risk of bias for this exposure-outcome association was serious or critical. Horton et al. reported one effect measure for which the precision measure (95% confidence interval (CI)) only included estimates associated with harm: for the exposure - twice-daily odor rating - and the outcome - confused or unable to concentrate - (95% CI = 1.16, 1.50). The overall risk of bias for this exposure-outcome association was critical.")
                )
              )),
      
      ### ROSES flow chart
      tabItem(tabName = "excluded",
        
                fluidRow(column(width = 12, h4("Studies excluded in the updated review"),
                                br(), 
                                p("Each study reviewed had to go through two screening levels. At the Level 1, the title and abstract of each study were reviewed by two reviewers working independently to answer the question:"),
                                tags$li(" Does the title and/or abstract describe an observational study reporting the association between relevant AFOs and measures of health in surrounding-community members?"),
                                br(),
                                p("All those studies in which the answer was 'Yes' passed to level 2. At level 2, the full article was reviewed and only those that answered affirmatively to the next 8 consecutive questions are included in the review:"),
                                tags$li(" Is the study written entirely in English?"),
                                tags$li(" Is the paper a conference proceedings with > 300 words?"),
                                tags$li(" Is the study a primary research?"),
                                tags$li(" Does the study report a comparative association between a relevant animal feeding operation and measures of health in surrounding-community members only and exclude occupational exposure?"),
                                tags$li(" Does the study analyze the relationship between outcome and exposure at individual human level?"),
                                tags$li(" Does the study report animal feeding operations that would be reasonably considered either large, concentrated or intensive by modern standards (not nomadic, small holder or pastoral)?"),
                                tags$li(" Does the study include more than one unit of measurement of exposure?"),
                                tags$li(" Does the study include at least one human health outcome measured using either an eligible survey instrument, test, assay or diseases measure obtained from medical records?"),
                                br(),
                                p("The following table contains the references excluded at level 2. The criteria for excluding each study is shown in the column 'Reason for exclusion'."),
                                
                                div(DT::dataTableOutput("excluded_table", height = "20em"),style = "font-size: 90%")
                )
                
                )
                
                
                ),
######## new table of included 
#tabItem(tabName = "included",
        
#        fluidRow(column(width = 12, h4("Total studies included in the baseline review and new ones identified in each update"),
#                        br(), 
#                        p("The following table contains the articles included in the initial review (baseline review) and new references identified in each updated."),
#                        div(DT::dataTableOutput("inclusionF", height = "20em"),style = "font-size: 90%")
#        )
        
#        )
        
        
#),

tabItem(tabName = "included",
        
        fluidRow(column(width = 12, h4("Total studies included in the baseline review and new ones identified in each update"),
                        br(), 
                        p("The following table contains the articles included in the initial review (baseline review) and new references identified in each updated."),
                        downloadButton("download_csv", "Download CSV"),
                        downloadButton("download_excel", "Download Excel"),
                        br(), br(), 
                        div(DT::dataTableOutput("included_table", height = "20em"),style = "font-size: 90%")
        )
        
        )
        
        
),

######## new table of included 
tabItem(tabName = "confounding",
        
        fluidRow(column(width = 12, h4("Total studies included in the baseline review and new ones identified in each update"),
                        br(), 
                        p("The following table contains the articles included in the initial review (baseline review) and new references identified in each updated."),
                        div(DT::dataTableOutput("confo", height = "20em"),style = "font-size: 90%")
        )
        
        )
        
        
),



      
      ## references ####  
      tabItem(tabName = "ref",
              fluidRow(
                
                column(width = 12, h4("Studies included in the baseline review and new ones identified in each update"),
                       br(), 
                       
                       p(" The following table contains the articles included in the initial review (baseline review). Only 15 studies are included in the current review, because the study Schiffman et al 2005 in not eligble as it is experimental model of exposure"),
                       DT::dataTableOutput("mytable1234")
                )
                
              ),
              hr(),
              fluidRow(column(width = 12, h4("Studies included in the updated review"),
                              br(), 
                              p(" The following table contains the new references identified in the updated review."),
                              DT::dataTableOutput("mytable12345")
              )
              
              )
              
              
              
              )
    )
  )
)
