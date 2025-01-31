# B-01 | Arista Wireless Setup

## Overview

What is this lab

--8<--
docs/snippets/login_cvcue.md
--8<--

Arista Launchpad

Launchpad is the portal to access your Arista cloud services including WiFi Management (CV-CUE) and AGNI (Network Access Control). When you open the launcher, you are presented with management applications on the Dashboard menu and access controls with the Admin menu.

When you open the launcher, you are presented with multiple applications. Each is included with the subscription (as is support).
  


 

CV-CUE CloudVision-WiFi - Wireless Manager. 
Canvas is used for Campaigns. 
Guest Manager looks at the users and how they are interacting with your environment. 
Nano allows you to manage your environment from your smartphone 
Packets is an online .pcap debug allowing you to examine the packet information.
WiFi Resources includes documentation and eLearning has 6 ½ hours of training, also included.
CVP Staging CloudVision Portal - Switch Management - Staging Environment - *New
WiFi Device Registration is the process for importing APs onto your account


Add a User and Assign Privileges

First, use the Admin menu to add a user.

Click on the Admin Tab at the top of the Launchpad window:



Overview of Launchpad Admin menu:
Users - Assign Access to users with different access levels as well as to specific folders
Keys - Used with API integrations
Profiles - Defines Access levels to CV-CUE, LaunchPad, and Guest Manager
Logs - Download User Action Logs
Settings - Lockout Policy, Password Policy, and 2-Factor settings
Account Settings - Change your Timezone and Change your password.

CloudVision CUE authenticates users via SAML directory integration or via the Launchpad identity providers. These can be customized with local users in Launchpad or directory single-sign-on users.

https://arista.my.site.com/AristaCommunity/s/article/Integrating-Third-Party-SAML-Solution-Providers-with-Arista-CV-CUE


End of lab section.




3. AP Registration
WiFi Device Registration - Reference section
Reference information below - these steps have already been done for you by event staff

*Note: Arista AP serial numbers are automatically assigned to the user’s CV-CUE staging area when purchased. In addition, specific devices can be registered for management using the WiFi Device Registration  function, accessible from Launchpad Dashboard.


Let’s click on the “Dashboard” menu option on the left hand side of the screen.  This opens the Dashboard Overview screen which provides us with numerous metrics for our wireless environment.  


Within the Import Function you can provide individual AP serials and keys or upload a CSV.

Assign Access points to Wireless Manager Service

End of lab section.
4. CV-CUE CloudVision Wifi Access
CloudVision CUE - Cognitive Unified Edge, provides the management plane and monitoring functions for the Arista WiFi solution. 

Click on the CV-CUE (CloudVision WiFi) Tile in the LaunchPad from the Dashboard menu.  


When the CV-CUE interface launches, you are presented with an initial dashboard to monitor your wireless environment at a glance, we will revisit these metrics later in the lab. Since this is a new setup the initial dashboard screen will be mostly empty.





Use the left menu bar to select monitoring and configuration functions.

The primary menu navigation functions are the following:

Dashboard - Alerts, Client Access, Infrastructure health, Application Experience, and WIPS
Monitor - Monitor and explore Clients, APs, Radios, SSIDs, Application traffic, Tunnels
Configure - WiFi SSIDs, APs and Radios, Tunnels, RADIUS, and WIPS settings
Troubleshoot - Client connection test, packet trace, live debug logs, historic logging
Engage - User insights, Presence, Usage, 3rd party integrations
Floor Plans - Floor layouts and AP location map view
Reports - Detailed information for Infrastructure APs/Radios, Client Connectivity and Experience, WIPS detections
System - Locations Hierarchy, AP Groups, 3rd party server settings, keys and certificates 
In addition to the menu bar navigation and Locations Hierarchy, the UI provides a common Search bar, Metric summary, and Help button throughout workflows.

End of lab section.




5. Assign AP Name
Access points that successfully receive an IP address, DNS, and default gateway, via DHCP, and have connectivity over HTTPS/TCP/443 to CV-CUE will be shown within CV-CUE under Monitor > WiFi 

Select the Access Points section and observe the discovered AP and default name “Arista_” and the last 3 bytes of the MAC address.

