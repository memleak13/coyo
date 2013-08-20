<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:variable name="enable.debug"    select="1" /> 
	<!-- enable.debug
	     0 = no debug infos
	     1 = make debug infos
	-->

    
	<!--
		Signal the alarm with a MIB variable
	-->
 	<xsl:template name="signalMibVar" >
 		<xsl:param name="output-var" />
 		<xsl:param name="output-var-value" />
 		<xsl:param name="output-var-clear-value" />
 		<xsl:param name="pending" />
        
 		<xsl:if test="string-length($output-var)!=0" >
	 		<xsl:choose>
	 			<xsl:when test="$pending=0">
	 				<mib>
	 					<set name="{$output-var}" value="{$output-var-clear-value}"/>
	 				</mib>
	 			</xsl:when>
	 			<xsl:otherwise>
	 				<mib>
	 					<set name="{$output-var}" value="{$output-var-value}"/>
	 				</mib>
	 			</xsl:otherwise>
	 		</xsl:choose>
 		</xsl:if>
 	</xsl:template>


<!-- ############################################################################################################################### -->
    
    <!-- Notification from MIB variables -->
    
	<xsl:template name="make.notification" >
	    <xsl:param name="idx" /> 
	    <xsl:param name="module-type" />
	    <xsl:param name="add.subject" />
	    <xsl:param name="output-var" />
		<xsl:param name="output-var-value" />
		<xsl:param name="output-var-clear-value" />  
		<xsl:param name="sql.disable" />
		<xsl:param name="trap.disable" />
		<xsl:param name="email.enable" />
		<xsl:param name="sms.enable" />
		<xsl:param name="backup.enable" />
		<xsl:param name="alarmlamp.enable" />
		
	    <xsl:variable name="notification.def" select="$context/notification-def/language" />
	    <xsl:variable name="notify" select="$notification.def/notification[@id=$idx]" />
	    <xsl:choose>
	        <xsl:when test="boolean($notify)">
			
				<xsl:variable name="traptext">
					<xsl:choose>
						<xsl:when test="string-length($notify/@traptext) &gt; 0">
							<xsl:value-of select="$notify/@traptext"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$notify/@text"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
	            
	            <xsl:variable name="subject" select="concat($notify/@subject,$add.subject)"/>
	
				<!-- MIB Variable -->
				<xsl:call-template name="signalMibVar" >
					<xsl:with-param name="output-var" select="$output-var" />
					<xsl:with-param name="output-var-value" select="$output-var-value" />
					<xsl:with-param name="output-var-clear-value" select="$output-var-clear-value" />
					<xsl:with-param name="pending" select="$notify/@pending" />
				</xsl:call-template>
				
				<xsl:if test="$notify/@mib='true'" >
					<xsl:variable name="mvn" select="concat('notify.',$notify/@alarm.id)"/>
					<mib>
						<set name="{$mvn}" value="{$notify/@severity}" />
					</mib>
				</xsl:if>
	            
				<!-- Context Variable -->
				<xsl:variable name="cn" select="concat('severity.', $notify/@alarm.id)" ></xsl:variable>
				<xsl:if test="number($notify/@alarm.id) &gt; 0">
					<context>
						<xsl:element name="{$cn}" >
							<xsl:attribute name="type"><xsl:value-of select="'severity'"/></xsl:attribute>
							<xsl:attribute name="id"><xsl:value-of select="$notify/@alarm.id"/></xsl:attribute>
							<xsl:attribute name="severity"><xsl:value-of select="$notify/@severity"/></xsl:attribute>
							<xsl:attribute name="behaviour"><xsl:value-of select="$notify/@behaviour"/></xsl:attribute>
							<xsl:attribute name="pending"><xsl:value-of select="$notify/@pending"/></xsl:attribute>
						</xsl:element>
					</context>
				</xsl:if>
	           
	            <!-- MySQL Messages -->
	            <xsl:if test="($context/@msg.sql.enable='true' or $conf/@msg.sql.enable='true') and $conf/@msg.sql.enable!='false'">
		            <msg>
			            <sqlmessages xmlns="http://euromedia-service.de/coyoNET/sqlgateway/">
			                <sqlmessage  server-id="{$context/@server.id}" 
			                             engine="{$context/@notificationEngine}" 
			                             engine-type="{$module-type}" 
			                             alarm-id="{$notify/@alarm.id}" 
			                             severity="{$notify/@severity}" 
			                             behaviour="{$notify/@behaviour}" 
			                             pending="{$notify/@pending}" 
			                             text="{$notify/@text}" 
			                             subject="{$subject}"
			                             alarm-engine="{$engineID}"
										 detail="{$traptext}" 
										 ipaddress="{$context/@ipaddress}"
										 />
			            </sqlmessages>
		            </msg>           
	            </xsl:if>
			    
			    <!-- coyoNet Northbound Messages -->
			    <xsl:if test="($context/@msg.snmp.enable='true' or $context/@msg.snmp_cus.enable='true' or $conf/@msg.snmp.enable='true') and (not ($trap.disable = 'true' or  $trap.disable = '1') and $conf/@msg.snmp.enable!='false')">
				    <msg>
		                <coyonet-trap   xmlns="http://euromedia-service.de/coyoNET/northbound/"
		                				server-id="{$context/@server.id}" 
		                                engine="{$context/@notificationEngine}" 
		                                engine-type="{$module-type}" 
		                                alarm-id="{$notify/@alarm.id}" 
		                                severity="{$notify/@severity}" 
		                                behaviour="{$notify/@behaviour}" 
		                                pending="{$notify/@pending}" 
		                                text="{$traptext}" 
		                                subject="{$subject}"
		                                time="{concat($dyn/@isodate,' ',$dyn/@isotime)}"
                                        alarm-engine="{$engineID}"
                                        ipaddress="{$context/@ipaddress}" 
                         />
		            </msg>
				</xsl:if>	            
			   
			    <!-- SEND Email -->
			    <xsl:if test="($context/@msg.email.enable='true' or $conf/@msg.email.enable='true') and ($email.enable = 'true' or $email.enable = '1') and $conf/@msg.email.enable!='false'" >
				    <msg>
		                <email xmlns="http://euromedia-service.de/coyoNET/emailgateway/" 
		                				server-id="{$context/@server.id}" 
		                                engine="{$context/@notificationEngine}" 
		                                engine-type="{$module-type}" 
		                                alarm-id="{$notify/@alarm.id}" 
		                                severity="{$notify/@severity}" 
		                                behaviour="{$notify/@behaviour}" 
		                                pending="{$notify/@pending}" 
		                                text="{$traptext}" 
		                                subject="{$subject}"
		                                time="{concat($dyn/@isodate,' ',$dyn/@isotime)}"
                                        alarm-engine="{$engineID}" 
                                        ipaddress="{$context/@ipaddress}"
                          />
		            </msg>
				</xsl:if>
			    
			    <!-- SEND SMS -->
			    <xsl:if test="($context/@msg.sms.enable='true' or $conf/@msg.sms.enable='true') and ($sms.enable = 'true' or $sms.enable = '1') and $conf/@msg.sms.enable!='false'">
				    <msg>
		                <sms xmlns="http://euromedia-service.de/coyoNET/smsgateway/" 
		                				server-id="{$context/@server.id}" 
		                                engine="{$context/@notificationEngine}" 
		                                engine-type="{$module-type}" 
		                                alarm-id="{$notify/@alarm.id}" 
		                                severity="{$notify/@severity}" 
		                                behaviour="{$notify/@behaviour}" 
		                                pending="{$notify/@pending}" 
		                                text="{$traptext}" 
		                                subject="{$subject}"
		                                time="{concat($dyn/@isodate,' ',$dyn/@isotime)}"
                                        alarm-engine="{$engineID}" 
                                        ipaddress="{$context/@ipaddress}"
		                                 />
		            </msg>
				</xsl:if>					            

				<!-- ACTIVATE ALARMLAMP -->
				<xsl:if test="($context/@msg.alarmlamp.enable='true' or $context/@msg.alarmlamp.enable='1' or $conf/@msg.alarmlamp.enable='true') and ($alarmlamp.enable = 'true' or $alarmlamp.enable = '1') and $conf/@msg.alarmlamp.enable!='false'">
				    <msg>
		                <alarmlamp   xmlns="http://euromedia-service.de/coyoNET/alarmlamp/"

		                				server-id="{$context/@server.id}" 
		                                engine="{$context/@notificationEngine}" 
		                                engine-type="{$module-type}" 
		                                alarm-id="{$notify/@alarm.id}" 
		                                severity="{$notify/@severity}" 
		                                behaviour="{$notify/@behaviour}" 
		                                pending="{$notify/@pending}" 
		                                text="{$traptext}" 


		                                subject="{$subject}"
		                                time="{concat($dyn/@isodate,' ',$dyn/@isotime)}"
                                        alarm-engine="{$context/@alarmLampID}"
                                        ipaddress="{$context/@ipaddress}" 
                         />
		            </msg>
				</xsl:if>				
				
			    <!-- SEND BACKUP COMMAND -->
			    <xsl:if test="($context/@msg.backup.enable='true' or $conf/@msg.backup.enable='true') and ($backup.enable = 'true' or $backup.enable = '1') and $conf/@msg.backup.enable!='false'">
				    <msg>
						<backup xmlns="http://euromedia-service.de/coyoNET/backup/" 
										engineID="{$notify/@notificationEngine}" 
										buinfo1="{$notify/@text}" 
										buinfo2="{$subject}" 
										buinfo3="NULL" 
										buinfo4="NULL" 
										service="0"
										severity="{$notify/@severity}"
										mode="{$notify/@backup.auto}"
										type="{$notify/@backup.type}"
										ipaddress="{$context/@ipaddress}"
                                 />
		            </msg>
				</xsl:if>			    
	        </xsl:when>
	        <xsl:otherwise>
	            <msg>
	                <error cause="Notification language not found" engine="{$context/@notificationEngine}" module.id="{$module.number}" 
	                       module.name="{$module.name}" xmlns="http://euromedia-service.de/coyoNET/" />
	            </msg>
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>
	
	

	
<!-- ############################################################################################################################### -->
	
	<!-- Notification from Traps -->
	
	<xsl:template name="make.trap.notification" >
	    <xsl:param name="engine" />
	    <xsl:param name="engine-type" />
        <xsl:param name="alarm-id" />
        <xsl:param name="severity" />
        <xsl:param name="behaviour" />
        <xsl:param name="pending" />
        <xsl:param name="text" />
		<xsl:param name="traptext" />
		<xsl:param name="slatext" />
        <xsl:param name="subject" />
        <xsl:param name="mib" />
		<xsl:param name="buinfo1" />
		<xsl:param name="buinfo2" />
		<xsl:param name="buinfo3" />
		<xsl:param name="buinfo4" />
		<xsl:param name="service" />
		<xsl:param name="sql.disable" />
		<xsl:param name="trap.disable" />
		<xsl:param name="email.enable" />
		<xsl:param name="sms.enable" />        
		<xsl:param name="backup.enable" />
		<xsl:param name="backup.auto" />
		<xsl:param name="backup.type" />
		<xsl:param name="alarmlamp.enable" />
        
        <xsl:if test="$mib='true'" >
            <xsl:variable name="mvn" select="concat('trap.',$alarm-id)"/>
            <mib>
                <set name="{$mvn}" value="{$severity}" />
            </mib>
        </xsl:if>
		
		<xsl:variable name="traptextout">
			<xsl:choose>
				<xsl:when test="string-length($traptext) &gt; 0">
					<xsl:value-of select="$traptext"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$text"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
        
		<!-- Context Variable -->
		<xsl:variable name="cn" select="concat('severity.', $alarm-id)" />
		<xsl:if test="number($alarm-id) &gt; 0">
			<context>
				<xsl:element name="{$cn}" >
					<xsl:attribute name="type"><xsl:value-of select="'severity'"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="$alarm-id"/></xsl:attribute>
					<xsl:attribute name="severity"><xsl:value-of select="$severity"/></xsl:attribute>
					<xsl:attribute name="behaviour"><xsl:value-of select="$behaviour"/></xsl:attribute>
					<xsl:attribute name="pending"><xsl:value-of select="$pending"/></xsl:attribute>
				</xsl:element>
			</context>
		</xsl:if>
	    <!-- MySQL Messages -->
	    <xsl:if test="$context/@msg.sql.enable='true' and (not(boolean($sql.disable)) or ($sql.disable != 'true' and $sql.disable != '1'))">
		   <msg>
	            <sqlmessages xmlns="http://euromedia-service.de/coyoNET/sqlgateway/">
	                <sqlmessage  server-id="{$context/@server.id}" 
	                             engine="{$context/@notificationEngine}" 
	                             engine-type="{$engine-type}" 
	                             alarm-id="{$alarm-id}" 
	                             severity="{$severity}" 
	                             behaviour="{$behaviour}" 
	                             pending="{$pending}" 
	                             text="{$text}" 
	                             subject="{$subject}"
	                             alarm-engine="{$engineID}"
								 detail="{$slatext}" />
	            </sqlmessages>
		    </msg>
	    </xsl:if>

	    <!-- coyoNet Northbound Messages -->
	    <xsl:if test="($context/@msg.snmp.enable='true' or $context/@msg.snmp_cus.enable='true' or $conf/@msg.snmp.enable='true') and (not ($trap.disable = 'true' or  $trap.disable = '1'))">
		    <msg>
		        <coyonet-trap   xmlns="http://euromedia-service.de/coyoNET/northbound/"
		        				server-id="{$context/@server.id}" 
		                        engine="{$context/@notificationEngine}" 
		                        engine-type="{$engine-type}" 
		                        alarm-id="{$alarm-id}" 
		                        severity="{$severity}" 
		                        behaviour="{$behaviour}" 
		                        pending="{$pending}" 
		                        text="{$traptextout}" 
		                        subject="{$subject}"
		                        time="{concat($dyn/@isodate,' ',$dyn/@isotime)}"
                                alarm-engine="{$engineID}"
								detail="{$slatext}"
		                         />
		    </msg>
	    </xsl:if>

	    <!-- SEND Email -->
	    <xsl:if test="$context/@msg.email.enable='true' and ($email.enable = 'true' or $email.enable = '1')">
		    <msg>
                <email xmlns="http://euromedia-service.de/coyoNET/emailgateway/" 
		        				server-id="{$context/@server.id}" 
		                        engine="{$engine}" 
		                        engine-type="{$engine-type}" 
		                        alarm-id="{$alarm-id}" 
		                        severity="{$severity}" 
		                        behaviour="{$behaviour}" 
		                        pending="{$pending}" 
		                        text="{$traptextout}" 
		                        subject="{$subject}"
		                        time="{concat($dyn/@isodate,' ',$dyn/@isotime)}" 
                                alarm-engine="{$engineID}"
                                 />
            </msg>
		</xsl:if>
			    
	    <!-- SEND SMS -->
	    <xsl:if test="$context/@msg.sms.enable='true' and ($sms.enable = 'true' or $sms.enable = '1')">
		    <msg>
                <sms xmlns="http://euromedia-service.de/coyoNET/smsgateway/" 
		        				server-id="{$context/@server.id}" 
		                        engine="{$context/@notificationEngine}" 
		                        engine-type="{$engine-type}" 
		                        alarm-id="{$alarm-id}" 
		                        severity="{$severity}" 
		                        behaviour="{$behaviour}" 
		                        pending="{$pending}" 
		                        text="{$traptextout}" 
		                        subject="{$subject}"
		                        time="{concat($dyn/@isodate,' ',$dyn/@isotime)}" 
                                alarm-engine="{$engineID}"
                                 />
            </msg>
		</xsl:if>	    

		<!-- ACTIVATE ALARMLAMP -->
		<xsl:if test="($context/@msg.alarmlamp.enable='true' or $context/@msg.alarmlamp.enable='1') and ($alarmlamp.enable = 'true' or $alarmlamp.enable = '1')">
		    <msg>
                <alarmlamp  
							xmlns="http://euromedia-service.de/coyoNET/alarmlamp/"
	        				server-id="{$context/@server.id}" 
	                        engine="{$context/@notificationEngine}" 
	                        engine-type="{$engine-type}" 
	                        alarm-id="{$alarm-id}" 
	                        severity="{$severity}" 
	                        behaviour="{$behaviour}" 
	                        pending="{$pending}" 
	                        text="{$traptextout}" 
	                        subject="{$subject}"
	                        time="{concat($dyn/@isodate,' ',$dyn/@isotime)}" 
                            alarm-engine="{$context/@alarmLampID}"
                     />
            </msg>
		</xsl:if>	

	    <!-- SEND BACKUP COMMAND -->
	    <xsl:if test="$context/@msg.backup.enable='true' and ($backup.enable = 'true' or $backup.enable = '1')">
		    <msg>
                <backup xmlns="http://euromedia-service.de/coyoNET/backup/" 
								engineID="{$engine}"
		        				buinfo1="{$buinfo1}"
		                        buinfo2="{$buinfo2}" 
		                        buinfo3="{$buinfo3}" 
								buinfo4="{$buinfo4}" 
		                        service="{$service}"
								severity="{$severity}"
								mode="{$backup.auto}"
								type="{$backup.type}"
                                 />
            </msg>
		</xsl:if>		
	</xsl:template>

	<xsl:template match="/http-response[@id='send.sql.message']" >
	    <xsl:if test="$enable.debug=1" >
	        <xsl:choose>
	            <xsl:when test="content/response='OK'">
	<!--                <debug>SQL message-log successful</debug>-->
	            </xsl:when>
	            <xsl:otherwise>
	                <debug>SQL message-log caused an error</debug>
	<!--                <dump><xsl:copy-of select="." /></dump>-->
	            </xsl:otherwise>
	        </xsl:choose>
	    </xsl:if>
	</xsl:template>



	<xsl:template name="sql.reset.alarmengine.messages" >
	
		<msg>
            <sqlmessages xmlns="http://euromedia-service.de/coyoNET/sqlgateway/">
                <sql.reset.alarmengine.messages server-id="{$context/@server.id}" alarm-engine="{$engineID}" />
            </sqlmessages>
        </msg> 	
		
	</xsl:template> 


</xsl:stylesheet>
