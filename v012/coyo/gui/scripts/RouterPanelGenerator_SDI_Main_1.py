#defines output encoding 
# -*- coding: utf-8 -*-

import codecs
import XmlGenTool
from protected_outputs import *


from xlrd import open_workbook
from collections import defaultdict



cntInputs=144
cntSubMenuEntries=16
curLevel=1
engine="sdi-router-p"
alarmEngine="alarm.sdi-router-p"


output_start_num=1
x_start=0
y_start=0

x_border_sz=10
y_border_sz=10

disp_w=180
disp_h=70

delta_x=10
delta_y=15

numRows=8
numColumns=9
            
border_style="RaisedBevelBorder"         
header_1="SDI-Router"
header_1_sz=28

header_2="main"   
header_2_sz=26

nav_img_width=64
nav_img_height=64

outFileName="gui/maps/dvb_sdi_router_main_1.xml"
mapName="DVB_Kreuz_SDI_1"

previous_Map=""
nav_left_img_name="arrow-left.png"

next_Map="DVB_Kreuz_SDI_2"
nav_right_img_name="arrow-right.png"

#primary router element color
element_color="d9d9d9"

#secondary router element color
#element_color="9c9c9c"


server_ip="172.25.154.72"


#primary sdi - router 
col_idx_grp=9
col_idx_sigName=10
col_idx_inputNum=13
col_idx_outName=16

fileName='currList.xls'
sheetIdx=0

startOffset=2

def getSubMenuEntries(dic):
    
    wb=open_workbook(fileName)
    sheet=wb.sheet_by_index(sheetIdx)

    for row in range(startOffset,sheet.nrows):
        if not str(sheet.cell(row,col_idx_inputNum).value)=='':   
            if not str(sheet.cell(row,col_idx_grp).value)=='':
                    dic[sheet.cell(row,col_idx_grp).value].append(str(sheet.cell(row,col_idx_sigName).value)+'_'+str(int(sheet.cell(row,col_idx_inputNum).value)))
            else:         
                dic['UNGROUPED'].append(str(sheet.cell(row,col_idx_sigName).value)+'_'+str(int(sheet.cell(row,col_idx_inputNum).value)))
    
    return

def getOutputNames(list):
    
    wb=open_workbook(fileName)
    sheet=wb.sheet_by_index(sheetIdx)
    
    for row in range(startOffset,sheet.nrows):
        if not str(sheet.cell(row,col_idx_inputNum).value)=='': 
            list.insert(int(sheet.cell(row,col_idx_inputNum).value),sheet.cell(row,col_idx_outName).value)
    
    return


