# Creating new columns for each position
library(dplyr)
library(tidyr)
library(readxl)
Audit_pre <- read_excel("C:/Users/wky0hqm/Desktop/Requests/Messaging/Jan-2018/Prioritization project/Savannah_Audit_preview_2_13_19.xlsx", 
                                             sheet = "Audit tab")

View(Audit_pre)

#Removing Duplicates for audit doc and creating the csv doc
Audit_pre <- Audit_pre %>% distinct(`Onsite Display`, .keep_all = TRUE)
write.csv(Audit_pre,"audit_pre2.csv")
View(Audit_pre)
