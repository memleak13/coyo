<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
 	<xsl:template name="trapHandler.init">
 	    <subscribe>
	        <msg uri="http://euromedia-service.de/coyoNET/internalTrap/" name="internal-trap.{$engineID}" />
	        <xsl:if test="not($engineID = $conf/@notification.engine)" >
	            <msg uri="http://euromedia-service.de/coyoNET/internalTrap/" name="internal-trap.{$conf/@notification.engine}" />
            </xsl:if> 
	    </subscribe>
 	</xsl:template>
    

<!-- ############################################################################################################################### -->
    
    <!-- Receive internal trap -->
    <xsl:template match="/int:*" xmlns:int="http://euromedia-service.de/coyoNET/internalTrap/" >
        <xsl:if test="contains(name(),'internal-trap.')" >
		
			<xsl:variable name="notification.filter" select="$context/notification-filter" />
		
            <xsl:variable name="new.debounce">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'debounce'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@debounce"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="debounce">
                <xsl:choose>
                    <xsl:when test="string-length($new.debounce) &gt; 0">
						<xsl:value-of select="$new.debounce"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@debounce"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>				

            <xsl:variable name="new.clear-debounce">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'clear-debounce'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>                            
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@clear-debounce"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="clear-debounce">
                <xsl:choose>
                    <xsl:when test="string-length($new.clear-debounce) &gt; 0">
						<xsl:value-of select="$new.clear-debounce"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@clear-debounce"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>				
            
             <xsl:variable name="new.sql.disable">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'sql.disable'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>                            
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@sql.disable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="sql.disable">
                <xsl:choose>
                    <xsl:when test="string-length($new.sql.disable) &gt; 0">
						<xsl:value-of select="$new.sql.disable"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@sql.disable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>				
            
            <xsl:variable name="new.trap.disable">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'trap.disable'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>                            
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@trap.disable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="trap.disable">
                <xsl:choose>
                    <xsl:when test="string-length($new.trap.disable) &gt; 0">
						<xsl:value-of select="$new.trap.disable"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@trap.disable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>			
 
            <xsl:variable name="new.email.enable">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'email.enable'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>                           
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@email.enable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="email.enable">
                <xsl:choose>
                    <xsl:when test="string-length($new.email.enable) &gt; 0">
						<xsl:value-of select="$new.email.enable"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@email.enable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>			
        
            <xsl:variable name="new.sms.enable">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'sms.enable'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>                            
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@sms.enable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="sms.enable">
                <xsl:choose>
                    <xsl:when test="string-length($new.sms.enable) &gt; 0">
						<xsl:value-of select="$new.sms.enable"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@sms.enable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>			

            <xsl:variable name="new.backup.enable">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'backup.enable'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@backup.enable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="backup.enable">
                <xsl:choose>
                    <xsl:when test="string-length($new.backup.enable) &gt; 0">
						<xsl:value-of select="$new.backup.enable"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@backup.enable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="new.backup.auto">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'backup.auto'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@backup.auto"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="backup.auto">
                <xsl:choose>
                    <xsl:when test="string-length($new.backup.auto) &gt; 0">
						<xsl:value-of select="$new.backup.auto"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@backup.auto"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="new.backup.type">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'backup.type'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@backup.type"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="backup.type">
                <xsl:choose>
                    <xsl:when test="string-length($new.backup.type) &gt; 0">
						<xsl:value-of select="$new.backup.type"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@backup.type"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>			
			
            <xsl:variable name="new.alarmlamp.enable">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                       <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'alarmlamp.enable'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@alarmlamp.enable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="alarmlamp.enable">
                <xsl:choose>
                    <xsl:when test="string-length($new.alarmlamp.enable) &gt; 0">
						<xsl:value-of select="$new.alarmlamp.enable"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@alarmlamp.enable"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="new.severity">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                        <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'severity'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@severity"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="severity">
                <xsl:choose>
                    <xsl:when test="$new.severity = '*'">
						<xsl:value-of select="@severity"/>
					</xsl:when>				
                    <xsl:when test="string-length($new.severity) &gt; 0">
						<xsl:value-of select="$new.severity"/>
					</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@severity"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="new.text">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                        <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'alarmtext'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@text"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="messagetext">
                <xsl:choose>
                    <xsl:when test="string-length($new.text) &gt; 0">
						<xsl:value-of select="$new.text"/>
					</xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@text"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="new.traptext">
                <xsl:choose>
                   <xsl:when test=" boolean ( $notification.filter/traps ) ">
                        <xsl:call-template name="getAttribute">
                            <xsl:with-param name="attrName"><xsl:value-of select="'traptext'"/></xsl:with-param>
                            <xsl:with-param name="attrText"><xsl:value-of select="@text"/></xsl:with-param>
                            <xsl:with-param name="attrSubject"><xsl:value-of select="@subject"/></xsl:with-param>
                            <xsl:with-param name="attrSeverity"><xsl:value-of select="@severity"/></xsl:with-param>
							<xsl:with-param name="attrEngineID"><xsl:value-of select="@engine"/></xsl:with-param>
                            <xsl:with-param name="attrBuInfo1" select="@buinfo1"/>
                            <xsl:with-param name="attrBuInfo2" select="@buinfo2"/>
                            <xsl:with-param name="attrBuInfo3" select="@buinfo3"/>
							<xsl:with-param name="attrBuInfo4" select="@buinfo4"/>
                            <xsl:with-param name="attrService" select="@service"/>
                        </xsl:call-template>
                    </xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@traptext"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="traptext">
                <xsl:choose>
                    <xsl:when test="string-length($new.traptext) &gt; 0">
						<xsl:value-of select="$new.traptext"/>
					</xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@text"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="buinfo2">
                <xsl:choose>
                    <xsl:when test="string-length(@buinfo2) &gt; 0 and @buinfo2 != 'NULL'">
						<xsl:value-of select="@buinfo2"/>
					</xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@text"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>	

            <xsl:variable name="buinfo3">
                <xsl:choose>
                    <xsl:when test="string-length(@buinfo3) &gt; 0 and @buinfo3 != 'NULL'">
						<xsl:value-of select="@buinfo3"/>
					</xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@subject"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
            <xsl:variable name="pending">
                <xsl:choose>
                    <xsl:when test="$severity &gt; 4">
						<xsl:value-of select="0"/>
					</xsl:when>            
                    <xsl:otherwise>
                        <xsl:value-of select="@pending"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
			
	        <xsl:call-template name="trapHandler.processTrap" >
		        <xsl:with-param name="engine" ><xsl:value-of select="@engine" /></xsl:with-param>
		        <xsl:with-param name="engine-type" ><xsl:value-of select="@engine-type" /></xsl:with-param>
		        <xsl:with-param name="alarm.id" ><xsl:value-of select="@alarm.id" /></xsl:with-param>
		        <xsl:with-param name="debounce" ><xsl:value-of select="$debounce" /></xsl:with-param>
		        <xsl:with-param name="clear-debounce" ><xsl:value-of select="$clear-debounce" /></xsl:with-param>
		        <xsl:with-param name="mib" ><xsl:value-of select="@mib" /></xsl:with-param>
		        <xsl:with-param name="severity" ><xsl:value-of select="$severity" /></xsl:with-param>
		        <xsl:with-param name="behaviour" ><xsl:value-of select="@behaviour" /></xsl:with-param>
		        <xsl:with-param name="pending" ><xsl:value-of select="$pending" /></xsl:with-param>
		        <xsl:with-param name="text" ><xsl:value-of select="$messagetext" /></xsl:with-param>
				<xsl:with-param name="traptext" ><xsl:value-of select="$traptext" /></xsl:with-param>
				<xsl:with-param name="slatext" ><xsl:value-of select="@slatext" /></xsl:with-param>
		        <xsl:with-param name="subject" ><xsl:value-of select="@subject" /></xsl:with-param>
                <xsl:with-param name="buinfo1" select="@buinfo1"/>
                <xsl:with-param name="buinfo2" select="$buinfo2"/>
                <xsl:with-param name="buinfo3" select="$buinfo3"/>
				<xsl:with-param name="buinfo4" select="@buinfo4"/>
                <xsl:with-param name="service" select="@service"/>		
				<xsl:with-param name="sql.disable" select="$sql.disable"/>
				<xsl:with-param name="trap.disable" select="$trap.disable"/>
				<xsl:with-param name="email.enable" select="$email.enable"/>
				<xsl:with-param name="sms.enable" select="$sms.enable"/>
				<xsl:with-param name="backup.enable" select="$backup.enable"/>
				<xsl:with-param name="backup.auto" select="$backup.auto"/>
				<xsl:with-param name="backup.type" select="$backup.type"/>
				<xsl:with-param name="alarmlamp.enable" select="$alarmlamp.enable"/>
		    </xsl:call-template>
	    </xsl:if>
	</xsl:template>
    

