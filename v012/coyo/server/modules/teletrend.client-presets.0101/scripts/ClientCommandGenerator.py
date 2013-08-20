import XmlGenTool
from xlrd import open_workbook
from collections import defaultdict


#utah router 
cntOutputs=144
cntInputs=144

#tvips
numOfTvips=5

#axon related
numOfPossibleSlots=18
frameNumbers=[1,2,3,7]

#barionet related

existingAlarmLampEngines=['alarmlamp']


def getOutputMappings(list,outputMappingFile,mappingTableIdx):
    
    row_idx_phys_outNum=0
    row_idx_logi_outNum=1
    
    wb=open_workbook(outputMappingFile)
    sheet=wb.sheet_by_index(mappingTableIdx)
    
    for row in range(1,sheet.nrows):
        list.insert(int(sheet.cell(row,row_idx_phys_outNum).value),str(int(sheet.cell(row,row_idx_logi_outNum).value)))
    
    return

    

def createLampClientCmds(xmlGen,existingAlarmLampEngines):   
    
    xmlGen.addLine(0,'')   
    
    
    for engine in existingAlarmLampEngines:
                    
        xmlGen.addLine(1,'<client-cmd type="'+engine+'.activate.all.lamps">')
        xmlGen.addLine(2,'<io:setOutput xmlns:io="http://euromedia-service.de/coyoNET/io/" engine="'+engine+'" >')
        xmlGen.addLine(3,'<io:Port num="3" type="Relay" val="1" />')
        xmlGen.addLine(3,'<io:Port num="2" type="Relay" val="1" />')
        xmlGen.addLine(3,'<io:Port num="1" type="Relay" val="1" />')
        xmlGen.addLine(2,'</io:setOutput>')
        xmlGen.addLine(1,'</client-cmd>')
    
        xmlGen.addLine(1,'<client-cmd type="'+engine+'.deactivate.all.lamps">')
        xmlGen.addLine(2,'<io:setOutput xmlns:io="http://euromedia-service.de/coyoNET/io/" engine="'+engine+'" >')
        xmlGen.addLine(3,'<io:Port num="3" type="Relay" val="0" />')
        xmlGen.addLine(3,'<io:Port num="2" type="Relay" val="0" />')
        xmlGen.addLine(3,'<io:Port num="1" type="Relay" val="0" />')
        xmlGen.addLine(2,'</io:setOutput>')
        xmlGen.addLine(1,'</client-cmd>')
    
        xmlGen.addLine(1,'<client-cmd type="'+engine+'.code.red">')
        xmlGen.addLine(2,'<io:setOutput xmlns:io="http://euromedia-service.de/coyoNET/io/" engine="'+engine+'" >')
        xmlGen.addLine(3,'<io:Port num="4" type="Relay" val="1" />')
        xmlGen.addLine(3,'<io:Port num="3" type="Relay" val="0" />')
        xmlGen.addLine(3,'<io:Port num="2" type="Relay" val="0" />')
        xmlGen.addLine(3,'<io:Port num="1" type="Relay" val="1" />')
        xmlGen.addLine(2,'</io:setOutput>')
        xmlGen.addLine(1,'</client-cmd>')
    
        xmlGen.addLine(1,'<client-cmd type="'+engine+'.code.yellow">')
        xmlGen.addLine(2,'<io:setOutput xmlns:io="http://euromedia-service.de/coyoNET/io/" engine="'+engine+'" >')
        xmlGen.addLine(3,'<io:Port num="4" type="Relay" val="1" />')
        xmlGen.addLine(3,'<io:Port num="3" type="Relay" val="0" />')
        xmlGen.addLine(3,'<io:Port num="2" type="Relay" val="1" />')
        xmlGen.addLine(3,'<io:Port num="1" type="Relay" val="0" />')
        xmlGen.addLine(2,'</io:setOutput>')
        xmlGen.addLine(1,'</client-cmd>')
    
        xmlGen.addLine(1,'<client-cmd type="'+engine+'.code.green">')
        xmlGen.addLine(2,'<io:setOutput xmlns:io="http://euromedia-service.de/coyoNET/io/" engine="'+engine+'" >')
        xmlGen.addLine(3,'<io:Port num="4" type="Relay" val="0" />')
        xmlGen.addLine(3,'<io:Port num="3" type="Relay" val="1" />')
        xmlGen.addLine(3,'<io:Port num="2" type="Relay" val="0" />')
        xmlGen.addLine(3,'<io:Port num="1" type="Relay" val="0" />')
        xmlGen.addLine(2,'</io:setOutput>')
        xmlGen.addLine(1,'</client-cmd>')
        
        xmlGen.addLine(0,'')
             
    return
    



