# A-01 | Explore EOS

## Overview

In this lab you will be exploring how to login to an Arista switch. All switches, regardless of their role (data center, campus, wan, etc), are running Arista's Extensible Operating System (EOS). We will also explore MLAG, the configuration to enable, and how to troubleshoot!

Let's dive into the look and feel of EOS, should feel familiar, but totally different!

## Hardware Commands

Let's login into the spine switch

1. Login to the spine using the address below and your supplied tacacs account.

    ```yaml
    ssh student##@192.168.3.11
    ```

2. First thing, let's validate you are on the spine switch

    ```yaml
    show version
    ```

    ```yaml title="Example Output" hl_lines="1 3 7-8 14"
    Arista CCS-720XP-48ZC2-F #(1)!
    Hardware version: 10.50
    Serial number: JPE19181543 #(2)!
    Hardware MAC address: fcbd.670f.3623
    System MAC address: fcbd.670f.3623

    Software image version: 4.33.1.1F #(3)!
    Architecture: i686 #(4)!
    Internal build version: 4.33.1.1F-40155285.43311F
    Internal build ID: d5051ff8-6d2a-428e-8c9a-b85369e7b27d
    Image format version: 3.0
    Image optimization: Strata-4GB

    Uptime: 3 weeks, 2 days, 0 hours and 23 minutes #(5)!
    Total memory: 3952948 kB
    Free memory: 2261864 kB
    ```

    1. The full switch model
    2. The serial number of the switch
    3. Current EOS image running
    4. This EOS software is a 32-bit version, Arista EOS is also provided in a 64-bit version
    5. The current uptime

3. That gave us some high level details, let's look at it a little deeper

    ```yaml
    show inventory
    ```

    ```yaml title="Example Output" hl_lines="4 8 14 16 38-43"
    System information
        Model                    Description
        ------------------------ ----------------------------------------------------
        CCS-720XP-48ZC2          48 MGig Base-T PoE, 4-port SFP28 & 2 QSFP28 Switch #(1)!

        HW Version  Serial Number  Mfg Date   Epoch
        ----------- -------------- ---------- -----
        10.50       JPE19181543    2019-05-26 01.00 #(2)!

    System has 2 power supply slots
        Slot Model            Serial Number
        ---- ---------------- ----------------
        1    Unknown          Unknown
        2    PWR-1021-AC-RED  FFJT94N00BG #(3)!

        System has 3 fan modules #(4)!
        Module  Number of Fans  Model            Serial Number
        ------- --------------- ---------------- ----------------
        1       1               FAN-7000-F       N/A
        2       1               FAN-7000-F       N/A
        3       1               FAN-7000-F       N/A

    System has 61 ports
        Type               Count
        ------------------ ----
        Management         1
        Switched           56
        SwitchedBootstrap  4

    System has 54 switched transceiver slots
        Port Manufacturer     Model            Serial Number    Rev
        ---- ---------------- ---------------- ---------------- ----
        1    Arista Networks  CCS-720XP-48ZC2
        2    Arista Networks  CCS-720XP-48ZC2
        3    Arista Networks  CCS-720XP-48ZC2
        4    Arista Networks  CCS-720XP-48ZC2
        ...
        49   Not Present #(5)!
        50   Not Present
        51   Not Present
        52   Not Present
        53   Not Present
        54   Not Present

    System has 1 storage device
        Mount      Type Model          Serial Number Rev Size (GB)
        ---------- ---- -------------- ------------- --- ---------
        /mnt/flash eMMC Toshiba 008G70 8480b1cf      0.0 8
    ```

    1. More information about this switch platform capabilities
    2. You can see when this switch was manufactured and hardware versioning
    3. Power supply details, like model and serial number
    4. If you have fan modules, similar detail to that of power supplies
    5. If there were optics installed, each optics serial number and model would appear here

