
import codecs
import XmlGenTool

from xlrd import open_workbook
from collections import defaultdict


numOfRows=5

num_elements_in_row =[ 
                       3,
                       3,
                       3,
                       3,
                       1
                     ]

row_specific_props=[
                        {'row_width':270,   'elm_width':250,     'elm_height':200,    'elm_distance':60, 'y_distance':120 },      
                        {'row_width':270,   'elm_width':250,     'elm_height':200,    'elm_distance':60, 'y_distance':120 },
                        {'row_width':270,   'elm_width':250,     'elm_height':200,    'elm_distance':60, 'y_distance':120 },
                        {'row_width':270,   'elm_width':250,     'elm_height':200,    'elm_distance':60, 'y_distance':120 },
                        {'row_width':270,   'elm_width':250,     'elm_height':200,    'elm_distance':60, 'y_distance':120 },                        
                    ]

elemet_props=[ 
                  {'name':'Messsenke 1',              'engine':'asi-router',       'sinkNum':'18'     },
                  {'name':'Messsenke 2',              'engine':'asi-router',       'sinkNum':'28'     },
                  {'name':'Messsenke 3',              'engine':'sdi-router-p',     'sinkNum':'76'     },
                  {'name':'Messsenke 4',              'engine':'asi-router',       'sinkNum':'19'     },
                  {'name':'Messsenke 5',              'engine':'asi-router',       'sinkNum':'29'     },
                  {'name':'Messsenke 6',              'engine':'sdi-router-p',     'sinkNum':'31'     },
                  {'name':'Messsenke 7',              'engine':'asi-router',       'sinkNum':'20'     },
                  {'name':'Messsenke 8',              'engine':'asi-router',       'sinkNum':'80'     },
                  {'name':'Messsenke 9',              'engine':'sdi-router-p',     'sinkNum':'33'     },
                  {'name':'Messsenke 10',             'engine':'asi-router',       'sinkNum':'21'     },
                  {'name':'Messsenke 11',             'engine':'asi-router',       'sinkNum':'81'     },
                  {'name':'Messsenke 12',             'engine':'sdi-router-p',     'sinkNum':'34'     },
                  {'name':'Messsenke 13',             'engine':'asi-router',       'sinkNum':'22'     }               
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
    
    #asi-data
    fileName='currAsiList.xls'
    sheetIdx=0    
    startOffset=4
    col_idx_inputNum=0
    col_idx_grp=2
    col_idx_sigName=1
    col_idx_outName=7  
    
    asiSinkNames=[]
    asiSubMenus=defaultdict(list)
    
    getSubMenuEntries(asiSubMenus,fileName,sheetIdx,startOffset,col_idx_inputNum,col_idx_grp,col_idx_sigName)
    getOutputNames(asiSinkNames,fileName,sheetIdx,startOffset,col_idx_inputNum,col_idx_outName)
    
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
   
    
    f = XmlGenTool.XmlGen('gui/maps/dvb_messen.xml')
    f.addLine(0,'<map label="DVB-Messen" >')
    
    curRowBorderLeft=0
    absolutElementNum=0   
    
    
    for row in range(numOfRows):
       
        curYPosCurser=(row_specific_props[row])['y_distance']
                
        for rowElementNum in range(num_elements_in_row[row]):            

            f.addLine(1,'<element')
            
            f.addLine(2,'id="el'+str(absolutElementNum+1)+'"')
            
            f.addLine(2,'type="de.euromedia_service.coyonet.plugin.Base"')
            f.addLine(2,'x="'+str(curRowBorderLeft)+'"')
            f.addLine(2,'y="'+str(curYPosCurser)+'"') 
            f.addLine(2,'width="'+str((row_specific_props[row])['elm_width'])+'"' )
            f.addLine(2,'height="'+str((row_specific_props[row])['elm_height'])+'" ')
            
            affectedSink=int( ( elemet_props[ absolutElementNum ] ) ['sinkNum'] )            
            if (elemet_props[absolutElementNum])['engine']=='asi-router':             
                f.addLine(2,'conf.label="'+ ( asiSinkNames[affectedSink-1 ])+'"')
            else:
                f.addLine(2,'conf.label="'+ (sdiSinkNames[affectedSink-1])+'"')
                
            f.addLine(2,'conf.style="StateBorderRectangleRounded"')
            f.addLine(2,'')
            f.addLine(2,'input.state="alarm.'+(elemet_props[absolutElementNum])['engine']+'.state"')
            f.addLine(2,'input.inputService="label.server.'+(elemet_props[absolutElementNum])['engine']+'.OutputPort.'+str(affectedSink)+'.name" >')         
            f.addLine(1,'>')    
            
            f.addLine(3,'<label')
            f.addLine(4,'x="25"')
            f.addLine(4,'y="80"')                
            f.addLine(4,'width="200"')
            f.addLine(4,'height="40"')                       
            f.addLine(4,'conf.font.name="Arial"')
            f.addLine(4,'conf.font.size="12"')
            f.addLine(4,'conf.alignment.horizontal="Center"')
            f.addLine(4,'conf.alignment.vertical="Center"')                    
            f.addLine(4,'conf.border.style="LoweredBevelBorder"')                                        
            f.addLine(4,'conf.foreground.color="000000">')                    
            f.addLine(3,'>')
            f.addLine(4,'<text> {$inputService}</text>')
            f.addLine(3,'</label>')
            
            f.addLine(3,'<menu')
            f.addLine(4,'label="Source Selection">')
            
            if (elemet_props[absolutElementNum])['engine']=='asi-router':             
                        
                grpNames=asiSubMenus.keys()
                grpNames.sort()
                for group in grpNames :
                        #prevents from being able to route reentry input to output
                        if not (( affectedSink > 99 and affectedSink < 112) and (group=='SL SD' or group=='SL HD')):
                            if len(group)>0:
                                f.addLine(5,'<menu')
                                f.addLine(6,'label="'+str(group)+'" >')                    
                                for sigLabel in asiSubMenus[group]:
                                    if len(sigLabel)>0:
                                            
                                            #print val
                                        #print val.split('_')[0]+' ('+val.split('_')[1]+')'
                                        f.addLine(7,'<menu-item')
                                        f.addLine(8,'label="'+sigLabel.split('_')[0]+' ('+sigLabel.split('_')[1]+')"')
                                        f.addLine(8,'action="de.euromedia_service.coyonet.sendcmd"')
                                        f.addLine(8,'arg.id="'+(elemet_props[absolutElementNum])['engine']+'.setcrosspoint_'+ str(affectedSink)+'_'+sigLabel.split('_')[1]+'"')
                                        f.addLine(8,'arg.question="Do you really want to route to '+ sigLabel.split('_')[0]+' ('+sigLabel.split('_')[1]+')?"')
                                        f.addLine(7,'/>')
                                f.addLine(5,'</menu>')
            
            else:
                grpNames=sdiSubMenus.keys()
                grpNames.sort()
                for group in grpNames :
                        #prevents from being able to route reentry input to output
                        if not (( affectedSink > 99 and affectedSink < 112) and (group=='SL SD' or group=='SL HD')):
                            if len(group)>0:
                                f.addLine(5,'<menu')
                                f.addLine(6,'label="'+str(group)+'" >')                    
                                for sigLabel in sdiSubMenus[group]:
                                    if len(sigLabel)>0:
                                            
                                            #print val
                                        #print val.split('_')[0]+' ('+val.split('_')[1]+')'
                                        f.addLine(7,'<menu-item')
                                        f.addLine(8,'label="'+sigLabel.split('_')[0]+' ('+sigLabel.split('_')[1]+')"')
                                        f.addLine(8,'action="de.euromedia_service.coyonet.sendcmd"')
                                        f.addLine(8,'arg.id="'+(elemet_props[absolutElementNum])['engine']+'.setcrosspoint_'+ str(affectedSink)+'_'+sigLabel.split('_')[1]+'"')
                                        f.addLine(8,'arg.question="Do you really want to route to '+ sigLabel.split('_')[0]+' ('+sigLabel.split('_')[1]+')?"')
                                        f.addLine(7,'/>')      
         
                    
                    
                            f.addLine(5,'</menu>')
            f.addLine(3,'</menu>')    
            f.addLine(1,'</element>')    
            f.addLine(0,'')
            
            absolutElementNum+=1
            curYPosCurser+=(row_specific_props[row])['elm_height']+(row_specific_props[row])['elm_distance']            
            
        curRowBorderLeft+=(row_specific_props[row])['row_width']
        f.addLine(0,'')
    f.addLine(0,'</map >')
    
    
    
    return

createMap()