def createTvipsClientCommands(xmlGen):
    
    for i in range(1,numOfTvips+1): 
        xmlGen.addLine(0,'')
        xmlGen.addLine(1,'<client-cmd')
        xmlGen.addLine(2,'type="smart-switch-'+str(i)+'.1.fixA" >')
        xmlGen.addLine(4,'<setMode relay="1" value="FixA" engineID="asi-switch-'+str(i)+'" />')    
        xmlGen.addLine(1,'</client-cmd>')    
        
        xmlGen.addLine(1,'<client-cmd')
        xmlGen.addLine(2,'type="smart-switch-'+str(i)+'.1.fixB" >')
        xmlGen.addLine(4,'<setMode relay="1" value="FixB" engineID="asi-switch-'+str(i)+'" />')

        xmlGen.addLine(1,'</client-cmd>')    
    
        xmlGen.addLine(1,'<client-cmd')
        xmlGen.addLine(2,'type="smart-switch-'+str(i)+'.1.autoA" >')
        xmlGen.addLine(4,'<setMode relay="1" value="AutoA" engineID="asi-switch-'+str(i)+'" />')    
        xmlGen.addLine(1,'</client-cmd>')    
        
        xmlGen.addLine(1,'<client-cmd')
        xmlGen.addLine(2,'type="smart-switch-'+str(i)+'.1.autoB" >')
        xmlGen.addLine(4,'<setMode relay="1" value="AutoB" engineID="asi-switch-'+str(i)+'" />')
        xmlGen.addLine(1,'</client-cmd>')    
    
        xmlGen.addLine(1,'<client-cmd')
        xmlGen.addLine(2,'type="smart-switch-'+str(i)+'.2.fixA" >')

        xmlGen.addLine(4,'<setMode relay="2" value="FixA" engineID="asi-switch-'+str(i)+'" />')
    
        xmlGen.addLine(1,'</client-cmd>')    
        
        xmlGen.addLine(1,'<client-cmd')
        xmlGen.addLine(2,'type="smart-switch-'+str(i)+'.2.fixB" >')

        xmlGen.addLine(4,'<setMode relay="2" value="FixB" engineID="asi-switch-'+str(i)+'" />')
    
        xmlGen.addLine(1,'</client-cmd>')    
    
        xmlGen.addLine(1,'<client-cmd')
        xmlGen.addLine(2,'type="smart-switch-'+str(i)+'.2.autoA" >')

        xmlGen.addLine(4,'<setMode relay="2" value="AutoA" engineID="asi-switch-'+str(i)+'" />')
    
        xmlGen.addLine(1,'</client-cmd>')    
        
        xmlGen.addLine(1,'<client-cmd')
        xmlGen.addLine(2,'type="smart-switch-'+str(i)+'.2.autoB" >')

        xmlGen.addLine(4,'<setMode relay="2" value="AutoB" engineID="asi-switch-'+str(i)+'" />')
    
        xmlGen.addLine(1,'</client-cmd>')    
        
        xmlGen.addLine(0,'')   
    return
    

