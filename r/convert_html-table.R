# Remember it is good coding technique to add additional packages to the top of your script 
library(tidyverse) # load the tidyverse, which includes dplyr, tidyr and ggplot2
library(lubridate) # for working with dates
library(anytime) # for parsing incomplete dates
library(rvest) # for parsing HTML/XML tables
# enable unicode
Sys.setlocale("LC_ALL", "en_US.UTF-8")

# set a working directory
setwd("/Volumes/Dessau HD/BachUni/BachBibliothek/GitHub/OpenArabicPE/convert_sakhrit-to-tei/data/test")

# rvest test
url <- "http://en.wikipedia.org/wiki/List_of_U.S._states_and_territories_by_population"
population <- url %>%
  read_html() %>%
  html_nodes(xpath='//*[@id="mw-content-text"]/table[1]') %>%
  html_table()
population <- population[[1]]

file.1 <- read_html("authorsArticles.aspx?AID=2")
