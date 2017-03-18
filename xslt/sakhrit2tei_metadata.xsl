<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:till="http://tillgrallert.github.io/xml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output method="text" encoding="UTF-8" omit-xml-declaration="yes" name="text"/>
    <xsl:include href="shell-script_curl.xsl"/>
    
    <!-- this stylesheet constructs an applescript using curl to download tables of content as html from sakhrit -->
    
    <!-- The CID is an arbitrary ID assigned by skhrit to individual journal issues. One has to look them up at the sakhrit website
            - Mawāqif: 15719 - 15818
            - Hilāl: 12720 - 13130 (for the end of 1920) or  14071 (for the end of 2006)
    -->
    <xsl:param name="p_cid-start" select="12720"/>
    <xsl:param name="p_cid-stop" select="13130"/>
    <!-- the journal name is a random string only used for the resulting file names -->
    <xsl:param name="p_title-journal" select="'hilal'"/>
    <!-- this is the base path to a local folder -->
    <xsl:param name="p_path-local" select="'digital-hilal/'"/>
    
    <!-- this is a stable address and should not be changed -->
    <xsl:variable name="v_url-cid" select="'http://archive.sakhrit.co/contents.aspx?CID='"/>
    
    <xsl:template match="/">
        <xsl:variable name="v_increment">
            <xsl:call-template name="t_increment-cid"/>
        </xsl:variable>
        <!-- applescript related variables -->
        <!--<xsl:variable name="v_list-url">
            <xsl:for-each select="$v_increment/descendant::till:url">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="not(position()=last())">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="v_list-url-local">
            <xsl:for-each select="$v_increment/descendant::till:urlLocal">
                <xsl:text>"</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>"</xsl:text>
                <xsl:if test="not(position()=last())">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>-->
        <!-- this will send the variable off to construct the applescript wrapping a curl script -->
       <!-- <xsl:call-template name="t_applescript">
            <xsl:with-param name="p_url-local" select="$v_list-url-local"/>
            <xsl:with-param name="p_url" select="$v_list-url"/>
        </xsl:call-template>-->
        <xsl:result-document href="{$p_title-journal}-metadata.sh" method="text">
            <xsl:call-template name="t_curl-script">
                <xsl:with-param name="p_url" select="$v_increment"/>
                <xsl:with-param name="p_local-name" select="$v_increment"/>
            </xsl:call-template>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="t_increment-cid">
        <xsl:param name="p_cid-start" select="$p_cid-start"/>
        <xsl:param name="p_cid-stop" select="$p_cid-stop"/>
        <xsl:variable name="v_url" select="concat($v_url-cid,$p_cid-start)"/>
        <xsl:element name="till:metadata">
            <xsl:element name="till:url">
            <xsl:value-of select="$v_url"/>
        </xsl:element>
        <xsl:element name="till:urlLocal">
            <xsl:value-of select="concat('html/cid_',$p_cid-start,'.html')"/>
        </xsl:element></xsl:element>
        <xsl:if test="$p_cid-start &lt; $p_cid-stop">
            <xsl:call-template name="t_increment-cid">
                <xsl:with-param name="p_cid-start" select="$p_cid-start + 1"/>
                <xsl:with-param name="p_cid-stop" select="$p_cid-stop"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="t_applescript">
        <xsl:param name="p_url-base"/>
        <xsl:param name="p_url"/>
        <xsl:param name="p_url-local"/>
        <xsl:result-document href="{$p_title-journal}-metadata.scpt"><![CDATA[(* This script tries to download and html files for the journal Mawakif *)]]> 
            <![CDATA[
set vUrlBase to "]]><xsl:value-of select="replace($p_url-base,'\s','')" disable-output-escaping="no"/><![CDATA["]]>
            <![CDATA[
set vUrlLocalBase to "]]><xsl:value-of select="$p_path-local"/><![CDATA["]]>
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
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>