def createTwoGf200ClientCmds(xmlGen,numOfPossibleSlots,frameNumbers):
    
    
    
    xmlGen.addLine(0,'')   

    for frame in frameNumbers:
        for i in range(1,numOfPossibleSlots+1):
            
            xmlGen.addLine(1,'<client-cmd')
            xmlGen.addLine(2,'type="axon_'+str(frame)+'.twoGF200.'+str(i)+'.Input.A" >')
            xmlGen.addLine(3,'<setTwoGf200Input engine="axon_'+str(frame)+'" >')
            xmlGen.addLine(3,'<setPreset engine="axon_'+str(frame)+'" preset="one" cardindex="' +str(i)+ '" />' )
            xmlGen.addLine(3,'</setTwoGf200Input >')    
            xmlGen.addLine(1,'</client-cmd>')
            
            xmlGen.addLine(1,'<client-cmd')
            xmlGen.addLine(2,'type="axon_'+str(frame)+'.twoGF200.'+str(i)+'.Input.B" >')
            xmlGen.addLine(3,'<setTwoGf200Input engine="axon_'+str(frame)+'" >')
            xmlGen.addLine(4,'<setPreset engine="axon_'+str(frame)+'" preset="two" cardindex="'+str(i)+'" />')
            xmlGen.addLine(3,'</setTwoGf200Input >')    
            xmlGen.addLine(1,'</client-cmd>')
        
        xmlGen.addLine(0,'')
    
    
        
        
    xmlGen.addLine(1,'<client-cmd')
    xmlGen.addLine(2,'type="All.twoGF200.Input.A" >')
    for frame in frameNumbers:                
        xmlGen.addLine(3,'<setTwoGf200Input engine="axon_'+str(frame)+'" >')
        for i in range(1,numOfPossibleSlots+1):
                xmlGen.addLine(3,'<setPreset engine="axon_'+str(frame)+'" preset="one" cardindex="' +str(i)+ '" />' )    
        xmlGen.addLine(3,'</setTwoGf200Input >')    
    xmlGen.addLine(1,'</client-cmd>')

    xmlGen.addLine(1,'<client-cmd')
    xmlGen.addLine(2,'type="All.twoGF200.Input.B" >')
    for frame in frameNumbers:                
        xmlGen.addLine(3,'<setTwoGf200Input engine="axon_'+str(frame)+'" >')
        for i in range(1,numOfPossibleSlots+1):
                xmlGen.addLine(3,'<setPreset engine="axon_'+str(frame)+'" preset="two" cardindex="' +str(i)+ '" />' )    
        xmlGen.addLine(3,'</setTwoGf200Input >')    
    xmlGen.addLine(1,'</client-cmd>')

    
            
    xmlGen.addLine(0,'')         
    
    
    return
    
       
def createNcompassClientCmds(xmlGen):
    
    xmlGen.addLine(0,'')   

    xmlGen.addLine(1,'<client-cmd')
    xmlGen.addLine(2,'type="ncompass.zdf.dvbs.prof.1" >')
    xmlGen.addLine(3,'<ncompass-profile-service-activate name="01 ZDF DVB-S Profile 1" nid="1" onid="1" tsid="1079" sid="28006" />')    
    xmlGen.addLine(1,'</client-cmd>')    
    
    xmlGen.addLine(1,'<client-cmd')
    xmlGen.addLine(2,'type="ncompass.zdf.dvbs.prof.2" >')
    xmlGen.addLine(3,'<ncompass-profile-service-activate name="01 ZDF DVB-S Profile 2" nid="1" onid="1" tsid="1079" sid="28006" />')    
    xmlGen.addLine(1,'</client-cmd>')    
                
    xmlGen.addLine(0,'')
         
    return


