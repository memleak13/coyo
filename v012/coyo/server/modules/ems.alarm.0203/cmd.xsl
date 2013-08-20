<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- 
    <msg>
        <reset-pending-alarm.{$engineID} alarm.id="ID" xmlns="http://euromedia-service.de/coyoNET/alarm/" />
    </msg>
    
    <msg>
        <reset-all-pending-alarm.{$engineID} xmlns="http://euromedia-service.de/coyoNET/alarm/" />
    </msg>
    
    <msg>
        <reset-all-pending-alarm xmlns="http://euromedia-service.de/coyoNET/alarm/" />
    </msg>
     -->
     
    <xsl:variable name="resetPending"  select="0" />
    <xsl:variable name="resetSeverity" select="5" />
    <xsl:variable name="resetCounter"  select="2" />
    <xsl:variable name="reset-pending-alarm"      select="'reset-pending-alarm'" />
    <xsl:variable name="reset-all-pending-alarm"  select="'reset-all-pending-alarm'" />
    <xsl:variable name="reset-all-pending-alarm-all"  select="'reset-all-pending-alarm'" />
    
    
 	<xsl:template name="cmd.init">
 	    <subscribe>
	        <msg uri="http://euromedia-service.de/coyoNET/alarm/" name="reset-all-pending-alarm" />
            <msg uri="http://euromedia-service.de/coyoNET/alarm/" name="reset-pending-alarm.{$engineID}" />
	        <msg uri="http://euromedia-service.de/coyoNET/alarm/" name="reset-all-pending-alarm.{$engineID}" />
	        <xsl:if test="not($engineID = $conf/@notification.engine)" >
                <msg uri="http://euromedia-service.de/coyoNET/alarm/" name="reset-pending-alarm.{$conf/@notification.engine}" />
	            <msg uri="http://euromedia-service.de/coyoNET/alarm/" name="reset-all-pending-alarm.{$conf/@notification.engine}" />
            </xsl:if>
	    </subscribe>
 	</xsl:template>
    
	 
<!-- ############################################################################################################################### -->
    
    <!-- Receive message to reset alarm -->
    
    <xsl:template match="/alarm:*" xmlns:alarm="http://euromedia-service.de/coyoNET/alarm/" >
        <debug>msg[<xsl:value-of select="local-name()"/>] alarmID[<xsl:value-of select="@alarm.id"/>]</debug>
        
        <xsl:choose>
            <xsl:when test="contains(name(),$reset-all-pending-alarm)" >
                <!-- reset all alarms of engine -->
                <xsl:call-template name="resetAllAlarms" />
            </xsl:when>
            <xsl:when test="contains(name(),$reset-all-pending-alarm-all)" >
                <!-- reset all alarms without engine ID -->
                <xsl:call-template name="resetAllAlarmsWithoutEngineId" />
            </xsl:when>
            <xsl:otherwise>
                <!-- reset single alarm -->
                <xsl:call-template name="resetSingleAlarm" >
                    <xsl:with-param name="alarm.id"><xsl:value-of select="@alarm.id" /></xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> 
	 
	 
