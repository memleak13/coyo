<xsl:stylesheet version="1.0" 
	xmlns:xsl ="http://www.w3.org/1999/XSL/Transform" 
	xmlns:gw  ="http://euromedia-service.de/coyoNET/sqlgateway/"
	xmlns:cn ="http://euromedia-service.de/coyoNET/"
	>

	
	<!-- get configuration parameters -->
	<xsl:param name="confURL" />
	<xsl:param name="contextURL" />
	<xsl:param name="dynURL" />
	<xsl:param name="engineID" />
	
	<xsl:variable name="conf"      select="document($confURL)/conf" />
	<xsl:variable name="context"   select="document($contextURL)/context" />
	<xsl:variable name="dyn"       select="document($dynURL)/dyn" />
	
	<!-- define general information -->
	<xsl:variable name="module.name"          select="'ems.sqlgateway'" />
	<xsl:variable name="module.version"       select="'0203'" />

<!-- 
	<sqlmessages xmlns="http://euromedia-service.de/coyoNET/sqlgateway/">
		<sqlmessage  server-id="1" 
		             engine="test" 
		             engine-type="test.type" 
	                 alarm-engine="test_alarm"
		             alarm-id="1000" 
		             severity="3" 
		             behaviour="3" 
		             pending="1" 
		             text="test text" 
		             subject="test subject" />
	</sqlmessages>	
	
         <http-request id="send.sql.message" url="{$context/@sqlmsg.url}">
       <auth type="basic" user="{$context/@sql.web.user}" password="{$context/@sql.web.pwd}" />
       <content>
           <sqlmessages xmlns="http://euromedia-service.de/coyoNET/">
               <sqlmessage  server-id="{$context/@server.id}" 
                            engine="{$context/@notificationEngine}" 
                            engine-type="{$module-type}" 
                            alarm-id="{$notify/@alarm.id}" 
                            severity="{$notify/@severity}" 
                            behaviour="{$notify/@behaviour}" 
                            pending="{$notify/@pending}" 
                            text="{$notify/@text}" 
                            subject="{$subject}" />
                   
           </sqlmessages>
       </content>
   </http-request>	
		
 -->


	
	<xsl:template match="/*">
	    <debug>cannot handle message [<xsl:value-of select="local-name(.)" />] uri [<xsl:value-of select="namespace-uri(.)" />]</debug>
	</xsl:template>
	
	<xsl:template match="/error">
		<debug >ERROR: tag [<xsl:value-of select="@tag" />] cause [<xsl:value-of select="@cause" />]</debug>
		<dump><xsl:copy-of select="." /></dump>
		<xsl:call-template name="dropmode" />
	</xsl:template>
	
	<xsl:template match="/init">
		<context url="http://127.0.0.1:8082/sqlmessage" connect.timeout="2.0" read.timeout="1.0" user="coyonet" pwd="euromedia" api="2" send.count="0" dropcount="0" dropmode="0" dropmode.time="3.0" max.packet.size="10" send.delay="0.5"/>
		<xsl:call-template name="reset_change" />	
		
		<xsl:if test="boolean($conf/@user) and boolean($conf/@pwd)" >
			<xsl:if test="$conf/@user != 'coyonet'">
				<context user="{$conf/@user}" />
			</xsl:if>
			<xsl:if test="$conf/@pwd != 'euromedia'">
				<context pwd="{$conf/@pwd}" />
			</xsl:if>
		</xsl:if>
		
		<xsl:if test="$conf/@max.packet.size &gt; 0">
			<context max.packet.size="{$conf/@max.packet.size}" />
		</xsl:if>	

		<xsl:if test="$conf/@connect.timeout &gt; 0">
			<context connect.timeout="{$conf/@connect.timeout}" />
		</xsl:if>		

		<xsl:if test="$conf/@read.timeout &gt; 0">
			<context read.timeout="{$conf/@read.timeout}" />
		</xsl:if>
		
		<xsl:if test="$conf/@send.delay &gt; 0">
			<context send.delay="{$conf/@send.delay}" />
		</xsl:if>			
		
		<mib>
		    <set name="module.name" value="{$module.name}" />
		    <set name="module.version" value="0201" />
			<set name="state" value="5" />	
			<set name="drop.count$" value="0" />
		</mib>    		
	    <subscribe>
			<msg uri="http://euromedia-service.de/coyoNET/sqlgateway/" name="sqlmessages" />
	    </subscribe>
	</xsl:template>
	
	
	<xsl:template match="/gw:sqlmessages" >