def createMap():
    
    subMenuEntries=defaultdict(list)
    getSubMenuEntries(subMenuEntries)
    
    outputNames=[]
    getOutputNames(outputNames)

    
    heading_sz=nav_img_width #pay attention that a bigger heading sz than navigation img sz causes headaches :) 
    x_border_offset=x_start+x_border_sz
    y_border_offset=y_start+y_border_sz
    
    xmlGen = XmlGenTool.XmlGen(outFileName)
    xmlGen.addLine(0, '<map label="'+mapName+'">')
    
    
    
    for column in range(numColumns):
        x=str(column+1)
        for row in range(numRows):
            y=str(row+1)
            outputNr=row+output_start_num+column*numRows
            
            xmlGen.addLine(1,' <element')
            xmlGen.addLine(2,'id="output'+str(outputNr)+'"')
            xmlGen.addLine(2,'type="de.euromedia_service.coyonet.plugin.Base"')
            xmlGen.addLine(2,'x="'+str(x_border_offset+row*(disp_w+delta_x))+'"')
            xmlGen.addLine(2,'y="'+str(heading_sz+y_border_offset+column*(disp_h+delta_y))+'"')
            xmlGen.addLine(2,'width="'+str(disp_w)+'"')
            xmlGen.addLine(2,'height="'+str(disp_h)+'"')
            xmlGen.addLine(2,'tree.Label="Output'+ str(outputNr)+'"')
            xmlGen.addLine(2,'tree.folder="Outputs"')                                
            xmlGen.addLine(2,'conf.style="none"')
            xmlGen.addLine(2,'conf.background.color="'+element_color+'"')
            xmlGen.addLine(2,'conf.border.style="LineBorder"')
            xmlGen.addLine(2,'conf.border.color="000000"')
            xmlGen.addLine(2,'conf.border.thickness="2"')                
            xmlGen.addLine(2,'conf.label=""')
            xmlGen.addLine(2,'input.state="'+alarmEngine+'.state"')
            xmlGen.addLine(2,'input.selectedInput="'+engine+'.level'+str(curLevel)+'.crosspoint.'+ str(outputNr)+'.input"' )
            xmlGen.addLine(2,'input.inputService="label.server.'+engine+'.OutputPort.'+str(outputNr)+'.name" >')
            xmlGen.addLine(3,'<label')
            xmlGen.addLine(4,'x="2"')
            xmlGen.addLine(4,'y="2"')              
            xmlGen.addLine(4,'width="'+str(disp_w-4)+'"')
            xmlGen.addLine(4,'height="'+str(disp_h/5-2)+'"')#13
            xmlGen.addLine(4,'conf.label="Output'+ str(outputNr)+'"')
            xmlGen.addLine(4,'conf.font.name="Arial"')
            xmlGen.addLine(4,'conf.font.size="12"')
            xmlGen.addLine(4,'conf.alignment.horizontal="Center"')
            xmlGen.addLine(4,'conf.alignment.vertical="Center"')                    
            xmlGen.addLine(4,'conf.border.style="LineBorder"')
            xmlGen.addLine(4,'conf.border.color="'+element_color+'"')
            xmlGen.addLine(4,'conf.border.thickness="0"')                    
            xmlGen.addLine(4,'conf.background.color="000000"')
            xmlGen.addLine(4,'conf.foreground.color="000000">')                    
            xmlGen.addLine(3,'>')
            xmlGen.addLine(4,'<text>'+ str(outputNr)+'</text>')
            xmlGen.addLine(3,'</label>')
            xmlGen.addLine(3,'<label')
            xmlGen.addLine(4,'x="2"') 
            xmlGen.addLine(4,'y="'+str(disp_h/5-2)+'"')                
            xmlGen.addLine(4,'width="'+str(disp_w-4)+'"')
            xmlGen.addLine(4,'height="'+str(disp_h/5+4)+'"')#13                                
            xmlGen.addLine(4,'conf.font.name="Arial"')
            xmlGen.addLine(4,'conf.font.size="12"')
            xmlGen.addLine(4,'conf.alignment.horizontal="Center"')
            xmlGen.addLine(4,'conf.alignment.vertical="Center"')                    
            xmlGen.addLine(4,'conf.border.style="LineBorder"')
            xmlGen.addLine(4,'conf.border.color="'+element_color+'"')
            xmlGen.addLine(4,'conf.border.thickness="0"')                    
            xmlGen.addLine(4,'conf.background.color="000000"')
            xmlGen.addLine(4,'conf.foreground.color="000000"')                                
            xmlGen.addLine(3,'>')
            
            if (len(outputNames[(outputNr)-1]) > 0):
                xmlGen.addLine(4,'<text>'+outputNames[(outputNr)-1]+'</text>')
            else:
                xmlGen.addLine(4,'<text>nicht vergeben</text>')
            
            
            xmlGen.addLine(3,'</label>')
            xmlGen.addLine(3,'<label')
            xmlGen.addLine(4,'x="6"')
            xmlGen.addLine(4,'y="32"')                
            xmlGen.addLine(4,'width="'+str(disp_w-12)+'"')
            xmlGen.addLine(4,'height="'+str((disp_h*3/5)-10)+'"')
            xmlGen.addLine(4,'conf.name="Destination'+ str(outputNr)+'"')                       
            xmlGen.addLine(4,'conf.font.name="Arial"')
            xmlGen.addLine(4,'conf.font.size="12"')            
            xmlGen.addLine(4,'conf.alignment.horizontal="Center"')
            xmlGen.addLine(4,'conf.alignment.vertical="Center"')                    
            xmlGen.addLine(4,'conf.border.style="'+border_style+'"')                                        
            xmlGen.addLine(4,'conf.foreground.color="000000">')                    
            xmlGen.addLine(3,'>')
            xmlGen.addLine(4,'<text>{$selectedInput} : {$inputService}</text>')
            if outputNr in protectedOutputs:
                xmlGen.addLine(4,'<foreground-color ')
                xmlGen.addLine(4,'input="systemmgr.ok"') 
                xmlGen.addLine(4,'default="FF0000" >')
                            
                xmlGen.addLine(5,'<map')
                xmlGen.addLine(5,'input.value="5"')
                xmlGen.addLine(5,'color="FF0000" >')
                xmlGen.addLine(5,'</map>')
                xmlGen.addLine(4,'</foreground-color >')
            xmlGen.addLine(3,'<menu')
            xmlGen.addLine(4,'label="Source Selection">')
                                    
            grpNames=subMenuEntries.keys()
            grpNames.sort()
            for group in grpNames :
                #prevents from being able to route reentry input to output
                if not ((outputNr > 99 and outputNr < 112) and (group=='SL SD' or group=='SL HD')):
                    if len(group)>0:
                        xmlGen.addLine(5,'<menu')                                               
                        xmlGen.addLine(6,'label="'+str(group)+'" >')                        
                                        
                        for sigLabel in subMenuEntries[group]:
                            if len(sigLabel)>0:
                                    
                                #print val
                                #print val.split('_')[0]+' ('+val.split('_')[1]+')'
                                xmlGen.addLine(7,'<menu-item')
                                xmlGen.addLine(8,'label="'+sigLabel.split('_')[0]+' ('+sigLabel.split('_')[1]+')"')
                                xmlGen.addLine(8,'action="de.euromedia_service.coyonet.sendcmd"')
                                xmlGen.addLine(8,'arg.id="'+engine+'.setcrosspoint_'+ str(outputNr)+'_'+sigLabel.split('_')[1]+'"')
                                if not outputNr in protectedOutputs:
                                    xmlGen.addLine(8,'arg.question="Do you really want to route to '+ sigLabel.split('_')[0]+' ('+sigLabel.split('_')[1]+')?"')
                                else:
                                    xmlGen.addLine(8,'arg.question="You are about to destroy a Reentry ! Are you really sure you know what you are doing ?"')    
                                xmlGen.addLine(7,'/>')    
                                xmlGen.addLine(7,'/>')    
                        xmlGen.addLine(5,'</menu>')               
                    
            xmlGen.addLine(3,'</menu>') 
            
            xmlGen.addLine(3,'</label>')                       
            xmlGen.addLine(1,'</element>')
            
            
            
            
           # for inputs in range(1,cntInputs+1,cntSubMenuEntries):
           #     xmlGen.addLine(5,'<menu')
           #     xmlGen.addLine(6,'label="Inputs: '+str(inputs)+'-'+str(inputs+cntSubMenuEntries-1)+'" >')    
           #     for curInputNum in range(cntSubMenuEntries):
           #         xmlGen.addLine(7,'<menu-item')
           ##         xmlGen.addLine(8,'label="Y'+ str(outputNr)+' - X'+str(inputs+curInputNum)+'"')
           #         xmlGen.addLine(8,'action="de.euromedia_service.coyonet.sendcmd"')
           #         xmlGen.addLine(8,'arg.id="'+engine+'.setcrosspoint_'+ str(outputNr)+'_'+str(inputs+curInputNum)+'"')
           ##         xmlGen.addLine(8,'arg.question="Do you really want to route output Y'+ str(outputNr)+' to input X'+str(inputs+curInputNum)+'?"')
           #         xmlGen.addLine(7,'/>')    
           #     xmlGen.addLine(5,'</menu>')
           # xmlGen.addLine(3,'</menu>') 
           # xmlGen.addLine(3,'</label>')                       
           # xmlGen.addLine(1,'</element>')
            
            
            
    xmlGen.addLine(1,'<element') 
    xmlGen.addLine(2,'id="'+engine+'"')
    xmlGen.addLine(2,'type="de.euromedia_service.coyonet.plugin.Base"')
    
     
    xmlGen.addLine(2,'x="'+str(x_start)+'"')
    xmlGen.addLine(2,'y="'+str(y_start)+'"')
    xmlGen.addLine(2,'width="'+str(numRows*disp_w+(numRows-1)*delta_x+2*x_border_offset)+'"')
    xmlGen.addLine(2,'height="'+str(numColumns*disp_h+(numColumns-1)*delta_y+2*y_border_offset+heading_sz)+'"')
        
    xmlGen.addLine(2,'tree.Label="'+engine+'"')
    xmlGen.addLine(2,'tree.folder="Router"')
        
    xmlGen.addLine(2,'conf.style="StateBorderRectangleRounded"')
    xmlGen.addLine(2,'conf.label="'+header_1+'"')
    xmlGen.addLine(2,'conf.label.height="28"')
    xmlGen.addLine(2,'conf.label2="'+header_2+'"')
    xmlGen.addLine(2,'conf.label2.height="26"')  
    xmlGen.addLine(2,'input.state="'+alarmEngine+'.state">')        
    xmlGen.addLine(1,'>')           
    if not(previous_Map==""):
        xmlGen.addLine(2,'<image')
        xmlGen.addLine(3,'x="'+str(x_border_offset)+'"')
        xmlGen.addLine(3,'y="'+str(y_border_offset)+'"')
        xmlGen.addLine(3,'width="'+str(nav_img_width)+'"')
        xmlGen.addLine(3,'height="'+str(nav_img_height)+'"')
        xmlGen.addLine(3,'conf.label="previous_navigator"')
        xmlGen.addLine(3,'conf.sys.map.show="'+previous_Map+'"')
        xmlGen.addLine(3,'conf.url.static="http://'+server_ip+'/coyonet/images/'+nav_left_img_name+'"')
        xmlGen.addLine(2,'/>')

    if not(next_Map==""):     
        xmlGen.addLine(2,'<image')
        xmlGen.addLine(3,'x="'+str(numRows*disp_w+(numRows-1)*delta_x-nav_img_width)+'"')
        xmlGen.addLine(3,'y="'+str(y_border_offset)+'"')
        xmlGen.addLine(3,'width="'+str(nav_img_width)+'"')
        xmlGen.addLine(3,'height="'+str(nav_img_width)+'"')
        xmlGen.addLine(3,'conf.label="next_navigator"')
        xmlGen.addLine(3,'conf.sys.map.show="'+next_Map+'"')
        xmlGen.addLine(3,'conf.url.static="http://'+server_ip+'/coyonet/images/'+nav_right_img_name+'"')
        xmlGen.addLine(2,'/>')

    xmlGen.addLine(1,'</element>')                    
    xmlGen.addLine(0,'</map>')

    
    
    
def readOutputNames(outputNames):
    
    
    file =codecs.open(pathOutputNames,"r","utf-8") 
    
    lineNum=0
    
    for line in file:
        lineNum+=1
        line=line.strip()
        if(len(line) > 0):         
            outputNames.insert(lineNum,line)
        else:
            outputNames.insert(lineNum,'not specified') 
    file.close()


createMap()



        


