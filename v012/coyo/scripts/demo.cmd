d:
cd D:\EMS_Eclipse_Workspace\Teletrend\coyonet\gui
dir >D:\EMS_Eclipse_Workspace\Teletrend\coyonet\scripts\dir.txt
cd D:\EMS_Eclipse_Workspace\Teletrend\coyonet\scripts
curl -u "coyonet:euromedia-service" --data-binary @ok.xml http://127.0.0.1:8080/msg

