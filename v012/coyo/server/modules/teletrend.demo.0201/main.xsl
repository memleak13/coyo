<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:param name="confURL" />
    <xsl:param name="contextURL" />
    <xsl:param name="dynURL" /> 
	<xsl:param name="engineID" />    
	
	<xsl:variable name="conf"      select="document($confURL)/conf" />
	<xsl:variable name="context"   select="document($contextURL)/context" />
	<xsl:variable name="dyn"       select="document($dynURL)/dyn" />
	<xsl:variable name="engine.id" select="$engineID" />
    
    <!-- define general information -->
    <xsl:variable name="module.name"        select="'teletrend.demo'" />
    
    
    <xsl:template match="/*">
        <debug>cannot handle message [<xsl:value-of select="local-name(.)" />] uri [<xsl:value-of select="namespace-uri(.)" />]</debug>
<!--         <dump file="dump/{$engineID}.txt"><xsl:copy-of select="."/></dump> -->
    </xsl:template>

<xsl:template match="/error">
    <debug>error: tag [<xsl:value-of select="@tag" />] <xsl:value-of select="@cause" /></debug>
<!--     <dump file="dump/{$engineID}.txt"><xsl:copy-of select="."/></dump>	 -->

</xsl:template>


    <xsl:template match="/init">
        <mib>
            <set name="state"         value="5" />
            <set name="ok"            value="5" />
            <set name="warning"       value="4" />
            <set name="minor"         value="3" />
            <set name="major"         value="2" />
            <set name="critical"      value="1" />
            <set name="invisible"     value="0" />
            <set name="green"       value="5" />
            <set name="cyan"        value="4" />
            <set name="yellow"      value="3" />
            <set name="orange"      value="2" />
            <set name="red"         value="1" />
		    <set name="module.name"     value="{$module.name}" />
        </mib>
       
        <subscribe>
        	<mib name="sys.client.msg"/>
        	<mib name="sys.client.conf"/>
        	
        	<mib name="{$conf/@scriptstate}" />
        	
        </subscribe>
        <timer id="t1" delay="0" />
        <timer id="alive" delay="0" />
        
        <context alive="0" />
<!--         <timer delay="2" id="change_state_2" /> -->


		<snmp-map>
			<DisplayText oid="1.3.6.1.2.1.43.16.5.1.2"  charset="UTF-8" />
		</snmp-map>
		
		<timer id="poll" delay="0" />
               
    </xsl:template>


	<xsl:template match="/timer[@id='poll']">
		<debug>poll</debug>
	
		<snmp-request id="poll" addr="192.168.2.208" community="public" >
	        <DisplayText index="1.1" />
	    </snmp-request>	
	
	</xsl:template>
	
	<xsl:template match="/snmp-response[@id='poll']">
		<dump file="dump/{$engineID}.txt">
			<xsl:copy-of select="/"/>
		
		</dump>
	
	
		<xsl:for-each select="*">
			<xsl:variable name="name" select="local-name()"/>
			<xsl:variable name="index" select="@index"/>
			<xsl:variable name="value" select="@strvalue" />
			
			<mib>
				<set name="{$name}.{$index}" value="{$value}" />
			</mib>
		
		</xsl:for-each>
		
		<timer id="poll" delay="5" />

	
	</xsl:template>	


	<xsl:template match="/mib" >
		<xsl:for-each select="set">
			<xsl:choose>
				<xsl:when test="@name = 'sys.client.msg'">
					<context sys.client.msg="{@value}" />
				</xsl:when>
				<xsl:when test="@name = 'sys.client.conf'">
					<context sys.client.conf="{@value}" />
				</xsl:when>
				<xsl:when test="@name = $conf/@scriptstate and @value='ok' ">
					<mib>
						<set name="state" value="5" />
					</mib>
				</xsl:when>
				<xsl:when test="@name = $conf/@scriptstate and @value='error'" >
					<mib>
						<set name="state" value="2" />
					</mib>
				</xsl:when>				
			</xsl:choose>	
		</xsl:for-each>
	</xsl:template>



    <xsl:template match="/timer[@id='t1']">
    	<xsl:variable name="sysClient" select="substring-before($context/@sys.client.conf,'/conf.xml')" />
    
       <mib>
           <set name="client.sqlprops" value="{$sysClient}/sqlprops.xml" />
           <set name="client.msg"      value="{$context/@sys.client.msg}" />
           <set name="testseverity" value = "." />
      </mib>
       <timer id="t2" delay="2.4" />
    </xsl:template>
    <xsl:template match="/timer[@id='t2']">
    	<xsl:variable name="sysClient" select="substring-before($context/@sys.client.conf,'/conf.xml')" />
      <mib>
          <set name="client.sqlprops" value="{$sysClient}/sqlprops.xml  " />
          <set name="client.msg"      value="{$context/@sys.client.msg}  " />
          <set name="testseverity" value = ":" />
      </mib>
      <timer id="t1" delay="2.4" />
    </xsl:template>
    
    <xsl:template match="/timer[@id='alive']">
    	<xsl:variable name="sysClient" select="substring-before($context/@sys.client.conf,'/conf.xml')" />
      <mib>
          <set name="alive" value="{$context/@alive}" />
      </mib>
      <context alive="{$context/@alive + 1}" />
      <timer id="alive" delay="60.0" />
    </xsl:template>    
    
    
     <xsl:template match="/timer[@id='change_state_2']">
     	<mib>
     		<set name="state" value="2" />
     	</mib>
     	<timer delay="2" id="change_state_5" />
     </xsl:template>
    
    
     <xsl:template match="/timer[@id='change_state_5']">
     	<mib>
     		<set name="state" value="5" />
     	</mib>
     	<timer delay="2" id="change_state_2" />
     </xsl:template>
        

</xsl:stylesheet>


