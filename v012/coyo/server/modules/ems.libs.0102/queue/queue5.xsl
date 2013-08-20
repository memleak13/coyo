<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="queue5.init">
		<context >
			<queue5/>
		</context>
	</xsl:template>
	
	<xsl:template name="queue5.clear">
		<context >
			<queue5/>
		</context>
	</xsl:template>

	<xsl:template name="queue5.size">
		<xsl:value-of select="count($context/queue5/q)" />
	</xsl:template>

	<!-- Retrieves, but does not remove, the head of this queue -->
	<!--	select="$context/queue5/q[1]/*"-->
	<!--                                   -->


	<!-- add the element 'el to the tail of the queue -->
	<xsl:template name="queue5.add" >
		<xsl:param name="el" />
		<xsl:if test="boolean($el)" >
			<context>
				<queue5>
					<xsl:for-each select="$context/queue5/q">
						<xsl:copy-of select="." />
					</xsl:for-each>
					<q>
						<xsl:copy-of select="$el" />
					</q>					
				</queue5>		
			</context>
		</xsl:if>
	</xsl:template>	

	<xsl:template name="queue6.cloneChilds" >
		<xsl:for-each select="$context/queue6/q">
			<xsl:copy-of select="." />
		</xsl:for-each>
	</xsl:template>	

	<xsl:template name="queue6.append" >
		<xsl:param name="el" />
		<xsl:if test="boolean($el)" >
			<q>
				<xsl:copy-of select="$el" />
			</q>					
		</xsl:if>
	</xsl:template>	

	<!-- Remove the first element from the queue. -->
	<xsl:template name="queue5.remove" >
		<context>
			<queue5>
				<xsl:for-each select="$context/queue5/q[1]/following-sibling::*" >
					<xsl:copy-of select="." />
				</xsl:for-each>
			</queue5>		
		</context>
	</xsl:template>	
	
	<!-- drop first n messages -->
	<xsl:template name="queue5.drop" >
		<xsl:param name="n"/>
		<xsl:variable name="qsize" >
			<xsl:call-template name="queue5.size"></xsl:call-template>
		</xsl:variable>
		<xsl:if test="$qsize &gt; $n" >
			<xsl:variable name="idxStart" select="$qsize - $n" />
			<context>
				<queue5>
					<xsl:for-each select="$context/queue5/q[$idxStart]/following-sibling::*" >
						<xsl:copy-of select="." />
					</xsl:for-each>
				</queue5>		
			</context>
		</xsl:if>		
	</xsl:template>		
	
	
</xsl:stylesheet>