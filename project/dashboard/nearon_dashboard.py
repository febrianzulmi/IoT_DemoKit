import datetime
import json
import os
import requests
import subprocess
import sys

import pyexcel as pe
from flask import Flask, render_template, request, flash, redirect, url_for, send_file
from werkzeug.utils import secure_filename

sys.path.append('/home/connex/project/database')
from query_project_db import (SensorGroupDB, SensorListDB, SensorParameterGroupDB, SensorParameterListDB, ActuatorListDB, IntervalRoutineMonitorDB, IntervalRoutineLogDB, 
                              ActuatorParameterListDB, ActuatorParameterGroupDB, ActuatorScheduleDB,
                              EnvironmentDeviceDB, EnvironmentMasterSensorDB, EnvironmentMasterParameterDB, LogMonitoringDB, LogSensorDB, LogActuatorDB, LogNotifDB,
                              LogErrorDB, SystemServiceDB, CalibrateFormulaDB, CalibrateSampleDB, PowerDeviceDB, ActuatorGroupDB,
                              PowerMasterParameterDB, PowerMasterSensorDB, SensorPortConfigDB, RtuParameterDB, RtuDeviceDB)
sys.path.append('/home/connex/library')
from SynapsisLibrary import times
sys.path.append('/home/connex/project/function')
from dashboardFunction import dashboardFunction
from dbFunction import dbFunction
from serverFunction import serverFunction
from generalFunction import generalFunction
from serviceProjectFunction import ServiceProjectFunction
sys.path.append('/home/connex/project/function/sensor')
from oidSensorFunction import OidSensorFunction


projectData = generalFunction.getProjectSetting()

app = Flask(__name__)
app.config['SECRET_KEY'] = 'project'

@app.route('/api/time/information')
def get_time():
    datetime = times.now()
    day = int(datetime.strftime("%w"))
    month = int(datetime.strftime("%m"))
    hari = ['Minggu','Senin','Selasa','Rabu','Kamis','Jum\'at','Sabtu']
    bulan = ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember']
    datetime = datetime.strftime(hari[day] + ", %d " + bulan[month-1] + " %Y %H:%M:%S")
    return datetime

@app.route('/api/dashboard/information', methods=['GET'])
def api_dashboard_information():
   dashboardInfo = dashboardFunction.dashboardHome.getDashboardInformation()
   return dashboardInfo

@app.route('/')
def index():
    rule = str(request.url_rule)
    sessionData = generalFunction.checkSession() # ID, username, level
    projectData = generalFunction.getProjectSetting() # projectNode, projectName
    deviceSetting = dbFunction.getDeviceSetting() # uid, name, version
    tab = 'home'
    if 'tab' in request.args:
      tab = request.args['tab']

    def parseData(displayName, serviceName, serviceData, serviceNum):
        serviceDetail = ServiceProjectFunction.getServiceInfo(serviceName)
        if serviceDetail['state'] == 'active':
           serviceNum +=1
           serviceInfo = {
              'displayName': displayName,
              'serviceName': serviceName,
              'statusOfService': serviceDetail['state'],
              'serviceState': serviceDetail['log'],
              'lastUpdate': str(serviceDetail['last_update'])
           }
        else:
           serviceInfo = [displayName, serviceDetail['state'], '-', '-']
           serviceInfo = {
              'displayName': displayName,
              'serviceName': serviceName,
              'statusOfService': serviceDetail['state'],
              'serviceState': '-',
              'lastUpdate': '-'
           }
        serviceData.append(serviceInfo)
        return serviceData, serviceNum
    infoNode, nodeService = [], 0
    infoNode, nodeService = parseData('Routine Monitoring', 'connex_routine', infoNode, nodeService)
    infoNode, nodeService = parseData('Alarm Monitoring', 'connex_alarm', infoNode, nodeService)
    infoNode, nodeService = parseData('Display', 'connex_display', infoNode, nodeService)
    infoNode, nodeService = parseData('Buffer', 'connex_buffer', infoNode, nodeService)
    infoNode, nodeService = parseData('Log', 'connex_log', infoNode, nodeService)
    infoNode, nodeService = parseData('Synchronize', 'connex_sync', infoNode, nodeService)
    infoNode, nodeService = parseData('Authentication', 'connex_auth', infoNode, nodeService)
    infoNode, nodeService = parseData('Notification', 'connex_notif', infoNode, nodeService)
    
    totalSensorOk, totalSensorMax, totalSensorMin = 0, 0, 0
    totalSensorError, totalAlarmInactive, totalSensorInactive, totalTolerance = 0, 0, 0, 0
    getSensorGroup = SensorGroupDB.select()
    infoSensor, sensorService = [], 0
    sensorDatas = {}
    if getSensorGroup :
       for item in range(len(getSensorGroup)):
          infoSensor, sensorService = parseData(getSensorGroup[item]['name'], 'sensor' + str(getSensorGroup[item]['number']), infoSensor, sensorService)
          sensorDatas[getSensorGroup[item]['name']] = []
          sensorList = SensorListDB.selectByGroupFull(getSensorGroup[item]['id'])
          if len(sensorList) > 0 :
             for num in range(len(sensorList)):
                groupName = SensorGroupDB.selectOne(sensorList[num]['group_id'])
                if len(groupName) == 1:
                   groupName = groupName[0]['name']
                else:
                   groupName = 'N/A'   
                baseOid = OidSensorFunction.getBaseOID(sensorList[num]['group_id'])
                oid = baseOid + "." + str(sensorList[num]['oid'])
                value, timestamp = sensorList[num]['value'], sensorList[num]['timestamp']
                serviceData = ServiceProjectFunction.getServiceInfo("sensor" + str(sensorList[num]['group_id']))
                if value == None:
                   value, timestamp = '-', '-'   
                if serviceData['state'] == 'active':     
                   sensorDetail = {"oid": oid, "groupName": groupName, "sensorName": sensorList[num]['name'], "value": value, 
                                  "condition": sensorList[num]['conditions'], "timestamp": str(timestamp)}
                else:
                   sensorDetail = {"oid": oid, "groupName": groupName, "sensorName": sensorList[num]['name'], "value": "-", 
                                  "condition": "-", "timestamp": "-"}
                sensorDatas[getSensorGroup[item]['name']].append(sensorDetail)
    sensorList = SensorListDB.select()
    sensorData = []
    if len(sensorList) > 0 :
       for num in range(len(sensorList)):
          groupName = SensorGroupDB.selectOne(sensorList[num]['group_id'])
          if len(groupName) == 1:
             groupName = groupName[0]['name']
          else:
             groupName = 'N/A'   
          baseOid = OidSensorFunction.getBaseOID(sensorList[num]['group_id'])
          oid = baseOid + "." + str(sensorList[num]['oid'])
          value, timestamp = sensorList[num]['value'], sensorList[num]['timestamp']
          serviceData = ServiceProjectFunction.getServiceInfo("sensor" + str(sensorList[num]['group_id']))
          if value == None:
             value, timestamp = '-', '-'   
          if serviceData['state'] == 'active':     
             sensorDetail = {"oid": oid, "groupName": groupName, "sensorName": sensorList[num]['name'], "value": value, 
                             "condition": sensorList[num]['conditions'], "timestamp": str(timestamp)}
          else:
             sensorDetail = {"oid": oid, "groupName": groupName, "sensorName": sensorList[num]['name'], "value": "-", 
                             "condition": "-", "timestamp": "-"}
          if sensorList[num]['conditions'] == 'Min': totalSensorMin+=1
          elif sensorList[num]['conditions'] == 'Max': totalSensorMax+=1
          elif sensorList[num]['conditions'] == 'Normal': totalSensorOk+=1
          elif sensorList[num]['conditions'] == 'Error': totalSensorError+=1
          elif sensorList[num]['conditions'] == 'Alarm Inactive': totalAlarmInactive +=1
          elif sensorList[num]['conditions'] == 'Tolerance': totalTolerance+=1
          else: totalSensorInactive+=1
          sensorData.append(sensorDetail)
    sensorStatus = {"ok":totalSensorOk, "max":totalSensorMax, "min":totalSensorMin, "error":totalSensorError, "alarm":totalAlarmInactive, "inactive":totalSensorInactive, "tolerance": totalTolerance}
      
    actuatorGroup = ActuatorGroupDB.select()
    actuatorList = ActuatorListDB.select()
    infoActuator, actuatorService = [], 0
    if len(actuatorGroup) > 0 :
       for item in range((len(actuatorGroup))):
          infoActuator, actuatorService = parseData(actuatorGroup[item]['name'], 'actuator' + str(actuatorGroup[item]['number']), infoActuator, actuatorService)         
    resultData = {}
    resultData['service'] = {"node": infoNode, "sensor": infoSensor, "actuator": infoActuator}
    resultData['summary'] = {"sensor": sensorData, "actuator": actuatorList}
    # resultData['summarys'] = {"sensor": sensorDatas}
    
    # Node
    if nodeService == 8: nodeService = 'OK'  
    else: nodeService = 'Warning'    
    # Actuator
    if actuatorService == len(actuatorGroup): actuatorService = 'OK'
    else: actuatorService = 'Warning'
    # Sensor
    if sensorService == len(getSensorGroup): sensorService = 'OK'
    else: sensorService = 'Warning'
    if nodeService == 'OK' and sensorService == 'OK' and actuatorService == 'OK':
       overall = 'OK'
    else:
       overall = 'Warning'
       
    return render_template('dashboard/dashboardPage.html', rule=rule, sessionData=sessionData, projectData=projectData, deviceSetting=deviceSetting,  
                           sensorStatus=sensorStatus, nodeService=nodeService, sensorService=sensorService, actuatorService=actuatorService, overall=overall,
                           resultData=resultData, tab=tab)

@app.route('/login')
def login():
   rule = str(request.url_rule)
   sessionData = generalFunction.checkSession()
   projectData = generalFunction.getProjectSetting()
   deviceSetting = dbFunction.getDeviceSetting()
   return render_template('login.html', rule=rule, sessionData=sessionData, projectData=projectData, deviceSetting=deviceSetting)

@app.route('/login', methods=['POST'])
def login_post():
    getUsername = request.form.get('username')
    getPassword = request.form.get('password')
    getFlag = request.form.get('flag')
    port = generalFunction.getPortSetting()
    data = {
       "username": getUsername,"password": getPassword,"flag": getFlag
    }
    try:
       login = requests.post('http://localhost:' + port + '/api/project/login', data=data)
       check = login.text
    except Exception as e:
       check = 0
    if check == "2":
       return redirect(url_for('index'))
    elif check == "1":
       flash('Wrong Password. Please Check Your Login and Try Again')
       return redirect(url_for('login'))
    else:
       flash('Wrong Username. Please Check Your Login and Try Again')
       return redirect(url_for('login'))

@app.route('/logout')
def logout():
   sessionData = generalFunction.checkSession()
   port = generalFunction.getPortSetting()
   data = {"id":sessionData['id']}
   try:
      logout = requests.post('http://localhost:' + port + '/api/project/logout', data=data)
   except:
      pass
   return redirect(url_for('index'))

# Menu Setting -> Device   
@app.route('/setting/device', methods= ['GET', 'POST'])
def settingDevice():
   rule = str(request.url_rule)
   sessionData = generalFunction.checkSession()   
   projectData = generalFunction.getProjectSetting()
   deviceSetting = dbFunction.getDeviceSetting()
   result = {'state':'', 'message':''}
   if 'result' in request.args:
        result = json.loads(request.args['result'])
   if request.method == 'POST':
      deviceUID = request.form.get('deviceUID')
      deviceName = request.form.get('deviceName')
      deviceVersion = request.form.get('deviceVersion')      
      if len(deviceSetting) == 0 :
         result = dashboardFunction.settingDevice.insert(deviceUID, deviceName, deviceVersion)
      else :
         result = dashboardFunction.settingDevice.update(deviceUID, deviceName, deviceVersion)
      return redirect(url_for('settingDevice', result=result))
   if int(sessionData['state']) == 0:
      flash('Please Login to Access the Page')  
      return redirect(url_for('login'))
   return render_template('setting/device/deviceSetting.html', rule=rule, sessionData=sessionData, projectData=projectData, deviceSetting=deviceSetting, result=result)

