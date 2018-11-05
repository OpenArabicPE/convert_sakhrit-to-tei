library(XML)

# load sample data
setwd("/BachUni/BachBibliothek/GitHub/OpenArabicPE/data_sakhrit")
load("rda/contents_1870-1920.rda")

convertToXML <- function (df, name) {
  xml <- xmlTree()
  xml$addNode(name, close = F)
  for (i in 1:nrow(df)) {
    xml$addNode("value", close = F)
    for (j in names(df)) {
      xml$addNode(j, df[i,j])
    }
    xml$closeTag()
  }
  xml$closeTag()
}

convertToXML(v.Df, "Test")

f.convert.to.xml <- function(dataframe, filename) {
  v.Xml <- xmlTree()
  v.Xml$addNode("tibble", close = F)
  for (i in 1:nrow(dataframe)) {
    v.Xml$addNode("row", close = F)
    for (j in names(dataframe)) {
      v.Xml$addNode(j, dataframe[i,j])
    }
    v.Xml$closeTag()
  }
  v.Xml$closeTag()
  saveXML(v.Xml, file = paste("_output/xml/", filename, ".xml", sep = ""), indent = T, encoding = "utf-8")
}

# convert files
f.convert.to.xml(dataframe = v.Df, filename = "test_v.Df")
f.convert.to.xml(dataframe = data.sakhrit.contents.1870to1920, filename = "contents_1870-1920")

# convert to and save as XML
v.Data <- v.Df
v.Xml <- xmlTree()
v.Xml$addTag("TEI", close = F)
v.Xml$addTag("teiHeader", close = T)
v.Xml$addTag("text", close = F)
v.Xml$addTag("body", close = F)
v.Xml$addTag("div", close = F)
v.Xml$addTag("listBibl", close = F)
# to be run on the output from contents.aspx
for (i in 1:nrow(v.Data)) {
  # Url to the authorsArticles page as source
  #v.Source <- as.character(v.Data[i, "article.url"])
  #v.Xml$addTag("biblStruct", attrs = c(source = v.Source), close = F)
  v.Xml$addTag("biblStruct", close = F)
  #for (j in names(v.Data)) {
  #  v.Xml$addTag(j, v.Data[i, j])
  #}
    # article information
    v.Xml$addTag("analytic", close = F )
    # author
    #v.Xml$addTag("author", attrs = c(ref = paste("aid", sub(".+AID=(\d+)", "$1", v.Source, perl = T), sep = ":")), close = F)
      v.Xml$addTag("author", close = F)
        #v.Xml$addTag("persName", v.Data[i, "author.name"])
      v.Xml$closeTag() # author
    # title
      v.Xml$addTag("title", v.Data[i, "article.title"], attrs = c(level="a"))
      # link to article
      v.Xml$addTag("idno", v.Data[i, "article.url"], attrs = c(type="url"))
      v.Xml$addTag("idno", v.Data[i, "article.id"], attrs = c(type="id"))
    v.Xml$closeTag() # analytic
    # journal information
    v.Xml$addTag("monogr", close = F )
      # title
      v.Xml$addTag("title", v.Data[i, "journal.title"], attrs = c(level="j"))
      # editor and imprint are missing at this point
      # issue etc.
      v.Xml$addTag("biblScope", v.Data[i, "journal.issue"], attrs = c(unit="issue"))
      v.Xml$addTag("idno", v.Data[i, "issue.id"], attrs = c(type="id"))
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
saveXML(v.Xml, file = "_output/xml/test.TEIP5.xml", indent = T, encoding = "utf-8")

