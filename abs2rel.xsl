<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:sg="http://www.sgmlguru.org/ns/funcions"
    exclude-result-prefixes="xs math sg"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    
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
        
        <alternative>
            <xsl:copy-of select="sg:comp(path1,path2)"/>
        </alternative>
    </xsl:template>
    
    
    <xsl:function name="sg:abs2rel">
        <xsl:param name="path1"/>
        <xsl:param name="path2"/>
        
        <xsl:variable name="local-path1" select="sg:unify($path1)"/>
        <xsl:variable name="local-path2" select="sg:unify($path2)"/>
        
        <xsl:message>
            <xsl:value-of select="$local-path1"/>
            ===
            <xsl:value-of select="$local-path2"/>
        </xsl:message>
        
        <xsl:variable
            name="p1"
            select="tokenize($local-path1,'/')"/>
        <xsl:variable
            name="p2"
            select="tokenize($local-path2,'/')"/>
        
        <xsl:variable name="base">
            <xsl:choose>
                <xsl:when
                    test="substring($local-path1,1,1) = substring($local-path2,1,1)">
                    <xsl:copy-of select="for-each-pair($p1,$p2,sg:comp#2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>oops</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="test">
            <xsl:value-of select="substring-after($local-path1,$base)"/>
        </xsl:variable>
        
        <xsl:variable name="dots" as="xs:integer">
            <xsl:value-of select="count(tokenize($test,'/'))"/>
        </xsl:variable>
        
        <xsl:for-each select="1 to ($dots - 1)">
            <xsl:text>../</xsl:text>
        </xsl:for-each>
        
        <xsl:value-of select="substring-after($local-path2,$base)"/>
        <xsl:value-of select="count(tokenize(substring-after($local-path2,$base),'/'))"/>
        
    </xsl:function>
    
    
    <xsl:function name="sg:unify">
        <xsl:param name="path" as="xs:string?"/>
        <xsl:variable name="local.string" select="translate($path,'\','/')"/>
        
        <xsl:analyze-string select="$local.string" regex="^(file:|([a-z]:))?/+(.*)$">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(2) || '/' || regex-group(3)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    
    <xsl:function name="sg:comp" as="node()*">
        <xsl:param name="s1"/>
        <xsl:param name="s2"/>
        <xsl:variable name="local-s1" select="sg:unify($s1)"/>
        <xsl:variable name="local-s2" select="sg:unify($s2)"/>
        
        <xsl:choose>
            <xsl:when test="$local-s1='' and $local-s2=''">
                <xsl:value-of select="'/'"/>
            </xsl:when>
            <xsl:when test="$local-s1 = $local-s2 and $local-s1!='' and $local-s2!=''">
                <xsl:value-of select="'./' || tokenize($local-s1,'/')[last()]"/>
            </xsl:when>
            <xsl:when test="$local-s1 != $local-s2"/>
        </xsl:choose>
        
        <!--<xsl:value-of select="if ($s1=$s2) then ('=') else ('+')"/>-->
    </xsl:function>
    
</xsl:stylesheet>