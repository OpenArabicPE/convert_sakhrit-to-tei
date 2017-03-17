<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:till="http://tillgrallert.github.io/xml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8" version="1.0"/>

    <xsl:include href="sakhrit2tei_functions-images.xsl"/>
    
    <!-- this stylesheet transforms the html input from sakhrit into tei xml files -->

    <!-- periodical specific parameters -->
    <!-- $p_id-sakhrit refers to the periodical's ID at the sakhrit website, such as:
        - al-Muqtaṭaf: 107
        - al-Muqtabas: 125
        - al-Ustādh: 106
        - al-Hilāl : 134
        - al-Bayān: 161
        - al-Manār: 33
        - al-Mashriq: 108
        - Mawaqif: 11
    -->
    <xsl:param name="p_id-sakhrit" select="11"/>
    
    <!-- $p_last-page depends on the periodical and should be generously selected to catch all pages -->
    <xsl:param name="p_last-page" select="300"/>
    
    
    <!-- $p_periodicals holds <tei:biblStruct> for every periodical -->
    <xsl:param name="p_periodicals">
        <listBibl>
            <!-- @n refers to the periodical's ID on the sakhrit website -->
            <biblStruct xml:lang="en" n="134">
                <monogr>
                    <title level="j" xml:lang="ar">الهلال</title>
                    <title level="j" type="sub" xml:lang="ar">مجلة علمية تاريخية صحية أدبية</title>
                    <title level="j" xml:lang="ar-Latn-x-ijmes">al-Hilāl</title>
                    <title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">majalla ʿilmiyya tārīkhiyya ṣaḥḥiyya adabiyya</title>
                    <editor ref="https://viaf.org/viaf/76496271">
                        <persName xml:lang="ar">
                            <forename>جرجي</forename>
                            <surname>زيدان</surname>
                        </persName>
                        <persName xml:lang="ar-Latn-x-ijmes">
                            <forename>Jirjī</forename>
                            <surname>Zaydān</surname>
                        </persName>
                    </editor>
                    <imprint>
                        <publisher>
                            <orgName xml:lang="ar">مطبعة الهلال</orgName>
                            <orgName xml:lang="ar-Latn-x-ijmes">Maṭbaʿat al-Hilāl</orgName>
                        </publisher>
                        <pubPlace>
                            <placeName xml:lang="ar">القاهرة</placeName>
                            <placeName xml:lang="ar-Latn-x-ijmes">al-Qāhira</placeName>
                            <placeName xml:lang="en">Cairo</placeName>
                        </pubPlace>
                        <!-- this needs processing later on -->
                        <date xml:lang="ar"/>
                    </imprint>
                    <!-- this needs processing later on -->
                    <biblScope unit="volume"/>
                    <biblScope unit="issue"/>
                    <biblScope unit="page" from="1" to=""/>
                </monogr>
                <idno type="oclc">1639361</idno>
                <idno type="oclc">183194011</idno>
                <idno type="issn">1110-8908</idno>
            <idno type="sakhrit" xml:lang="en">134</idno>
        </biblStruct>
        <biblStruct xml:lang="en" n="125">
            <monogr xml:lang="en">
                <title level="j" xml:lang="ar">المقتبس</title>
                <title level="j" xml:lang="ar" type="sub">مجلة أدبية علمية اجتماعية تصدر بالقاهرة في غرة كل شهر عربي</title>
                <title level="j" xml:lang="ar-Latn-x-ijmes">al-Muqtabas</title>
                <title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">Majalla adabiyya ʿilmiyya ijtimāʿiyya tuṣadir bi-l-Qāhira fī gharrat kull shahr ʿarabī</title>
                <title level="j" xml:lang="fr">Al-Moktabas</title>
                <title level="j" type="sub" xml:lang="fr">Revue mensuelle, littéraire, scientifique &amp; Sociologique</title>
                <editor ref="https://viaf.org/viaf/32272677"> 
                    <persName xml:lang="ar"> 
                        <forename xml:lang="ar">محمد</forename>
                        <surname xml:lang="ar">كرد علي</surname> 
                    </persName> 
                    <persName xml:lang="ar-Latn-x-ijmes"> 
                        <forename xml:lang="ar-Latn-x-ijmes">Muḥammad</forename> 
                        <surname xml:lang="ar-Latn-x-ijmes">Kurd ʿAlī</surname>
                    </persName> 
                </editor>
                <imprint xml:lang="en">
                    <publisher> 
                        <orgName xml:lang="ar">مطبعة الظاهر</orgName> 
                        <orgName xml:lang="ar-Latn-x-ijmes">Maṭbaʿa al-Ẓāhir</orgName> 
                    </publisher>
                    <publisher> 
                        <orgName xml:lang="ar">المطبعة العمومية</orgName> 
                        <orgName xml:lang="ar-Latn-x-ijmes">al-Maṭbaʿa al-ʿUmūmiyya</orgName> 
                    </publisher>
                    <pubPlace xml:lang="en"> 
                        <placeName xml:lang="ar">القاهرة</placeName> 
                        <placeName xml:lang="ar-Latn-x-ijmes">al-Qāhira</placeName> 
                        <placeName xml:lang="fr">Caire</placeName> 
                        <placeName xml:lang="en">Cairo</placeName> 
                    </pubPlace>
                    <!-- this needs processing later on -->
                    <date xml:lang="ar"/>
                </imprint>
                <!-- this needs processing later on -->
                <biblScope unit="volume"/>
                <biblScope unit="issue"/>
                <biblScope unit="page" from="1" to=""/>
            </monogr>
            <idno type="oclc" xml:lang="en">4770057679</idno>
            <idno type="oclc" xml:lang="en">79440195</idno>
            <idno type="aucr" xml:lang="en">07201136864</idno>
            <idno type="shamela" xml:lang="en">26523</idno>
            <idno type="sakhrit" xml:lang="en">125</idno>
        </biblStruct>
        <biblStruct xml:lang="en" n="11">
            <monogr xml:lang="en">
                <title level="j" xml:lang="ar">مواقف</title>
                <title level="j" type="sub" xml:lang="ar">للحرية، والإبداع، والتغير</title>
                <title level="j" xml:lang="ar-Latn-x-ijmes">Mawāqif</title>
                <title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">li-l-ḥurriyya, wa-l-ibdāʿ wa-l-taghayyur</title>
                <tei:title xml:lang="ar-Latn-x-sakhrit" level="j">Mawakif</tei:title>
                <editor ref="https://viaf.org/viaf/27059798">
                    <persName xml:lang="ar">أدونيس</persName>
                    <persName xml:lang="ar-Latn-x-ijmes">Adūnīs</persName>
                </editor>
                <imprint xml:lang="en">
                    <pubPlace xml:lang="en">
                        <placeName xml:lang="ar">بيروت</placeName>
                        <placeName xml:lang="ar-Latn-x-ijmes">Bayrūt</placeName>
                        <placeName xml:lang="en">Beirut</placeName>
                    </pubPlace>
                    <!-- this needs processing later on -->
                    <date xml:lang="ar"/>
                </imprint>
                <!-- this needs processing later on -->
                <biblScope unit="volume"/>
                <biblScope unit="issue"/>
                <biblScope unit="page" from="1" to=""/>
            </monogr>
            <idno type="oclc" xml:lang="en">792755362</idno>
            <idno type="sakhrit" xml:lang="en">11</idno>
        </biblStruct>
        </listBibl>
    </xsl:param>
    
    <!-- variables based on the selected periodical -->
    <xsl:variable name="v_biblstruct" select="$p_periodicals/descendant::tei:biblStruct[@n=$p_id-sakhrit]"/>
    <xsl:variable name="v_id-oclc" select="$v_biblstruct/descendant::tei:idno[@type='oclc'][1]"/>
    <xsl:variable name="v_title-journal" select="$v_biblstruct/descendant::tei:title[not(@type='sub')]"/>
    
    
    <!-- these parameters should not be changed  -->
    <xsl:param name="p_id-facs" select="'facs_'"/>

    <xsl:template match="html:html">
        <!-- some variables -->
        <xsl:variable name="v_year">
            <xsl:analyze-string select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_Label1']" regex="(\d{{4}})">
                <xsl:matching-substring>
                    <xsl:value-of select="number(regex-group(1))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="v_issue">
            <xsl:analyze-string select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_lbissuenumber']" regex="(\d+)">
                <xsl:matching-substring>
                    <xsl:value-of select="number(regex-group(1))"/>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:variable name="v_increment">
            <xsl:call-template name="t_increment-image">
                <xsl:with-param name="p_image-start" select="1"/>
                <xsl:with-param name="p_image-stop" select="$p_last-page"/>
                <xsl:with-param name="p_issue" select="$v_issue"/>
                <xsl:with-param name="p_year" select="$v_year"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- check, if the cid points to the correct journal -->
        <xsl:if test="descendant::html:td[@class='F_MagazineName']/html:table/html:tr[1]//html:a/@href='newmagazineYears.aspx?MID=11'">
        <!-- build the output -->
        <xsl:result-document href="../xml/oclc_{$v_id-oclc}-i_{$v_issue}.TEIP5.xml">
            <xsl:value-of select="'&lt;?xml-model href=&quot;https://rawgit.com/OpenArabicPE/OpenArabicPE_ODD/master/schema/tei_periodical.rng&quot; type=&quot;application/xml&quot; schematypens=&quot;http://relaxng.org/ns/structure/1.0&quot;?>'" disable-output-escaping="yes"/>
            <xsl:value-of select="'&lt;?xml-stylesheet type=&quot;text/xsl&quot; href=&quot;https://rawgit.com/tillgrallert/tei-boilerplate-arabic-editions/online/xslt-boilerplate/teibp.xsl&quot;?>'" disable-output-escaping="yes"/>
            <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="oclc_{$v_id-oclc}-i_{$v_issue}">
                <teiHeader>
                    <fileDesc>
                        <titleStmt>
                            <!-- add copy of title -->
                            <xsl:copy-of select="$v_title-journal/tei:title[@xml:lang='ar-Latn-x-ijmes']"/>
                            <editor ref="https://viaf.org/viaf/27059798">
                                <persName xml:lang="ar">أدونيس</persName>
                                <persName xml:lang="ar-Latn-x-ijmes">Adūnīs</persName>
                            </editor>
                            <respStmt xml:lang="en">
                                <resp>TEI edition</resp>
                                <persName xml:id="pers_TG">
                                    <forename>Till</forename>
                                    <surname>Grallert</surname>
                                </persName>
                            </respStmt>
                        </titleStmt>
                        <publicationStmt xml:lang="en">
                            <authority xml:lang="en">
                                <persName xml:lang="en">Till Grallert</persName>
                            </authority>
                            <pubPlace xml:lang="en">Beirut</pubPlace>
                            <date when="2016" xml:lang="en">2016</date>
                            <availability status="restricted" xml:lang="en">
                                <licence target="http://creativecommons.org/licenses/by-sa/4.0/" xml:lang="en">The XML file is distributed under a Creative Commons Attribution-ShareAlike 4.0 International (CC BY-SA 4.0) license</licence>
                            </availability>
                            <idno type="url">
                                <xsl:value-of select="concat('https://github.com/tillgrallert/digital-mawaqif/blob/master/xml/oclc_',$v_id-oclc,'-i_', $v_issue, '.TEIP5.xml')"/>
                            </idno>
                        </publicationStmt>
                        <sourceDesc>
                            <biblStruct xml:lang="en">
                                <monogr xml:lang="en">
                                    <title level="j" xml:lang="ar">مواقف</title>
                                    <title level="j" type="sub" xml:lang="ar">للحرية، والإبداع، والتغير</title>
                                    <title level="j" xml:lang="ar-Latn-x-ijmes">Mawāqif</title>
                                    <title level="j" type="sub" xml:lang="ar-Latn-x-ijmes">li-l-ḥurriyya, wa-l-ibdāʿ wa-l-taghayyur</title>
                                    <editor ref="https://viaf.org/viaf/27059798">
                                        <persName xml:lang="ar">أدونيس</persName>
                                        <persName xml:lang="ar-Latn-x-ijmes">Adūnīs</persName>
                                    </editor>
                                    <imprint xml:lang="en">
                                        <pubPlace xml:lang="en">
                                            <placeName xml:lang="ar">بيروت</placeName>
                                            <placeName xml:lang="ar-Latn-x-ijmes">Bayrūt</placeName>
                                            <placeName xml:lang="en">Beirut</placeName>
                                        </pubPlace>
                                        <date when="{$v_year}" xml:lang="ar">
                                            <xsl:value-of select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_Label1']"/>
                                        </date>
                                    </imprint>
                                    <biblScope unit="volume" n="{$v_year}"/>
                                    <biblScope unit="issue" n="{$v_issue}"/>
                                    <biblScope unit="page" from="1" to=""/>
                                </monogr>
                                <idno type="oclc" xml:lang="en"><xsl:value-of select="$v_id-oclc"/></idno>
                                <idno type="sakhrit" xml:lang="en">
                                    <xsl:value-of select="replace(base-uri(.),'.*/cid_(\d+)\.html','http://archive.sakhrit.co/contents.aspx?CID=$1')"/>
                                </idno>
                            </biblStruct>
                        </sourceDesc>
                    </fileDesc>
                    <!-- According to TEI P5 @xml:lang should follow BCP 47 <note target="http://www.iana.org/assignments/language-subtag-registry/language-subtag-registry"/>, which specifies for Arabic in Latin transcription "ar-Latn". The specific type of transcription should be added as a private use subtag, i.e. "ar-Latn-x-ijmes" for the
               IJMES transcription of Arabic in Latin script. -->
                    <profileDesc>
                        <langUsage xml:lang="en">
                            <language ident="ar" xml:lang="en">Arabic</language>
                            <language ident="ar-Latn-x-ijmes" xml:lang="en">Arabic transcribed into Latin script following the IJMES
                                conventions</language>
                            <language ident="ar-Latn-EN" xml:lang="en">Arabic transcribed into Latin script following common English
                                practices</language>
                            <language ident="ar-Latn-FR" xml:lang="en">Arabic transcribed into Latin script following common French
                                practices</language>
                            <language ident="en" xml:lang="en">English</language>
                            <language ident="fa" xml:lang="en">Farsi</language>
                            <language ident="fa-Latn-x-ijmes" xml:lang="en">Farsi transcribed into Latin script following the IJMES
                                conventions</language>
                            <language ident="fr" xml:lang="en">French</language>
                            <language ident="ota" xml:lang="en">Ottoman</language>
                            <language ident="ota-Latn-x-ijmes" xml:lang="en">Ottoman transcribed into Latin script following the IJMES
                                conventions</language>
                            <language ident="tr" xml:lang="en">Turkish</language>
                            <language ident="en-Arab-AR" xml:lang="en">English transcribed into Arabic script following common Levantine Arabic
                                practices</language>
                            <language ident="fr-Arab-AR" xml:lang="en">French transcribed into Arabic script following common Levantine Arabic
                                practices</language>
                        </langUsage>
                    </profileDesc>
                    <revisionDesc>
                        <change when="{format-date(current-date(),'[Y0001]-[M01]-[D01]')}" who="#pers_TG">Created this TEI P5 file by automatic conversion of the table of content from 
                            HTML available at archive.sakhrit.co and adding a computed sequence of facsimiles linking to the same website.</change>
                    </revisionDesc>
                </teiHeader>
                <facsimile>
                    <xsl:apply-templates select="$v_increment/descendant-or-self::till:image"/>
                </facsimile>
                <text xml:lang="ar">
                    <front>
                        <div>
                            <bibl>
                                <xsl:copy-of select="$v_title-journal/tei:title[@xml:lang='ar']"/>
                                <biblScope unit="issue" n="{$v_issue}">
                                    <xsl:value-of select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_lbissuenumber']"/>
                                </biblScope>
                                <date when="{$v_year}">
                                    <xsl:value-of select=".//*[@id = 'ContentPlaceHolder1_fvIssueInfo_Label1']"/>
                                </date>
                            </bibl>
                        </div>
                        <!-- test if a table of content, front matter should be provided -->
                        <xsl:variable name="v_pb-start" select="number(normalize-space(descendant::html:table[@id = 'ContentPlaceHolder1_dlIndexs']/html:tr[html:td[position() = 6]][1]/html:td[position() = 6]))"/>
                        <xsl:if test="$v_pb-start &gt; 1">
                            <xsl:call-template name="t_generate-pb">
                                <xsl:with-param name="p_pb-start" select="1"/>
                                <xsl:with-param name="p_pb-stop" select="1"/>
                            </xsl:call-template>
                            <div>
                                <xsl:call-template name="t_generate-pb">
                                    <xsl:with-param name="p_pb-start" select="2"/>
                                    <xsl:with-param name="p_pb-stop" select="$v_pb-start - 1"/>
                                </xsl:call-template>
                            </div>
                        </xsl:if>
                    </front>
                    <body>
                        <xsl:apply-templates select="descendant::html:table[@id = 'ContentPlaceHolder1_dlIndexs']/html:tr"/>
                    </body>
                </text>
            </TEI>
        </xsl:result-document>
        </xsl:if>
    </xsl:template>

    <xsl:template match="html:table[@id = 'ContentPlaceHolder1_dlIndexs']/html:tr">
        <xsl:variable name="v_pb" select="number(normalize-space(./html:td[position() = 6]))"/>
        <xsl:variable name="v_pb-following-article" select="number(normalize-space(following-sibling::html:tr[1]/html:td[position() = 6]))"/>
        <!-- some of the pb need  correction, which is currently done with another styleseheet -->
        <pb ed="print">
            <xsl:attribute name="n">
                <xsl:value-of select="$v_pb"/>
            </xsl:attribute>
            <xsl:attribute name="facs">
                <xsl:value-of select="concat('#', $p_id-facs, $v_pb)"/>
            </xsl:attribute>
        </pb>
        <div type="article">
            <xsl:attribute name="facs">
                <xsl:value-of select="concat('http://archive.sakhrit.co/', ./html:td[2]/html:a/@href)"/>
            </xsl:attribute>
            <head>
                <xsl:value-of select="normalize-space(./html:td[position() = 4])"/>
            </head>
            <!-- information on author -->
            <xsl:if test="normalize-space(./html:td[position() = 2]) != ''">
                <byline>
                    <persName>
                        <xsl:value-of select="normalize-space(./html:td[position() = 2])"/>
                    </persName>
                </byline>
            </xsl:if>
            <!-- generate intermittend pbs based on the table of content -->
            <xsl:if test="$v_pb-following-article > 0">
                <xsl:call-template name="t_generate-pb">
                    <xsl:with-param name="p_pb-start" select="$v_pb + 1"/>
                    <xsl:with-param name="p_pb-stop" select="$v_pb-following-article"/>
                </xsl:call-template>
            </xsl:if>
        </div>
    </xsl:template>

    <!-- generate pbs for intermittend pages -->
    <xsl:template name="t_generate-pb">
        <xsl:param name="p_pb-start"/>
        <xsl:param name="p_pb-stop"/>
        <pb ed="print">
            <xsl:attribute name="n">
                <xsl:value-of select="$p_pb-start"/>
            </xsl:attribute>
            <xsl:attribute name="facs">
                <xsl:value-of select="concat('#', $p_id-facs, $p_pb-start)"/>
            </xsl:attribute>
        </pb>
        <xsl:if test="$p_pb-start &lt; $p_pb-stop">
            <xsl:call-template name="t_generate-pb">
                <xsl:with-param name="p_pb-start" select="$p_pb-start + 1"/>
                <xsl:with-param name="p_pb-stop" select="$p_pb-stop"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- transform links to images to surface -->
    <xsl:template match="till:image">
        <xsl:element name="tei:surface">
            <xsl:attribute name="xml:id" select="concat($p_id-facs, @n)"/>
            <xsl:element name="tei:graphic">
                <xsl:attribute name="xml:id" select="concat($p_id-facs, @n, '-g_1')"/>
                <xsl:attribute name="url" select="child::till:url"/>
                <xsl:attribute name="mimeType" select="'image/jpg'"/>
            </xsl:element>
            <xsl:element name="tei:graphic">
                <xsl:attribute name="xml:id" select="concat($p_id-facs, @n, '-g_2')"/>
                <xsl:attribute name="url" select="concat('../images', child::till:urlLocal)"/>
                <xsl:attribute name="mimeType" select="'image/jpeg'"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
