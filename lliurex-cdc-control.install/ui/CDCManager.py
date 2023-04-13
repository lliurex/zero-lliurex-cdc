#!/usr/bin/python3

import os
import subprocess
import sys
import shutil
import syslog

class CDCManager:

	APPLY_CHANGES_SUCCESSFUL=0
	APPLY_CHANGES_ENABLE_ERROR=-1
	APPLY_CHANGES_DISABLE_ERROR=-2

	def __init__(self):

		self.debug=True
		self.isIntegrationCDCEnabled=False
		self.lockTokenPath="/var/run/cdcControl.lock"
		self._createLockToken()
		self.getSessionLang()
		self.clearCache()
		self._getCurrentUser()

	#def __init__

	def _createLockToken(self):
		
		if not os.path.exists(self.lockTokenPath):
			f=open(self.lockTokenPath,'w')
			upPid=os.getpid()
			f.write(str(upPid))
			f.close()

	#def createLockToken

	def loadConfig(self):
		
		self.writeLog("Init session in lliurex-cdc-control GUI")
		self.writeLog("User login in GUI: %s"%self.currentUser)
		self._getIntegrationCDCStatus()
		self.writeLog("Initial configuration. Integration with CDC enabled: %s"%str(self.isIntegrationCDCEnabled))

	#def loadConfig

	def _getIntegrationCDCStatus(self):

		cmd="cdccli -t"
		p=subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE)
		poutput=p.communicate()
		rc=p.returncode
		
		if rc==0:
			self.isIntegrationCDCEnabled=True
		else:
			self.isIntegrationCDCEnabled=False
	
	#def _getIntegrationCDCStatus

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
			self._getIntegrationCDCStatus()
			self.writeLog("- Result: Change apply successfully")
			
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
			self._getIntegrationCDCStatus()
			self.writeLog("- Result: Change apply successfully")
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

	def clearCache(self):

		clear=False
		versionFile="/root/.lliurex-cdc-control.conf"
		cachePath1="/root/.cache/lliurex-cdc-control"
		installedVersion=self.getPackageVersion()

		if not os.path.exists(versionFile):
			with open(versionFile,'w') as fd:
				fd.write(installedVersion)

			clear=True

		else:
			with open(versionFile,'r') as fd:
				fileVersion=fd.readline()
				fd.close()

			if fileVersion!=installedVersion:
				with open(versionFile,'w') as fd:
					fd.write(installedVersion)
					fd.close()
				clear=True
		
		if clear:
			if os.path.exists(cachePath1):
				shutil.rmtree(cachePath1)

	#def clearCache

	def getPackageVersion(self):

		packageVersionFile="/var/lib/zero-lliurex-cdc/version"
		pkgVersion=""

		if os.path.exists(packageVersionFile):
			with open(packageVersionFile,'r') as fd:
				pkgVersion=fd.readline()
				fd.close()

		return pkgVersion

	#def getPackageVersion

	def _getCurrentUser(self):

		sudoUser=""
		loginUser=""
		pkexecUser=""

		try:
			sudoUser=(os.environ["SUDO_USER"])
		except:
			pass
		try:
			loginUser=os.getlogin()
		except:
			pass

		try:
			cmd="id -un $PKEXEC_UID"
			p=subprocess.Popen(cmd,shell=True,stdout=subprocess.PIPE)
			pkexecUser=p.communicate()[0].decode().strip()
		except Exception as e:
			pass

		if pkexecUser!="root" and pkexecUser!="":
			self.currentUser=pkexecUser

		elif sudoUser!="root" and sudoUser!="":
			self.currentUser=sudoUser

	#def _getCurrentUser

	def removeLockToken(self):
		
		if os.path.exists(self.lockTokenPath):
			os.remove(self.lockTokenPath)

	#def removeLockToken

#class CDCManager
