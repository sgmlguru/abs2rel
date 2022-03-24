<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:sg="http://www.sgmlguru.org/ns/funcions"
    exclude-result-prefixes="xs math sg"
    version="3.0">
    
    
    <xsl:include href="abs2rel.xsl"/>
    
    
    <xsl:template match="/">
        <xsl:apply-templates select="node()"/>
    </xsl:template>
    
    
    <xsl:template match="node()">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="pair">
        <xsl:copy>
            <xsl:copy-of select="sg:abs2rel(path1,path2)"/>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>