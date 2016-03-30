<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" indent="yes" encoding="iso-8859-1" />
    <xsl:strip-space elements="*" />
    <!-- The section deals with the structure and order of the output document.-->
    <xsl:template match="ead">
        <html>
            <head>
                <title>UNL | Libraries |  Finding
                    Aids</title>
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
                <link rel="stylesheet"
                    href="http://www.unl.edu/unlpub/2004sharedcode/2004styles/2004globalstyle.css"
                    type="text/css" />
            </head>
            <body>
                <!--BANNER TABLE do not change table

                <table width="100%" border="0" style="border-bottom:1px solid #333333"
                    cellpadding="3" cellspacing="0">
                    <tr>
                        <td align="left" width="300">
                            <span class="sseriftext14">
                                <a href="http://iris.unl.edu/">UNL Libraries</a>
                            </span>
                        </td>
                        <td align="right">
                            <a href="http://www.unl.edu/">
                                <img src="http://www.unl.edu/libr/sharedcode/unlLogoBR.gif"
                                    width="100" height="48" alt="University of Nebraska-Lincoln"
                                    border="0" />
                            </a>
                        </td>
                    </tr>
                </table>-->
                <!--END BANNER TABLE

                <table align="center" border="0" width="100%" cellpadding="3" cellspacing="0">
                    <tbody>
                        <tr valign="center">
                            <td valign="center" align="left">
                                <span class="sseriftext"><a
                                    href="http://www.unl.edu/libr/libs/spec/"
                                    >Archives &#38;
                                        Special Collections</a> | <a
                                    href="http://www.unl.edu/libr/libs/spec/faids.shtml"
                                    >Finding
                                        Aids</a></span>
                            </td>
                        </tr>
                    </tbody>
                </table>-->
                <!--END PAGE SPECIFIC LINKS TOP-->
                <table border="0" width="1000" align="center">
                    <tr>
                        <td>
                            <xsl:apply-templates />
                        </td>
                    </tr>
                </table>
                <br /><br />
                <br /><br />
                <!--DEPARTMENT CONTACT INFO

                <table width="100%" border="0" cellpadding="3" cellspacing="0" class="sseriftext">
                    <tr>
                        <td align="left" class="librarydeptcontact"
                            > If you have questions about the
                            Archives &#38; Special Collections, please <a
                            href="http://www.unl.edu/libr/libs/spec/form3.html"
                            >contact
                            us</a>.</td>
                    </tr>
                </table>-->
                <!--END DEPARTMENT CONTACT INFO

                <table align="center" border="0" width="100%" cellpadding="10" cellspacing="0">
                    <tbody>
                        <tr valign="center">
                            <td valign="center" align="middle"
                                style="border-top:1px solid #333333;border-bottom:1px solid #333333;">
                                <span class="sseriftext"><a
                                    href="http://www.unl.edu/libr/libs/spec/faids.shtml"
                                    >Finding
                                        Aids</a> | <a
                                    href="http://www.unl.edu/libr/libs/spec/"
                                    >Archives &#38; Special Collections</a> | <a
                                    href="http://iris.unl.edu/">UNL Libraries</a> | <a
                                    href="http://www.unl.edu/unlpub/index.shtml"
                                    >UNL
                                    Home</a></span>
                                <br /><br />
                            </td>
                        </tr>
                    </tbody>
                </table>-->
                <!--END PAGE SPECIFIC LINKS-->
                <br /><br />
                <!--FOOTER TABLE do not change table-->
                <table width="100%" border="0" cellpadding="3" cellspacing="0">
                    <tr>
                        <td align="left" width="1%">
                           
                        </td>
                        <td align="left">
                            <span class="sseriftext10"
                                > 2015 | Encoded by the Center for Digital Research in the Humanities, University of Nebraska-Lincoln | Lincoln, NE 68588-4100 | 402-472-4547</span>
                        </td>
                    </tr>
                </table>
                <!--END FOOTER TABLE-->
            </body>
        </html>
    </xsl:template>
    <!-- The following sections deal with the display of various RENDER attributes.-->
    <xsl:template match="*[@render='bold']">
        <b>
            <xsl:apply-templates />
        </b>
    </xsl:template>
    <xsl:template match="*[@render='underline']">
        <u>
            <xsl:apply-templates />
        </u>
    </xsl:template>
    <!-- ####################################### -->
    <!--This section deals with the main title. -->
    <!-- <xsl:template match="ead/eadheader/filedesc/titlestmt/titleproper">
