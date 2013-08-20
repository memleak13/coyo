
import codecs
import XmlGenTool

from xlrd import open_workbook
from collections import defaultdict


numOfRows=4

num_elements_in_row =[ 
                       8,
                       8,
                       13,
                       13,
                     ]




element_props=[ 
                                                                    
                  #sks single switches row 1 (8)
                  
                  {'group':'sks-all',       'button-label':'KKS Normal', 'preset':'KKS_NORMAL', 'group-x-offset':'0','heading-y-offset':'50' },                  
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'100'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'101'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'102'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'103'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'104'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'105'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'106'     },
                  
                  #sks single switches row 2 (7)                  
                  {'engine':'sdi-router-p', 'group':'sks-all',         'button-label':'KKS Backup 1', 'preset':'KKS_BACKUP_1' , 'group-x-offset':'0' ,'heading-y-offset':'50'},
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'107'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'108'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'109'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'110'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'111'     },
                  {'engine':'sdi-router-p', 'group':'sks-single',      'sinkNum':'112'     },
                  {'group':'heading',       'text':'KKS Backup Switches','x-pos':'0','y-pos':'0','x-sz':'380','y-sz':'710'  },
                  #twogf single switches row 3 (13)
                  
                  { 'group':'twogf-all',    'button-label':'Switch all to A',      'preset':'All.twoGF200.Input.A'  , 'group-x-offset':'40' ,'heading-y-offset':'50'  },
                  {'engine':'axon_1',       'group':'twogf-single',    'slot':'2',  'encoder':'Encoder 11'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.100.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.100.name'},
                  {'engine':'axon_1',       'group':'twogf-single',    'slot':'3',  'encoder':'Encoder 12'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.101.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.101.name'   },
                  {'engine':'axon_1',       'group':'twogf-single',    'slot':'4',  'encoder':'Encoder 13'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.112.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.112.name'   },
                  {'engine':'axon_1',       'group':'twogf-single',    'slot':'5',  'encoder':'Encoder 14'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.103.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.103.name'   },
                  {'engine':'axon_1',       'group':'twogf-single',    'slot':'8',  'encoder':'BME A-Eing.' ,'label-val-a':'label.server.sdi-router-p.OutputPort.63.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.63.name'     },
                  {'engine':'axon_2',       'group':'twogf-single',    'slot':'2',  'encoder':'Encoder 1'   ,'label-val-a':'label.server.sdi-router-p.OutputPort.100.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.100.name'   },
                  {'engine':'axon_2',       'group':'twogf-single',    'slot':'3',  'encoder':'Encoder 2'   ,'label-val-a':'label.server.sdi-router-p.OutputPort.101.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.101.name'   },
                  {'engine':'axon_2',       'group':'twogf-single',    'slot':'4',  'encoder':'Encoder 3'   ,'label-val-a':'label.server.sdi-router-p.OutputPort.102.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.102.name'     },
                  {'engine':'axon_2',       'group':'twogf-single',    'slot':'5',  'encoder':'Encoder 4'   ,'label-val-a':'label.server.sdi-router-p.OutputPort.103.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.103.name'     },
                  {'engine':'axon_2',       'group':'twogf-single',    'slot':'6',  'encoder':'Encoder 5'   ,'label-val-a':'label.server.sdi-router-p.OutputPort.104.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.104.name'   },
                  {'engine':'axon_2',       'group':'twogf-single',    'slot':'7',  'encoder':'Encoder 6'   ,'label-val-a':'label.server.sdi-router-p.OutputPort.105.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.105.name' },
                  {'engine':'axon_2',       'group':'twogf-single',    'slot':'8',  'encoder':'BME B-Eing.' ,'label-val-a':'label.server.sdi-router-p.OutputPort.64.name'      ,'label-val-b':'label.server.sdi-router-s.OutputPort.63.name'     },
                  #twogf single switches row 4 (12)
                  { 'group':'twogf-all',    'button-label':'Switch all to B',      'preset':'All.twoGF200.Input.B' , 'group-x-offset':'0' ,'heading-y-offset':'50'   },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'2',  'encoder':'Encoder 16'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.16.name'    ,'label-val-b':'label.server.sdi-router-s.OutputPort.16.name'    },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'3',  'encoder':'Encoder 17'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.17.name'    ,'label-val-b':'label.server.sdi-router-s.OutputPort.17.name'    },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'4',  'encoder':'Encoder 7'   ,'label-val-a':'label.server.sdi-router-p.OutputPort.7.name'     ,'label-val-b':'label.server.sdi-router-s.OutputPort.7.name'   },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'5',  'encoder':'Encoder 8'   ,'label-val-a':'label.server.sdi-router-p.OutputPort.8.name'     ,'label-val-b':'label.server.sdi-router-s.OutputPort.8.name'   },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'6',  'encoder':'Encoder 27'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.27.name'    ,'label-val-b':'label.server.sdi-router-s.OutputPort.27.name'    },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'7',  'encoder':'Encoder 21'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.106.name'   ,'label-val-b':'label.server.sdi-router-s.OutputPort.106.name'    },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'8',  'encoder':'Encoder 22'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.107.name'   ,'label-val-b':'label.server.sdi-router-s.OutputPort.107.name'    },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'9',  'encoder':'Encoder 23'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.108.name'   ,'label-val-b':'label.server.sdi-router-s.OutputPort.108.name'    },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'10', 'encoder':'Encoder 24'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.109.name'   ,'label-val-b':'label.server.sdi-router-s.OutputPort.109.name'    },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'11', 'encoder':'Encoder 25'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.110.name'   ,'label-val-b':'label.server.sdi-router-s.OutputPort.110.name'    },
                  {'engine':'axon_3',       'group':'twogf-single',    'slot':'12', 'encoder':'Encoder 26'  ,'label-val-a':'label.server.sdi-router-p.OutputPort.111.name'   ,'label-val-b':'label.server.sdi-router-s.OutputPort.111.name'    },
                  {'group':'heading',       'text':'TwoGf100 Switches','x-pos':'440','y-pos':'0', 'x-sz':'380','y-sz':'1090'  }
             ]                
                  
                  
                                 

