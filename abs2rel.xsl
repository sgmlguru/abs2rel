<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:sg="http://www.sgmlguru.org/ns/funcions"
    exclude-result-prefixes="xs math sg"
    version="3.0">
    
    <xsl:variable name="debug" select="false()" static="yes"/>
    
    <xsl:function name="sg:abs2rel">
        <xsl:param name="path1"/>
        <xsl:param name="path2"/>
        
        <xsl:variable
            name="local-path1"
            select="sg:unify($path1)"/>
        <xsl:variable
            name="local-path2"
            select="sg:unify($path2)"/>
        
        <xsl:message expand-text="yes" use-when="$debug">
            local-path1: {$local-path1}
            local-path2: {$local-path2}
        </xsl:message>
        
        <xsl:variable
            name="p1"
            select="tokenize($local-path1,'/')"/>
        <xsl:variable
            name="p2"
            select="tokenize($local-path2,'/')"/>
        
        <xsl:variable name="base">
            <!-- Need raw base first, because paths may be different but have folders named the same -->
            <xsl:variable name="raw">
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
            
            <!-- Figure out actual base -->
            <xsl:choose>
                <xsl:when test="contains($raw,'###')">
                    <xsl:value-of select="substring-before($raw,'###')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$raw"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:message expand-text="yes" use-when="$debug">
            base: {$base}
        </xsl:message>
        
        <!-- $local-path1 diff from $base -->
        <xsl:variable name="diff-from-base">
            <xsl:value-of select="substring-after($local-path1,$base)"/>
        </xsl:variable>
        
        <!-- How many parent traversals from $local-path1 to base? -->
        <xsl:variable name="dots" as="xs:integer">
            <xsl:value-of select="count(tokenize($diff-from-base,'/'))"/>
        </xsl:variable>
        
        <!-- Output parent traversal from $local-path1 -->
        <xsl:for-each select="1 to ($dots - 1)">
            <xsl:text>../</xsl:text>
        </xsl:for-each>
        
        <!-- Produce relative path to $local-path2 OR
             all of $local-path2, if the drive is different -->
        <xsl:variable name="output">
            <xsl:value-of
                select="if ($base='oops') 
                then ($local-path2)
                else (substring-after($local-path2,$base))"/>
        </xsl:variable>
        
        <xsl:value-of select="string-join($output)"/>
        
    </xsl:function>
    
    
    <!-- Unify Windows/Unix path notations for comparison -->
    <xsl:function name="sg:unify">
        <xsl:param name="path" as="xs:string?"/>
        <xsl:variable name="local.string" select="translate($path,'\','/')"/>
        
        <xsl:analyze-string select="$local.string" regex="^(file:|([a-z]:))?/+(.*)$">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(2) || '/' || regex-group(3)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:function>
    
    
    <!-- Compare path 1 and path 2 tokens -->
    <xsl:function name="sg:comp" as="node()*">
        <xsl:param name="s1"/>
        <xsl:param name="s2"/>
        
        <xsl:message expand-text="yes" use-when="$debug">
            s1: {$s1}
            s2: {$s2}
        </xsl:message>
        
        <xsl:choose>
            <xsl:when test="$s1='' and $s2=''">
                <xsl:value-of select="'/'"/>
            </xsl:when>
            <xsl:when test="$s1 = $s2 and $s1!='' and $s2!=''">
                <xsl:value-of select="$s1 || '/'"/>
            </xsl:when>
            <!-- ONLY previous tokens may form the base path; ### indicates break -->
            <xsl:when test="$s1 != $s2">
                <xsl:value-of select="'###'"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:function>
    
</xsl:stylesheet>