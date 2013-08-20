import codecs
import XmlGenTool
from xlrd import open_workbook
from collections import defaultdict


fileName="currList.xls"
    
wb=open_workbook(fileName)
sheet=wb.sheet_by_index(1)
col_inputNum=12


f = XmlGenTool.XmlGen('server/conf/RouterSyncList.xml')
f.addLine(0,'<sync-list>')
f.addLine(1,'<sdi-router>')

for row in range(2,sheet.nrows):
    
    if str(sheet.cell(row,25).value)=='x':
        
        if not sheet.cell(row,col_inputNum).value=='': 
            f.addLine(2,'<destination id="'+str(int(sheet.cell(row,col_inputNum).value))+'" />"')
        
f.addLine(1,'</sdi-router>')       
f.addLine(0,'</sync-list>')
    