def getSubMenuEntries(dic,fileName,sheetIdx,startOffset,col_idx_inputNum,col_idx_grp,col_idx_sigName):
        
    wb=open_workbook(fileName)
    sheet=wb.sheet_by_index(sheetIdx)

    for row in range(startOffset,sheet.nrows):
        if not str(sheet.cell(row,col_idx_inputNum).value)=='':   
            if not str(sheet.cell(row,col_idx_grp).value)=='':
                    dic[sheet.cell(row,col_idx_grp).value].append(str(sheet.cell(row,col_idx_sigName).value)+'_'+str(int(sheet.cell(row,col_idx_inputNum).value)))
            else:         
                dic['UNGROUPED'].append(str(sheet.cell(row,col_idx_sigName).value)+'_'+str(int(sheet.cell(row,col_idx_inputNum).value)))
    
    return

def getOutputNames(list,fileName,sheetIdx,startOffset,col_idx_inputNum,col_idx_outName):
    
    wb=open_workbook(fileName)
    sheet=wb.sheet_by_index(sheetIdx)
    
    for row in range(startOffset,sheet.nrows):
        if not str(sheet.cell(row,col_idx_inputNum).value)=='':
            list.insert(int(sheet.cell(row,col_idx_inputNum).value),sheet.cell(row,col_idx_outName).value)
    
    return


