<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:output method="html" indent="yes" encoding="utf-8"/>
   <xsl:strip-space elements="*"/>
   <!-- The section deals with the structure and order of the output document.-->

   <xsl:template match="ead">
      <html>
         <head>
            <title>UNL | Libraries | Archives &#38; Special Collections | Finding Aids</title>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <link rel="stylesheet"
               href="http://www.unl.edu/unlpub/2004sharedcode/2004styles/2004globalstyle.css"
               type="text/css"/>
         </head>
         <body>
            <!--BANNER TABLE do not change table-->
            <!--librarybanner CSS-->
            <table width="100%" border="0" style="border-bottom:1px solid #333333" cellpadding="3"
               cellspacing="0">
               <tr>
                  <td align="left" width="300">
                     <span class="sseriftext14">
                        <a href="http://libraries.unl.edu/libraries/">UNL Libraries</a>
                     </span>
                  </td>
                  <td align="right">
                     <a href="http://www.unl.edu/">
                        <!--LOGO-->
                     </a>
                  </td>
               </tr>
            </table>

            <!--END BANNER TABLE-->
            <!--PAGE SPECIFIC LINKS TOP-->
            <table align="center" border="0" width="100%" cellpadding="3" cellspacing="0">
               <tbody>
                  <tr valign="center">
                     <td valign="center" align="left">
                        <span class="sseriftext">
                           <a href="http://libraries.unl.edu/spec">Archives &#38; Special
                              Collections</a> | <a href="http://libraries.unl.edu/specfaidsAZ"
                              >Finding Aids</a>
                        </span>
                     </td>
                  </tr>
               </tbody>
            </table>
            <!--END PAGE SPECIFIC LINKS TOP-->
            <table border="0" width="1000" align="center">
               <tr>
                  <td>
                     <xsl:apply-templates/>
                  </td>
               </tr>
            </table>
            <br/>
            <br/>
            <!--DEPARTMENT CONTACT INFO-->
            <!--librarydeptcontact CSS-->
            <table width="100%" border="0" cellpadding="3" cellspacing="0" class="sseriftext">
               <tr>
                  <td align="left" class="librarydeptcontact"> If you have questions about the
                     Archives &#38; Special Collections, please email <a
                        href="mailto:archives@unl.edu">"archives@unl.edu."</a>
                  </td>
               </tr>
            </table>
            <!--END DEPARTMENT CONTACT INFO-->
            <!--PAGE SPECIFIC LINKS-->
            <table align="center" border="0" width="100%" cellpadding="10" cellspacing="0">
               <tbody>
                  <tr valign="center">
                     <td valign="center" align="middle"
                        style="border-top:1px solid #333333;border-bottom:1px solid #333333;">
                        <span class="sseriftext">
                           <a href="http://libraries.unl.edu/specfaidsAZ">Finding Aids</a> | <a
                              href="http://libraries.unl.edu/spec">Archives &#38; Special
                              Collections</a> | <a href="http://libraries.unl.edu/libraries/">UNL
                              Libraries</a> | <a href="http://news.unl.edu/newsrooms/unltoday/">UNL
                              Home</a>
                        </span>
                        <br/>
                     </td>
                  </tr>
               </tbody>
            </table>
            <!--END PAGE SPECIFIC LINKS-->
            <br/>
            <!--FOOTER TABLE do not change table-->
            <table width="100%" border="0" cellpadding="3" cellspacing="0">
               <tr>
                  <td align="left" width="1%">


                     <a href="http://www.unl.edu/"/>

                  </td>
                  <td align="left">
                     <span class="sseriftext10">&#169; 2005 University of Nebraska-Lincoln Libraries
                        | Lincoln, NE 68588-4100 | 402-472-9568 | comments to: <a
                           href="mailto:webinput@unlnotes.unl.edu" style="color:black">Web Team</a>
                     </span>
                  </td>
               </tr>
            </table>
            <!--END FOOTER TABLE-->
         </body>
      </html>
   </xsl:template>

   <!-- The following sections deal with the display of various RENDER attributes.-->

   <xsl:template match="*[@render = 'bold']">
      <b>
         <xsl:apply-templates/>
      </b>
   </xsl:template>


   <xsl:template match="*[@render = 'underline']">
      <u>
         <xsl:apply-templates/>
      </u>
   </xsl:template>

   <!-- ####################################### -->
   <!--This section deals with the main title. -->
   <!-- 
