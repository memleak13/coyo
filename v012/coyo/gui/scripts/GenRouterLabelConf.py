
import codecs
import XmlGenTool

from xlrd import open_workbook
from collections import defaultdict

fileName="currList.xls"
excelsheet_data=defaultdict(list)

routers=    [
             #        0:engineName -     1:num Crosspoint -     2:level -   3:sheet_name    4:filename     5:#row-inputNr  6:row-grp    7:row-signame   8:data-offset              9:mapping-file               10:mapping-idx
                 [  'sdi-router-p',           144,                  1,     'DVKS-1_DVB',  'currList.xls',     13,             9,               10,             2,       'logical2physCrosspointMapping.xls',        0           ],
                 [  'sdi-router-s',           176,                  2,     'DVKS-2_DVB',  'currList.xls',     12,             9,               10,             2,       'logical2physCrosspointMapping.xls',        1           ],
                 [  'asi-router',              96,                  1,     'ASI - KS',    'currAsiList.xls',   0,             2,                1,             4,       'logical2physCrosspointMapping.xls',        2           ]                 
             ]

def getOutputMappings(list,outputMappingFile,mappingTableIdx):
    
    row_idx_phys_outNum=0
    row_idx_logi_outNum=1
    
    wb=open_workbook(outputMappingFile)
    sheet=wb.sheet_by_index(mappingTableIdx)
    
    for row in range(1,sheet.nrows):
        list.insert(int(sheet.cell(row,row_idx_phys_outNum).value),str(int(sheet.cell(row,row_idx_logi_outNum).value)))
    
    return

def getSdiRouterLabelingData(list,xlsSrcName,sheetName,idx_inputNum,col_idx_grp,col_idx_sigName,data_offset): 
    
    
    wb=open_workbook(xlsSrcName)
    sheet=wb.sheet_by_name(sheetName)
    
   
    for row in range(data_offset,sheet.nrows):
        
        if not sheet.cell(row,idx_inputNum).value=='':    
            #list.append(str(sheet.cell(row,col_idx_sigName).value)+'_'+str(int( sheet.cell(row,idx_inputNum).value) ))# row-1 because the first output is at pos 1
            list.insert(int(sheet.cell(row,idx_inputNum).value),str(sheet.cell(row,col_idx_grp).value+'::'+sheet.cell(row,col_idx_sigName).value ))
                
    return

def createLabelingConfig():
    
    f = XmlGenTool.XmlGen('server/conf/LabelingConfiguration.xml')
    f.addLine(0,'<labeling_config>')

    for router in routers:
        
   
        signal_data=[]
        getSdiRouterLabelingData(signal_data,router[4],router[3],router[5],router[6],router[7],router[8])
        
        outputMappings=[]
        getOutputMappings(outputMappings,router[9],router[10])
        
        
        f.addLine(1,'<distribution-router')
        f.addLine(2,'id="'+router[0]+'"')
        f.addLine(2,'cntCrosspoints="'+str(router[1])+'"')
        f.addLine(2,'level="'+str(router[2])+'"')
        f.addLine(1,'>')
        
        for inputNum in range(1,int(router[1])+1):
            
            print inputNum
            print int(outputMappings[inputNum-1])-1
            
            if not signal_data[int(outputMappings[inputNum-1])-1]=='::':
                #input='<input id="%s" pdk-src-port="%s" default-name="%s" />'%(outputMappings[int(signal.split('_')[1])-1],outputMappings[int(signal.split('_')[1])-1],signal.split('_')[0])
                input='<input id="%s" pdk-src-port="%s" default-name="%s" />'%(inputNum,inputNum,signal_data[int(outputMappings[inputNum-1])-1])
            else:
                #input='<input id="%s" pdk-src-port="%s" default-name="%s" />'%(outputMappings[int(signal.split('_')[1])-1],outputMappings[int(signal.split('_')[1])-1],'nicht vergeben')
                input='<input id="%s" pdk-src-port="%s" default-name="%s" />'%(inputNum,inputNum,'nicht vergeben')        
            f.addLine(2,input)
        
        f.addLine(1,'</distribution-router>')        
           
    f.addLine(0,'</labeling_config>')
    
    return

createLabelingConfig()





