<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- default values -->
    <xsl:variable name="default_snmp_getSystem_id" select="'snmp_system_get'" />
    
    
	<xsl:template name="snmp_system_init" >
		<snmp-map>
		    <sysDescr    oid="1.3.6.1.2.1.1.1" charset="UTF-8" />
		    <sysObjectId oid="1.3.6.1.2.1.1.2" charset="UTF-8" />
	        <sysUpTime   oid="1.3.6.1.2.1.1.3" />
		    <sysContact  oid="1.3.6.1.2.1.1.4" charset="UTF-8" />
		    <sysName     oid="1.3.6.1.2.1.1.5" charset="UTF-8" />
		    <sysLocation oid="1.3.6.1.2.1.1.6" charset="UTF-8" />
		</snmp-map>
		<context>
		    <xsl:attribute name="{$default_snmp_getSystem_id}" ><xsl:value-of select="0" /></xsl:attribute>
		</context>
	</xsl:template>
	
	
	<xsl:template name="snmp_system_getVarbinds" >
	    <sysDescr />
	    <sysObjectId />
	    <sysUpTime />
	    <sysContact />
	    <sysName />
	    <sysLocation />
    </xsl:template>
    
	
	<xsl:template name="snmp_system_get" >
	    <xsl:param name="id" />
	    <xsl:variable name="requestId" >
	       <xsl:choose>
	           <xsl:when test="string-length($id) &gt; 0" ><xsl:value-of select="$id" /></xsl:when>
	           <xsl:otherwise><xsl:value-of select="$default_snmp_getSystem_id" /></xsl:otherwise>
	       </xsl:choose>
	    </xsl:variable>
	    <snmp-request id="{$requestId}" addr="{$conf/@url}" port="{$conf/@snmp.port}" type="get" community="{$conf/@snmp.read}" version="{$conf/@snmp.version}" >
		    <xsl:call-template name="snmp_system_getVarbinds" />
		</snmp-request>
	</xsl:template>
	
	
	<xsl:template match="/snmp-response[@id = $default_snmp_getSystem_id]" >
	    <xsl:choose>
	        <xsl:when test="(@error='timeout') or (@error='I/O exception')" >
	            <mib>
	                <set name="notResponding" value="1" />
	            </mib>
	            <context notResponding="1" >
	                <xsl:attribute name="{$default_snmp_getSystem_id}" ><xsl:value-of select="1" /></xsl:attribute>
	            </context>
	        </xsl:when>
	        <xsl:otherwise>
	            <mib>
	                <xsl:for-each select="*" >
	                    <xsl:variable name="mibValue" >
		                    <xsl:choose>
	                           <xsl:when test="string-length(@strvalue) &gt; 0" ><xsl:value-of select="@strvalue"/></xsl:when>
	                           <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
	                        </xsl:choose>
                        </xsl:variable>
	                    <set name="{name()}" value="{$mibValue}" />
	                </xsl:for-each>
	                <set name="notResponding" value="0" />
	            </mib>
	            <context notResponding="0" >
	               <xsl:attribute name="{$default_snmp_getSystem_id}" ><xsl:value-of select="1" /></xsl:attribute>
	               <xsl:for-each select="*" >
	                    <xsl:element name="{concat('mib.',name())}">
	                        <xsl:attribute name="name">
	                            <xsl:value-of select="name()"/>
	                        </xsl:attribute>
	                        <xsl:attribute name="value">
	                            <xsl:choose>
	                               <xsl:when test="string-length(@strvalue) &gt; 0" ><xsl:value-of select="@strvalue"/></xsl:when>
	                               <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
	                            </xsl:choose>
	                        </xsl:attribute>
	                    </xsl:element>
	               </xsl:for-each>
	            </context>
	        </xsl:otherwise>
	    </xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>

