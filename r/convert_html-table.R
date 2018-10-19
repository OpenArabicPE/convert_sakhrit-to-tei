# Remember it is good coding technique to add additional packages to the top of your script 
library(tidyverse) # load the tidyverse, which includes dplyr, tidyr and ggplot2
library(lubridate) # for working with dates
library(anytime) # for parsing incomplete dates
library(rvest) # for parsing HTML/XML tables
# enable unicode
Sys.setlocale("LC_ALL", "en_US.UTF-8")

# set a working directory
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/convert_sakhrit-to-tei/data/test") #/Volumes/Dessau HD/

# read a html file
v.Source <- read_html("authorsArticles.aspx?AID=2", encoding = "utf-8") #make sure to specify utf-8 encoding

# get the author name
v.Author.Name <- v.Source %>%
  html_node(xpath="normalize-space(descendant::node()[@id = 'ContentPlaceHolder1_lbAuthorName'])")

# pull out the bibliographic information
v.Table <- v.Source %>% 
  # get a specific node set
  html_nodes(xpath="descendant::table[@id = 'ContentPlaceHolder1_gvSearchResult']") %>%
  # convert a html table to an R data frame
  html_table(fill = T) %>%
  data.frame() %>%
  # select columns of interest
  dplyr::select(1,2,3) %>%
  # rename columns
  dplyr::rename(
    article.title = 1,
    journal.title = 2,
    journal.issue = 3) %>%
  # add author name
  dplyr::mutate(author.name = as.character(html_node(v.Source, xpath="normalize-space(descendant::node()[@id = 'ContentPlaceHolder1_lbAuthorName'])")))

head(v.Table)

