#Webscraping the Harvard Business Review website
install.packages("rvest")

#Loading the rvest package
library('rvest')

# I will be getting title, time, and topic

# FIRST TITLE
#Specifying the url for desired website to be scraped
url <- 'https://hbr.org/topic/strategy'

#Reading the HTML code from the website
webpage <- read_html(url)

#Using CSS selectors to scrape the title section
title_data_html <- html_nodes(webpage,'h3 a')

#Converting the title data to text
title_data <- html_text(title_data_html)
title_data <- title_data[1:60]

#Let's have a look at the titles
View(title_data)

#SECOND TOPIC

#Using CSS selectors to scrape the topic section
topic_data_html <- html_nodes(webpage,'.topic')

#Converting the topic data to text
topic_data <- html_text(topic_data_html)
topic_data <- topic_data[1:60]

#Let's have a look at the topics
View(topic_data)

#THIRD DATE
#Using CSS selectors to scrape the date section
date_data_html <- html_nodes(webpage,'.pubdate')

#Converting the date data to text
date_data <- html_text(date_data_html)
date_data <- date_data[1:60]

#Let's have a look at the topics
View(date_data)

#Combining all the lists to form a data frame
HBR_df<-data.frame(Title = title_data, Topic = topic_data, Date = date_data)
View(HBR_df)
write.csv(HBR_df,"HBR_articles.csv")
