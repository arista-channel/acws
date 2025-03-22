# A-01 | Explore EOS

## Overview

In this lab you will be exploring how to login to an Arista switch. All switches, regardless of their role (data center, campus, wan, etc), are running Arista's Extensible Operating System (EOS). We will also explore MLAG, the configuration to enable, and how to troubleshoot!

Let's dive into the look and feel of EOS, should feel familiar, but totally different!

## Hardware Commands

Let's login into the spine switch

1. Login to the spine using the address below and the username `arista`, password `Arista!123`.

    ```yaml
    # Student 1
    ssh arista@10.1.100.2

    # Student 2
    ssh arista@10.1.100.3
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

    Arista CCS-722XPM-48ZY8-F
    Hardware version: 11.01
    Serial number: HBG23270736
    Hardware MAC address: ac3d.9450.afc6
    System MAC address: ac3d.9450.afc6

    Software image version: 4.31.5M
    Architecture: i686
    Internal build version: 4.31.5M-38783123.4315M
    Internal build ID: a514fb70-598b-4084-975c-4f5978421b10
    Image format version: 3.0
    Image optimization: Strata-4GB

    Uptime: 4 hours and 58 minutes
    Total memory: 3952960 kB
    Free memory: 2054376 kB
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
        CCS-722XPM-48ZY8         48 2.5GBase-T PoE & 8-port SFP28 MacSec Switch

        HW Version  Serial Number  Mfg Date   Epoch
        ----------- -------------- ---------- -----
        11.01       HBG23270736    2023-07-14 01.00

    System has 2 power supply slots
        Slot Model            Serial Number
        ---- ---------------- ----------------
        1    PWR-1021-AC-RED  GGJT36P13J0
        2    Not Inserted

    System has 3 fan modules
        Module  Number of Fans  Model            Serial Number
        ------- --------------- ---------------- ----------------
        1       1               FAN-7000-F       N/A
        2       1               FAN-7000-F       N/A
        3       1               FAN-7000-F       N/A

    System has 65 ports
        Type               Count
        ------------------ ----
        Management         1
        Switched           52
        SwitchedBootstrap  4
        Fabric             8

    System has 56 switched transceiver slots
        Port Manufacturer     Model            Serial Number    Rev
        ---- ---------------- ---------------- ---------------- ----
        1    Arista Networks  CCS-722XPM-48ZY8
        2    Arista Networks  CCS-722XPM-48ZY8
        ...
        49   Arista Networks  SFP-10G-SR       ACW1710002F0     20
        50   Not Present
        51   Arista Networks  SFP-10G-SR       XTH16080010E     0002
        52   Not Present
        53   Not Present
        54   Not Present
        55   Not Present
        56   Not Present

    System has 1 storage device
        Mount      Type Model                Serial Number Rev Size (GB)
        ---------- ---- -------------------- ------------- --- ---------
        /mnt/flash eMMC Smart Modular 16GP1A 801f4198      1.0 8
    ```

    1. More information about this switch platform capabilities
    2. You can see when this switch was manufactured and hardware versioning
    3. Power supply details, like model and serial number
    4. If you have fan modules, similar detail to that of power supplies
    5. If there were optics installed, each optics serial number and model would appear here