<xsl:template match="ead/eadheader/filedesc/titlestmt/titleproper">
<center>
<h2>
<xsl:apply-templates/>
</h2>
</center>
</xsl:template>
 -->

   <xsl:template match="eadheader//titlestmt">
      <br/>
      <xsl:for-each select="child::titleproper">
         <h2>
            <center>
               <xsl:apply-templates/>
            </center>
         </h2>
      </xsl:for-each>
      <xsl:for-each select="child::subtitle">
         <b>
            <center>
               <xsl:apply-templates/>
            </center>
         </b>
         <br/>
         <hr/>
      </xsl:for-each>
   </xsl:template>

   <!-- ####################################### -->
   <!-- This section deals with information that appears in the header and in frontmatter -->

   <xsl:template match="//eadid"/>

   <xsl:template match="//publicationstmt"/>

   <xsl:template match="//profiledesc"/>

   <!--REVISIONS-->

   <xsl:template match="//revisiondesc"/>

   <xsl:template match="//frontmatter"/>

   <!-- ######################################### -->
   <!-- The section deals with the information in archdesc. -->
   <!--ORIGINATION-->

   <xsl:template match="//archdesc/did/origination">
      <b>
         <xsl:value-of select="@label"/>
      </b>
      <xsl:text>&#160;</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>


   <xsl:template match="//archdesc/did/origination/persname">
      <xsl:apply-templates/>
      <br/>
   </xsl:template>

   <xsl:template match="//archdesc/did/origination/corpname">
      <xsl:apply-templates/>
      <br/>
   </xsl:template>

   <!--PHYSICAL DESCRIPTION-->

   <xsl:template match="//archdesc/did/physdesc">
      <b>
         <xsl:value-of select="@label"/>
      </b>
      <xsl:text>&#160;</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="//extent">
      <xsl:choose>
         <xsl:when test="@unit = 'boxes'">
            <xsl:apply-templates/>
            <xsl:text>&#160;</xsl:text>
         </xsl:when>
         <xsl:when test="@unit = 'Item(s)'">
            <xsl:apply-templates/>
            <xsl:text>&#160;</xsl:text>
         </xsl:when>
         <xsl:when test="@unit = 'linear feet'">(<xsl:apply-templates/>)</xsl:when>
      </xsl:choose>
   </xsl:template>

   <!--LANGUAGE OF MATERIALS-->

   <xsl:template match="//archdesc/did/langmaterial">
      <b>
         <br/>
         <xsl:value-of select="@label"/>
      </b>
      <xsl:text>&#160;</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>

   <!--REPOSITORY-->

   <xsl:template match="//archdesc/did/repository">
      <br/>
      <b>
         <xsl:value-of select="@label"/>
      </b>
      <xsl:text>&#160;</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="//address"/>

   <!-- ABSTRACT -->

   <xsl:template match="//abstract">
      <xsl:choose>
         <xsl:when test="parent::titlestmt">
            <p>
               <center>
                  <xsl:apply-templates/>
               </center>
            </p>
         </xsl:when>
         <xsl:otherwise>
            <font size="-2">
               <p>
                  <b> Abstract:</b>
                  <xsl:text>&#160;</xsl:text>
                  <xsl:apply-templates/>
               </p>
            </font>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--ACCESS RESTRICTIONS-->

   <xsl:template match="//archdesc/descgrp/accessrestrict">
      <p>
         <b>
            <xsl:value-of select="head"/>
         </b>
         <xsl:text>&#160;</xsl:text>
         <xsl:value-of select="p"/>
      </p>
   </xsl:template>

   <!--USE RESTRICTIONS-->
   <!--
<xsl:template match="//archdesc/descgrp/userestrict">
<p>
<b>
<xsl:for-each
   select="head">