@app.route('/setting/feature', methods=['GET', 'POST'])
def settingFeature():
   rule = str(request.url_rule)
   sessionData = generalFunction.checkSession()  
   projectData = generalFunction.getProjectSetting()
   feature_setting = dbFunction.getFeatureSetting()
   deviceSetting = dbFunction.getDeviceSetting()
   intervalRoutine = IntervalRoutineMonitorDB.select()
   routineLog = IntervalRoutineLogDB.select()
   sensorDetail = SensorListDB.select()
   intervalRoutineCount = {}
   routineLogCount = {}
   for x in range(len(intervalRoutine)):
      count = 0
      for y in range(len(sensorDetail)):
         if str(intervalRoutine[x]['id']) == str(sensorDetail[y]['monitor']):
            count = count + 1
      intervalRoutineCount[str(intervalRoutine[x]['id'])] = str(count)
   for x in range(len(routineLog)):
      count = 0
      for y in range(len(sensorDetail)):
         if str(routineLog[x]['id']) == str(sensorDetail[y]['log']):
            count = count + 1
      routineLogCount[str(routineLog[x]['id'])] = str(count)
   result = {'state':'', 'message':''}
   tab = 'monitor'
   if 'tab' in request.args:
      tab = request.args['tab']
   if 'result' in request.args:
      result = json.loads(request.args['result'])
   if request.method == 'POST':
      tab = request.form.get('tab')
      if tab == 'monitor':
         action = request.form.get('action')
         
         if action == 'monitor-setting':
            routineMonitor = request.form.get('routineMonitor')
            bufferMonitor = request.form.get('bufferMonitor')
            bufferMonitorInterval = request.form.get('bufferMonitorInterval')
            bufferMonitorUnit = request.form.get('bufferMonitorUnit')
            alarmMonitor = request.form.get('alarmMonitor')
            alarmMonitorUnit = request.form.get('alarmMonitorUnit')
            alarmMonitorInterval = request.form.get('alarmMonitorInterval')
            result = dashboardFunction.settingFeature.monitoring.update(routineMonitor, bufferMonitor, bufferMonitorInterval, bufferMonitorUnit, alarmMonitor, 
                                                                       alarmMonitorUnit, alarmMonitorInterval)
            return redirect(url_for('settingFeature', tab=tab, result=result))
         elif action == 'monitor-interval-add':
            interval = request.form.get('interval')
            unit = request.form.get('unit')
            state = request.form.get('state')
            result = dashboardFunction.settingFeature.monitoring.addRoutineInterval(interval, unit, state)
            return redirect(url_for('settingFeature', tab=tab, result=result))
         elif action == 'monitor-routine-update':
            idVal = request.form.get('idVal')
            interval = request.form.get('interval')
            unit = request.form.get('unit')
            state = request.form.get('state')
            result = dashboardFunction.settingFeature.monitoring.updateRoutineInterval(interval, unit, state, idVal)
            return redirect(url_for('settingFeature', tab=tab, result=result))
         elif action == 'monitor-routine-delete':
            idVal = request.form.get('idVal')
            result = dashboardFunction.settingFeature.monitoring.deleteRoutineInterval(idVal)
            return redirect(url_for('settingFeature', tab=tab, result=result))

      elif tab == 'sync':
         synchronize = request.form.get('synchronize')
         synchronizeInterval = request.form.get('synchronizeInterval')
         synchronizeUnit = request.form.get('synchronizeUnit')
         syncNode = request.form.get('syncNode')
         syncSensor = request.form.get('syncSensor')
         syncActuator = request.form.get('syncActuator')
         result = dashboardFunction.settingFeature.synchronize.update(synchronize, synchronizeInterval, synchronizeUnit, syncNode, syncSensor, syncActuator)
         return redirect(url_for('settingFeature', tab=tab, result=result))

      elif tab == 'notif':
         notification = request.form.get('notification')
         notificationInterval = request.form.get('notificationInterval')
         notificationUnit = request.form.get('notificationUnit')
         notifNodeWeb = request.form.get('notifNodeWeb')
         notifNodeWA = request.form.get('notifNodeWA')
         notifNodeEmail = request.form.get('notifNodeEmail')
         notifNodeTelegram = request.form.get('notifNodeTelegram')
         notifSensorWeb = request.form.get('notifSensorWeb')
         notifSensorWA = request.form.get('notifSensorWA')
         notifSensorEmail = request.form.get('notifSensorEmail')
         notifSensorTelegram = request.form.get('notifSensorTelegram')
         notifActuatorWeb = request.form.get('notifActuatorWeb')
         notifActuatorWA = request.form.get('notifActuatorWA')
         notifActuatorEmail = request.form.get('notifActuatorEmail')
         notifActuatorTelegram = request.form.get('notifActuatorTelegram')
         result = dashboardFunction.settingFeature.notification.update(notification, notificationInterval, notificationUnit, notifNodeWeb, notifNodeWA, notifNodeEmail, notifNodeTelegram, notifSensorWeb, notifSensorWA, notifSensorEmail, notifSensorTelegram, notifActuatorWeb, notifActuatorWA, notifActuatorEmail, notifActuatorTelegram)
         return redirect(url_for('settingFeature', tab=tab, result=result))
   
      elif tab == 'log':
         action = request.form.get('action')
         if action == 'log-setting' :
            log = request.form.get('log')
            duration_log = request.form.get("duration_log")
            duration_state = request.form.get("duration_state")
            backup_monthly = request.form.get("backup_monthly")
            result = dashboardFunction.settingFeature.internalLog.update(log, duration_log, duration_state, backup_monthly)
            return redirect(url_for('settingFeature', tab=tab, result=result))
         elif action == 'log-routine-add' :
            interval = request.form.get('interval')
            unit = request.form.get('unit')
            state = request.form.get('state')
            result = dashboardFunction.settingFeature.internalLog.addRoutineInterval(interval, unit, state)
            return redirect(url_for('settingFeature', tab=tab, result=result))
         elif action == 'log-routine-update' :
            idVal = request.form.get('id')
            interval = request.form.get('interval')
            unit = request.form.get('unit')
            state = request.form.get('state')
            result = dashboardFunction.settingFeature.internalLog.updateRoutineInterval(interval, unit, state, idVal)
            return redirect(url_for('settingFeature', tab=tab, result=result))
         elif action == 'log-routine-delete' :
            idVal = request.form.get('id')
            result = dashboardFunction.settingFeature.internalLog.deleteRoutineInterval(idVal)
            return redirect(url_for('settingFeature', tab=tab, result=result))
         
      elif tab == 'system-service':
         action = request.form.get('action')
         if action == 'start-all-system-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('start', 'all')
            return redirect(url_for('settingFeature', tab=tab, result=result))
         elif action == 'restart-all-system-service' :
            result= dashboardFunction.settingFeature.systemService.runAll('restart', 'all')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'stop-all-system-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('stop', 'all')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'start-all-node-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('start', 'node')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'restart-all-node-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('restart', 'node')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'stop-all-node-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('stop', 'node')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'start-all-sensor-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('start', 'sensor')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'restart-all-sensor-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('restart', 'sensor')            
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'stop-all-sensor-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('stop', 'sensor')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'start-all-actuator-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('start', 'actuator')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'restart-all-actuator-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('restart', 'actuator')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         elif action == 'stop-all-actuator-service' :
            result = dashboardFunction.settingFeature.systemService.runAll('stop', 'actuator')
            return redirect(url_for('settingFeature', tab='system-service', result=result))
         
      elif tab == 'system-alarm':   
         action = request.form.get('action')
         if action == 'reset-alarm-sensor-only' :
            result = dashboardFunction.settingFeature.systemAlarm.resetOnly()
            return redirect(url_for('settingFeature', tab='system-alarm', result=result))
         elif action == 'reset-alarm-sensor-with-restart' :
            result = dashboardFunction.settingFeature.systemAlarm.resetWithRestart()            
            return redirect(url_for('settingFeature', tab='system-alarm', result=result))
         

   if int(sessionData['state']) == 0:
      flash('Please Login to Access the Page')  
      return redirect(url_for('login'))
   

   return render_template('setting/feature/featureSetting.html', rule=rule, sessionData=sessionData, projectData=projectData, feature_setting=feature_setting, 
                                                                 deviceSetting=deviceSetting, intervalRoutine=intervalRoutine, routineLog=routineLog, tab=tab, 
                                                                 intervalRoutineCount=intervalRoutineCount, routineLogCount=routineLogCount, result=result)  

@app.route('/setting/server', methods=['GET', 'POST'])
def settingServerPage():
   rule = str(request.url_rule)
   sessionData = generalFunction.checkSession()  
   projectData = generalFunction.getProjectSetting()
   deviceSetting = dbFunction.getDeviceSetting()
   result = {'state':'', 'message':''}
   if 'result' in request.args:
      result = json.loads(request.args['result'])
   tab = 'httpConfig'
   if 'tab' in request.args:
      tab = request.args['tab']    
   if request.method == 'POST':
      tab = request.form.get('tab')
      action = request.form.get('action')
      if action == 'httpConfig' or action == 'mqttConfig':
         server = action.replace("Config","")   
         domainAddress = request.form.get('domainAddress')
         ipAddress = request.form.get('ipAddress')
         port = request.form.get('port')
         username = request.form.get('user')
         password = request.form.get('passw')
         if server == 'mqtt':
            ServiceProjectFunction.restartNetworkService()
         result = dashboardFunction.settingServer.updateConfig(domainAddress, ipAddress, port, username, password, server)
         return redirect(url_for('settingServerPage', tab=tab, result=result))
      elif action == 'httpAuth-clear':
         result = dashboardFunction.settingServer.http.deleteAuth()
         return redirect(url_for('settingServerPage', tab=tab, result=result))
      elif action == 'httpAuth-new':
         result = dashboardFunction.settingServer.http.getAuth()
         return redirect(url_for('settingServerPage', tab=tab, result=result))
      elif action == 'httpApi-add':
         name = request.form.get('name')
         parameter = request.form.get('parameter')
         type = request.form.get('type')
         api = request.form.get('api')
         result = dashboardFunction.settingServer.http.insertAPI(name, parameter, type, api)
         return redirect(url_for('settingServerPage', tab=tab, result=result))
      elif action == 'httpApi-update':
         id = request.form.get('id')
         name = request.form.get('name')
         parameter = request.form.get('parameter')
         type = request.form.get('type')
         api = request.form.get('api')
         result = dashboardFunction.settingServer.http.updateAPI(name, parameter, type, api, id)
         return redirect(url_for('settingServerPage', tab=tab, result=result))   
      elif action == 'httpApi-delete':
         id = request.form.get('id')
         result = dashboardFunction.settingServer.http.deleteAPI(id)
         return redirect(url_for('settingServerPage', tab=tab, result=result))
      elif action == 'mqttTopic-add':
         name = request.form.get('name')
         parameter = request.form.get('parameter')
         topic = request.form.get('topic')
         result = dashboardFunction.settingServer.mqtt.insertTopic(name, parameter, topic)
         return redirect(url_for('settingServerPage', tab=tab, result=result)) 
      elif action == 'mqttTopic-update':
         id = request.form.get('id')
         name = request.form.get('name')
         parameter = request.form.get('parameter')
         topic = request.form.get('topic')
         result = dashboardFunction.settingServer.mqtt.updateTopic(name, parameter, topic, id)
         return redirect(url_for('settingServerPage', tab=tab, result=result))
      elif action == 'mqttTopic-delete':
         id = request.form.get('id')
         result = dashboardFunction.settingServer.mqtt.deleteTopic(id)
         return redirect(url_for('settingServerPage', tab=tab, result=result))               
   serverData = serverFunction.getServerData()
   if int(sessionData['state']) == 0:
      flash('Please Login to Access the Page')  
      return redirect(url_for('login'))  
   return render_template('setting/server/serverSetting.html', rule=rule, sessionData=sessionData, projectData=projectData, deviceSetting=deviceSetting, tab=tab, 
                                                               result=result, serverData=serverData)

