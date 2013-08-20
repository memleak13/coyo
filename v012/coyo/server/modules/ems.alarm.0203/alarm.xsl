<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:variable name="alarm-handler.timerValue" select="1" />
	<xsl:variable name="alarm-handler.debounceCountTimer" select="$context/@alarm-handler.debounceCountTimer" />
	<xsl:variable name="inputEngine" select="string($conf/@input.engine)"  />
	<xsl:variable name="moduleNameVarName" select="concat($inputEngine, '.module.name')" />
	<xsl:variable name="moduleNumberVarName" select="concat($inputEngine, '.module.number')" />
	<xsl:variable name="engineIpAddressVarName" select="concat($inputEngine, '.ipadress')" />
	

	
 
 	<xsl:template name="alarmHandler.init">
 		<xsl:param name="alarmDef" />
           <xsl:call-template name="alarmHandler.initSubscribe" >
	           <xsl:with-param name="alarmDef" select="$alarmDef" />
           </xsl:call-template>
           <xsl:call-template name="alarmHandler.initContext" >
	           <xsl:with-param name="alarmDef" select="$alarmDef" />
           </xsl:call-template>
           <xsl:call-template name="alarmHandler.initSubAlarmEngines"/>
		   
		   		<xsl:variable name="default.severity">
					<xsl:choose>
						<xsl:when test="number($conf/@default.severity)">
							<xsl:variable name="severity" select="number($conf/@default.severity)"/>
							<xsl:choose>
								<xsl:when test="$severity &gt;= 1 and $severity &lt;=5">
									<xsl:value-of select="$severity"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="5"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="5"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
           <context>
           		<default.severity type="severity" severity="{$default.severity}" pending="0" behaviour="3"  />
           </context>
 	</xsl:template>
    
    
    
	<!--
		Read the alarm definition file and create the context for every alarm
	-->
	<xsl:template name="alarmHandler.initContext">
		<xsl:param name="alarmDef" />
	    
	    <context notificationEngine="{$conf/@notification.engine}">	
            <xsl:for-each select="$alarmDef/event">
				<xsl:variable name="id" select="@id" />
				<xsl:variable name="eventElementName" select="concat('AE.', $id)" />
				<xsl:element name="{$eventElementName}">
					<xsl:attribute name="type">event</xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
					<xsl:attribute name="test-variable"><xsl:value-of select="concat($inputEngine, '.', $id)" /></xsl:attribute>
					<xsl:attribute name="enabled"><xsl:value-of select="@enabled" /></xsl:attribute>
					<xsl:attribute name="notification-id"><xsl:value-of select="@notification-id"/></xsl:attribute>
					<xsl:attribute name="value">0</xsl:attribute>
					<xsl:attribute name="subject-id"><xsl:value-of select="@subject-id" /></xsl:attribute> 
					<xsl:attribute name="subject-value"></xsl:attribute>
					
					<xsl:attribute name="sql.disable"><xsl:value-of select="@sql.disable" /></xsl:attribute> 
					<xsl:attribute name="trap.disable"><xsl:value-of select="@trap.disable" /></xsl:attribute> 
					<xsl:attribute name="email.enable"><xsl:value-of select="@email.enable" /></xsl:attribute> 
					<xsl:attribute name="sms.enable"><xsl:value-of select="@sms.enable" /></xsl:attribute>
					<xsl:attribute name="backup.enable"><xsl:value-of select="@backup.enable" /></xsl:attribute>
					<xsl:attribute name="backup.auto"><xsl:value-of select="@backup.auto" /></xsl:attribute> 
					<xsl:attribute name="backup.type"><xsl:value-of select="@backup.type" /></xsl:attribute> 
					<xsl:attribute name="alarmlamp.enable"><xsl:value-of select="@alarmlamp.enable" /></xsl:attribute> 
				</xsl:element>
			</xsl:for-each>			
			
			<xsl:for-each select="$alarmDef/discret-alarm">
				<xsl:variable name="id" select="@id" />
				<xsl:for-each select="equal">
					<xsl:variable name="eventElementName" select="concat('AD.', $id, '.', @value)" />
					<xsl:element name="{$eventElementName}">
						<xsl:attribute name="type">equal</xsl:attribute>
						<xsl:attribute name="test-variable"><xsl:value-of select="concat($inputEngine,'.', $id)" /></xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
						<xsl:attribute name="enabled"><xsl:value-of select="@enabled" /></xsl:attribute>
						<xsl:attribute name="notification-id"><xsl:value-of select="@notification-id" /></xsl:attribute>
						<xsl:attribute name="clear-notification-id"><xsl:value-of select="@clear-notification-id" /></xsl:attribute>
						<xsl:attribute name="debounce"><xsl:value-of select="@debounce" /></xsl:attribute>
						<xsl:attribute name="clear-debounce"><xsl:value-of select="@clear-debounce" /></xsl:attribute>
						<xsl:attribute name="counter"><xsl:value-of select="0" /></xsl:attribute>
						<xsl:attribute name="pending"><xsl:value-of select="-1" /></xsl:attribute>
						<xsl:attribute name="subject-id"><xsl:value-of select="@subject-id"/></xsl:attribute> 
						<xsl:attribute name="subject-value"></xsl:attribute> 
						<xsl:attribute name="output-var"><xsl:value-of select="@output-var" /></xsl:attribute> 
						<xsl:attribute name="output-var-value"><xsl:value-of select="@output-var-value" /></xsl:attribute> 
						<xsl:attribute name="output-var-clear-value"><xsl:value-of select="@output-var-clear-value" /></xsl:attribute> 					
						<xsl:attribute name="sql.disable"><xsl:value-of select="@sql.disable" /></xsl:attribute> 
						<xsl:attribute name="trap.disable"><xsl:value-of select="@trap.disable" /></xsl:attribute> 
						<xsl:attribute name="email.enable"><xsl:value-of select="@email.enable" /></xsl:attribute> 
						<xsl:attribute name="sms.enable"><xsl:value-of select="@sms.enable" /></xsl:attribute>
						<xsl:attribute name="backup.enable"><xsl:value-of select="@backup.enable" /></xsl:attribute> 
						<xsl:attribute name="backup.auto"><xsl:value-of select="@backup.auto" /></xsl:attribute> 
						<xsl:attribute name="backup.type"><xsl:value-of select="@backup.type" /></xsl:attribute> 
						<xsl:attribute name="alarmlamp.enable"><xsl:value-of select="@alarmlamp.enable" /></xsl:attribute> 
					</xsl:element>
				</xsl:for-each>
				<xsl:for-each select="unequal">
					<xsl:variable name="eventElementName" select="concat('AD.', $id, '.', @value)" />
					<xsl:element name="{$eventElementName}">
						<xsl:attribute name="type">unequal</xsl:attribute>
						<xsl:attribute name="test-variable"><xsl:value-of select="concat($inputEngine,'.', $id)" /></xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
						<xsl:attribute name="enabled"><xsl:value-of select="@enabled" /></xsl:attribute>
						<xsl:attribute name="notification-id"><xsl:value-of select="@notification-id" /></xsl:attribute>
						<xsl:attribute name="clear-notification-id"><xsl:value-of select="@clear-notification-id" /></xsl:attribute>
						<xsl:attribute name="debounce"><xsl:value-of select="@debounce" /></xsl:attribute>
						<xsl:attribute name="clear-debounce"><xsl:value-of select="@clear-debounce" /></xsl:attribute>
						<xsl:attribute name="counter"><xsl:value-of select="0" /></xsl:attribute>
						<xsl:attribute name="pending"><xsl:value-of select="-1" /></xsl:attribute>
						<xsl:attribute name="subject-id"><xsl:value-of select="@subject-id"/></xsl:attribute> 
						<xsl:attribute name="subject-value"></xsl:attribute> 
						<xsl:attribute name="output-var"><xsl:value-of select="@output-var" /></xsl:attribute> 
						<xsl:attribute name="output-var-value"><xsl:value-of select="@output-var-value" /></xsl:attribute> 
						<xsl:attribute name="output-var-clear-value"><xsl:value-of select="@output-var-clear-value" /></xsl:attribute> 					
						<xsl:attribute name="sql.disable"><xsl:value-of select="@sql.disable" /></xsl:attribute> 
						<xsl:attribute name="trap.disable"><xsl:value-of select="@trap.disable" /></xsl:attribute> 
						<xsl:attribute name="email.enable"><xsl:value-of select="@email.enable" /></xsl:attribute> 
						<xsl:attribute name="sms.enable"><xsl:value-of select="@sms.enable" /></xsl:attribute>
						<xsl:attribute name="backup.enable"><xsl:value-of select="@backup.enable" /></xsl:attribute> 
						<xsl:attribute name="backup.auto"><xsl:value-of select="@backup.auto" /></xsl:attribute> 
						<xsl:attribute name="backup.type"><xsl:value-of select="@backup.type" /></xsl:attribute> 
						<xsl:attribute name="alarmlamp.enable"><xsl:value-of select="@alarmlamp.enable" /></xsl:attribute> 
					</xsl:element>
				</xsl:for-each>			
			</xsl:for-each>
	        
			<xsl:for-each select="$alarmDef/analog-alarm">
				<xsl:variable name="id" select="@id" />
				<xsl:for-each select="gt | lt">
					<xsl:variable name="elementTag" select="local-name(.)" />
					<xsl:variable name="eventElementName" select="concat('AA.', $id, '.', $elementTag)" />
					<xsl:element name="{$eventElementName}">
						
						<xsl:attribute name="test-variable"><xsl:value-of select="concat($inputEngine, '.', $id)" /></xsl:attribute>
						<xsl:attribute name="id"><xsl:value-of select="$id" /></xsl:attribute>
						<xsl:attribute name="type"><xsl:value-of select="$elementTag" /></xsl:attribute>
						<xsl:attribute name="subject-id"><xsl:value-of select="@subject-id"/></xsl:attribute> 
						<xsl:attribute name="subject-value"></xsl:attribute> 
						<xsl:choose>
							<xsl:when test="boolean(@value)">
								<xsl:attribute name="limittype">value</xsl:attribute>
								<xsl:attribute name="value"><xsl:value-of select="@value" /></xsl:attribute>
							</xsl:when>
							<xsl:when test="boolean(@local-variable)">
								<xsl:attribute name="limittype">lvar</xsl:attribute>
								<xsl:attribute name="limit-variable"><xsl:value-of select="concat($inputEngine, '.', @local-variable)" /></xsl:attribute>
								<xsl:attribute name="value"></xsl:attribute>
							</xsl:when>
							<xsl:when test="boolean(@global-variable)">
								<xsl:attribute name="limittype">gvar</xsl:attribute>
								<xsl:attribute name="limit-variable"><xsl:value-of select="@global-variable" /></xsl:attribute>
								<xsl:attribute name="value"></xsl:attribute>
							</xsl:when>
						</xsl:choose>
						<xsl:attribute name="hysteresis">
							<xsl:choose>
								<xsl:when test="boolean(@hysteresis)"><xsl:value-of select="@hysteresis" /></xsl:when>
								<xsl:otherwise>0</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>
						<xsl:attribute name="notification-id"><xsl:value-of select="@notification-id" /></xsl:attribute>
						<xsl:attribute name="clear-notification-id"><xsl:value-of select="@clear-notification-id" /></xsl:attribute>
						<xsl:attribute name="debounce"><xsl:value-of select="@debounce" /></xsl:attribute>
						<xsl:attribute name="clear-debounce"><xsl:value-of select="@clear-debounce" /></xsl:attribute>
						<xsl:attribute name="enabled"><xsl:value-of select="@enabled" /></xsl:attribute>
						<xsl:attribute name="counter"><xsl:value-of select="0" /></xsl:attribute>
						<xsl:attribute name="pending"><xsl:value-of select="-1" /></xsl:attribute>
						<xsl:attribute name="output-var"><xsl:value-of select="@output-var" /></xsl:attribute> 
						<xsl:attribute name="output-var-value"><xsl:value-of select="@output-var-value" /></xsl:attribute> 
						<xsl:attribute name="output-var-clear-value"><xsl:value-of select="@output-var-clear-value" /></xsl:attribute> 					
						<xsl:attribute name="sql.disable"><xsl:value-of select="@sql.disable" /></xsl:attribute> 
						<xsl:attribute name="trap.disable"><xsl:value-of select="@trap.disable" /></xsl:attribute> 
						<xsl:attribute name="email.enable"><xsl:value-of select="@email.enable" /></xsl:attribute> 
						<xsl:attribute name="sms.enable"><xsl:value-of select="@sms.enable" /></xsl:attribute>
						<xsl:attribute name="backup.enable"><xsl:value-of select="@backup.enable" /></xsl:attribute> 
						<xsl:attribute name="backup.auto"><xsl:value-of select="@backup.auto" /></xsl:attribute> 
						<xsl:attribute name="backup.type"><xsl:value-of select="@backup.type" /></xsl:attribute> 
						<xsl:attribute name="alarmlamp.enable"><xsl:value-of select="@alarmlamp.enable" /></xsl:attribute> 
					</xsl:element>
				</xsl:for-each>
			</xsl:for-each>
		</context>
	</xsl:template>
    
    
    
	<!--
		Subscribe Mib variables with the given alarm definition
	-->
	<xsl:template name="alarmHandler.initSubscribe">
		<xsl:param name="alarmDef"/>
		<subscribe>
			<mib name="{$moduleNameVarName}" />
			<mib name="{$moduleNumberVarName}" />
			<mib name="{$engineIpAddressVarName}" />
			
			
			<xsl:for-each select="$alarmDef/event">
				<xsl:variable name="test-variable" select="concat($inputEngine, '.', @id)" />
				<mib name="{$test-variable}" />
				<xsl:if test="boolean(@subject-id)" >
					<xsl:variable name="subject-var" select="concat($inputEngine, '.', @subject-id)" />
					<mib name="{$subject-var}" />
				</xsl:if>
			</xsl:for-each>
	
			<xsl:for-each select="$alarmDef/discret-alarm">
				<xsl:variable name="test-variable" select="concat($inputEngine, '.', @id)" />
				<mib name="{$test-variable}" />
                 <xsl:for-each select="equal |unequal" >
                      <xsl:if test="boolean(@subject-id)" >
                            <xsl:variable name="subject-var" select="concat($inputEngine, '.', @subject-id)" />
                            <mib name="{$subject-var}" />
                      </xsl:if>
                 </xsl:for-each>				
			</xsl:for-each>
	
			<xsl:for-each select="$alarmDef/analog-alarm">
				<xsl:variable name="test-variable" select="concat($inputEngine, '.', @id)" />
				<mib name="{$test-variable}" />
				<xsl:for-each select="gt | lt" >
					<xsl:if test="boolean(@local-variable)" >
						<xsl:variable name="lv" select="concat($inputEngine, '.', @local-variable)" />
						<mib name="{$lv}" />
					</xsl:if>
					<xsl:if test="boolean(@global-variable)" >
						<mib name="{@global-variable}" />
					</xsl:if>
					<xsl:if test="boolean(@subject-id)" >
						<xsl:variable name="subject-var" select="concat($inputEngine, '.', @subject-id)" />
						<mib name="{$subject-var}" />
					</xsl:if>
				</xsl:for-each>
			</xsl:for-each>
		</subscribe>
	</xsl:template>

    
	<!--
		Init external severity mib variables
	-->
	<xsl:template name="alarmHandler.initSubAlarmEngines" >
		<xsl:for-each select="$conf/state_cleared_by_system" >
			<xsl:variable name="eln" select="concat('severity-3.', @name)" />
			<context>
				<xsl:element name="{$eln}" >
					<xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>
					<xsl:attribute name="severity"><xsl:value-of select="5"/></xsl:attribute>
					<xsl:attribute name="type"><xsl:value-of select="'severity'"/></xsl:attribute>
					<xsl:attribute name="behaviour"><xsl:value-of select="3"/></xsl:attribute>
					<xsl:attribute name="pending"><xsl:value-of select="0"/></xsl:attribute>
				</xsl:element>
			</context>
			<subscribe>
				<mib name="{@name}" />
			</subscribe>
		</xsl:for-each>	
		<xsl:for-each select="$conf/state_cleared_by_user" >
			<xsl:variable name="eln" select="concat('severity-2.', @name)" />
			<context>
				<xsl:element name="{$eln}" >
					<xsl:attribute name="id"><xsl:value-of select="@name"/></xsl:attribute>
					<xsl:attribute name="severity"><xsl:value-of select="5"/></xsl:attribute>
					<xsl:attribute name="type"><xsl:value-of select="'severity'"/></xsl:attribute>
					<xsl:attribute name="behaviour"><xsl:value-of select="2"/></xsl:attribute>
					<xsl:attribute name="pending"><xsl:value-of select="0"/></xsl:attribute>
				</xsl:element>
			</context>
			<subscribe>
				<mib name="{@name}" />
			</subscribe>
		</xsl:for-each>		
		<xsl:for-each select="$conf/subengine" >
			<xsl:if test="boolean(@id)">
				<xsl:variable name="mibVarS" select="concat(@id , '.state_cleared_by_system')" />
				<xsl:variable name="mibVarU" select="concat(@id , '.state_cleared_by_user')" />
				<xsl:variable name="elnS" select="concat('severity-3.', $mibVarS)" />
				<xsl:variable name="elnU" select="concat('severity-2.', $mibVarU)" />
				<context>
					<xsl:element name="{$elnS}" >
						<xsl:attribute name="id"><xsl:value-of select="$mibVarS"/></xsl:attribute>
						<xsl:attribute name="severity"><xsl:value-of select="5"/></xsl:attribute>
						<xsl:attribute name="type"><xsl:value-of select="'severity'"/></xsl:attribute>
						<xsl:attribute name="behaviour"><xsl:value-of select="3"/></xsl:attribute>
						<xsl:attribute name="pending"><xsl:value-of select="0"/></xsl:attribute>
					</xsl:element>
					<xsl:element name="{$elnU}" >
						<xsl:attribute name="id"><xsl:value-of select="$mibVarU"/></xsl:attribute>
						<xsl:attribute name="severity"><xsl:value-of select="5"/></xsl:attribute>
						<xsl:attribute name="type"><xsl:value-of select="'severity'"/></xsl:attribute>
						<xsl:attribute name="behaviour"><xsl:value-of select="2"/></xsl:attribute>
						<xsl:attribute name="pending"><xsl:value-of select="0"/></xsl:attribute>
					</xsl:element>
				</context>
				<subscribe>
					<mib name="{$mibVarS}" />
					<mib name="{$mibVarU}" />
				</subscribe>
			</xsl:if>
		</xsl:for-each>		
	</xsl:template>





	<xsl:template match="/alarm:fireEvent" xmlns:alarm="http://euromedia-service.de/coyoNET/alarm/">
		<xsl:if test="@input.engine=$inputEngine" >
			<xsl:call-template name="alarmHandler.fireEvent">
				<xsl:with-param name="varName" select="@variableName"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="alarmHandler.fireEvent">
		<xsl:param name="varName" />
		<xsl:variable name="currentContext" select="$context/*[(@type='event') and (@test-variable=$varName) ]" />
		<xsl:variable name="value" select="$currentContext[1]/@value" />
		<xsl:choose>
			<xsl:when test="boolean($value)">
				<mib>
					<set name="{$varName}" value="{$value}" />
				</mib>
				<xsl:call-template name="alarmHandler.updateEventContext">
					<xsl:with-param name="currentContext" select="$currentContext" />
					<xsl:with-param name="value" select="$value + 1"/>
					<xsl:with-param name="subject-value" select="$currentContext/@subject-value"/>
				</xsl:call-template>
			</xsl:when>		
			<xsl:otherwise>
				<mib>
					<set name="{$varName}" value="{$dyn/@second}" />
				</mib>
			</xsl:otherwise>		
		</xsl:choose>		
	</xsl:template>
 
    
    
	<!--
		Check for every MIB variable of this engine the alarm state
	-->
	<xsl:template name="alarmHandler.processMibSet">
		<xsl:param name="mib" />
        <!-- 
        find mib variable in the context as test-variable, 
        other variables could define limits and subject 
        -->
        
        <xsl:for-each select="$mib/set" >
        	<xsl:variable name="name" select="@name" />
			<xsl:variable name="value" select="@value" />
            
            <xsl:if test="not (boolean(@value))" >
                <debug>mib var cleared name[<xsl:value-of select="@name" />] value[<xsl:value-of select="@value" />]</debug>
            </xsl:if>
            
			<xsl:call-template name="alarmHandler.updateMibVar">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="value" select="$value" />
			</xsl:call-template>

			<!-- store external sub engine mib vars. -->
			<xsl:call-template name="alarmHandler.updateSeverityMib">
				<xsl:with-param name="name" select="$name" />
				<xsl:with-param name="value" select="$value" />
			</xsl:call-template>    
        </xsl:for-each>
        
        
		<xsl:for-each select="$mib/set[starts-with(@name,$inputEngine)]">
			<xsl:variable name="name" select="@name" />
			<xsl:variable name="value" select="@value" />
			<xsl:for-each select="$context/*[@test-variable=$name]" >
				<xsl:choose>
					<xsl:when test="@type='event'">
						<xsl:call-template name="alarmHandler.processEvent">
							<xsl:with-param name="name" select="$name" />
							<xsl:with-param name="value" select="$value" />
							<xsl:with-param name="mib" select="$mib" />
							<xsl:with-param name="currentContext" select="." />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@type='equal' or @type='unequal'">
						<xsl:call-template name="alarmHandler.processDiscreteAlarm">
							<xsl:with-param name="type" select="@type" />
							<xsl:with-param name="name" select="$name" />
							<xsl:with-param name="value" select="$value" />
							<xsl:with-param name="mib" select="$mib" />
							<xsl:with-param name="currentContext" select="." />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@type='gt'">
						<xsl:call-template name="alarmHandler.processAnalogHigh">
							<xsl:with-param name="name" select="$name" />
							<xsl:with-param name="value" select="$value" />
							<xsl:with-param name="currentContext" select="." />
							<xsl:with-param name="mib" select="$mib" />
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="@type='lt'">
						<xsl:call-template name="alarmHandler.processAnalogLow">
							<xsl:with-param name="name" select="$name" />
							<xsl:with-param name="value" select="$value" />
							<xsl:with-param name="currentContext" select="." />
							<xsl:with-param name="mib" select="$mib" />
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>			
			</xsl:for-each>
		</xsl:for-each>
		<context datachange="1" />
	</xsl:template>

	<xsl:template match="/timer[@id='calculateSeverity']" >
		<xsl:if test="$context/@datachange=1" >
			<!--<severity.2030 id="2030" severity="5" type="severity" behaviour="3" pending="1" />-->

		      <xsl:variable name="allClearedBySystem" select="$context/*[@type='severity' and @severity&lt;6 and @behaviour='3']/@severity" />
		      <xsl:variable name="state_cleared_by_system" select="$allClearedBySystem[not (. &gt; $allClearedBySystem)]" />
		      <xsl:variable name="allClearedByUser" select="$context/*[@type='severity' and @severity&lt;6 and @behaviour='2']/@severity" />

		      <xsl:variable name="state_Cleared_by_user" select="$allClearedByUser[not (. &gt; $allClearedByUser)]" />
			  <mib>
			  	<set name="state_cleared_by_system" value="{$state_cleared_by_system}" />
			  	<set name="state_Cleared_by_user" value="{$state_Cleared_by_user}" />
			  	<xsl:choose>
			  		<xsl:when test="$state_Cleared_by_user &lt; $state_cleared_by_system" >
			  			<set name="state" value="{$state_Cleared_by_user}" /> 
			  		</xsl:when>
			  		<xsl:otherwise>
			  			<set name="state" value="{$state_cleared_by_system}" /> 
			  		</xsl:otherwise>


			  	</xsl:choose>
			  </mib>
		</xsl:if>	  
		<context datachange="0" />
		<timer delay="{$alarm-handler.debounceCountTimer}" id="calculateSeverity" />
	</xsl:template>
	
	


	<xsl:template name="alarmHandler.processEvent">
		<xsl:param name="name" />
		<xsl:param name="value" />
		<xsl:param name="mib" />
		<xsl:param name="currentContext" />
						
		<!--set the alarm -->
		<xsl:if test="$currentContext/@enabled='1'">
			<xsl:variable name="subjectVarName" select="concat($inputEngine,'.', $currentContext/@subject-id)" />
			<xsl:variable name="subjectValue" select="$mib/set[@name=$subjectVarName]/@value" />
			<xsl:variable name="subject">
			<xsl:choose>
				<xsl:when test="boolean($subjectValue)" ><xsl:value-of select="$subjectValue" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$currentContext/@subject-value" /></xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			
			<xsl:variable name="moduleNameValueMib" select="$mib/set[@name=$moduleNameVarName]/@value" />
			<xsl:variable name="module-type">
			<xsl:choose>
				<xsl:when test="boolean($moduleNameValueMib)" ><xsl:value-of select="$moduleNameValueMib" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$context/@moduleName" /></xsl:otherwise>
			</xsl:choose>
			</xsl:variable>
			
			<xsl:if test="boolean($subject)">
				<xsl:call-template name="alarmHandler.updateEventContext">
					<xsl:with-param name="currentContext" select="$currentContext" />
					<xsl:with-param name="value" select="$currentContext/@value"/>
					<xsl:with-param name="subject-value" select="$subject"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:call-template name="make.notification">
				<xsl:with-param name="idx" select="$currentContext/@notification-id" />
				<xsl:with-param name="module-type" select="$module-type"/>
				<xsl:with-param name="add.subject" select="$subject" />
				<xsl:with-param name="output-var" select="$currentContext/@output-var"/>
				<xsl:with-param name="output-var-value" select="$currentContext/@output-var-value"/>
				<xsl:with-param name="output-var-clear-value" select="$currentContext/@output-var-clear-value"/>
				<xsl:with-param name="sql.disable" select="$currentContext/@sql.disable"/>
				<xsl:with-param name="trap.disable" select="$currentContext/@trap.disable"/>
				<xsl:with-param name="email.enable" select="$currentContext/@email.enable"/>
				<xsl:with-param name="sms.enable" select="$currentContext/@sms.enable"/>
				<xsl:with-param name="backup.enable" select="$currentContext/@backup.enable"/>
				<xsl:with-param name="alarmlamp.enable" select="$currentContext/@alarmlamp.enable"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
  

	<!--handle a discrete equal alarm -->
	<xsl:template name="alarmHandler.processDiscreteAlarm">
		<xsl:param name="type" />
		<xsl:param name="name" />
		<xsl:param name="value" />
		<xsl:param name="mib" />
		<xsl:param name="currentContext" />
 		
		<xsl:variable name="subjectVarName" select="concat($inputEngine,'.', $currentContext/@subject-id)" />
		<xsl:variable name="subjectMibValue" select="$mib/set[@name=$subjectVarName]/@value" />
		<xsl:variable name="subjectContextMibValue" select="$context/*[@type='MIBVAR' and @name=$subjectVarName]/@value" />
		<xsl:variable name="subject">
		<xsl:choose>
			<xsl:when test="boolean($subjectMibValue)" ><xsl:value-of select="$subjectMibValue" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$subjectContextMibValue" /></xsl:otherwise>
		</xsl:choose>
		</xsl:variable>

		<xsl:variable name="moduleNameValueMib" select="$mib/set[@name=$moduleNameVarName]/@value" />
		<xsl:variable name="module-type">
		<xsl:choose>
			<xsl:when test="boolean($moduleNameValueMib)" ><xsl:value-of select="$moduleNameValueMib" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$context/@moduleName" /></xsl:otherwise>
		</xsl:choose>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="(($type='equal') and ($value=$currentContext/@value)) or (($type='unequal') and ($value!=$currentContext/@value) and boolean($value))">
				<!--set the alarm -->
				<xsl:if test="$currentContext/@pending != 1">
					<!--This is an alarm change -->
