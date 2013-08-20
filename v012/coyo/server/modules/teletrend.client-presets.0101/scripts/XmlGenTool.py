
class XmlGen:
    def __init__(self, fileName=''):
        self.fileName = fileName
        self.fo = None
        if(fileName!=''):
            self.fo = open(fileName, 'w')
        self.xmlStart()
        return

    def close(self):
        if(self.fo):
            self.fo.close()

    def addLine(self, tabCount, text):
        tabs = ''
        for i in range(tabCount):
            tabs=tabs +'    ' 
        text = tabs + text
        if(self.fo):
            self.fo.write(text +  '\n')
        else:
            print text
        return
        
    def xmlStart(self):
        self.addLine(0,'<?xml version="1.0" encoding="UTF-8"?>')
        return


    


        
