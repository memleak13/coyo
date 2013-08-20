<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--
<xsl:variable name="host" select="'localhost'" />
-->
<xsl:variable name="host" select="'10.10.5.30'" />


<xsl:template match="/">
	<xsl:variable name="root" select="/*" />
	<html>
		<head>
			<title> NEC Monitoring </title>
			<link rel="StyleSheet" href="stylesheet.css" type="text/css" />
			<link rel="shortcut icon" href="logo.ico" />
			<script type="text/javascript" src="ajax.js" />
		</head>
		<body>
			<p> <img src="logo_kabeldeutschland_NEC_MON.png" alt="Kabel Deutschland NEC Monitoring" height="89" width="666" /> </p>
			<form>
                <input type="button" value="Home" onclick="window.location.href='http://{$host}:8080'" />
				<input type="button" value="Reload" onclick="window.location.reload()" />                
			</form>
			<xsl:apply-templates select="$root" mode="body" />
		</body>
	</html>
</xsl:template>


<xsl:template match="/logging" mode="body">
    <xsl:variable name="logID" select="string(@id)"/>
    <h2>Logging <xsl:value-of select="$logID" /></h2> 
    <a href="http://{$host}/necmon/log.php?id={$logID}&amp;raw" target="_blank" type="text/xml" >SAVE AS</a>

    <table>
        <tr>
            <td> <a href="http://{$host}/necmon/log.php?id=0">0</a> </td>
            <td> <a href="http://{$host}/necmon/log.php?id=1">1</a> </td>
            <td> <a href="http://{$host}/necmon/log.php?id=2">2</a> </td>
            <td> <a href="http://{$host}/necmon/log.php?id=3">3</a> </td>
            <td> <a href="http://{$host}/necmon/log.php?id=4">4</a> </td>
            <td> <a href="http://{$host}/necmon/log.php?id=5">5</a> </td>
            <td> <a href="http://{$host}/necmon/log.php?id=6">6</a> </td>
            <td> <a href="http://{$host}/necmon/log.php?id=7">7</a> </td>
            <td> <a href="http://{$host}/necmon/log.php?id=8">8</a> </td> 
            <td> <a href="http://{$host}/necmon/log.php?id=9">9</a> </td>            
        </tr>
    </table>       

<!--    
	<xsl:variable name="logfile" select="concat('http://{$host}/necmon/log.php?id=',$logID)" />
    <xsl:variable name="logging" select="document($logfile)" /> 	
 -->  
    <table>
		<tr>
            <th> Sequence </th>  
			<th> Date Time </th>
			<th> Level </th>
			<th> Message </th>
		</tr>
		<xsl:for-each select="record">
            <tr>
                <td align="right"> <xsl:value-of select="sequence" /> </td>
                <td align="left"> <xsl:value-of select="date" /> </td>
                <td align="left"> <xsl:value-of select="level" /> </td>
                <td align="left"> <xsl:value-of select="message" /> </td>
            </tr>
        </xsl:for-each>
    </table>


</xsl:template>




</xsl:stylesheet>
