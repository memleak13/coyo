<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="queue1.init">
		<context >
			<queue1/>
		</context>
	</xsl:template>
	
	<xsl:template name="queue1.clear">
		<context >
			<queue1/>
		</context>
	</xsl:template>

	<xsl:template name="queue1.size">
		<xsl:value-of select="count($context/queue1/q)" />
	</xsl:template>


	<!-- Retrieves, but does not remove, the head of this queue -->
	<!--	select="$context/queue1/q[1]/*"-->
	<!--                                   -->

	<!-- add the element 'el to the tail of the queue -->
	<xsl:template name="queue1.add" >
		<xsl:param name="el" />
		<xsl:if test="boolean($el)" >
			<context>
				<queue1>
					<xsl:for-each select="$context/queue1/q">
						<xsl:copy-of select="." />
					</xsl:for-each>
					<xsl:if test="boolean($el)" >
						<q>
							<xsl:copy-of select="$el" />
						</q>					
					</xsl:if>					
				</queue1>		
			</context>
		</xsl:if>
	</xsl:template>	

	<xsl:template name="queue1.cloneChilds" >
		<xsl:for-each select="$context/queue1/q">
			<xsl:copy-of select="." />
		</xsl:for-each>
	</xsl:template>	

	<xsl:template name="queue1.append" >
		<xsl:param name="el" />
		<xsl:if test="boolean($el)" >
			<q>
				<xsl:copy-of select="$el" />
			</q>					
		</xsl:if>
	</xsl:template>	



	<!-- Remove the first element from the queue. -->
	<xsl:template name="queue1.remove" >
		<context>
			<queue1>
				<xsl:for-each select="$context/queue1/q[1]/following-sibling::*" >
					<xsl:copy-of select="." />
				</xsl:for-each>
			</queue1>		
		</context>
	</xsl:template>	
	
	<!-- drop first n messages -->
	<xsl:template name="queue1.drop" >
		<xsl:param name="n"/>
		<xsl:variable name="qsize" >
			<xsl:call-template name="queue1.size"></xsl:call-template>
		</xsl:variable>
		<xsl:if test="$qsize &gt; $n" >
			<xsl:variable name="idxStart" select="$qsize - $n" />
			<context>
				<queue1>
					<xsl:for-each select="$context/queue1/q[$idxStart]/following-sibling::*" >
						<xsl:copy-of select="." />
					</xsl:for-each>
				</queue1>		
			</context>
		</xsl:if>		
	</xsl:template>	
	
	
</xsl:stylesheet>