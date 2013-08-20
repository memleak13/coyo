<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">


	<xsl:template name="getAttribute">
	
		<xsl:param name="attrName"/>
		<xsl:param name="attrText"/>
		<xsl:param name="attrSubject"/>
		<xsl:param name="attrSeverity"/>
		<xsl:param name="attrEngineID"/>
        <xsl:param name="attrBuInfo1"/>
        <xsl:param name="attrBuInfo2"/>
        <xsl:param name="attrBuInfo3"/>
		<xsl:param name="attrBuInfo4"/>
        <xsl:param name="attrService"/>

		<xsl:variable name="notification.filter" select="$context/notification-filter" />
		<xsl:variable name="traps" select="$notification.filter/traps"/>


                
	
		<xsl:variable name="severity" select="$attrSeverity"/>
		
		
		<xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
		<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	
		
		<xsl:variable name="subject"  select="translate($attrSubject,$uppercase,$smallcase)"/>
		<xsl:variable name="text"  select="translate($attrText,$uppercase,$smallcase)"/>
		<xsl:variable name="engine" select="translate($attrEngineID,$uppercase,$smallcase)"/>
		<xsl:variable name="buinfo1" select="translate($attrBuInfo1,$uppercase,$smallcase)"/>
		<xsl:variable name="buinfo2" select="translate($attrBuInfo2,$uppercase,$smallcase)"/>
		<xsl:variable name="buinfo3" select="translate($attrBuInfo3,$uppercase,$smallcase)"/>
		<xsl:variable name="buinfo4" select="translate($attrBuInfo4,$uppercase,$smallcase)"/>
		
		<xsl:variable name="test" select="
		
				$traps/trap[
				
							(
								( 
									boolean(severity/@lower)
								and
									$severity &lt; severity/@lower
								)
								
								or
								
								  ( 
									  boolean(severity/@greater)
								   and
									  $severity &gt; severity/@greater
								  )
								
								or
								
								  (  	
									(
										not( boolean( severity/@lower ) )
										
									  and
									  
										not( boolean( severity/@greater ) )
										
									  and
									  
									    boolean( severity/@equal )
									    
									)
									
									and						
									severity[@equal = $severity]
									
								  )
								
								or
								(
								
									not ( boolean ( severity ) )
								
								)
							)
							
							and(
								( 
									boolean(text/@contains) 
								and 
									text[contains($text,translate(@contains,$uppercase,$smallcase)  )]
								)

								or
								
								( 
									boolean(text/@without) 
								and 
									text[not ( contains($text,translate(@contains,$uppercase,$smallcase) ) )]
								)
								
								or
								  ( 
									boolean(text/@equal) 
								  and 
									text[$text = translate(@equal,$uppercase,$smallcase)]
								  )	

								or
								  ( 
									boolean(text/@unequal) 
								  and 
									text[not ( $text = translate(@equal,$uppercase,$smallcase) )]
								  )
								  
								or
								  (
									not ( boolean( text ) )
								  )			
							)
		

							and(
								( 
									boolean(subject/@contains) 
								  and 
									subject[contains($subject,translate(@contains,$uppercase,$smallcase))]
								)
				
								or
								(
								
									boolean(subject/@equal) 
								  and
									subject[$subject=translate(@equal,$uppercase,$smallcase)]
								
									
								)
								
								or
								(
									not ( boolean ( subject ) )
								)
							)

                            
							and(
								( 
									boolean(engineId/@contains) 
								  and 
									engineId[contains($engine,translate(@contains,$uppercase,$smallcase))]
								)
				
								or
								(
								
									boolean(engineId/@equal) 
								  and
									engineId[$engine=translate(@equal,$uppercase,$smallcase)]
								
									
								)
								
								or
								(
									not ( boolean ( engineId ) )
								)
							)                            

							and(
								( 
									boolean(buinfo1/@contains) 
								  and 
									buinfo1[contains($buinfo1,translate(@contains,$uppercase,$smallcase))]
								)
				
								or
								(
								
									boolean(buinfo1/@equal) 
								  and
									buinfo1[$buinfo1=translate(@equal,$uppercase,$smallcase)]
								
									
								)
								
								or
								(
									not ( boolean ( buinfo1 ) )
								)
							) 
							
							
							and(
								( 
									boolean(buinfo2/@contains) 
								  and 
									buinfo2[contains($buinfo2,translate(@contains,$uppercase,$smallcase))]
								)
				
								or
								(
								
									boolean(buinfo2/@equal) 
								  and
									buinfo2[$buinfo2=translate(@equal,$uppercase,$smallcase)]
								
									
								)
								
								or
								(
									not ( boolean ( buinfo2 ) )
								)
							)


							and(
								( 
									boolean(buinfo3/@contains) 
								  and 
									buinfo3[contains($buinfo3,translate(@contains,$uppercase,$smallcase))]
								)
				
								or
								(
								
									boolean(buinfo3/@equal) 
								  and
									buinfo3[$buinfo3=translate(@equal,$uppercase,$smallcase)]
								
									
								)
								
								or
								(
									not ( boolean ( buinfo3 ) )
								)
							)


							and(
								( 
									boolean(buinfo4/@contains) 
								  and 
									buinfo4[contains($buinfo4,translate(@contains,$uppercase,$smallcase))]
								)
				
								or
								(
								
									boolean(buinfo4/@equal) 
								  and
									buinfo4[$buinfo4=translate(@equal,$uppercase,$smallcase)]
								
									
								)
								
								or
								(
									not ( boolean ( buinfo4 ) )
								)
							)
							
                            
                            and(
								(
								
									boolean(attrService/@equal) 
								  and
									attrService[$attrService=@equal]
								
									
								)
								
								or
								(
									not ( boolean ( attrService ) )
								)
							)                            
							
							]
				
		"/>		
		
		<xsl:choose>
		
			<xsl:when test="boolean($test)">
				<xsl:choose>
					<xsl:when test="boolean($test/@*[name(.)=$attrName])">
						<xsl:value-of select="$test/@*[name(.)=$attrName]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$traps/@*[name(.)=$attrName]"/>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:when>
			
			<xsl:otherwise>
				<xsl:value-of select="$traps/@*[name(.)=$attrName]"/>
			</xsl:otherwise>
			
		</xsl:choose>


		
	</xsl:template>
	
	



</xsl:stylesheet>