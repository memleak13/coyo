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

<xsl:variable name="clusterMaster" select="concat('cluster.',$cluster,'.master')" />
<xsl:variable name="clusterPort" select="concat('cluster.',$cluster,'.port')" />
<xsl:variable name="clusterUser" select="concat('cluster.',$cluster,'.user')" />
<xsl:variable name="clusterPassword" select="concat('cluster.',$cluster,'.password')" />

<xsl:template match="/init">
	<debug>clusterlib init: engine [<xsl:value-of select="$engineID" />] cluster [<xsl:value-of select="$cluster" />] poll [<xsl:value-of select="$poll" />]</debug>
	<xsl:if test="string-length($cluster) &gt; 0">
		<subscribe>
			<mib name="{$clusterMaster}" />
			<mib name="{$clusterPort}" />
			<mib name="{$clusterUser}" />
			<mib name="{$clusterPassword}" />
		</subscribe>
	</xsl:if>
	<xsl:call-template name="init" />
	<xsl:if test="string-length($cluster)=0">
		<xsl:call-template name="trigger" />
	</xsl:if>
</xsl:template>

<xsl:template match="/mib">
	<xsl:if test="string-length($cluster) &gt; 0 and count(set[@name=$clusterMaster])">
		<xsl:if test="count($context/@cluster-master)=0">
			<xsl:call-template name="trigger" />
		</xsl:if>
		<context cluster-master="{set[@name=$clusterMaster]/@value}" />
		<context cluster-port="{set[@name=$clusterPort]/@value}" />
		<context cluster-user="{set[@name=$clusterUser]/@value}" />
		<context cluster-password="{set[@name=$clusterPassword]/@value}" />
	</xsl:if>
	<xsl:call-template name="mib">
		<xsl:with-param name="mib" select="/mib" />
	</xsl:call-template>
</xsl:template>

<xsl:template match="/timer[@id='sys.cluster.ticker']">
	<xsl:variable name="master" select="$context/@cluster-master" />
	<xsl:choose>
		<xsl:when test="string-length($cluster)=0">
			<debug>clusterlib: poll</debug>
			<xsl:call-template name="poll" />
		</xsl:when>
		<xsl:when test="$master='off'">
			<debug>clusterlib: off</debug>
			<xsl:call-template name="trigger" />
		</xsl:when>
		<xsl:when test="$master='demo'">
			<debug>clusterlib: demo</debug>
			<xsl:call-template name="demo" />
			<xsl:call-template name="trigger" />
		</xsl:when>
		<xsl:when test="$master='self'">
			<debug>clusterlib: master</debug>
			<xsl:call-template name="poll" />
		</xsl:when>
		<xsl:otherwise>
			<debug>clusterlib: copy from master</debug>
			<xsl:variable name="port" select="$context/@cluster-port" />
			<xsl:variable name="user" select="$context/@cluster-user" />
			<xsl:variable name="password" select="$context/@cluster-password" />
			<http-request id="sys.cluster.copy" url="http://{$master}:{$port}/mib/list.xml?prefix={$engineID}">
				<auth user="{$user}" password="{$password}" />
			</http-request>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="/http-response[@id='sys.cluster.copy']">
	<mib>
		<xsl:for-each select="content/mib/entry">
			<set name="{@name}" value="{@value}" />
		</xsl:for-each>
	</mib>
	<xsl:call-template name="trigger" />
</xsl:template>

<xsl:template name="trigger">
	<timer id="sys.cluster.ticker" delay="{$poll}" />
</xsl:template>

</xsl:stylesheet>