<xsl:apply-templates/>
</xsl:for-each>
</b>
<xsl:text>&#160;</xsl:text>
<xsl:for-each select="p">
<xsl:apply-templates/>
</xsl:for-each>
</p>
</xsl:template>
-->
   <!--PREFERRED CITATION-->

   <xsl:template match="//archdesc/descgrp/prefercite">
      <p>
         <b>
            <xsl:value-of select="head"/>
         </b>
         <xsl:text>&#160;</xsl:text>
         <xsl:value-of select="p"/>
      </p>
   </xsl:template>

   <!--ALTERNATIVE FORMAT-->

   <xsl:template match="//archdesc/descgrp/altformavail">
      <p>
         <b>
            <xsl:value-of select="head"/>
         </b>
         <xsl:text>&#160;</xsl:text>
         <xsl:value-of select="p"/>
      </p>
   </xsl:template>

   <!--BIOGRAPHY This section deals with the biography, etc., paragraphs and information.-->

   <xsl:template match="ead/archdesc/bioghist">
      <b>
         <xsl:value-of select="head"/>
         <xsl:text>&#160;</xsl:text>
      </b>
      <p style="margin-left : 30pt; margin-right : 30pt">
         <xsl:for-each select="p">
            <p style="margin-left : 30pt; margin-right : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
      </p>
   </xsl:template>

   <!--CONTROL ACCESS SUBJECT HEADINGS This section deals with the subject headings in control access, must add rest of control access options here.-->

   <xsl:template match="//ead/archdesc/controlaccess">
      <p>
         <b>
            <xsl:value-of select="head"/>
         </b>
         <xsl:text>&#160;</xsl:text>
         <xsl:for-each select="persname">
            <p style="margin-left : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
         <xsl:for-each select="subject">
            <p style="margin-left : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
         <xsl:for-each select="geogname">
            <p style="margin-left : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
         <xsl:for-each select="famname">
            <p style="margin-left : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
         <xsl:for-each select="corpname">
            <p style="margin-left : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
         <xsl:for-each select="title">
            <p style="margin-left : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
         <xsl:for-each select="genreform">
            <p style="margin-left : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
         <xsl:for-each select="occupation">
            <p style="margin-left : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
         <xsl:for-each select="function">
            <p style="margin-left : 30pt">
               <xsl:apply-templates select="."/>
            </p>
         </xsl:for-each>
      </p>
   </xsl:template>

   <xsl:template match="ead/archdesc/dsc/head">
      <xsl:choose>
         <xsl:when test="parent::dsc[@type = 'in-depth']">
            <br/>
            <br/>
            <b>
               <xsl:apply-templates/>
            </b>
            <br/>
            <br/>
         </xsl:when>
         <xsl:otherwise>
            <b>
               <xsl:apply-templates/>
            </b>
            <br/>
            <br/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- beginning of section that deals with the container list section of the document (<dsc>) -->

   <xsl:template match="//c01">
      <xsl:choose>
         <xsl:when test="@level = 'item'"> Item<!--<xsl:text>&#160;</xsl:text>
            <xsl:number/>.<xsl:text>&#160;</xsl:text>-->
            <xsl:apply-templates/>
            <br/>
         </xsl:when>
         <xsl:when test="@level = 'series'"> Series<xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>
            <br/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
            <br/>
         </xsl:otherwise>
      </xsl:choose>
     <xsl:text> </xsl:text>
   </xsl:template>

   <xsl:template match="//c02">
      <xsl:choose>
         <xsl:when test="@level = 'item'">
            <blockquote>
               <!--Item<xsl:text>&#160;</xsl:text>
               <xsl:number/>.<xsl:text>&#160;</xsl:text>-->
               <xsl:apply-templates/>
            </blockquote>
         </xsl:when>
         <xsl:otherwise>
            <blockquote>
               <xsl:apply-templates/>
            </blockquote>
         </xsl:otherwise>
      </xsl:choose>
     <xsl:text> </xsl:text>
   </xsl:template>

   <xsl:template match="//c03">
      <xsl:choose>
         <xsl:when test="@level = 'item'">
            <blockquote>
               <blockquote>Item<!--<xsl:text>&#160;</xsl:text>
                  <xsl:number/>.<xsl:text>&#160;</xsl:text>-->
                  <xsl:apply-templates/>
               </blockquote>
            </blockquote>
         </xsl:when>
         <xsl:otherwise>
            <blockquote>
               <blockquote>
                  <xsl:apply-templates/>
               </blockquote>
            </blockquote>
         </xsl:otherwise>
      </xsl:choose>
     <xsl:text> </xsl:text>
   </xsl:template>

   <xsl:template match="//c04">
      <xsl:choose>
         <xsl:when test="@level = 'item'">
            <blockquote>
               <blockquote>
                  <blockquote>
                     <!--Item<xsl:text>&#160;</xsl:text>
                     <xsl:number/>.<xsl:text>&#160;</xsl:text>-->
                     <xsl:apply-templates/>
                  </blockquote>
               </blockquote>
            </blockquote>
         </xsl:when>
         <xsl:otherwise>
            <blockquote>
               <blockquote>
                  <blockquote>
                     <xsl:apply-templates/>
                  </blockquote>
               </blockquote>
            </blockquote>
         </xsl:otherwise>
      </xsl:choose>
     <xsl:text> </xsl:text>
   </xsl:template>

   <!-- This section styles the <unittitle> element throughout the document -->
   <xsl:template match="//unittitle">
      <xsl:choose>
         <xsl:when test="ancestor::dsc">
            <xsl:choose>
               <xsl:when test="following-sibling::unitdate">
                  <xsl:choose>
                     <xsl:when test="child::emph">
                        <xsl:variable name="child_emph">
                           <xsl:value-of select="child::emph"/>
                        </xsl:variable>
                        <xsl:choose>
                           <xsl:when test="substring-after(., $child_emph)">
                              <xsl:apply-templates/>
                              <xsl:text>&#160;</xsl:text>
                           </xsl:when>

                           <xsl:otherwise>
                              <xsl:apply-templates/>
                              <xsl:text>&#160;</xsl:text>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:when>
                     <xsl:when test="@label">
                        <xsl:choose>
                           <xsl:when
                              test="attribute::label = 'From' and preceding-sibling::container">
                              <br/>
                              <xsl:for-each select=".">
                                 <b>
                                    <xsl:value-of select="@label"/>
                                    <xsl:text>:</xsl:text>
                                 </b>
                                 <xsl:text>&#160;</xsl:text>
                                 <xsl:apply-templates/>
                                 <br/>
                              </xsl:for-each>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:for-each select=".">
                                 <b>
                                    <xsl:value-of select="@label"/>
                                    <xsl:text>:</xsl:text>
                                 </b>
                                 <xsl:text>&#160;</xsl:text>
                                 <xsl:apply-templates/>
                                 <br/>
                              </xsl:for-each>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:when>
                     <xsl:when test="preceding-sibling::unitdate">
                        <xsl:apply-templates/>
                     </xsl:when>

                     <xsl:otherwise>
                        <xsl:apply-templates/>
                        <xsl:text><!--,-->&#160;</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:when test="following-sibling::container">
                  <xsl:choose>
                     <xsl:when test="following-sibling::container/attribute::type = 'reel'">
                        <xsl:apply-templates/>
                        <xsl:text>&#160;</xsl:text>
                     </xsl:when>
                     <xsl:when test="following-sibling::container/attribute::type = 'reelnot'">
                        <xsl:apply-templates/>
                        <xsl:text>&#160;</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates/>
                        <xsl:text><!--,-->&#160;</xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:when test="following-sibling::physloc">
                  <xsl:apply-templates/>
                  <xsl:text>&#160;</xsl:text>
               </xsl:when>

               <xsl:otherwise>
                  <xsl:apply-templates/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="ancestor::archdesc">
            <b>
               <xsl:value-of select="@label"/>
            </b>
            <xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>
            <br/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
     <xsl:text> </xsl:text>
   </xsl:template>

   <!-- This section styles the <unitdate> element throughout the document -->

   <xsl:template match="//unitdate">
      <xsl:choose>
         <xsl:when test="ancestor::dsc">
            <xsl:choose>
               <xsl:when test="preceding-sibling::unitdate">
                  <xsl:choose>
                     <xsl:when test="following-sibling::physloc">
                        <xsl:text><!--,-->&#160;</xsl:text>
                        <xsl:apply-templates/>
                        <xsl:text>&#160;</xsl:text>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text><!--,-->&#160;</xsl:text>
                        <xsl:apply-templates/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:when test="@label">
                  <b>
                     <xsl:value-of select="@label"/>
                     <xsl:text>:</xsl:text>
                  </b>
                  <xsl:text>&#160;</xsl:text>
                  <xsl:apply-templates/>
               </xsl:when>
               <xsl:when test="following-sibling::physloc">
                  <xsl:apply-templates/>
                  <xsl:text>&#160;</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:apply-templates/>&#160;
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="ancestor::archdesc">
            <xsl:choose>
               <xsl:when test="@type = 'bulk'">
                  <xsl:text><!--,-->&#160;</xsl:text>bulk<xsl:text>&#160;</xsl:text>
                  <xsl:apply-templates/>
                  <br/>
               </xsl:when>
               <xsl:when test="following-sibling::unitdate[@type = 'bulk']">
                  <b>
                     <xsl:value-of select="@label"/>
                  </b>
                  <xsl:text>&#160;</xsl:text>
                  <xsl:apply-templates/>
               </xsl:when>
               <xsl:otherwise>
                  <b>
                     <xsl:value-of select="@label"/>
                  </b>
                  <xsl:text>&#160;</xsl:text>
                  <xsl:apply-templates/>
                  <br/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
     <xsl:text> </xsl:text>
   </xsl:template>

   <!-- This section styles the <physloc> element throughout the document -->

   <xsl:template match="//physloc">
      <xsl:choose>
         <xsl:when test="@type = 'oversize'">
            <xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- This section styles the <container> element throughout the document -->

   <xsl:template match="//container">
      <xsl:choose>
         <xsl:when test="@type = 'box'">
            <xsl:choose>
               <xsl:when test="@label = 'Krabice'">Krabice<xsl:text>&#160;</xsl:text>
                  <xsl:apply-templates/>.<xsl:text>&#160;</xsl:text>
               </xsl:when>
               <xsl:when test="@label = 'drawer'">Drawer<xsl:text>&#160;</xsl:text>
                  <xsl:apply-templates/>.<xsl:text>&#160;</xsl:text>
               </xsl:when>
               <xsl:when test="ancestor::dsc[@type = 'analyticover']">
                  <xsl:apply-templates/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>Box&#160;</xsl:text>
                  <xsl:apply-templates/>
                  <xsl:text>.&#160;</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="@type = 'folder'">
            <xsl:choose>
               <xsl:when test="@label = 'Slo&#382;ka'">
                  <xsl:text>Slo&#382;ka&#160;</xsl:text>
                  <xsl:apply-templates/>
                  <xsl:text>.&#160;</xsl:text>
               </xsl:when>
               <xsl:when test="@label = 'envelope'">
                  <xsl:text>Envelope&#160;</xsl:text>
                  <xsl:apply-templates/>
                  <xsl:text>.&#160;</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>Folder&#160;</xsl:text>
                  <xsl:apply-templates/>
                  <xsl:text>.&#160;</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="@type = 'box-folder'">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:when test="@type = 'mapcase'">
            <xsl:text>&#160;Map:&#160;</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>.&#160;</xsl:text>
         </xsl:when>
         <xsl:when test="@type = 'CD'">
            <xsl:text>&#160;</xsl:text>Compact Disc:<xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>.<xsl:text>&#160;</xsl:text>
         </xsl:when>
         <xsl:when test="@type = 'frame'">
            <xsl:text>&#160;</xsl:text>[frame<xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>]</xsl:when>
         <xsl:when test="@type = 'reel'">
            <xsl:text>&#160;</xsl:text>[reel<xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>]</xsl:when>
         <xsl:when test="@type = 'reelnot'">
            <xsl:text>&#160;</xsl:text>[<xsl:apply-templates/>]</xsl:when>
         <xsl:when test="@type = 'VHS'">
            <xsl:text>&#160;</xsl:text>[VHS<xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>]</xsl:when>
         <xsl:when test="@type = 'mmfilm'">
            <xsl:text>&#160;</xsl:text>[mm film<xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>]</xsl:when>
         <xsl:when test="@type = 'microfilm'">
            <xsl:text>&#160;</xsl:text>[microfilm<xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>]</xsl:when>
      </xsl:choose>
   </xsl:template>

   <!-- This section styles the <scopecontent> element throughout the document -->

   <xsl:template match="//scopecontent">
      <xsl:choose>
         <xsl:when test="ancestor::dsc">
            <xsl:for-each select="p">
               <blockquote>
                  <p>
                     <xsl:apply-templates/>
                  </p>
               </blockquote>
            </xsl:for-each>
            <xsl:for-each select="child::list">
               <xsl:choose>
                  <xsl:when test="@type = 'ordered' and @numeration = 'arabic'">
                     <blockquote>
                        <ol>
                           <xsl:for-each select="child::item">
                              <li>
                                 <xsl:apply-templates/>
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
                                 <xsl:apply-templates/>
                              </li>
                           </xsl:for-each>
                        </ul>
                     </blockquote>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:when>
         <xsl:when test="parent::archdesc">
            <p>
               <b>
                  <xsl:value-of select="head"/>
               </b>
               <xsl:text>&#160;</xsl:text>
            </p>
            <xsl:for-each select="p">
               <p style="margin-left : 30pt">
                  <xsl:apply-templates select="."/>
               </p>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- This section adds the labels for different levels of containers

