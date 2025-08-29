import json
import re
import sys
import time
import asyncio
import threading

from pymodbus.client.sync import ModbusSerialClient as ModbusClient
import requests

sys.path.append('/home/connex/library')
from SynapsisLibrary import times
sys.path.append('/home/connex/project/database')
from query_project_db import SensorListDB, RtuDeviceDB
sys.path.append("/home/connex/project/function")
from actuatorFunction import ActuatorFunction
from generalFunction import generalFunction

# Import bleak untuk BLE (perlu diinstall: pip install bleak)
try:
    from bleak import BleakClient, BleakScanner
    BLE_AVAILABLE = True
except ImportError:
    BLE_AVAILABLE = False
    print("Warning: bleak library not available. BLE functionality will be disabled.")

class ActuatorRTU():
    def run(global_variable, actuator_run, actuator_data):
        parameter_group = ActuatorFunction.getParameterGroupActuator(global_variable["number"])
        parameter_list = ActuatorFunction.getParameterListActuator(global_variable["number"])
        result_action = {"state": [], "value": [], "summary": "", "message": []}
        if len(actuator_data) > 0:
            port = generalFunction.checkUSBDevice(parameter_group["port"])
            port = port[1]
            if port != "N/A": 
                port = f"/dev/{port}"
                try:
                    rtu_object = ModbusClient(method="rtu", port=port, baudrate=int(parameter_group["baudrate"]), parity='N', stopbits=1, bytesize=8)
                except Exception as e:
                    rtu_object = None
                if rtu_object != None:
                    success_run = 0
                    for x in range(len(actuator_data)):
                        try:
                            if actuator_run["action"][x] == True:
                                actuator_custom_id = actuator_data[x]["actuator_custom_id"]
                                rtu_number = actuator_custom_id[actuator_custom_id.lower().find("rtu") + 3:]
                                slave_id = int(RtuDeviceDB.selectByNumber(rtu_number)[0]["slave_id"])
                                address = int(parameter_list[actuator_data[x]["actuator_custom_id"]]["address"])
                                divider = float(parameter_list[actuator_data[x]["actuator_custom_id"]]["divider"])
                                if address > 40000:
                                    result = rtu_object.write_register(address=address-40001, value=int(int(actuator_run["value"][x]) * divider), unit=slave_id)
                                else:
                                    result = rtu_object.write_coil(address=address-1, value=int(int(actuator_run["value"][x]) * divider), unit=slave_id)
                                if result.isError() == False:
                                    result_state, result_value = True, result.value
                                    result_action["message"].append("Success")
                                    success_run += 1
                                else:
                                    result_state, result_value = False, None
                                    result_action["message"].append(result.message)
                            else:
                                result_state, result_value= False, None
                                result_action["message"].append("Skip Run")
                        except Exception as e:
                            result_state, result_value = False, None
                            result_action["message"].append(str(e))
                        result_action["state"].append(result_state)
                        result_action["value"].append(result_value)
                    result_action["summary"] = f"Success Run {success_run} of {actuator_run['count']} Actuator from {len(actuator_data)} Actuator"
                else:
                    result_action["state"].append(False)
                    result_action["value"].append(None)
                    result_action["message"].append("RTU Device Not Found")
                    result_action["summary"] = "RTU Device Not Found"    
            else:
                result_action["state"].append(False)
                result_action["value"].append(None)
                result_action["message"].append("Port N/A")
                result_action["summary"] = "Port N/A"
        else:
            result_action["summary"] = "No Actuator Data"
        # print(result_action)
        return result_action


def actuatorAC(actuator_custom_id, value):
   def sendCommand(actuator_custom_id, value, swing, temp, url_ac):
      headers = {"content-type": "application/json"} 
      data_json = json.dumps({'ac':str(actuator_custom_id), 'state':str(value), 'swing':swing, 'temp':str(temp)})
      send = requests.post(url=url_ac, data=data_json, headers=headers, timeout=10)
      state = send.status_code
      return send.json(), state  
      
   status, num = None, 0 
   actuator_custom_id = actuator_custom_id.replace("remote","")
   parameterActuator = ActuatorFunction.getParameterListActuator(actuator_custom_id)  
   try:   
      url_ac = f"http://{parameterActuator['ip']}{parameterActuator['endpoint']}"
      response_state = None
      while num < 1:
         num += 1
         timestamp = times.getDatetime()
         send, state = sendCommand(actuator_custom_id, value, parameterActuator['swing'], parameterActuator['temperature'], url_ac)
         if state == 200:
            response_state = send['data']['state']  # Mengakses state dari respons JSON
            SensorListDB.updateValue(response_state, timestamp, "stateAc" + str(actuator_custom_id))
            status = "Action Success"
         else:
            status = "Action Error"
         time.sleep(1) 
         
   except Exception as e:
      num = 1          
      state = 404
      status = f"Action Failed - {str(e)}"

   status = str(status) + " | " + str(num) + "x Action"   
   return status