<center><h2>
<xsl:apply-templates/>
</h2>
</center>
</xsl:template> -->
    <xsl:template match="eadheader//titlestmt">
        <br /><br />
        <xsl:for-each select="child::titleproper">
            <h2>
                <center>
                    <xsl:apply-templates />
                </center>
            </h2>
        </xsl:for-each>
        <xsl:for-each select="child::subtitle">
            <b>
                <center>
                    <xsl:apply-templates />
                </center>
            </b>
            <br /><br />
            <hr />
        </xsl:for-each>
    </xsl:template>
    <!-- ####################################### -->
    <!-- This section deals with information that appears in the header and in frontmatter -->
    <xsl:template match="//eadid"> </xsl:template>
    <xsl:template match="//publicationstmt"> </xsl:template>
    <xsl:template match="//profiledesc"> </xsl:template>
    <!--REVISIONS-->
    <xsl:template match="//revisiondesc"> </xsl:template>
    <xsl:template match="//frontmatter"> </xsl:template>
    <!-- ######################################### -->
    <!-- The section deals with the information in archdesc. -->
    <!--ORIGINATION-->
    <xsl:template match="//archdesc/did/origination"> <b> <xsl:value-of select="@label" />
        </b>  <xsl:apply-templates /> </xsl:template>
    <xsl:template match="//archdesc/did/origination/persname">
        <xsl:apply-templates />
        <br /><br />
    </xsl:template>
    <xsl:template match="//archdesc/did/origination/corpname">
        <xsl:apply-templates />
        <br /><br />
    </xsl:template>

    <!--PHYSICAL DESCRIPTION-->
    <xsl:template match="//archdesc/did/physdesc"> <b> <xsl:value-of select="@label" />
        </b> <xsl:apply-templates /> </xsl:template>
    <xsl:template match="//extent">
        <xsl:choose>
            <xsl:when test="@unit='boxes'"><xsl:apply-templates /> </xsl:when>
            <xsl:when test="@unit='Item(s)'"><xsl:apply-templates /> </xsl:when>
            <xsl:when test="@unit='linear feet'">(<xsl:apply-templates />)</xsl:when>
        </xsl:choose>
    </xsl:template>
    <!--LANGUAGE OF MATERIALS-->
    <xsl:template match="//archdesc/did/langmaterial"> <b> <br /><br /> <xsl:value-of select="@label" />
        </b> <xsl:apply-templates /> </xsl:template>
    <!--REPOSITORY-->
    <xsl:template match="//archdesc/did/repository"> <br /><br /><b> <xsl:value-of select="@label" />
        </b> <xsl:apply-templates /></xsl:template>
    <xsl:template match="//address"> </xsl:template>
    <!-- ABSTRACT -->
    <xsl:template match="//abstract">
        <xsl:choose>
            <xsl:when test="parent::titlestmt">
                <p>
                    <center>
                        <xsl:apply-templates />
                    </center>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <font size="-2">
                    <p><b> Abstract:</b> <xsl:apply-templates /></p>
                </font>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--ACCESS RESTRICTIONS-->
    <xsl:template match="//archdesc/descgrp/accessrestrict">
        <p><b> <xsl:value-of select="head" /> </b> <xsl:value-of select="p" /></p>
    </xsl:template>
    <!--USE RESTRICTIONS-->
    <!--<xsl:template match="//archdesc/descgrp/userestrict">
<p><b><xsl:for-each
   select="head"><xsl:apply-templates/></xsl:for-each></b> <xsl:for-each select="p"><xsl:apply-templates/></xsl:for-each></p>