def createSigGenClientCmds(xmlGen):

    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen1.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="31" input="4" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="51" input="4" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen1.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="31" input="3" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="51" input="3" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen2.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="32" input="2" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="52" input="2" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen2.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="32" input="1" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="52" input="1" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')

    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen3.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="83" input="6" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="84" input="6" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen3.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="83" input="5" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="84" input="5" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')

    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen4.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="34" input="8" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="54" input="8" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen4.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="34" input="7" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="54" input="7" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')

    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen5.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="35" input="10" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="55" input="10" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen5.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="35" input="9" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="55" input="9" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')

    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen8.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="40" input="16" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="60" input="16" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen8.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="40" input="15" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="60" input="15" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen9.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="41" input="18" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="61" input="18" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen9.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="41" input="17" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="61" input="17" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen.Fab.1.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="26" input="51" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="78" input="51" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="36" input="74" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="56" input="74" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen.Fab.1.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="23" input="51" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="75" input="51" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="36" input="71" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="56" input="71" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen.Fab.2.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="26" input="59" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="78" input="51" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="37" input="74" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="57" input="74" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen.Fab.2.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="24" input="59" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="76" input="51" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="37" input="72" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="57" input="72" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen.Fab.3.Backup" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="26" input="63" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="78" input="51" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="38" input="74" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="58" input="74" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    xmlGen.addLine(3,'<client-cmd')
    xmlGen.addLine(3,'type="SigGen.Fab.3.Restore" >')
    xmlGen.addLine(3,'<SigGen-Crosspoints>')
    xmlGen.addLine(4,'<setCross output="25" input="63" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="77" input="51" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="38" input="73" level="1" router="asi-router" />')
    xmlGen.addLine(4,'<setCross output="58" input="73" level="1" router="asi-router" />')
    xmlGen.addLine(3,'</SigGen-Crosspoints>')
    xmlGen.addLine(3,'</client-cmd>')
    
    
    
    return

def createRouterClientCmds(xmlGen):
    
    
    idx_sksII_table=1
    outputMapping=[]
    getOutputMappings(outputMapping,'phys2logicalCrosspointMapping.xls',idx_sksII_table)
    
    
    xmlGen.addLine(0,'<!-- Router Client Commands -->')
    xmlGen.addLine(1,'<!-- SDI-Router-Primary  -->')
    xmlGen.addLine(0,'')
    
    for outputNum in range(cntOutputs):
        output=str(outputNum+1) 
        for inputNum in range(cntInputs):
            input=str(inputNum+1)
            xmlGen.addLine(1,'<client-cmd')
            xmlGen.addLine(1,'type="sdi-router-p.setcrosspoint_'+output+'_'+input+'" >')
            xmlGen.addLine(4,'<setCross output="'+output+'" input="'+input+'" level="1" router="sdi-router-p" />')    
            xmlGen.addLine(1,'</client-cmd>')            
            

    xmlGen.addLine(0,'')
    xmlGen.addLine(1,'<!-- SDI-Router-Secondary  -->')        
    for outputNum in range(cntOutputs):
        output=str(outputNum+1) 
        for inputNum in range(cntInputs):
            input=str(inputNum+1)
            xmlGen.addLine(1,'<client-cmd')
            xmlGen.addLine(1,'type="sdi-router-s.setcrosspoint_'+output+'_'+input+'" >')
            xmlGen.addLine(4,'<setCross output="'+str(outputMapping[outputNum])+'" input="'+input+'" level="2" router="sdi-router-s" />')    
            xmlGen.addLine(1,'</client-cmd>')     

    xmlGen.addLine(0,'')            
    xmlGen.addLine(1,'<!-- Asi-Router  -->')        
    for outputNum in range(cntOutputs):
        output=str(outputNum+1) 
        for inputNum in range(cntInputs):
            input=str(inputNum+1)
            xmlGen.addLine(1,'<client-cmd')
            xmlGen.addLine(1,'type="asi-router.setcrosspoint_'+output+'_'+input+'" >')
            xmlGen.addLine(4,'<setCross output="'+output+'" input="'+input+'" level="1" router="asi-router" />')    
            xmlGen.addLine(1,'</client-cmd>')    
                
    xmlGen.addLine(0,'')
    return                   
  
