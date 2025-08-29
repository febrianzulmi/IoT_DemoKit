number = 3

import sys
import time

sys.path.append('/home/connex/library')
from SynapsisLibrary import times
sys.path.append('/home/connex/project/database')
from query_project_db import ActuatorListDB, SystemServiceDB
sys.path.append('/home/connex/project/function')
from actuatorFunction import ActuatorFunction
from actuatorLibrary import ActuatorBLE
from serviceProjectFunction import ServiceProjectFunction
from logFunction import logFunction

global_variable = {}
global_variable["number"] = number
global_variable["serviceName"] = f"actuator{number}"
global_variable["flag"] = 0
global_variable["logger"] = logFunction.setupLogger(global_variable["serviceName"], stream=True)

timestamp = times.getDatetime()
global_variable["logger"].debug(f"Start : {timestamp}")
first = 0

def actionActuator(global_variable, actuator_run, actuator_data):
    status = ActuatorBLE.run(global_variable, actuator_run, actuator_data)
    return status

def main():
    global first

    now2 = times.now()
    timestamp = now2.strftime("%Y-%m-%d %H:%M:%S")
    now2 = int((now2.minute*60)+now2.second)

    actuator_data = ActuatorListDB.selectByActuatorGroupNumberState(number, "1", "1")
    if len(actuator_data) > 0:
        if first == 0:
            status_actuator = ActuatorFunction.checkSyncValueFunction(actuator_data, timestamp, actionActuator, global_variable)
            global_variable["logger"].debug(f"{timestamp}".center(34, '-'))
            global_variable["logger"].debug(f"Summary Sync Actuator : {status_actuator['summary']}")
            summary = status_actuator["summary"]
            first = 1
        
        else:
            global_variable["logger"].debug(f"{timestamp}".center(34, '-'))
            status_actuator = ActuatorFunction.checkServerValueFunction(actuator_data, timestamp, actionActuator, global_variable)
            global_variable["logger"].debug(f"Summary Trigger Server Actuator : {status_actuator['summary']}")
            status_schedule = ActuatorFunction.checkScheduleFunction(actuator_data, timestamp, actionActuator, global_variable)
            global_variable["logger"].debug(f"Summary Trigger Schedule Actuator : {status_schedule['summary']}")
            summary = f"{status_actuator['summary']} | {status_schedule['summary']}"
        
        SystemServiceDB.updateStatusByName(summary, timestamp, f"actuator{number}")
        # first = 1
        global_variable["logger"].debug("---------------------------------")
    else:
        global_variable["logger"].debug("No Actuator List Found with Actuator Group Number" + str(number))

    global_variable["logger"].debug("")
    time.sleep(1)

while True:
    if __name__ == '__main__':        
        try:
            main()
        except KeyboardInterrupt:
            print("Shutting down...")
            # Cleanup BLE connection
            from actuatorLibrary import ActuatorBLE
            ActuatorBLE.disconnect()
            break
        except Exception as e:
            ServiceProjectFunction.handlingServiceError("Actuator " + str(number), e, global_variable)