<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--
		Init Timer for alarm debounce control
	-->
	<xsl:template name="alarmHandler.initDebounceTimer">
		<timer id="alarmHandler.DebounceTimer" delay="{$alarm-handler.timerValue}" />
		<timer delay="5" id="calculateSeverity" />
	</xsl:template>
	
	
	<xsl:template match="/timer[@id='alarmHandler.DebounceTimer']">
		<!-- MIB Alarms -->        
		<xsl:variable name="contextFiltered" select="$context/*[not(starts-with(name(),'trap.')) and @counter &gt; 0]"/>
		<xsl:for-each select="$contextFiltered" >
			<xsl:variable name="currentContext" select="."/>
			<xsl:variable name="counter" select="@counter" />
			<xsl:variable name="newCounter" select="$counter - 1" />
			<xsl:variable name="pending" select="number(@pending)" />
			<xsl:variable name="enabled" select="number(@enabled)" />
			<xsl:variable name="output-var" select="@output-var" />
			<xsl:variable name="output-var-value" select="@output-var-value" />
			<xsl:variable name="output-var-clear-value" select="@output-var-clear-value"/>

			<xsl:variable name="sql.disable" select="@sql.disable"/>
			<xsl:variable name="trap.disable" select="@trap.disable"/>
			<xsl:variable name="email.enable" select="@email.enable"/>
			<xsl:variable name="sms.enable" select="@sms.enable"/>
			<xsl:variable name="backup.enable" select="@backup.enable"/>
			<xsl:variable name="alarmlamp.enable" select="@alarmlamp.enable"/>
			
			
			<xsl:call-template name="alarmHandler.updateAlarmContext">
				<xsl:with-param name="currentContext" select="$currentContext" />
				<xsl:with-param name="counter" select="$newCounter" />
				<xsl:with-param name="pending" select="$pending" />
				<xsl:with-param name="subject-value" select="@subject-value" />
			</xsl:call-template>

			<!--create a notification for the different types of alarms -->
			<xsl:if test="$newCounter=0 and $enabled=1">
				<context datachange="1" />
				<xsl:choose>
					<xsl:when test="$pending=0">
						<xsl:call-template name="make.notification">
							<xsl:with-param name="idx" select="@clear-notification-id" />
							<xsl:with-param name="module-type" select="$context/@moduleName"/>
							<xsl:with-param name="add.subject" select="@subject-value" />
							<xsl:with-param name="output-var" select="$output-var"/>
							<xsl:with-param name="output-var-value" select="$output-var-value"/>
							<xsl:with-param name="output-var-clear-value" select="$output-var-clear-value"/>
							<xsl:with-param name="sql.disable" select="$sql.disable"/>
							<xsl:with-param name="trap.disable" select="$trap.disable"/>
							<xsl:with-param name="email.enable" select="$email.enable"/>
							<xsl:with-param name="sms.enable" select="$sms.enable"/>
							<xsl:with-param name="backup.enable" select="$backup.enable"/>
							<xsl:with-param name="alarmlamp.enable" select="$alarmlamp.enable"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$pending=1">
						<xsl:call-template name="make.notification">
							<xsl:with-param name="idx" select="@notification-id" />
							<xsl:with-param name="module-type" select="$context/@moduleName"/>
							<xsl:with-param name="add.subject" select="@subject-value" />
							<xsl:with-param name="output-var" select="$output-var"/>
							<xsl:with-param name="output-var-value" select="$output-var-value"/>
							<xsl:with-param name="output-var-clear-value" select="$output-var-clear-value"/>
							<xsl:with-param name="sql.disable" select="$sql.disable"/>
							<xsl:with-param name="trap.disable" select="$trap.disable"/>
							<xsl:with-param name="email.enable" select="$email.enable"/>
							<xsl:with-param name="sms.enable" select="$sms.enable"/>
							<xsl:with-param name="backup.enable" select="$backup.enable"/>
							<xsl:with-param name="alarmlamp.enable" select="$alarmlamp.enable"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
		
		
		<!-- Trap Alarms -->        
        <xsl:variable name="contextTrapFiltered" select="$context/*[starts-with(name(),'trap.') and @counter &gt; 0]"/>
        <xsl:for-each select="$contextTrapFiltered" >
            <xsl:variable name="currentContext" select="."/>
            <xsl:variable name="counter" select="@counter" />
            <xsl:variable name="newCounter" select="$counter - 1" />
             
            <xsl:call-template name="trapHandler.updateAlarmContext">
                <xsl:with-param name="currentContext" select="$currentContext" />
                <xsl:with-param name="newCounter" select="$newCounter" />
            </xsl:call-template>
            
            <!--create a notification of a trap if necessary -->
            <xsl:if test="$newCounter=0">
            	<context datachange="1" />
                <xsl:call-template name="make.trap.notification" >
			       <xsl:with-param name="engine" ><xsl:value-of select="@engine" /></xsl:with-param>
			       <xsl:with-param name="engine-type" ><xsl:value-of select="@engine-type" /></xsl:with-param>
			       <xsl:with-param name="alarm-id" ><xsl:value-of select="@alarm.id" /></xsl:with-param>
			       <xsl:with-param name="severity" ><xsl:value-of select="@severity" /></xsl:with-param>
				   <xsl:with-param name="sla" ><xsl:value-of select="@sla" /></xsl:with-param>
			       <xsl:with-param name="behaviour" ><xsl:value-of select="@behaviour" /></xsl:with-param>
			       <xsl:with-param name="pending" ><xsl:value-of select="@pending" /></xsl:with-param>
			       <xsl:with-param name="text" ><xsl:value-of select="@text" /></xsl:with-param>
				   <xsl:with-param name="traptext" ><xsl:value-of select="@traptext" /></xsl:with-param>
			       <xsl:with-param name="subject" ><xsl:value-of select="@subject" /></xsl:with-param>
			       <xsl:with-param name="mib" ><xsl:value-of select="@mib" /></xsl:with-param>
				   <xsl:with-param name="buinfo1" ><xsl:value-of select="@buinfo1" /></xsl:with-param>
				   <xsl:with-param name="buinfo2" ><xsl:value-of select="@buinfo2" /></xsl:with-param>
				   <xsl:with-param name="buinfo3" ><xsl:value-of select="@buinfo3" /></xsl:with-param>
				   <xsl:with-param name="buinfo4" ><xsl:value-of select="@buinfo4" /></xsl:with-param>
				   <xsl:with-param name="service" ><xsl:value-of select="@service" /></xsl:with-param>									   
				   <xsl:with-param name="sql.disable" select="@sql.disable"/>
				   <xsl:with-param name="trap.disable" select="@trap.disable"/>
				   <xsl:with-param name="email.enable" select="@email.enable"/>
				   <xsl:with-param name="sms.enable" select="@sms.enable"/>
				   <xsl:with-param name="backup.enable" select="@backup.enable"/>
				   <xsl:with-param name="backup.auto" select="@backup.auto"/>
				   <xsl:with-param name="backup.type" select="@backup.type"/>
				   <xsl:with-param name="alarmlamp.enable" select="@alarmlamp.enable"/>
			    </xsl:call-template>
            </xsl:if>
        </xsl:for-each>		
		
		
		
		<timer id="alarmHandler.DebounceTimer" delay="{$alarm-handler.timerValue}" />
	</xsl:template>	


</xsl:stylesheet>