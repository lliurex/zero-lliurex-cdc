#!/usr/bin/python3

import os
import subprocess
import sys
import syslog

class CDCManager:

	APPLY_CHANGES_SUCCESSFUL=0
	APPLY_CHANGES_ENABLE_ERROR=-1
	APPLY_CHANGES_DISABLE_ERROR=-2

	def __init__(self):

		self.debug=True
		self.isIntegrationCDCEnabled=False
		self.getSessionLang()

	#def __init__


	#def setServer

	def loadConfig(self,ticket):
		
		ticket=ticket.replace('##U+0020##',' ')
		self.currentUser=ticket.split(' ')[2]
		
		self.writeLog("Init session in lliurex-access-control GUI")
		self.writeLog("User login in GUI: %s"%self.currentUser)

		cmd="cdccli -t"
		p=subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE)
		poutput=p.communicate()
		rc=p.returncode
		
		if rc==0:
			self.isIntegrationCDCEnabled=True
		else:
			self.isIntegrationCDCEnabled=False

		self.writeLog("Initial configuration. Integration with CDC enabled: %s"%str(self.isIntegrationCDCEnabled))
	
	#def loadConfig

	def enableIntegrationCDC(self):

		error=False
		msg=""

		self.writeLog("- Action: enable integration with CDC")
		
		cmd="cdccli -e"
		p=subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE)
		poutput=p.communicate()
		rc=p.returncode

		if rc==0:
			error=False
			msg=CDCManager.APPLY_CHANGES_SUCCESSFUL
			self.writeLog("- Result: Change apply successful")
			
		else:
			error=True
			msg=CDCManager.APPLY_CHANGES_ENABLE_ERROR
			self.writeLog("- Result: Failed to apply change")

		result=[error,msg]

		return result 	
		
	#def enableIntegrationCDC

	def disableIntegrationCDC(self):

		error=False
		msg=""

		self.writeLog("- Action: disable integration with CDC")
		
		cmd="cdccli -d"
		p=subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE)
		poutput=p.communicate()
		rc=p.returncode

		if rc==0:
			error=False
			msg=CDCManager.APPLY_CHANGES_SUCCESSFUL
			self.writeLog("- Result: Change apply successful")
			
		else:
			error=True
			msg=CDCManager.APPLY_CHANGES_DISABLE_ERROR
			self.writeLog("- Result: Failed to apply change")

		result=[error,msg]
		
		return result 	
		
	#def disableIntegrationCDC

	def getSessionLang(self):

		lang=os.environ["LANG"]
		
		if 'valencia' in lang:
			self.sessionLang="ca@valencia"
		else:
			self.sessionLang="es"

	#def getSessionLang

	def writeLog(self,msg):

		syslog.openlog("CDC-CONTROL")
		syslog.syslog(msg)

	#def writeLog


#class CDCManager
