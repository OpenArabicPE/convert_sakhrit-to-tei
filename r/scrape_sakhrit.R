# Remember it is good coding technique to add additional packages to the top of your script 
library(tidyverse) # load the tidyverse, which includes dplyr, tidyr and ggplot2
library(lubridate) # for working with dates
library(anytime) # for parsing incomplete dates
library(rvest) # for parsing HTML/XML tables and web scraping
library(xml2) # for manipulating HTML/XML
#library(httr)
library(RCurl)
# enable unicode
Sys.setlocale("LC_ALL", "en_US.UTF-8")

# set a working directory for test files
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/convert_sakhrit-to-tei/data/test")

v.Url.Base <- "http://archive.sakhrit.co/"

#  function retrieve everything from the article details page
func.Retrieve.ArticlePages.Csv <- function(ArticlePages) {
  # build URL from base and variable
  v.Url <- paste(v.Url.Base, ArticlePages, sep = "")
  # build an If ... then clause that checks whether a URL is actually available
  if (RCurl::url.exists(v.Url)) {
    v.Source <- xml2::read_html(v.Url, encoding = "utf-8") #make sure to specify utf-8 encoding
    # PROBLEM: some pages default to "DefaultArchive.aspx"
    # check if the table with bibliographic information is present
    #if (xml_find_first(v.Source, "descendant::td[@class='F_MagazineName']")) {
    # issue level
    v.Issue <- xml2::xml_find_first(v.Source, "descendant::td[@class='F_MagazineName']/table/tr/td[1]")
    # check if these fields are empty! And provide NA
    journal.title <- xml2::xml_text(xml2::xml_find_first(v.Issue, "child::a[1]"))
    journal.issue <- xml2::xml_text(xml2::xml_find_first(v.Issue, "child::a[2]"))
    journal.issue.url <- xml2::xml_attr(xml2::xml_find_first(v.Issue, "child::a[2]"), attr = "href")
    date.publication <- xml2::xml_text(xml2::xml_find_first(v.Issue, "child::span[1]"))
    place.publication <- xml2::xml_text(xml2::xml_find_first(v.Source, "descendant::a[@class='countrylable']"))
    # article level
    v.Author <- xml2::xml_find_all(v.Source, "descendant::a[child::span[@id='ContentPlaceHolder1_Label2']]")
    author.name <- xml2::xml_text(xml2::xml_find_first(v.Author,"span[@id='ContentPlaceHolder1_Label2']"))
    author.url <- xml2::xml_attr(v.Author, attr = "href")
    article.url <- ArticlePages
    # links to images
    v.Pages <- xml2::xml_find_all(v.Source, "descendant::div[@id='svPlayerId']/div/div/div/img[@class='slide_image']")
    facsimile.url <- xml2::xml_attr(v.Pages, attr = "src")
    # still missing: article.title 
    # construct data frame
    v.Df <- dplyr::data_frame(
      journal.title, journal.issue, journal.issue.url, date.publication, place.publication,
      author.name, author.url,
      article.url, 
      # the data frame will have one row for each page in the article
      facsimile.url
    )
    # save output
    write.table(v.Df, file = paste("../_output/csv/",ArticlePages,".csv", sep = "") , row.names = F, quote = T, sep = ",")
    #} else {
    #  print(paste(ArticlePages, "does not contain the bibliographic information.", sep = " "))
    #}
  } else {
    print(paste(ArticlePages, "could not be found.", sep = " "))
  }
}

# generate a sequence of numbers to be used as article IDs, author IDs, etc.
v.Id.Sequence <- c(241:250)
v.Url.Selector <- "ArticlePages.aspx?ArticleID=" # "ArticlePages.aspx?ArticleID=" / "authorsArticles.aspx?AID="

# generate a list of URLs
v.Urls <- list()
for(i in v.Id.Sequence) {
    v.Url <-paste(v.Url.Selector, i, sep = "") %>% 
      list()
    # add the new URL to the list of URLs
    v.Urls[[i]] <- v.Url
}
v.Urls <- unlist(v.Urls)

# set working directory

# apply a function to all files
lapply(v.Urls, FUN = func.Retrieve.ArticlePages.Csv)

# debugging
library(purrr)

v.Url <-paste(v.Url.Base, "ArticlePages.aspx?ArticleID=240", sep = "")
v.Source <- read_html(v.Url, encoding = "utf-8")
v.Issue <- xml_find_first(v.Source, "descendant::td[@class='F_MagazineName']")
journal.title <- xml_text(xml_find_first(v.Issue, "child::a[1]"))
