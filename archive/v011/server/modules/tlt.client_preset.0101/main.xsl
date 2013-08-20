<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:param name="confURL"/>
	<xsl:param name="contextURL"/>
	<xsl:param name="dynURL"/>
	<xsl:param name="engineID"/>
	
	<xsl:variable name="conf" select="document($confURL)/conf"/>
	<xsl:variable name="context" select="document($contextURL)/context"/>
	<xsl:variable name="dyn" select="document($dynURL)/dyn"/>
	
	
	<xsl:template match="/*">
		<debug>unhandled message[<xsl:value-of select="local-name(.)"/>] uri [<xsl:value-of select="namespace-uri(.)"/>]</debug>
	</xsl:template>
	
	
	<xsl:template match="/init">
		<debug>Start Client-Cmd Engine</debug>
		<xsl:variable name="run_client_commands" select="document('commands.xml')/client-commands"/>

		<context>
			<client-commands>
				<xsl:copy-of select="$run_client_commands/client-cmd" />
			</client-commands>
		</context>
		<debug>command file loaded</debug>

		<subscribe>
			<msg uri="http://euromedia-service.de/coyoNET/" name="client-cmd"/>
		
		
			<xsl:for-each select="$conf/mib">
				<xsl:copy-of select="."/>
			</xsl:for-each>
			<mib name="clustermgr.cluster.role" />
	
		</subscribe>
	
		<context cluster.role="not init"/>
	
	
	</xsl:template>
	
	<xsl:template match="/mib">
		<xsl:for-each select="set">
			<xsl:if test="@name='clustermgr.cluster.role'">
				<debug>clustermgr.cluster.role[<xsl:value-of select="@value" />]</debug>
				<context  cluster.role="{@value}" />
			</xsl:if>		
		</xsl:for-each>
	</xsl:template>

	<!-- preset interpreter -->
	<xsl:template match="/ems:client-cmd" xmlns:ems="http://euromedia-service.de/coyoNET/">
		<debug>Got Client Command: [<xsl:value-of select="@id"/>]</debug>
		<xsl:call-template name="client-cmd">
			<xsl:with-param name="cmdID" select="@id"/>
		</xsl:call-template>
	</xsl:template>
	
	<xsl:template match="/tt:script-response" xmlns:tt="http://teletrend.ch/coyonet/script/">
		<debug>Got script-response: state[<xsl:value-of select="@state"/>] error[<xsl:value-of select="@error"/>] message[<xsl:copy-of select="."/>]</debug>
		<mib>
			<set name="script-response" value="{@state}" />
		</mib>
	</xsl:template>
	
	<xsl:template name="client-cmd">
		<xsl:param name="cmdID"/>
		<xsl:variable name="preset" select="$context/client-commands/client-cmd[@type=$cmdID]/*"/>
		<xsl:if test="boolean($preset)">
			<debug>Found preset [<xsl:value-of select="$cmdID"/>]</debug>
			<xsl:call-template name="masterPresets">
				<xsl:with-param name="cmdID" select="$cmdID"/>
				<xsl:with-param name="preset" select="$preset"/>
			</xsl:call-template>			
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="masterPresets" >
		<xsl:param name="cmdID" />
		<xsl:param name="preset"/>
		
		<xsl:for-each select="$preset">
			<xsl:choose>
				<xsl:when test="local-name(.)='writetofile'">
					<dump file="{@file}"><xsl:copy-of select="." /></dump>
				</xsl:when>
				<xsl:when test="local-name(.)='startscript'">
					<xsl:variable name="cmd" select="." />
				
					<http-request id="startscript" url="http://127.0.0.1:8082/execute" method="POST"  api="2" connect.timeout="2" read.timeout="1">
						<auth type="basic" user="coyonet" password="euromedia" />
						<content>
							<processes xmlns="http://euromedia-service.de/coyoNET/execute">
				   				 <start><xsl:value-of select="$cmd"/></start>
							</processes>
						</content>
					</http-request>	
				</xsl:when>				
								

				
				<xsl:otherwise>
					<debug>cluster.role[<xsl:value-of select="$context/@cluster.role"/>], could not execute client command [<xsl:value-of select="$cmdID"/>]</debug>
				</xsl:otherwise>
			</xsl:choose>	
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="/http-response[@id='startscript']">
		<debug>startscript done</debug>
	</xsl:template>
	
</xsl:stylesheet>