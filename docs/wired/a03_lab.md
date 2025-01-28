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

1. Once the workspace is created, open the existing `Campus Fabric (L2/L3/EVPN)` studio.

    ![Campus Studio](./assets/images/a03/00_ops.png)

    1. Validate that the `Device Selection` still applies to `All Devices`

    2. `Within the Campus Services (Non-VXLAN)` select the `Campus-Pod: Workshop` arrow :material-greater-than: on the right

    ![Campus Studio](./assets/images/a03/01_ops.png)

2. Add new VLAN and add to the `Home Office` Campus POD.
    1. Within the `Campus: Workshop` section, click the `Campus-Pod: Home Office` name or the right arrow :material-greater-than:

    ![Campus Studio](./assets/images/a03/02_ops.png)

    2. Click the `+ Add VLAN` button

    ![Campus Studio](./assets/images/a03/03_ops.png)

    3. Once an entry is added for `VLAN 2##`, click the right arrow :material-greater-than:

    ???+ example "Wireless-Access-Point"

        | Student | VLAN |
        | ------- | ---- |
        | 1       | 201  |
        | 2       | 202  |

    4. Customize the new VLAN by giving it a `Name`
    5. Add the VLAN to the Access-Pod by clicking `+ Add Pod` and selecting `IDF1`

    ![Campus Studio](./assets/images/a03/04_ops.png)
    
    6. You can skip entries for all of the remaining section.

3. Review and Submit Workspace

    1. Click `Review Workspace` to submit the staged changes.

    2. Notice that the Studio is adding the VLAN to all three devices within the Pod.

        !!! tip "Pruning VLANS"

            Outside of this lab topology, when you add vlans to a Layer 2 leaf like this, Studios will generate the necessary configuration to trunk the new VLAN to the spines or upstream MLAG pair when using LSS.

        ??? warning "No changes?!"

            If you are not seeing any proposed changes, make sure you selected an `Access-Pod` within the VLAN configuration. (See step 2e)

    3. Once you review the changes, click `Submit Workspace`

    4. Click View `Change Control`

    5. Review the Change Control and select `Review and Approve`

    6. Toggle the `Execute Immediately` button and select `Approve and Execute`

4. Verify the VLAN has been added to the device configuration by using the Devices Comparison function.

    1. Click Devices then Comparison menu, and select a Time Comparison

    2. Select Time Comparison and under Select device… choose a device from the list, such as leaf1c

    3. Select a time period, for example 30 minutes ago and click the Compare button

    4. The first screen presented shows the overview is unchanged

    5. Select the Configuration section

    !!! note "Configuration Updated"

        Notice that the configuration has been updated. Feel free to explore other comparisons by feature. Since this VLAN was localized only, no new IP routes or MAC addresses should be learned.

5.  Lab section completed! In the next lab section you will see how to roll back a previous change control

## 02 | Rollback a Change Control

A common operational task is to roll back a specific configuration and restore back to previous state. You may need to do this for all devices affected by a change, or only a subset of devices under troubleshooting.

CloudVision change controls allow this flexibility for granular change management per device and fleet-wide

1. Let’s roll back the change control we used to add a VLAN via Studios.
2. First go to Provisioning then Change Control menu. Select the change control corresponding to your VLAN addition
3. Click the Rollback button
4. In the next screen, select the top list check mark to select all the devices and click Create Rollback Change Control
5. Verify the Configuration Changes section by clicking “View Diff”  Once you have reviewed the change, click the Review and Approve button
6. You’ll be presented with one more opportunity to review the changes. Select Execute Immediately if not already toggled on and Approve and Execute
7. Monitor the change control for completion to ensure the added VLAN is cleaned up on all three switches.
8.  You have now successfully added a VLAN through Studios and then rolled back that change across all switches.

## 03 | Dashboards (Built-in and Custom)

Dashboards are an important way to visualize commonly requested information. This lab section shows you how to navigate the built-in dashboards and customize your own.

1. Built in Dashboard: “Campus Health Overview”
      1. Open the Dashboards Section to arrive at the Dashboards landing page.
      2. Select the built-in Campus Health Overview dashboard
      3. You’ll be presented with a curated selection of common campus related monitoring tools
      4. *Note: We will explore the Quick Actions interactive functions of this dashboard in another lab section. 
      5. Feel free to explore the Campus Health dashboard briefly and then navigate back to the Dashboards landing page by selecting Dashboards in the upper left.
   
2. Built in Dashboard: “Device Health”
      1. Next, Select the Device Health dashboard
      2.  By default, this dashboard selects all devices. Change the dashboard to select only leaf1-c by changing from “device: *” to device:  match single device
      3.  Once you’ve selected an individual device, the dashboard will filter to results for only this device.
      4.  Navigate back to the Dashboards landing page by clicking Dashboards in upper left.
