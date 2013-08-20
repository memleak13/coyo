<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:include href="param.xsl"/>		
    <xsl:variable name="conf"      select="document($confURL)/conf" />
    <xsl:variable name="context"   select="document($contextURL)/context" />
    <xsl:variable name="dyn"       select="document($dynURL)/dyn" />		
	
	<xsl:include href="../queue.xsl"/>
	
	
	<xsl:template match="/init" >
		
		<debug><xsl:call-template name="queue.peek"/> </debug>
		<xsl:call-template name="queue.remove"/>

		<!-- 
		<xsl:call-template name="queue.init" />

		<xsl:variable name="msg" >
			<msg a="0" b="25" />
			<msg s="3" d="4" />
		</xsl:variable>	
		<xsl:call-template name="queue.add" >
			<xsl:with-param name="el" ><xsl:copy-of select="$msg"/></xsl:with-param>
		</xsl:call-template>

		<debug><xsl:call-template name="queue.size"/> </debug>

		<debug>
			<xsl:call-template name="queue.peek" />
			<xsl:call-template name="queue.remove" />
		</debug>
		 -->		
	</xsl:template>
</xsl:stylesheet>