4. Let's examine the environmental status of our hardware, there is a lot of information here!

    ```yaml
    show system environment all
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
    1       Cpu temp sensor                        49.2   (84) 85.0     90        95
    2       Inlet temp sensor                      28.0   (40) 41.2     50        60
    3       Outlet temp sensor                     36.0   (50) 51.2     65        75
    4       LHS TD3X2 temp sensor                  37.4   (50) 51.2     70        85
    5       RHS TD3X2 temp sensor                  34.6   (50) 51.2     70        85
    6       PHY[0:2] temp sensor                   35.5   (50) 51.2     70        85
    7       PHY[3:5] temp sensor                   32.8   (50) 51.2     70        85
    8       Board temp sensor                      39.8   (59) 60.0     65        75
    9       SwitchAsic left center sensor          34.5   (80) 81.2    100       110
    10      SwitchAsic top center inner sensor     34.5   (80) 81.2    100       110
    11      SwitchAsic bottom center sensor        35.1   (80) 81.2    100       110
    12      SwitchAsic center sensor               36.2   (80) 81.2    100       110
    13      SwitchAsic top center sensor           33.9   (80) 81.2    100       110
    14      SwitchAsic right center sensor         35.1   (80) 81.2    100       110
    15      SwitchAsic left center sensor          32.3   (80) 81.2    100       110
    16      SwitchAsic top center inner sensor     33.9   (80) 81.2    100       110
    17      SwitchAsic bottom center sensor        30.0   (80) 81.2    100       110
    18      SwitchAsic center sensor               31.7   (80) 81.2    100       110
    19      SwitchAsic top center sensor           30.0   (80) 81.2    100       110
    20      SwitchAsic right center sensor         31.7   (80) 81.2    100       110
    21      Bcm54998E Chip0                        38.0   (85) 86.2    100       115
    22      Bcm54998E Chip1                        37.0   (85) 86.2    100       115
    23      Bcm54998E Chip2                        34.0   (85) 86.2    100       115
    24      Bcm54998E Chip3                        32.0   (85) 86.2    100       115
    25      Bcm54998E Chip4                        30.0   (85) 86.2    100       115
    26      Bcm54998E Chip5                        33.0   (85) 86.2    100       115
    27      PoE Chip1                              25.0   (85) 86.2     95       100
    28      PoE Chip0                              27.0   (85) 86.2     95       100
    29      PoE Chip3                              27.0   (85) 86.2     95       100
    30      PoE Chip2                              25.0   (85) 86.2     95       100
    31      PoE Chip5                              29.0   (85) 86.2     95       100
    32      PoE Chip4                              31.0   (85) 86.2     95       100
    33      PoE Chip7                              29.0   (85) 86.2     95       100
    34      PoE Chip6                              29.0   (85) 86.2     95       100
    35      PoE Chip9                              27.0   (85) 86.2     95       100
    36      PoE Chip8                              29.0   (85) 86.2     95       100
    37      PoE Chip11                             29.0   (85) 86.2     95       100
    38      PoE Chip10                             25.0   (85) 86.2     95       100

    PowerSupply 1:
                                                                    Alert  Critical
                                                Temp    Setpoint  Limit     Limit
    Sensor  Description                             (C)         (C)    (C)       (C)
    ------- ----------------------------------- ------- ----------- ------ ---------
    1       Inlet                                  32.9   (55) 56.0     61        65
    2       Secondary hotspot                      41.8   (70) 69.0     74        78
    3       Primary hotspot                        47.6   (60) 61.2     68        73

    System cooling status is: Ok
    Ambient temperature: 28C
    Airflow: port-side intake
    Number of cooling zones is: 1
                                Config Actual         Speed      Stable
    Fan            Status        Speed  Speed  Uptime Stability  Uptime
    -------------- ------------ ------ ------ ------- --------- -------
    1/1            Ok              39%    39% 4:59:18 Stable    4:58:15
    2/1            Ok              39%    39% 4:59:18 Stable    4:58:15
    3/1            Ok              39%    39% 4:59:18 Stable    4:58:17
    PowerSupply1/1 Ok              30%    30% 4:59:11 Stable    4:57:27
    PowerSupply2   Not Inserted    N/A    N/A Offline N/A           N/A

    Power                            Input  Output  Output
    Supply Model           Capacity Current Current  Power Status  Uptime
    ------ --------------- -------- ------- ------- ------ ------ -------
    1      PWR-1021-AC-RED    1050W   0.96A   1.71A  95.0W Ok     4:59:11
    Total  --                 1050W      --      --  95.0W --          --
    ```

