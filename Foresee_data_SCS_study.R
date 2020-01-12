library(readr)
library(tidyverse)


#Loading data, filtering by locale, cleaning url column, selecting only the columns that I will use
Foresee <- read_csv("C:/Users/wky0hqm/Desktop/R_scripts/forsee_data.csv")%>% filter(locale == 'us_en') %>% 
  separate(url, into = c("url_clean","right"),sep = "[?]") %>% 
  select(experienceDate,oe_improvements,oe_industry,oe_navigation,oe_not_complete_task,url_clean)
View(Foresee)


#select terms like supply, freight, logistic, brokerage
Foresee_terms <- Foresee %>% filter(locale == 'us_en') %>% filter(str_detect(oe_improvements,
                                                                           c("supply","freight","logistic","brokerage"))) %>%
  select(experienceDate,oe_improvements,oe_industry,oe_navigation,oe_not_complete_task,url)
View(Foresee_terms) #24 rows
write.csv(Foresee_terms,"Foresee_terms_2019.csv")

#select urls linked to the experience on UPS.com - filtering by terms present in the urls
Foresee_url <- Foresee %>% filter(str_detect(url, c('supply','freight','logistics', 'itl','expedited','pallet','invoice','customs','nafta'))) %>% filter(locale == 'us_en') %>%
  select(experienceDate,oe_improvements,oe_industry,oe_navigation,oe_not_complete_task,url)
View(Foresee_url) #8 rows
write.csv(Foresee_url,'Foresee_URL_2019.csv')

#Getting the list of URLs from UPS.com that are linked to this project
Url_list <- read_csv("C:/Users/wky0hqm/Desktop/scs_nav/list_urls_scs_ups.com_10_1_20.csv")
View(Url_list)


#Removing duplicates and renaming column
Url_list <- Url_list %>% unique() %>% rename('List_of_URL' = 'https://www.ups.com/us/en/services/contract-logistics.page')


#Filtering Foresee main table based on list of URL in the URL_list dataset
Foresee_URL_comments <- Foresee %>% filter(url_clean %in% Url_list$List_of_URL )
View(Foresee_URL_comments)