<!--					<dump file="dump.txt" location="alarmHandler.processDiscreteAlarm value=$currentContext/@value" ><xsl:value-of select="$currentContext/@test-variable" /> counter [<xsl:value-of select="$currentContext/@counter" />]  new counter [<xsl:copy-of select="ceiling($currentContext/@debounce div $alarm-handler.timerValue)" />]</dump> -->
					<xsl:call-template name="alarmHandler.updateAlarmContext">
						<xsl:with-param name="currentContext" select="$currentContext" />
						<xsl:with-param name="counter" select="ceiling($currentContext/@debounce div $alarm-handler.timerValue)" />
						<xsl:with-param name="pending" select="1" />
						<xsl:with-param name="subject-value" select="$subject" />
					</xsl:call-template>
					<xsl:if test="$currentContext/@debounce=0 and $currentContext/@enabled=1 ">
						<!--make a notification without any debounce time -->
						<xsl:call-template name="make.notification">
							<xsl:with-param name="idx" select="$currentContext/@notification-id" />
							<xsl:with-param name="module-type" select="$module-type"/>
							<xsl:with-param name="add.subject" select="$subject" />
							<xsl:with-param name="output-var" select="$currentContext/@output-var"/>
							<xsl:with-param name="output-var" select="$currentContext/@output-var"/>
							<xsl:with-param name="output-var-value" select="$currentContext/@output-var-value"/>
							<xsl:with-param name="output-var-clear-value" select="$currentContext/@output-var-clear-value"/>
							<xsl:with-param name="sql.disable" select="$currentContext/@sql.disable"/>
							<xsl:with-param name="trap.disable" select="$currentContext/@trap.disable"/>
							<xsl:with-param name="email.enable" select="$currentContext/@email.enable"/>
							<xsl:with-param name="sms.enable" select="$currentContext/@sms.enable"/>
							<xsl:with-param name="backup.enable" select="$currentContext/@backup.enable"/>
							<xsl:with-param name="alarmlamp.enable" select="$currentContext/@alarmlamp.enable"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				<!--else, this alarm is already set, do nothing -->
			</xsl:when>
			<xsl:otherwise>
				<!--reset the alarm -->
				<xsl:if test="$currentContext/@pending!=0">
