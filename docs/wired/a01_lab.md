# A-01 | Provisioning a Campus Fabric

## Overview

In this lab you will be configuring the switches through CloudVision Studios. Today you will be adding a Leaf Switch to an existing Campus Fabric/POD.

!!! tip "Configuration"

    The campus, building, and access-pod objects have been added in advance. This would be a real life scenario where physical layout is pre-configured in Studios waiting for new devices.

    The switches themselves are in Zero Touch Provisioning (ZTP) mode as they would come from the factory.

--8<--
docs/snippets/topology.md
docs/snippets/login_cv.md
docs/snippets/workspace.md
--8<--

## 01 | Onboarding Device

1. Navigate to the Network Fabric Studio `Campus Farbric (L2/L3/EVPN)

    ![Campus Fabric Studo](./assets/images/a01/03_studio_campus_fabric.png)

2. Note on this first screen that there is a `Campus Fabrics` configured as `Workshop`. This is a physical representation of the campus and provides the onboarding somewhere to place the switch in the topology

    ![Campus Fabrics](./assets/images/a01/04_campus_fabric_main.png)

3. Click on the `Add Campus Devices` to launch the workflow

    ![Campus Add Devices](./assets/images/a01/05_add_campus_devices.png)

4. This workflow will take you through onboarding the device, follow the tabs below to complete the onboarding process.

    !!! tip "Select your pod"

        Remember anywhere it says `pod-##` you will replace with your assigned pod number

    === "Step 1"

        ![Campus Add Devices](./assets/images/a01/06_add_device_quick_action_step1.png)

    === "Step 2"

        ![Campus Set Device Hostname and ROle](./assets/images/a01/06_add_device_quick_action_step2.png)

    === "Step 3"

        ![Campus Add Management Network](./assets/images/a01/06_add_device_quick_action_step3.png)

    === "Step 4"
        ![Campus Review Changes](./assets/images/a01/06_add_device_quick_action_step4.png)

5. The workflow is completing several steps to onboard the device, click `Review Workspace` to explore

    ![Campus Review Workspace](./assets/images/a01/07_review_workspace.png)

6.  We should see the detailed view of what's changing

    ![Campus Add Devices](./assets/images/a01/08_review_detail.png)

7.  In the workspace note the top leaf `Summary` box, there are several studios modified:
    1. `Inventory and Topology`: Devices selected are simply added to the Campus inventory
    2. `Software Management`: As part of adding to the inventory, software can be added (for upgrade/downgrade) based on needs. While we should not have selected software, the device is part of the software managment studio now
    3. `Campus Fabric (L2/L3/EVPN)`: Devices we're added to their respective Campus Access Pod `IDF1` and will inherit configuration from that part of the campus.

8.  Let's leave this for now and navigate back to `Studios` home page and next we add some base configuration

## 03 | Applying Configuration

1. Click on `Static Configuration`

    ![Campus Static Configuration Studio](./assets/images/a01/09_static_studio.png)

2. Click on the `Add +` and select `Device`

    ![Campus Add Device](./assets/images/a01/10_static_studios.png)

3. Select your devices you recently added through the worflow

    ![Campus Device Selection](./assets/images/a01/11_add_devices.png)

4. Select a device and on the right click the `+ Configlet` and select `Configlet Library`

    ![Campus Device Selection](./assets/images/a01/12_add_config.png)

5. Here the base device configuration was generated for these devices before hand and include additional configuration for the workshop

    ![Campus Device Selection](./assets/images/a01/13_add_configlet.png)

6. Click `Review Workspace` once all devices have been given a configuration

    ![Campus Device Selection](./assets/images/a01/14_review.png)

7. You can review the configuration changes to the devices

    !!! info "ZTP Configuration"

        We are replacing the Zero Touch configuration with a combination of base configuration (generated using AVD) and more dynamic configuration using Campus Studios

    ![Campus Final Review](./assets/images/a01/15_submit_workspace.png)

8. Click `Submit Workspace` to generate the Change Control

    !!! warning "Is this pushing configuration!?"

        This is not pushing the configuration just yet, we are creating a change control workflow that can be further reviewed, changed, enhanced and pushed now or in the future.

    ![Campus Final Review](./assets/images/a01/16_submit_highlight.png)

9. Click on `View Change Control`

    ![Campus Final Review](./assets/images/a01/17_view_cc.png)

## 04 | Exectuting Change Control

1.  Within the Change Control, you can review the configurations as we just did in the workspace. This is geared towards encouraging or enforcing review of changes prior to execution.

    ![Campus Final Review](./assets/images/a01/18_cc_step1.png)

2.  When you are ready, you can review `Review and Approve` at the top right, select the `Execute Immediately` toggle, and `Approve and Execute`.

    ??? tip "I approved my own change?!"

        You can change this in settings and toggle the ability to approve your own change control. This ensures another set of eyes approves your change before that eventual change window!

    ![Campus Final Review](./assets/images/a01/19_cc_step2.png)

3.  While the change control runs, you can view logs by clicking on a stage or specific device and selecting `Logs`.

    ![Campus Final Review](./assets/images/a01/20_cc_step3.png)

4. You should get a :material-check: on the device task once complete.
5. Your new campus switch went from out of the box ZTP mode to a configured member of the Campus fabric. We're going to explore further changes to this switch in the next lab!

--8<-- "includes/abbreviations.md"
