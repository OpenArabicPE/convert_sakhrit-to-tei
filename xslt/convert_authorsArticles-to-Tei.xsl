<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="3.0" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <!-- this stylesheet should be run on a potentially huge collection of files (some 15000 files) that need pre-processing  -->
   	<!-- TO DO:
   		- save output to file  -->
    <!-- get the author name and ID -->
    <xsl:variable name="v_author-name"
        select="descendant::node()[@id = 'ContentPlaceHolder1_lbAuthorName']"/>
    <xsl:variable name="v_author-id" select="substring-after(base-uri(), 'AID=')"/>
    <xsl:template match="/">
        <xsl:apply-templates mode="m_table-to-bibl"
            select="descendant::html:table[@id = 'ContentPlaceHolder1_gvSearchResult']"/>
    </xsl:template>
    <xsl:template match="html:table" mode="m_table-to-bibl">
        <xsl:element name="tei:listBibl">
        	<xsl:attribute name="corresp" select="tokenize(base-uri(),'/')[last()]"/>
            <xsl:apply-templates mode="m_table-to-bibl" select="html:tr[not(child::html:th)]"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="html:tr" mode="m_table-to-bibl">
        <xsl:element name="tei:biblStruct">
            <!-- author information -->
            <xsl:element name="tei:author">
                <xsl:attribute name="ref" select="concat('sakhrit:', $v_author-id)"/>
                <xsl:element name="tei:persName">
                    <xsl:value-of select="normalize-space($v_author-name)"/>
                </xsl:element>
            </xsl:element>
            <!-- article title -->
            <xsl:element name="tei:title">
                <xsl:attribute name="level" select="'a'"/>
                <xsl:value-of select="normalize-space(html:td[1])"/>
            </xsl:element>
            <!-- article -->
            <xsl:element name="tei:idno">
                <xsl:attribute name="type" select="'url'"/>
                <xsl:value-of select="concat('http://archive.sakhrit.co/', html:td[1]/html:a/@href)"
                />
            </xsl:element>
            <xsl:element name="tei:idno">
                <xsl:attribute name="type" select="'sakhritArticle'"/>
                <xsl:value-of select="replace(html:td[1]/html:a/@href, '.+=(\d+)$', '$1')"/>
            </xsl:element>
            <!-- journal information -->
            <xsl:element name="tei:monogr">
                <!-- journal title -->
                <xsl:element name="tei:title">
                    <xsl:attribute name="level" select="'j'"/>
                    <xsl:value-of select="normalize-space(html:td[2])"/>
                </xsl:element>
                <!-- editor is not provided -->
                <!-- imprint information is generally lacking and must be added later -->
                <xsl:element name="tei:imprint">
                    <xsl:element name="tei:publisher"/>
                    <xsl:element name="tei:pubPlace"/>
                </xsl:element>
                <!-- date / issue information -->
                <xsl:element name="tei:biblScope">
                    <!-- detailed issue information is available on the article page linked by the URL above -->
                    <xsl:attribute name="unit" select="'issue'"/>
                    <xsl:value-of select="normalize-space(html:td[3])"/>
                </xsl:element>
                <xsl:element name="tei:date">
                    <!-- detailed date information is available on the article page linked by the URL above -->
                    <xsl:attribute name="when"
                        select="replace(normalize-space(html:td[3]), '.*(\d{4})', '$1')"/>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="html:tr[@class = 'PagerStyle']" mode="m_table-to-bibl"/>
</xsl:stylesheet>
