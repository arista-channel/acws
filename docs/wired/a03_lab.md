# A-03 | Operations, Dashboards, and Events

## Overview

In this lab we will explore some of the features of CloudVision to manage and operate your campus network.

--8<--
docs/snippets/topology.md
docs/login_cv_md
docs/snippets/workspace.md
--8<--

## 01 | Adding a VLAN

Adding a VLAN is a common provisioning task. Let’s use the existing Campus Fabric Studio to add an incremental configuration (add a VLAN). This VLAN will be specific to your pod and not routable outside.

1. Select `Provisioning`, then `Studios`.

2. Create a new Workspace and name it similar to  `<add-vlan2##>` where ## is your pod number. 

    ??? examples "Pod VLAN Examples"

         ```
         Pod 1    = VLAN 201
         Pod 2    = VLAN 202
         Pod 2    = VLAN 203
         …   
         Pod 12   = VLAN 212
         ```

3. Once the workspace is created, open the existing `Campus Fabric (L2/L3/EVPN)` studio.

   1. Vvalidate that the `Device Selection` still applies to `All Devices`

   2. `Within the Campus Services (Non-VXLAN)` select the `Campus-Pod: Workshop` expand arrow button on the right

   3. Add new VLAN and add to the `IT-Bldg` Campus POD.

   4. Within the `Campus: Workshop` section, click the `Campus-Pod: IT-Bldg` name or the right arrow Expand button

   5. Click the Add VLAN button

   6. Once an entry is added for `VLAN 2##`, click the right arrow Expand button

   7. Customize the new VLAN by giving it a name 

   8. Add the VLAN to the Access-Pod by clicking Add Pod and selecting IDF1

   9. You can skip entries for all of the remaining section.

4. Review and Submit Workspace

   1. Click `Review Workspace` to submit the staged changes.

   2. Notice that the Studio is adding the VLAN to all three devices within the Pod.

   3. Once you review the changes, click Submit Workspace

   4. Click View Change Control

   5. Review the Change Control and select “Review and Approve”

   6. Toggle the Execute Immediately button and select Approve and Execute

5. Verify the VLAN has been added to the device configuration by using the Devices Comparison function.

   1. Click Devices then Comparison menu, and select a Time Comparison

   2. Select Time Comparison and under Select device… choose a device from the list, such as leaf1c

   3. Select a time period, for example 30 minutes ago and click the Compare button

   4. The first screen presented shows the overview is unchanged

   5. Select the Configuration section

    !!! note "Configuration Updated"

        Notice that the configuration has been updated. Feel free to explore other comparisons by feature. Since this VLAN was localized only, no new IP routes or MAC addresses should be learned.

6. Lab section completed! In the next lab section you will see how to roll back a previous change control

## 02 | Rollback a Change Control

1. A common operational task is to roll back a specific configuration and restore back to previous state. You may need to do this for all devices affected by a change, or only a subset of devices under troubleshooting.
2. CloudVision change controls allow this flexibility for granular change management per device and fleet-wide
3. Let’s roll back the change control we used to add a VLAN via Studios.
4. First go to Provisioning then Change Control menu. Select the change control corresponding to your VLAN addition
5. Click the Rollback button
6. In the next screen, select the top list check mark to select all the devices and click Create Rollback Change Control
7. Verify the Configuration Changes section by clicking “View Diff”  Once you have reviewed the change, click the Review and Approve button
8. You’ll be presented with one more opportunity to review the changes. Select Execute Immediately if not already toggled on and Approve and Execute
9. Monitor the change control for completion to ensure the added VLAN is cleaned up on all three switches.
10. You have now successfully added a VLAN through Studios and then rolled back that change across all switches.
11. Lab section complete!

## 03 | Dashboards (Built-in and Custom)

1. Dashboards are an important way to visualize commonly requested information. This lab section shows you how to navigate the built-in dashboards and customize your own.
2. Built in Dashboard: “Campus Health Overview”
3. Open the Dashboards Section to arrive at the Dashboards landing page.
4. Select the built-in Campus Health Overview dashboard
5. You’ll be presented with a curated selection of common campus related monitoring tools
6. *Note: We will explore the Quick Actions interactive functions of this dashboard in another lab section. 
7. Feel free to explore the Campus Health dashboard briefly and then navigate back to the Dashboards landing page by selecting Dashboards in the upper left.
8. Built in Dashboard: “Device Health”
9. Next, Select the Device Health dashboard
10. By default, this dashboard selects all devices. Change the dashboard to select only leaf1-c by changing from “device: *” to device:  match single device
11. \
12. Once you’ve selected an individual device, the dashboard will filter to results for only this device.
13. Navigate back to the Dashboards landing page by clicking Dashboards in upper left.
14. Next, let’s add a new customized dashboard.
15. Click the New Dashboard button.
16. Provide a useful name for the Dashboard, such as “Pod-##” Security and Performance”
17. Next, let’s add a combination of visualizations which have both security and performance related metrics.First, click the drop down on the upper right and change from Metrics to Summaries
18. Within the Summaries list, Click on, or drag the Compliance widget into the dashboard canvas 
19. Within the Compliance tile now added to your dashboard, select the Click to Configure button
20. Within the right side menu bar, within Compliance Metric select Image Compliance
21. Dismiss the customization menu by clicking the X in upper right corner
22. Next, change the Summaries menu back to Metrics 
23. Within the Metrics menu, click Horizon Graph on the right side to add this tile to the canvas, then click the three-dots … menu and click Configure to customize the Horizon Graph.
24. Within View Type, select Single Metric for Multiple Sources. Select Metric CPU Utilization.
25. Dismiss the customization menu with the X button in upper right
26. *Note: You can drag the tiles around by the respective menu bars and resize each tile using the lower right corner handles.
27. Save and completed the dashboard customization by clicking the Done button in upper menu bar
28. Exporting and Importing Dashboards Sharing your Dashboard across Cloudvision systems!
29. Export a dashboard
30. To share your dashboard -  in the upper right corner, select the three-dots … menu and click Export as JSON
31. Click Download in the lower right corner. This will download a file you can share with others if they wish to use your customized dashboard.
32. Import a dashboard
33. Navigate back to the Dashboards landing page to view the import button
34. Click on Import
35. The import function is shown as reference only, it is not required to upload any file here. Alternatively you can use this function to share a dashboard customized with your lab partner. If you wish to import, click Select File and select the file you download in the previous step.
36. Lab section completed!

