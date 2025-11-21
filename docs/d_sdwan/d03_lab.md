# D-03 | SD-WAN Operations

## Overview

In this lab, you'll learn how to monitor, operate, and troubleshoot Arista SD-WAN deployments. You'll use CloudVision Portal for real-time monitoring, performance analysis, and troubleshooting common SD-WAN issues.

## Learning Objectives

By the end of this lab, you will be able to:

- Monitor SD-WAN performance metrics
- Analyze application traffic patterns
- Troubleshoot SD-WAN connectivity issues
- Use CloudVision Portal for operational tasks
- Implement SD-WAN best practices

## Lab Topology

!!! info "Lab Environment"
    This lab uses the fully configured SD-WAN environment from D-01 and D-02 with:
    
    - **Multiple Branch Sites**: With active SD-WAN policies
    - **Production Traffic**: Simulated application traffic
    - **CloudVision Portal**: Full monitoring and analytics

## Prerequisites

Before starting this lab, ensure you have:

- [ ] Completed D-01 - SD-WAN Overview
- [ ] Completed D-02 - SD-WAN Configuration
- [ ] Active SD-WAN deployment with traffic

## Monitoring SD-WAN Performance

### Task 1: CloudVision Portal Dashboard

1. Login to CloudVision Portal and navigate to **SD-WAN Dashboard**

2. Review key metrics:
   - **Tunnel Health**: Active/Inactive tunnels
   - **Path Performance**: Latency, jitter, packet loss
   - **Application Performance**: Per-application metrics
   - **Bandwidth Utilization**: Per-path usage

3. Identify any performance anomalies or alerts

### Task 2: Real-Time Monitoring

1. Access real-time tunnel statistics:

    ```yaml
    show sdwan tunnels statistics
    ```

2. Monitor path quality metrics:

    ```yaml
    show sdwan path-quality
    ```

    ???+ quote "Example Output"
        ```yaml
        Path Group    Interface    Latency    Jitter    Loss    Status
        MPLS          Ethernet1    25ms       2ms       0.1%    Up
        Internet      Ethernet2    45ms       8ms       0.5%    Up
        ```

3. View application traffic distribution:

    ```yaml
    show sdwan application-traffic
    ```

## Performance Analysis

### Task 3: Analyze Application Performance

1. Review application-specific metrics in CloudVision:
   - Navigate to **SD-WAN > Applications**
   - Select an application (e.g., Microsoft 365)
   - Review performance trends

2. Check application path selection:

    ```yaml
    show sdwan application-routing detail
    ```

3. Analyze bandwidth consumption:

    ```yaml
    show sdwan bandwidth-usage
    ```

### Task 4: Path Performance Comparison

1. Compare performance across WAN paths:

    ```yaml
    show sdwan path-comparison
    ```

2. Review historical performance data in CloudVision:
   - Navigate to **Analytics > SD-WAN Performance**
   - Select time range (last 24 hours)
   - Compare MPLS vs Internet paths

## Troubleshooting

### Task 5: Troubleshoot Connectivity Issues

!!! note "Scenario: Tunnel Down"
    A branch site reports that their SD-WAN tunnel is down. Follow these steps to troubleshoot:

1. Check tunnel status:

    ```yaml
    show sdwan tunnels
    ```

2. Verify interface status:

    ```yaml
    show interfaces status
    ```

3. Check controller connectivity:

    ```yaml
    show sdwan controller connectivity
    ```

4. Review system logs:

    ```yaml
    show logging | grep sdwan
    ```

5. Test connectivity to controller:

    ```yaml
    ping <controller-ip> source <wan-interface>
    ```

### Task 6: Troubleshoot Application Issues

!!! note "Scenario: Poor Application Performance"
    Users report slow performance for business-critical applications.

1. Identify the application traffic:

    ```yaml
    show sdwan flows application <app-name>
    ```

2. Check which path is being used:

    ```yaml
    show sdwan application-routing <app-name>
    ```

3. Review path quality metrics:

    ```yaml
    show sdwan path-quality detail
    ```

4. Verify SLA compliance:

    ```yaml
    show sdwan sla-profile status
    ```

5. If needed, manually steer traffic to a different path:

    ```yaml
    configure
    sdwan
      policy <policy-name>
        match application <app-name>
          action forward path-group <alternate-path>
    ```

## Operational Tasks

### Task 7: Perform Path Maintenance

1. Gracefully drain traffic from a path before maintenance:

    ```yaml
    configure
    sdwan
      path-group MPLS
        shutdown graceful
    ```

2. Monitor traffic migration:

    ```yaml
    show sdwan flows
    ```

3. After maintenance, bring the path back online:

    ```yaml
    configure
    sdwan
      path-group MPLS
        no shutdown
    ```

### Task 8: Update SD-WAN Policies

1. Navigate to CloudVision Portal > **SD-WAN > Policies**

2. Modify an existing policy (e.g., change path preference)

3. Preview changes before deployment

4. Deploy to selected sites

5. Monitor deployment status and verify changes

## Best Practices

### Monitoring Best Practices

- [ ] Set up alerts for tunnel failures
- [ ] Monitor SLA compliance regularly
- [ ] Review application performance trends weekly
- [ ] Configure SNMP traps for critical events

### Operational Best Practices

- [ ] Use graceful shutdown for planned maintenance
- [ ] Test policy changes in a lab environment first
- [ ] Document all configuration changes
- [ ] Maintain backup WAN paths for redundancy
- [ ] Regular review of application routing policies

## CloudVision Analytics

### Task 9: Use Advanced Analytics

1. Navigate to **CloudVision > Analytics > SD-WAN**

2. Create custom dashboards for:
   - Branch site performance comparison
   - Application performance trends
   - WAN path utilization
   - SLA compliance reports

3. Set up automated reports:
   - Daily performance summary
   - Weekly SLA compliance report
   - Monthly capacity planning report

## Summary

In this lab, you learned how to monitor and operate Arista SD-WAN deployments using CloudVision Portal. You practiced troubleshooting common issues and implemented operational best practices.

### Key Takeaways

- CloudVision Portal provides comprehensive SD-WAN monitoring
- Proactive monitoring helps identify issues before they impact users
- Application-aware routing ensures optimal performance
- Graceful maintenance procedures minimize service disruption

---

!!! success "Lab Series Complete"
    Congratulations! You have successfully completed all SD-WAN labs. You now have the skills to deploy, configure, and operate Arista SD-WAN solutions.

## Additional Resources

- [Arista SD-WAN Operations Guide](https://www.arista.com/en/support/product-documentation)
- [CloudVision Portal Analytics](https://www.arista.com/en/products/cloudvision)
- [SD-WAN Troubleshooting Guide](https://www.arista.com/en/support/advisories-notices)

