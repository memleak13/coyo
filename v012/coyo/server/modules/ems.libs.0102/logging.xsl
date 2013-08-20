<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:log="http://euromedia-service.de/coyoNET/libs/debug/logging/logging/" >
	<xsl:template name="log:init" >
		<context debug.level="severe" /> 
	</xsl:template>
	

<xsl:template name="log:log.severe" >
	<xsl:param name="text" />
	<xsl:call-template name="log:log"  xmlns:log="http://euromedia-service.de/coyoNET/libs/debug/logging/">
		<xsl:with-param name="level" select="'severe'"/>
		<xsl:with-param name="text" select="$text"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="log:log.warning" >
	<xsl:param name="text" />
	<xsl:call-template name="log:log" >
		<xsl:with-param name="level" select="'warning'"/>
		<xsl:with-param name="text" select="$text"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="log:log.info" >
	<xsl:param name="text" />
	<xsl:call-template name="log:log" >
		<xsl:with-param name="level" select="'info'"/>
		<xsl:with-param name="text" select="$text"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="log:log.config" >
	<xsl:param name="text" />
	<xsl:call-template name="log:log"  xmlns:log="http://euromedia-service.de/coyoNET/libs/debug/logging/">
		<xsl:with-param name="level" select="'config'"/>
		<xsl:with-param name="text" select="$text"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="log:log.fine" >
	<xsl:param name="text" />
	<xsl:call-template name="log:log"  xmlns:log="http://euromedia-service.de/coyoNET/libs/debug/logging/">
		<xsl:with-param name="level" select="'fine'"/>
		<xsl:with-param name="text" select="$text"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="log:log.finer" >
	<xsl:param name="text" />
	<xsl:call-template name="log:log"  xmlns:log="http://euromedia-service.de/coyoNET/libs/debug/logging/">
		<xsl:with-param name="level" select="'finer'"/>
		<xsl:with-param name="text" select="$text"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="log:log.finest" >
	<xsl:param name="text" />
	<xsl:call-template name="log:log"  xmlns:log="http://euromedia-service.de/coyoNET/libs/debug/logging/">
		<xsl:with-param name="level" select="'finest'"/>
		<xsl:with-param name="text" select="$text"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="log:log.all" >
	<xsl:param name="text" />
	<xsl:call-template name="log:log"  xmlns:log="http://euromedia-service.de/coyoNET/libs/debug/logging/">
		<xsl:with-param name="level" select="'all'"/>
		<xsl:with-param name="text" select="$text"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="log:log" >
	<xsl:param name="level" />
	<xsl:param name="text" />
	
	<xsl:variable name="nl" >
		<xsl:call-template name="log:getNumericLoglevel">
			<xsl:with-param name="level" select="$level"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="cnl" >
		<xsl:call-template name="log:getNumericLoglevel">
			<xsl:with-param name="level" select="$context/@debug.level"/>
		</xsl:call-template>
	</xsl:variable>	
	
	<xsl:if test="$nl &gt;= $cnl" >
		<debug>[<xsl:value-of select="$level"/>] <xsl:value-of select="$text"/></debug>		
	</xsl:if>

</xsl:template>

<xsl:template name="log:getNumericLoglevel" >
	<xsl:param name="level" />
	<xsl:choose>
		<xsl:when test="$level='off'">1000000</xsl:when>
		<xsl:when test="$level='severe'">1000</xsl:when>
	    <xsl:when test="$level='warning'">900</xsl:when>	
	    <xsl:when test="$level='info'">800</xsl:when>	
	    <xsl:when test="$level='config'">700</xsl:when>	
	    <xsl:when test="$level='fine'">500</xsl:when>	
	    <xsl:when test="$level='finer'">400</xsl:when>	
	    <xsl:when test="$level='finest'">300</xsl:when>			
	    <xsl:when test="$level='all'">-1</xsl:when>	
	    <xsl:otherwise>-1</xsl:otherwise>		
	</xsl:choose>	
</xsl:template>	
	
	
	
</xsl:stylesheet>