<!-- 		<dump><xsl:copy-of select="$context" /> </dump> -->
		
		<xsl:choose>
			<xsl:when test="$context/@dropmode=1">
				<!-- DROP MESSAGES -->
<!-- 				<debug>drop message</debug> -->
				<xsl:variable name="dc" select="$context/@send.count + $context/@dropcount + count(./*)"/>
				<context dropcount="{$dc}" send.count="0"/>
				<mib>
					<set name="drop.count$" value="{$dc}" />
				</mib>
			</xsl:when>
			<xsl:otherwise>
			   <context send.count="{$context/@send.count + count(./*)}" />
				<context>
					<queue>
						<xsl:copy-of select="$context/queue/*" />
						<xsl:copy-of select="./*" />
					</queue>		
				</context>
				<xsl:choose>
					<xsl:when test="(count($context/queue/*) + 1) &gt; $context/@max.packet.size">
						<timer delay="0" id="send_message" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="$context/@change = 0">
							<context change="1" />
							<timer delay="{$context/@send.delay}" id="send_message" />
						</xsl:if>
					</xsl:otherwise>				
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	
	<xsl:template match="/timer[@id='send_message']" >
<!-- 		<debug>timer send_message</debug> -->
		<xsl:call-template name="sendMessages"/>
		<xsl:call-template name="reset_change"/>
	</xsl:template>


	<xsl:template name="sendMessages">
		<http-request api="{$context/@api}" id="send.sql.message" url="{$context/@url}" method="POST" connect.timeout="{$context/@connect.timeout}" read.timeout="{$context/@read.timeout}">
		<auth type="basic" user="{$context/@user}" password="{$context/@pwd}" />
		<content>
			<xsl:element name="sqlmessages" namespace="http://euromedia-service.de/coyoNET/">
				<xsl:for-each select="$context/queue/*" >
					<xsl:element name="{local-name(.)}" namespace="http://euromedia-service.de/coyoNET/">
						<xsl:copy-of select="./@*"/>
					</xsl:element>
				</xsl:for-each>	
			</xsl:element>
		</content>
		</http-request>
	</xsl:template>


	
	<xsl:template match="/http-response[@id='send.sql.message']" >
		<xsl:choose>
			<xsl:when test="boolean(@error)" >
				<debug>error http-request [<xsl:value-of select="@error" />]</debug>
				<dump file="dump/$engineID.txt"> 
					<xsl:copy-of select="." />
				</dump>
				<xsl:call-template name="dropmode" />
			</xsl:when>
			<xsl:when test="@code != 200">
				<xsl:call-template name="dropmode" />
			</xsl:when>
			<xsl:otherwise>
				<context send.count="0" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
	<xsl:template name="dropmode" >
		<xsl:if test="$context/@dropmode=0">
			<debug >drop mode on</debug>
			<context dropmode="1" />
			<xsl:call-template name="reset_change" />				
			<timer delay="{$context/@dropmode.time}" id="dropmode" />
		</xsl:if>	
	</xsl:template>

	
	<xsl:template name="reset_change" >
		<timer-cancel id="send_message" />
		<context change="0">
			<queue />
		</context>	
	</xsl:template>	
	
	<xsl:template match="/timer[@id='dropmode']">
		<context dropmode="0" />
		<debug >drop mode off</debug>
	</xsl:template>	
	


</xsl:stylesheet>



