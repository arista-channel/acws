# D-01 | SD-WAN Overview

## Overview

In this lab, you'll learn about Arista's SD-WAN solution and its key components. You'll explore how Arista SD-WAN provides secure, reliable, and optimized connectivity across distributed enterprise networks.

## Learning Objectives

By the end of this lab, you will be able to:

- Understand the fundamentals of Arista SD-WAN architecture
- Identify key SD-WAN components and their roles
- Explore SD-WAN deployment models
- Review SD-WAN use cases and benefits

## Lab Topology

!!! info "Lab Environment"
    This lab uses a simulated SD-WAN environment with the following components:
    
    - **SD-WAN Controllers**: Centralized management and orchestration
    - **Edge Devices**: Branch routers and gateways
    - **CloudVision Portal**: Monitoring and analytics platform

## Prerequisites

Before starting this lab, ensure you have:

- [ ] Access to the lab environment
- [ ] Basic understanding of networking concepts
- [ ] Familiarity with Arista EOS CLI

## SD-WAN Architecture

### Key Components

1. **SD-WAN Controller**
   - Centralized policy management
   - Path selection and optimization
   - Security policy enforcement

2. **Edge Devices**
   - Branch routers running Arista EOS
   - Support for multiple WAN transports
   - Local breakout capabilities

3. **CloudVision Portal**
   - Real-time monitoring and analytics
   - Configuration management
   - Troubleshooting tools

## Getting Started

### Step 1: Access the Lab Environment

1. Login to CloudVision Portal using the credentials provided:

    ```yaml
    URL: https://www.cv-staging.corp.arista.io/cv/provisioning
    Username: student#
    Password: Arista123
    ```

2. Navigate to the SD-WAN dashboard to view your topology.

### Step 2: Explore SD-WAN Components

1. Review the SD-WAN controller configuration:

    ```yaml
    show sdwan controller
    ```

2. Check the WAN interface status:

    ```yaml
    show sdwan interfaces
    ```

3. View active SD-WAN tunnels:

    ```yaml
    show sdwan tunnels
    ```

## SD-WAN Benefits

### Business Advantages

- **Cost Optimization**: Leverage multiple transport types (MPLS, Internet, LTE)
- **Application Performance**: Intelligent path selection based on application requirements
- **Security**: Integrated security with encryption and segmentation
- **Simplified Management**: Centralized configuration and monitoring

### Technical Capabilities

- Dynamic path selection
- Application-aware routing
- Zero-touch provisioning
- High availability and redundancy

## Lab Tasks

!!! note "Task 1: Review SD-WAN Dashboard"
    Navigate through the CloudVision SD-WAN dashboard and identify:
    
    - Number of active sites
    - WAN transport types in use
    - Current tunnel status
    - Application performance metrics

!!! note "Task 2: Explore SD-WAN Policies"
    Review the configured SD-WAN policies:
    
    - Traffic steering policies
    - Security policies
    - QoS policies

## Next Steps

In the next lab (D-02), you'll learn how to configure SD-WAN policies and deploy them to edge devices.

## Additional Resources

- [Arista SD-WAN Documentation](https://www.arista.com/en/solutions/sd-wan)
- [CloudVision Portal User Guide](https://www.arista.com/en/support/product-documentation/cloudvision)
- [SD-WAN Best Practices](https://www.arista.com/en/support/advisories-notices)

## Summary

In this lab, you explored the fundamentals of Arista SD-WAN, including its architecture, key components, and business benefits. You accessed the lab environment and reviewed the SD-WAN dashboard in CloudVision Portal.

---

!!! success "Lab Complete"
    You have successfully completed the SD-WAN Overview lab. Proceed to **D-02 - SD-WAN Configuration** to continue your learning journey.

