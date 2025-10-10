import sys, time

sys.path.append('/home/connex/library')
from SynapsisLibrary import times, Scheduler
sys.path.append('/home/connex/project/database')
from query_project_db import SystemServiceDB
sys.path.append('/home/connex/project/function')
from monitoringFunction import monitoringFunction
from dbFunction import dbFunction
from serverFunction import serverFunction
from serviceProjectFunction import ServiceProjectFunction

datetimes = times.getDatetime()
print("Start Status Storage Monitor : ", datetimes)
globalVariable = {'serviceName': 'status_storage_monitor'}   

def main(globalVar, *args, **kwargs):
    global globalVariable
    
    # Dapatkan konfigurasi server
    serverConfig = serverFunction.getServerConfig()
    
    # Jalankan status storage monitoring
    try:
        result = monitoringFunction.runStatusStorage(serverConfig, globalVariable)
        if result['state'] == "Success":
            logService = "Status Storage Monitoring Success"
            colorLogService = "\033[92m{}\033[00m".format(logService)
        else:
            logService = "Status Storage Monitoring Failed - {}".format(result['log'])
            colorLogService = "\033[31m{}\033[00m".format(logService)
        
        print("{}\n".format(colorLogService))
        SystemServiceDB.updateStatusByName(logService, times.getDatetime(), globalVariable['serviceName'])
        
    except Exception as e:
        logService = "Status Storage Monitoring Error - {}".format(str(e))
        colorLogService = "\033[31m{}\033[00m".format(logService)
        print("{}\n".format(colorLogService))
        SystemServiceDB.updateStatusByName(logService, times.getDatetime(), globalVariable['serviceName'])

# Loop manual setiap 60 detik
while True:
    try:
        main(globalVariable)
        # print(f"Waiting 60 seconds...")
        time.sleep(60)
    except Exception as e:
        print(f"Error in main loop: {e}")
        time.sleep(60)