## 04 | Events

1. In this section, we will explore the Events stream and the tools and filters to help process and manage critical errors versus informational data.
2. First Open the Events section from the menu bar:
3. Next, select a different timeframe for the summary visualization, click the current time selection and change this to 1-hour
4. You can also toggle between a bar graph and event count display
5. Focusing on the Event List next, Note the Export button to download the current Event list as CSV. Notice you can download All Events or only Selected:
6. Next, select the Gear icon to toggle Event List Roll Up. This setting combines repeated events into groups. Toggle this On and Off, watch the effect this has on the list of Events. 
7. Next, utilizing the Event Filters on the right pane is important to reduce the amount of data displayed. 
8. Toggle Off the Warning and Info event Severity. Leave Critical and Error events selected.
9. In the Type field, enter the string “Unexpected Link Shutdown” and any other interesting event types you are looking for, such as “Device clock out of Sync”
10. Acknowledge and Unacknowledging events
11. To acknowledge from the filtered event list, select specific events and Acknowledge them. 
12. Adding a note is optional, select the Acknowledge button to mark these selected events.
13. Acknowledged events are not deleted from the event list, only flagged as acknowledged and can be referenced by changing the filtered Acknowledgement State. Click Acknowledgement State and select Acknowledged
14. Un-acknowledging an event can be done in the same way, click the box to the left of the Acknowledged event, and click Unacknowledge at the top of the event list.
15. Events and filtering lab section complete!
16. The next section will show you how to customize the notifications (e.g. email, chat, SNMP, Syslog, etc) that the events generate. 

## 05 | Customize Notifications

1. In this lab, you will configure CloudVision to send an email alert to an email address using the built-in “SendGrid” email service.
2. Configure “SendGrid” email service.
3. After logging in to CloudVision, click on the “Events” menu option.
4. Click on the “Notifications” button in the top right of the screen. 
5. Check the system status for the “Config back-end” and “Relay back-end”. *Note: Before receivers and notifications are configured, the status will be “Unknown”.
6. Now, configure the SendGrid receiver by clicking on “Receivers” in the menu, then click on the “Add Receiver” button.	
7. Name the receiver “SendGrid for Campus ATD”, then click the “Add Configuration” button and select “SendGrid” from the menu options.
8. Type in a valid email address that you can receive emails at during this lab and check the “Send notification when events are resolved” checkbox.  Click the “Save” button in the upper right hand side of the screen to save your new receiver.
9. Once you are happy with receiver’s configuration, click the Save button at the top of the screen
10. Next, configure a “Rule” to use the new receiver.  Click on the “Rules” menu option, then click “Add Rule”
11. Configure “Rule Conditions” for this rule.  Click on the “+ Device” button, then choose your leaf1c switch from the “Device” drop down box.
12. Now click on the “+ Event Type” button. 
13. Add “Event Types” by choosing them from the drop down box as shown in the image below:
14. Select all of the severity options by clicking on the “+ Severity” button and choosing the options from the drop down box.
15. Next, choose your new “SendGrid for Campus ATD” receiver from the “Receiver” dropdown box, select the “Continue Checking Rules” box, and save your changes by clicking on the “Save” button.
16. Make sure to save your changes in this screen with the Save button along the top of your screen.
17. Now test your new receiver and rule.  
18. Click on the “Status” menu option.  Configure the “Test Notification Sender” by changing the “Event Type” to be “Device Stopped Streaming” and selecting your leaf1c  from the “Device” drop down box.  Click the “Send Test Notification” button.
19. After a minute or two, you should receive the email alert at the email address you configured in the Receiver.
20. Congratulations, you’ve completed the “Event Notification Lab” !

!!! tip "🎉 CONGRATS! You have completed the labs! 🎉"

--8<-- "includes/abbreviations.md"