<!-- ############################################################################################################################### -->
    
    <!-- Trap processor -->
        
    <xsl:template name="trapHandler.processTrap" >
        <xsl:param name="engine" />
        <xsl:param name="engine-type" />
        <xsl:param name="alarm.id" />
        <xsl:param name="debounce" />
        <xsl:param name="clear-debounce" />
        <xsl:param name="mib" />
        <xsl:param name="severity" />
        <xsl:param name="behaviour" />
        <xsl:param name="pending" />
        <xsl:param name="text" />
		<xsl:param name="traptext" />
		<xsl:param name="slatext" />
        <xsl:param name="subject" />
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
        
        <xsl:variable name="entryName" ><xsl:value-of select="concat('trap.',$engine,'.',$alarm.id)" /></xsl:variable>
        
        <xsl:variable name="currentPending" >
            <xsl:choose>
                <xsl:when test="string-length($context/*[name() = $entryName ]/@pending)" ><xsl:value-of select="$context/*[name() = $entryName ]/@pending" /></xsl:when>
                <xsl:otherwise><xsl:value-of select="2" /></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        
        <xsl:variable name="trapType" >
	        <xsl:choose>
	            <xsl:when test="$behaviour=3 and $pending=1" ><xsl:value-of select="'alarm.clearedBySystem'" /></xsl:when>
	            <xsl:when test="$behaviour=3 and $pending=0" ><xsl:value-of select="'clear.clearedBySystem'" /></xsl:when>
	            <xsl:otherwise><xsl:value-of select="'not.clearedBySystem'" /></xsl:otherwise>
	        </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="newCounter" >
	        <xsl:choose>
	            <xsl:when test="$trapType='alarm.clearedBySystem'" >
	                <!-- Alarm Trap -->
	                <xsl:choose>
	                    <xsl:when test="$debounce &gt; 0" >
	                        <!-- Store trap in context with counter value equal to debounce -->
	                        <xsl:value-of select="$debounce" />
	                    </xsl:when>
	                    <xsl:otherwise>
	                        <!-- Make Message and store trap in context with counter value zero -->
	                        <xsl:value-of select="0" />
	                    </xsl:otherwise>
	                </xsl:choose>
	            </xsl:when>
	            <xsl:when test="$trapType='clear.clearedBySystem'" >
	                <!-- Clear Trap -->
	                <xsl:choose>
	                    <xsl:when test="$clear-debounce &gt; 0" >
	                        <!-- Store trap in context with counter value equal to clear-debounce -->
	                        <xsl:value-of select="$clear-debounce" />
	                    </xsl:when>
	                    <xsl:otherwise>
	                        <!-- Make Message and store trap in context with counter value zero -->
	                        <xsl:value-of select="0" />
	                    </xsl:otherwise>
	                </xsl:choose>
	            </xsl:when>
	            <xsl:otherwise>
	                <!-- any other kind of Trap -->
	                <xsl:choose>
	                    <xsl:when test="$debounce &gt; 0" >
	                        <!-- Store trap in context with counter value more than zero -->
	                        <xsl:value-of select="$debounce" />
	                    </xsl:when>
	                    <xsl:otherwise>
	                        <!-- Make Message and store trap in context with counter value zero -->
	                        <xsl:value-of select="0" />
	                    </xsl:otherwise>
	                </xsl:choose>
	            </xsl:otherwise>
	        </xsl:choose>
        </xsl:variable>
        
        <!-- Only work with traps which are not found in equal way in the context -->
        <xsl:if test="not($currentPending=$pending and $behaviour=3)">
        	
	        <xsl:call-template name="trapHandler.storeTrapInContext" >
	            <xsl:with-param name="engine" ><xsl:value-of select="$engine" /></xsl:with-param>
	            <xsl:with-param name="engine-type" ><xsl:value-of select="$engine-type" /></xsl:with-param>
	            <xsl:with-param name="alarm.id" ><xsl:value-of select="$alarm.id" /></xsl:with-param>
	            <xsl:with-param name="debounce" ><xsl:value-of select="$debounce" /></xsl:with-param>
	            <xsl:with-param name="clear-debounce" ><xsl:value-of select="$clear-debounce" /></xsl:with-param>
	            <xsl:with-param name="mib" ><xsl:value-of select="$mib" /></xsl:with-param>
	            <xsl:with-param name="severity" ><xsl:value-of select="$severity" /></xsl:with-param>
	            <xsl:with-param name="behaviour" ><xsl:value-of select="$behaviour" /></xsl:with-param>
	            <xsl:with-param name="pending" ><xsl:value-of select="$pending" /></xsl:with-param>
	            <xsl:with-param name="text" ><xsl:value-of select="$text" /></xsl:with-param>
				<xsl:with-param name="traptext" ><xsl:value-of select="$traptext" /></xsl:with-param>
				<xsl:with-param name="slatext" ><xsl:value-of select="$slatext" /></xsl:with-param>
	            <xsl:with-param name="subject" ><xsl:value-of select="$subject" /></xsl:with-param>
	            <xsl:with-param name="counter" ><xsl:value-of select="$newCounter" /></xsl:with-param>
                <xsl:with-param name="buinfo1" ><xsl:value-of select="$buinfo1" /></xsl:with-param>
                <xsl:with-param name="buinfo2" ><xsl:value-of select="$buinfo2" /></xsl:with-param>
                <xsl:with-param name="buinfo3" ><xsl:value-of select="$buinfo3" /></xsl:with-param>
				<xsl:with-param name="buinfo4" ><xsl:value-of select="$buinfo4" /></xsl:with-param>
                <xsl:with-param name="service" ><xsl:value-of select="$service" /></xsl:with-param>
				<xsl:with-param name="sql.disable" select="$sql.disable"/>
				<xsl:with-param name="trap.disable" select="$trap.disable"/>
				<xsl:with-param name="email.enable" select="$email.enable"/>
				<xsl:with-param name="sms.enable" select="$sms.enable"/>
				<xsl:with-param name="backup.enable" select="$backup.enable"/>
				<xsl:with-param name="backup.auto" select="$backup.auto"/>
				<xsl:with-param name="backup.type" select="$backup.type"/>
				<xsl:with-param name="alarmlamp.enable" select="$alarmlamp.enable"/>
	        </xsl:call-template>
	        
	        <!-- make message if no debounce time is used -->
            <xsl:if test="$newCounter=0" >
            	<context datachange="1" />
            
                <xsl:call-template name="make.trap.notification" >
					<xsl:with-param name="engine" ><xsl:value-of select="$engine" /></xsl:with-param>
					<xsl:with-param name="engine-type" ><xsl:value-of select="$engine-type" /></xsl:with-param>
					<xsl:with-param name="alarm-id" ><xsl:value-of select="$alarm.id" /></xsl:with-param>
					<xsl:with-param name="severity" ><xsl:value-of select="$severity" /></xsl:with-param>
					<xsl:with-param name="behaviour" ><xsl:value-of select="$behaviour" /></xsl:with-param>
					<xsl:with-param name="pending" ><xsl:value-of select="$pending" /></xsl:with-param>
					<xsl:with-param name="text" ><xsl:value-of select="$text" /></xsl:with-param>
					<xsl:with-param name="traptext" ><xsl:value-of select="$traptext" /></xsl:with-param>
					<xsl:with-param name="slatext" ><xsl:value-of select="$slatext" /></xsl:with-param>
					<xsl:with-param name="subject" ><xsl:value-of select="$subject" /></xsl:with-param>
					<xsl:with-param name="mib" ><xsl:value-of select="$mib" /></xsl:with-param>
					<xsl:with-param name="buinfo1" ><xsl:value-of select="$buinfo1" /></xsl:with-param>
					<xsl:with-param name="buinfo2" ><xsl:value-of select="$buinfo2" /></xsl:with-param>
					<xsl:with-param name="buinfo3" ><xsl:value-of select="$buinfo3" /></xsl:with-param>
					<xsl:with-param name="buinfo4" ><xsl:value-of select="$buinfo4" /></xsl:with-param>
					<xsl:with-param name="service" ><xsl:value-of select="$service" /></xsl:with-param>					
					<xsl:with-param name="sql.disable" select="$sql.disable"/>
					<xsl:with-param name="trap.disable" select="$trap.disable"/>
					<xsl:with-param name="email.enable" select="$email.enable"/>
					<xsl:with-param name="sms.enable" select="$sms.enable"/>
					<xsl:with-param name="backup.enable" select="$backup.enable"/>
					<xsl:with-param name="backup.auto" select="$backup.auto"/>
					<xsl:with-param name="backup.type" select="$backup.type"/>
					<xsl:with-param name="alarmlamp.enable" select="$alarmlamp.enable"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
        
    </xsl:template>
    
    
    <xsl:template name="trapHandler.storeTrapInContext" >
        <xsl:param name="engine" />
        <xsl:param name="engine-type" />
        <xsl:param name="alarm.id" />
        <xsl:param name="debounce" />
        <xsl:param name="clear-debounce" />
        <xsl:param name="mib" />
        <xsl:param name="severity" />
        <xsl:param name="behaviour" />
        <xsl:param name="pending" />
        <xsl:param name="text" />
		<xsl:param name="traptext" />
		<xsl:param name="slatext" />
        <xsl:param name="subject" />
        <xsl:param name="counter" />
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
        
        <context>
            <xsl:variable name="el" select="concat('trap.',$engine,'.',$alarm.id)" />
            <xsl:element name="{$el}" >
                <xsl:attribute name="engine" ><xsl:value-of select="$engine" /></xsl:attribute>
                <xsl:attribute name="engine-type" ><xsl:value-of select="$engine-type" /></xsl:attribute>
                <xsl:attribute name="alarm.id" ><xsl:value-of select="$alarm.id" /></xsl:attribute>
                <xsl:attribute name="debounce" ><xsl:value-of select="$debounce" /></xsl:attribute>
                <xsl:attribute name="clear-debounce" ><xsl:value-of select="$clear-debounce" /></xsl:attribute>
                <xsl:attribute name="mib" ><xsl:value-of select="$mib" /></xsl:attribute>
                <xsl:attribute name="severity" ><xsl:value-of select="$severity" /></xsl:attribute>
                <xsl:attribute name="behaviour" ><xsl:value-of select="$behaviour" /></xsl:attribute>
                <xsl:attribute name="pending" ><xsl:value-of select="$pending" /></xsl:attribute>
                <xsl:attribute name="text" ><xsl:value-of select="$text" /></xsl:attribute>
				<xsl:attribute name="traptext" ><xsl:value-of select="$traptext" /></xsl:attribute>
				<xsl:attribute name="slatext" ><xsl:value-of select="$slatext" /></xsl:attribute>
                <xsl:attribute name="subject" ><xsl:value-of select="$subject" /></xsl:attribute>
                <xsl:attribute name="counter" ><xsl:value-of select="$counter" /></xsl:attribute>
				<xsl:attribute name="buinfo1" ><xsl:value-of select="$buinfo1" /></xsl:attribute>
				<xsl:attribute name="buinfo2" ><xsl:value-of select="$buinfo2" /></xsl:attribute>
				<xsl:attribute name="buinfo3" ><xsl:value-of select="$buinfo3" /></xsl:attribute>
				<xsl:attribute name="buinfo4" ><xsl:value-of select="$buinfo4" /></xsl:attribute>
				<xsl:attribute name="service" ><xsl:value-of select="$service" /></xsl:attribute>
                <xsl:attribute name="type" ><xsl:value-of select="'severity'" /></xsl:attribute>
				<xsl:attribute name="sql.disable"><xsl:value-of select="$sql.disable" /></xsl:attribute> 
				<xsl:attribute name="trap.disable"><xsl:value-of select="$trap.disable" /></xsl:attribute> 
				<xsl:attribute name="email.enable"><xsl:value-of select="$email.enable" /></xsl:attribute> 
				<xsl:attribute name="sms.enable"><xsl:value-of select="$sms.enable" /></xsl:attribute>
				<xsl:attribute name="backup.enable"><xsl:value-of select="$backup.enable" /></xsl:attribute>
				<xsl:attribute name="backup.auto"><xsl:value-of select="$backup.auto" /></xsl:attribute>
				<xsl:attribute name="backup.type"><xsl:value-of select="$backup.type" /></xsl:attribute>
				<xsl:attribute name="alarmlamp.enable"><xsl:value-of select="$alarmlamp.enable" /></xsl:attribute>
            </xsl:element>
        </context>
    </xsl:template>


	
