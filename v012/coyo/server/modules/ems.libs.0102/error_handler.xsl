<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


<xsl:template name="setUnitNotResponding" >
<mib>
	<set name="unitNotResponding" value="1" />
</mib>
</xsl:template>

<xsl:template name="setUnitResponding" >
<mib>
	<set name="unitNotResponding" value="0" />
</mib>
</xsl:template>

<xsl:template name="setUnitUndefined">
<mib>
	<set name="unitNotResponding" value="-1" />
</mib>
</xsl:template>



<xsl:template name="setStateNotResponding" >
<!--<debug>setStateNotResponding</debug>-->
<mib>
	<set name="unitNotResponding" value="1" />
	<set name="responding" value="0" />
	<set name="state"      value="2" />
</mib>
</xsl:template>

<xsl:template name="setStateResponding" >
<!--<debug>setStateResponding</debug>-->
<mib>
	<set name="unitNotResponding" value="0" />
	<set name="responding" value="1" />
	<set name="state"      value="5" />
</mib>
</xsl:template>



</xsl:stylesheet>