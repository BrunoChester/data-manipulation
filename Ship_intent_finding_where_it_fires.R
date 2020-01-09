library(readr)
library(tidyverse)

Test1 <- read_csv("C:/Users/wky0hqm/Desktop/ship_test_CDP/ship_test1.csv")

# Adding new column with short name for intention
Test1$Intention <- Test1$`Shipment Start Intent (e21) (event21)`
Test1$URL <- Test1$`Page URL Clean (c18) (prop18)`
View(Test1)

#select only Shipping Start intent >1
Test1_intention <- filter(Test1,Intention > 1)
View(Test1_intention)

#Check the distribution of URL
Test1_intention %>% count(URL, sort = TRUE)

Test1_intention %>% group_by(`Page Country (c6) (prop6)`) %>% View()

##New Test##
Test2 <- read_csv("C:/Users/wky0hqm/Desktop/ship_test_CDP/shiptest2.csv")

# Adding new column with short name for intention
Test2$Intention <- Test1$`Shipment Start Intent (e21) (event21)`
Test2$ID <- Test2$`Page ID (c1) (prop1)`
View(Test2)