def createMap():

    
    #sdi-data
    fileName='currList.xls'
    sheetIdx=0    
    startOffset=2
    col_idx_inputNum=13
    col_idx_grp=9
    col_idx_sigName=10
    col_idx_outName=16
    
    sdiSinkNames=[]
    sdiSubMenus=defaultdict(list)
    
    getSubMenuEntries(sdiSubMenus,fileName,sheetIdx,startOffset,col_idx_inputNum,col_idx_grp,col_idx_sigName)
    getOutputNames(sdiSinkNames,fileName,sheetIdx,startOffset,col_idx_inputNum,col_idx_outName)
    
    f = XmlGenTool.XmlGen('gui/maps/dvb_havarie_schaltungen.xml')
    f.addLine(0,'<map label="DVB-Havarie" >')
    
    outputNr=0
    headingNr=1
   
    curr_x_pos=10
    curr_y_pos=0
    
    delta_x=20
    delta_y=5    
    
    for  row in range(numOfRows):
        for currElement in range(num_elements_in_row[row]): 
            
            element_width=180
            element_height=70
            
            if not element_props[outputNr]['group'].split('-')[0]=='heading':
                        if element_props[outputNr]['group'].split('-')[0]=='sks':     
                            
                            if element_props[outputNr]['group'].split('-')[1]=='single':
                                selectedInput=element_props[outputNr]['engine']+'.level1.crosspoint.'+ element_props[outputNr]['sinkNum']+'.input'
                                serviceName='label.server.'+element_props[outputNr]['engine']+'.OutputPort.'+element_props[outputNr]['sinkNum']+'.name'
                                curr_y_pos+=dist_to_heading
                                dist_to_heading=0
                            else:
                                selectedInput='none'
                                serviceName='none'
                                curr_x_pos+=int(element_props[outputNr]['group-x-offset'])
                                dist_to_heading=int(element_props[outputNr]['heading-y-offset'])
                                curr_y_pos+=dist_to_heading
                        else:
                            
                            if element_props[outputNr]['group'].split('-')[1]=='single':
                                selectedInput=element_props[outputNr]['engine']+'.'+element_props[outputNr]['slot']+'.2gf10v410.currInput'
                                serviceName='none'
                                curr_y_pos+=dist_to_heading
                                dist_to_heading=0 
                            else:                                    
                                selectedInput='none'
                                serviceName='none'
                                curr_x_pos+=int(element_props[outputNr]['group-x-offset'])
                                dist_to_heading=int(element_props[outputNr]['heading-y-offset'])
                                curr_y_pos+=dist_to_heading
                
                        f.addLine(1,' <element')
                        f.addLine(2,'id="output'+str(outputNr)+'"')
                        f.addLine(2,'type="de.euromedia_service.coyonet.plugin.Base"')
                        f.addLine(2,'x="'+str(curr_x_pos)+'"')
                        f.addLine(2,'y="'+str(curr_y_pos)+'"')
                        f.addLine(2,'width="'+str(element_width)+'"')
                        f.addLine(2,'height="'+str(element_height)+'"')
                        f.addLine(2,'tree.Label="Output'+ str(outputNr)+'"')
                        f.addLine(2,'tree.folder="Outputs"')                                
                        f.addLine(2,'conf.style="none"')
                        f.addLine(2,'conf.background.color="d9d9d9"')
                        f.addLine(2,'conf.border.style="LineBorder"')
                        f.addLine(2,'conf.border.color="000000"')
                        f.addLine(2,'conf.border.thickness="2"')                
                        f.addLine(2,'conf.label=""')
                        f.addLine(2,'input.state="systemmgr.ok"')
                        
                        if element_props[outputNr]['group'].split('-')[0]=='sks':                 
                            if element_props[outputNr]['group'].split('-')[1]=='single':
                                f.addLine(2,'input.selectedInput="'+selectedInput+'"' )
                                f.addLine(2,'input.inputService="'+serviceName+'" >')
                            else:
                                f.addLine(2,'>')
                        else:
                            if element_props[outputNr]['group'].split('-')[1]=='single':
                                f.addLine(2,'input.selectedInput="'+selectedInput+'"' )
                                f.addLine(2,'input.inputService1="'+element_props[outputNr]['label-val-a']+'"')
                                f.addLine(2,'input.inputService2="'+element_props[outputNr]['label-val-b']+'" >')
                            else:
                                f.addLine(2,'>')
                        
                        
                        f.addLine(3,'<label')
                        f.addLine(4,'x="2"')
                        f.addLine(4,'y="2"')              
                        f.addLine(4,'width="'+str(element_width-4)+'"')
                        f.addLine(4,'height="'+str(element_height/5-2)+'"')#13
                        f.addLine(4,'conf.label="Output'+ str(outputNr)+'"')
                        f.addLine(4,'conf.font.name="Arial"')
                        f.addLine(4,'conf.font.size="12"')
                        f.addLine(4,'conf.alignment.horizontal="Center"')
                        f.addLine(4,'conf.alignment.vertical="Center"')                    
                        f.addLine(4,'conf.border.style="LineBorder"')
                        f.addLine(4,'conf.border.color="d9d9d9"')
                        f.addLine(4,'conf.border.thickness="0"')                    
                        f.addLine(4,'conf.background.color="000000"')
                        f.addLine(4,'conf.foreground.color="000000">')                    
                        f.addLine(3,'>')
                        
                        if element_props[outputNr]['group'].split('-')[1]=='single': 
                             if element_props[outputNr]['group'].split('-')[0]=='sks': 
                                f.addLine(4,'<text>'+ element_props[outputNr]['sinkNum']+'</text>')
                             else:
                                f.addLine(4,'<text> Frame :'+element_props[outputNr]['engine'].split('_')[1]+' Slot : '+element_props[outputNr]['slot']+'</text>')
                        else:
                             f.addLine(4,'<text>'+ element_props[outputNr]['button-label']+'</text>')                                       
                        
                        f.addLine(3,'</label>')
                        f.addLine(3,'<label')
                        f.addLine(4,'x="2"') 
                        f.addLine(4,'y="'+str(element_height/5-2)+'"')                
                        f.addLine(4,'width="'+str(element_width-4)+'"')
                        f.addLine(4,'height="'+str(element_height/5+4)+'"')#13                                
                        f.addLine(4,'conf.font.name="Arial"')
                        f.addLine(4,'conf.font.size="12"')
                        f.addLine(4,'conf.alignment.horizontal="Center"')
                        f.addLine(4,'conf.alignment.vertical="Center"')                    
                        f.addLine(4,'conf.border.style="LineBorder"')
                        f.addLine(4,'conf.border.color="d9d9d9"')
                        f.addLine(4,'conf.border.thickness="0"')                    
                        f.addLine(4,'conf.background.color="000000"')
                        f.addLine(4,'conf.foreground.color="000000"')                                
                        f.addLine(3,'>')
                        
                        if element_props[outputNr]['group'].split('-')[1]=='single': 
                             if element_props[outputNr]['group'].split('-')[0]=='sks': 
                                f.addLine(4,'<text>'+sdiSinkNames[int(element_props[(outputNr)]['sinkNum'])-1]+'</text>')
                             else:
                                f.addLine(4,'<text>'+element_props[outputNr]['encoder']+'</text>')
                        else:
                             f.addLine(4,'<text>Sum - Switch</text>')
                        
                        
                        f.addLine(3,'</label>')
                        f.addLine(3,'<label')
                        f.addLine(4,'x="6"')
                        f.addLine(4,'y="32"')                
                        f.addLine(4,'width="'+str(element_width-12)+'"')
                        f.addLine(4,'height="'+str((element_height*3/5)-10)+'"')
                        f.addLine(4,'conf.name="Destination'+ str(outputNr)+'"')                       
                        f.addLine(4,'conf.font.name="Arial"')
                        f.addLine(4,'conf.font.size="12"')
                        f.addLine(4,'conf.alignment.horizontal="Center"')
                        f.addLine(4,'conf.alignment.vertical="Center"')                    
                        f.addLine(4,'conf.border.style="RaisedBevelBorder"')                                        
                        f.addLine(4,'conf.foreground.color="000000"')                    
                        #f.addLine(3,'>')
                        
                        if element_props[outputNr]['group'].split('-')[1]=='single': 
                             if element_props[outputNr]['group'].split('-')[0]=='sks':
                                 f.addLine(3,'>') 
                                 f.addLine(4,'<text>{$selectedInput} : {$inputService}</text>')
                             else:
                                f.addLine(3,'>')
                                f.addLine(4,'<text')
                                f.addLine(5,'input="selectedInput"')
                                f.addLine(5,'default="dicker Hund" >')
                                f.addLine(6,'<map ')
                                f.addLine(6,'input.value="0" text="A:{$inputService1}" /> ')
                                f.addLine(6,'<map ')
                                f.addLine(6,'input.value="1" text="B:{$inputService2}" /> ')                    
                                f.addLine(6,'</text> ')                                        
                        else:
                            
                             f.addLine(3,'>')
                             f.addLine(4,'<text>Switch all</text>')               
                             #f.addLine(4,'<menu>')
                             #f.addLine(5,'<label="Source Selection"')   
                             f.addLine(6,'<menu-item')
                             f.addLine(7,'label="Switch Now"')
                             f.addLine(7,'action="de.euromedia_service.coyonet.sendcmd"')
                             f.addLine(7,'arg.id="'+element_props[outputNr]['preset']+'"')
                             f.addLine(7,'arg.question="Do you really want to do that?"')
                             f.addLine(6,'/>')
                             #f.addLine(4,'</menu>')  
                             
                        
                        
                        if element_props[outputNr]['group'].split('-')[1]=='single':
                             f.addLine(3,'<menu')
                             f.addLine(4,'label="Source Selection">') 
                             
                             if element_props[outputNr]['group'].split('-')[0]=='sks': 
                                 
                                grpNames=sdiSubMenus.keys()
                                grpNames.sort()
                                for group in grpNames :
                                    #prevents from being able to route reentry input to output
                                     if not ((element_props[outputNr]['sinkNum'] > 99 and element_props[outputNr]['sinkNum'] < 112) and (group=='SL SD' or group=='SL HD')):
                                        if len(group)>0:
                                            f.addLine(5,'<menu')
                                            f.addLine(6,'label="'+str(group)+'" >')                    
                                            for sigLabel in sdiSubMenus[group]:
                                                if len(sigLabel)>0:
            
                                                    f.addLine(7,'<menu-item')
                                                    f.addLine(8,'label="'+sigLabel.split('_')[0]+' ('+sigLabel.split('_')[1]+')"')
                                                    f.addLine(8,'action="de.euromedia_service.coyonet.sendcmd"')
                                                    f.addLine(8,'arg.id="'+element_props[outputNr]['engine']+'.setcrosspoint_'+ element_props[outputNr]['sinkNum']+'_'+sigLabel.split('_')[1]+'"')
                                                    f.addLine(8,'arg.question="You are about to destroy a Reentry ! Are you really sure you know what you are doing ?"')    
                                                    f.addLine(7,'/>')    
                                                    f.addLine(7,'/>')    
                                            f.addLine(5,'</menu>')                    
                             else:
                                        f.addLine(5,'<menu-item')
                                        f.addLine(6,'label="Select InputA"')
                                        f.addLine(7,'action="de.euromedia_service.coyonet.sendcmd"')
                                        f.addLine(7,'arg.id="'+element_props[outputNr]['engine']+'.twoGF200.'+element_props[outputNr]['slot']+'.Input.A"')
                                        f.addLine(7,'arg.question="Do you really want switch to Input A?" />')
                                        f.addLine(5,'<menu-item')
                                        f.addLine(6,'label="Select InputB"')
                                        f.addLine(7,'action="de.euromedia_service.coyonet.sendcmd"')
                                        f.addLine(7,'arg.id="'+element_props[outputNr]['engine']+'.twoGF200.'+element_props[outputNr]['slot']+'.Input.B"')
                                        f.addLine(5,'arg.question="Do you really want switch to Input B?" />')
                            
                             f.addLine(3,'</menu>') 
                             
                        #else:
                                        #f.addLine(3,'<menu')
                                        #f.addLine(4,'<label="Source Selection"')   
                                        #f.addLine(5,'<menu-item')
                                        #f.addLine(6,'label="Switch Now"')
                                
                                        
                      
                        f.addLine(3,'</label>')                       
                        f.addLine(1,'</element>')  
                        outputNr+=1
                        curr_y_pos+=element_height+delta_y

            else:
                
                xWidth=int(element_props[outputNr]['x-sz'])+delta_x
                
                f.addLine(1,'<element')
                f.addLine(2,'id="switch_group'+str(headingNr)+'"')
                f.addLine(2,'type="de.euromedia_service.coyonet.plugin.Base"')
                f.addLine(2,'x="'+element_props[outputNr]['x-pos']+'"')
                f.addLine(2,'y="'+element_props[outputNr]['y-pos']+'"')
                f.addLine(2,'width="'+str(xWidth)+'"')
                f.addLine(2,'height="'+element_props[outputNr]['y-sz']+'"')
                f.addLine(2,'tree.Label="Umschaltung'+str(headingNr)+'"')
                f.addLine(2,'tree.folder=""')
                f.addLine(2,'conf.style="none"')
                f.addLine(2,'conf.background.color="d9d9d9"')
                f.addLine(2,'conf.border.style="LineBorder"')
                f.addLine(2,'conf.border.color="000000"')
                f.addLine(2,'conf.border.thickness="4"')                    
                f.addLine(2,'conf.label="'+element_props[outputNr]['text']+'"')
                f.addLine(2,'input.state="systemmgr.ok"')
                f.addLine(2,'/>')                                       
                                                        
                outputNr+=1
                curr_y_pos+=element_height+delta_y
                
        curr_x_pos+=element_width+delta_x
        curr_y_pos=0            
    f.addLine(0,'</map >')
    
    
    
    return

createMap()




