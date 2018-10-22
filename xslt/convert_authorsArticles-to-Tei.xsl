<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <!-- this stylesheet should be run on a potentially huge collection of files (some 15000 files) that need pre-processing  -->
    <!-- TO DO:
   	    - run everything on a collection
   	    - generate proper TEI files 
   	    - add a way to account for additional pages not currently scraped but indicated by page links below a table
   	    - harvest total article count
   	-->
    <!-- get the author name and ID -->
    <xsl:variable name="v_author-name">
        <xsl:element name="tei:persName">
            <xsl:attribute name="xml:lang" select="'ar'"/>
            <xsl:value-of
                select="normalize-space(descendant-or-self::node()[@id = 'ContentPlaceHolder1_lbAuthorName'])"
            />
        </xsl:element>
    </xsl:variable>
    <!--<xsl:variable name="v_author-id" select="substring-after(base-uri(), 'AID=')"/>-->
    <xsl:variable name="v_author-id" select=" replace(base-uri(),'.+AID=(\d+).*$','$1')"/>
    <xsl:variable name="v_file-name" select="substring-before(tokenize(base-uri(), '/')[last()],'.html')"/>
    <!-- generate and safe output file -->
    <xsl:template match="/">
        <xsl:result-document href="../_output/{$v_file-name}.TEIP5.xml">
            <xsl:value-of select="'&lt;?xml-stylesheet type=&quot;text/xsl&quot; href=&quot;https://rawgit.com/tillgrallert/tei-boilerplate-arabic-editions/online/xslt-boilerplate/teibp_parameters.xsl&quot;?>'" disable-output-escaping="yes"/>
            <xsl:element name="tei:TEI">
                <!-- add a header with source information -->
                <xsl:copy-of select="$v_teiHeader"/>
                <!-- body of the TEI file containing the bibliographic information -->
                <xsl:element name="tei:text">
                    <xsl:element name="tei:body">
                        <xsl:element name="tei:div">
                            <xsl:apply-templates mode="m_table-to-bibl"
                                select="descendant-or-self::table[@id = 'ContentPlaceHolder1_gvSearchResult']"
                            />
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:result-document>
    </xsl:template>
    <!-- transform HTML to TEI -->
    <xsl:template match="table" mode="m_table-to-bibl">
        <xsl:element name="tei:listBibl">
            <xsl:attribute name="corresp" select="$v_file-name"/>
            <xsl:attribute name="xml:lang" select="'ar'"/>
            <xsl:element name="tei:head">
                <xsl:copy-of select="$v_author-name"/>
            </xsl:element>
            <xsl:apply-templates mode="m_table-to-bibl" select="tr[not(child::th)]"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tr" mode="m_table-to-bibl">
        <xsl:element name="tei:biblStruct">
            <!-- article information -->
            <xsl:element name="tei:analytic">
                <!-- author information -->
                <xsl:element name="tei:author">
                    <xsl:attribute name="ref" select="concat('sakhrit:', $v_author-id)"/>
                    <xsl:copy-of select="$v_author-name"/>
                </xsl:element>
                <!-- article title -->
                <xsl:element name="tei:title">
                    <xsl:attribute name="level" select="'a'"/>
                    <xsl:value-of select="normalize-space(td[1])"/>
                </xsl:element>
                <!-- link to article -->
                <xsl:element name="tei:idno">
                    <xsl:attribute name="type" select="'url'"/>
                    <xsl:value-of
                        select="concat('http://archive.sakhrit.co/', td[1]/a/@href)"/>
                </xsl:element>
                <xsl:element name="tei:idno">
                    <xsl:attribute name="type" select="'sakhritArticle'"/>
                    <xsl:value-of select="replace(td[1]/a/@href, '.+=(\d+)$', '$1')"/>
                </xsl:element>
            </xsl:element>
            <!-- journal information -->
            <xsl:element name="tei:monogr">
                <!-- journal title -->
                <xsl:element name="tei:title">
                    <xsl:attribute name="level" select="'j'"/>
                    <xsl:value-of select="normalize-space(td[2])"/>
                </xsl:element>
                <!-- editor is not provided -->
                <!-- imprint information is generally lacking and must be added later -->
                <xsl:element name="tei:imprint">
                    <xsl:element name="tei:publisher"/>
                    <xsl:element name="tei:pubPlace"/>
                    <xsl:element name="tei:date">
                        <!-- detailed date information is available on the article page linked by the URL above -->
                        <xsl:attribute name="when"
                            select="replace(normalize-space(td[3]), '.*(\d{4})', '$1')"/>
                    </xsl:element>
                </xsl:element>
                <!-- date / issue information -->
                <xsl:element name="tei:biblScope">
                    <!-- detailed issue information is available on the article page linked by the URL above -->
                    <xsl:attribute name="unit" select="'issue'"/>
                    <xsl:value-of select="normalize-space(td[3])"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- add a way to account for additional pages not currently scraped -->
    <xsl:template match="tr[@class = 'PagerStyle']" mode="m_table-to-bibl">
        <xsl:element name="tei:note">
            <xsl:text>Total number of pages: </xsl:text>
            <xsl:element name="tei:num">
                <xsl:attribute name="value" select="count(descendant::table/tr/td)"/>
                <xsl:value-of select="count(descendant::table/tr/td)"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <!-- provide a teiHeader -->
    <xsl:variable name="v_teiHeader">
        <xsl:element name="tei:teiHeader">
            <xsl:element name="tei:fileDesc">
                <xsl:attribute name="xml:lang" select="'en'"/>
                <xsl:element name="tei:titleStmt">
                    <xsl:element name="tei:title">
                        <xsl:text>Periodical articles by </xsl:text>
                        <xsl:copy-of select="$v_author-name"/>
                        <xsl:text> and recorded on </xsl:text>
                        <xsl:element name="tei:orgName">
                            <xsl:text>archive.sakhrit.co</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="tei:author">
                        <xsl:element name="tei:persName">
                            <xsl:element name="tei:forename">
                                <xsl:text>Till</xsl:text>
                            </xsl:element>
                            <xsl:element name="tei:surname">
                                <xsl:text>Grallert</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="tei:respStmt">
                        <xsl:element name="tei:orgName">
                            <xsl:text>archive.sakhrit.co</xsl:text>
                        </xsl:element>
                        <xsl:element name="tei:resp">
                            <xsl:text>Recording and provision of original bibliographic data</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="tei:respStmt">
                        <xsl:element name="tei:persName">
                            <xsl:element name="tei:forename">
                                <xsl:text>Till</xsl:text>
                            </xsl:element>
                            <xsl:element name="tei:surname">
                                <xsl:text>Grallert</xsl:text>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="tei:resp">
                            <xsl:text>Scraping from website and data conversion into TEI</xsl:text>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="tei:publicationStmt">
                    <xsl:element name="tei:authority">
                        <xsl:element name="tei:persName">
                            <xsl:element name="tei:forename">
                                <xsl:text>Till</xsl:text>
                            </xsl:element>
                            <xsl:element name="tei:surname">
                                <xsl:text>Grallert</xsl:text>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="tei:pubPlace">
                        <xsl:text>Beirut</xsl:text>
                    </xsl:element>
                    <xsl:element name="tei:date">
                        <xsl:attribute name="when" select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
                        <xsl:value-of select="year-from-date(current-date())"/>
                    </xsl:element>
                    <xsl:element name="tei:availability">
                        <xsl:attribute name="status" select="'restricted'"/>
                        <xsl:element name="tei:licence">
                            <xsl:attribute name="target" select="'http://creativecommons.org/licenses/by-sa/4.0/'"></xsl:attribute>
                            <xsl:text>Distributed under a Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) license</xsl:text>
                        </xsl:element>
                    </xsl:element>
                    <!-- potentially link to this file -->
                </xsl:element>
                <xsl:element name="tei:sourceDesc">
                    <xsl:element name="tei:p">
                        <xsl:text>This file was created by extracting bibliographic information from </xsl:text>
                        <xsl:element name="tei:ref">
                            <xsl:attribute name="target" select="concat('http://archive.sakhrit.co/', $v_file-name)"/>
                            <xsl:value-of select="concat('http://archive.sakhrit.co/', $v_file-name)"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:variable>
</xsl:stylesheet>
