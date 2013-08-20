<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- 
	EuroMedia-Service GmbH 
	debug.xsl
	v0103
	2011-02-01 19:00
	GMU
-->



<!-- 
<ems:dumpcontext xmlns:ems="http://euromedia-service.de/coyoNET/libs/debug/" />
<ems:dumpcontext xmlns:ems="http://euromedia-service.de/coyoNET/libs/debug/" @filename="/dump/abc.txt" />
<ems:dumpcontext.engineID xmlns:ems="http://euromedia-service.de/coyoNET/libs/debug/" />
<ems:dumpcontext.engineID xmlns:ems="http://euromedia-service.de/coyoNET/libs/debug/" @filename="/dump/abc.txt" />
 -->
<xsl:template match="ems:*[starts-with(local-name(), 'dumpcontext')]" xmlns:ems="http://euromedia-service.de/coyoNET/libs/debug/" >
	<xsl:choose>
		<xsl:when test="boolean(@filename)" >
			<dump file="{@filename}">
				<xsl:copy-of select="$context"/>
			</dump>	
		</xsl:when>
		<xsl:otherwise>
			<dump id="{$engineID}">
				<xsl:copy-of select="$context"/>
			</dump>	
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--  
<ems:setmib  xmlns:ems="http://euromedia-service.de/coyoNET/libs/debug/">
	<set name="variable1" value="123" />
	<set name="variable2" value="123" />
</ems:setmib>

<ems:setmib.engineID  xmlns:ems="http://euromedia-service.de/coyoNET/libs/debug/">
	<set name="variable1" value="123" />
	<set name="variable2" value="123" />
</ems:setmib.engineID>
-->
<xsl:template match="ems:*[starts-with(local-name(),'setmib')]" xmlns:ems="http://euromedia-service.de/coyoNET/libs/debug/">
	<mib>
		<xsl:for-each select="set">
			<set name="{@name}" value="{@value}" />
		</xsl:for-each>
	</mib>
</xsl:template>



<xsl:template name="ems:init" xmlns:ems="http://euromedia-service.de/coyoNET/libs/debug/">
	<subscribe>
		<msg uri="http://euromedia-service.de/coyoNET/libs/debug/" name="dumpcontext.{$engineID}" />	
		<msg uri="http://euromedia-service.de/coyoNET/libs/debug/" name="setmib.{$engineID}" />	
		<msg uri="http://euromedia-service.de/coyoNET/libs/debug/" name="dumpcontext" />	
		<msg uri="http://euromedia-service.de/coyoNET/libs/debug/" name="setmib" />	
	</subscribe>
</xsl:template>




</xsl:stylesheet>