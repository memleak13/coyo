<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!--
	Copyright (c) 2010 EuroMedia-Service GmbH

	Module Name: Alarm Handler
	Version: 1.02
	
	Description: 
	This module works as a general alarm engine for other poll engines.
	It subscribes MIB variables of the @poll.engine and sends a coyonet message.
	The file alarms.xml defines the alarm of the polling engine. 
	The file notification.xml defines the notification details.
	
	conf-Attributes:
	poll.engine: 				ID of the polling engine 
    engine.alias: 				The name of the engine entry in the notification. 
    alarm.file: 				The alarm definition file. 
								The standard name is alarms.xml. 
								E.g. "../modules/ems.snmp.mgmt.mib-2.0101/alarms.xml"
    notification.file: 			The definition of the notifications. 
								The standard name is notification.xml. 
								E.g. "../modules/ems.snmp.mgmt.mib-2.0101/notification.xml"
	notification.filter.file	The alarm filter file
	
	alarm-handler.debounceCountTimer	The DebounceCounterTimer [optional]
	default.severity					The default Severity [optional]
	
	08/06/2012 TWI	Added Attributes to Conf
					alarm-handler.debounceCountTimer
					default.severity
-->
	
	
	<!-- get configuration parameters -->
	<xsl:param name="confURL" />
	<xsl:param name="contextURL" />
	<xsl:param name="dynURL" />
	<xsl:param name="engineID" />
	
	<xsl:variable name="conf"      select="document($confURL)/conf" />
	<xsl:variable name="context"   select="document($contextURL)/context" />
	<xsl:variable name="dyn"       select="document($dynURL)/dyn" />
	
	<!-- define general information -->
	<xsl:variable name="module.name"          select="'ems.alarm'" />
	<xsl:variable name="module.number"        select="500001" />
	
