# Remember it is good coding technique to add additional packages to the top of your script 
library(tidyverse) # load the tidyverse, which includes dplyr, tidyr and ggplot2
library(lubridate) # for working with dates
library(anytime) # for parsing incomplete dates
library(xml2)
library(rvest) # for parsing HTML/XML tables
# enable unicode
Sys.setlocale("LC_ALL", "en_US.UTF-8")

# set a working directory
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/convert_sakhrit-to-tei")
# load functions from external R script
source("r/functions_sakhrit.R")

# set a working directory for test files
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/convert_sakhrit-to-tei/data/test")

# apply functions to the full data set
# navigate to folder containing a scraped copy of the website
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/data_sakhrit/sakhrit")
setwd("/BachUni/programming/wget/dumpsite/sakhrit/contents")

# read all file names in a folder containing the scraped HTML from Sakhrit
v.Filenames.Authors <- list.files(pattern="authorsArticles*", full.names=TRUE)
v.Filenames.Articles <- list.files(pattern="ArticlePages*", full.names=TRUE)
v.Filenames.Contents <- list.files(pattern="contents*", full.names=TRUE)

# apply a function to all files: retrieve information from HTML pages and save results as CSV
sapply(v.Filenames.Contents, FUN = f.retrieve.contents.csv)
sapply(v.Filenames.Authors, FUN = f.retrieve.authorsArticles.csv)
sapply(v.Filenames.Authors, FUN = f.retrieve.authorsArticles.html)
sapply(v.Filenames.Articles, FUN = f.retrieve.ArticlePages.csv)

# combine the individual result files into single data frames
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/data_sakhrit/csv")
#setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/convert_sakhrit-to-tei/data/test/csv")
v.Filenames.Authors <- list.files(pattern="authorsArticles*", full.names=TRUE)
v.Filenames.Articles <- list.files(pattern="ArticlePages*", full.names=TRUE)
v.Filenames.Contents <- list.files(pattern="contents*", full.names=TRUE)

# Purrr:: read all files and combine them into one dataframe
data.sakhrit.authorsArticles <- purrr::map_df(v.Filenames.Authors, read.csv)
data.sakhrit.articles <- purrr::map_df(v.Filenames.Articles, read.csv)
data.sakhrit.contents <- purrr::map_df(v.Filenames.Contents, read.csv)

# do some data cleaning:
data.sakhrit.authorsArticles <- data.sakhrit.authorsArticles %>%
  # 1. rename columns
  dplyr::rename(
    article.title = article.title.1.35.,
    article.url = article.url.1.35.,
    journal.title = journal.title.1.35.,
    journal.issue = journal.issue.1.35.,
    author.url = source.url
  ) %>%
  # 2. remove all rows that contain NA values or numbers for article title
  tidyr::drop_na(article.url)

# load data
data.sakhrit.contents <- read_csv("contents_all.csv")
# fix data types: dates
data.sakhrit.contents$date.publication.iso <- anydate(data.sakhrit.contents$date.publication.iso)

# write results to file
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/data_sakhrit/")
write.table(data.sakhrit.authorsArticles, file = "csv/authorsArticles_all.csv", row.names = F, quote = T, sep = ",")
save(data.sakhrit.authorsArticles, file = "rda/authorsArticles_all.rda")

write.table(data.sakhrit.contents, file = "csv/contents_all.csv", row.names = F, quote = T, sep = ",")
save(data.sakhrit.contents, file = "rda/contents_all.rda")

# filter for specific periods
data.sakhrit.contents.1870to1920 <- f.date.publication.period(data.sakhrit.contents, "1870-01-01", "1920-12-31")
write.table(data.sakhrit.contents.1870to1920, file = "csv/contents_1870-1920.csv", row.names = F, quote = T, sep = ",")
save(data.sakhrit.contents.1870to1920, file = "rda/contents_1870-1920.rda")

# slice data into rolling decades
## load data
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/data_sakhrit/")
load("rda/contents_all.rda")
## 1. define start year
## 2. define a stop year
## 3. select data that falls between the two
## 4. increment start year by one and repeat until start year equals stop year

f.date.slice.decade <- function(df.input, date.start, date.stop) {
  date.decade <- date.start + 9
  #df.input <- data.sakhrit.contents
  if(date.start <= date.stop) {
    # limit df.input to current decade
    v.Df <- df.input[lubridate::year(df.input$date.publication.iso) >= date.start & lubridate::year(df.input$date.publication.iso) <= date.decade,]
    # save output
    write.table(v.Df, file = paste("csv/contents_",date.start ,"-", date.decade, ".csv", sep = ""), row.names = F, quote = T, sep = ",")
    save(v.Df, file = paste("rda/contents_",date.start ,"-", date.decade, ".rda", sep = ""))
    f.date.slice.decade(df.input, date.start + 1, date.stop)
  }
}

f.date.slice.decade(data.sakhrit.contents, 1876, 2008)


# convert to and save as XML
v.Data <- data.sakhrit.authorsArticles
v.Xml <- xmlTree()
v.Xml$addTag("TEI", close = F)
v.Xml$addTag("teiHeader", close = T)
v.Xml$addTag("text", close = F)
v.Xml$addTag("body", close = F)
v.Xml$addTag("div", close = F)
v.Xml$addTag("listBibl", close = F)

for (i in 1:nrow(v.Data)) {
  # Url to the authorsArticles page as source
  v.Source <- as.character(v.Data[i, "author.url"])
  v.Xml$addTag("biblStruct", attrs = c(source = v.Source), close = F)
  #for (j in names(v.Data)) {
  #  v.Xml$addTag(j, v.Data[i, j])
  #}
  # article information
  v.Xml$addTag("analytic", close = F )
  # author
  #v.Xml$addTag("author", attrs = c(ref = paste("aid", sub(".+AID=(\d+)", "$1", v.Source, perl = T), sep = ":")), close = F)
  v.Xml$addTag("author", attrs = c(ref = v.Source), close = F)
  v.Xml$addTag("persName", v.Data[i, "author.name"])
  v.Xml$closeTag() # author
  # title
  v.Xml$addTag("title", v.Data[i, "article.title"], attrs = c(level="a"))
  # link to article
  v.Xml$addTag("idno", v.Data[i, "article.url"], attrs = c(type="url"))
  v.Xml$closeTag() # analytic
  # journal information
  v.Xml$addTag("monogr", close = F )
  # title
  v.Xml$addTag("title", v.Data[i, "journal.title"], attrs = c(level="j"))
  # editor and imprint are missing at this point
  # issue etc.
  v.Xml$addTag("biblScope", v.Data[i, "journal.issue"], attrs = c(unit="issue"))
  v.Xml$closeTag() # monogr
  v.Xml$closeTag() # biblStruct
}
v.Xml$closeTag() # listBibl
v.Xml$closeTag() # div
v.Xml$closeTag() # body
v.Xml$closeTag() # text
v.Xml$closeTag() # TEI

# view the result
#cat(saveXML(v.Xml))
# save the result
saveXML(v.Xml, file = "authorsArticles_all.TEIP5.xml", indent = T, encoding = "utf-8")



