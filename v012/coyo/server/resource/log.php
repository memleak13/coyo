<?php
    header('Content-type: text/xml');
	
    $LOG_DIR="logging";
    $head='<?xml version="1.0" encoding="utf-8" standalone="no"?>';
    $STYLESHEET ='<?xml-stylesheet type="text/xsl" href="logging.xsl" ?>';

    $id = $_GET['id'];
    if(!isset($id)) {
        $id="0";
    }
    $raw = $_GET['raw'];
    if(isset($raw)) {
        echo "$head";
    }
    else {
        echo "$head
        $STYLESHEET
    ";
    }
    
    
    
    echo "<logging id='{$id}'>";
    $fh = 0;
    try {
        $fn = "{$LOG_DIR}/sniffer{$id}.xml";
        if(file_exists($fn)) {
            $fh = fopen($fn, "r");
            if($fh) {
                $line ="";
                do {
                    $line = fgets($fh);
                    
                    
                    $pos0 = stripos($line, "<!DOCTYPE");                    
                    $pos1 = stripos($line, "<?xml");
                    $pos2 = stripos($line, "<log>");
                    $pos3 = stripos($line, "</log>");
                    $pos4 = stripos($line, "<millis");                     
                    $pos5 = stripos($line, "<method");                     
                    

                    
                    if( $pos0===false and 
                        $pos1===false and 
                        $pos2===false and 
                        $pos3===false and 
                        $pos4===false and
                        $pos5===false
                        ) {
                        echo $line;
                    }
                } while(strlen($line) > 0);
            }
        }
    }
    catch (Exception $ex)
    {
    }
    if($fh) {
        fclose($fh);
    }
    echo '</logging>';

    return;
?>