class ActuatorGPIO():
    def run(global_variable, actuator_run, actuator_data):
        parameter_list = ActuatorFunction.getParameterListActuator(global_variable["number"])
        result_action = {"state": [], "value": [], "summary": "", "message": []}
        
        if len(actuator_data) > 0:
            try:
                # Setup GPIO mode
                GPIO.setmode(GPIO.BCM)
                GPIO.setwarnings(False)
                
                success_run = 0
                for x in range(len(actuator_data)):
                    try:
                        if actuator_run["action"][x] == True:
                            actuator_custom_id = actuator_data[x]["actuator_custom_id"]
                            pin = int(parameter_list[actuator_data[x]["actuator_custom_id"]]["pin"])
                            
                            # Setup pin as output
                            GPIO.setup(pin, GPIO.OUT)
                            
                            # Set pin value (0 for OFF, 1 for ON)
                            value = int(actuator_run["value"][x])
                            GPIO.output(pin, value)
                            
                            result_state, result_value = True, value
                            result_action["message"].append("Success")
                            success_run += 1
                        else:
                            result_state, result_value = False, None
                            result_action["message"].append("Skip Run")
                    except Exception as e:
                        result_state, result_value = False, None
                        result_action["message"].append(str(e))
                    result_action["state"].append(result_state)
                    result_action["value"].append(result_value)
                
                result_action["summary"] = f"Success Run {success_run} of {actuator_run['count']} Actuator from {len(actuator_data)} Actuator"
                
            except Exception as e:
                result_action["state"].append(False)
                result_action["value"].append(None)
                result_action["message"].append(f"GPIO Error: {str(e)}")
                result_action["summary"] = f"GPIO Error: {str(e)}"
        else:
            result_action["summary"] = "No Actuator Data"
        
        return result_action