4. Let's examine the environmental status of our hardware, there is a lot of information here!

    ```yaml
    show inventory
    ```

    ```yaml title="Example Output"
    System temperature status is: Ok
    Action on overheat: shutdown
    Recovery mode when power-cycle upon overheat: not applicable
    Restrict recovery when ambient temperature is at or above: not applicable
                                                                    Alert  Critical
                                                Temp    Setpoint  Limit     Limit
    Sensor  Description                             (C)         (C)    (C)       (C)
    ------- ----------------------------------- ------- ----------- ------ ---------
    1       Cpu temp sensor                        53.8   (84) 85.0     90        95
    2       Switch card temp sensor                41.0   (60) 62.2     75        85
    3       Outlet temp sensor                     35.8   (55) 57.2     75        85
    4       Inlet temp sensor                      30.6   (55) 57.2     75        85
    5       SwitchAsic bottom center sensor        36.6   (80) 82.2    100       110
    6       SwitchAsic bottom right sensor         37.6   (80) 82.2    100       110
    7       SwitchAsic top right sensor            37.1   (80) 82.2    100       110
    8       SwitchAsic top left sensor             38.7   (80) 82.2    100       110
    9       SwitchAsic top center sensor           38.7   (80) 82.2    100       110
    10      SwitchAsic top center inner sensor     38.7   (80) 82.2    100       110
    11      SwitchAsic bottom right center sens    35.5   (80) 82.2    100       110
    12      Bcm54998Es Chip0                       39.0   (80) 82.2    100       110
    13      Bcm54998Es Chip1                       34.0   (80) 82.2    100       110
    14      Bcm54998Es Chip2                       34.0   (80) 82.2    100       110
    15      Bcm54998Es Chip3                       35.0   (80) 82.2    100       110
    16      Bcm54998Es Chip4                       38.0   (80) 82.2    100       110
    17      Bcm54998S Chip5                        38.0   (80) 82.2    100       110

    PowerSupply 2:
                                                                    Alert  Critical
                                                Temp    Setpoint  Limit     Limit
    Sensor  Description                             (C)         (C)    (C)       (C)
    ------- ----------------------------------- ------- ----------- ------ ---------
    1       Inlet                                  29.1   (55) 56.0     61        65
    2       Secondary hotspot                      33.8   (70) 69.0     74        78
    3       Primary hotspot                        33.0   (60) 62.2     68        73

    System cooling status is: Ok
    Ambient temperature: 30C
    Airflow: port-side intake
    Number of cooling zones is: 1
                        Config Actual                  Speed               Stable
    Fan            Status  Speed  Speed           Uptime Stability           Uptime
    -------------- ------ ------ ------ ---------------- --------- ----------------
    1/1            Ok        39%    39% 23 days, 0:29:08 Stable    23 days, 0:28:03
    2/1            Ok        39%    40% 23 days, 0:29:08 Stable    23 days, 0:28:08
    3/1            Ok        39%    39% 23 days, 0:29:08 Stable    23 days, 0:28:08
    PowerSupply2/1 Ok        30%    30% 23 days, 0:30:43 Stable    23 days, 0:28:07

    Power                            Input  Output  Output
    Supply Model           Capacity Current Current  Power Status            Uptime
    ------ --------------- -------- ------- ------- ------ ------- ----------------
    1                           N/A     N/A     N/A    N/A Unknown          Offline
    2      PWR-1021-AC-RED    1050W   0.65A   1.15A  63.6W Ok      23 days, 0:30:43
    Total  --                   N/A      --      --    N/A --                    --
    ```

5. Let's take a look at the interfaces and what's connected to our device
6. We can validate LLDP neighbors and show detail

    ```yaml
    show lldp neighbors
    ```

    ```yaml title="Example Output"
    Last table change time   : 8 days, 21:04:13 ago
    Number of table inserts  : 106
    Number of table deletes  : 102
    Number of table drops    : 0
    Number of table age-outs : 2

    Port          Neighbor Device ID       Neighbor Port ID    TTL
    ---------- ------------------------ ---------------------- ---
    Et1           POD01-LEAF1B             Ethernet1           120
    Et2           POD01-LEAF1A             Ethernet1           120
    Et48          USW-24-PoE               Port 19             120
    Ma1           USW-24-PoE               Port 23             120
    ```

## MLAG

Arista's Multi-Chassis Link Aggregation (MLAG) is a technology that allows two physical switches to act as a single logical switch. By syncing the control plane without the need for proprietary cabling or protocols, it provides an active-active, non-blocking redundancy between multiple pairs of switches.

Let's explore the configuration and how to troubleshoot

1. From the switch run the `show mlag` command to validate the high level state

    ```yaml
    show mlag
    ```

    ```yaml title="Example Output"
    MLAG Configuration:
    domain-id                          :                MLAG
    local-interface                    :            Vlan4094
    peer-address                       :         169.254.0.0
    peer-link                          :      Port-Channel11
    hb-peer-address                    :            10.1.1.4
    peer-config                        :          consistent

    MLAG Status:
    state                              :              Active
    negotiation status                 :           Connected
    peer-link status                   :                  Up
    local-int status                   :                  Up
    system-id                          :   2e:dd:e9:fe:b9:31
    dual-primary detection             :          Configured
    dual-primary interface errdisabled :               False

    MLAG Ports:
    Disabled                           :                   0
    Configured                         :                   0
    Inactive                           :                   0
    Active-partial                     :                   0
    Active-full                        :                   0
    ```

2. You can also dive deeper in using the `show mlag detail`

    ```yaml
    show mlag detail
    ```

    ```yaml title="Example Output"
    ...
    MLAG Detailed Status:
    State                                :              secondary
    Peer State                           :                primary
    State changes                        :                      2
    Last state change time               :   8 days, 23:05:07 ago
    Hardware ready                       :                   True
    Failover                             :                  False
    Failover Cause(s)                    :                Unknown
    Last failover change time            :                  never
    Secondary from failover              :                  False
    Peer MAC address                     :      2c:dd:e9:fe:b9:31
    Peer MAC routing supported           :                   True
    Reload delay                         :            300 seconds
    Non-MLAG reload delay                :            330 seconds
    Ports errdisabled                    :                  False
    Lacp standby                         :                  False
    Configured heartbeat interval        :                4000 ms
    Effective heartbeat interval         :                4000 ms
    Heartbeat timeout                    :               60000 ms
    Last heartbeat timeout               :                  never
    Heartbeat timeouts since reboot      :                      0
    UDP heartbeat alive                  :                   True
    Heartbeats sent/received             :          387089/387038
    Peer monotonic clock offset          :       0.186408 seconds
    Agent should be running              :                   True
    P2p mount state changes              :                      1
    Fast MAC redirection enabled         :                   True
    Interface activation interlock       :           unconfigured
    Dual-primary detection delay         :                      5
    Dual-primary action                  :         errdisable-all
    Dual-primary recovery delay          :                      0
    Dual-primary non-mlag recovery delay :                      0
    ```

