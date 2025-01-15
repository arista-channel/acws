# CVaas Setup: Studios

This is a how to deploy the Campus Workshop using Arista CloudVision Campus Studios. The reuslts of this setup will include

- [x] CloudVision Campus Studios
    - [x] Devices onboard to studios
    - [x] Studios driven configuration
    - [x] Change Control deployment

## CVaaS Setup

Details needed for CVaaS setup

- Add Static Configlets to the Static Configuration Studio
    - Global, Device Specific Configs, RadSec Config
- ZTP Switches - pre cabled to match Pod architecture 
- Add 1a & 1b to the Inventory & Topology Studio
- Apply Global & Static Configs to 1a & 1b in the Static Configuration Studio
- Build the Campus Fabric in the Campus Fabric (L2/L3/EVPN) Studio
    - Advanced Fabric - Inband ZTP - Leafs Inband ZTP Interfaces - Add 710 platform and the Inband ZTP Interfaces to be used in the Workshop
        - 710P - Ethernet16
    - Campus Services (Non-VXLAN)
        - select the Campus-Pod
        - select the Campus-Pod (again)
        - select Campus Type L2
        - Add the In-Band management VLAN ID
            - Enable
            - Add VLAN Name
            - Add Access-Pod
    - Campus-Pod - Fabric Configuration - Inband Management - Add Inband Mgmt VLAN
- Execute Change Control
- Add 1c to the Inventory & Topology Studio
- Apply Global & Static Configs to 1c in the Static Configuration Studio
- Add 1c to the Campus Fabric in the Campus Fabric (L2/L3/EVPN) Studio
- Execute Change Control

!!! quote "Studios-campus-pod01-global-config"

    ```yaml
    !
    username arista privilege 15 role network-admin secret sha512 $6$6pCRbtfDTU3gs5tL$J4kpWZpu2shmrf7C.e0S.qIU7O54DS/6DQeXGDFBVhMuJJdvP6ruHyd4RMXnGVtu24eJ3WXhvHlpIBWniHELl0
    !
    service routing protocols model multi-agent
    service unsupported-transceiver nhancockArista bc1fad46
    !
    ip name-server vrf default 10.0.101.254
    dns domain campusworkshop.aristanetworks.com
    !
    poe
        reboot action maintain
    !
    logging buffered 10000
    !
    load-interval default 1
    !
    event-monitor
    !
    logging level all informational
    !
    daemon TerminAttr
        exec /usr/bin/TerminAttr -cvopt primary.addr=apiserver.arista.io:443 -cvopt primary.auth=token-secure,/tmp/cv-onboarding-token-00 -cvopt cvaas.addr=apiserver.arista.io:443 -cvopt cvaas.auth=token-secure,/tmp/cv-onboarding-token-01 -cvcompression=gzip -smashexcludes=ale,flexCounter,hardware,kni,pulse,strata -ingestexclude=/Sysdb/cell/1/agent,/Sysdb/cell/2/agent -taillogs -disableaaa
        no shutdown
    !
    alias senz show interface counter error | nz
    alias snz show interface counter | nz
    alias spd show port-channel %1 detail all
    alias sqnz show interface counter queue | nz
    alias srnz show interface counter rate | nz
    !
    sflow sample 1000
    sflow polling-interval 15
    sflow destination 127.0.0.1
    sflow source-interface Vlan101
    sflow vrf mgmt destination 127.0.0.1
    sflow vrf mgmt source-interface Vlan101
    sflow run
    !
    ip routing
    !
    ip route 0.0.0.0/0 10.0.101.1
    !
    ntp local-interface Vlan101
    ntp server 10.0.101.254 prefer iburst source Vlan101
    !
    management ssh
        authentication mode password
        no shutdown
        !
    !
    management api http-commands
        protocol http
        protocol unix-socket
        no shutdown
    !
    ```


!!! quote "Studios-campus-pod01-leaf1a-deviceconfig"

    ```yaml
    hostname campus-pod01-leaf1a
    !
    interface vlan 101
        ip address 10.0.101.11/24
    ```

!!! quote "Studios-campus-pod01-leaf1b-deviceconfig"

    ```yaml
    hostname campus-pod01-leaf1b
    !
    interface vlan 101
        ip address 10.0.101.12/24
    ```

!!! quote "Studios-campus-pod01-leaf1c-deviceconfig"

    ```yaml
    hostname campus-pod01-leaf1c
    !
    interface vlan 101
        p address 10.0.101.13/24
    ```

!!! quote "Studios-campus-pod01-radsec-config"

    ```yaml
    management security
        ssl profile agni-server
            certificate 710p.pem key 710p.key
            trust certificate radsec_ca_certificate.pem
    !
    radius-server host radsec.beta.agni.arista.io tls ssl-profile agni-server timeout 10 retransmit 3
    !
    aaa group server radius agni-server-group
        server radsec.beta.agni.arista.io tls
    !
    aaa authentication dot1x default group radius
    aaa accounting dot1x default start-stop group radius
    ```