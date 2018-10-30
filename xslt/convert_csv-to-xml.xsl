<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xsl xs fn local" version="3.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:local="http://www.seanbdurkin.id.au/xslt/csv-to-xml.xslt"
    xmlns:xcsv="http://www.seanbdurkin.id.au/xslt/xcsv.xsd"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    <!--<xsl:import-schema schema-location="http://www.seanbdurkin.id.au/xslt/xcsv.xsd"
        use-when="system-property('xsl:is-schema-aware') = 'yes'"/>-->
    <!-- Read Me ! -->
    <!-- ************************************************************************</strong> -->
    <!-- A significant part of this style-sheet is derived from or copied from     -->
    <!-- Andrew Welch's solution. Refer: http://andrewjwelch.com/code/xslt/csv/csv-to-xml_v2.html -->
    <!-- Modifications have been made by me (Sean B. Durkin) in order to meet the design         -->
    <!-- goals as described here:                                                                -->
    <!-- http://pascaliburnus.seanbdurkin.id.au/index.php?/archives/17-A-Generalised-and-Compreh -->
    <!--ensive-Solution-to-CSV-to-XML-and-XML-to-CSV-Transformations.html				         -->
    <!-- Stylesheet parameters -->
    <!-- ************************************************************************<strong> -->
    <xsl:param as="xs:string" name="url-of-csv" select="'/BachUni/BachBibliothek/GitHub/OpenArabicPE/data_sakhrit/_output/csv/contents_all.csv'"/>
    <xsl:param as="xs:string" name="lang" select="'en'"/>
    <xsl:param as="xs:string" name="url-of-messages"/>
    <!-- Configurable constants -->
    <!-- ************************************************************************</strong> -->
    <xsl:variable as="xs:string" name="quote">"</xsl:variable>
    <xsl:variable name="error-messages-i18n">
        <xcsv:error error-code="1">
            <xcsv:message xml:lang="en">Uncategorised error.</xcsv:message>
        </xcsv:error>
        <xcsv:error error-code="2">
            <xcsv:message xml:lang="en">Quoted value not terminated.</xcsv:message>
        </xcsv:error>
        <xcsv:error error-code="3">
            <xcsv:message xml:lang="en">Quoted value incorrectly terminated.</xcsv:message>
        </xcsv:error>
        <xcsv:error error-code="5">
            <xcsv:message xml:lang="en">Could not open CSV resource.</xcsv:message>
        </xcsv:error>
    </xsl:variable>
    <!-- Non-configurable constants -->
    <!-- ************************************************************************<strong> -->
    <xsl:variable name="error-messages">
        <xsl:apply-templates mode="messages" select="$error-messages-i18n"/>
    </xsl:variable>
    <xsl:template match="@* | node()" mode="messages">
        <xsl:copy>
            <xsl:apply-templates mode="messages" select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template
        match="xcsv:message[not(@xml:lang = $lang) and (not(@xml:lang = 'en') or ../xcsv:message[@xml:lang = $lang])]"
        mode="messages"/>
    <xsl:function as="xs:string+" name="local:unparsed-text-lines">
        <xsl:param as="xs:string" name="href"/>
        <xsl:sequence select="fn:unparsed-text-lines($href)"
            use-when="function-available('unparsed-text-lines')"/>
        <xsl:sequence
            select="tokenize(unparsed-text($href), '\r\n|\r|\n')[not(position() = last() and . = '')]"
            use-when="not(function-available('unparsed-text-lines'))"/>
    </xsl:function>
    <xsl:function as="node()" name="local:error-node">
        <xsl:param as="xs:integer" name="error-code"/>
        <xsl:param as="xs:string" name="data"/>
        <xcsv:error error-code="{$error-code}">
            <xcsv:message
                xml:lang="{$error-messages/xcsv:error[@error-code=$error-code]/xcsv:message/@xml:lang}">
                <xsl:value-of
                    select="$error-messages/xcsv:error[@error-code = $error-code]/xcsv:message"/>
            </xcsv:message>
            <xcsv:error-data>
                <xsl:value-of select="$data"/>
            </xcsv:error-data>
        </xcsv:error>
    </xsl:function>
    <xsl:function as="node()+" name="local:csv-to-xml">
        <xsl:param as="xs:string" name="href"/>
        <xcsv:comma-separated-single-line-values xcsv-version="1.0">
            <xcsv:notice xml:lang="en"><!--&notice;--></xcsv:notice>
            <xsl:choose>
                <xsl:when test="fn:unparsed-text-available($href)">
                    <xsl:for-each select="local:unparsed-text-lines($href)">
                        <xcsv:row>
                            <xsl:analyze-string regex="((&quot;[^&quot;]*&quot;)+|[^,&quot;]*),"
                                select="fn:concat(., ',')">
                                <xsl:matching-substring>
                                    <xcsv:value>
                                        <xsl:choose>
                                            <xsl:when
                                                test="fn:starts-with(fn:regex-group(1), $quote)">
                                                <xsl:value-of
                                                  select="fn:replace(fn:regex-group(1), &quot;^&quot;&quot;|&quot;&quot;$|(&quot;&quot;)&quot;&quot;&quot;, &quot;$1&quot;)"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xcsv:value>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:copy-of select="local:error-node(3, .)"/>
                                    <!-- Quoted value incorrectly terminated. -->
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xcsv:row>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="local:error-node(5, $href)"/>
                    <!-- Could not open CSV resource. -->
                </xsl:otherwise>
            </xsl:choose>
        </xcsv:comma-separated-single-line-values>
    </xsl:function>
    <xsl:template match="/" name="local:main">
        <xsl:copy-of select="local:csv-to-xml($url-of-csv)"/>
    </xsl:template>
</xsl:stylesheet>
