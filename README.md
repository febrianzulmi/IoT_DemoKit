## Version
v1.0.0 (02 Juni 2025)



<img width="400" height="600" alt="image" src="https://github.com/user-attachments/assets/b77e0c0b-cad0-47d0-9e93-4561b86e773c" />
<img width="400" height="600" alt="image" src="https://github.com/user-attachments/assets/319ad058-286d-46e3-bde8-2a46a8826128" />


## Structure Directory        
- Project Location : /home/connex/project
- Platform Location : /home/connex/platform
- Library Location : /home/connex/library
- Services Location : /lib/systemd/system
- Config OS Location :
    1. SNMP Config : snmp.conf -> /etc/snmp/snmpd.conf
    2. NTP Config : timesyncd.conf -> /etc/systemd/timesyncd.conf
    3. DHCP Config : dnsmasq.conf -> /etc/dnsmasq.conf
    4. Hotspot Config : hostapd.conf -> /etc/hostapd/hostapd.conf
    5. Network Config : interfaces -> /etc/network/interfaces
    6. Wireless Config : wpa_supplicant.conf -> /etc/wpa_supplicant/wpa_supplicant.conf
    7. Raspberry Config : 
        a. config.txt -> /boot/config.txt
        b. cmdline.txt -> /boot/cmdline.txt

## Network Configuration
- Ethernet : 192.168.1.10/24 (Static)
- Wireless :
  1. IP Address : 172.16.11.1/24 (Static)      
  2. Mode : Hotspot
  3. SSID : Nearon IoT SLB
  4. Password : 12345678
     
