number = 3

import argparse
import sys

sys.path.append('/home/connex/library')
from SynapsisLibrary import times
sys.path.append('/home/connex/project/database')
from query_project_db import ActuatorListDB, LogActuatorDB
from actuatorLibrary import ActuatorBLE
sys.path.append("/home/connex/project/function")
from notificationFunction import notificationFunction
from dbFunction import dbFunction


parser = argparse.ArgumentParser()

# Adding optional argument
parser.add_argument("-a", "--action", help = "Show Output")
parser.add_argument("-l", "--list", help = "Show Output")

# Read arguments from command line
global_variable = {}
global_variable["number"] = number
args = parser.parse_args()
action_value = None
actuator_list_id = None

if args.action != None:
   action_value = args.action
if args.list != None:
   actuator_list_id = args.list

def actionActuator(global_variable, actuator_run, actuator_data):
    status = ActuatorBLE.run(global_variable, actuator_run, actuator_data)
    return status

def main():
    global action_value, actuator_list_id, global_variable

    timestamp = times.getDatetime()
    print(f"Timestamp : {timestamp}")

    feature_setting = dbFunction.getFeatureSetting()
    actuator_data = ActuatorListDB.selectByIdFull(actuator_list_id)
    actuator_run = {"value": [], "action": [], "count": 0}
    if len(actuator_data) == 1:
        actuator_name = actuator_data[0]['name']
        actuator_group_name = actuator_data[0]['actuator_group_name']
        actuator_run["action"].append(True)
        actuator_run["value"].append(action_value)
        actuator_run["count"] += 1

        print(f"Actuator Group Name : {actuator_group_name}")
        print(f"Actuator List Name : {actuator_name}")
        print(f"Action Value : {action_value}")
        status_actuator = actionActuator(global_variable, actuator_run, actuator_data)
        status_actuator["summary"] = f"{status_actuator['summary']} - Controlled by Local Remote"
        for x in range(len(actuator_data)):
            print(f"Result Action : {status_actuator['state'][x]}")
            print(f"Result Message : {status_actuator['message'][x]}")
            if status_actuator["state"][x] == True:
                control = "1x Action"
                ActuatorListDB.updateAction(actuator_run["value"][x], 3, timestamp, actuator_data[x]["id"])
                LogActuatorDB.insert(actuator_data[x]["id"], actuator_run["value"][x], 3, timestamp)
                if str(feature_setting['notification']) == "1":
                    notificationFunction.generateNotificationActuator(actuator_data[x]["id"], 3, actuator_run["value"][x], timestamp, control)
    else:
        print("No Actuator List Found")    
        

if __name__ == '__main__': 
    try:
        main()
    except Exception as e:
        print(f"Error Run Actuator Local Remote - {str(e)}")