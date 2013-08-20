<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template name="trigger.init">
	<context counter="0" />
	<xsl:for-each select="$conf/trigger/trigger1" >
		<debug>subscring name[<xsl:value-of select="@trigger.mib.name"/>]</debug>
		<subscribe><mib name="{@trigger.mib.name}" /></subscribe>
	</xsl:for-each>
	<xsl:for-each select="$conf/trigger/trigger3" >
		<debug>subscring name[<xsl:value-of select="@trigger.mib.name"/>]</debug>
		<debug>subscring name[<xsl:value-of select="@enable1.name"/>]</debug>
		<debug>subscring name[<xsl:value-of select="@enable2.name"/>]</debug>
		<subscribe>
			<mib name="{@trigger.mib.name}" />
			<mib name="{@enable1.name}" />
			<mib name="{@enable2.name}" />
		</subscribe>
	</xsl:for-each>
	<xsl:for-each select="$conf/trigger/trigger2" >
		<debug>subscring name[<xsl:value-of select="@trigger.mib.name"/>]</debug>
		<debug>subscring name[<xsl:value-of select="@enable1.name"/>]</debug>
		<subscribe>
			<mib name="{@trigger.mib.name}" />
			<mib name="{@enable1.name}" />
		</subscribe>
	</xsl:for-each>
	
	
<!-- 	<timer delay="0" id="counter" /> -->
</xsl:template>
	
	
<!-- NUR FUER TESTZWECKE -->
<xsl:template match="/timer[@id='counter']">

	<context counter="{$context/@counter + 1}" />
	<mib><set name="counter" value="{$context/@counter}" /></mib>
	<timer delay="1" id="counter" />
</xsl:template>	
	
	
<xsl:template name="trigger.mib">
	<xsl:param name="mib" />
	
	<xsl:for-each select="$mib/set" >
		<xsl:variable name="name" select="@name" />
		<xsl:variable name="value" select="@value" />
		<debug>mib name[<xsl:value-of select="$name"/>] value[<xsl:value-of select="$value"/>]</debug>
		
		<xsl:variable name="trigger" select="$conf/trigger/*[(@trigger.mib.name = $name) or (@trigger.mib.name1 = $name) or (@trigger.mib.name2 = $name)]" />
		<context>
			<xsl:variable name="el" select="concat('mib.', $name)"/>
			<xsl:element name="{$el}">
				<xsl:attribute name="type" ><xsl:value-of select="'mib'"/></xsl:attribute>
				<xsl:attribute name="name" ><xsl:value-of select="$name"/></xsl:attribute>
				<xsl:attribute name="value" ><xsl:value-of select="$value"/></xsl:attribute>
			</xsl:element>
		</context>
		
		<xsl:for-each select="$trigger" >
			<xsl:choose>
				<xsl:when test="(local-name(.) = 'trigger1') and ($value = @trigger.mib.value)">
					<debug>run preset trigger1 trigger.mib.name[<xsl:value-of select="$name"/>] value[<xsl:value-of select="$value"/>] preset[<xsl:value-of select="@preset"/>]</debug>
					<xsl:call-template name="client-cmd" >
						<xsl:with-param name="cmdID" select="@preset"/>
					</xsl:call-template>
				</xsl:when>
				
				
				<xsl:when test="(local-name(.) = 'trigger3') and ($value = @trigger.mib.value)">
					<debug>preset trigger3 trigger.mib.name[<xsl:value-of select="$name"/>] value[<xsl:value-of select="$value"/>] preset[<xsl:value-of select="@preset"/>]</debug>
					
					<xsl:variable name="enable1.name" select="@enable1.name" />
					<xsl:variable name="enable2.name" select="@enable2.name" />
					<xsl:variable name="enable1.value" select="@enable1.value" />
					<xsl:variable name="enable2.value" select="@enable2.value" />
					<xsl:variable name="enable1.mib.value" select="$context/*[@type='mib' and @name=$enable1.name]/@value" />
					<xsl:variable name="enable2.mib.value" select="$context/*[@type='mib' and @name=$enable2.name]/@value" />
					
					<xsl:if test="($enable1.value=$enable1.mib.value) and ($enable2.value=$enable2.mib.value)" >
						<debug>run preset trigger3 trigger.mib.name[<xsl:value-of select="$name"/>] value[<xsl:value-of select="$value"/>] preset[<xsl:value-of select="@preset"/>]</debug>
						<xsl:call-template name="client-cmd" >
							<xsl:with-param name="cmdID" select="@preset"/>
						</xsl:call-template>					
					</xsl:if>					
				</xsl:when>				
				<xsl:when test="(local-name(.) = 'trigger2') and ($value = @trigger.mib.value)">
					<debug>preset trigger2 trigger.mib.name[<xsl:value-of select="$name"/>] value[<xsl:value-of select="$value"/>] preset[<xsl:value-of select="@preset"/>]</debug>
					
					<xsl:variable name="enable1.name" select="@enable1.name" />
					<xsl:variable name="enable1.value" select="@enable1.value" />
					<xsl:variable name="enable1.mib.value" select="$context/*[@type='mib' and @name=$enable1.name]/@value" />
					
					<xsl:if test="($enable1.value=$enable1.mib.value)" >
						<debug>run preset trigger2 trigger.mib.name[<xsl:value-of select="$name"/>] value[<xsl:value-of select="$value"/>] preset[<xsl:value-of select="@preset"/>]</debug>
						<xsl:call-template name="client-cmd" >
							<xsl:with-param name="cmdID" select="@preset"/>
						</xsl:call-template>					
					</xsl:if>					
				</xsl:when>					
				
			</xsl:choose>
		</xsl:for-each>
	</xsl:for-each>
	 
</xsl:template>	
	

	
	
</xsl:stylesheet>