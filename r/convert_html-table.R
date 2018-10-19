# Remember it is good coding technique to add additional packages to the top of your script 
library(tidyverse) # load the tidyverse, which includes dplyr, tidyr and ggplot2
library(lubridate) # for working with dates
library(anytime) # for parsing incomplete dates
library(rvest) # for parsing HTML/XML tables
# enable unicode
Sys.setlocale("LC_ALL", "en_US.UTF-8")

# function to retrieve the relevant HTML table
func.Html.Retrieve.Table <- function(v.Url) {
  v.Source <- read_html(v.Url, encoding = "utf-8") #make sure to specify utf-8 encoding
  v.Author.Name <- v.Source %>%
    html_node(xpath="normalize-space(descendant::node()[@id = 'ContentPlaceHolder1_lbAuthorName'])")
  v.Table <- read_html(v.Url, encoding = "utf-8") %>% #make sure to specify utf-8 encoding
    html_nodes(xpath="descendant::table[@id = 'ContentPlaceHolder1_gvSearchResult']")
  v.Df <- v.Table %>% # convert a html table to an R data frame
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
    dplyr::mutate(author.name = as.character(v.Author.Name))
  # save data
  #save(v.Df, file = paste("../_output/rda/",v.Url,".rda", sep = ""))
  write.table(v.Df, file = paste("../_output/csv/",v.Url,".csv", sep = "") , row.names = F, quote = T , sep = ",")
  write_xml(v.Table, file = paste("../_output/html/",v.Url,".html", sep = ""), options = "as_html")
}

# set a working directory
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/convert_sakhrit-to-tei/data/test") #/Volumes/Dessau HD/

# read all file names in a folder
v.Filenames <- list.files(pattern="authorsArticles*", full.names=TRUE)

# apply a function to all files
sapply(v.Filenames, FUN = func.Html.Retrieve.Table)