<!-- ############################################################################################################################### -->
    
    <!-- Context Update -->
	
	<xsl:template name="trapHandler.updateAlarmContext">
        <xsl:param name="currentContext" />
        <xsl:param name="newCounter" />
        
        <xsl:call-template name="trapHandler.storeTrapInContext" >
            <xsl:with-param name="engine" ><xsl:value-of select="$currentContext/@engine" /></xsl:with-param>
            <xsl:with-param name="engine-type" ><xsl:value-of select="$currentContext/@engine-type" /></xsl:with-param>
            <xsl:with-param name="alarm.id" ><xsl:value-of select="$currentContext/@alarm.id" /></xsl:with-param>
            <xsl:with-param name="debounce" ><xsl:value-of select="$currentContext/@debounce" /></xsl:with-param>
            <xsl:with-param name="clear-debounce" ><xsl:value-of select="$currentContext/@clear-debounce" /></xsl:with-param>
            <xsl:with-param name="mib" ><xsl:value-of select="$currentContext/@mib" /></xsl:with-param>
            <xsl:with-param name="severity" ><xsl:value-of select="$currentContext/@severity" /></xsl:with-param>
            <xsl:with-param name="behaviour" ><xsl:value-of select="$currentContext/@behaviour" /></xsl:with-param>
            <xsl:with-param name="pending" ><xsl:value-of select="$currentContext/@pending" /></xsl:with-param>
            <xsl:with-param name="text" ><xsl:value-of select="$currentContext/@text" /></xsl:with-param>
			<xsl:with-param name="traptext" ><xsl:value-of select="$currentContext/@traptext" /></xsl:with-param>
			<xsl:with-param name="slatext" ><xsl:value-of select="$currentContext/@slatext" /></xsl:with-param>
            <xsl:with-param name="subject" ><xsl:value-of select="$currentContext/@subject" /></xsl:with-param>
            <xsl:with-param name="counter" ><xsl:value-of select="$newCounter" /></xsl:with-param>
			<xsl:with-param name="buinfo1" ><xsl:value-of select="$currentContext/@buinfo1" /></xsl:with-param>
			<xsl:with-param name="buinfo2" ><xsl:value-of select="$currentContext/@buinfo2" /></xsl:with-param>
			<xsl:with-param name="buinfo3" ><xsl:value-of select="$currentContext/@buinfo3" /></xsl:with-param>
			<xsl:with-param name="buinfo4" ><xsl:value-of select="$currentContext/@buinfo4" /></xsl:with-param>
			<xsl:with-param name="service" ><xsl:value-of select="$currentContext/@service" /></xsl:with-param>
			<xsl:with-param name="sql.disable" select="$currentContext/@sql.disable"/>
			<xsl:with-param name="trap.disable" select="$currentContext/@trap.disable"/>
			<xsl:with-param name="email.enable" select="$currentContext/@email.enable"/>
			<xsl:with-param name="sms.enable" select="$currentContext/@sms.enable"/>
			<xsl:with-param name="backup.enable" select="$currentContext/@backup.enable"/>
			<xsl:with-param name="backup.auto" select="$currentContext/@backup.auto"/>
			<xsl:with-param name="backup.type" select="$currentContext/@backup.type"/>
			<xsl:with-param name="alarmlamp.enable" select="$currentContext/@alarmlamp.enable"/>
        </xsl:call-template>
        
    </xsl:template>
	
</xsl:stylesheet> 
