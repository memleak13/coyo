#!/usr/bin/python

def run():
	fh = open('/opt/coyonet/server/dump/run_system_command.log', 'a') 
	#fh = open('./command_dump.txt', 'a') 
	fh.write('this is a test \n')
	fh.close()

if __name__ == "__main__":
    run()