3. Let's look at the configuration to enable MLAG, first run the command to show the block of mlag configuration

    ```yaml
    show running-config section mlag configuration
    ```

    ```yaml title="Example Output"
    mlag configuration
        domain-id MLAG #(1)!
        local-interface Vlan4094 #(2)!
        peer-address 169.254.0.0 #(3)!
        peer-address heartbeat 10.1.1.4 #(4)!
        peer-link Port-Channel11 #(5)!
        dual-primary detection delay 5 action errdisable all-interfaces
        reload-delay mlag 300
        reload-delay non-mlag 330
    ```

    1. MLAG domain is locally significant to the MLAG pair of switches, this can be any descriptor. Whether it's simply `MLAG` like shown or the name of say a pod: `POD01`
    2. The local interface used to peer to the MLAG neighbor, this will always be an SVI
    3. The MLAG neighbors address that resides within the `local-interface` subnet
    4. This is an optional configuration called [Dual Primary Detection](https://www.arista.com/en/support/toi/eos-4-23-1f/14406-mlag-dual-primary-detection-and-release-updates), you can read more on this topic.
    5. The peer link is the layer 2 port-channel used to trunk our MLAG vlans, we'll explore below how that's configured.

4. Let's take a closer look at the peer link itself

    ```yaml
    show run int Port-Channel11
    show port-channel 11 detailed
    ```

    ```yaml title="Example Output" hl_lines="4 14-15"
    !
    interface Port-Channel11
        description MLAG_PEER_pod01-leaf1a_Po11
        switchport mode trunk
        switchport trunk group MLAG
    !
    Port Channel Port-Channel11 (Fallback State: Unconfigured):
    Minimum links: unconfigured
    Minimum speed: unconfigured
    Current weight/Max weight: 2/8
        Active Ports:
            Port             Time Became Active       Protocol       Mode         Weight    State
            ---------------- ------------------------ -------------- ------------ ------------ -----
            Ethernet11       2/9/25 11:19:32          LACP           Active         1       Rx,Tx
            Ethernet12       2/9/25 11:19:32          LACP           Active         1       Rx,Tx
    ```

5. The port-channel is using a `trunk group`, lets look at that trunk group

    !!! tip "Linux Sub-system"

        On top of the typical `includes`, `section`, `begin`, etc we commonly use to filter output. You also have access to many of the linux sub-system commands like `grep`, `sed`, `awk`, etc to filter and manipulate the output.

    ```yaml
    show vlan trunk group | grep -E "MLAG|Groups|-"
    ```

    ```yaml title="Example Output" hl_lines="3"
    VLAN     Trunk Groups
    ----     ----------------------------------------------------------------------
    4094     MLAG
    ```

6. Note that `vlan 4094` is a part of that trunk group, trunk groups are used to ensure those vlans assigned to trunk group `MLAG` are pruned from all interfaces except those explicitly configured. In this case `Port-Channel11` is assigned the trunk group, therefore it's the only interface forwarding `Vlan 4094`.

7. Let's look at the peering SVI `Vlan4094`

    ```yaml
    show running-config interfaces vlan 4094
    ```

    ```yaml title="Example Output: SPINE01" hl_lines="4-5"
    interface Vlan4094
        description MLAG_PEER
        mtu 9200
        no autostate #(1)!
        ip address 169.254.0.0/31 #(2)!
    ```

    1. We disable autostate to force the VLAN to be active
    2. This peering address is only locally significant, it's common to use an APIPA IP address range (/31) that's repeated across all MLAG pairs. The neighbor address is used in the mlag configuration to peer over the trunk.

8. In the previous `show mlag` section we got a brief overview of status. During troubleshooting steps, there is a built in command to ensure MLAG configuration parity between the two devices. Run the following command to validate configuration matches between the two devices

    ```yaml
    show mlag config-sanity
    ```

    ```yaml title="Example Output"
    No global configuration inconsistencies found.

    No per interface configuration inconsistencies found.
    ```

9. Lastly, if we do detect issues or want to verify the MLAG interfaces upstream/downstream are `up/up` we can validate

    ```yaml
    show mlag interfaces
    ```

    ```yaml title="Example Output"
    TBD
    ```

10. That's it for this lab, you should have a bit better understanding of how MLAG is configured

!!! tip "🎉 CONGRATS! You have completed this lab! 🎉"

    [:material-login: LET'S GO TO THE NEXT LAB!](./a02_lab.md){ .md-button .md-button--primary }

--8<-- "includes/abbreviations.md"
