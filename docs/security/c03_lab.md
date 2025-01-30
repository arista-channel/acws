# C-03 | AGNI and Wired EAP-TLS 802.1X
## Overview
In this lab...
--8<--
docs/snippets/topology.md
docs/snippets/login_agni.md
--8<--

## Enable RadSec

In this lab you will be configuring RadSec on the campus-podXX-leaf1c switches by adding the RadSec configuration to the leaf1c switches via the Static Configuration Studio.  

1. Login to CloudVision, then click on the “Provisioning” menu option, then choose “Studios”.
2. Create a workspace to propose changes to the Network Infrastructure. A workspace acts as a sandbox where you can stage your configuration changes before deploying them. 
3. Click “Create a Workspace”, give it any name you would like and click “Create”. 
4. Apply the static configuration to the campus-podXX-leaf1c switch using Static Configuration Studio
5. Click on Studios at the Top OR Left side navigation pane
6. Launch the Static Configuration Studios
7. Expand the Device Container Tree and select the “campus-pod<xx>-leaf1c” switch.
8. In the Device Container window, click on  “+ Configlet” followed by “Configlet Library”.  Select the Configlet named “Studios-campus-pod<xx>-radsec-config” and click Assign to add the configlet to the “campus-pod<xx>-leaf1c” switch. 
9. Click Review Workspace to review all the changes proposed to the CloudVision Studio
10. Review and Submit the Workspace
11. Review the workspace details showing the summary of modified studios, the build status, and the proposed configuration changes for each device.
12. Click “Submit Workspace”
13. Click “View Change Control”
14. Review, Approve and Execute the Change Control to apply the configuration changes
15. Click “Review and Approve”
16. Select “Execute immediately” an click “Approve and Execute”
17. The change control will execute and apply all the RadSec configuration changes to the device. This will enable RadSec connectivity between the campus-pod<xx>-leaf1c switch and AGNI.

    !!! tip "Automating Certificates"
        
        The switch device certificate and the AGNI RadSec root certificate have already been provisioned on the switch.This was completed using automation, specifically ansible and leveraging both the switch eAPI and AGNI API to generate, sign, and install certificates.

18. See Section B. Configuring RadSec profile in EOS for additional information.

## Create Wired EAP-TLS Network and Segment

1. Click on Access Devices - Devices to confirm the RadSec connection is up.
2. Create Wired EAP-TLS Network and Segment
3.  In this section we will create a Network and Segment in Cloudvision AGNI to utilize a certificate based TLS authentication method on a wired connection with a Raspberry Pi. 
4.  Click on Networks and select + Add Network
5.  Fill in and select the Following fields on the “Add Network” page.

    ???+ example "Settings"
        
        | Field                          | Value                         |
        | ------------------------------ | ----------------------------- |
        | Name                           | Wired-EAP-TLS                 |
        | Connection Type                | Wired                         |
        | Access Device Group            | Switches                      |
        | Status                         | enabled                       |
        | Authentication type            | Client Certificate (Eap-TLS)  |
        | Fallback to mac Authentication | Enabled                       |
        | MAC Authentication Type        | Allow Registered Clients Only |
        | Onboarding                     | Enabled                       |
        | Authorized User Groups         | Employees                     |


25. Click on Add Network at the bottom of the screen.  
26. Next, click on Segments and then + Add Segment
27. Next, type in the name: Wired-EAP-TLS and the Description as well.
28. Next, let’s Add Conditions.  Note: Adding more than one condition means MATCH ALL 
29. Select, Network, Name, Is, Wired-EAP-TLS from the drop down lists. 
30. Let’s add one more condition.
31. Select, Network, Authentication Type, Is, Client Certificate (EAP-TLS) from the drop down lists. 
32. Your Conditions should now look like this.
33. Under Actions select Add Action.
34. Select Allow Access.
35. Finally, select Add Segment at the bottom of the page. 
36. You should now be able to expand and review your segment.
37. Next, unplug and plug your raspberry Pi into port 2 on the switch and click on Sessions to see if your ATD Raspberry Pi has a connection via the Wired connection.  *Note: The Client Certificate has already been applied to the Raspberry Pi.

## Validate and Verify Wired EAP-TLS Device
1. Once the device is connected you will be able to view the status of the connection and additional session details if you click on the Eye to the right of the device. 
2. AGNI will then display more in depth session information regarding the device and connection. 
3. You can also validate the session on the switch by issuing the following commands in the switch CLI

    ```yaml
    show dot1x host
    ```

    ```yaml
    Port      Supplicant MAC Auth  State                   Fallback               VLAN
    --------- -------------- ----- ----------------------- ---------------------- ----
    Et2       d83a.dd98.6183 EAPOL SUCCESS                 NONE                       
    710P-16P#sh dot1x host mac d83a.dd98.6183 detail
    Operational:
    Supplicant MAC: d83a.dd98.6183
    User name: aristaatd01@outlook.com
    Interface: Ethernet2
    Authentication method: EAPOL
    Supplicant state: SUCCESS
    Fallback applied: NONE
    Calling-Station-Id: D8-3A-DD-98-61-83
    Reauthentication behaviour: DO-NOT-RE-AUTH
    Reauthentication interval: 0 seconds
    VLAN ID: 
    Accounting-Session-Id: 1x00000004
    Captive portal:
    AAA Server Returned:
    Arista-WebAuth: 
    Class: Rcnlkerh9ci3s72u197e0|C4151a596-baab-444b-a4fd-ad40946d8b5f
    Filter-Id: 
    Framed-IP-Address: 192.168.101.21 sourceArp
    NAS-Filter-Rule: 
    Service-Type: None
    Session-Timeout: 86400 seconds
    Termination-Action: RADIUS-REQUEST
    Tunnel-Private-GroupId: 
    Arista-PeriodicIdentity:
    ```

--8<-- "includes/abbreviations.md"
