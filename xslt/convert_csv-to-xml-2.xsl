<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://www.seanbdurkin.id.au/xslt/csv-to-xml.xslt"
    exclude-result-prefixes="xs"
    version="3.0">
   <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="/">
        <xsl:param name="p_csv-url" select="descendant::tei:sourceDesc//tei:idno[@type='url']" as="xs:string"/>
        <tei:TEI>
            <tei:teiHeader/>
            <tei:text>
                <tei:body>
                    <tei:div>
                         <xsl:choose>
                             <xsl:when test="unparsed-text-available($p_csv-url)">
                                 <xsl:for-each select="local:unparsed-text-lines($p_csv-url)">
                                     <tei:bibl>
                                         <xsl:value-of select="."/>
                                     </tei:bibl>
                                 </xsl:for-each>
                             </xsl:when>
                         </xsl:choose>
                    </tei:div>
                </tei:body>
            </tei:text>
        </tei:TEI>
        
    </xsl:template>
    
    <xsl:function as="xs:string+" name="local:unparsed-text-lines">
        <xsl:param as="xs:string" name="href"/>
        <xsl:sequence select="unparsed-text-lines($href)"
            use-when="function-available('unparsed-text-lines')"/>
        <xsl:sequence
            select="tokenize(unparsed-text($href), '\r\n|\r|\n')[not(position() = last() and . = '')]"
            use-when="not(function-available('unparsed-text-lines'))"/>
    </xsl:function>
    
</xsl:stylesheet>