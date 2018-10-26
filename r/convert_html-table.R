# Remember it is good coding technique to add additional packages to the top of your script 
library(tidyverse) # load the tidyverse, which includes dplyr, tidyr and ggplot2
library(lubridate) # for working with dates
library(anytime) # for parsing incomplete dates
library(xml2)
library(rvest) # for parsing HTML/XML tables
# enable unicode
Sys.setlocale("LC_ALL", "en_US.UTF-8")

# set a working directory for test files
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/convert_sakhrit-to-tei/data/test") #/Volumes/Dessau HD/

# function to retrieve the relevant HTML table
f.Retrieve.authorsArticles.Html <- function(authorsArticles) {
    v.Source <- read_html(authorsArticles, encoding = "utf-8") #make sure to specify utf-8 encoding
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
    write_xml(v.Table, file = paste("../_output/html/",authorsArticles,".html", sep = ""), options = "as_html")
}

f.Retrieve.authorsArticles.Csv <- function(authorsArticles) {
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
f.Retrieve.ArticlePages.Csv <- function(ArticlePages) {
    v.Source <- read_html(ArticlePages, encoding = "utf-8") #make sure to specify utf-8 encoding
    # issue level
    v.Issue <- xml_find_all(v.Source, "descendant::td[@class='F_MagazineName']/table/tr/td[1]")
    journal.title <- xml_text(xml_find_all(v.Issue, "child::a[1]"))
    journal.issue <- xml_text(xml_find_all(v.Issue, "child::a[2]"))
    journal.issue.url <- xml_attr(xml_find_all(v.Issue, "child::a[2]"), attr = "href")
    date.publication <- xml_text(xml_find_all(v.Issue, "child::span[1]"))
    place.publication <- xml_text(xml_find_all(v.Source, "descendant::a[@class='countrylable']"))
    # article level
    v.Author <- xml_find_all(v.Source, "descendant::a[child::span[@id='ContentPlaceHolder1_Label2']]")
    author.name <- xml_text(xml_find_all(v.Author,"span[@id='ContentPlaceHolder1_Label2']"))
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
f.Retrieve.authorsArticles.Title <- function(authorsArticles) {
    v.Url <- paste("http://archive.sakhrit.co/", authorsArticles, sep = "")
    v.Source <- read_html(v.Url, encoding = "utf-8") #make sure to specify utf-8 encoding
    v.Table <- v.Source %>% #make sure to specify utf-8 encoding
    html_nodes(xpath="descendant::table[@id = 'ContentPlaceHolder1_gvSearchResult']")
    article.title <- xml_text(xml_find_all(v.Table, "descendant::tr/td[1][child::a]/a" ))
}

# function to retrieve information from the detail page of each issue: contents.aspx?CID=123
f.Retrieve.contents.Csv <- function(contents) {
  v.Source <- read_html(contents, encoding = "utf-8")
  # issue level
  v.Issue <- xml_find_all(v.Source, "descendant::table[@id='ContentPlaceHolder1_fvIssueInfo']/descendant::td[@class='F_MagazineName']/table/tr/td[1]")
  journal.title <- xml_text(xml_find_first(v.Issue , "child::a[1]"), trim = T)
  journal.url <- xml_attr(xml_find_first(v.Issue , "child::a[1]"), attr = "href")
  journal.issue <- xml_text(xml_find_first(v.Issue , "child::span[1]"),trim = T)
  date.publication <- xml_text(xml_find_first(v.Issue , "child::span[2]"),trim = T)
  # article level
  v.Issue.Content <- xml_find_all(v.Source, "descendant::table[@id='ContentPlaceHolder1_dlIndexs']")
  v.Article <- xml_find_all(v.Issue.Content, "child::tr")
  author.name <- xml_text(xml_find_all(v.Article, "descendant::a[@class='aIndexLinks'][1]"), trim = T)
  article.title <- xml_text(xml_find_all(v.Article, "descendant::a[@class='aIndexLinks'][2]"), trim = T)
  article.url <- xml_attr(xml_find_all(v.Article, "descendant::a[@class='aIndexLinks'][1]"), attr = "href")
  page.from <- xml_text(xml_find_all(v.Article, "descendant::a[@class='aIndexLinks'][3]"), trim = T)
  # construct data frame
  v.Df <- data_frame(
    journal.title, journal.issue, journal.url, date.publication, #place.publication,
    author.name, # author.url,
    article.title, article.url, page.from
  )
  # save output
  write.table(v.Df, file = paste("../_output/csv/",contents,".csv", sep = "") , row.names = F, quote = T, sep = ",")
}

# apply functions to the full data set
# navigate to folder containing a scraped copy of the website
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/data_sakhrit/sakhrit")

# read all file names in a folder
v.Filenames.Authors <- list.files(pattern="authorsArticles*", full.names=TRUE)
v.Filenames.Articles <- list.files(pattern="ArticlePages*", full.names=TRUE)
v.Filenames.Contents <- list.files(pattern="contents*", full.names=TRUE)

# apply a function to all files
sapply(v.Filenames.Contents, FUN = f.Retrieve.contents.Csv)
sapply(v.Filenames.Authors, FUN = f.Retrieve.authorsArticles.Csv)
sapply(v.Filenames.Authors, FUN = f.Retrieve.authorsArticles.Html)
sapply(v.Filenames.Articles, FUN = f.Retrieve.ArticlePages.Csv)



