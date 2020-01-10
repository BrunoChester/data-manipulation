library(readr)
library(tidyverse)
library(stringr)

Foresee <- read_csv("C:/Users/wky0hqm/Desktop/R_scripts/forsee_data.csv")
View(Foresee)


#select terms like supply, freight, logistic, brokerage
Foresee_terms <- Foresee %>% filter(locale == 'us_en') %>% filter(str_detect(oe_improvements,
                                                                           c("supply","freight","logistic","brokerage"))) %>%
  select(experienceDate,oe_improvements,oe_industry,oe_navigation,oe_not_complete_task,url)
View(Foresee_terms) #24 rows

#select urls linked to the experinece on UPS.com
Foresee_url <- Foresee %>% filter(str_detect(url, c('supply','freight','logistics'))) %>% filter(locale == 'us_en') %>%
  select(experienceDate,oe_improvements,oe_industry,oe_navigation,oe_not_complete_task,url)
View(Foresee_url) #8 rows