Customize the AP’s name by clicking the 3-dots menu and Rename

 
Give the AP a name such as: “POD-##-AP1”or “POD-##-AP2” where ## is a 2 digit character between 01-20 that was assigned to your lab/Pod.



Lab Section Completed.




6.  Managing the Configuration Hierarchy:

Open CV-CUE / CloudVision-WiFi. The configuration is hierarchical, so everything you configure will be pushed down from that level. Expand the “Locations” pane by clicking on the hamburger icon.  Now select the three dots to the left of “Locations'' and click on  “Manage Navigator”.

             




“Manage Navigator” is where you create Folders, Floors, and Groups.

Folders typically represent a company, branch office name or division.
Floors are straightforward and are where maps are placed.
Groups are a way to make a configuration more granular. Let’s say you want a branch location to have all of the same configuration but Outdoor APs need to vary from that. You would create a group for the Outdoor APs, put the APs into that group and override the part of the configuration that is unique. Think of your company and how you would want to lay it out.




Add a folder for your Company Name. In the “Navigator”, select the 3 dots next to “Locations”:



Select “Add Folder/Floor” and then name your new Folder “ACorp” for student1 and “BCorp” for student2



Next, create 2 more folders called “1st Floor” and “2nd Floor”.  Right click on the word “Corp” to expose the menu.




Note:  It’s also possible to add multiple floors at once using the “Add Multiple Folders/Floors” menu option:
     
Use the “*” key to create floors instead of folders

Next, move your AP into the “1st Floor” folder you created. To move your AP from the staging area, right click on the “Staging Area” folder, and select “Show Available Devices”.




Next, right click on the AP name, select  “Move” and then select the “1st Floor” folder you created earlier, and then click the “Move” button at the bottom of the screen.

     



You’ll see a pop-up message to confirm the move. Click “Move” again to finish the process:



You can verify the move by selecting the “1st Floor” folder and then “Show Available Devices”.

    



Check the email you received as part of this Arista Test Drive session, you will find an image attached to the email to use as a floor plan. Save that image to your computer.

Floor plan image example:




In the left hand menu, click on “Floor Plans”.  Make sure to set the location level to be “1st Floor”.  Click the “Add Floor Plan” button in the upper right corner of the screen.

 




Enter floor name as “1st Floor”, click the “Upload Image” button to import the floor plan image, and use the following dimensions:  Floor Plan Dimensions: Unit: Feet, Length: 120, Width: 50

Click “Save” at the bottom of the screen.







Next, drag the AP onto the map, from the right hand side menu, to see how easy placing APs is. 

If you do not see an AP, it is because your AP is assigned to another location (folder) and you’ll need to move it to the “1st Floor” folder (see page 8). Or, you may have the incorrect menu selected in the upper right hand corner of the screen - choose “Place Access Points”.  






Hover over the AP image to get more information and then right-click on the AP image to see more options.  

                

Next, explore the other menu options like RF Heatmaps (in the menu on the right hand side of the screen).








7.  Creating an SSID

The “Configure” section of CV-CUE is broken into several parts, including “WiFi”, “Alerts”, and “WIPS”.  “Alerts” is where syslog and other alert related settings are configured, and “WIPS” is where the policies are configured for the WIPS sensor.

In this lab, we will be working in the “WiFi” configuration area. Create an SSID (WPA2 PSK) with your ATD-##-PSK as the name and Wireless!123 as the passkey. 

Hover your cursor over the “Configure” menu option on the left side of the screen, then click “WiFi”.




At the top of the screen, you will see where you are in the location hierarchy. If you aren’t on “Corp”, click on the three lines (hamburger icon) next to “Locations” to expand the hierarchy and choose/highlight the “Corp” folder.  Now click the “Add SSID” button on the right hand side of the screen.

With the hierarchy menu collapsed:



Or, with the hierarchy menu expanded:




Once on the “SSID” page, configuration sub-category menu options will appear across the top of the page related to WiFi (the defaults are “Basic”, “Security”, and “Network”). You can click on these sub-category names to change configuration items related to that area of the configuration.
To make additional categories visible, click on the 3 dots next to "Network" and you can see the other categories that are available to configure (i.e. “Analytics”, “Captive Portal”, etc.).





