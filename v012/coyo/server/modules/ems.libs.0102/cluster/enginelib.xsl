<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:cluster="http://avenyo.com/cluster">

<!--
	Copyright (c) 2010 Itchigo Communications GmbH

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

		http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
-->

<xsl:param name="engineID" />
<xsl:param name="confURL" />
<xsl:param name="contextURL" />
<xsl:param name="dynURL" />

<xsl:variable name="conf" select="document($confURL)/conf" />
<xsl:variable name="context" select="document($contextURL)/context" />
<xsl:variable name="dyn" select="document($dynURL)/dyn" />


<xsl:template match="/*">
	<debug>WARNING: cannot handle message [<xsl:value-of select="local-name(.)" />] uri [<xsl:value-of select="namespace-uri(.)" />]</debug>
</xsl:template>

<xsl:template match="/error">
	<debug>ERROR: tag [<xsl:value-of select="@tag" />] cause [<xsl:value-of select="@cause" />]</debug>
</xsl:template>

<xsl:template name="init">
	<debug>enginelib init</debug>
</xsl:template>

<xsl:template name="mib">
	<debug>enginelib mib</debug>
</xsl:template>

<xsl:template name="poll">
	<debug>enginelib poll</debug>
</xsl:template>

<xsl:template name="demo">
	<debug>enginelib demo</debug>
</xsl:template>

</xsl:stylesheet>
