import sys

sys.path.append('/home/connex/project/database')
from query_project_db import ServerHttpDB, ServerMqttDB, ServerSettingDB, ServerHttpAuthDB
sys.path.append("/home/connex/project/function")
from dbFunction import dbFunction


class serverFunction(): 
    def processHttpApi(serverSetting, type, uid, parameter, api):
        state = False
        
        # Khusus untuk status-storage dan status-device, gunakan domain dev-nearon.synapsis.id
        if parameter.lower() == 'status-storage' or parameter.lower() == 'status-device':
            endpoint = api.replace("nodeid", uid)
            if endpoint != '':
                url = f"https://dev-nearon.synapsis.id{endpoint}"
                state = True
            else:
                url = 'N/A'
        else:
            # Untuk parameter lainnya, gunakan logika normal
            if parameter.lower() == "sensor" or parameter.lower() == "actuator" or parameter.lower() == 'node' or parameter.lower() == 'reboot' or parameter.lower() == 'receiver':
                endpoint = api.replace("nodeid", uid)
            else:
                endpoint = f"{api}"
            
            if type == '0':
                if serverSetting['domainAddress'] == '' or serverSetting['domainAddress'] == '-' or serverSetting['port'] == '' or serverSetting['port'] == '-' or endpoint == '':
                    url = 'N/A'
                else:
                    url = 'http://' + str(serverSetting['ipAddress']) + ":" + str(serverSetting['port']) + str(endpoint)
            elif type == '1':
                if serverSetting['domainAddress'] == '' or serverSetting['domainAddress'] == '-' or endpoint == '':
                    url = 'N/A'
                else:
                    url = 'https://' + str(serverSetting['domainAddress']) + str(endpoint)
            
            if url != 'N/A':
                state = True
        
        result = {'data': url, 'state': state}  
        return result

    def processMqttTopic(serverSetting, uid, parameter, topic):
        state = False
        if parameter.lower() == "sensor" or parameter.lower() == "actuator" or parameter.lower() == "node":
            topics = topic.replace("nodeid", uid)
        elif parameter.lower() == "data" or parameter.lower() == "notif":
            topics = topic.replace("nodeid", uid)
        else:
            topics = f"{topic}"
        if topic != '':
            state, topics = True, topics            
        result = {'data': topics, 'state': state}  
        return result

    def getServerData():
        deviceData = dbFunction.getDeviceSetting()
        serverData = {'http': {'setting': '', 'data': ''}, 'mqtt': {'setting': '', 'data': ''}}
        serverHttpSetting = ServerSettingDB.selectByServer('http')
        if len(serverHttpSetting) == 1:
            serverHttpSetting = serverHttpSetting[0]
        else:
            serverHttpSetting = {'domainAddress': '', 'ipAddress': '', 'port': '', 'username': '', 'password': ''} 
            
        serverHttp = ServerHttpDB.select()
        serverData['http']['setting'], serverData['http']['data'] = serverHttpSetting, serverHttp
        for item in range(len(serverHttp)):
            url = serverFunction.processHttpApi(serverHttpSetting, serverHttp[item]['type'], deviceData['uid'], serverHttp[item]['parameter'], serverHttp[item]['data'])
            serverHttp[item]['api'] = url['data']
            serverHttp[item]['state'] = url['state']
            
        httpAuth = serverFunction.getServerHttpAuth() 
        serverData['http']['auth'] = httpAuth
        serverMqttSetting = ServerSettingDB.selectByServer('mqtt')
        if len(serverMqttSetting) == 1:
            serverMqttSetting = serverMqttSetting[0]
        else:
            serverMqttSetting = {'domainAddress': '', 'ipAddress': '', 'port': '', 'username': '', 'password': ''} 
            
        serverMqtt = ServerMqttDB.select()  
        serverData['mqtt']['setting'], serverData['mqtt']['data'] = serverMqttSetting, serverMqtt
        for item in range(len(serverMqtt)):
            topic = serverFunction.processMqttTopic(serverMqttSetting, deviceData['uid'], serverMqtt[item]['parameter'], serverMqtt[item]['data'])
            serverMqtt[item]['topic'] = topic['data']
            serverMqtt[item]['state'] = topic['state'] 
        return serverData

    def getServerConfig():
        serverData = {'http': {}, 'mqtt': {}}
        serverHttpSetting = ServerSettingDB.selectByServer('http')
        # serverHttpSetting = ServerSettingDB.selectByServer('http')
        if len(serverHttpSetting) == 1:
            serverHttpSetting = serverHttpSetting[0]
        else:
            serverHttpSetting = {'domainAddress': '', 'ipAddress': '', 'port': '', 'username': '', 'password': ''} 
        serverData['http'] = serverHttpSetting 
        serverMqttSetting = ServerSettingDB.selectByServer('mqtt')
        if len(serverMqttSetting) == 1:
            serverMqttSetting = serverMqttSetting[0]
        else:
            serverMqttSetting = {'domainAddress': '', 'ipAddress': '', 'port': '', 'username': '', 'password': ''} 
        serverData['mqtt'] = serverMqttSetting 
        return serverData   
    
    def getServerDataByServerAndParameter(server, parameter):
        deviceData = dbFunction.getDeviceSetting() 
        serverSetting = ServerSettingDB.selectByServer(server)

        if len(serverSetting) == 1:
            serverSetting = serverSetting[0]
        else:
            serverSetting = {'domainAddress': '', 'ipAddress': '', 'port': '', 'username': '', 'password': ''}
        
        if server == 'http':     
            serverData = ServerHttpDB.selectByParameter(parameter)
        elif server == 'mqtt':
            serverData = ServerMqttDB.selectByParameter(parameter) 
        else :
            serverData = []
        

        if len(serverData) == 1:
            for x in range(len(serverData)):
                if server == 'http':
                    result = serverFunction.processHttpApi(serverSetting, serverData[x]['type'], deviceData['uid'], serverData[x]['parameter'], serverData[x]['data'])
                elif server == 'mqtt':
                    result = serverFunction.processMqttTopic(serverSetting, deviceData['uid'], serverData[x]['parameter'], serverData[x]['data'])   
        else:
            result = {'data': 'N/A', 'state': False}        
        return result

    def getServerHttpAuth():
        getData = ServerHttpAuthDB.select()
        serverAuth = {}
        for item in getData:
            serverAuth[item['name']] = item['value']
        return serverAuth