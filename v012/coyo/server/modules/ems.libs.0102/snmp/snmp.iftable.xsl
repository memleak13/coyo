<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- available messages:
    <msg>
        <set-port-adminstatus engine="ENGINE" port="PORT" state="STATE" xmlns="http://euromedia-service.de/coyoNET/ipSwitch" />
    </msg>
        ENGINE = engine of switch
        PORT   = port number (1 - 128)
        STATE  = 'up', 'down', 'testing'
     -->
    
     
    <!-- default values -->
    <xsl:variable name="default_snmp_getIfTable_id_all"     select="'snmp_iftable_get_all'" />
    <xsl:variable name="default_snmp_getIfTable_id_simple"  select="'snmp_iftable_get_simple'" />
    <xsl:variable name="default_snmp_setifAdminStatus_id"  select="'snmp_iftable_set_ifAdminStatus'" />
    
    <xsl:variable name="ifTable.table"  select="'1.3.6.1.2.1.2.2.1'" />
    
    <xsl:variable name="name_ifType"  select="'ifType'" />
    <xsl:variable name="port_offset"  select="10000" />
    

 
<!-- ############################################################################################################################### -->

    <!-- init -->
        
	<xsl:template name="snmp_iftable_init" >
		<snmp-map>
	        <ifAdminStatus oid="1.3.6.1.2.1.2.2.1.7" />
	    </snmp-map>
	    <subscribe>
	        <msg uri="http://euromedia-service.de/coyoNET/ipSwitch" name="set-port-adminstatus" />
	    </subscribe>
	    <context>
            <xsl:attribute name="{$default_snmp_getIfTable_id_all}" ><xsl:value-of select="1" /></xsl:attribute>
            <xsl:attribute name="{$default_snmp_getIfTable_id_simple}" ><xsl:value-of select="1" /></xsl:attribute>
        </context>
	</xsl:template>
	
	

<!-- ############################################################################################################################### -->

    <!-- varbinds for SNMP get table -->
    	
	<xsl:template name="snmp_iftable_getVarbinds_all" >
	    <ifIndex            id="1" />
	    <ifDescr            id="2" charset="UTF-8" />
        <ifType             id="3" />
        <ifMtu              id="4" />
        <ifSpeed            id="5" charset="UTF-8" />
        <ifPhysAddress      id="6" charset="UTF-8" />
        <ifAdminStatus      id="7" />
        <ifOperStatus       id="8" />
        <ifLastChange       id="9" />
        <ifInOctets         id="10" />
        <ifInUcastPkts      id="11" />
        <ifInNUcastPkts     id="12" />
        <ifInDiscards       id="13" />
        <ifInErrors         id="14" />
        <ifInUnknownProtos  id="15" />
        <ifOutOctets        id="16" />
        <ifOutUcastPkts     id="17" />
        <ifOutNUcastPkts    id="18" />
        <ifOutDiscards      id="19" />
        <ifOutErrors        id="20" />
        <ifOutQLen          id="21" />
        <ifSpecific         id="22" charset="UTF-8" />
    </xsl:template>
    
    
    <xsl:template name="snmp_iftable_getVarbinds_simple" >
        <ifIndex            id="1" />
        <ifDescr            id="2" charset="UTF-8" />
        <ifAdminStatus      id="7" />
        <ifOperStatus       id="8" />
    </xsl:template>
	


<!-- ############################################################################################################################### -->

    <!-- SNMP get table -->
    
	<xsl:template name="snmp_iftable_get_all" >
	    <xsl:param name="id" />
	    <xsl:variable name="requestId" >
	       <xsl:choose>
	           <xsl:when test="string-length($id) &gt; 0" ><xsl:value-of select="$id" /></xsl:when>
	           <xsl:otherwise><xsl:value-of select="$default_snmp_getIfTable_id_all" /></xsl:otherwise>
	       </xsl:choose>
	    </xsl:variable>
	    <snmp-get-table id="{$requestId}" addr="{$conf/@url}" port="{$conf/@snmp.port}" 
	                    entry="{$ifTable.table}" community="{$conf/@snmp.read}" version="{$conf/@snmp.version}" >
            <xsl:call-template name="snmp_iftable_getVarbinds_all" />
        </snmp-get-table>
	</xsl:template>
	
	
	<xsl:template name="snmp_iftable_get_simple" >
        <xsl:param name="id" />
        <xsl:variable name="requestId" >
           <xsl:choose>
               <xsl:when test="string-length($id) &gt; 0" ><xsl:value-of select="$id" /></xsl:when>
               <xsl:otherwise><xsl:value-of select="$default_snmp_getIfTable_id_simple" /></xsl:otherwise>
           </xsl:choose>
        </xsl:variable>
        <snmp-get-table id="{$requestId}" addr="{$conf/@url}" port="{$conf/@snmp.port}" 
                        entry="{$ifTable.table}" community="{$conf/@snmp.read}" version="{$conf/@snmp.version}" >
            <xsl:call-template name="snmp_iftable_getVarbinds_simple" />
        </snmp-get-table>
    </xsl:template>
	
	


