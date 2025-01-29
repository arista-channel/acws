# ATD Notes

Some notes around the setup of the Campus ATD

## Announcements

- There are tabs that have some steps

## Odd Behaviors

- Add Campus Device Workflow
  -  Make more clear you can name the switch, prefix seems too easy to select and it adds the -# to the hostname
     -  Maybe ability to control the suffix (currently '-#")
  -  Add ability to create a workspace if ones not already created
-  Let Campus Studio control inband management for ATD lab
   -  Still trying to figure out a way to account for mgmt interfaces in ACT, this adds a dup 0/0 route
      -  Mgmt is on 192.168.100.0/24, Vlan 1 (inband) is on 192.169.3.0/24
-  Working in Studios, accidentally click outside the add device workflow and lose all work
-  Inband management Address and VLAN
-  vEOS devices now work in access interface config, generates a front panel view based on port count/numbering
-  Sometimes vEOS devices in ZTP mode go from `sw-X.X.X.X` hostname to the serial hostname `SN-switch-01`

## Observations

Some observations on behavior

- Set the profile of the network-admin role to Campus Monitoring, will default the Campus Dashboard
- Static config studio will take precedence over campus studio generated config, using AVD as an example for base config using Static Config Studio will win out
  - It must be a conflict config, examples
    - An additional default route (inband mgmt) will append to the static studio config, no overwrite
    - Campus Studio adds MLAG config for dual primary detection, will append to mlag config
- Campus Fabric Studio, it's better to create the campus, pod, and access layer objects ahead of time
- CHECK ALL CVAAS SETTINGS!! Including Alpha settings
  - TURN OFF
    - Studios - Add Spine Devices in Quick Action
    - Campus Alpha Features 
    - Campus Network Hierarchy - Spine Details 


  
## A-01 Wired Provisioning

  - Initial Onbaording
    - Create the Campus Studio first
      - Best to create the campus name, campus-pod name, access-pod name ahead of time
      - Spines can be included as just string values, they do not need to be available/streaming devices
  - Campus Quick Action 
    - Onboarding leaf1a
      - Onboards via studios inventory
        - Upgrade: No
        - Prefix Name: Yes - use `pod##-leaf`
          - Device hostname can be overridden by static config studio base config
        - 
      - Static Studio Config  
        - Base config should be pre-loaded into the configlet library
        - Add new device with the base config, should not include access interface configuration
      - Submit workspace, first device should come online
    - Onboarding leaf1b
        - Requirements
          - Work space must be created first
          - Device can not be in studio inventory
          - Must use existing new campus, pods, or access pods (no creating new)
          - Requires inband management network and vlan (OOB is not supported currently as of 01/25)
            - It does IP based on ID number, so this could avoid conflicts across a multi-cvaas lab
    - Campus Studio
      - More granular options