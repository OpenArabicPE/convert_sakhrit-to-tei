---
title: "read me: convert_sakhrit-to-tei"
author: Till Grallert
date: 2017-03-17 14:29:58 +0100
---

The XSLT stylesheets in this repository provide a means to transform bibliographic information from [sakhrit.archive.co](http://sakhrit.archive.co) into TEI XML.

The process works in two steps:

1. The stylesheet `sakhrit2tei_metadata.xsl` scrapes one HTML file for each issue of the journal from sakhrit.
2. The stylesheet `sakhrit2tei_main.xsl` transforms the HTML files into TEI XML files for each issue.