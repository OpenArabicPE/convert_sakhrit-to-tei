# Remember it is good coding technique to add additional packages to the top of your script 
library(tidyverse) # load the tidyverse, which includes dplyr, tidyr and ggplot2
library(lubridate) # for working with dates
library(anytime) # for parsing incomplete dates
library(rvest) # for parsing HTML/XML tables
# enable unicode
Sys.setlocale("LC_ALL", "en_US.UTF-8")

# set a working directory for test files
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/convert_sakhrit-to-tei/data/test") #/Volumes/Dessau HD/

# function to retrieve the relevant HTML table
func.Retrieve.Authors.Html <- function(v.Url) {
    v.Source <- read_html(v.Url, encoding = "utf-8") #make sure to specify utf-8 encoding
    v.Table <- v.Source %>% #make sure to specify utf-8 encoding
    html_nodes(xpath="descendant::table[@id = 'ContentPlaceHolder1_gvSearchResult']")
    #v.Author.Name <- v.Source %>%
    #html_node(xpath="normalize-space(descendant::node()[@id = 'ContentPlaceHolder1_lbAuthorName'])")
    #v.Df <- v.Table %>% # convert a html table to an R data frame
    #html_table(fill = T) %>%
    #data.frame() %>%
    # select columns of interest
    #dplyr::select(1,2,3) %>%
    # rename columns
    #dplyr::rename(
     # article.title = 1,
      #journal.title = 2,
      #journal.issue = 3) %>%
    # add author name
    #dplyr::mutate(author.name = as.character(v.Author.Name))
    # save data
    #save(v.Df, file = paste("../_output/rda/",v.Url,".rda", sep = ""))
    #write.table(v.Df, file = paste("../_output/csv/",v.Url,".csv", sep = "") , row.names = F, quote = T, sep = ",")
    write_xml(v.Table, file = paste("../_output/html/",v.Url,".html", sep = ""), options = "as_html")
}

func.Retrieve.Authors.Csv <- function(authorsArticles) {
    v.Url <- authorsArticles
    v.Source <- read_html(v.Url, encoding = "utf-8") #make sure to specify utf-8 encoding
    v.Table <- v.Source %>% #make sure to specify utf-8 encoding
    html_nodes(xpath="descendant::table[@id = 'ContentPlaceHolder1_gvSearchResult']")
    article.title <- xml_find_all(v.Table, "descendant::tr/td[1][child::a]/a" )
    article.url <- xml_attr(article.title, attr = "href")
    article.title <- xml_text(article.title, trim = T)
    author.name <- v.Source %>%
    html_node(xpath="normalize-space(descendant::node()[@id = 'ContentPlaceHolder1_lbAuthorName'])")
    journal.title <- xml_text(xml_find_all(v.Table, "descendant::tr/td[2]"), trim = T)
    journal.issue <- xml_text(xml_find_all(v.Table, "descendant::tr/td[3]"), trim = T)
    v.Df <- data.frame(article.title[1:35], 
        article.url[1:35], 
        journal.title[1:35], 
        journal.issue[1:35],
        stringsAsFactors = T,
        check.names = F)%>%
    dplyr::mutate(author.name = author.name,
        source.url = v.Url)
    write.table(v.Df, file = paste("../_output/csv/",v.Url,".csv", sep = "") , row.names = F, quote = T, sep = ",")
}

# retrieve everything from the article details page
func.Retrieve.Article.Details.Csv <- function(ArticlePages) {
    v.Source <- read_html(ArticlePages, encoding = "utf-8") #make sure to specify utf-8 encoding
    # issue level
    v.Issue <- xml_find_all(v.Source, "descendant::td[@class='F_MagazineName']/table/tr/td[1]")
    journal.title <- xml_text(xml_find_all(v.Issue, "child::a[1]"))
    journal.issue <- xml_text(xml_find_all(v.Issue, "child::a[2]"))
    journal.issue.url <- xml_attr(xml_find_all(v.Issue, "child::a[2]"), attr = "href")
    date.publication <- xml_text(xml_find_all(v.Issue, "child::span[1]"))
    place.publication <- xml_text(xml_find_first(v.Source, "descendant::a[@class='countrylable']"))
    # article level
    v.Author <- xml_find_all(v.Source, "descendant::a[child::span[@id='ContentPlaceHolder1_Label2']]")
    author.name <- xml_text(xml_find_first(v.Author,"span[@id='ContentPlaceHolder1_Label2']"))
    author.url <- xml_attr(v.Author, attr = "href")
    article.url <- ArticlePages
    # links to images
    v.Pages <- xml_find_all(v.Source, "descendant::div[@id='svPlayerId']/div/div/div/img[@class='slide_image']")
    facsimile.url <- xml_attr(v.Pages, attr = "src")
    # still missing: article.title 
    # construct data frame
    v.Df <- data_frame(
      journal.title, journal.issue, journal.issue.url, date.publication, place.publication,
      author.name, author.url,
      article.url, 
      # the data frame will have one row for each page in the article
      facsimile.url
      )
    # save output
    write.table(v.Df, file = paste("../_output/csv/",ArticlePages,".csv", sep = "") , row.names = F, quote = T, sep = ",")
}

# this function retrieves all article titles from the first page of the target URL
# NOT to be used at the moment
func.Retrieve.Article.Title <- function(authorsArticles) {
    v.Url <- paste("http://archive.sakhrit.co/", authorsArticles, sep = "")
    v.Source <- read_html(v.Url, encoding = "utf-8") #make sure to specify utf-8 encoding
    v.Table <- v.Source %>% #make sure to specify utf-8 encoding
    html_nodes(xpath="descendant::table[@id = 'ContentPlaceHolder1_gvSearchResult']")
    article.title <- xml_text(xml_find_all(v.Table, "descendant::tr/td[1][child::a]/a" ))
}

# apply functions to the full data set
# navigate to folder containing a scraped copy of the website
setwd("BachUni/programming/wget/dumpsite/sakhrit/archive.sakhrit.co")

# read all file names in a folder
v.Filenames.Authors <- list.files(pattern="authorsArticles*", full.names=TRUE)
v.Filenames.Articles <- list.files(pattern="ArticlePages*", full.names=TRUE)

# apply a function to all files
sapply(v.Filenames.Authors, FUN = func.Retrieve.Authors.Csv)
sapply(v.Filenames.Authors, FUN = func.Retrieve.Authors.Html)
sapply(v.Filenames.Articles, FUN = func.Retrieve.Article.Details.Csv)