<!-- ############################################################################################################################### -->

    <!-- SNMP get table responses -->
    
    	
	<xsl:template match="/snmp-table[@id = $default_snmp_getIfTable_id_all]" >
	    <xsl:choose>
	        <xsl:when test="(@error='timeout') or (@error='I/O exception')" >
	            <mib>
	                <set name="notResponding" value="1" />
	            </mib>
	            <context notResponding="1" >
	                <xsl:attribute name="{$default_snmp_getIfTable_id_all}" ><xsl:value-of select="1" /></xsl:attribute>
	            </context>
	        </xsl:when>
	        <xsl:otherwise>
	            <mib>
	                <xsl:for-each select="entry" >
	                    <xsl:variable name="index" select="@index" />
	                    <xsl:for-each select="*" >
	                            <xsl:variable name="mibName" select="concat(name(),'.',$index+$port_offset)" />
	                            <xsl:variable name="mibValue" >
		                            <xsl:choose>
		                               <xsl:when test="name() = $name_ifType" >
                                           <xsl:call-template name="format_ifType" >
                                               <xsl:with-param name="ifType" ><xsl:value-of select="@value"/></xsl:with-param>
                                           </xsl:call-template>
                                       </xsl:when>
                                       <xsl:when test="string-length(@strvalue) &gt; 0" ><xsl:value-of select="@strvalue"/></xsl:when>
		                               <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
		                            </xsl:choose>
		                        </xsl:variable>
	                            <set name="{$mibName}" value="{$mibValue}" />
	                    </xsl:for-each>
	                </xsl:for-each>
	                <set name="notResponding" value="0" />
	            </mib>
	            <context notResponding="0" >
	               <xsl:attribute name="{$default_snmp_getIfTable_id_all}" ><xsl:value-of select="1" /></xsl:attribute>
	               <xsl:for-each select="entry" >
                        <xsl:variable name="index" select="@index" />
                        <xsl:for-each select="*" >
                                <xsl:variable name="mibName" select="concat(name(),'.',$index+$port_offset)" />
                                <xsl:variable name="mibValue" >
                                    <xsl:choose>
                                       <xsl:when test="string-length(@strvalue) &gt; 0" ><xsl:value-of select="@strvalue"/></xsl:when>
                                       <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <set name="{$mibName}" value="{$mibValue}" />
                        </xsl:for-each>
                    </xsl:for-each>
	            </context>
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="/snmp-table[@id = $default_snmp_getIfTable_id_simple]" >
        <xsl:choose>
            <xsl:when test="(@error='timeout') or (@error='I/O exception')" >
                <mib>
                    <set name="notResponding" value="1" />
                </mib>
                <context notResponding="1" >
                    <xsl:attribute name="{$default_snmp_getIfTable_id_simple}" ><xsl:value-of select="1" /></xsl:attribute>
                </context>
            </xsl:when>
            <xsl:otherwise>
                <mib>
                    <xsl:for-each select="entry" >
                        <xsl:variable name="index" select="@index" />
                        <xsl:for-each select="*" >
                                <xsl:variable name="mibName" select="concat(name(),'.',$index+$port_offset)" />
                                <xsl:variable name="mibValue" >
                                    <xsl:choose>
                                       <xsl:when test="string-length(@strvalue) &gt; 0" ><xsl:value-of select="@strvalue"/></xsl:when>
                                       <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:if test="substring-before($mibName,'.')='ifOperStatus' or substring-before($mibName,'.')='ifAdminStatus'">                           
                                	<xsl:variable name="newIndex" select="$index+$port_offset" />                                
	                                	<xsl:choose>
	                                		<xsl:when test="$mibValue='1'">                                		
	                                			<set name="ifPortStatus.{$newIndex}" value="5" />                                		 
	                                		</xsl:when>
	                                		<xsl:otherwise>
	                                				<set name="ifPortStatus.{$newIndex}" value="2" />
	                                		</xsl:otherwise>
                                	</xsl:choose>                                	 
                                </xsl:if>
                                <set name="{$mibName}" value="{$mibValue}" />
                        </xsl:for-each>
                    </xsl:for-each>
                    <set name="notResponding" value="0" />
                </mib>
                <context notResponding="0" >
                   <xsl:attribute name="{$default_snmp_getIfTable_id_simple}" ><xsl:value-of select="1" /></xsl:attribute>
                   <xsl:for-each select="entry" >
                        <xsl:variable name="index" select="@index" />
                        <xsl:for-each select="*" >
                                <xsl:variable name="mibName" select="concat(name(),'.',$index+$port_offset)" />
                                <xsl:variable name="mibValue" >
                                    <xsl:choose>
                                       <xsl:when test="string-length(@strvalue) &gt; 0" ><xsl:value-of select="@strvalue"/></xsl:when>
                                       <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>                                                              
                                <set name="{$mibName}" value="{$mibValue}" />
                        </xsl:for-each>
                    </xsl:for-each>
                </context>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


		