<!-- ############################################################################################################################### -->
    
    <!-- Reset single alarm -->
    
    <xsl:template name="resetSingleAlarm" >
        <xsl:param name="alarm.id" />
        <xsl:variable name="mib.Id" select="$context/notification-def/language[1]/notification[@alarm.id=$alarm.id and @pending=1]/@id" />
        
        <xsl:choose>
            <xsl:when test="boolean($mib.Id)" >
                <xsl:for-each select="$context/*[@notification-id=$mib.Id and @pending=1]" >
                    <xsl:if test="starts-with(name(),'AE.') or 
		                            starts-with(name(),'AD.') or 
		                            starts-with(name(),'AA.') " >
		                <xsl:call-template name="alarmHandler.updateAlarmContext">
		                    <xsl:with-param name="currentContext" select="." />
		                    <xsl:with-param name="counter" select="$resetCounter" />
		                    <xsl:with-param name="pending" select="$resetPending" />
		                    <xsl:with-param name="subject-value" select="@subject-value" />
		                </xsl:call-template>
		            </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$context/*[@alarm.id=$alarm.id and @pending=1]" >
                       <xsl:if test="starts-with(name(),'trap.')" >
		                <xsl:call-template name="trapHandler.storeTrapInContext" >
		                    <xsl:with-param name="engine" ><xsl:value-of select="@engine" /></xsl:with-param>
		                    <xsl:with-param name="engine-type" ><xsl:value-of select="@engine-type" /></xsl:with-param>
		                    <xsl:with-param name="alarm.id" ><xsl:value-of select="@alarm.id" /></xsl:with-param>
		                    <xsl:with-param name="debounce" ><xsl:value-of select="@debounce" /></xsl:with-param>
		                    <xsl:with-param name="clear-debounce" ><xsl:value-of select="@clear-debounce" /></xsl:with-param>
		                    <xsl:with-param name="mib" ><xsl:value-of select="@mib" /></xsl:with-param>
		                    <xsl:with-param name="severity" ><xsl:value-of select="$resetSeverity" /></xsl:with-param>
							<xsl:with-param name="sla" ><xsl:value-of select="$resetSeverity" /></xsl:with-param>
		                    <xsl:with-param name="behaviour" ><xsl:value-of select="@behaviour" /></xsl:with-param>
		                    <xsl:with-param name="pending" ><xsl:value-of select="$resetPending" /></xsl:with-param>
		                    <xsl:with-param name="text" ><xsl:value-of select="@text" /></xsl:with-param>
							<xsl:with-param name="traptext" ><xsl:value-of select="@traptext" /></xsl:with-param>
		                    <xsl:with-param name="subject" ><xsl:value-of select="@subject" /></xsl:with-param>
		                    <xsl:with-param name="counter" ><xsl:value-of select="$resetCounter" /></xsl:with-param>
							<xsl:with-param name="buinfo1" ><xsl:value-of select="@buinfo1" /></xsl:with-param>
							<xsl:with-param name="buinfo2" ><xsl:value-of select="@buinfo2" /></xsl:with-param>
							<xsl:with-param name="buinfo3" ><xsl:value-of select="@buinfo3" /></xsl:with-param>
							<xsl:with-param name="buinfo4" ><xsl:value-of select="@buinfo4" /></xsl:with-param>
							<xsl:with-param name="service" ><xsl:value-of select="@service" /></xsl:with-param>							
		                    <xsl:with-param name="sql.disable" ><xsl:value-of select="@sql.disable" /></xsl:with-param>
					        <xsl:with-param name="trap.disable" ><xsl:value-of select="@trap.disable" /></xsl:with-param>
					        <xsl:with-param name="email.enable" ><xsl:value-of select="@email.enable" /></xsl:with-param>
					        <xsl:with-param name="sms.enable" ><xsl:value-of select="@sms.enable" /></xsl:with-param>
							<xsl:with-param name="backup.enable" ><xsl:value-of select="@backup.enable" /></xsl:with-param>
							<xsl:with-param name="backup.auto" ><xsl:value-of select="@backup.auto" /></xsl:with-param>
							<xsl:with-param name="backup.type" ><xsl:value-of select="@backup.type" /></xsl:with-param>
							<xsl:with-param name="alarmlamp.enable" ><xsl:value-of select="@alarmlamp.enable" /></xsl:with-param>
		                </xsl:call-template>
		            </xsl:if>
                   </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <context datachange="1" />
    </xsl:template> 
    
    
    
<!-- ############################################################################################################################### -->
    
    <!-- Reset all alarms -->
    
    <xsl:template name="resetAllAlarms" >
        <xsl:for-each select="$context/*[@pending=1]" >
	        <xsl:choose>
	            <xsl:when test="starts-with(name(),'trap.')" >
	                <xsl:call-template name="trapHandler.storeTrapInContext" >
	                    <xsl:with-param name="engine" ><xsl:value-of select="@engine" /></xsl:with-param>
	                    <xsl:with-param name="engine-type" ><xsl:value-of select="@engine-type" /></xsl:with-param>
	                    <xsl:with-param name="alarm.id" ><xsl:value-of select="@alarm.id" /></xsl:with-param>
	                    <xsl:with-param name="debounce" ><xsl:value-of select="@debounce" /></xsl:with-param>
	                    <xsl:with-param name="clear-debounce" ><xsl:value-of select="@clear-debounce" /></xsl:with-param>
	                    <xsl:with-param name="mib" ><xsl:value-of select="@mib" /></xsl:with-param>
	                    <xsl:with-param name="severity" ><xsl:value-of select="$resetSeverity" /></xsl:with-param>
						<xsl:with-param name="sla" ><xsl:value-of select="$resetSeverity" /></xsl:with-param>
	                    <xsl:with-param name="behaviour" ><xsl:value-of select="@behaviour" /></xsl:with-param>
	                    <xsl:with-param name="pending" ><xsl:value-of select="$resetPending" /></xsl:with-param>
	                    <xsl:with-param name="text" ><xsl:value-of select="@text" /></xsl:with-param>
						<xsl:with-param name="traptext" ><xsl:value-of select="@traptext" /></xsl:with-param>
	                    <xsl:with-param name="subject" ><xsl:value-of select="@subject" /></xsl:with-param>
	                    <xsl:with-param name="counter" ><xsl:value-of select="$resetCounter" /></xsl:with-param>
						<xsl:with-param name="buinfo1" ><xsl:value-of select="@buinfo1" /></xsl:with-param>
						<xsl:with-param name="buinfo2" ><xsl:value-of select="@buinfo2" /></xsl:with-param>
						<xsl:with-param name="buinfo3" ><xsl:value-of select="@buinfo3" /></xsl:with-param>
						<xsl:with-param name="buinfo4" ><xsl:value-of select="@buinfo4" /></xsl:with-param>
						<xsl:with-param name="service" ><xsl:value-of select="@service" /></xsl:with-param>						
	                    <xsl:with-param name="sql.disable" ><xsl:value-of select="@sql.disable" /></xsl:with-param>
                        <xsl:with-param name="trap.disable" ><xsl:value-of select="@trap.disable" /></xsl:with-param>
                        <xsl:with-param name="email.enable" ><xsl:value-of select="@email.enable" /></xsl:with-param>
                        <xsl:with-param name="sms.enable" ><xsl:value-of select="@sms.enable" /></xsl:with-param>
						<xsl:with-param name="backup.enable" ><xsl:value-of select="@backup.enable" /></xsl:with-param>
						<xsl:with-param name="backup.auto" ><xsl:value-of select="@backup.auto" /></xsl:with-param>
						<xsl:with-param name="backup.type" ><xsl:value-of select="@backup.type" /></xsl:with-param>
						<xsl:with-param name="alarmlamp.enable" ><xsl:value-of select="@alarmlamp.enable" /></xsl:with-param>
	                </xsl:call-template>
	            </xsl:when>
	            <xsl:when test="starts-with(name(),'AE.') or 
	                            starts-with(name(),'AD.') or 
	                            starts-with(name(),'AA.') " >
	                <xsl:call-template name="alarmHandler.updateAlarmContext">
	                    <xsl:with-param name="currentContext" select="." />
	                    <xsl:with-param name="counter" select="$resetCounter" />
	                    <xsl:with-param name="pending" select="$resetPending" />
	                    <xsl:with-param name="subject-value" select="@subject-value" />
	                </xsl:call-template>
	            </xsl:when>
	        </xsl:choose>
        </xsl:for-each>
        <context datachange="1" />
    </xsl:template> 
	
	
	
	
<!-- ############################################################################################################################### -->
    
    <!-- Reset all alarms -->
    
    <xsl:template name="resetAllAlarmsWithoutEngineId" >
        <xsl:for-each select="$context/*[@pending=1]" >
            <xsl:choose>
                <xsl:when test="starts-with(name(),'trap.')" >
                    <xsl:call-template name="trapHandler.storeTrapInContext" >
                        <xsl:with-param name="engine" ><xsl:value-of select="@engine" /></xsl:with-param>
                        <xsl:with-param name="engine-type" ><xsl:value-of select="@engine-type" /></xsl:with-param>
                        <xsl:with-param name="alarm.id" ><xsl:value-of select="@alarm.id" /></xsl:with-param>
                        <xsl:with-param name="debounce" ><xsl:value-of select="@debounce" /></xsl:with-param>
                        <xsl:with-param name="clear-debounce" ><xsl:value-of select="@clear-debounce" /></xsl:with-param>
                        <xsl:with-param name="mib" ><xsl:value-of select="@mib" /></xsl:with-param>
                        <xsl:with-param name="severity" ><xsl:value-of select="$resetSeverity" /></xsl:with-param>
						<xsl:with-param name="sla" ><xsl:value-of select="$resetSeverity" /></xsl:with-param>
                        <xsl:with-param name="behaviour" ><xsl:value-of select="@behaviour" /></xsl:with-param>
                        <xsl:with-param name="pending" ><xsl:value-of select="$resetPending" /></xsl:with-param>
                        <xsl:with-param name="text" ><xsl:value-of select="@text" /></xsl:with-param>
						<xsl:with-param name="traptext" ><xsl:value-of select="@traptext" /></xsl:with-param>
                        <xsl:with-param name="subject" ><xsl:value-of select="@subject" /></xsl:with-param>
                        <xsl:with-param name="counter" ><xsl:value-of select="$resetCounter" /></xsl:with-param>
						<xsl:with-param name="buinfo1" ><xsl:value-of select="@buinfo1" /></xsl:with-param>
						<xsl:with-param name="buinfo2" ><xsl:value-of select="@buinfo2" /></xsl:with-param>
						<xsl:with-param name="buinfo3" ><xsl:value-of select="@buinfo3" /></xsl:with-param>
						<xsl:with-param name="buinfo4" ><xsl:value-of select="@buinfo4" /></xsl:with-param>
						<xsl:with-param name="service" ><xsl:value-of select="@service" /></xsl:with-param>												
                        <xsl:with-param name="sql.disable" ><xsl:value-of select="@sql.disable" /></xsl:with-param>
                        <xsl:with-param name="trap.disable" ><xsl:value-of select="@trap.disable" /></xsl:with-param>
                        <xsl:with-param name="email.enable" ><xsl:value-of select="@email.enable" /></xsl:with-param>
                        <xsl:with-param name="sms.enable" ><xsl:value-of select="@sms.enable" /></xsl:with-param>
						<xsl:with-param name="backup.enable" ><xsl:value-of select="@backup.enable" /></xsl:with-param>
						<xsl:with-param name="backup.auto" ><xsl:value-of select="@backup.auto" /></xsl:with-param>
						<xsl:with-param name="backup.type" ><xsl:value-of select="@backup.type" /></xsl:with-param>
						<xsl:with-param name="alarmlamp.enable" ><xsl:value-of select="@alarmlamp.enable" /></xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="starts-with(name(),'AE.') or 
                                starts-with(name(),'AD.') or 
                                starts-with(name(),'AA.') " >
                    <xsl:call-template name="alarmHandler.updateAlarmContext">
                        <xsl:with-param name="currentContext" select="." />
                        <xsl:with-param name="counter" select="$resetCounter" />
                        <xsl:with-param name="pending" select="$resetPending" />
                        <xsl:with-param name="subject-value" select="@subject-value" />
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
        <context datachange="1" />
    </xsl:template> 
    
    
</xsl:stylesheet> 