@app.route('/setting/sensor', methods=['GET', 'POST'])
def settingSensorPage():
   groupID, groupID2, groupID3 = 'All', 'All', 'All'
   rule = str(request.url_rule)
   sessionData = generalFunction.checkSession()  
   projectData = generalFunction.getProjectSetting()
   feature_setting = dbFunction.getFeatureSetting()
   deviceSetting = dbFunction.getDeviceSetting()
   sensorGroup = SensorGroupDB.select()
   sensorDetail = SensorListDB.select()
   parameterGroup = SensorParameterGroupDB.select()
   parameterList = SensorParameterListDB.select()
   formulas = CalibrateFormulaDB.select()
   monitorInterval = IntervalRoutineMonitorDB.selectEnable()
   logInterval = IntervalRoutineLogDB.selectEnable()
   sensorPortConfig = SensorPortConfigDB.select()
   
   oid = []
   base_oid = "1.3.6.1.4.1.19719"
   for item in range(len(sensorDetail)):
      oid_number = SensorGroupDB.selectOneOid(sensorDetail[item]['group_id'])[0]["oid"]
      oid.append(F"{base_oid}.{oid_number}")
   
   
   if 'groupID' in request.args:
      groupID = request.args['groupID']
      if groupID != 'All':
         sensorDetail = SensorListDB.selectByGroupFull(groupID)
         oid.clear()
         for item in range(len(sensorDetail)):
            base_oid = "1.3.6.1.4.1.19719"
            oid_number = SensorGroupDB.selectOneOid(sensorDetail[item]['group_id'])[0]["oid"]
            oid.append(F"{base_oid}.{oid_number}")        
   elif 'groupID2' in request.args:
      groupID2 = request.args['groupID2']
      if groupID2 != 'All':
         parameterGroup = SensorParameterGroupDB.selectByGroupFull(groupID2)
   elif 'groupID3' in request.args:
      groupID3 = request.args['groupID3']
      if groupID3 != 'All':
         parameterList = SensorParameterListDB.selectByGroupFull(groupID3)

   result = {"state": "", "message": ""}
   if 'result' in request.args:
      result = json.loads(request.args['result'])

   tab = 'sensor-management-group'
   if 'tab' in request.args:
      tab = request.args['tab']

   if request.method == 'POST':
      tab = request.form.get('tab')

      if tab == 'sensor-management-group' :
         action = request.form.get('action')
         if action == 'sensorGroupAdd':
            number = request.form.get("number")
            oid_group = request.form.get("oid_group")
            name = request.form.get('name')
            interval = request.form.get('interval')
            unit = request.form.get('unit')
            frekuensi = request.form.get('frekuensi')
            enterAlarm = request.form.get('enterAlarm')
            exitAlarm = request.form.get('exitAlarm')
            errorAlarm = request.form.get('errorAlarm')
            result = dashboardFunction.settingSensor.group.insert(number, oid_group, name, interval, unit, frekuensi, enterAlarm, exitAlarm, errorAlarm)           
            return redirect(url_for('settingSensorPage', tab=tab, result=result))
         
         elif action == 'sensorGroupUpdate':
            name = request.form.get('name')
            interval = request.form.get('interval')
            unit = request.form.get('unit')
            frekuensi = request.form.get('frekuensi')
            enterAlarm = request.form.get('enterAlarm')
            exitAlarm = request.form.get('exitAlarm')
            errorAlarm = request.form.get('errorAlarm')
            stateSensor = request.form.get('stateSensor')
            id = request.form.get('id')
            oid_group = request.form.get("oid_group")
            number = request.form.get("number")
            service_id = request.form.get('service_id')

            last_number = request.form.get("last_number")
            last_name = request.form.get("last_name")
            last_oid_group = request.form.get("last_oid")

            result = dashboardFunction.settingSensor.group.update(number, oid_group, name, interval, unit, frekuensi, service_id, id, enterAlarm, exitAlarm, errorAlarm, stateSensor,
                                                                  last_number, last_name, last_oid_group)
            return redirect(url_for('settingSensorPage', tab=tab, result=result))
         
         elif action == 'sensorGroupDelete':
            id = request.form.get('id')
            number = request.form.get("number")
            name = request.form.get('name')
            serviceId = request.form.get('serviceId')
            port = generalFunction.getPortSetting()
            result = dashboardFunction.settingSensor.group.delete(id, number, name, serviceId, port)
            return redirect(url_for('settingSensorPage', tab=tab, result=result))


      elif tab == 'sensor-management-list' :
         action = request.form.get('action')
         if action == 'sensorListAdd':
            group_id = request.form.get('group_id')
            sensor_id = request.form.get('sensor_id')
            oid = request.form.get('oid')
            name = request.form.get('name')
            calibrate = request.form.get('calibrate')
            formula = request.form.get('formula')
            oid_tipe = request.form.get('oid_tipe')
            monitor = request.form.get('monitor')
            log = request.form.get('log')
            name = request.form.get('name')
            result = dashboardFunction.settingSensor.list.insert(sensor_id, oid, group_id, name, calibrate, formula, oid_tipe, monitor, log)
            return redirect(url_for('settingSensorPage', tab=tab, result=result, groupID=group_id))
         
         elif action == 'sensorListUpdate' :
            groupID = request.form.get('groupID')
            id = request.form.get('id')
            group_id = request.form.get('group_id')
            sensor_id = request.form.get('sensor_id')
            oid = request.form.get('oid')
            name = request.form.get('name')
            calibrate = request.form.get('calibrate')
            formula = request.form.get('formula')
            oid_tipe = request.form.get('oid_tipe')
            monitor = request.form.get('monitor')
            log = request.form.get('log')
            name = request.form.get('name')
            alarm = request.form.get('alarm')
            alarm_type = request.form.get('alarm_type')
            min = request.form.get('min')
            max = request.form.get('max')
            stateSensorList = request.form.get('stateSensorList')

            if sensorDetail :
               for itemSensor in range(len(sensorDetail)):
                  base_oid = "1.3.6.1.4.1.19719"
                  oid_number = SensorGroupDB.selectOneOid(sensorDetail[item]['group_id'])[0]["oid"]
                  base_oid = F"{base_oid}.{oid_number}"
                  last_oid = sensorDetail[itemSensor]['oid']
                  Oid = f'{base_oid}.{last_oid}'
                  script = "sudo rm /tmp/" + Oid
                  os.system(script)

            result = dashboardFunction.settingSensor.list.update(sensor_id, oid, group_id, name, calibrate, formula, oid_tipe, monitor, log, alarm, min, max, alarm_type, stateSensorList, id)
            return redirect(url_for('settingSensorPage', tab=tab, result=result, groupID=groupID))
         elif action == 'sensorListDelete' :
            id = request.form.get('id')
            name = request.form.get('name')
            groupID = request.form.get('groupID')
            result = dashboardFunction.settingSensor.list.delete(id, name)
            return redirect(url_for('settingSensorPage', tab=tab, result=result, groupID=groupID)) 
         elif action == 'sensorListFilter' :
            groupID = request.form.get('groupID')
            return redirect(url_for('settingSensorPage', tab=tab, groupID=groupID))  

      elif tab == 'sensor-management-param-group' :
         action = request.form.get('action')
         if action == 'sensorParamGroupAdd' :
            group_id = request.form.get('group_id')
            name = request.form.get('name')
            parameter = request.form.get('parameter')
            value = request.form.get('value')
            result = dashboardFunction.settingSensor.parameterGroup.insert(group_id, name, parameter, value)
            return redirect(url_for('settingSensorPage', tab=tab, result=result, groupID2=group_id))
         
         elif action == 'sensorParamGroupUpdate' :
            groupID2 = request.form.get('groupID2')
            id = request.form.get('id')
            group_id = request.form.get('group_id')
            name = request.form.get('name')
            parameter = request.form.get('parameter')
            value = request.form.get('value')
            result = dashboardFunction.settingSensor.parameterGroup.update(group_id, name, parameter, value, id)
            return redirect(url_for('settingSensorPage', tab=tab, result=result, groupID2=groupID2))
         
         elif action == 'sensorParamGroupDelete' :
            groupID2 = request.form.get('groupID2')
            id = request.form.get('id')
            name = request.form.get('name')
            result = dashboardFunction.settingSensor.parameterGroup.delete(id, name)
            return redirect(url_for('settingSensorPage', tab=tab, result=result, groupID2=groupID2))  
         
         elif action == 'sensorParamGroupFilter' :
            groupID2 = request.form.get('groupID2')
            return redirect(url_for('settingSensorPage', tab=tab, groupID2=groupID2))
      
      elif tab == 'sensor-management-param-list' :
         action = request.form.get('action')
         if action == 'sensorParamListAdd' :
            groupID3 = request.form.get('groupID3')
            sensorID = request.form.get('sensor_id')
            name = request.form.get('name')
            parameter = request.form.get('parameter')
            value = request.form.get('value')
            result = dashboardFunction.settingSensor.parameterList.insert(sensorID, name, parameter, value)
            return redirect(url_for('settingSensorPage', tab=tab, result=result, groupID3=groupID3))
         
         elif action == 'sensorParamListFilter' :
            groupID3 = request.form.get('groupID3')
            return redirect(url_for('settingSensorPage', tab=tab, groupID3=groupID3))
         
         elif action == 'sensorParamListUpdate' :
            groupID3 = request.form.get('groupID3')
            id = request.form.get('id')
            sensorID = request.form.get('sensor_id')
            name = request.form.get('name')
            parameter = request.form.get('parameter')
            value = request.form.get('value')
            result = dashboardFunction.settingSensor.parameterList.update(sensorID, name, parameter, value, id)
            return redirect(url_for('settingSensorPage', tab=tab, result=result, groupID3=groupID3))
         
         elif action == 'sensorParamListDelete' :
            groupID3 = request.form.get('groupID3')
            id = request.form.get('id')
            result = dashboardFunction.settingSensor.parameterList.delete(id)
            return redirect(url_for('settingSensorPage', tab=tab, result=result, groupID3=groupID3))

      elif tab == "sensor-port-config":
         ports = {}
         for i in range(1, 7):
            port = F"port_{i}"
            typePort = request.form.get(F"typePort{i}")
            modbusId = request.form.get(F"modbusIdP{i}")
            digitalPin = request.form.get(F"digitalPinP{i}")
            lastPort = request.form.get(F"lastP{i}")
            ports[port] = {
               "typePort": typePort,
               "modbusId": modbusId,
               "digitalPin": digitalPin,
               "lastPort": lastPort,
            }
         result = dashboardFunction.settingSensor.PortConfig.update(ports)
         return redirect(url_for('settingSensorPage', tab=tab, result=result))

   if int(sessionData['state']) == 0:
      flash('Please Login to Access the Page')  
      return redirect(url_for('login')) 

   return render_template("setting/sensor/sensor_setting.html", rule=rule, sessionData=sessionData, projectData=projectData, deviceSetting=deviceSetting, 
                          feature_setting=feature_setting, tab=tab, result=result, sensorGroup=sensorGroup, sensorDetail=sensorDetail,  monitorInterval=monitorInterval,  
                          logInterval=logInterval, oid=oid, base_oid=base_oid, formulas=formulas, parameterGroup=parameterGroup, parameterList=parameterList, 
                          groupID=groupID, groupID2=groupID2, groupID3=groupID3, sensorPortConfig=sensorPortConfig)


