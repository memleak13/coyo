<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- ############################################################################################################################### -->

    <!-- Send internal Trap message --> 
    
    <xsl:template name="makeInternalTrap" >
        <xsl:param name="alarm.id" />
        <xsl:param name="severity" />
        <xsl:param name="behaviour" />
        <xsl:param name="pending" />
        <xsl:param name="text" />
        <xsl:param name="subject" />
        <xsl:param name="debounce" />
        <xsl:param name="clear-debounce" />
        <xsl:param name="mib" />
        <xsl:param name="engine" />
        <xsl:param name="engine-type" />
        <xsl:param name="sql.disable" />
		<xsl:param name="trap.disable" />
		<xsl:param name="email.enable" />
		<xsl:param name="sms.enable" />
        
        <msg>
            <xsl:variable name="itn" select="concat('internal-trap.', $engine)" />
            <xsl:element name="{$itn}" namespace="http://euromedia-service.de/coyoNET/internalTrap/" >
                <xsl:attribute name="engine"         ><xsl:value-of select="$engine" /></xsl:attribute>
                <xsl:attribute name="engine-type"    ><xsl:value-of select="$engine-type" /></xsl:attribute>
                <xsl:attribute name="alarm.id"       ><xsl:value-of select="$alarm.id" /></xsl:attribute>
                <xsl:attribute name="debounce"       ><xsl:value-of select="$debounce" /></xsl:attribute>
                <xsl:attribute name="clear-debounce" ><xsl:value-of select="$clear-debounce" /></xsl:attribute>
                <xsl:attribute name="mib"            ><xsl:value-of select="$mib" /></xsl:attribute>
                <xsl:attribute name="severity"       ><xsl:value-of select="$severity" /></xsl:attribute>
                <xsl:attribute name="behaviour"      ><xsl:value-of select="$behaviour" /></xsl:attribute>
                <xsl:attribute name="pending"        ><xsl:value-of select="$pending" /></xsl:attribute>
                <xsl:attribute name="text"           ><xsl:value-of select="$text" /></xsl:attribute>
                <xsl:attribute name="subject"        ><xsl:value-of select="$subject" /></xsl:attribute>
                <xsl:attribute name="sql.disable"    ><xsl:value-of select="$sql.disable" /></xsl:attribute>
                <xsl:attribute name="trap.disable"   ><xsl:value-of select="$trap.disable" /></xsl:attribute>
                <xsl:attribute name="email.enable"   ><xsl:value-of select="$email.enable" /></xsl:attribute>
                <xsl:attribute name="sms.enable"     ><xsl:value-of select="$sms.enable" /></xsl:attribute>
            </xsl:element>
        </msg>
    </xsl:template>
    
    
   <xsl:template name="makeInternalBackupTrap" >
        <xsl:param name="alarm.id" />
        <xsl:param name="severity" />
        <xsl:param name="behaviour" />
        <xsl:param name="pending" />
        <xsl:param name="text" />
		<xsl:param name="traptext" />
		<xsl:param name="slatext" />
        <xsl:param name="subject" />
        <xsl:param name="debounce" />
        <xsl:param name="clear-debounce" />
        <xsl:param name="mib" />
        <xsl:param name="engine" />
        <xsl:param name="engine-type" />
        <xsl:param name="sql.disable" />
		<xsl:param name="trap.disable" />
		<xsl:param name="email.enable" />
		<xsl:param name="sms.enable" />
		<xsl:param name="backup.enable" />
		<xsl:param name="backup.auto" />
		<xsl:param name="backup.type" />
		<xsl:param name="alarmlamp.enable" />
        <xsl:param name="buinfo1"/>
		<xsl:param name="buinfo2"/>
        <xsl:param name="buinfo3"/>
        <xsl:param name="buinfo4"/>
        <xsl:param name="service"/>
        
        <msg>
            <xsl:variable name="itn" select="concat('internal-trap.', $engine)" />
            <xsl:element name="{$itn}" namespace="http://euromedia-service.de/coyoNET/internalTrap/" >
                <xsl:attribute name="engine"           ><xsl:value-of select="$engine" /></xsl:attribute>
                <xsl:attribute name="engine-type"      ><xsl:value-of select="$engine-type" /></xsl:attribute>
                <xsl:attribute name="alarm.id"         ><xsl:value-of select="$alarm.id" /></xsl:attribute>
                <xsl:attribute name="debounce"         ><xsl:value-of select="$debounce" /></xsl:attribute>
                <xsl:attribute name="clear-debounce"   ><xsl:value-of select="$clear-debounce" /></xsl:attribute>
                <xsl:attribute name="mib"              ><xsl:value-of select="$mib" /></xsl:attribute>
                <xsl:attribute name="severity"         ><xsl:value-of select="$severity" /></xsl:attribute>
                <xsl:attribute name="behaviour"        ><xsl:value-of select="$behaviour" /></xsl:attribute>
                <xsl:attribute name="pending"          ><xsl:value-of select="$pending" /></xsl:attribute>
                <xsl:attribute name="text"             ><xsl:value-of select="$text" /></xsl:attribute>
				<xsl:attribute name="traptext"         ><xsl:value-of select="$traptext" /></xsl:attribute>
				<xsl:attribute name="slatext"          ><xsl:value-of select="$slatext" /></xsl:attribute>
                <xsl:attribute name="subject"          ><xsl:value-of select="$subject" /></xsl:attribute>
                <xsl:attribute name="sql.disable"      ><xsl:value-of select="$sql.disable" /></xsl:attribute>
                <xsl:attribute name="trap.disable"     ><xsl:value-of select="$trap.disable" /></xsl:attribute>
                <xsl:attribute name="email.enable"     ><xsl:value-of select="$email.enable" /></xsl:attribute>
                <xsl:attribute name="sms.enable"       ><xsl:value-of select="$sms.enable" /></xsl:attribute>
				<xsl:attribute name="backup.enable"    ><xsl:value-of select="$backup.enable" /></xsl:attribute>
				<xsl:attribute name="backup.auto"      ><xsl:value-of select="$backup.auto" /></xsl:attribute>
				<xsl:attribute name="backup.type"      ><xsl:value-of select="$backup.type" /></xsl:attribute>
				<xsl:attribute name="alarmlamp.enable" ><xsl:value-of select="$alarmlamp.enable" /></xsl:attribute>
                <xsl:attribute name="buinfo1"          ><xsl:value-of select="$buinfo1"/></xsl:attribute>
                <xsl:attribute name="buinfo2"          ><xsl:value-of select="$buinfo2"/></xsl:attribute>
				<xsl:attribute name="buinfo3"          ><xsl:value-of select="$buinfo3"/></xsl:attribute>
                <xsl:attribute name="buinfo4"          ><xsl:value-of select="$buinfo4"/></xsl:attribute>   
                <xsl:attribute name="service"          ><xsl:value-of select="$service"/></xsl:attribute>   
            </xsl:element>
        </msg>
    </xsl:template>  
    
    
</xsl:stylesheet>