</xsl:template>-->
    <!--PREFERRED CITATION-->
    <xsl:template match="//archdesc/descgrp/prefercite">
        <p><b> <xsl:value-of select="head" /> </b> <xsl:value-of select="p" /></p>
    </xsl:template>
    <!--ALTERNATIVE FORMAT-->
    <xsl:template match="//archdesc/descgrp/altformavail">
        <p><b> <xsl:value-of select="head" /> </b> <xsl:value-of select="p" /></p>
    </xsl:template>
    <!--BIOGRAPHY This section deals with the biography, etc., paragraphs and information.-->
    <xsl:template match="ead/archdesc/bioghist">
        <b><xsl:value-of select="head" /> </b>
        <p style="margin-left : 30pt; margin-right : 30pt">
            <xsl:for-each select="p">
                <p style="margin-left : 30pt; margin-right : 30pt">
                    <xsl:apply-templates select="." />
                </p>
            </xsl:for-each>
        </p>
    </xsl:template>
    <!--CONTROL ACCESS SUBJECT HEADINGS This section deals with the subject headings in control access, must add rest of control access options here.-->
    <xsl:template match="//ead/archdesc/controlaccess">
        <p><b> <xsl:value-of select="head" /> </b>  <xsl:for-each select="persname"> <p
            style="margin-left : 30pt"> <xsl:apply-templates select="." /> </p> </xsl:for-each>
            <xsl:for-each select="subject"> <p style="margin-left : 30pt"> <xsl:apply-templates
            select="." /> </p> </xsl:for-each> <xsl:for-each select="geogname"> <p
            style="margin-left : 30pt"> <xsl:apply-templates select="." /> </p> </xsl:for-each>
            <xsl:for-each select="famname"> <p style="margin-left : 30pt"> <xsl:apply-templates
            select="." /> </p> </xsl:for-each> <xsl:for-each select="corpname"> <p
            style="margin-left : 30pt"> <xsl:apply-templates select="." /> </p> </xsl:for-each>
            <xsl:for-each select="title"> <p style="margin-left : 30pt"> <xsl:apply-templates
            select="." /> </p> </xsl:for-each> <xsl:for-each select="genreform"> <p
            style="margin-left : 30pt"> <xsl:apply-templates select="." /> </p> </xsl:for-each>
            <xsl:for-each select="occupation"> <p style="margin-left : 30pt"> <xsl:apply-templates
            select="." /> </p> </xsl:for-each> <xsl:for-each select="function"> <p
            style="margin-left : 30pt"> <xsl:apply-templates select="." /> </p> </xsl:for-each> </p>
    </xsl:template>
    <xsl:template match="ead/archdesc/dsc/head">
        <xsl:choose>
            <xsl:when test="parent::dsc[@type='in-depth']">
                <br />
                <b>
                    <xsl:apply-templates />
                </b>
                <br /><br />
            </xsl:when>
            <xsl:otherwise>
                <b>
                    <xsl:apply-templates />
                </b>
                <br /><br />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- beginning of section that deals with the container list section of the document (<dsc>) -->
    <xsl:template match="//c01">
        <xsl:choose>
            <xsl:when test="@level='item'"
                >
                Item <xsl:number />. <xsl:apply-templates /><br /><br /> </xsl:when>
            <xsl:when test="@level='series'"> Series <xsl:apply-templates /><br /><br /> </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
                <br /><br />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//c02">
        <xsl:choose>
            <xsl:when test="@level='item'">
                <blockquote>Item <xsl:number />. <xsl:apply-templates /></blockquote>
            </xsl:when>
            <xsl:otherwise>
                <blockquote>
                    <xsl:apply-templates />
                </blockquote>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//c03">
        <xsl:choose>
            <xsl:when test="@level='item'">
                <blockquote>
                    <blockquote>Item <xsl:number />. <xsl:apply-templates /></blockquote>
                </blockquote>
            </xsl:when>
            <xsl:otherwise>
                <blockquote>
                    <blockquote>
                        <xsl:apply-templates />
                    </blockquote>
                </blockquote>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//c04">
        <xsl:choose>
            <xsl:when test="@level='item'">
                <blockquote>
                    <blockquote>
                        <blockquote>Item <xsl:number />. <xsl:apply-templates /></blockquote>
                    </blockquote>
                </blockquote>
            </xsl:when>
            <xsl:otherwise>
                <blockquote>
                    <blockquote>
                        <blockquote>
                            <xsl:apply-templates />
                        </blockquote>
                    </blockquote>
                </blockquote>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- This section styles the <unittitle> element throughout the document -->
    <!-- <xsl:template match="unittitle/emph">
