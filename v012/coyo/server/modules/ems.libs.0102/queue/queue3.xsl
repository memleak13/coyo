<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="queue3.init">
		<context >
			<queue3/>
		</context>
	</xsl:template>
	
	<xsl:template name="queue3.clear">
		<context >
			<queue3/>
		</context>
	</xsl:template>

	<xsl:template name="queue3.size">
		<xsl:value-of select="count($context/queue3/q)" />
	</xsl:template>

	<!-- Retrieves, but does not remove, the head of this queue -->
	<!--	select="$context/queue3/q[1]/*"-->
	<!--                                   -->


	<!-- add the element 'el to the tail of the queue -->
	<xsl:template name="queue3.add" >
		<xsl:param name="el" />
		<xsl:if test="boolean($el)" >
			<context>
				<queue3>
					<xsl:for-each select="$context/queue3/q">
						<xsl:copy-of select="." />
					</xsl:for-each>
					<q>
						<xsl:copy-of select="$el" />
					</q>					
				</queue3>		
			</context>
		</xsl:if>
	</xsl:template>	

	<xsl:template name="queue3.cloneChilds" >
		<xsl:for-each select="$context/queue3/q">
			<xsl:copy-of select="." />
		</xsl:for-each>
	</xsl:template>	

	<xsl:template name="queue3.append" >
		<xsl:param name="el" />
		<xsl:if test="boolean($el)" >
			<q>
				<xsl:copy-of select="$el" />
			</q>					
		</xsl:if>
	</xsl:template>	

	<!-- Remove the first element from the queue. -->
	<xsl:template name="queue3.remove" >
		<context>
			<queue3>
				<xsl:for-each select="$context/queue3/q[1]/following-sibling::*" >
					<xsl:copy-of select="." />
				</xsl:for-each>
			</queue3>		
		</context>
	</xsl:template>	
	
	<!-- drop first n messages -->
	<xsl:template name="queue3.drop" >
		<xsl:param name="n"/>
		<xsl:variable name="qsize" >
			<xsl:call-template name="queue3.size"></xsl:call-template>
		</xsl:variable>
		<xsl:if test="$qsize &gt; $n" >
			<xsl:variable name="idxStart" select="$qsize - $n" />
			<context>
				<queue3>
					<xsl:for-each select="$context/queue3/q[$idxStart]/following-sibling::*" >
						<xsl:copy-of select="." />
					</xsl:for-each>
				</queue3>		
			</context>
		</xsl:if>		
	</xsl:template>		
	
	
</xsl:stylesheet>