5. Let's take a look at the interfaces and what's connected to our device
6. We can validate LLDP neighbors and show detail

    ```yaml
    show lldp neighbors
    ```

    ```yaml title="Example Output"
    Last table change time   : 0:00:02 ago

    Number of table inserts  : 51
    Number of table deletes  : 35
    Number of table drops    : 0
    Number of table age-outs : 0

    Port          Neighbor Device ID       Neighbor Port ID    TTL
    ---------- ------------------------ ---------------------- ---
    Et1           sw-10.1.1.51             Ethernet15          120
    Et3           sw-10.1.2.42             Ethernet15          120
    Et5           sw-10.1.3.40             Ethernet15          120
    Et7           sw-10.1.4.41             Ethernet15          120
    Et9           sw-10.1.5.40             Ethernet15          120
    Et11          sw-10.1.6.41             Ethernet15          120
    Et13          sw-10.1.7.41             Ethernet15          120
    Et15          sw-10.1.8.40             Ethernet15          120
    Et17          sw-10.1.9.41             Ethernet15          120
    Et19          sw-10.1.10.41            Ethernet15          120
    Et21          sw-10.1.11.40            Ethernet15          120
    Et23          sw-10.1.12.40            Ethernet15          120
    Et25          sw-10.1.13.40            Ethernet15          120
    Et33          Arista_18:66:BF          3086.2d18.66bf      120
    Et47          SPINE02                  Ethernet47          120
    Et48          SPINE02                  Ethernet48          120
    Et49          CORE01                   Ethernet49          120

    SPINE01#sh ip int brief
                                                                                    Address
    Interface         IP Address             Status       Protocol           MTU    Owner
    ----------------- ---------------------- ------------ -------------- ---------- -------
    Ethernet49        192.168.254.1/31       up           up                9214
    Management1       unassigned             down         down              1500
    Vlan100           10.1.100.2/24          up           up                9214
    Vlan101           10.1.1.2/24            up           up                9214
    Vlan102           10.1.2.2/24            up           up                9214
    Vlan103           10.1.3.2/24            up           up                9214
    Vlan104           10.1.4.2/24            up           up                9214
    Vlan105           10.1.5.2/24            up           up                9214
    Vlan106           10.1.6.2/24            up           up                9214
    Vlan107           10.1.7.2/24            up           up                9214
    Vlan108           10.1.8.2/24            up           up                9214
    Vlan109           10.1.9.2/24            up           up                9214
    Vlan110           10.1.10.2/24           up           up                9214
    Vlan111           10.1.11.2/24           up           up                9214
    Vlan112           10.1.12.2/24           up           up                9214
    Vlan113           10.1.13.2/24           up           up                9214
    Vlan4094          192.168.255.1/30       up           up                9214

    SPINE01#sh int status
    Port       Name           Status       Vlan     Duplex Speed  Type         Flags Encapsulation
    Et1                       connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et2                       connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et3                       connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et4                       connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et5                       connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et6                       connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et7                       connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et8                       notconnect   trunk    auto   auto   2.5GBASE-T
    Et9                       connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et10                      connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et11                      connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et12                      connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et13                      connected    trunk    a-full a-2.5G 2.5GBASE-T
    Et14                      disabled     1        auto   auto   2.5GBASE-T
    Et15                      disabled     1        auto   auto   2.5GBASE-T
    Et16                      disabled     1        auto   auto   2.5GBASE-T
    Et17                      disabled     1        auto   auto   2.5GBASE-T
    Et18                      disabled     1        auto   auto   2.5GBASE-T
    Et19                      disabled     1        auto   auto   2.5GBASE-T
    Et20                      disabled     1        auto   auto   2.5GBASE-T
    Et21                      disabled     1        auto   auto   2.5GBASE-T
    Et22                      disabled     1        auto   auto   2.5GBASE-T
    Et23                      disabled     1        auto   auto   2.5GBASE-T
    Et24                      disabled     1        auto   auto   2.5GBASE-T
    Et25                      disabled     1        auto   auto   2.5GBASE-T
    Et26                      disabled     1        auto   auto   2.5GBASE-T
    Et27                      disabled     100      auto   auto   2.5GBASE-T
    Et28                      disabled     100      auto   auto   2.5GBASE-T
    Et29                      disabled     100      auto   auto   2.5GBASE-T
    Et30                      disabled     100      auto   auto   2.5GBASE-T
    Et31                      disabled     100      auto   auto   2.5GBASE-T
    Et32                      disabled     100      auto   auto   2.5GBASE-T
    Et33       ATD_WIFI       connected    100      a-full a-2.5G 2.5GBASE-T
    Et34       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et35       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et36       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et37       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et38       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et39       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et40       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et41       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et42       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et43       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et44       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et45       ACCESS_100     notconnect   100      auto   auto   2.5GBASE-T
    Et46       ACCESS_100     connected    100      a-full a-1G   2.5GBASE-T
    Et47       MLAG           connected    in Po11  a-full a-2.5G 2.5GBASE-T
    Et48       MLAG           connected    in Po11  a-full a-2.5G 2.5GBASE-T
    Et49                      connected    routed   full   10G    10GBASE-SR
    Et50                      notconnect   1        full   25G    Not Present
    Et51                      notconnect   in Po11  full   10G    10GBASE-SR
    Et52                      notconnect   1        full   25G    Not Present
    Et53                      notconnect   1        full   25G    Not Present
    Et54                      notconnect   1        full   25G    Not Present
    Et55                      notconnect   1        full   25G    Not Present
    Et56                      notconnect   1        full   25G    Not Present
    Ma1                       notconnect   routed   auto   auto   10/100/1000
    Po11       MLAG Peer Link connected    trunk    full   5G     N/A
    Po101      POD01          notconnect   trunk    full   unconf N/A
    Po102      POD02          notconnect   trunk    full   unconf N/A
    Po103      POD03          notconnect   trunk    full   unconf N/A
    Po104      POD04          notconnect   trunk    full   unconf N/A
    Po105      POD05          notconnect   trunk    full   unconf N/A
    Po106      POD06          notconnect   trunk    full   unconf N/A
    Po107      POD07          notconnect   trunk    full   unconf N/A
    Po108      POD08          notconnect   trunk    full   unconf N/A
    Po109      POD09          notconnect   trunk    full   unconf N/A
    Po110      POD10          notconnect   trunk    full   unconf N/A
    Po111      POD11          notconnect   trunk    full   unconf N/A
    Po112      POD12          notconnect   trunk    full   unconf N/A
    Po113      POD13          notconnect   trunk    full   unconf N/A
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


    MLAG Configuration:
    domain-id                          :                MLAG
    local-interface                    :            Vlan4094
    peer-address                       :       192.168.255.2
    peer-link                          :      Port-Channel11
    hb-peer-address                    :             0.0.0.0
    peer-config                        :          consistent

    MLAG Status:
    state                              :              Active
    negotiation status                 :           Connected
    peer-link status                   :                  Up
    local-int status                   :                  Up
    system-id                          :   ae:3d:94:50:af:c6
    dual-primary detection             :            Disabled
    dual-primary interface errdisabled :               False

    MLAG Ports:
    Disabled                           :                   0
    Configured                         :                   0
    Inactive                           :                  13
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
    State                           :              primary
    Peer State                      :            secondary
    State changes                   :                    2
    Last state change time          :          4:56:38 ago
    Hardware ready                  :                 True
    Failover                        :                False
    Failover Cause(s)               :              Unknown
    Last failover change time       :                never
    Secondary from failover         :                False
    Peer MAC address                :    ac:3d:94:50:d2:aa
    Peer MAC routing supported      :                 True
    Reload delay                    :          300 seconds
    Non-MLAG reload delay           :          300 seconds
    Peer ports errdisabled          :                False
    Lacp standby                    :                False
    Configured heartbeat interval   :              4000 ms
    Effective heartbeat interval    :              4000 ms
    Heartbeat timeout               :             60000 ms
    Last heartbeat timeout          :                never
    Heartbeat timeouts since reboot :                    0
    UDP heartbeat alive             :                 True
    Heartbeats sent/received        :            4499/4450
    Peer monotonic clock offset     :   -56.025806 seconds
    Agent should be running         :                 True
    P2p mount state changes         :                    1
    Fast MAC redirection enabled    :                 True
    Interface activation interlock  :         unconfigured
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
    run show int Port-Channel11; show port-channel 11 detailed
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
        Ethernet47       11:51:27                 LACP           Active         1       Rx,Tx
        Ethernet48       9:24:02                  LACP           Active         1       Rx,Tx

    Configured, but inactive ports:
        Port             Time Became Inactive    Reason
        ---------------- -------------------------- -------------------------
        Ethernet51       Always                  wrong speed for aggregate
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
    SPINE01#show mlag interfaces
                                                               local/remote
    mlag       desc           state       local       remote          status
    ---------- ----------- -------------- ----------- ------------ ------------
    101       POD01       inactive       Po101        Po101       down/down
    102       POD02       inactive       Po102        Po102       down/down
    103       POD03       inactive       Po103        Po103       down/down
    104       POD04       inactive       Po104        Po104       down/down
    105       POD05       inactive       Po105        Po105       down/down
    106       POD06       inactive       Po106        Po106       down/down
    107       POD07       inactive       Po107        Po107       down/down
    108       POD08       inactive       Po108        Po108       down/down
    109       POD09       inactive       Po109        Po109       down/down
    110       POD10       inactive       Po110        Po110       down/down
    111       POD11       inactive       Po111        Po111       down/down
    112       POD12       inactive       Po112        Po112       down/down
    113       POD13       inactive       Po113        Po113       down/down
    ```

10. That's it for this lab, you should have a bit better understanding of how MLAG is configured

11. Instructor Lead

    1. Linux Example - go into bash
    2. vlan config
    3. packet capture/tcpdump
    4. Config session
    5. AAA Logs

!!! tip "🎉 CONGRATS! You have completed this lab! 🎉"

    [:material-login: LET'S GO TO THE NEXT LAB!](./a02_lab.md){ .md-button .md-button--primary }

--8<-- "includes/abbreviations.md"
