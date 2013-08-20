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

<xsl:param name="confURL" />
<xsl:param name="contextURL" />

<xsl:variable name="conf" select="document($confURL)/conf" />
<xsl:variable name="context" select="document($contextURL)/context" />

<xsl:template match="/*">
	<debug>WARNING: cannot handle message [<xsl:value-of select="local-name(.)" />] uri [<xsl:value-of select="namespace-uri(.)" />]</debug>
</xsl:template>

<xsl:template match="/error">
	<debug>ERROR: tag [<xsl:value-of select="@tag" />] cause [<xsl:value-of select="@cause" />]</debug>
</xsl:template>

<xsl:template match="/init">
	<xsl:variable name="init" select="document('file:/etc/vamp/cluster.xml')/clusters" />
	<xsl:for-each select="$init/cluster">
		<xsl:variable name="id" select="@id" />
		<xsl:variable name="filename" select="concat('file:/var/spool/vamp/cluster/',$id,'.xml')" />
		<xsl:variable name="state" select="document($filename)/cluster:cluster" />
		<mib>
			<set name="{$id}.master" value="{$state/@master}" />
			<set name="{$id}.port" value="{$state/@port}" />
			<set name="{$id}.user" value="{$state/@user}" />
			<set name="{$id}.password" value="{$state/@password}" />
		</mib>
	</xsl:for-each>
	<subscribe>
		<msg name="cluster" uri="http://avenyo.com/cluster" />
	</subscribe>
</xsl:template>

<xsl:template match="/cluster:cluster">
	<mib>
		<set name="{@id}.master" value="{@master}" />
		<set name="{@id}.port" value="{@port}" />
		<set name="{@id}.user" value="{@user}" />
		<set name="{@id}.password" value="{@password}" />
	</mib>
</xsl:template>

</xsl:stylesheet>
