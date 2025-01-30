# C-01 | AGNI and Wifi EAP-TLS 802.1X

## Overview

In this lab we will be working within the `WiFi` configuration section of CV-CUE. Create an SSID (WPA2 802.1X) with your `ATD-##-EAP` as the name (where ## is a 2 digit character between 01-12 that was assigned to your lab/Pod).

--8<--
docs/snippets/topology.md
docs/snippets/login_cvcue.md
--8<--

## Create an EAP-TLS SSID

The `Configure` section of CV-CUE is composed of multiple parts, including WiFi, Alerts, WIPS, etc. In this lab we are focused on the `Wifi` section.

!!! tip "Other configuration sections"
    - **Alerts:** Where syslog and other alert related settings are configured
    - **WIPS:** Where the policies are configured for the WIPS sensor.

1. Hover your cursor over the `Configure` menu option on the left side of the screen, then click `WiFi`
2. At the top of the screen, you will see where you are in the location hierarchy. If you aren’t on “Corp”, click on the three lines (hamburger icon) next to “Locations” to expand the hierarchy and choose/highlight the “Corp” folder.  Now click the “Add SSID” button on the right hand side of the screen.
3. Once on the “SSID” page, configuration sub-category menu options will appear across the top of the page related to WiFi (the defaults are “Basic”, “Security”, and “Network”). You can click on these sub-category names to change configuration items related to that area of the configuration.
4. To make additional categories visible, click on the 3 dots next to "Network" and you can see the other categories that are available to configure (i.e. “Analytics”, “Captive Portal”, etc.).
5. In the “Basic” sub-category option, name the SSID “ATD-##-EAP” (where ## is a 2 digit character between 01-20 that was assigned to your lab/Pod). The “Profile Name” is used to describe the SSID and should have been auto-filled for you.
6. Since this is our corporate SSID, leave the “Select SSID Type” set to “Private”, but note this is where you would change it to “Guest” if needed.  Select Next at the bottom.
7. In the “Security” sub-category, select WPA2 and change the association type to “802.1X”.
8. Next, under RADIUS Settings check RadSec and select AGNI in the drop down box under Authentication and Accounting Server
9. The AGNI Radius Profile is already configured for your use. See Section B for more information on setting up the AGNI Radius Profile.
10. Select “Next” at the bottom of the screen.
11. In the “Network” configuration sub-category, we’ll leave the “VLAN ID” set to “0”, which means it will use the native VLAN. If the switchport the AP is attached to is trunked, you could change this setting to whichever VLAN you want the traffic mapped to.
12. We are using “Bridged” mode in this lab.
13. You could use “NAT” (often done for Guest) or “L2 Tunnel” / “L3 Tunnel” (as you would see for a Guest Anchor or tunneled corporate traffic).
14. The rest of the settings can be left at the default values.
15. Click the “Save & Turn SSID On” button at the bottom of the page.
16. On the pop-up page, click “Customize” if that option appears, otherwise skip to the next step.
17. Only select the “5 GHz” option on the next screen (uncheck the 2.4 GHz box if it’s checked), then click “Turn SSID On”.
18. After you turn on the SSID, hover your cursor over “Monitor” in the left hand side menu, and then click “WiFi”.
19. Now, in the menu options at the top of the page, look at the “Radios” menu option. Is the 5 GHz radio “up” and 2.4 GHz radio “down”? It may take a minute or two for the radio to become active.
20. Check the “Active SSIDs” menu at the top of the screen.  Is your SSID listed?

## CloudVision AGNI Access

--8<--
docs/snippets/login_agni.md
--8<--

## Create AGNI Networks & Segments for the EAP-TLS Wireless Policy

1. Click on Networks and select + Add Network
2. Type in the name Wireless-EAP-TLS
3. Select Connection Type: Wireless
4. SSID needs to match what you created in CV-CUE type ATD-##-EAP
5. For Authentication select Client Certificate (EAP-TLS)
6. Click on Add Network at the bottom of the screen.
7. Next, click on Segments and then + Add Segment
8. Next, type in the name: Wireless - EAP-TLS and the Description as well.
9. Next, let’s Add Conditions.  *Note: Adding more than one condition means MATCH ALL
10. Select, Network, Name, Is, Wireless-EAP-TLS from the drop down lists.
11. Let’s add one more condition.
12. Select, Network, Authentication Type, Is, Client Certificate (EAP-TLS) from the drop down lists.
13. Your Conditions should now look like this.
14. Under Actions select Add Action.
15. Select Allow Access.
16. Finally, select Add Segment at the bottom of the page.
17. You should now be able to expand and review your segment.
18. Next, click on Sessions to see if your ATD Raspberry Pi has a connection via the Wireless connection.  *Note: The Client Certificate has already been applied to the Raspberry Pi and is configured to connect to the SSID ATD-##-EAP.
19. If you don’t see any new sessions within 2 minutes AGNI, power cycle the Raspberry Pi.

--8<-- "includes/abbreviations.md"