<!-- 	<xsl:variable name="defaultSeverity" select="0" /> -->
	<xsl:variable name="defaultSeverity" select="5" />
	
	<!-- alarm file -->
	<xsl:variable name="notificationEngine" select="$conf/@notification.engine" />

	<xsl:variable name="dumpURL" select="concat('dump/', $engineID, '_dump.xml')" />

	<xsl:template match="/*">
	    <debug>cannot handle message [<xsl:value-of select="local-name(.)" />], uri: [<xsl:value-of select="namespace-uri(.)" />], id: [<xsl:value-of select="@id" />]</debug>
	    <xsl:copy-of select="." />
     </xsl:template>
     
     
     <xsl:template match="/error">
		<debug>error: tag [<xsl:value-of select="@tag" />] <xsl:value-of select="@cause" /></debug>
		<xsl:choose>
		    <xsl:when test="contains(@cause,'cannot parse response: Connection reset')">
		       <mib>
		           <set name="unitNotResponding" value="1" />
		       </mib>
		    </xsl:when>
		</xsl:choose>
     </xsl:template>

    
	
	<!-- Include Alarm-LIB -->
    <xsl:include href="notification.filter.xsl"/>
	<xsl:include href="alarm.xsl"/>
	<xsl:include href="trap.xsl"/>
	<xsl:include href="debounce.xsl"/>
	<xsl:include href="notification.xsl"/>
	<xsl:include href="cmd.xsl"/>
	 
	
	<xsl:template match="/init">
	    <!-- engine conf notification -->
		
		<subscribe>
			<msg name="dump" uri="http://euromedia-service.de/coyoNET/libs/module/" />
		</subscribe>
		
		<xsl:variable name="notification-conf.file" select="'../../conf/notification-conf.xml'" />
		<xsl:variable name="notification-conf"   	select="document($notification-conf.file)/notification-conf" />
		<xsl:variable name="language"           	select="$notification-conf/@language" />  	
		<xsl:variable name="notification.file"  	select="string($conf/@notification.file)" />
		<xsl:variable name="notification.def"   	select="document($notification.file)/notification-def/language[@name=$language]" />
		<xsl:variable name="default.alarm-handler.debounceCountTimer" select="1"/>
		
		<xsl:variable name="alarm-handler.debounceCountTimer">
			<xsl:choose>
				<xsl:when test="boolean($conf/@alarm-handler.debounceCountTimer) and number($conf/@alarm-handler.debounceCountTimer)">
					<xsl:variable name="delay" select="number($conf/@alarm-handler.debounceCountTimer)"/>
					<xsl:choose>
						<xsl:when test="$delay &gt;= 1">
							<xsl:value-of select="$delay"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$default.alarm-handler.debounceCountTimer"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$default.alarm-handler.debounceCountTimer"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		

		
	    <context
			sqlmsg.url="{string($notification-conf/@sqlgateway-url)}"
			sql.web.user="{string($notification-conf/@sqlgateway-user)}"
			sql.web.pwd="{string($notification-conf/@sqlgateway-password)}"
			server.id="{$notification-conf/@server-id}" 
			msg.sql.enable="{$notification-conf/@msg.sql.enable}"
			msg.snmp.enable="{$notification-conf/@msg.snmp.enable}"
			msg.email.enable="{$notification-conf/@msg.email.enable}"
			msg.sms.enable="{$notification-conf/@msg.sms.enable}"
			msg.backup.enable="{$notification-conf/@msg.backup.enable}"
			msg.alarmlamp.enable="{$notification-conf/@msg.alarmlamp.enable}"
			alarmLampID="{$notification-conf/@alarmLampID}"
			alarm-handler.debounceCountTimer="{$alarm-handler.debounceCountTimer}"
			clearedBySystem = "5"
			clearedByUser = "5"
			
			datachange="0"
			>
			
			<xsl:if test="boolean ( $conf/@notification.filter.file )">
				<notification-filter>
					<xsl:copy-of  select="document($conf/@notification.filter.file)"/>			
				</notification-filter>
			</xsl:if>
			
			<notification-def>
				<xsl:copy-of select="$notification.def" />
			</notification-def>
		</context>
		<timer id="init2" delay="0" />
	</xsl:template>
	
	<xsl:template match="/timer[@id='init2']">
		<xsl:variable name="alarmFile" select="string($conf/@alarm.file)" />
		
		<xsl:if test="$conf/@sql.reset.alarmengine.messages='true'">
			<xsl:call-template name="sql.reset.alarmengine.messages"/>
		</xsl:if>
	
		<xsl:variable name="alarmDef" select="document($alarmFile)/alarms" />
		<xsl:call-template name="alarmHandler.init" >
			<xsl:with-param name="alarmDef" select="$alarmDef"/>
		</xsl:call-template>
		<xsl:call-template name="trapHandler.init" />
		<xsl:call-template name="alarmHandler.initDebounceTimer" />
		<xsl:call-template name="cmd.init"  />
	</xsl:template>
	
	
	
	<xsl:template match="/mib">
		<xsl:call-template name="alarmHandler.processMibSet" >
			<xsl:with-param name="mib" select="." />
		</xsl:call-template>
	</xsl:template>
	
	
	<xsl:template match="/module:dump" xmlns:module="http://euromedia-service.de/coyoNET/libs/module/" >
		<xsl:if test="@engineID = $engineID">
			<debug>receive message dump</debug>
			<dump file="{$dumpURL}">
				<xsl:value-of select="$dyn/@isotimeUTC" />
				<xsl:copy-of select="$context"/>
			</dump>

			<mib>
				<set name="last.dump" value="{$dyn/@isotimeUTC}" />
			</mib>
			
			<xsl:variable name="server" select="concat('http://127.0.0.1:8080/mib/list.xml?prefix=',$engineID)"/>
	
			<http-request id="{concat('mibdump.',$engineID)}" url="{$server}" method="GET" api="2" connect.timeout="1" >
				<auth type="basic" user="coyonet" password="euromedia-service" />
				<content>
				</content>
			</http-request>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="/http-response[starts-with(@id,'mibdump.')]">
		<dump file="{$dumpURL}">
			<xsl:copy-of select="/http-response"/>
		</dump>	
	</xsl:template>
</xsl:stylesheet>



