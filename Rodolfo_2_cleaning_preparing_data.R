# Rodolfo, esse script aqui e pra voce complementar com o outro. Talvez seja ate legal voce copiar e colar o outro aqui
# deletando o que for repeticao, tipo o upload do arquivo.
# Bom aqiu voce ja instalou todos os pacotes entao nao vou por aquela linha no script.
# Como criei esses scripts ha pouco tempo o nome de cada secao ta em ingles, vou deixar em ingles, blz?

library(readxl)
Onsite_ad <- read_csv("C:/Users/wky0hqm/Desktop/Requests/Messaging/March_19/Onsite_ad_displays/Jan_Feb.csv", 
                      col_types = cols(`Date (yyyy-mm-dd) UTC 0` = col_date(format = "%m/%d/%Y")))

# Creating new columns for each position
## Aqui e o seguinte, quando voce tem uma coluna em que os dados estao juntos e separados por um ; ou uma , e
## voce quer separar esses dados e criar colunas novas com eles voce usa essa parte
## e o text to columns do Excel e o Split do PowerBI
library(dplyr)
library(tidyr)
Onsite_ad <- Onsite_ad %>% mutate(`Onsite Ad Display2` = `Onsite Ad Display`) %>% # logo apos o mutate voce nomeia uma coluna nova
  separate(`Onsite Ad Display2`, c("Position_1","Position_2","Position_3"),";") # aqui voce separa a coluna nova e nomeia as colunas que serao craidas a partir dela apos o c()
View(Onsite_ad) # Aqui voce checa se deu certo a separacao e a planilha ta do jeito que voce quer


# Cleaning the data & Adding new columns
# Essa funcao e uma mao na roda. E o find and replace. Voce pode usa-la sempre em qualquer coisa. Aqui eu estou
# achando esse chunck de texto "template/content..." e trocando por nada, porque so queria tirar isso mesmo
fn <- function(x) gsub("templatedata/content/messaging/data/en_US/", "", x)
# Com a funcao pronta eu estou aplicando ela para as colunas que eu quero
# perceba que indico antes da <- a planilha e a coluna no padrao planilha$coluna e depois
# repito isso dentro da funcao. depois do  <- fn()
Onsite_ad$Position_1 <-fn(Onsite_ad$Position_1)
Onsite_ad$Position_2 <-fn(Onsite_ad$Position_2)
Onsite_ad$Position_3 <-fn(Onsite_ad$Position_3)
View(Onsite_ad)

# preparing date columns
# Agora que ta tudo do jeito que eu quero eu vou mudar as datas porque eu tenho uma coluna de data que vem
# completa tipo assim: 03/13/2019
# e eu quero cirar colunas para cada parte da data mas tambem manter a data completa.
Onsite_ad$Period <- anytime::anydate(Onsite_ad$`Date (yyyy-mm-dd) UTC 0`) # mantem data completa mas faz o R entender que o tipo do dado e data
Onsite_ad$year <- as.numeric(format(Onsite_ad$Period, format = "%Y")) # cria uma coluna com o ano apenas
Onsite_ad$month <- as.numeric(format(Onsite_ad$Period, format = "%m")) # cria uma coluna numerica com mes jan = 1, fev = 2...
Onsite_ad$month <- month.abb[Onsite_ad$month] # transforma os numeros em iniciais de meses 1 = jan, 2 = fev...

# Filtering data & Creating a smaller Data frame
# tudo pronto pra filtrar os dados pelo o que voce quiser
# aqui estou filtrando por periodo, perceba que so queria de janeiro a fevereiro desse ano
Onsite_ad <- Onsite_ad %>% filter(Period >= as.Date('2019-01-01') & Period <= as.Date('2019-02-28')) %>%
  filter(grepl("templatedata/content/messaging/data/en_US/m127-worldwide-express-saturday-pickup.dcr",`Onsite Ad Display`)) %>% # aqui estou filtrando uma mensagem especifica que quero analisar entao aponto a mensagem e o nome da coluna onde ela sera encontrada
  group_by(`Onsite Ad Display`) # aqui eu agrupo pela metrica que quero analisar
View(Onsite_ad) # checando se o dado ta como eu quero

