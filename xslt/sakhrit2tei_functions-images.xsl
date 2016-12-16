<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:till="http://tillgrallert.github.io/xml"
    exclude-result-prefixes="xs"
    version="2.0">
    
 
    <xsl:variable name="v_image-start" select="1"/>
    <!-- 400 -->
    <xsl:variable name="v_image-stop" select="400"/>
    <xsl:variable name="v_url-base" select="'http://archive.sakhrit.co/MagazinePages%5CMagazine_JPG'"/>
    <xsl:variable name="v_url-local" select="'/some/path'"/>
    <xsl:variable name="v_url-separator" select="'/'"/>
    <!-- this should refer to a parameter value in the main stylesheet -->
    <xsl:variable name="v_title-journal_en" select="'Mawakif'"/>
    
    
    <xsl:template name="t_applescript">
        <xsl:param name="p_url-base"/>
        <xsl:param name="p_url"/>
        <xsl:param name="p_url-local"/>
        <xsl:param name="p_year-start"/>
        <xsl:param name="p_year-stop"/>
        <xsl:param name="p_issue-start"/>
        <xsl:param name="p_issue-stop"/>
        
<![CDATA[(* This script tries to download and safe image files for the journal Mawakif, year(s) ]]><xsl:value-of select="$p_year-start"/><![CDATA[ to ]]><xsl:value-of select="$p_year-stop"/><![CDATA[, issue(s) ]]><xsl:value-of select="$p_issue-start"/><![CDATA[ to ]]><xsl:value-of select="$p_issue-stop"/><![CDATA[ *)]]>
           
<![CDATA[
set vUrlBase to "]]><xsl:value-of select="replace($p_url-base,'\s','')" disable-output-escaping="no"/><![CDATA["]]>
<![CDATA[
set vUrlLocalBase to "]]><xsl:value-of select="$v_url-local"/><![CDATA["]]>
<![CDATA[
set vUrl to {]]><xsl:value-of select="$p_url"/><![CDATA[}]]>
<![CDATA[
set vUrlLocal to {]]><xsl:value-of select="$p_url-local"/><![CDATA[}]]>
<![CDATA[        
set vErrors to {}
        
repeat with Y from 1 to (number of items) of vUrl
	set vUrlSelected to item Y of vUrl
	set vUrlLocalSelected to item Y of vUrlLocal
	
	try
		do shell script "curl -o '" & vUrlLocalBase & vUrlLocalSelected & "' " & vUrlSelected
	on error
		set end of vErrors to vUrlSelected & ", "
		set the clipboard to vErrors as text
	end try
end repeat
]]>
<![CDATA[
tell application "TextEdit"
	make new document
	set text of document 1 to (the clipboard as text)
	save document 1 in "errors.txt"
end tell 
]]>
        
    </xsl:template>
    
    <!-- increment  -->
    <xsl:template name="t_increment-year">
        <xsl:param name="p_year-start"/>
        <xsl:param name="p_year-stop"/>
        <xsl:param name="p_issue-start"/>
        <xsl:param name="p_issue-stop"/>
        <xsl:call-template name="t_increment-issue">
            <xsl:with-param name="p_issue-start" select="$p_issue-start"/>
            <xsl:with-param name="p_issue-stop" select="$p_issue-stop"/>
            <xsl:with-param name="p_year" select="$p_year-start"/>
        </xsl:call-template>
        <xsl:if test="$p_year-start &lt; $p_year-stop">
            <xsl:call-template name="t_increment-year">
                <xsl:with-param name="p_year-start" select="$p_year-start + 1"/>
                <xsl:with-param name="p_year-stop" select="$p_year-stop"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="t_increment-issue">
        <xsl:param name="p_issue-start"/>
        <xsl:param name="p_issue-stop"/>
        <xsl:param name="p_year"/>
        <xsl:call-template name="t_increment-image">
            <xsl:with-param name="p_image-start" select="$v_image-start"/>
            <xsl:with-param name="p_image-stop" select="$v_image-stop"/>
            <xsl:with-param name="p_year" select="$p_year"/>
            <xsl:with-param name="p_issue" select="$p_issue-start"/>
        </xsl:call-template>
        <xsl:if test="$p_issue-start lt $p_issue-stop">
            <xsl:call-template name="t_increment-issue">
                <xsl:with-param name="p_issue-start" select="$p_issue-start + 1"/>
                <xsl:with-param name="p_issue-stop" select="$p_issue-stop"/>
                <xsl:with-param name="p_year" select="$p_year"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="t_increment-image">
        <xsl:param name="p_image-start"/>
        <xsl:param name="p_image-stop"/>
        <xsl:param name="p_year"/>
        <xsl:param name="p_issue"/>
        <xsl:element name="till:image">
            <xsl:attribute name="year" select="$p_year"/>
            <xsl:attribute name="issue" select="$p_issue"/>
            <xsl:attribute name="n" select="$p_image-start"/>
            <xsl:element name="till:url">
                <xsl:value-of select="concat($v_url-base,$v_url-separator,$v_title-journal_en,$v_url-separator,$v_title-journal_en,'_',$p_year,$v_url-separator,'Issue_',$p_issue,$v_url-separator,format-number($p_image-start,'000'),'.JPG')"/>
            </xsl:element>
            <xsl:element name="till:urlLocal">
                <xsl:value-of select="concat('/y_',$p_year,'-i_',$p_issue,'-p_',format-number($p_image-start,'000'),'.jpg')"/>
            </xsl:element>
        </xsl:element>
        <xsl:if test="$p_image-start lt $p_image-stop">
            <xsl:call-template name="t_increment-image">
                <xsl:with-param name="p_image-start" select="$p_image-start + 1"/>
                <xsl:with-param name="p_image-stop" select="$p_image-stop"/>
                <xsl:with-param name="p_issue" select="$p_issue"/>
                <xsl:with-param name="p_year" select="$p_year"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>