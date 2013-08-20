<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="integer.parse_value">
		<xsl:param name="value" />
		<xsl:param name="min"/>
		<xsl:param name="max"/>
		<xsl:param name="default"/>
		<xsl:choose>
			<xsl:when test="boolean($value)">
				<xsl:choose>
					<xsl:when test="$value &gt; $max">
						<xsl:value-of select="$max"/>
					</xsl:when>
					<xsl:when test="$value &lt; $min">
						<xsl:value-of select="$min"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$value"/>
					</xsl:otherwise>		
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$default"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>