<xsl:template match="*[@level='series']">
Series<xsl:text>&#160;</xsl:text>
<xsl:apply-templates/>
</xsl:template>
 -->
   <!-- This section styles the <unitid> element throughout the document -->

   <xsl:template match="//unitid">
      <xsl:choose>
         <xsl:when test="ancestor::dsc">
            <xsl:choose>
               <xsl:when test="@label = 'series'">
                  <xsl:apply-templates/>
                  <xsl:text>:&#160;</xsl:text>
               </xsl:when>
               <xsl:when test="@label = 'Odd&#237;l'">
                  <xsl:apply-templates/>
                  <xsl:text>:&#160;</xsl:text>
               </xsl:when>
               <xsl:when test="@label = 'S&#233;rie'">
                  <xsl:apply-templates/>
                  <xsl:text>:&#160;</xsl:text>
               </xsl:when>
               <xsl:when test="@label = 'item'">
                  <xsl:apply-templates/>
                  <xsl:text>:&#160;</xsl:text>
               </xsl:when>
               <xsl:when test="@type = 'work'"/>
               <xsl:otherwise>
                  <xsl:apply-templates/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="ancestor::archdesc">
            <b>
               <br/>
               <xsl:value-of select="@label"/>
            </b>
            <xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>
            <br/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- This section styles the <processinfo> element throughout the document -->

   <xsl:template match="//processinfo">
      <xsl:choose>
         <xsl:when test="parent::c02">
            <xsl:for-each select="p">
               <!--<font color="#cc0000">-->
               <xsl:text>&#160;</xsl:text>
               <xsl:apply-templates/>
               <!--</font>-->
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- This section regulates comma usage within <emph> -->

   <xsl:template match="//emph">
      <xsl:choose>
         <xsl:when test="@render = 'italic'">
            <xsl:choose>
               <xsl:when test="parent::unittitle/following-sibling::unitdate">
                  <xsl:choose>
                     <xsl:when test="preceding-sibling::emph">
                        <xsl:text>&#160;</xsl:text>
                        <i>
                           <xsl:apply-templates/>
                        </i>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:text>&#160;</xsl:text>
                        <i>
                           <xsl:apply-templates/>
                        </i>
                        <xsl:text><!--,--></xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:when>
               <xsl:otherwise>
                  <i>
                     <xsl:apply-templates/>
                  </i>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="@render = 'doublequote'">
            <xsl:choose>
               <xsl:when test="parent::unittitle/following-sibling::unitdate">
                  <xsl:text>"</xsl:text>
                  <xsl:apply-templates/>
                  <xsl:text><!--,-->"</xsl:text>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:text>"</xsl:text>
                  <xsl:apply-templates/>
                  <xsl:text>"</xsl:text>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:when test="@render = 'bold'">
            <xsl:choose>
               <xsl:when test="parent::unittitle/following-sibling::unitdate">
                  <b>
                     <xsl:apply-templates/>
                  </b>
               </xsl:when>
               <xsl:otherwise>
                  <b>
                     <xsl:apply-templates/>
                  </b>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!--This applies to line breaks-->
   <!--This applies to alternative formats-->

   <xsl:template match="//ead/archdesc/altformavail">
      <br/>
      <br/>
      <b>
         <xsl:value-of select="head"/>
      </b>
      <xsl:text>&#160;</xsl:text>
      <br/>
      <xsl:for-each select="//altformavail/list/item">
         <xsl:apply-templates select="."/>
         <br/>
      </xsl:for-each>
   </xsl:template>

   <!--This applies to related materials, first one is for lists, the second for paragraphs-->

   <xsl:template match="//ead/archdesc/relatedmaterial">
      <br/>
      <br/>
      <b>
         <xsl:value-of select="head"/>
      </b>
      <xsl:text>&#160;</xsl:text>
      <br/>
      <xsl:for-each select="//relatedmaterial/list/item">
         <xsl:apply-templates select="."/>
         <br/>
      </xsl:for-each>
      <xsl:for-each select="child::p">
         <br/>
         <xsl:apply-templates/>
         <br/>
      </xsl:for-each>
   </xsl:template>

   <!-- This styles <userestrict> -->

   <xsl:template match="//userestrict">
      <xsl:choose>
         <xsl:when test="parent::descgrp">
            <p>
               <b>
                  <xsl:value-of select="head"/>
               </b>
               <xsl:text>&#160;</xsl:text>
               <xsl:for-each select="p">
                  <xsl:apply-templates/>
               </xsl:for-each>
            </p>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>&#160;</xsl:text>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <!-- This makes links work -->

   <xsl:template match="//dao">
      <xsl:choose>
         <xsl:when test="@href">
            <a>
               <xsl:attribute name="href">
                  <xsl:value-of select="@href"/>
               </xsl:attribute>
               <xsl:apply-templates/>
            </a>
         </xsl:when>
         <xsl:when test="@entityref">
            <xsl:choose>
               <xsl:when test="@role = 'illustration'">
                  <center>
                     <img>
                        <xsl:attribute name="src">
                           <xsl:text>http://libtextcenter.unl.edu/archives/thumbnails/</xsl:text>
                           <xsl:value-of select="attribute::entityref"/>
                           <xsl:text>.jpg</xsl:text>
                        </xsl:attribute>
                     </img>
                  </center>
                  <br/>
               </xsl:when>
            </xsl:choose>
         </xsl:when>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="//extref">
      <a>
         <xsl:attribute name="href">
            <xsl:value-of select="@href"/>
         </xsl:attribute>
         <xsl:apply-templates/>
      </a>
   </xsl:template>

   <!-- This styles <otherfindaid> -->

   <xsl:template match="//otherfindaid">
      <b>Other Finding Aids</b>
      <xsl:text>:&#160;</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="//dsc//list">
      <xsl:choose>
         <xsl:when test="./attribute::type = 'ordered'">
            <ol>
               <xsl:for-each select="./child::item">
                  <li>
                     <xsl:apply-templates/>
                  </li>
               </xsl:for-each>
            </ol>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="//list/item//note">
      <br/>
      <b>
         <xsl:value-of select="@label"/>
      </b>
      <xsl:text>&#160;</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="//list/item//unittitle">
      <b>
         <xsl:value-of select="@label"/>
      </b>
      <xsl:text>&#160;</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="//list/item//origination">
      <b>
         <xsl:value-of select="@label"/>
      </b>
      <xsl:text>&#160;</xsl:text>
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="//lb">
      <br/>
   </xsl:template>
  
  <xsl:template match="note">
    <xsl:choose>
      <xsl:when test="@type='editorial'">
        <xsl:text> [</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>] </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

</xsl:stylesheet>
