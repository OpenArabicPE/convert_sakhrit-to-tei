<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:till="http://tillgrallert.github.io/xml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:kml="http://earth.google.com/kml/2.0"
    xmlns:tss="http://www.thirdstreetsoftware.com/SenteXML-1.0"
    >
    <xsl:output method="xml"  version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no"  name="xml"/>
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes"  name="text"/>
    
    <!-- This helper stylesheet builds a shell script to download images (or any link) from the net to a folder -->
    <!-- The stylesheet can be called from other XSLT stylesheets which have to supply the data for the target folder, the link list, and the list of file names to be generated
        $p_base-path must be a literal string
        $p_url and $p_local-name must be sets of tei:graphic nodes with @url attributes -->
    
    
    
    <xsl:template name="t_curl-script">
        <xsl:param name="p_url"/>
        <xsl:param name="p_local-name"/>
        <xsl:param name="p_base-path"/>
        <xsl:text>curl  -L -C - </xsl:text>
        <xsl:for-each select="$p_url/descendant-or-self::till:url">
<!--            <xsl:variable name="v_position" select="count(preceding::tei:graphic)+1"/>-->
            <xsl:value-of select="."/>
            <xsl:text> -o </xsl:text>
            <xsl:value-of select="concat($p_base-path,following-sibling::till:urlLocal)"/>
            <xsl:text> </xsl:text>
        </xsl:for-each>
    </xsl:template>
  
</xsl:stylesheet>