<!-- ############################################################################################################################### -->

    <!-- Format parameters -->
    
    <xsl:template name="format_ifType" >
        <xsl:param name="ifType" />
        <xsl:variable name="formatted_ifType" >
	        <xsl:choose>
				<xsl:when test="$ifType = 1" ><xsl:value-of select="'other'" /></xsl:when>
				<xsl:when test="$ifType = 2" ><xsl:value-of select="'regular1822'" /></xsl:when>
				<xsl:when test="$ifType = 3" ><xsl:value-of select="'hdh1822'" /></xsl:when>
				<xsl:when test="$ifType = 4" ><xsl:value-of select="'ddn-x25'" /></xsl:when>
				<xsl:when test="$ifType = 5" ><xsl:value-of select="'rfc877-x25'" /></xsl:when>
				<xsl:when test="$ifType = 6" ><xsl:value-of select="'ethernet-csmacd'" /></xsl:when>
				<xsl:when test="$ifType = 7" ><xsl:value-of select="'iso88023-csmacd'" /></xsl:when>
				<xsl:when test="$ifType = 8" ><xsl:value-of select="'iso88024-tokenBus'" /></xsl:when>
				<xsl:when test="$ifType = 9" ><xsl:value-of select="'iso88025-tokenRing'" /></xsl:when>
				<xsl:when test="$ifType = 10" ><xsl:value-of select="'iso88026-man'" /></xsl:when>
				<xsl:when test="$ifType = 11" ><xsl:value-of select="'starLan'" /></xsl:when>
				<xsl:when test="$ifType = 12" ><xsl:value-of select="'proteon-10Mbit'" /></xsl:when>
				<xsl:when test="$ifType = 13" ><xsl:value-of select="'proteon-80Mbit'" /></xsl:when>
				<xsl:when test="$ifType = 14" ><xsl:value-of select="'hyperchannel'" /></xsl:when>
				<xsl:when test="$ifType = 15" ><xsl:value-of select="'fddi'" /></xsl:when>
				<xsl:when test="$ifType = 16" ><xsl:value-of select="'lapb'" /></xsl:when>
				<xsl:when test="$ifType = 17" ><xsl:value-of select="'sdlc'" /></xsl:when>
				<xsl:when test="$ifType = 18" ><xsl:value-of select="'ds1'" /></xsl:when>
				<xsl:when test="$ifType = 19" ><xsl:value-of select="'e1'" /></xsl:when>
				<xsl:when test="$ifType = 20" ><xsl:value-of select="'basicISDN'" /></xsl:when>
				<xsl:when test="$ifType = 21" ><xsl:value-of select="'primaryISDN'" /></xsl:when>
				<xsl:when test="$ifType = 22" ><xsl:value-of select="'propPointToPointSerial'" /></xsl:when>
				<xsl:when test="$ifType = 23" ><xsl:value-of select="'ppp'" /></xsl:when>
				<xsl:when test="$ifType = 24" ><xsl:value-of select="'softwareLoopback'" /></xsl:when>
				<xsl:when test="$ifType = 25" ><xsl:value-of select="'eon'" /></xsl:when>
				<xsl:when test="$ifType = 26" ><xsl:value-of select="'ethernet-3Mbit'" /></xsl:when>
				<xsl:when test="$ifType = 27" ><xsl:value-of select="'nsip'" /></xsl:when>
				<xsl:when test="$ifType = 28" ><xsl:value-of select="'slip'" /></xsl:when>
				<xsl:when test="$ifType = 29" ><xsl:value-of select="'ultra'" /></xsl:when>
				<xsl:when test="$ifType = 30" ><xsl:value-of select="'ds3'" /></xsl:when>
				<xsl:when test="$ifType = 31" ><xsl:value-of select="'sip'" /></xsl:when>
				<xsl:when test="$ifType = 32" ><xsl:value-of select="'frame-relay'" /></xsl:when>
				<xsl:otherwise><xsl:value-of select="$ifType" /></xsl:otherwise>
	        </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$formatted_ifType" />
    </xsl:template>
    