@app.route('/setting/actuator', methods=['GET', 'POST'])
def settingActuatorPage():
   rule = str(request.url_rule)
   sessionData = generalFunction.checkSession()  
   projectData = generalFunction.getProjectSetting()
   feature_setting = dbFunction.getFeatureSetting()
   deviceSetting = dbFunction.getDeviceSetting()
   actuatorData = ActuatorGroupDB.select()
   actuatorList = ActuatorListDB.selectFull()
   actuatorParamGroup = ActuatorParameterGroupDB.selectFull()
   actuatorParamList = ActuatorParameterListDB.selectFull()
   actuatorSchedule = ActuatorScheduleDB.select()
   actuatorNow, actuatorNow2, actuatorNow3, actuatorNow4 = 'All', 'All', 'All', 'All'
   if 'actuatorNow' in request.args:
      actuatorNow = request.args['actuatorNow']
      if actuatorNow != 'All':
         actuatorList = ActuatorListDB.selectByActuatorGroupFull(actuatorNow)
   elif 'actuatorNow2' in request.args:
      actuatorNow2 = request.args['actuatorNow2']
      if actuatorNow2 != 'All':
         actuatorParamGroup = ActuatorParameterGroupDB.selectByActuatorGroupFull(actuatorNow2)
   if 'actuatorNow3' in request.args:
      actuatorNow3 = request.args['actuatorNow3']
      if actuatorNow3 != 'All':
         actuatorParamList = ActuatorParameterListDB.selectByActuatorGroupFull(actuatorNow3)
   elif 'actuatorNow4' in request.args:
      actuatorNow4 = request.args['actuatorNow4']
      if actuatorNow4 != 'All':
         actuatorSchedule = ActuatorScheduleDB.selectByActuatorListFull(actuatorNow4)      

   result = {'state':'', 'message':''}
   if 'result' in request.args:
      result = json.loads(request.args['result'])
   tab = 'groupActuator'
   if 'tab' in request.args:
      tab = request.args['tab']  

   if request.method == 'POST':
      tab = request.form.get('tab')
      if tab == 'groupActuator' :
         action = request.form.get('action')
         if action == 'groupActuatorAdd':
            name = request.form.get('name')
            number = request.form.get('number')
            interval = request.form.get('interval')
            unit = request.form.get('unit')
            result = dashboardFunction.SettingActuator.Group.insert(number, name, interval, unit)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result))
         elif action == 'groupActuatorUpdate':
            id = request.form.get('id')
            number = request.form.get('number')
            name = request.form.get('name')
            interval = request.form.get('interval')
            unit = request.form.get('unit')
            last_number = request.form.get('last_number')
            service_id = request.form.get('service_id')
            state = request.form.get(f'update_state{id}')
            last_name = request.form.get('last_name')
            result = dashboardFunction.SettingActuator.Group.update(number, name, interval, unit, id, last_number, last_name, service_id, state)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result))
         elif action == 'groupActuatorDelete':
            id = request.form.get('id')
            name = request.form.get('name')
            number = request.form.get('number')
            service_id = request.form.get('service_id')
            result = dashboardFunction.SettingActuator.Group.delete(id, name, number, service_id)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result))
      elif tab == 'listActuator' :
         action = request.form.get('action')
         if action == 'listActuatorAdd':
            actuator_custom_id = request.form.get('custom_id')
            actuator_group_id = request.form.get('actuator_group_id')
            name = request.form.get('name')
            type_actuator = request.form.get('type_actuator')
            result = dashboardFunction.SettingActuator.List.insert(actuator_group_id, name, actuator_custom_id, type_actuator)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result))
         elif action == 'listActuatorUpdate':
            id = request.form.get('id')
            actuator_group_id = request.form.get('actuator_group_id')
            actuator_custom_id = request.form.get('custom_id')
            name = request.form.get('name')
            type_actuator = request.form.get('type_actuator')
            last_actuator_custom_id = request.form.get('last_custom_id')
            state = request.form.get(f'update_state{id}')
            result = dashboardFunction.SettingActuator.List.update(actuator_group_id, name, actuator_custom_id, type_actuator, id, last_actuator_custom_id, state)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result))
         elif action == 'listActuatorDelete':
            id = request.form.get('id')
            name = request.form.get('name')
            result = dashboardFunction.SettingActuator.List.delete(id, name)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result))
         elif action == 'listActuatorFilter':
            actuatorNow = request.form.get('actuatorNow')
            return redirect(url_for('settingActuatorPage', tab=tab, actuatorNow=actuatorNow))
      elif tab == 'paramActuatorGroup':
         action = request.form.get('action')
         if action == 'paramActuatorGroupAdd':
            actuatorNow2 = request.form.get('actuatorNow2')
            actuatorGroupId = request.form.get('actuator_group_id')
            name = request.form.get('name')
            parameter = request.form.get('parameter')
            value = request.form.get('value')
            result = dashboardFunction.SettingActuator.ParameterGroup.insert(actuatorGroupId, name, parameter, value)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result, actuatorNow2=actuatorNow2))
         elif action == 'paramActuatorGroupUpdate':
            actuatorNow2 = request.form.get('actuatorNow2')
            id = request.form.get('id')
            actuatorGroupId = request.form.get('actuator_group_id')
            name = request.form.get('name')
            parameter = request.form.get('parameter')
            value = request.form.get('value')
            last_actuator_group_id = request.form.get('last_actuator_group_id')
            last_parameter = request.form.get('last_parameter')
            result = dashboardFunction.SettingActuator.ParameterGroup.update(actuatorGroupId, name, parameter, value, last_actuator_group_id, last_parameter, id)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result, actuatorNow2=actuatorNow2)) 
         elif action == 'paramActuatorGroupDelete':
            actuatorNow2 = request.form.get('actuatorNow2')
            id = request.form.get('id')
            name = request.form.get('name')
            result = dashboardFunction.SettingActuator.ParameterGroup.delete(id, name)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result, actuatorNow2=actuatorNow2))
         elif action == 'paramActuatorGroupFilter':
            actuatorNow2 = request.form.get('actuatorNow2')
            return redirect(url_for('settingActuatorPage', tab=tab, actuatorNow2=actuatorNow2))
      elif tab == 'paramActuatorList':
         action = request.form.get('action')
         if action == 'paramActuatorListAdd':
            actuatorNow3 = request.form.get('actuatorNow3')
            actuatorListId = request.form.get('actuator_list_id')
            name = request.form.get('name')
            parameter = request.form.get('parameter')
            value = request.form.get('value')
            result = dashboardFunction.SettingActuator.ParameterList.insert(actuatorListId, name, parameter, value)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result, actuatorNow3=actuatorNow3))
         elif action == 'paramActuatorListUpdate':
            actuatorNow3 = request.form.get('actuatorNow3')
            id = request.form.get('id')
            actuatorListId = request.form.get('actuator_list_id')
            name = request.form.get('name')
            parameter = request.form.get('parameter')
            value = request.form.get('value')
            last_actuator_list_id = request.form.get('last_actuator_list_id')
            last_parameter = request.form.get('last_parameter')
            result = dashboardFunction.SettingActuator.ParameterList.update(actuatorListId, name, parameter, value, last_actuator_list_id, last_parameter, id)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result, actuatorNow3=actuatorNow3)) 
         elif action == 'paramActuatorListDelete':
            actuatorNow3 = request.form.get('actuatorNow3')
            id = request.form.get('id')
            name = request.form.get('name')
            result = dashboardFunction.SettingActuator.ParameterList.delete(id, name)
            return redirect(url_for('settingActuatorPage', tab=tab, result=result, actuatorNow3=actuatorNow3))
         elif action == 'paramActuatorListFilter':
            actuatorNow3 = request.form.get('actuatorNow3')
            return redirect(url_for('settingActuatorPage', tab=tab, actuatorNow3=actuatorNow3))
      elif tab == 'scheduleActuator':
         action = request.form.get('action')   
         if action == 'scheduleActuatorFilter':
            actuatorNow4 = request.form.get('actuatorNow4')
            return redirect(url_for('settingActuatorPage', tab=tab, actuatorNow4=actuatorNow4))
   if int(sessionData['state']) == 0:
      flash('Please Login to Access the Page')  
      return redirect(url_for('login'))  
   return render_template('setting/actuator/actuator_setting.html',  rule=rule, sessionData=sessionData, projectData=projectData, deviceSetting=deviceSetting, 
                                                                    feature_setting=feature_setting, tab=tab, result=result, actuatorList=actuatorList, 
                                                                    actuatorParamGroup=actuatorParamGroup, actuatorSchedule=actuatorSchedule, actuatorNow=actuatorNow,
                                                                    actuatorNow2=actuatorNow2, actuatorData=actuatorData, actuatorParamList=actuatorParamList,
                                                                    actuatorNow3=actuatorNow3, actuatorNow4=actuatorNow4)

