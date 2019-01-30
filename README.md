---
title: "read me: convert_sakhrit-to-tei"
author: Till Grallert
date: 2018-11-05
---

The XSLT stylesheets in this repository provide a means to transform bibliographic information from [archive.sakhrit.co](http://archive.sakhrit.co) into TEI XML.

# scrape one specific journal 

The process works in two steps:

1. The stylesheet `sakhrit2tei_metadata.xsl` scrapes one HTML file for each issue of the journal from sakhrit.
2. The stylesheet `sakhrit2tei_main.xsl` transforms the HTML files into TEI XML files for each issue.

# scrape everything

Sakhrit's website provides different types of detail pages that all provide slightly different sets of bibliographic data.

1. `contents.aspx?CID=` + number: provide information on the issue level, including:
    - author (if known), article title, number of first page
2. `ArticlePages.aspx?ArticleID=` + number: provide information on the article level, including:
    - journal title, issue, date, place, author, facsimiles, issue URL, author URL
    - missing information: article title 
3. `authorsArticles.aspx?AID=` + number: aggregate information on the author level across periodicals
    - Problems: 
        1. the content of the page is limited to 30 entries. A JS provides links to further pages but they were not scraped with wget.
        3. many articles had no byline. Hence there is no author page for them.

## 1. scrape content with wget
## 2. extract bibliographic data with R

The R script [`r/convert_html-table.R`](r/convert_html-table.R) reads all files following a certain naming pattern from a local directory, extracts bibliographic information, normalises dates, and saves everything as .csv and .rda. All functions for data conversion are kept in a separate script (`functions_sakhrit.R`).

### ingest data:  `contents.aspx?CID=` + number

The script extracts bibliographic information using the following naming scheme:

- journal.title
- journal.id
- issue
- issue.id
- date.publication
- date.publication.iso
- author.name
- article.title
- article.url
- article.id
- page.from

### save data

The resulting data frames or tibbles can be converted to xml. Each bibliographic entry is then transformed into TEI P5
`<biblStruct>`s using [`xslt/convert_r-output-to-tei.xsl`](xslt/convert_r-output-to-tei.xsl).

## 3. prepare data with R

1. Slice data: in order to better understand changes over time, the function `f.date.slice.period` allows to slice all data into rolling periods of any number of years.
