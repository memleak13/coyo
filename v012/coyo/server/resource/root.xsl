<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:variable name="host" select="'localhost'" />

<xsl:template match="/">
	<xsl:variable name="root" select="/*" />
	<html>
		<head>
			<title> Backup Configuration Tool </title>
			<link rel="StyleSheet" href="/resource/stylesheet.css" type="text/css" />
			<link rel="shortcut icon" href="/resource/logo.ico" />
			<script type="text/javascript" src="/resource/ajax.js" />
			<script type="text/javascript" src="/resource/md5.js" />
		</head>
		<body>
			<xsl:if test="count($root/@dberror)">
				<p> <span class="ajaxError"> database error: <xsl:value-of select="$root/@dberror" /> </span> </p>
			</xsl:if>
			<form>
				<xsl:if test="name($root)!='start'">
					<input type="button" value="Home" onclick="window.location.href='/config'" />
				</xsl:if>
				<input type="button" value="Reload" onclick="window.location.reload()" />
			</form>
			<xsl:apply-templates select="$root" mode="body" />
		</body>
	</html>
</xsl:template>

</xsl:stylesheet>
