<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="queue2.init">
		<context >
			<queue2/>
		</context>
	</xsl:template>
	
	<xsl:template name="queue2.clear">
		<context >
			<queue2/>
		</context>
	</xsl:template>

	<xsl:template name="queue2.size">
		<xsl:value-of select="count($context/queue2/q)" />
	</xsl:template>

	<!-- Retrieves, but does not remove, the head of this queue -->
	<!--	select="$context/queue2/q[1]/*"-->
	<!--                                   -->


	<!-- add the element 'el to the tail of the queue -->
	<xsl:template name="queue2.add" >
		<xsl:param name="el" />
		<xsl:if test="boolean($el)" >
			<context>
				<queue2>
					<xsl:for-each select="$context/queue2/q">
						<xsl:copy-of select="." />
					</xsl:for-each>
					<q>
						<xsl:copy-of select="$el" />
					</q>					
				</queue2>		
			</context>
		</xsl:if>
	</xsl:template>	

	<xsl:template name="queue2.cloneChilds" >
		<xsl:for-each select="$context/queue2/q">
			<xsl:copy-of select="." />
		</xsl:for-each>
	</xsl:template>	

	<xsl:template name="queue2.append" >
		<xsl:param name="el" />
		<xsl:if test="boolean($el)" >
			<q>
				<xsl:copy-of select="$el" />
			</q>					
		</xsl:if>
	</xsl:template>	



	<!-- Remove the first element from the queue. -->
	<xsl:template name="queue2.remove" >
		<context>
			<queue2>
				<xsl:for-each select="$context/queue2/q[1]/following-sibling::*" >
					<xsl:copy-of select="." />
				</xsl:for-each>
			</queue2>		
		</context>
	</xsl:template>	
	
	<!-- drop first n messages -->
	<xsl:template name="queue2.drop" >
		<xsl:param name="n"/>
		<xsl:variable name="qsize" >
			<xsl:call-template name="queue2.size"></xsl:call-template>
		</xsl:variable>
		<xsl:if test="$qsize &gt; $n" >
			<xsl:variable name="idxStart" select="$qsize - $n" />
			<context>
				<queue2>
					<xsl:for-each select="$context/queue2/q[$idxStart]/following-sibling::*" >
						<xsl:copy-of select="." />
					</xsl:for-each>
				</queue2>		
			</context>
		</xsl:if>		
	</xsl:template>		
	
	
	
</xsl:stylesheet>