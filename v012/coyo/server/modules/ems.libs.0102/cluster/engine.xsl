<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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

<xsl:variable name="poll">3</xsl:variable>
<xsl:variable name="cluster">group1</xsl:variable>

<xsl:import href="enginelib.xsl"/>
<xsl:include href="clusterlib.xsl" />


<xsl:template name="init">
	<mib>
		<set name="test" value="init" />
	</mib>
</xsl:template>

<xsl:template name="poll">
	<mib>
		<set name="test" value="poll" />
	</mib>
	<xsl:call-template name="trigger" />
</xsl:template>

<xsl:template name="demo">
	<mib>
		<set name="test" value="demo" />
	</mib>
</xsl:template>

</xsl:stylesheet>
