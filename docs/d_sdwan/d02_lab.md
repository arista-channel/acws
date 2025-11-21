# D-02 | SD-WAN Configuration

## Overview

In this lab, you'll learn how to configure Arista SD-WAN policies and deploy them to edge devices. You'll work with traffic steering, security policies, and application-aware routing to optimize WAN connectivity.

## Learning Objectives

By the end of this lab, you will be able to:

- Configure SD-WAN policies in CloudVision Portal
- Deploy policies to edge devices
- Configure application-aware routing
- Implement traffic steering rules
- Set up WAN path preferences

## Lab Topology

!!! info "Lab Environment"
    This lab builds on D-01 and uses the same SD-WAN environment with:
    
    - **2 Branch Sites**: Each with dual WAN connections (MPLS + Internet)
    - **SD-WAN Controller**: Centralized policy management
    - **CloudVision Portal**: Configuration and monitoring

## Prerequisites

Before starting this lab, ensure you have:

- [ ] Completed D-01 - SD-WAN Overview
- [ ] Access to CloudVision Portal
- [ ] Understanding of SD-WAN architecture

## Configuration Tasks

### Task 1: Configure WAN Interfaces

1. Login to the edge device:

    ```yaml
    ssh student#@<edge-device-ip>
    ```

2. Configure the primary WAN interface (MPLS):

    ```yaml
    configure
    interface Ethernet1
      description MPLS-WAN
      no switchport
      ip address 10.1.1.1/30
      sdwan
        path-group MPLS
    ```

3. Configure the secondary WAN interface (Internet):

    ```yaml
    interface Ethernet2
      description Internet-WAN
      no switchport
      ip address 192.168.1.1/30
      sdwan
        path-group Internet
    ```

### Task 2: Create Traffic Steering Policies

1. Navigate to CloudVision Portal > SD-WAN > Policies

2. Create a new traffic steering policy:

    ```yaml
    Policy Name: Business-Critical-Apps
    Description: Route business-critical traffic over MPLS
    ```

3. Define application matching criteria:

    ```yaml
    Applications:
      - SAP
      - Oracle
      - Microsoft 365
    
    Preferred Path: MPLS
    Backup Path: Internet
    ```

### Task 3: Configure Application-Aware Routing

1. Create an application profile:

    ```yaml
    sdwan
      application-profile Business-Critical
        application sap
        application oracle
        path-selection
          prefer path-group MPLS
          backup path-group Internet
    ```

2. Apply the profile to the SD-WAN policy:

    ```yaml
    sdwan
      policy Business-Apps
        match application-profile Business-Critical
          action forward path-group MPLS
    ```

### Task 4: Set Up Path Preferences

1. Configure path selection based on performance metrics:

    ```yaml
    sdwan
      path-group MPLS
        preference 100
        sla-profile Low-Latency
          latency 50
          jitter 10
          loss 1
    ```

2. Configure Internet path as backup:

    ```yaml
    sdwan
      path-group Internet
        preference 50
        sla-profile Best-Effort
          latency 100
          jitter 20
          loss 5
    ```

## Verification

### Verify SD-WAN Configuration

1. Check SD-WAN policy status:

    ```yaml
    show sdwan policy
    ```

2. Verify path selection:

    ```yaml
    show sdwan path-selection
    ```

3. View active tunnels and their metrics:

    ```yaml
    show sdwan tunnels detail
    ```

4. Check application routing:

    ```yaml
    show sdwan application-routing
    ```

## Testing

### Test Traffic Steering

1. Generate test traffic for business-critical applications:

    ```yaml
    # From edge device
    ping 10.2.1.1 source Ethernet1
    ```

2. Verify traffic is using the preferred path:

    ```yaml
    show sdwan flows application sap
    ```

3. Simulate path failure and verify failover:

    ```yaml
    # Shutdown primary path
    interface Ethernet1
      shutdown
    
    # Verify traffic moved to backup path
    show sdwan flows
    ```

## CloudVision Portal Configuration

### Deploy Policies via CloudVision

1. Navigate to **Provisioning > SD-WAN**

2. Select your edge devices

3. Apply the configured policies:
   - Traffic Steering Policy
   - Application Profiles
   - Path Selection Rules

4. Click **Deploy** and monitor the deployment status

## Troubleshooting

### Common Issues

!!! warning "Path Not Available"
    If a path is not available, check:
    
    - Interface status: `show interfaces status`
    - Tunnel status: `show sdwan tunnels`
    - Controller connectivity: `show sdwan controller`

!!! warning "Application Not Matching"
    If applications aren't matching policies:
    
    - Verify DPI is enabled: `show sdwan dpi`
    - Check application signatures: `show sdwan applications`
    - Review policy configuration: `show sdwan policy detail`

## Next Steps

In the next lab (D-03), you'll learn about SD-WAN operations, monitoring, and troubleshooting techniques.

## Summary

In this lab, you configured SD-WAN policies including traffic steering, application-aware routing, and path preferences. You deployed these policies to edge devices and verified their operation.

---

!!! success "Lab Complete"
    You have successfully completed the SD-WAN Configuration lab. Proceed to **D-03 - SD-WAN Operations** to continue.