3. Next, let’s add a new customized dashboard.
      1.  Click the New Dashboard button.
      2. Provide a useful name for the Dashboard, such as “Pod-##” Security and Performance”
      3. Next, let’s add a combination of visualizations which have both security and performance related metrics.First, click the drop down on the upper right and change from Metrics to Summaries
      4. Within the Summaries list, Click on, or drag the Compliance widget into the dashboard canvas 
      5. Within the Compliance tile now added to your dashboard, select the Click to Configure button
      6. Within the right side menu bar, within Compliance Metric select Image Compliance
      7. Dismiss the customization menu by clicking the X in upper right corner
      8.  Next, change the Summaries menu back to Metrics 
      9.  Within the Metrics menu, click Horizon Graph on the right side to add this tile to the canvas, then click the three-dots … menu and click Configure to customize the Horizon Graph.
      10. Within View Type, select Single Metric for Multiple Sources. Select Metric CPU Utilization.
      11. Dismiss the customization menu with the X button in upper right
      
        !!! tip "Drag the tiles"

            You can drag the tiles around by the respective menu bars and resize each tile using the lower right corner handles.

      12. Save and completed the dashboard customization by clicking the Done button in upper menu bar
4. Exporting and Importing Dashboards Sharing your Dashboard across Cloudvision systems!
      1. Export a dashboard
      2. To share your dashboard -  in the upper right corner, select the three-dots … menu and click Export as JSON
      3. Click Download in the lower right corner. This will download a file you can share with others if they wish to use your customized dashboard.
      4. Import a dashboard
      5. Navigate back to the Dashboards landing page to view the import button
      6.  Click on Import
      7.  The import function is shown as reference only, it is not required to upload any file here. Alternatively you can use this function to share a dashboard customized with your lab partner. If you wish to import, click Select File and select the file you download in the previous step.
5.  Lab section completed!

## 04 | Events

In this section, we will explore the Events stream and the tools and filters to help process and manage critical errors versus informational data.

1. First Open the Events section from the menu bar:
2. Next, select a different timeframe for the summary visualization, click the current time selection and change this to 1-hour
    1. You can also toggle between a bar graph and event count display
3. Focusing on the Event List next, Note the Export button to download the current Event list as CSV. Notice you can download All Events or only Selected:
4. Next, select the Gear icon to toggle Event List Roll Up. This setting combines repeated events into groups. Toggle this On and Off, watch the effect this has on the list of Events. 
5. Next, utilizing the Event Filters on the right pane is important to reduce the amount of data displayed. 
    1. Toggle Off the Warning and Info event Severity. Leave Critical and Error events selected.
    1. In the Type field, enter the string “Unexpected Link Shutdown” and any other interesting event types you are looking for, such as “Device clock out of Sync”
6.  Acknowledge and Unacknowledging events
    1. To acknowledge from the filtered event list, select specific events and Acknowledge them. 
    2. Adding a note is optional, select the Acknowledge button to mark these selected events.
    3. Acknowledged events are not deleted from the event list, only flagged as acknowledged and can be referenced by changing the filtered Acknowledgement State. Click Acknowledgement State and select Acknowledged
    4. Un-acknowledging an event can be done in the same way, click the box to the left of the Acknowledged event, and click Unacknowledge at the top of the event list.
7.  Events and filtering lab section complete!

The next section will show you how to customize the notifications (e.g. email, chat, SNMP, Syslog, etc) that the events generate. 

## 05 | Customize Notifications

In this lab, you will configure CloudVision to send an email alert to an email address using the built-in “SendGrid” email service.

1. Configure “SendGrid” email service.
    1. After logging in to CloudVision, click on the “Events” menu option.
    2. Click on the “Notifications” button in the top right of the screen. 
    3. Check the system status for the “Config back-end” and “Relay back-end”. *Note: Before receivers and notifications are configured, the status will be “Unknown”.
    4. Now, configure the SendGrid receiver by clicking on “Receivers” in the menu, then click on the “Add Receiver” button.	
    5. Name the receiver “SendGrid for Campus ATD”, then click the “Add Configuration” button and select “SendGrid” from the menu options.
    6. Type in a valid email address that you can receive emails at during this lab and check the “Send notification when events are resolved” checkbox.  Click the “Save” button in the upper right hand side of the screen to save your new receiver.
    7. Once you are happy with receiver’s configuration, click the Save button at the top of the screen
2.  Next, configure a “Rule” to use the new receiver.  Click on the “Rules” menu option, then click “Add Rule”
    1. Configure “Rule Conditions” for this rule.  Click on the “+ Device” button, then choose your leaf1c switch from the “Device” drop down box.
    2. Now click on the “+ Event Type” button. 
    3. Add “Event Types” by choosing them from the drop down box as shown in the image below:
    4. Select all of the severity options by clicking on the “+ Severity” button and choosing the options from the drop down box.
    5. Next, choose your new “SendGrid for Campus ATD” receiver from the “Receiver” dropdown box, select the “Continue Checking Rules” box, and save your changes by clicking on the “Save” button.
    6. Make sure to save your changes in this screen with the Save button along the top of your screen.
3.  Now test your new receiver and rule.  
    1. Click on the “Status” menu option.  Configure the “Test Notification Sender” by changing the “Event Type” to be “Device Stopped Streaming” and selecting your leaf1c  from the “Device” drop down box.  Click the “Send Test Notification” button.
    2. After a minute or two, you should receive the email alert at the email address you configured in the Receiver
    3. Congratulations, you’ve completed the “Event Notification Lab” !

!!! tip "🎉 CONGRATS! You have completed the labs! 🎉"

--8<-- "includes/abbreviations.md"
