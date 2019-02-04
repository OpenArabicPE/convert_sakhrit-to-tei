# This script provides functions to convert HTML from archivr.sakhrit.co to CSV and properly formatted HTML

# Remember it is good coding technique to add additional packages to the top of your script 
library(tidyverse) # load the tidyverse, which includes dplyr, tidyr and ggplot2
library(lubridate) # for working with dates
library(anytime) # for parsing incomplete dates
library(xml2)
library(rvest) # for parsing HTML/XML tables
# enable unicode
Sys.setlocale("LC_ALL", "en_US.UTF-8")


# function to retrieve the relevant HTML table
f.retrieve.authorsArticles.html <- function(authorsArticles) {
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

f.retrieve.authorsArticles.csv <- function(authorsArticles) {
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
f.retrieve.ArticlePages.csv <- function(ArticlePages) {
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
f.retrieve.authorsArticles.title <- function(authorsArticles) {
  v.Url <- paste("http://archive.sakhrit.co/", authorsArticles, sep = "")
  v.Source <- read_html(v.Url, encoding = "utf-8") #make sure to specify utf-8 encoding
  v.Table <- v.Source %>% #make sure to specify utf-8 encoding
    html_nodes(xpath="descendant::table[@id = 'ContentPlaceHolder1_gvSearchResult']")
  article.title <- xml_text(xml_find_all(v.Table, "descendant::tr/td[1][child::a]/a" ))
}

# function to retrieve information from the detail page of each issue: contents.aspx?CID=123
f.retrieve.contents.csv <- function(contents) {
  # some feedback message would be good for debugging purposes
  v.Source <- read_html(contents, encoding = "utf-8")
  # issue level: in some scraped files "table[@id='ContentPlaceHolder1_fvIssueInfo']" is missing
  v.Issue <- xml_find_all(v.Source, "descendant::table[@id='ContentPlaceHolder1_fvIssueInfo']/descendant::td[@class='F_MagazineName']/table/tr/td[1]")
  journal.title <- xml_text(xml_find_first(v.Issue , "child::a[1]"), trim = T)
  journal.url <- xml_attr(xml_find_first(v.Issue , "child::a[1]"), attr = "href")
  journal.id <- sub(".+MID=(\\d+)", "\\1", journal.url)
  issue <- xml_text(xml_find_first(v.Issue , "child::span[1]"),trim = T)
  date.publication <- xml_text(xml_find_first(v.Issue , "child::span[2]"),trim = T)
  date.publication.iso <- f.date.convert.sakhrit.to.iso(date.publication) # this function just returns NA if it cannot find data to be parsed
  # article level
  v.Issue.Content <- xml_find_all(v.Source, "descendant::table[@id='ContentPlaceHolder1_dlIndexs']")
  v.Article <- xml_find_all(v.Issue.Content, "child::tr")
  author.name <- xml_text(xml_find_all(v.Article, "descendant::a[@class='aIndexLinks'][1]"), trim = T)
  article.title <- xml_text(xml_find_all(v.Article, "descendant::a[@class='aIndexLinks'][2]"), trim = T)
  article.url <- xml_attr(xml_find_all(v.Article, "descendant::a[@class='aIndexLinks'][1]"), attr = "href")
  article.id <- sub(".+AID=(\\d+)", "\\1", article.url) # this can't be the author ID, since every reference to the same name gets a different AID here
  issue.id <- sub(".+ISSUEID=(\\d+).*", "\\1", article.url)
  page.from <- xml_text(xml_find_all(v.Article, "descendant::a[@class='aIndexLinks'][3]"), trim = T)
  # construct data frame
  v.Df <- data_frame(
    journal.title, journal.id, #journal.url,
    issue, issue.id,
    date.publication, date.publication.iso, #place.publication,
    author.name, #author.id,
    article.title, article.url, article.id, page.from
  )
  # save output
  write.table(v.Df, file = paste("../_output/csv/",contents,".csv", sep = "") , row.names = F, quote = T, sep = ",")
}

v.month.names <- dplyr::tibble(month.number = 1:12, month.name = list("يناير","فبراير","مارس","أبريل","مايو","يونيو","يوليو","أغسطس","سبتمبر","أكتوبر","نوفمبر","ديسمبر"))

# function to convert the publication date from Sakhrit into a proper ISO date
f.date.convert.sakhrit.to.iso <- function(date) {
  # this function just returns NA if it cannot find data to be parsed
  date.year <- as.integer(gsub("(\\d+)\\s+(.+)\\s+(\\d{4})", "\\3", date))
  date.day <- as.integer(gsub("(\\d+)\\s+(.+)\\s+(\\d{4})", "\\1", date))
  date.month.name <- gsub("(\\d+)\\s+(.+)\\s+(\\d{4})", "\\2", date)
  date.month.number <- as.integer(filter(v.month.names, month.name == date.month.name)[1])
  lubridate::as_date(sprintf("%d-%02d-%02d", date.year, date.month.number, date.day))
}

f.date.publication.period <- function(dataframe, date.start, date.stop){
  dataframe[dataframe$date.publication.iso >= anydate(date.start) & dataframe$date.publication.iso <= anydate(date.stop),]
  }

# slice data into rolling periods
## load data
## 1. define start year
## 2. define a stop year
## 3. define a period
## 4. select data that falls into the period starting with the start year
## 5. increment start year by one and repeat until start year equals stop year

f.date.slice.period <- function(df.input, onset, terminus, period) {
  terminus.period <- onset + period
  #df.input <- data.sakhrit.contents
  if(onset <= terminus) {
    # limit df.input to current decade
    v.Df <- df.input[lubridate::year(df.input$date.publication.iso) >= onset & lubridate::year(df.input$date.publication.iso) <= terminus.period,]
    # save output
    write.table(v.Df, file = paste("csv/contents_",onset ,"-", terminus.period, ".csv", sep = ""), row.names = F, quote = T, sep = ",")
    save(v.Df, file = paste("rda/contents_",onset ,"-", terminus.period, ".rda", sep = ""))
    f.date.slice.period(df.input, onset =  + 1, terminus, period)
  }
}