<!-- ############################################################################################################################### -->

    <!-- SNMP set ifAdminStatus -->
    
    
    <!-- Message -->
    <xsl:template match="/switch:set-port-adminstatus[@engine = $engineID]" xmlns:switch="http://euromedia-service.de/coyoNET/ipSwitch">
        <debug>Got message set-port-adminstatus</debug>
        <xsl:call-template name="snmp_iftable_set_ifadminstatus" >
           <xsl:with-param name="id" ><xsl:value-of select="''" /></xsl:with-param>
           <xsl:with-param name="port" ><xsl:value-of select="@port" /></xsl:with-param>
           <xsl:with-param name="state" ><xsl:value-of select="@state" /></xsl:with-param>
        </xsl:call-template>
        <!--  
        <context >
            <queue>
                <xsl:call-template name="queue.cloneChilds"/>
                <q >
                    <xsl:call-template name="snmp_iftable_set_ifadminstatus" >
                       <xsl:with-param name="id" ><xsl:value-of select="''" /></xsl:with-param>
                       <xsl:with-param name="port" ><xsl:value-of select="@port" /></xsl:with-param>
                       <xsl:with-param name="state" ><xsl:value-of select="@state" /></xsl:with-param>
                    </xsl:call-template>
                </q>    
            </queue>
        </context>           
        <xsl:if test="$context/@queue.busy='false'" >
            <timer delay="0" id="config.next-job" />
        </xsl:if>
        -->
    </xsl:template>
    
    
    <!-- SNMP set and response -->
    
    <xsl:template name="snmp_iftable_set_ifadminstatus" >
	    <xsl:param name="id" />
	    <xsl:param name="port" />
        <xsl:param name="state" />
        <xsl:variable name="requestId" >
           <xsl:choose>
               <xsl:when test="string-length($id) &gt; 0" ><xsl:value-of select="$id" /></xsl:when>
               <xsl:otherwise><xsl:value-of select="$default_snmp_setifAdminStatus_id" /></xsl:otherwise>
           </xsl:choose>
        </xsl:variable>
        <xsl:variable name="index" select="$port + $port_offset" />
        
	    <xsl:variable name="setValue" >
	        <xsl:choose>
	           <xsl:when test="$state = 'up'" ><xsl:value-of select="1" /></xsl:when>
               <xsl:when test="$state = 'down'" ><xsl:value-of select="2" /></xsl:when>
               <xsl:when test="$state = 'testing'" ><xsl:value-of select="3" /></xsl:when>
               <xsl:otherwise><xsl:value-of select="10" /></xsl:otherwise>
	        </xsl:choose>
	    </xsl:variable>
	    <xsl:choose>
            <xsl:when test="($setValue=1 or $setValue=2 or $setValue=3) and 
                             (($port &gt; 0) and ($port &lt; 128))" >
                <debug>Idx: <xsl:value-of select="$index" /></debug>
                <debug>Val: <xsl:value-of select="$setValue" /></debug>
                <snmp-request id="{$id}" addr="{$conf/@url}" port="{$conf/@snmp.port}" type="set" community="{$conf/@snmp.write}" version="{$conf/@snmp.version}" >
		            <ifAdminStatus index="{$index}" syntax="Integer32" value="{$setValue}"/> 
		        </snmp-request>
            </xsl:when>
            <xsl:otherwise>
                <debug>Error in SNMP Set. Parameter invalid. Port: <xsl:value-of select="$port" />, State: <xsl:value-of select="$state" />.</debug>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="/snmp-response[@id=$default_snmp_setifAdminStatus_id]" >
	    <xsl:choose>
	        <xsl:when test="(@error='timeout') or (@error='I/O exception')" >
	            <debug>Error occured. id: <xsl:value-of select="@id" />, error: <xsl:value-of select="@error" /></debug>
	        </xsl:when>
	        <xsl:otherwise>
	            <mib>
                    <xsl:for-each select="entry" >
                        <xsl:variable name="index" select="@index" />
                        <xsl:for-each select="*" >
                                <xsl:variable name="mibName" select="concat(name(),'.',$index+$port_offset)" />
                                <xsl:variable name="mibValue" >
                                    <xsl:choose>
                                       <xsl:when test="string-length(@strvalue) &gt; 0" ><xsl:value-of select="@strvalue"/></xsl:when>
                                       <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <set name="{$mibName}" value="{$mibValue}" />
                        </xsl:for-each>
                    </xsl:for-each>
                    <set name="notResponding" value="0" />
                </mib>
                <context notResponding="0" >
                   <xsl:for-each select="entry" >
                        <xsl:variable name="index" select="@index" />
                        <xsl:for-each select="*" >
                                <xsl:variable name="mibName" select="concat(name(),'.',$index+$port_offset)" />
                                <xsl:variable name="mibValue" >
                                    <xsl:choose>
                                       <xsl:when test="string-length(@strvalue) &gt; 0" ><xsl:value-of select="@strvalue"/></xsl:when>
                                       <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <set name="{$mibName}" value="{$mibValue}" />
                        </xsl:for-each>
                    </xsl:for-each>
                </context>
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>

</xsl:stylesheet>
