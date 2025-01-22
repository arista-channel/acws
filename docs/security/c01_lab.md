# C-01 | AGNI and Wifi EAP-TLS 802.1X

## Overview

In this lab we will be working within the `WiFi` configuration section of CV-CUE. Create an SSID (WPA2 802.1X) with your `ATD-##-EAP` as the name (where ## is a 2 digit character between 01-12 that was assigned to your lab/Pod).

--8<--
docs/snippets/topology.md
docs/snippets/login_cvcue.md
--8<--

## 01 | Create an EAP-TLS SSID

The `Configure` section of CV-CUE is composed of multiple parts, including WiFi, Alerts, WIPS, etc. In this lab we are focused on the `Wifi` section.

!!! tip "Other configuration sections"
    
    - **Alerts:** Where syslog and other alert related settings are configured
    - **WIPS:** Where the policies are configured for the WIPS sensor.

1. Hover your cursor over the `Configure` menu option on the left side of the screen, then click `WiFi`
2. At the top of the screen, you will see where you are in the location hierarchy. If you aren’t on “Corp”, click on the three lines (hamburger icon) next to “Locations” to expand the hierarchy and choose/highlight the “Corp” folder.  Now click the “Add SSID” button on the right hand side of the screen.

=== "Collapsed"

    ![Hierarchy Collapsed]()

=== "Expanded"

    ![Hierarchy Expanded]()

3. Once on the “SSID” page, configuration sub-category menu options will appear across the top of the page related to WiFi (the defaults are “Basic”, “Security”, and “Network”). You can click on these sub-category names to change configuration items related to that area of the configuration.

To make additional categories visible, click on the 3 dots next to "Network" and you can see the other categories that are available to configure (i.e. “Analytics”, “Captive Portal”, etc.).





In the “Basic” sub-category option, name the SSID “ATD-##-EAP” (where ## is a 2 digit character between 01-20 that was assigned to your lab/Pod). The “Profile Name” is used to describe the SSID and should have been auto-filled for you.



Since this is our corporate SSID, leave the “Select SSID Type” set to “Private”, but note this is where you would change it to “Guest” if needed.  Select Next at the bottom.




In the “Security” sub-category, select WPA2 and change the association type to “802.1X”.




Next, under RADIUS Settings check RadSec and select AGNI in the drop down box under Authentication and Accounting Server



The AGNI Radius Profile is already configured for your use. See Section B for more information on setting up the AGNI Radius Profile. 

Select “Next” at the bottom of the screen.


In the “Network” configuration sub-category, we’ll leave the “VLAN ID” set to “0”, which means it will use the native VLAN. If the switchport the AP is attached to is trunked, you could change this setting to whichever VLAN you want the traffic mapped to.

We are using “Bridged” mode in this lab. 


You could use “NAT” (often done for Guest) or “L2 Tunnel” / “L3 Tunnel” (as you would see for a Guest Anchor or tunneled corporate traffic).

The rest of the settings can be left at the default values.

Click the “Save & Turn SSID On” button at the bottom of the page.



On the pop-up page, click “Customize” if that option appears, otherwise skip to the next step.



Only select the “5 GHz” option on the next screen (uncheck the 2.4 GHz box if it’s checked), then click “Turn SSID On”.




After you turn on the SSID, hover your cursor over “Monitor” in the left hand side menu, and then click “WiFi”.



Now, in the menu options at the top of the page, look at the “Radios” menu option. Is the 5 GHz radio “up” and 2.4 GHz radio “down”? It may take a minute or two for the radio to become active. 



Check the “Active SSIDs” menu at the top of the screen.  Is your SSID listed?










## 02 | CloudVision AGNI Access

--8<--
docs/snippets/login_agni.md
--8<--


## 03 | Create AGNI Networks & Segments for the EAP-TLS Wireless Policy
Click on Networks and select + Add Network

        

Type in the name Wireless-EAP-TLS
Select Connection Type: Wireless
SSID needs to match what you created in CV-CUE type ATD-##-EAP




For Authentication select Client Certificate (EAP-TLS)


Click on Add Network at the bottom of the screen.  



Next, click on Segments and then + Add Segment





Next, type in the name: Wireless - EAP-TLS and the Description as well.


Next, let’s Add Conditions.  *Note: Adding more than one condition means MATCH ALL 

Select, Network, Name, Is, Wireless-EAP-TLS from the drop down lists. 


Let’s add one more condition.

Select, Network, Authentication Type, Is, Client Certificate (EAP-TLS) from the drop down lists. 



Your Conditions should now look like this.


Under Actions select Add Action.

Select Allow Access.



Finally, select Add Segment at the bottom of the page. 


You should now be able to expand and review your segment.



Next, click on Sessions to see if your ATD Raspberry Pi has a connection via the Wireless connection.  *Note: The Client Certificate has already been applied to the Raspberry Pi and is configured to connect to the SSID ATD-##-EAP.

If you don’t see any new sessions within 2 minutes AGNI, power cycle the Raspberry Pi.

--8<-- "includes/abbreviations.md"