# Data & summary
# As vezes eu quero a soma, a media..ou outra estatistica. Ai uso essa expressao aqui
# a ideia e a mesma, mas perceba que tem um SUMMARISE que e tipo um RESUMA POR
Onsite_ad <- Onsite_ad %>% group_by(Position_1) %>% filter(Position_1 == "m127-worldwide-express-saturday-pickup.dcr") %>%
  summarise(Total_displays = sum(`Users (distinct)`, na.rm = TRUE)) # o padrao aqui e depois do summarise voce indica o nome da nova coluna que tera o valor e em seguida o valor que vai popular aquela coluna. A importante, estou tirando os NA tambem
colnames(Onsite_ad)[colnames(Onsite_ad)=="new_name"] <- "DCR_name" # to so trocando o nome da coluna nao sei se voce vai preciasr fazer isso, mas vou deixar a expressao aqui. Fique a vontade para ignorar ela colocando uma # na frente dela


## NEW SESSION ##
# FAZENDO A MESMA COISA COM UMA SEGUNDA PLANILHA ANTES DE UNIR AS DUAS

# Uploading the clicks data
library(readr)
j_f_clicks <- read_csv("C:/Users/wky0hqm/Desktop/Requests/Messaging/March_19/Onsite_ad_clicks/Jan_to_Feb.csv", 
                       col_types = cols(`Date (yyyy-mm-dd) UTC 0` = col_date(format = "%m/%d/%Y")))

# Creating new columns for each position
library(dplyr)
library(tidyr)
j_f_clicks <- j_f_clicks %>% mutate(`Message Clicked` = `Onsite Ad Click (All Events)`)
week2_clicks$`Message Clicked` <-fn(week2_clicks$`Message Clicked`)
View(j_f_clicks)
# preparing the date data
j_f_clicks$Period <- anytime::anydate(j_f_clicks$`Date (yyyy-mm-dd) UTC 0`)
j_f_clicks$year <- as.numeric(format(j_f_clicks$Period, format = "%Y"))
j_f_clicks$month <- as.numeric(format(j_f_clicks$Period, format = "%m"))
j_f_clicks$month <- month.abb[j_f_clicks$month]

# Adding extra columns for positions
j_f_clicks <- j_f_clicks %>% mutate(`Onsite Ad Display2` = `Onsite Ad Display`) %>% 
  separate(`Onsite Ad Display2`, c("Position_1","Position_2","Position_3"),";")
View(j_f_clicks)
# Cleaning the data
fn <- function(x) gsub("templatedata/content/messaging/data/en_US/", "", x)
j_f_clicks$Position_1 <-fn(j_f_clicks$Position_1)
j_f_clicks$Position_2 <-fn(j_f_clicks$Position_2)
j_f_clicks$Position_3 <-fn(j_f_clicks$Position_3)

# Checking clicks for a single DCR
DCR_clicks_stats <- j_f_clicks %>% filter(Period >= as.Date('2019-01-01') & Period <= as.Date('2019-02-28')) %>%
  filter(`Onsite Ad Click (All Events)` == "templatedata/content/messaging/data/en_US/m127-worldwide-express-saturday-pickup.dcr") %>% 
  group_by(`Onsite Ad Click (All Events)`) %>%
  summarise(Total_clicks = sum(`Onsite Banner Clicks (count)`, na.rm = TRUE))
View(DCR_clicks_stats)
fn <- function(x) gsub("templatedata/content/messaging/data/en_US/", "", x)
DCR_clicks_stats$`Onsite Ad Click (All Events)` <-fn(DCR_clicks_stats$`Onsite Ad Click (All Events)`)
colnames(DCR_clicks_stats)[colnames(DCR_clicks_stats)=="Onsite Ad Click (All Events)"] <- "DCR_name"

## NEW SESSION - JOINING BOTH DATA FRAMES & CALCULATING CTR

# Com tudo pornto, agora eu so uno as duas e calculo o meu Click thru rate que era o que queria, mas era tanto dado
# que nao cabia no excel e o PowerBi travava.

# Joining both data sets
CTR_data <- left_join(Onsite_ad, DCR_clicks_stats, by = c("DCR_name" = "DCR_name"))
View(CTR_data)
CTR_data$ctr <- (CTR_data$Total_clicks / CTR_data$Total_displays)*100

## Download para CSV
write.csv(CTR_data, "NOME_DO_ARQUIVO.csv")