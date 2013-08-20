<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="string.toUpper">
		<xsl:param name="text"/>
		<xsl:variable name="lowerletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="upperletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<xsl:value-of  select="translate($text,$upperletters,$lowerletters)"/>
	</xsl:template>
</xsl:stylesheet>