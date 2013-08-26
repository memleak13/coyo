#!/usr/bin/python

#Strange this does not work with the vig client ... 
#then command works if i connect to hec over ssh and run the same command
#using ifconfig it works too...

#strange ... 

import paramiko

def run():
	username = 'vig'
	password = 'vig'
	port = '22'
	ip = '192.168.1.1'
	#command = 'vig-client --interface udp --mac_src 0F:F9:1C --mac_dst 0F:FD:A5 --ncp write ing1 -6db --ack 1 --verbose\n'
	command = 'ifconfig'
	#fh = open('/opt/coyonet/server/dump/connect_hec.log', 'a') 
	fh = open('./log', 'a')
	fh.write('test\n')
	ssh = paramiko.SSHClient()
	ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
	ssh.connect(ip, username=username, password=password)
	stdin, stdout, stderr = ssh.exec_command('command')
	for line in stdout:
		fh.write(line)
	ssh.close()
	fh.close()

if __name__ == "__main__":
    run()