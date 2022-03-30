<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="1.0">
    
    <!--Put all elements in parent list element-->
    <xsl:template match="/">
        <list>  
            <xsl:apply-templates/>  
        </list>
    </xsl:template>
    
    <!--Do not include any TEI header information-->
    <!--Note that namespace (tei:) is needed for this template, because it applies to TEI file-->
    <xsl:template match="tei:teiHeader"/>
    
    <!--Template for personEvent information (generated from personography or oscys.persons.xml)-->
    <!--Note that namespace (tei:) is needed for this template, because it transforms the TEI personography file (oscys.persons.xml)-->
    <xsl:template match="tei:person">
        <personEvent>
            <person><xsl:value-of select="@xml:id"/></person>
            <birth><xsl:value-of select="tei:birth"/></birth>
            <event><xsl:value-of select="substring-after(@source,'doc/')"/></event>
            <statusWithinEvent><xsl:value-of select="tei:socecStatus[not(@source)]"/></statusWithinEvent> 
        </personEvent>
        <xsl:for-each select="child::tei:socecStatus[@source]">
            <personEvent>
                <person><xsl:value-of select="parent::tei:person/@xml:id"/></person>
                <event><xsl:value-of select="substring-after(./@source, 'doc/')"/></event>
                <statusWithinEvent><xsl:value-of select="."/></statusWithinEvent>
            </personEvent>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>