<xsl:variable name="emph"><xsl:value-of select="." /></xsl:variable>
<xsl:choose>
<xsl:when test="substring-after(parent::*,$emph)">
<font color="green"><xsl:apply-templates /></font>, 
</xsl:when>
<xsl:otherwise>
<font color="red"><xsl:apply-templates /></font>
</xsl:otherwise>
</xsl:choose>
</xsl:template> -->
    <xsl:template match="//unittitle">
        <xsl:choose>
            <xsl:when test="ancestor::dsc">
                <xsl:choose>
                    <xsl:when test="following-sibling::unitdate">
                        <xsl:choose>
                            <xsl:when test="child::emph">
                                <xsl:variable name="child_emph">
                                    <xsl:value-of select="child::emph" />
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="substring-after(.,$child_emph)">
                                        <xsl:apply-templates /> </xsl:when>
                                                                        
<xsl:otherwise><xsl:apply-templates /> </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="@label">
                                <xsl:choose>
                                    <xsl:when
                                        test="attribute::label='From' and preceding-sibling::container">
                                        <br /><br /><br /><br />
                                        <xsl:for-each select="."><b><xsl:value-of select="@label"
                                             />:</b> <xsl:apply-templates /><br /><br /></xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="."><b><xsl:value-of select="@label"
                                             />:</b> <xsl:apply-templates /><br /><br /></xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="preceding-sibling::unitdate">
                                <xsl:apply-templates />
                            </xsl:when>
                            
                            <xsl:otherwise><xsl:apply-templates />, </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="following-sibling::container">
                        <xsl:choose>
                            <xsl:when test="following-sibling::container/attribute::type='reel'"
                                ><xsl:apply-templates /> </xsl:when>
                            <xsl:when test="following-sibling::container/attribute::type='reelnot'"
                                ><xsl:apply-templates /> </xsl:when>
                            <xsl:otherwise><xsl:apply-templates />, </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="following-sibling::physloc"
                        ><xsl:apply-templates /> </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::archdesc"> <b> <xsl:value-of select="@label" />
                </b> <xsl:apply-templates /><br /><br /> </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- This section styles the <unitdate> element throughout the document -->
    <xsl:template match="//unitdate">
        <xsl:choose>
            <xsl:when test="ancestor::dsc">
                <xsl:choose>
                    <xsl:when test="preceding-sibling::unitdate">
                        <xsl:choose>
                            <xsl:when test="following-sibling::physloc"
                                >, <xsl:apply-templates /> </xsl:when>
                            <xsl:otherwise>, <xsl:apply-templates /></xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:when test="@label"><b><xsl:value-of select="@label"
                         />:</b> <xsl:apply-templates /></xsl:when>
                    <xsl:when test="following-sibling::physloc"
                        ><xsl:apply-templates /> </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::archdesc">
                <xsl:choose>
                    <xsl:when test="@type='bulk'"
                        >, bulk <xsl:apply-templates /><br /><br /></xsl:when>
                    <xsl:when test="following-sibling::unitdate[@type='bulk']"><b> <xsl:value-of
                        select="@label" /> </b> <xsl:apply-templates /></xsl:when>
                    <xsl:otherwise><b> <xsl:value-of select="@label" />
                        </b> <xsl:apply-templates /><br /><br /></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- This section styles the <physloc> element throughout the document -->
    <xsl:template match="//physloc">
        <xsl:choose>
            <xsl:when test="@type='oversize'"> <xsl:apply-templates /></xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- This section styles the <container> element throughout the document -->
    <xsl:template match="//container">
        <xsl:choose>
            <xsl:when test="@type='box'">
                <xsl:choose>
                    <xsl:when test="@label='Krabice'"
                        >Krabice <xsl:apply-templates />. </xsl:when>
                    <xsl:when test="@label='drawer'"
                        >Drawer <xsl:apply-templates />. </xsl:when>
                    <xsl:when test="ancestor::dsc[@type='analyticover']">
                        <xsl:apply-templates />
                    </xsl:when>
                    <xsl:otherwise>Box <xsl:apply-templates />. </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@type='folder'">
                <xsl:choose>
                    <xsl:when test="@label='Slo&#382;ka'"
                        >Slo&#382;ka <xsl:apply-templates />. </xsl:when>
                    <xsl:when test="@label='envelope'"
                        >Envelope <xsl:apply-templates />. </xsl:when>
                    <xsl:otherwise>Folder <xsl:apply-templates />. </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@type='box-folder'">
                <xsl:apply-templates />

            </xsl:when>
 <xsl:when test="@type='mapcase'"> Map: <xsl:apply-templates />. </xsl:when>
    <xsl:when test="@type='CD'"> Compact Disc: <xsl:apply-templates />. </xsl:when>
            <xsl:when test="@type='frame'"> [frame <xsl:apply-templates />]</xsl:when>
            <xsl:when test="@type='reel'"> [reel <xsl:apply-templates />]</xsl:when>
            <xsl:when test="@type='reelnot'"> [<xsl:apply-templates />]</xsl:when>
            <xsl:when test="@type='VHS'"> [VHS <xsl:apply-templates />]</xsl:when>
            <xsl:when test="@type='mmfilm'"> [mm film <xsl:apply-templates />]</xsl:when>
            <xsl:when test="@type='microfilm'"
                > [microfilm <xsl:apply-templates />]</xsl:when>
        </xsl:choose>
    </xsl:template>


    <!-- This section styles the <scopecontent> element throughout the document -->
    <xsl:template match="//scopecontent">
        <xsl:choose>
            <xsl:when test="ancestor::dsc">
                <xsl:for-each select="p">
                    <blockquote>
                        <p>
                            <xsl:apply-templates />
                        </p>
                    </blockquote>
                </xsl:for-each>
                <xsl:for-each select="child::list">
                    <xsl:choose>
                        <xsl:when test="@type='ordered' and @numeration='arabic'">
                            <blockquote>
                                <ol>
                                    <xsl:for-each select="child::item">
                                        <li>
                                            <xsl:apply-templates />
                                        </li>
                                    </xsl:for-each>
                                </ol>
                            </blockquote>
                        </xsl:when>
                        <xsl:otherwise>
                            <blockquote>
                                <ul>
                                    <xsl:for-each select="child::item">
                                        <li>
                                            <xsl:apply-templates />
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </blockquote>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="parent::archdesc">
                <p><b> <xsl:value-of select="head" /> </b> </p>
                <xsl:for-each select="p">
                    <p style="margin-left : 30pt">
                        <xsl:apply-templates select="." />
                    </p>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- This section adds the labels for different levels of containers