@app.route('/setting/extension', methods=['GET', 'POST'])
def settingExtensionDevice():
   time = times.now()
   rule = str(request.url_rule)
   sessionData = generalFunction.checkSession()  
   projectData = generalFunction.getProjectSetting()
   feature_setting = dbFunction.getFeatureSetting()
   deviceSetting = dbFunction.getDeviceSetting()
   extensionDeviceData = EnvironmentDeviceDB.select()
   extensionMasterSensorData = EnvironmentMasterSensorDB.select()
   extensionMasterParameterData = EnvironmentMasterParameterDB.select()
   powerDeviceData = PowerDeviceDB.select()
   powerMasterSensorData = PowerMasterSensorDB.select()
   powerMasterParameterData = PowerMasterParameterDB.select()
   calculate_port = dashboardFunction.settingExtensionDevice.environmentExtension.device.calculatePorts(extensionDeviceData)

   result = {'state':'', 'message':''}
   tab = 'environment-general'
   if 'tab' in request.args:
      tab = request.args['tab']
   
   if 'result' in request.args:
      result = json.loads(request.args['result'])

   if request.method == 'POST':
      tab = request.form.get('tab')
      action = request.form.get('action')
      if tab == 'environment-device':
         if action == 'environmentDeviceExtensionAdd':
            number = request.form.get('environmentExtensionDeviceNumber')
            name = request.form.get('environmentExtensionDeviceName')
            method = request.form.get("method")
            ipAddress = request.form.get('ip_address')
            modbus_id = request.form.get('modbus_id')
            deviceState = request.form.get('environmentExtensionDeviceState')

            ports = []
            for i in range(1, 9):
               ports.append(request.form.get(F'environmentExtensionPort{i}'))

            result = dashboardFunction.settingExtensionDevice.environmentExtension.device.insert(number, name, method, ipAddress, modbus_id, deviceState, time, ports)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))
         
         elif action == 'environmentDeviceExtensionEdit':
            idDevice = request.form.get('id')
            number = request.form.get('environmentExtensionDeviceNumber')
            name = request.form.get('environmentExtensionDeviceName')
            method = request.form.get("method")
            ipAddress = request.form.get('ip_address')
            modbus_id = request.form.get('modbus_id')
            deviceState = request.form.get('environmentExtensionDeviceState')
            lastNumber = request.form.get('lastNumber')
            lastName = request.form.get('lastName')
            lastIp = request.form.get("lastIp")
            lastModbus = request.form.get("lastModbus")

            last_ports = []
            ports = []
            for i in range(1, 9):
               last_ports.append(request.form.get(F'last_port{i}'))
               ports.append(request.form.get(F'environmentExtensionPort{i}'))
            
            result = dashboardFunction.settingExtensionDevice.environmentExtension.device.update(number, idDevice, name, method, ipAddress, modbus_id, deviceState, 
            lastNumber, lastName, lastIp, lastModbus, ports, last_ports)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))
         
         elif action == 'environmentDeviceExtensionDelete':
            idDevice = request.form.get('id')
            name = request.form.get('name')
            number = request.form.get('number')

            last_ports = []
            for i in range(1, 9):
               last_ports.append(request.form.get(F'last_port{i}'))
            
            result = dashboardFunction.settingExtensionDevice.environmentExtension.device.delete(idDevice, number, last_ports, name)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))
      
      elif tab == 'environment-master':
         if action == 'environmentMasterSensorAdd':
            name = request.form.get('environmentMasterSensorName')
            sensorId = request.form.get('environmentMasterSensorId')
            result = dashboardFunction.settingExtensionDevice.environmentExtension.masterSensorData.insert(name, sensorId, time)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result)) 

         elif action == 'environmentMasterSensorEdit':
            idDevice = request.form.get('id')
            name = request.form.get('environmentMasterSensorName')
            sensorId = request.form.get('environmentMasterSensorId')
            result = dashboardFunction.settingExtensionDevice.environmentExtension.masterSensorData.update(idDevice, name, sensorId)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result)) 

         elif action == 'environmentMasterSensorDelete':
            idDevice = request.form.get('id')
            name = request.form.get('name')
            result = dashboardFunction.settingExtensionDevice.environmentExtension.masterSensorData.delete(idDevice, name)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))
         
         elif action == 'environmentMasterParameterAdd':
            name = request.form.get('environmentMasterParameterName')
            parameterCode = request.form.get('environmentMasterParameterCode')
            result = dashboardFunction.settingExtensionDevice.environmentExtension.masterParameterData.insert(name, parameterCode, time)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))

         elif action == 'environmentMasterParameterEdit':
            idDevice = request.form.get('id')
            name = request.form.get('environmentMasterParameterName')
            parameterCode = request.form.get('environmentMasterParameterCode')
            result = dashboardFunction.settingExtensionDevice.environmentExtension.masterParameterData.update(idDevice, name, parameterCode)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))

         elif action == 'environmentMasterParameterDelete':
            idDevice = request.form.get('id')
            name = request.form.get('name')
            result = dashboardFunction.settingExtensionDevice.environmentExtension.masterParameterData.delete(idDevice, name)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))

      elif tab == 'power-device':
         if action == 'powerDeviceExtensionAdd':
            number = request.form.get('powerExtensionDeviceNumber')
            name = request.form.get('powerExtensionDeviceName')
            ipAddress = request.form.get('powerExtensionDeviceIp')
            deviceState = request.form.get('powerExtensionDeviceState')
            deviceConnection = '0'
            result = dashboardFunction.settingExtensionDevice.powerExtension.device.insert(number, name, ipAddress, deviceConnection, deviceState, time)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))
         
         elif action == 'powerDeviceExtensionEdit':
            idDevice = request.form.get('id')
            number = request.form.get('powerExtensionDeviceNumber')
            name = request.form.get('powerExtensionDeviceName')
            ipAddress = request.form.get('powerExtensionDeviceIp')
            deviceState = request.form.get('powerExtensionDeviceState')
            lastNumber = request.form.get('lastNumber')
            lastName = request.form.get('lastName')
            lastIp = request.form.get('lastIp')
            result = dashboardFunction.settingExtensionDevice.powerExtension.device.update(number, idDevice, name, ipAddress, deviceState, lastNumber, lastName, lastIp)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))
         
         elif action == 'powerDeviceExtensionDelete':
            idDevice = request.form.get('id')
            number = request.form.get('number')
            name = request.form.get('name')
            result = dashboardFunction.settingExtensionDevice.powerExtension.device.delete(idDevice, name, number)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))
      
      elif tab == 'power-master':
         if action == 'powerMasterSensorAdd':
            name = request.form.get('powerMasterSensorName')
            sensorId = request.form.get('powerMasterSensorId')
            result = dashboardFunction.settingExtensionDevice.powerExtension.masterSensorData.insert(name, sensorId, time)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result)) 

         elif action == 'powerMasterSensorEdit':
            idDevice = request.form.get('id')
            name = request.form.get('powerMasterSensorName')
            sensorId = request.form.get('powerMasterSensorId')
            result = dashboardFunction.settingExtensionDevice.powerExtension.masterSensorData.update(idDevice, name, sensorId)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result)) 

         elif action == 'powerMasterSensorDelete':
            idDevice = request.form.get('id')
            name = request.form.get('name')
            result = dashboardFunction.settingExtensionDevice.powerExtension.masterSensorData.delete(idDevice, name)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))
         
         elif action == 'powerMasterParameterAdd':
            name = request.form.get('powerMasterParameterName')
            parameterCode = request.form.get('powerMasterParameterCode')
            result = dashboardFunction.settingExtensionDevice.powerExtension.masterParameterData.insert(name, parameterCode, time)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))

         elif action == 'powerMasterParameterEdit':
            idDevice = request.form.get('id')
            name = request.form.get('powerMasterParameterName')
            parameterCode = request.form.get('powerMasterParameterCode')
            result = dashboardFunction.settingExtensionDevice.powerExtension.masterParameterData.update(idDevice, name, parameterCode)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))

         elif action == 'powerMasterParameterDelete':
            idDevice = request.form.get('id')
            name = request.form.get('name')
            result = dashboardFunction.settingExtensionDevice.powerExtension.masterParameterData.delete(idDevice, name)
            return redirect(url_for('settingExtensionDevice', tab=tab, result=result))

   if int(sessionData['state']) == 0:
      flash('Please Login to Access the Page')  
      return redirect(url_for('login'))

   return render_template('setting/extension/extensionSetting.html', rule=rule, sessionData=sessionData, projectData=projectData, 
                        feature_setting=feature_setting, deviceSetting=deviceSetting, tab=tab,   
                        powerDeviceData=powerDeviceData,powerMasterSensorData=powerMasterSensorData, powerMasterParameterData=powerMasterParameterData, 
                        extensionDeviceData=extensionDeviceData, calculate_port=calculate_port,
                        extensionMasterSensorData=extensionMasterSensorData, extensionMasterParameterData=extensionMasterParameterData, result=result)

@app.route('/setting/rtu', methods=['GET', 'POST'])
def settingRtu():
   time = times.now()
   rule = str(request.url_rule)
   sessionData = generalFunction.checkSession()  
   projectData = generalFunction.getProjectSetting()
   deviceSetting = dbFunction.getDeviceSetting()
   rtu_device = RtuDeviceDB.select()
   rtuParameterData = RtuParameterDB.select()
   monitorInterval = IntervalRoutineMonitorDB.selectEnable()
   logInterval = IntervalRoutineLogDB.selectEnable()

   tab = "rtu-device"
   result = {"state": "", "message": ""}
   if "tab" in request.args:
      tab = request.args["tab"]
   
   if "result" in request.args:
      result = json.loads(request.args["result"])

   if request.method == "POST":
      tab = request.form.get("tab")
      action = request.form.get("action")

      if action == "rtu-parameter-add":
         name = request.form.get("name")
         custom_id = request.form.get("custom_id")
         address = request.form.get("address")
         length = request.form.get("length")
         divider = request.form.get("divider")
         datatype = request.form.get("datatype")
         type = request.form.get("type")
         type_control = request.form.get("type_control")
         unit = request.form.get("unit")
         monitor = request.form.get("monitor")
         log = request.form.get("log")
         state = request.form.get("state")

         result = dashboardFunction.SettingRtu.Parameter.insert(name, custom_id, address, length, datatype, divider, 
                                                                type, type_control, unit, monitor, log, state)

         return redirect(url_for("settingRtu", tab=tab, result=result))
      
      elif action == 'rtu-parameter-update':
         id = request.form.get('id')
         name = request.form.get("name")
         custom_id = request.form.get("custom_id")
         address = request.form.get("address")
         length = request.form.get("length")
         divider = request.form.get("divider")
         datatype = request.form.get("datatype")
         type = request.form.get("type")
         type_control = request.form.get("type_control")
         unit = request.form.get("unit")
         monitor = request.form.get("monitor")
         log = request.form.get("log")
         state = request.form.get(f'update_state{id}')
         last_name = request.form.get("last_name")
         last_address = request.form.get("last_address")
         last_custom_id = request.form.get("last_custom_id")
         
         result = dashboardFunction.SettingRtu.Parameter.update(id, name, custom_id, address, length, datatype, divider, type,
                                                                type_control, unit, monitor, log, state, last_name, last_custom_id, last_address)

         return redirect(url_for("settingRtu", tab=tab, result=result))
      
      elif action == 'rtu-parameter-delete':
         id = request.form.get('id')
         name = request.form.get('name')
         result = dashboardFunction.SettingRtu.Parameter.delete(id, name)

         return redirect(url_for("settingRtu", tab=tab, result=result))
      
      elif action == 'device-add':
         number = request.form.get('rtu-device-number')
         name = request.form.get('rtu-device-name')
         slave_id = request.form.get('rtu-device-slaveid')
         state = request.form.get('state')
         result = dashboardFunction.SettingRtu.Device.insert(number, name, slave_id, state)
         
         return redirect(url_for("settingRtu", tab=tab, result=result))
      
      elif action == 'device-update':
         id = request.form.get('update-device-id')
         last_number = request.form.get('device-data-lastnumber')
         last_slaveid = request.form.get('device-data-slaveid')
         number = request.form.get('update-device-number')
         name = request.form.get('update-device-name')
         slave_id = request.form.get('update-device-slaveid')
         state = request.form.get(f'update_state{id}')
         result = dashboardFunction.SettingRtu.Device.update(id, number, name, slave_id, state, last_number, last_slaveid)
         
         return redirect(url_for("settingRtu", tab=tab, result=result))
      
      elif action == 'device-delete':
         id = request.form.get('delete-device-id')
         name = request.form.get('name')
         result = dashboardFunction.SettingRtu.Device.delete(id, name)

         return redirect(url_for("settingRtu", tab=tab, result=result))
      

   if int(sessionData['state']) == 0:
      flash('Please Login to Access the Page')  
      return redirect(url_for('login'))

   return render_template('setting/rtu/rtu_setting.html', rule=rule, sessionData=sessionData, projectData=projectData, deviceSetting=deviceSetting,
                           tab=tab, rtu_device=rtu_device, rtuParameterData=rtuParameterData, monitorInterval=monitorInterval, logInterval=logInterval, result=result)