In the “Basic” sub-category option, name the SSID ATD-##A/B-PSK  (where ## is the pod number you were assigned and A for student1/B for student 2). The “Profile Name” is used to describe the SSID and should have been auto-filled for you.



Since this is our corporate SSID, leave the “Select SSID Type” set to “Private”, but note this is where you would change it to “Guest” if needed.  Select Next at the bottom.










In the “Security” sub-category, change the association type to “WPA2”, select the “PSK” radio button, enter the passkey of “Wireless!123”, then select “Next” at the bottom of the screen.




In the “Network” configuration sub-category, we’ll leave the “VLAN ID” set to “0”, which means it will use the native VLAN. If the switchport the AP is attached to is trunked, you could change this setting to whichever VLAN you want the traffic dropped off on.

We are using “Bridged” mode in this lab. You could use “NAT” (often done for Guest) or “L2 Tunnel” / “L3 Tunnel” (as you would see for a Guest Anchor or tunneled corporate traffic).

The rest of the settings can be left at the default values.

Click the “Save & Turn SSID On” button at the bottom of the page.




Only select the “5 GHz” option on the next screen (uncheck the 2.4 GHz box if it’s checked), then click “Turn SSID On”.



After you turn on the SSID, hover your cursor over “Monitor” in the left hand side menu, and then click “WiFi”.



Now, in the menu options at the top of the page, look at the “Radios” menu option. Is the 5 GHz radio “up” and 2.4 GHz radio “down”? It may take a minute or two for the radio to become active. 



Check the “Active SSIDs” menu at the top of the screen.  Is your SSID listed?



Next, go ahead and connect your phone to the SSID (PSK is “Wireless!123”).  Navigate to the “Clients” menu at the top of the screen and you should see your device.

 






8. Troubleshooting

Make sure you are at the “A/BCorp” folder in the hierarchy, and then hover over “Troubleshoot” in the left hand menu, then click “Packet Trace”.




On the top right hand side of the window, click “Auto Packet Trace” and select the checkbox for the SSID you created earlier (ATD-##A-PSK). Click “Save” at the bottom of the window.  If you don’t see the SSID listed, make sure you are in the correct folder in the navigation pane.



      




Next, connect your device to the AP and type in the wrong PSK.  Hover your cursor over the “Monitor” menu on the left hand side of the screen, then click “WiFi”.  Now click on “Clients” at the top of the page. You should see your device trying to connect.



Select on the three dots next to the device name and select “Start Live Client Debugging”.



Select “30 Minutes” in the “Time Duration” drop down box, select the “Discard Logs” radio button, then click “Start”.



Next, try connecting the device again with the wrong PSK.  Watch and review the Live Client Debugging Log.



 
After that fails, try again with the correct PSK (“Wireless!123”).  Review the logs.

Once your device has successfully connected to the AP, click on the client name to learn more about the client (on the previous browser tab).
      


After you click on the client name you can gather additional information such as Root Cause Analysis, Client Events, Data Rate, Top Apps by Traffic, Client Traffic Volume, Application Experience, etc.

Scroll down a little to the “Client Events” section select the icon to “Switch to Table View”.




Here you can see the success/failure messages, DHCP information, and other events.
Scroll down to the failed incorrect PSK entry and select “View Packet Trace” in the “Packet Capture” column (you may have to scroll to the right).  



You should see a packet trace that you can download.  Click on “View Packet Trace”.
Select “Open” to open the file right within CV-CUE / Packets.  You will be in the “Visualize” section of Packets.

You can also download the trace and view it with WireShark if you have it installed.






Click on “Time View” and “Frames” to look through the data and at the trace to see how Arista can help you troubleshoot.

Next, click on the back arrow icon to look at the “Analyze” feature.



Explore the “Analyze” feature by clicking on the various menu options and reviewing the data.







🛑   –  When you are finished, STOP the client prevention so that you can use this test device in upcoming labs, optionally.🛑 
 

Lab guide complete

--8<-- "includes/abbreviations.md"