<xsl:template match="*[@level='series']">
Series <xsl:apply-templates/>
</xsl:template> -->
    <!-- This section styles the <unitid> element throughout the document -->
    <xsl:template match="//unitid">
        <xsl:choose>
            <xsl:when test="ancestor::dsc">
                <xsl:choose>
                    <xsl:when test="@label='series'"> <xsl:apply-templates />: </xsl:when>
                    <xsl:when test="@label='Odd&#237;l'"> <xsl:apply-templates />: </xsl:when>
                    <xsl:when test="@label='S&#233;rie'"> <xsl:apply-templates />: </xsl:when>
                    <xsl:when test="@label='item'"> <xsl:apply-templates />: </xsl:when>
                    <xsl:when test="@type='work'" />
                    <xsl:otherwise>
                        <xsl:apply-templates />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ancestor::archdesc"> <b> <br /><br /> <xsl:value-of select="@label" />
                </b> <xsl:apply-templates /><br /></xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- This section styles the <processinfo> element throughout the document -->
    <xsl:template match="//processinfo">
        <xsl:choose>
            <xsl:when test="parent::c02">
                <xsl:for-each select="p">
                    <font color="#cc0000"> <xsl:apply-templates /></font>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- This section regulates comma usage within <emph> -->
    <xsl:template match="//emph">
        <xsl:choose>
            <xsl:when test="@render='italic'">
                <xsl:choose>
                    <xsl:when test="parent::unittitle/following-sibling::unitdate">
                        <xsl:choose>
                            <xsl:when test="preceding-sibling::emph"> <i>
                                <xsl:apply-templates /> </i></xsl:when>
                            <xsl:otherwise> <i> <xsl:apply-templates /> </i>,</xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <i>
                            <xsl:apply-templates />
                        </i>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@render='doublequote'">
                <xsl:choose>
                    <xsl:when test="parent::unittitle/following-sibling::unitdate"
                        >"<xsl:apply-templates />,"</xsl:when>
                    <xsl:otherwise>"<xsl:apply-templates />"</xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@render='bold'">
                <xsl:choose>
                    <xsl:when test="parent::unittitle/following-sibling::unitdate">
                        <b>
                            <xsl:apply-templates />
                        </b>
                    </xsl:when>
                    <xsl:otherwise>
                        <b>
                            <xsl:apply-templates />
                        </b>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!--This applies to line breaks-->
    <!--This applies to alternative formats-->
    <xsl:template match="//ead/archdesc/altformavail"> <br /><br /><br /><br /><b> <xsl:value-of select="head"
         /> </b> <br /><br /> <xsl:for-each select="//altformavail/list/item"> <xsl:apply-templates
        select="." /> <br /><br /> </xsl:for-each> </xsl:template>
    <!--This applies to related materials, first one is for lists, the second for paragraphs-->
    <xsl:template match="//ead/archdesc/relatedmaterial"> <br /><br /><br /><br /><b> <xsl:value-of
        select="head" /> </b> <br /><br /> <xsl:for-each select="//relatedmaterial/list/item">
        <xsl:apply-templates select="." /> <br /><br /> </xsl:for-each> <xsl:for-each select="child::p">
        <br /><br /> <xsl:apply-templates /> <br /><br /> </xsl:for-each> </xsl:template>
    <!-- This styles <userestrict> -->
    <xsl:template match="//userestrict">
        <xsl:choose>
            <xsl:when test="parent::descgrp">
                <p><b> <xsl:value-of select="head" /> </b> <xsl:for-each select="p">
                    <xsl:apply-templates /> </xsl:for-each></p>
            </xsl:when>
            <xsl:otherwise> <xsl:apply-templates /></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- This makes links work -->
    <xsl:template match="//dao">
        <xsl:choose>
            <xsl:when test="@href">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="@href" />
                    </xsl:attribute>
                    <xsl:apply-templates />
                </a>
            </xsl:when>
            <xsl:when test="@entityref">
                <xsl:choose>
                    <xsl:when test="@role='illustration'">
                        <center>
                            <img>
                                <xsl:attribute name="src"
                                    >http://libtextcenter.unl.edu/archives/thumbnails/<xsl:value-of
                                    select="attribute::entityref" />.jpg</xsl:attribute>
                            </img>
                        </center>
                        <br /><br />
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//extref">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@href" />
            </xsl:attribute>
            <xsl:apply-templates />
        </a>
    </xsl:template>
    <!-- This styles <otherfindaid> -->
    <xsl:template match="//otherfindaid"
        ><b>Other Finding
        Aids</b>: <xsl:apply-templates /></xsl:template>

    <xsl:template match="//dsc//list">
        <xsl:choose>
            <xsl:when test="./attribute::type='ordered'">
                <ol>
                    <xsl:for-each select="./child::item">
                        <li>
                            <xsl:apply-templates />
                        </li>
                    </xsl:for-each>
                </ol>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="//list/item//note"><br/><b><xsl:value-of select="@label"/></b> <xsl:apply-templates /> </xsl:template>
    <xsl:template match="//list/item//unittitle"><b><xsl:value-of select="@label"/></b> <xsl:apply-templates/> </xsl:template>
<xsl:template match="//list/item//origination"><b><xsl:value-of select="@label"/></b> <xsl:apply-templates/> </xsl:template>


    <xsl:template match="//lb">
        <br /><br />
    </xsl:template>
</xsl:stylesheet>