class ActuatorBLE():
    # Global BLE controller untuk mempertahankan koneksi
    _ble_controller = None
    _is_initialized = False
    _event_loop = None
    _lock = None
    
    def run(global_variable, actuator_run, actuator_data):
        parameter_group = ActuatorFunction.getParameterGroupActuator(global_variable["number"])
        parameter_list = ActuatorFunction.getParameterListActuator(global_variable["number"])
        result_action = {"state": [], "value": [], "summary": "", "message": []}
        
        if not BLE_AVAILABLE:
            result_action["state"].append(False)
            result_action["value"].append(None)
            result_action["message"].append("BLE library not available")
            result_action["summary"] = "BLE library not available"
            return result_action
        
        # Initialize BLE controller jika belum
        if not ActuatorBLE._is_initialized:
            device_name = parameter_group.get("device_name", "nRF-AC-Controller")
            ActuatorBLE._initialize_ble_controller(device_name)
        
        if len(actuator_data) > 0:
            success_run = 0
            
            for x in range(len(actuator_data)):
                try:
                    if actuator_run["action"][x] == True:
                        actuator_custom_id = actuator_data[x]["actuator_custom_id"]
                        
                        # Ambil ac_type dari parameter list (bisa berbeda untuk setiap actuator)
                        ac_type = int(parameter_list[actuator_custom_id].get("ac_type", "1"))  # Default DAIKIN
                        control_value = int(actuator_run["value"][x])
                        
                        # Kirim command melalui BLE dengan koneksi yang sudah established
                        result = ActuatorBLE._send_ble_command_direct(ac_type, control_value)
                        
                        if result["success"]:
                            result_state, result_value = True, control_value
                            result_action["message"].append("Success")
                            success_run += 1
                        else:
                            result_state, result_value = False, None
                            result_action["message"].append(f"BLE Error: {result['error']}")
                    else:
                        result_state, result_value = False, None
                        result_action["message"].append("Skip Run")
                except Exception as e:
                    result_state, result_value = False, None
                    result_action["message"].append(str(e))
                
                result_action["state"].append(result_state)
                result_action["value"].append(result_value)
            
            result_action["summary"] = f"Success Run {success_run} of {actuator_run['count']} Actuator from {len(actuator_data)} Actuator"
        else:
            result_action["summary"] = "No Actuator Data"
        
        return result_action
    
    def _initialize_ble_controller(device_name):
        """Initialize BLE controller dengan koneksi langsung"""
        try:
            # UUID dari Arduino code
            SERVICE_UUID = "12345678-1234-5678-9abc-123456789abc"
            CONTROL_CHAR_UUID = "87654321-4321-8765-cbaa-987654321abc"
            AC_TYPE_CHAR_UUID = "11111111-2222-3333-4444-555555555555"
            
            # Buat event loop yang persistent
            if ActuatorBLE._event_loop is None:
                ActuatorBLE._event_loop = asyncio.new_event_loop()
                asyncio.set_event_loop(ActuatorBLE._event_loop)
            
            # Import threading untuk lock
            import threading
            if ActuatorBLE._lock is None:
                ActuatorBLE._lock = threading.Lock()
            
            result = ActuatorBLE._event_loop.run_until_complete(ActuatorBLE._async_initialize_ble(
                device_name, SERVICE_UUID, CONTROL_CHAR_UUID, AC_TYPE_CHAR_UUID
            ))
            
            if result["success"]:
                ActuatorBLE._is_initialized = True
                print("BLE controller initialized successfully")
            else:
                print(f"BLE controller initialization failed: {result['error']}")
                
        except Exception as e:
            print(f"BLE controller initialization error: {str(e)}")
    
    async def _async_initialize_ble(device_name, service_uuid, control_char_uuid, ac_type_char_uuid):
        """Async function untuk initialize BLE connection"""
        try:
            print(f"Initializing BLE connection to: {device_name}")
            devices = await BleakScanner.discover(timeout=10.0)
            
            target_device = None
            for device in devices:
                if device.name and device_name.lower() in device.name.lower():
                    target_device = device
                    break
            
            if not target_device:
                return {"success": False, "error": f"Device {device_name} not found"}
            
            print(f"Found device: {target_device.name} ({target_device.address})")
            
            # Connect ke device dan simpan client
            client = BleakClient(target_device.address)
            await client.connect()
            
            # Simpan BLE controller
            ActuatorBLE._ble_controller = {
                "client": client,
                "device": target_device,
                "service_uuid": service_uuid,
                "control_char_uuid": control_char_uuid,
                "ac_type_char_uuid": ac_type_char_uuid,
                "is_connected": True,
                "device_name": device_name
            }
            
            print(f"Connected to {target_device.name}")
            return {"success": True, "error": None}
            
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def _send_ble_command_direct(ac_type, control_value):
        """Kirim command menggunakan koneksi BLE yang sudah established"""
        if not ActuatorBLE._ble_controller or not ActuatorBLE._ble_controller["is_connected"]:
            # Coba reconnect jika koneksi terputus
            if ActuatorBLE._ble_controller:
                print("BLE connection lost, attempting to reconnect...")
                ActuatorBLE._reconnect_ble()
            
            if not ActuatorBLE._ble_controller or not ActuatorBLE._ble_controller["is_connected"]:
                return {"success": False, "error": "BLE not connected"}
        
        try:
            # Gunakan lock untuk thread safety
            with ActuatorBLE._lock:
                result = ActuatorBLE._event_loop.run_until_complete(ActuatorBLE._async_send_command_direct(
                    ac_type, control_value
                ))
                return result
                
        except Exception as e:
            return {"success": False, "error": str(e)}
    
    def _reconnect_ble():
        """Reconnect ke BLE device"""
        try:
            if ActuatorBLE._ble_controller:
                device_name = ActuatorBLE._ble_controller.get("device_name", "nRF-AC-Controller")
                print(f"Reconnecting to {device_name}...")
                
                # Reset connection state
                ActuatorBLE._is_initialized = False
                ActuatorBLE._ble_controller = None
                
                # Reinitialize
                ActuatorBLE._initialize_ble_controller(device_name)
                
        except Exception as e:
            print(f"Reconnect error: {str(e)}")
    
    async def _async_send_command_direct(ac_type, control_value):
        """Async function untuk kirim command dengan koneksi yang sudah ada"""
        try:
            controller = ActuatorBLE._ble_controller
            client = controller["client"]
            
            # Check if still connected
            if not client.is_connected:
                ActuatorBLE._ble_controller["is_connected"] = False
                return {"success": False, "error": "Connection lost"}
            
            # Set AC Type characteristic
            await client.write_gatt_char(controller["ac_type_char_uuid"], bytes([ac_type]))
            print(f"Set AC Type to: {ac_type}")
            
            # Set Control characteristic
            await client.write_gatt_char(controller["control_char_uuid"], bytes([control_value]))
            print(f"Set Control to: {control_value}")
            
            # Tunggu sebentar untuk memastikan command terkirim
            await asyncio.sleep(0.5)
            
            return {"success": True, "error": None}
            
        except Exception as e:
            # Jika koneksi terputus, mark sebagai disconnected
            ActuatorBLE._ble_controller["is_connected"] = False
            return {"success": False, "error": f"Command failed: {str(e)}"}
    
    def disconnect():
        """Disconnect dari BLE device"""
        if ActuatorBLE._ble_controller and ActuatorBLE._ble_controller["is_connected"]:
            try:
                if ActuatorBLE._event_loop:
                    ActuatorBLE._event_loop.run_until_complete(ActuatorBLE._async_disconnect())
                    
            except Exception as e:
                print(f"Disconnect error: {str(e)}")
    
    async def _async_disconnect():
        """Async function untuk disconnect"""
        if ActuatorBLE._ble_controller:
            await ActuatorBLE._ble_controller["client"].disconnect()
            ActuatorBLE._ble_controller["is_connected"] = False
            ActuatorBLE._is_initialized = False
            print("Disconnected from BLE device")