<!--					<dump file="dump.txt" location="alarmHandler.processDiscreteAlarm value != $currentContext/@value" ><xsl:value-of select="$currentContext/@test-variable" /> counter [<xsl:value-of select="$currentContext/@counter" />]  new counter [<xsl:copy-of select="ceiling($currentContext/@debounce div $alarm-handler.timerValue)" />]</dump> -->
					<!--This is a alarm change -->
					<xsl:call-template name="alarmHandler.updateAlarmContext">
						<xsl:with-param name="currentContext" select="$currentContext" />
						<xsl:with-param name="counter" select="ceiling($currentContext/@clear-debounce div $alarm-handler.timerValue)" />
						<xsl:with-param name="pending" select="0" />
						<xsl:with-param name="subject-value" select="$subject" />
					</xsl:call-template>
					<xsl:if test="$currentContext/@clear-debounce=0">
						<!--make a notification without any debounce time -->
						<xsl:call-template name="make.notification" >
							<xsl:with-param name="idx" select="$currentContext/@clear-notification-id" />
							<xsl:with-param name="module-type" select="$module-type"/>
							<xsl:with-param name="add.subject" select="$subject" />
							<xsl:with-param name="output-var" select="$currentContext/@output-var"/>
							<xsl:with-param name="output-var-value" select="$currentContext/@output-var-value"/>
							<xsl:with-param name="output-var-clear-value" select="$currentContext/@output-var-clear-value"/>							
							<xsl:with-param name="sql.disable" select="$currentContext/@sql.disable"/>
							<xsl:with-param name="trap.disable" select="$currentContext/@trap.disable"/>
							<xsl:with-param name="email.enable" select="$currentContext/@email.enable"/>
							<xsl:with-param name="sms.enable" select="$currentContext/@sms.enable"/>
							<xsl:with-param name="backup.enable" select="$currentContext/@backup.enable"/>
							<xsl:with-param name="alarmlamp.enable" select="$currentContext/@alarmlamp.enable"/>							
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!--handle a analog low alarm -->
	<xsl:template name="alarmHandler.processAnalogLow">
		<xsl:param name="name" />
		<xsl:param name="value" />
		<xsl:param name="currentContext" />
		<xsl:param name="mib" />

		<xsl:variable name="subjectVarName" select="concat($inputEngine,'.', $currentContext/@subject-id)" />
		<xsl:variable name="subjectMibValue" select="$mib/set[@name=$subjectVarName]/@value" />
		<xsl:variable name="subjectContextMibValue" select="$context/*[@type='MIBVAR' and @name=$subjectVarName]/@value" />
		<xsl:variable name="subject">
		<xsl:choose>
			<xsl:when test="boolean($subjectMibValue)" ><xsl:value-of select="$subjectMibValue" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$subjectContextMibValue" /></xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
		<!-- check for the change of limit variable -->
		<xsl:variable name="limitVarName" select="$currentContext/@limit-variable"  />
		<xsl:variable name="mibVarValue" select="$mib/set[@name=$limitVarName]/@value" /> 
		<xsl:variable name="contVarValue" select="$context/*[@type='MIBVAR' and @name=$limitVarName]/@value" />
		<xsl:variable name="contValue" select="$currentContext/@value" />
		<xsl:variable name="limitValue">
		<xsl:choose>
			<xsl:when test="boolean($mibVarValue)" ><xsl:value-of select="$mibVarValue" /></xsl:when>
			<xsl:when test="boolean($contVarValue)" ><xsl:value-of select="$contVarValue" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$contValue" /></xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
				
		<xsl:variable name="moduleNameValueMib" select="$mib/set[@name=$moduleNameVarName]/@value" />
		<xsl:variable name="module-type">
		<xsl:choose>
			<xsl:when test="boolean($moduleNameValueMib)" ><xsl:value-of select="$moduleNameValueMib" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$context/@moduleName" /></xsl:otherwise>
		</xsl:choose>
		</xsl:variable>		
		
		<xsl:choose>
			<xsl:when test="$value &lt; $limitValue">
				<!--set the alarm -->
				<xsl:if test="$currentContext/@pending !=1">
					<!--This is a alarm change -->
					<xsl:call-template name="alarmHandler.updateAlarmContext">
						<xsl:with-param name="currentContext" select="$currentContext" />
						<xsl:with-param name="counter" select="ceiling($currentContext/@debounce div $alarm-handler.timerValue)"  />
						<xsl:with-param name="pending" select="1" />
						<xsl:with-param name="subject-value" select="$subject" />
					</xsl:call-template>
					<xsl:if test="$currentContext/@debounce=0 and $currentContext/@enabled=1 ">
						<!--make a notification without any debounce time -->
						<xsl:call-template name="make.notification">
							<xsl:with-param name="idx" select="$currentContext/@notification-id" />
							<xsl:with-param name="module-type" select="$module-type"/>
							<xsl:with-param name="add.subject" select="$subject" />
							<xsl:with-param name="output-var" select="$currentContext/@output-var"/>
							<xsl:with-param name="output-var-value" select="$currentContext/@output-var-value"/>
							<xsl:with-param name="output-var-clear-value" select="$currentContext/@output-var-clear-value"/>	
							<xsl:with-param name="sql.disable" select="$currentContext/@sql.disable"/>
							<xsl:with-param name="trap.disable" select="$currentContext/@trap.disable"/>
							<xsl:with-param name="email.enable" select="$currentContext/@email.enable"/>
							<xsl:with-param name="sms.enable" select="$currentContext/@sms.enable"/>
							<xsl:with-param name="backup.enable" select="$currentContext/@backup.enable"/>
							<xsl:with-param name="alarmlamp.enable" select="$currentContext/@alarmlamp.enable"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				<!--else, this alarm is already set, do nothing -->
			</xsl:when>
			<xsl:otherwise>
				<!--reset the alarm -->
				<xsl:if test="$value &gt; ($limitValue + $currentContext/@hysteresis)" >
					<xsl:if test="$currentContext/@pending !=0">
						<!--This is a alarm change -->
						<xsl:call-template name="alarmHandler.updateAlarmContext">
							<xsl:with-param name="currentContext" select="$currentContext" />
							<xsl:with-param name="counter" select="ceiling($currentContext/@debounce div $alarm-handler.timerValue)" />
							<xsl:with-param name="pending" select="0" />
							<xsl:with-param name="subject-value" select="$subject" />
						</xsl:call-template>
						<xsl:if test="$currentContext/@clear-debounce=0 and $currentContext/@enabled=1 ">
							<!--make a notification without any debounce time -->
							<xsl:call-template name="make.notification">
								<xsl:with-param name="idx" select="$currentContext/@clear-notification-id" />
								<xsl:with-param name="module-type" select="$module-type"/>
								<xsl:with-param name="add.subject" select="$subject" />
								<xsl:with-param name="output-var" select="$currentContext/@output-var"/>
								<xsl:with-param name="output-var-value" select="$currentContext/@output-var-value"/>
								<xsl:with-param name="output-var-clear-value" select="$currentContext/@output-var-clear-value"/>	
								<xsl:with-param name="sql.disable" select="$currentContext/@sql.disable"/>
								<xsl:with-param name="trap.disable" select="$currentContext/@trap.disable"/>
								<xsl:with-param name="email.enable" select="$currentContext/@email.enable"/>
								<xsl:with-param name="sms.enable" select="$currentContext/@sms.enable"/>
								<xsl:with-param name="backup.enable" select="$currentContext/@backup.enable"/>
								<xsl:with-param name="alarmlamp.enable" select="$currentContext/@alarmlamp.enable"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:if>
				</xsl:if>					
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
    
	<xsl:template name="alarmHandler.processAnalogHigh">
		<xsl:param name="name" />
		<xsl:param name="value" />
		<xsl:param name="currentContext" />
		<xsl:param name="mib" />
 		
		<xsl:variable name="subjectVarName" select="concat($inputEngine,'.', $currentContext/@subject-id)" />
		<xsl:variable name="subjectMibValue" select="$mib/set[@name=$subjectVarName]/@value" />
		<xsl:variable name="subjectContextMibValue" select="$context/*[@type='MIBVAR' and @name=$subjectVarName]/@value" />
		<xsl:variable name="subject">
		<xsl:choose>
			<xsl:when test="boolean($subjectMibValue)" ><xsl:value-of select="$subjectMibValue" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$subjectContextMibValue" /></xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
		<!-- check for the change of limit variable -->
		<xsl:variable name="limitVarName" select="$currentContext/@limit-variable"  />
		<xsl:variable name="mibVarValue" select="$mib/set[@name=$limitVarName]/@value" /> 
		<xsl:variable name="contVarValue" select="$context/*[@type='MIBVAR' and @name=$limitVarName]/@value" />
		<xsl:variable name="contValue" select="$currentContext/@value" />
		<xsl:variable name="limitValue">
		<xsl:choose>
			<xsl:when test="string-length($mibVarValue) &gt; 0" ><xsl:value-of select="$mibVarValue" /></xsl:when>
			<xsl:when test="string-length($contVarValue) &gt; 0" ><xsl:value-of select="$contVarValue" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$contValue" /></xsl:otherwise>
		</xsl:choose>
		</xsl:variable>	
		
		<xsl:variable name="moduleNameValueMib" select="$mib/set[@name=$moduleNameVarName]/@value" />
		<xsl:variable name="module-type">
		<xsl:choose>
			<xsl:when test="boolean($moduleNameValueMib)" ><xsl:value-of select="$moduleNameValueMib" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="$context/@moduleName" /></xsl:otherwise>
		</xsl:choose>
		</xsl:variable>			

		<!--get for the alarm-context the mating alarm and error definition -->
		<xsl:choose>
			<xsl:when test="$value &gt; $limitValue">
				<!--set the alarm -->
				<xsl:if test="$currentContext/@pending !=1">
					<!--This is a alarm change -->
					<xsl:call-template name="alarmHandler.updateAlarmContext">
						<xsl:with-param name="currentContext" select="$currentContext" />
						<xsl:with-param name="counter" select="ceiling($currentContext/@debounce div $alarm-handler.timerValue)" />
						<xsl:with-param name="pending" select="1" />
						<xsl:with-param name="subject-value" select="$subject" />						
					</xsl:call-template>
					<xsl:if test="$currentContext/@debounce=0 and $currentContext/@enabled=1 ">
						<!--make a notification without any debounce time -->
						<xsl:call-template name="make.notification">
							<xsl:with-param name="idx" select="$currentContext/@notification-id" />
							<xsl:with-param name="module-type" select="$module-type"/>	
							<xsl:with-param name="add.subject" select="''" />
							<xsl:with-param name="output-var" select="$currentContext/@output-var"/>
							<xsl:with-param name="output-var-value" select="$currentContext/@output-var-value"/>
							<xsl:with-param name="output-var-clear-value" select="$currentContext/@output-var-clear-value"/>	
							<xsl:with-param name="sql.disable" select="$currentContext/@sql.disable"/>
							<xsl:with-param name="trap.disable" select="$currentContext/@trap.disable"/>
							<xsl:with-param name="email.enable" select="$currentContext/@email.enable"/>
							<xsl:with-param name="sms.enable" select="$currentContext/@sms.enable"/>
							<xsl:with-param name="backup.enable" select="$currentContext/@backup.enable"/>
							<xsl:with-param name="alarmlamp.enable" select="$currentContext/@alarmlamp.enable"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:if>
				<!--else, this alarm is already set, do nothing -->
			</xsl:when>
			<xsl:otherwise>
				<!--reset the alarm -->
				<xsl:if test="$value &lt; ($limitValue - $currentContext/@hysteresis)" >
	 				<xsl:if test="$currentContext/@pending !=0">
						<!--This is a alarm change -->
						<xsl:call-template name="alarmHandler.updateAlarmContext">
							<xsl:with-param name="currentContext" select="$currentContext" />
							<xsl:with-param name="counter" select="ceiling($currentContext/@debounce div $alarm-handler.timerValue)" />
							<xsl:with-param name="pending" select="0" />
							<xsl:with-param name="subject-value" select="$subject" />						
						</xsl:call-template>
						<xsl:if test="$currentContext/@clear-debounce=0 and $currentContext/@enabled=1 ">
							<!--make a notification without any debounce time -->
							<xsl:call-template name="make.notification">
								<xsl:with-param name="idx" select="$currentContext/@clear-notification-id" />
								<xsl:with-param name="module-type" select="$module-type"/>
								<xsl:with-param name="add.subject" select="''" />
								<xsl:with-param name="output-var" select="$currentContext/@output-var"/>
								<xsl:with-param name="output-var-value" select="$currentContext/@output-var-value"/>
								<xsl:with-param name="output-var-clear-value" select="$currentContext/@output-var-clear-value"/>	
								<xsl:with-param name="sql.disable" select="$currentContext/@sql.disable"/>
								<xsl:with-param name="trap.disable" select="$currentContext/@trap.disable"/>
								<xsl:with-param name="email.enable" select="$currentContext/@email.enable"/>
								<xsl:with-param name="sms.enable" select="$currentContext/@sms.enable"/>
								<xsl:with-param name="backup.enable" select="$currentContext/@backup.enable"/>
								<xsl:with-param name="alarmlamp.enable" select="$currentContext/@alarmlamp.enable"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    

	<xsl:template name="alarmHandler.updateAlarmContext">
		<xsl:param name="currentContext" />
		<xsl:param name="counter" />
		<xsl:param name="pending" />
		<xsl:param name="subject-value" />

		<xsl:variable name="elementName" select="local-name($currentContext)" />
		<context>
				<xsl:element name="{$elementName}">
					<xsl:attribute name="counter"><xsl:value-of select="$counter" /></xsl:attribute>
					<xsl:attribute name="pending"><xsl:value-of select="$pending" /></xsl:attribute>
					<xsl:attribute name="subject-value"><xsl:value-of select="$subject-value"/></xsl:attribute> 
	
					<xsl:attribute name="type"><xsl:value-of select="$currentContext/@type" /></xsl:attribute>
					<xsl:attribute name="test-variable"><xsl:value-of select="$currentContext/@test-variable" /></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="$currentContext/@id" /></xsl:attribute>
					<xsl:attribute name="subject-id"><xsl:value-of select="$currentContext/@subject-id"/></xsl:attribute> 
					<xsl:attribute name="value"><xsl:value-of select="$currentContext/@value" /></xsl:attribute>
					<xsl:attribute name="enabled"><xsl:value-of select="$currentContext/@enabled" /></xsl:attribute>
					<xsl:attribute name="notification-id"><xsl:value-of select="$currentContext/@notification-id" /></xsl:attribute>
					<xsl:attribute name="clear-notification-id"><xsl:value-of select="$currentContext/@clear-notification-id" /></xsl:attribute>
					<xsl:attribute name="debounce"><xsl:value-of select="$currentContext/@debounce" /></xsl:attribute>
					<xsl:attribute name="clear-debounce"><xsl:value-of select="$currentContext/@clear-debounce" /></xsl:attribute>
					
					<xsl:attribute name="output-var"><xsl:value-of select="$currentContext/@output-var" /></xsl:attribute>
					<xsl:attribute name="output-var-value"><xsl:value-of select="$currentContext/@output-var-value" /></xsl:attribute>
					<xsl:attribute name="output-var-clear-value"><xsl:value-of select="$currentContext/@output-var-clear-value" /></xsl:attribute>
	
					<xsl:if test="boolean($currentContext/@limittype)" >
						<xsl:attribute name="limittype"><xsl:value-of select="$currentContext/@limittype" /></xsl:attribute>
						<xsl:attribute name="limit-variable"><xsl:value-of select="$currentContext/@limit-variable" /></xsl:attribute>
						<xsl:attribute name="hysteresis"><xsl:value-of select="$currentContext/@hysteresis" /></xsl:attribute>
					</xsl:if>

					<xsl:attribute name="buinfo1" ><xsl:value-of select="$currentContext/@buinfo1" /></xsl:attribute>
					<xsl:attribute name="buinfo2" ><xsl:value-of select="$currentContext/@buinfo2" /></xsl:attribute>
					<xsl:attribute name="buinfo3" ><xsl:value-of select="$currentContext/@buinfo3" /></xsl:attribute>
					<xsl:attribute name="buinfo4" ><xsl:value-of select="$currentContext/@buinfo4" /></xsl:attribute>
					<xsl:attribute name="service" ><xsl:value-of select="$currentContext/@service" /></xsl:attribute>
					
					<xsl:attribute name="sql.disable"><xsl:value-of select="$currentContext/@sql.disable" /></xsl:attribute>
					<xsl:attribute name="trap.disable"><xsl:value-of select="$currentContext/@trap.disable" /></xsl:attribute>
					<xsl:attribute name="email.enable"><xsl:value-of select="$currentContext/@email.enable" /></xsl:attribute>
					<xsl:attribute name="sms.enable"><xsl:value-of select="$currentContext/@sms.enable" /></xsl:attribute>
					<xsl:attribute name="backup.enable"><xsl:value-of select="$currentContext/@backup.enable" /></xsl:attribute>
					<xsl:attribute name="backup.auto"><xsl:value-of select="$currentContext/@backup.auto" /></xsl:attribute>
					<xsl:attribute name="backup.type"><xsl:value-of select="$currentContext/@backup.type" /></xsl:attribute>
					<xsl:attribute name="alarmlamp.enable"><xsl:value-of select="$currentContext/@alarmlamp.enable" /></xsl:attribute>
					
				</xsl:element>
		</context>
	</xsl:template>


	<xsl:template name="alarmHandler.updateEventContext">
		<xsl:param name="currentContext" />
		<xsl:param name="value" />
		<xsl:param name="subject-value" />
		
		<xsl:variable name="elementName" select="local-name($currentContext)" />
		<context>
			<xsl:element name="{$elementName}">
				<xsl:attribute name="value"><xsl:value-of select="$value" /></xsl:attribute>
				<xsl:attribute name="subject-value"><xsl:value-of select="$subject-value"/></xsl:attribute> 
				<xsl:attribute name="type"><xsl:value-of select="$currentContext/@type" /></xsl:attribute>
				<xsl:attribute name="test-variable"><xsl:value-of select="$currentContext/@test-variable" /></xsl:attribute>
				<xsl:attribute name="id"><xsl:value-of select="$currentContext/@id" /></xsl:attribute>
				<xsl:attribute name="subject-id"><xsl:value-of select="$currentContext/@subject-id"/></xsl:attribute> 
				<xsl:attribute name="enabled"><xsl:value-of select="$currentContext/@enabled" /></xsl:attribute>
				<xsl:attribute name="notification-id"><xsl:value-of select="$currentContext/@notification-id" /></xsl:attribute>
				<xsl:attribute name="buinfo1"><xsl:value-of select="$currentContext/@buinfo1" /></xsl:attribute>
				<xsl:attribute name="buinfo2"><xsl:value-of select="$currentContext/@buinfo2" /></xsl:attribute>
				<xsl:attribute name="buinfo3"><xsl:value-of select="$currentContext/@buinfo3" /></xsl:attribute>
				<xsl:attribute name="buinfo4"><xsl:value-of select="$currentContext/@buinfo4" /></xsl:attribute>
				<xsl:attribute name="service"><xsl:value-of select="$currentContext/@service" /></xsl:attribute>
				<xsl:attribute name="sql.disable"><xsl:value-of select="$currentContext/@sql.disable" /></xsl:attribute>
				<xsl:attribute name="trap.disable"><xsl:value-of select="$currentContext/@trap.disable" /></xsl:attribute>
				<xsl:attribute name="email.enable"><xsl:value-of select="$currentContext/@email.enable" /></xsl:attribute>
				<xsl:attribute name="sms.enable"><xsl:value-of select="$currentContext/@sms.enable" /></xsl:attribute>
				<xsl:attribute name="backup.enable"><xsl:value-of select="$currentContext/@backup.enable" /></xsl:attribute>
				<xsl:attribute name="backup.auto"><xsl:value-of select="$currentContext/@backup.auto" /></xsl:attribute>
				<xsl:attribute name="backup.type"><xsl:value-of select="$currentContext/@backup.type" /></xsl:attribute>
				<xsl:attribute name="alarmlamp.enable"><xsl:value-of select="$currentContext/@alarmlamp.enable" /></xsl:attribute>
			</xsl:element>	
		</context>
	</xsl:template>
	
	<xsl:template name="alarmHandler.updateMibVar">
		<xsl:param name="name" />
		<xsl:param name="value" />
		<xsl:choose>
			<xsl:when test="$name=$moduleNameVarName"	>
				<context moduleName="{$value}" />
			</xsl:when>
			<xsl:when test="$name=$moduleNumberVarName"	>
				<context moduleNumber="{$value}" />
			</xsl:when>	
			<xsl:when test="$name=$engineIpAddressVarName"	>
				<context ipaddress="{$value}" />
			</xsl:when>	
					
			<xsl:otherwise>
				<xsl:variable name="elementName" select="concat('mib.',$name)" />
				<context>
					<xsl:element name="{$elementName}">
						<xsl:attribute name="type"><xsl:value-of select="'MIBVAR'" /></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="$name" /></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="$value" /></xsl:attribute>
					</xsl:element>	
				</context>			
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template name="alarmHandler.updateSeverityMib">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		
		<xsl:for-each select="$context/*[@id=$name and @type='severity']" >
			<xsl:variable name="elementName" select="local-name()"/>
			<context>
				<xsl:element name="{$elementName}">
					<xsl:attribute name="id"><xsl:value-of select="@id" /></xsl:attribute>
					<xsl:attribute name="severity"><xsl:value-of select="$value" /></xsl:attribute>
					<xsl:attribute name="type"><xsl:value-of select="'severity'" /></xsl:attribute>
					<xsl:attribute name="behaviour"><xsl:value-of select="@behaviour" /></xsl:attribute>
					<xsl:attribute name="pending"><xsl:value-of select="@pending" /></xsl:attribute>
				</xsl:element>	
			</context>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template name="alarmHandler.getMibVar" >
		<xsl:param name="name" />
		<xsl:variable name="mib" select="$context/*[@type='MIBVAR' and @name=$name]" />
		<xsl:copy-of select="mib[1]" />
	</xsl:template>
	
	<xsl:template name="alarmHandler.getMibVarValue" >
		<xsl:param name="name" />
		<xsl:variable name="mib" select="$context/*[@type='MIBVAR' and @name=$name]" />
		<xsl:value-of select="mib[1]/@value" />
	</xsl:template>	




	
</xsl:stylesheet> 