@app.route('/log/monitoring', methods=['GET','POST'])
def logMonitoringPage():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    datetime1 = times.now()
    datetime2 = datetime1 - datetime.timedelta(hours=2)
    rule = str(request.url_rule)
    date1 = datetime2.strftime("%Y-%m-%d")
    time1 = datetime2.strftime("%H:%M")
    date2 = datetime1.strftime("%Y-%m-%d")
    time2 = datetime1.strftime("%H:%M")
    if 'date1' in request.args:
        date1 = request.args['date1']
    if 'date2' in request.args:
        date2 = request.args['date2']
    if 'time1' in request.args:
        time1 = request.args['time1']
    if 'time2' in request.args:
        time2 = request.args['time2']
    result = {'state':'', 'message':''}
    if 'result' in request.args:
        result = json.loads(request.args['result'])
    datetime1 = date1 + ' ' + time1
    datetime2 = date2 + ' ' + time2
    if datetime1 == ' ' and datetime2 == ' ':
        logMonitoringData = LogMonitoringDB.selectMonitorAll()
    else:
        logMonitoringData = LogMonitoringDB.selectMonitorByTime(datetime1,datetime2)
    if request.method == 'POST':
        action = request.form.get('action')
        date1 = request.form.get('date1')
        time1 = request.form.get('time1')
        date2 = request.form.get('date2')
        time2 = request.form.get('time2')
 
        if action == 'filter':
            return redirect(url_for('logMonitoringPage', action=action, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'delete':
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logMonitoring.deleteRange(datetime1, datetime2)
            return redirect(url_for('logMonitoringPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'deleteOne':
            idLog = request.form.get('idLog')
            result = dashboardFunction.logMonitoring.deleteOne(idLog)
            return redirect(url_for('logMonitoringPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'download':
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logMonitoring.download(deviceSetting, datetime1, datetime2)
            if result['message']['state'] == '1': 
               pe.save_as(array=result['dataLog'], dest_file_name="/home/connex/project/dashboard/file.csv", dest_delimiter=';')
               return send_file('/home/connex/project/dashboard/file.csv', download_name=result['filename'], as_attachment=True)
            else:
              return redirect(url_for('logMonitoringPage', result=json.dumps(result['message']), date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'upload':
            uploaded_file = request.files['file']
            result = dashboardFunction.logMonitoring.uploadFile(uploaded_file)
            return redirect(url_for('logMonitoringPage',result=result, date1=date1, time1=time1, date2=date2, time2=time2))
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    return render_template('log/log_monitoring.html', result=result, projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, rule=rule,
                                                      logMonitoringData=logMonitoringData, date1=date1, time1=time1, date2=date2, time2=time2)

@app.route('/log/buffer', methods=['GET','POST'])
def logBufferPage():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    datetime1 = times.now()
    datetime2 = datetime1 - datetime.timedelta(hours=2)
    rule = str(request.url_rule)
    date1 = datetime2.strftime("%Y-%m-%d")
    time1 = datetime2.strftime("%H:%M")
    date2 = datetime1.strftime("%Y-%m-%d")
    time2 = datetime1.strftime("%H:%M")

    if 'date1' in request.args:
        date1 = request.args['date1']
    if 'date2' in request.args:
        date2 = request.args['date2']
    if 'time1' in request.args:
        time1 = request.args['time1']
    if 'time2' in request.args:
        time2 = request.args['time2']
    result = {'state':'', 'message':''}
    if 'result' in request.args:
        result = json.loads(request.args['result'])
    datetime1 = date1 + ' ' + time1
    datetime2 = date2 + ' ' + time2
    if datetime1 == ' ' and datetime2 == ' ':
        logBufferData = LogMonitoringDB.selectBufferAll()
    else:
        logBufferData = LogMonitoringDB.selectBufferByTime(datetime1,datetime2)
    if request.method == 'POST':
        action = request.form.get('action')
        date1 = request.form.get('date1')
        time1 = request.form.get('time1')
        date2 = request.form.get('date2')
        time2 = request.form.get('time2')
        if action == 'filter':
            return redirect(url_for('logBufferPage', action=action, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'delete':
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logBuffer.deleteRange(datetime1, datetime2)
            return redirect(url_for('logBufferPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'deleteOne':
            idLog = request.form.get('idLog')
            result = dashboardFunction.logBuffer.deleteOne(idLog)
            return redirect(url_for('logBufferPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'download':
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logBuffer.download(deviceSetting, datetime1, datetime2)
            if result['message']['state'] == '1': 
                pe.save_as(array=result['dataLog'], dest_file_name="/home/connex/project/dashboard/file.csv", dest_delimiter=';')
                return send_file('/home/connex/project/dashboard/file.csv', download_name=result['filename'], as_attachment=True)
            else:
                return redirect(url_for('logBufferPage', result=json.dumps(result['message']), date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'upload':
            uploaded_file = request.files['file']
            result = dashboardFunction.logBuffer.uploadFile(uploaded_file)
            return redirect(url_for('logBufferPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    return render_template('log/log_buffer.html', result=result, projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, rule=rule, logBufferData=logBufferData, 
                                                  date1=date1, time1=time1, date2=date2, time2=time2)

@app.route('/log/sensor', methods=['GET','POST'])
def logSensorPage():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    datetime1 = times.now()
    datetime2 = datetime1 - datetime.timedelta(hours=2)
    date1 = datetime2.strftime("%Y-%m-%d")
    time1 = datetime2.strftime("%H:%M")
    date2 = datetime1.strftime("%Y-%m-%d")
    time2 = datetime1.strftime("%H:%M")
    sensor_id, sensor_name = 'all', ''
    if 'sensor_id' in request.args:
        sensor_id = request.args['sensor_id']
    if 'date1' in request.args:
        date1 = request.args['date1']
    if 'date2' in request.args:
        date2 = request.args['date2']
    if 'time1' in request.args:
        time1 = request.args['time1']
    if 'time2' in request.args:
        time2 = request.args['time2']
    result = {'state':'', 'message':''}
    if 'result' in request.args:
      result = json.loads(request.args['result'])
    datetime1 = date1 + ' ' + time1
    datetime2 = date2 + ' ' + time2
    if sensor_id == 'all' and datetime1 == ' ' and datetime2 == ' ':
        logSensorData = LogSensorDB.selectAll()
    elif sensor_id != 'all' and datetime1 == ' ' and datetime2 == ' ':
        logSensorData = LogSensorDB.selectBySensor(sensor_id)
    else:
        logSensorData = LogSensorDB.selectByTime(sensor_id, datetime1, datetime2)
    sensorData = SensorListDB.select()
    getSensor = SensorListDB.selectById(sensor_id)
    if len(getSensor) == 1:
        sensor_name = getSensor[0]['name']
    if request.method == 'POST':
        action = request.form.get('action')
        date1 = request.form.get('date1')
        time1 = request.form.get('time1')
        date2 = request.form.get('date2')
        time2 = request.form.get('time2')
        sensor_id = request.form.get('sensor_id')
        if action == "filter":            
            return redirect(url_for('logSensorPage', action=action, sensor_id=sensor_id, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == "delete":
            sensor_name = request.form.get('sensor_name')
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logSensor.deleteRange(sensor_id, sensor_name, datetime1, datetime2)
            return redirect(url_for('logSensorPage', result=result, sensor_id=sensor_id, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == "deleteOne":
            idLog = request.form.get('idLog')
            result = dashboardFunction.logSensor.deleteOne(idLog)
            return redirect(url_for('logSensorPage', result=result, sensor_id=sensor_id, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == "download":
            sensor_name = request.form.get('sensor_name')
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logSensor.download(deviceSetting, sensor_id, datetime1, datetime2)
            if result['message']['state'] == '1': 
               pe.save_as(array=result['dataLog'], dest_file_name="/home/connex/project/dashboard/file.csv", dest_delimiter=';')
               return send_file('/home/connex/project/dashboard/file.csv', download_name=result['filename'], as_attachment=True)
            else:
              return redirect(url_for('logSensorPage', result=json.dumps(result['message']), date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == "upload":
            sensor_name = request.form.get('sensor_name')
            uploaded_file = request.files['file']
            result = dashboardFunction.logSensor.upload(uploaded_file)
            return redirect(url_for('logSensorPage', result=result, sensor_id=sensor_id, date1=date1, time1=time1, date2=date2, time2=time2)) 
    if int(sessionData['state']) == 0:
       flash('Please Login to Access the Page')
       return redirect(url_for('login'))
    return render_template('log/log_sensor.html', projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, rule=rule, logSensorData=logSensorData, date1=date1, 
                                              time1=time1, date2=date2, time2=time2, sensorData=sensorData, sensor_id=sensor_id, sensor_name=sensor_name, result=result)

@app.route('/log/actuator', methods=['GET','POST'])
def logActuatorPage():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    datetime1 = times.now()
    datetime2 = datetime1 - datetime.timedelta(hours=2)
    rule = str(request.url_rule)
    date1 = datetime2.strftime("%Y-%m-%d")
    time1 = datetime2.strftime("%H:%M")
    date2 = datetime1.strftime("%Y-%m-%d")
    time2 = datetime1.strftime("%H:%M")
    if 'date1' in request.args:
        date1 = request.args['date1']
    if 'date2' in request.args:
        date2 = request.args['date2']
    if 'time1' in request.args:
        time1 = request.args['time1']
    if 'time2' in request.args:
        time2 = request.args['time2']
    result = {'state':'', 'message':''}
    if 'result' in request.args:
        result = json.loads(request.args['result'])
    datetime1 = date1 + ' ' + time1
    datetime2 = date2 + ' ' + time2
    if datetime1 == ' ' and datetime2 == ' ':
        logActuatorData = LogActuatorDB.selectAll()
    else:
        logActuatorData = LogActuatorDB.selectByTime(datetime1,datetime2)
    if request.method == 'POST':
        action = request.form.get('action')
        date1 = request.form.get('date1')
        time1 = request.form.get('time1')
        date2 = request.form.get('date2')
        time2 = request.form.get('time2')
        if action == 'filter':
            return redirect(url_for('logActuatorPage', action=action, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'delete':
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logActuatorSystem.deleteRange(datetime1, datetime2)
            return redirect(url_for('logActuatorPage',result=result, action=action, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'deleteOne':
            idLog = request.form.get('idLog')
            result = dashboardFunction.logActuatorSystem.deleteOne(idLog)
            return redirect(url_for('logActuatorPage',result=result, action=action, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'download':
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logActuatorSystem.download(deviceSetting, datetime1, datetime2)
            if result['message']['state'] == '1': 
                pe.save_as(array=result['dataLog'], dest_file_name="/home/connex/project/dashboard/file.csv", dest_delimiter=';')
                return send_file('/home/connex/project/dashboard/file.csv', download_name=result['filename'], as_attachment=True)
            else:
                return redirect(url_for('logActuatorPage', result=json.dumps(result['message']), date1=date1, time1=time1, date2=date2, time2=time2))  
        elif action == 'upload':
            uploaded_file = request.files['file']
            result = dashboardFunction.logActuatorSystem.uploadFile(uploaded_file)
            return redirect(url_for('logActuatorPage',result=result, action=action, date1=date1, time1=time1, date2=date2, time2=time2))
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    return render_template('log/log_actuator.html',projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, rule=rule, 
                           logActuatorData=logActuatorData, date1=date1, time1=time1, date2=date2, time2=time2, result=result)

@app.route('/log/notif', methods=['GET','POST'])
def logNotifPage():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    datetime1 = times.now()
    datetime2 = datetime1 - datetime.timedelta(hours=2)
    rule = str(request.url_rule)
    date1 = datetime2.strftime("%Y-%m-%d")
    time1 = datetime2.strftime("%H:%M")
    date2 = datetime1.strftime("%Y-%m-%d")
    time2 = datetime1.strftime("%H:%M")

    if 'date1' in request.args:
        date1 = request.args['date1']
    if 'date2' in request.args:
        date2 = request.args['date2']
    if 'time1' in request.args:
        time1 = request.args['time1']
    if 'time2' in request.args:
        time2 = request.args['time2']
    result = {'state':'', 'message':''}
    if 'result' in request.args:
        result = json.loads(request.args['result'])
    datetime1 = date1 + ' ' + time1
    datetime2 = date2 + ' ' + time2
    if datetime1 == ' ' and datetime2 == ' ':
        logNotifData = LogNotifDB.selectAll()
    else:
        logNotifData = LogNotifDB.selectByTime(datetime1, datetime2)
    if request.method == 'POST':
        action = request.form.get('action') 
        date1 = request.form.get('date1')
        time1 = request.form.get('time1')
        date2 = request.form.get('date2')
        time2 = request.form.get('time2')
        if action == 'filter':
            return redirect(url_for('logNotifPage', action=action, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'delete':
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logNotification.deleteRange(datetime1, datetime2)
            return redirect(url_for('logNotifPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'deleteOne':
            idLog = request.form.get('idLog')
            result = dashboardFunction.logNotification.deleteOne(idLog)
            return redirect(url_for('logNotifPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
        elif action == 'download':
            datetime1 = date1 + ' ' + time1
            datetime2 = date2 + ' ' + time2
            result = dashboardFunction.logNotification.download(deviceSetting, datetime1, datetime2)
            if result['message']['state'] == '1': 
                pe.save_as(array=result['dataLog'], dest_file_name="/home/connex/project/dashboard/file.csv", dest_delimiter=';')
                return send_file('/home/connex/project/dashboard/file.csv', download_name=result['filename'], as_attachment=True)
            else:
                return redirect(url_for('logNotifPage', result=json.dumps(result['message']), date1=date1, time1=time1, date2=date2, time2=time2))  
        elif action == 'upload':
            uploaded_file = request.files['file']
            result = dashboardFunction.logNotification.uploadFile(uploaded_file)
            return redirect(url_for('logNotifPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    return render_template('log/log_notif.html', result=result, projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, rule=rule, logNotifData=logNotifData, 
                                                  date1=date1, time1=time1, date2=date2, time2=time2)

@app.route('/log/error', methods=['GET','POST'])
def logErrorPage():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    datetime1 = times.now()
    datetime2 = datetime1 - datetime.timedelta(hours=2)
    rule = str(request.url_rule)
    date1 = datetime2.strftime("%Y-%m-%d")
    time1 = datetime2.strftime("%H:%M")
    date2 = datetime1.strftime("%Y-%m-%d")
    time2 = datetime1.strftime("%H:%M")
    if 'date1' in request.args:
        date1 = request.args['date1']
    if 'date2' in request.args:
        date2 = request.args['date2']
    if 'time1' in request.args:
        time1 = request.args['time1']
    if 'time2' in request.args:
        time2 = request.args['time2']
    result = {'state':'', 'message':''}
    if 'result' in request.args:
        result = json.loads(request.args['result'])
    datetime1 = date1 + ' ' + time1
    datetime2 = date2 + ' ' + time2
    if datetime1 == ' ' and datetime2 == ' ':
       logErrorData = LogErrorDB.selectAll()
    else:
       logErrorData = LogErrorDB.selectByTime(datetime1, datetime2)
    if request.method == 'POST':
       action = request.form.get('action') 
       result = {'state': '1', 'message': f'Showing action {action}'}
       date1 = request.form.get('date1')
       time1 = request.form.get('time1')
       date2 = request.form.get('date2')
       time2 = request.form.get('time2')
       if action == 'filter':
         return redirect(url_for('logErrorPage', action=action, date1=date1, time1=time1, date2=date2, time2=time2))
       elif action == 'delete':
         datetime1 = request.form.get('datetime1')
         datetime2 = request.form.get('datetime2')
         result = dashboardFunction.logErrorSystem.deleteRange(datetime1, datetime2)
         return redirect(url_for('logErrorPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
       elif action == 'deleteOne':
          idLog = request.form.get('idLog')
          result = dashboardFunction.logErrorSystem.deleteOne(idLog)
          return redirect(url_for('logErrorPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
       elif action == 'download':
          datetime1 = date1 + ' ' + time1
          datetime2 = date2 + ' ' + time2
          result= dashboardFunction.logErrorSystem.download(deviceSetting, datetime1, datetime2)
          if result['message']['state'] == '1': 
             pe.save_as(array=result['dataLog'], dest_file_name="/home/connex/project/dashboard/file.csv", dest_delimiter=';')
             return send_file('/home/connex/project/dashboard/file.csv', download_name=result['filename'], as_attachment=True)
          else:
             return redirect(url_for('logErrorPage', result=json.dumps(result['message']), date1=date1, time1=time1, date2=date2, time2=time2))
       elif action == 'upload':
          uploaded_file = request.files['file']
          result = dashboardFunction.logErrorSystem.uploadFile(uploaded_file)
          return redirect(url_for('logErrorPage', result=result, date1=date1, time1=time1, date2=date2, time2=time2))
    if int(sessionData['state']) == 0:
       flash('Please Login to Access the Page')
       return redirect(url_for('login'))
    return render_template('log/log_error.html', result=result, projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, rule=rule, 
                                                 logErrorData=logErrorData, date1=date1, time1=time1, date2=date2, time2=time2)

@app.route('/log/systemlog', methods=['GET','POST'])
def logSystemPage():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    result = {'state':'', 'message':''}
    
    if 'result' in request.args:
        result = json.loads(request.args['result'])
    
    # Get log file sizes
    log_sizes = getLogFileSizes()
    
    if request.method == 'POST':
        action = request.form.get('action')
        
        if action == "clear_daemon":
            result = clearSystemLog('/var/log/daemon.log', 'daemon')
        elif action == "clear_syslog":
            result = clearSystemLog('/var/log/syslog', 'system')
        elif action == "clear_journal":
            journal_method = request.form.get('journal_method', 'normal')
            result = clearJournalLog(journal_method)
        elif action == "clear_bulk":
            selected_logs = request.form.get('selected_logs', '').split(',')
            result = clearBulkLogs(selected_logs)
        
        return redirect(url_for('logSystemPage', result=json.dumps(result)))
    
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    
    return render_template('log/log_system.html', projectData=projectData, sessionData=sessionData, 
                         deviceSetting=deviceSetting, rule=rule, result=result, log_sizes=log_sizes)

def getLogFileSizes():
    """Get sizes of log files"""
    sizes = {}
    
    # Daemon log
    daemon_path = '/var/log/daemon.log'
    if os.path.exists(daemon_path):
        try:
            size = os.path.getsize(daemon_path)
            sizes['daemon'] = formatFileSize(size)
        except:
            sizes['daemon'] = 'Error reading size'
    else:
        sizes['daemon'] = 'File not found'
    
    # System log
    syslog_path = '/var/log/syslog'
    if os.path.exists(syslog_path):
        try:
            size = os.path.getsize(syslog_path)
            sizes['syslog'] = formatFileSize(size)
        except:
            sizes['syslog'] = 'Error reading size'
    else:
        sizes['syslog'] = 'File not found'
    
    # Journal log size (using journalctl)
    try:
        import subprocess
        result = subprocess.run(['journalctl', '--disk-usage'], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            # Parse output like "Archived and active journals take up 1.2G in the file system."
            output = result.stdout.strip()
            if 'take up' in output:
                size_text = output.split('take up')[1].split('in')[0].strip()
                sizes['journal'] = size_text
            else:
                sizes['journal'] = 'Unknown'
        else:
            sizes['journal'] = 'Error reading size'
    except:
        sizes['journal'] = 'Error reading size'
    
    return sizes

def formatFileSize(size_bytes):
    """Convert bytes to human readable format"""
    if size_bytes == 0:
        return "0 B"
    
    size_names = ["B", "KB", "MB", "GB", "TB"]
    i = 0
    while size_bytes >= 1024 and i < len(size_names) - 1:
        size_bytes /= 1024.0
        i += 1
    
    return f"{size_bytes:.1f} {size_names[i]}"

def clearSystemLog(log_file, log_type):
    """Clear system log file"""
    try:
        # Check if file exists
        if not os.path.exists(log_file):
            return {'state': '0', 'message': f'{log_type.capitalize()} log file not found: {log_file}'}
        
        # Clear the log file
        with open(log_file, 'w') as f:
            f.write('')
        
        return {'state': '1', 'message': f'{log_type.capitalize()} log cleared successfully'}
    except Exception as e:
        return {'state': '0', 'message': f'Error clearing {log_type} log: {str(e)}'}

def clearJournalLog(method='normal'):
    """Clear journalctl logs"""
    try:
        import subprocess
        
        if method == 'normal':
            # Normal cleaning - safer approach
            commands = [
                ['journalctl', '--vacuum-time=0s'],
                ['journalctl', '--vacuum-size=0'],
                ['journalctl', '--rotate']
            ]
        else:
            # Aggressive cleaning - more thorough but may require restart
            commands = [
                ['journalctl', '--vacuum-time=0s'],
                ['journalctl', '--vacuum-size=0'],
                ['journalctl', '--rotate'],
                ['systemctl', 'restart', 'systemd-journald']
            ]
            
            # Force cleanup of journal files
            cleanup_cmd = ['find', '/var/log/journal', '-name', '*.journal*', '-delete']
            subprocess.run(cleanup_cmd, capture_output=True, text=True, timeout=30)
        
        for cmd in commands:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            if result.returncode != 0:
                print(f"Warning: Command {' '.join(cmd)} failed: {result.stderr}")
        
        method_text = "aggressively" if method == 'aggressive' else "normally"
        return {'state': '1', 'message': f'Journal log cleared {method_text} successfully'}
    except Exception as e:
        return {'state': '0', 'message': f'Error clearing journal log: {str(e)}'}

def clearBulkLogs(selected_logs):
    """Clear multiple log files"""
    results = []
    
    for log_type in selected_logs:
        if log_type == 'daemon':
            result = clearSystemLog('/var/log/daemon.log', 'daemon')
            results.append(f"Daemon log: {result['message']}")
        elif log_type == 'syslog':
            result = clearSystemLog('/var/log/syslog', 'system')
            results.append(f"System log: {result['message']}")
        elif log_type == 'journal':
            result = clearJournalLog('normal')  # Use normal method for bulk operations
            results.append(f"Journal log: {result['message']}")
    
    # Check if all operations were successful
    success_count = sum(1 for r in results if 'successfully' in r)
    total_count = len(results)
    
    if success_count == total_count:
        return {'state': '1', 'message': f'All selected logs cleared successfully ({success_count}/{total_count})'}
    elif success_count > 0:
        return {'state': '2', 'message': f'Partially successful: {success_count}/{total_count} logs cleared. Details: {" | ".join(results)}'}
    else:
        return {'state': '0', 'message': f'Failed to clear logs. Details: {" | ".join(results)}'}

@app.route('/calibration/formula', methods=['GET','POST'])
def calibrationFormulaPage():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    tab, result = 'table', '-'
    formulaId, sampleValue = '', ''
    formulaData = CalibrateFormulaDB.select()
    if 'tab' in request.args:
        tab = request.args['tab']
    result = {'state':'', 'message':''}
    check = {}
    if 'formulaId' in request.args:
        formulaId = request.args['formulaId']
    if 'sampleValue' in request.args:
        sampleValue = request.args['sampleValue']
    if 'result' in request.args:
        result = json.loads(request.args['result'])
    if 'check' in request.args:
        check = json.loads(request.args['check'])
    if request.method == 'POST':
        tab = request.form.get('tab')
        if tab == 'table':
            action = request.form.get('action')
            if action == 'add':
                name = request.form.get('name')
                result = dashboardFunction.calibrationFormula.insert(name)
                return redirect(url_for('calibrationFormulaPage', result=result, tab=tab))
            elif action == 'calculate':
                formulaId = request.form.get('formulaId')
                result = dashboardFunction.calibrationFormula.calculate(formulaId)
                return redirect(url_for('calibrationFormulaPage', result=result, tab=tab))
            elif action == 'update':
                formulaId = request.form.get('formulaId')
                name = request.form.get('name')
                result = dashboardFunction.calibrationFormula.update(formulaId, name)
                return redirect(url_for('calibrationFormulaPage', result=result, tab=tab))
            elif action == 'delete':
                formulaId = request.form.get('formulaId')
                result = dashboardFunction.calibrationFormula.delete(formulaId)
                return redirect(url_for('calibrationFormulaPage', result=result, tab=tab))
        elif tab == 'check':
            formulaId = request.form.get('formulaId')
            sampleValue = request.form.get('sampleValue')
            result = dashboardFunction.calibrationFormula.check(formulaId, sampleValue)
            if result['message']['state'] == '1':
               return redirect(url_for('calibrationFormulaPage', result=json.dumps(result['message']), tab=tab, check=json.dumps(result['data']), formulaId=formulaId, sampleValue=sampleValue))
            else:
               return redirect(url_for('calibrationFormulaPage', result=json.dumps(result['message']), tab=tab, formulaId=formulaId, sampleValue=sampleValue))
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    return render_template('calibration/formula/calibrationFormula.html', projectData=projectData, deviceSetting=deviceSetting, rule=rule, sessionData=sessionData, 
                                                                          tab=tab, result=result, formulaId=formulaId, sampleValue=sampleValue, formulaData=formulaData,
                                                                          check=check)

@app.route('/calibration/sample', methods=['GET','POST'])
def calibrationSamplePage():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    tab, result = 'check', ''
    groupSensorId, formulaId = '', ''
    groupSensorData = SensorGroupDB.select()
    formulaData = CalibrateFormulaDB.select()
    if 'tab' in request.args:
        tab = request.args['tab']
    result = {'state':'', 'message':''}
    output = {}
    if 'formulaId' in request.args:
        formulaId = request.args['formulaId']
    if 'groupSensorId' in request.args:
        groupSensorId = request.args['groupSensorId']
    if 'output' in request.args:
        output = json.loads(request.args['output'])
    if 'result' in request.args:
        result = json.loads(request.args['result'])
    if formulaId == "":
        sampleData = CalibrateSampleDB.select()
    else:
        sampleData = CalibrateSampleDB.selectByFormula(formulaId)
    if request.method == 'POST':
        tab = request.form.get('tab')
        if tab == 'check':
            groupSensorId = request.form.get('groupSensorId')
            result = dashboardFunction.calibrationSample.check(groupSensorId)
            if result['message']['state'] == '1':
               return redirect(url_for('calibrationSamplePage', result=json.dumps(result['message']), tab=tab, output=json.dumps(result['data']), groupSensorId=groupSensorId))
            else:
               return redirect(url_for('calibrationSamplePage', result=json.dumps(result['message']), tab=tab, groupSensorId=groupSensorId)) 
        elif tab == 'table':
            action = request.form.get('action')
            formulaId = request.form.get('formulaId')
            if action == 'add':
                formula = request.form.get('formula')
                valueSample = request.form.get('value_sample')
                valueReference = request.form.get('value_reference')
                result = dashboardFunction.calibrationSample.insert(formula, valueSample, valueReference)
                return redirect(url_for('calibrationSamplePage', result=result, tab=tab, formulaId=formulaId))
            elif action == 'filter':
               return redirect(url_for('calibrationSamplePage', tab=tab, formulaId=formulaId))
            elif action == 'update':
                sampleId = request.form.get('sampleId')
                formulaNew = request.form.get('formulaNew')
                formulaLast = request.form.get('formulaLast')
                valueSample = request.form.get('valueSample')
                valueReference = request.form.get('valueReference')
                result = dashboardFunction.calibrationSample.update(sampleId, formulaNew, valueSample, valueReference, formulaLast)
                return redirect(url_for('calibrationSamplePage', result=result, tab=tab, formulaId=formulaId))
            elif action == 'delete':
                sampleId = request.form.get('sampleId')
                formula = request.form.get('formula')
                result = dashboardFunction.calibrationSample.delete(sampleId, formula)
                return redirect(url_for('calibrationSamplePage', result=result, tab=tab, formulaId=formulaId))
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    return render_template('calibration/sample/calibrationSample.html', sessionData=sessionData, deviceSetting=deviceSetting, projectData=projectData, rule=rule, 
                                                                        result=result, tab=tab, formulaId=formulaId, sampleData=sampleData, formulaData=formulaData, 
                                                                        groupSensorData=groupSensorData, groupSensorId=groupSensorId, output=output)

@app.route('/check/sensor', methods=['GET','POST'])
def check_sensor():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    sensor_id = ''
    result = '-'
    sensors = SensorGroupDB.select()
    if request.method == 'POST':
        sensor_id = request.form.get('sensor')
        service = ServiceProjectFunction.checkActiveService('sensor' + str(sensor_id))
        if service == 'active':
            result = ['Please stop service sensor' + str(sensor_id) + " first before check the sensor"]
        else:
            filename = "check_sensor" + sensor_id + ".py"
            result = subprocess.Popen(["python3", "/home/connex/project/sensor/"+filename, "-t", "1"], stdout=subprocess.PIPE)
            (out, err) = result.communicate()
            result = out.decode('utf-8')
            result = result.split('\n')
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    return render_template('check/checkSensor.html', projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, sensors=sensors, rule=rule, 
                                                     sensor_id=sensor_id, result=result)

@app.route('/setting/sensorsht20', methods=['GET','POST'])
def setting_sensorsht():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    sensorPortConfig = SensorPortConfigDB.select()

    result = '-'
    if request.method == 'POST':
      result = subprocess.Popen(["python3", "/home/connex/project/sensor/test.py" "-t", "1"], stdout=subprocess.PIPE)
      (out, err) = result.communicate()
      result = out.decode('utf-8')
      result = result.split('\n')
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    return render_template('setting/sensor/sensor_setting.html', sessionData=sessionData, projectData=projectData, result=result, sensorPortConfig=sensorPortConfig)


@app.route('/check/actuator', methods=['GET','POST'])
def check_actuator():
    projectData = generalFunction.getProjectSetting()
    sessionData = generalFunction.checkSession()
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    actuator_list_id, action = '', ''
    result = '-'
    actuators = ActuatorListDB.selectByStateFull("1","1")
    if request.method == 'POST':
        actuator_list_id = request.form.get('actuator')
        actuator_group_number = request.form.get('actuator_group_number')
        action = request.form.get('action')
        filename = f"check_actuator{actuator_group_number}.py"
        result = subprocess.Popen(["python3", f"/home/connex/project/actuator/{filename}", "-a", action, "-l", actuator_list_id], stdout=subprocess.PIPE)
        (out, err) = result.communicate()
        result = out.decode('utf-8')
        result = result.split('\n')
    if int(sessionData['state']) == 0:
        flash('Please Login to Access the Page')
        return redirect(url_for('login'))
    return render_template('check/checkActuator.html', projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, actuators=actuators, 
                                                       rule=rule, actuator_list_id=actuator_list_id, result=result, action=action)

@app.route('/check/monitoring', methods=['GET','POST'])
def check_monitoring():
    sessionData = generalFunction.checkSession() # ID, username, level
    projectData = generalFunction.getProjectSetting() # projectNode, projectName
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    data, protocol, result = '', '', '-'
    if request.method == 'POST':
        data = request.form.get('data')
        protocol = request.form.get('protocol')
        filename = "/home/connex/project/monitoring/check_monitoring.py"
        result = subprocess.Popen(["python3", filename, "-p", str(protocol)], stdout=subprocess.PIPE)
        (out, err) = result.communicate()
        result = out.decode('utf-8')
        result = result.split('\n')
        if result[0] == '':
            result = '-'
    if int(sessionData['state']) == 0:
       flash('Please Login to Access the Page')
       return redirect(url_for('login'))
    return render_template('check/checkMonitoring.html', projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, rule=rule, result=result, 
                                                         data=data, protocol=protocol)

@app.route('/check/snmp', methods=['GET','POST'])
def check_snmp():
    sessionData = generalFunction.checkSession() # ID, username, level
    projectData = generalFunction.getProjectSetting() # projectNode, projectName
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    sensorSelected, result = '', '-'
    sensorList = SensorListDB.select()
    if request.method == 'POST':
       sensorSelected = request.form.get('sensor')
       if sensorSelected == "":
          result = "Please Select the Sensor"
       else:
          result = subprocess.Popen(["python3", "/home/connex/project/system/check_snmp.py", "-i", sensorSelected], stdout=subprocess.PIPE)
          (out, err) = result.communicate()
          result = out.decode('utf-8')
          result = result.split('\n')
    if int(sessionData['state']) == 0:
       flash('Please Login to Access the Page')
       return redirect(url_for('login'))
    return render_template('check/checkSnmp.html', projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, rule=rule, result=result,
                                                   sensorList=sensorList, sensorSelected=sensorSelected)

@app.route('/display', methods=['GET','POST'])
def display():
    sessionData = generalFunction.checkSession() # ID, username, level
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    projectData = generalFunction.getProjectSetting() # projectNode, projectName
    result = '-'
    import time
    path = "/home/connex/project/display/"
    files = os.path.exists(path + "display.tft")
    if request.method == 'POST':
       upload_type = request.form.get('upload')
       if upload_type == 'external':
          uploaded_file = request.files['file']
          filename = secure_filename(uploaded_file.filename)
       enable = ServiceProjectFunction.checkEnableService('nearon_display')
       if enable == 'enabled':
          os.system('systemctl disable nearon_display')
          result = ['Display service detected enable, system already disable the display service.', 'Please reboot device before upload the file']
       else:
          service = ServiceProjectFunction.checkActiveService('nearon_display')
          if service == 'active':
             result = ['Display service detected active, system already stop the display service.', 'Please reboot device before upload the file']
             os.system('service nearon_display stop')
          else:
             if upload_type == 'external':
                uploaded_file.save(os.path.join(path + "display_new.tft"))
                script = 'nextion-fw-upload /dev/ttyS0 ' + path + 'display_new.tft -b 115200 -ub 115200'
             else:
                script = 'nextion-fw-upload /dev/ttyS0 ' + path + 'display.tft -b 115200 -ub 115200'
             code = os.system(script)
             if int(code) == 0:
                if upload_type == 'external':
                   os.system("rm " + path + "display.tft")
                   os.system("mv " + path + "display_new.tft " + path + "display.tft")
                result = ['Success Upload Display File']
             else:
                if upload_type == 'external':
                   os.system("rm " + path + "display_new.tft")
                result = ['Error Upload Display File']
    if files == True:
       last = time.ctime(os.path.getmtime(path + "display.tft"))
    else:
       last = "-"
    if int(sessionData['state']) == 0:
       flash('Please Login to Access the Page')
       return redirect(url_for('login'))
    return render_template('display.html', projectData=projectData, sessionData=sessionData, deviceSetting=deviceSetting, rule=rule, result=result, last=last, files=files)

@app.route('/system/service', methods=['GET','POST'])
def service_form():
    sessionData = generalFunction.checkSession() # ID, username, level
    projectData = generalFunction.getProjectSetting() # projectNode, projectName
    deviceSetting = dbFunction.getDeviceSetting()
    rule = str(request.url_rule)
    serviceData = SystemServiceDB.select()
    if request.method == 'POST':
        action = request.form.get('action')
        serviceName = request.form.get('serviceName')
        serviceId = request.form.get('serviceId')
        if action == 'start':
            os.system(f"sudo systemctl start {serviceName}")
            serviceState = ServiceProjectFunction.checkActiveService(serviceName)
            SystemServiceDB.updateServiceStateById(serviceState, serviceId)
            return redirect(url_for('service_form'))
        elif action == 'stop':
            os.system(f"sudo systemctl stop {serviceName}")
            serviceState = ServiceProjectFunction.checkActiveService(serviceName)
            SystemServiceDB.updateServiceStateById(serviceState, serviceId)
            return redirect(url_for('service_form'))
        elif action == 'enable':
            os.system(f"sudo systemctl enable {serviceName}")
            serviceEnable = ServiceProjectFunction.checkEnableService(serviceName)
            SystemServiceDB.updateServiceBootById(serviceEnable, serviceId)
            return redirect(url_for('service_form'))
        elif action == 'disable':
            os.system(f"sudo systemctl disable {serviceName}")
            serviceEnable = ServiceProjectFunction.checkEnableService(serviceName)
            SystemServiceDB.updateServiceBootById(serviceEnable, serviceId)
            return redirect(url_for('service_form'))           
    if int(sessionData['state']) == 0:
       flash('Please Login to Access the Page')
       return redirect(url_for('login'))
    return render_template('system_service.html', projectData=projectData, sessionData=sessionData, rule=rule, serviceData=serviceData, deviceSetting=deviceSetting)

@app.route('/do/reboot')
def do_reboot():
    os.system("sudo reboot")
    return redirect('/')

if __name__ == '__main__':
   app.run(host='0.0.0.0', port=projectData['port'], debug=True)