def createEvertsVideoMix(xmlGen):
    
    
    xmlGen.addLine(0,'<!-- Everts Video Mixer Client Commands -->')
    xmlGen.addLine(0,'')
    
    xmlGen.addLine(1,'<client-cmd')
    xmlGen.addLine(1,'type="mixer-1:SELECT_0" >')
    xmlGen.addLine(4,'<evertz.videomix.select.input current.input.mib.name="iobox1.barix.barionet.DI.1" current.input.mib.value="0"  iobox.engine="iobox1" relay.number="1" relay.state="1" relay.pulsetime="1.0" />')    
    xmlGen.addLine(1,'</client-cmd>')    

    xmlGen.addLine(1,'<client-cmd')
    xmlGen.addLine(1,'type="mixer-1:SELECT_1" >')
    xmlGen.addLine(4,'<evertz.videomix.select.input current.input.mib.name="iobox1.barix.barionet.DI.1" current.input.mib.value="1"  iobox.engine="iobox1" relay.number="1" relay.state="1" relay.pulsetime="1.0" />')    
    xmlGen.addLine(1,'</client-cmd>')    

                
    xmlGen.addLine(0,'')
    return    
  
def createKKSNormal(xmlGen):
    cp={100:22, 101:100, 102:138, 103:103, 104:102, 105:101, 106:28, 107:113, 108:139, 109:112, 110:110, 111:111}
    
    xmlGen.addLine(0,'<!-- KKS Switch -->')
    xmlGen.addLine(0,'')
    
    
    xmlGen.addLine(1,'<client-cmd type="KKS_NORMAL" >')
    for d in cp.keys():
        s=cp[d]
        xmlGen.addLine(4,'<setCross output="'+str(d)+'" input="'+str(s)+'" level="1" router="sdi-router-p" />')    
        xmlGen.addLine(4,'<setCross output="'+str(d)+'" input="'+str(s)+'" level="2" router="sdi-router-s" />')    
    
    xmlGen.addLine(1,'</client-cmd>')    


                
    xmlGen.addLine(0,'')
    return      
  
def createKKSBackup1(xmlGen):
    cp={100:125, 101:104, 102:19, 103:105, 104:105, 105:105, 106:126, 107:115, 108:25, 109:114, 110:114, 111:114}
    
    xmlGen.addLine(0,'<!-- KKS Switch -->')
    xmlGen.addLine(0,'')
    
    
    xmlGen.addLine(1,'<client-cmd type="KKS_BACKUP_1" >')
    for d in cp.keys():
        s=cp[d]
        xmlGen.addLine(4,'<setCross output="'+str(d)+'" input="'+str(s)+'" level="1" router="sdi-router-p" />')    
        xmlGen.addLine(4,'<setCross output="'+str(d)+'" input="'+str(s)+'" level="2" router="sdi-router-s" />')    
    
    xmlGen.addLine(1,'</client-cmd>')    


                
    xmlGen.addLine(0,'')
    return      
  
  
def createClientCmds():
    xmlGen = XmlGenTool.XmlGen('commands.xml')
    xmlGen.addLine(0,'<client-commands>')
    xmlGen.addLine(0,'')
    
    createRouterClientCmds(xmlGen) 
    #createNcompassClientCmds(xmlGen)
    createTvipsClientCommands(xmlGen)
    createTwoGf200ClientCmds(xmlGen,numOfPossibleSlots,frameNumbers)
    #createLampClientCmds(xmlGen,existingAlarmLampEngines)
    createEvertsVideoMix(xmlGen)
    createSigGenClientCmds(xmlGen)
    createKKSNormal(xmlGen)
    createKKSBackup1(xmlGen)
    
    xmlGen.addLine(0,'</client-commands>')
    xmlGen.addLine(0,'')
    xmlGen.close()
    return
        
createClientCmds()

