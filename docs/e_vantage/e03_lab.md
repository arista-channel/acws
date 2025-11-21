# E-03 | Vantage Operations

## Overview

In this lab, you'll learn how to effectively operate and maintain Arista Vantage in a production environment. You'll practice troubleshooting techniques, perform advanced analytics, optimize performance, and implement operational best practices.

## Learning Objectives

By the end of this lab, you will be able to:

- Perform day-to-day operational tasks in Vantage
- Troubleshoot network issues using Vantage analytics
- Use advanced analytics features for root cause analysis
- Optimize Vantage performance and data retention
- Implement operational best practices
- Generate actionable insights from network data

## Lab Topology

!!! info "Lab Environment"
    This lab uses a fully configured Vantage deployment with:
    
    - **Production Network**: Live traffic and telemetry
    - **Historical Data**: 30 days of network metrics
    - **Active Alerts**: Real-world scenarios
    - **Multiple Users**: Simulated team environment

## Prerequisites

Before starting this lab, ensure you have:

- [ ] Completed E-01 - Vantage Overview
- [ ] Completed E-02 - Vantage Configuration
- [ ] Access to production Vantage environment
- [ ] Understanding of network troubleshooting

## Daily Operations

### Task 1: Morning Health Check

1. **Review Dashboard**

    Navigate to your main dashboard and check:
    
    ```yaml
    Health Indicators:
      - Network health score: Should be > 90%
      - Active alerts: Review any critical/warning alerts
      - Device status: Check for any offline devices
      - Top applications: Verify expected traffic patterns
    ```

2. **Check Active Alerts**

    Navigate to **Alerts > Active Alerts**
    
    ```yaml
    For each alert:
      - Review severity and impact
      - Check alert history
      - Acknowledge if investigating
      - Assign to team member if needed
      - Add notes on investigation progress
    ```

3. **Review Overnight Events**

    Navigate to **Events > Timeline**
    
    ```yaml
    Filter by:
      - Time: Last 12 hours
      - Severity: Warning and above
      - Type: All events
    
    Look for:
      - Configuration changes
      - Device reboots
      - Interface flaps
      - Unusual traffic patterns
    ```

## Troubleshooting Scenarios

### Scenario 1: High Latency Complaint

!!! note "User Report"
    Users in Building A report slow application performance during business hours.

**Investigation Steps:**

1. **Identify Affected Path**

    Navigate to **Analytics > Path Analysis**
    
    ```yaml
    Source: Building A subnet (10.10.10.0/24)
    Destination: Application server (10.20.1.100)
    Time Range: Last 4 hours
    
    Metrics to Review:
      - End-to-end latency
      - Packet loss
      - Jitter
      - Path utilization
    ```

2. **Analyze Traffic Patterns**

    ```yaml
    Navigate to: Analytics > Traffic Analysis
    Filter: Building A uplink interfaces
    
    Check for:
      - Bandwidth saturation
      - Microbursts
      - Packet drops
      - QoS violations
    ```

3. **Review Device Performance**

    ```yaml
    Navigate to: Devices > Building A Distribution Switch
    
    Check:
      - CPU utilization
      - Memory usage
      - Interface errors
      - Queue depths
    ```

4. **Root Cause Analysis**

    Use Vantage AI-powered insights:
    
    ```yaml
    Navigate to: Analytics > Root Cause Analysis
    Select: High Latency Event
    
    Vantage will analyze:
      - Correlated events
      - Similar historical patterns
      - Potential causes
      - Recommended actions
    ```

5. **Resolution and Verification**

    After implementing fix:
    
    ```yaml
    - Monitor latency metrics in real-time
    - Compare before/after performance
    - Verify user experience improved
    - Document resolution in alert notes
    ```

### Scenario 2: Unexpected Traffic Spike

!!! note "Alert Triggered"
    Anomaly detection alert: Unusual traffic spike on WAN link

**Investigation Steps:**

1. **Identify Traffic Source**

    Navigate to **Analytics > Flow Analysis**
    
    ```yaml
    Interface: WAN uplink
    Time: Alert timestamp
    
    Analyze:
      - Top talkers (source IPs)
      - Top applications
      - Traffic direction (inbound/outbound)
      - Protocol distribution
    ```

2. **Determine if Legitimate**

    ```yaml
    Questions to answer:
      - Is this a known application?
      - Is this expected business traffic?
      - Are there security indicators?
      - Is this a scheduled backup/update?
    ```

3. **Check for Security Threats**

    Navigate to **Security > Threat Analysis**
    
    ```yaml
    Look for:
      - DDoS patterns
      - Port scanning
      - Data exfiltration
      - Malware communication
    ```

4. **Take Action**

    Based on findings:
    
    ```yaml
    If legitimate:
      - Update baseline
      - Adjust alert thresholds
      - Document as expected behavior
    
    If suspicious:
      - Escalate to security team
      - Block source if necessary
      - Collect evidence
      - Create incident report
    ```

### Scenario 3: Device Unreachable

!!! note "Alert Triggered"
    Critical alert: Core switch unreachable

**Investigation Steps:**

1. **Verify Device Status**

    Navigate to **Devices > Core Switch**
    
    ```yaml
    Check:
      - Last seen timestamp
      - Last successful telemetry collection
      - Device reachability from Vantage
      - Ping/SNMP status
    ```

2. **Check Network Path**

    Navigate to **Topology > Path Trace**
    
    ```yaml
    Source: Vantage collector
    Destination: Core switch management IP
    
    Identify:
      - Where connectivity breaks
      - Intermediate device status
      - Routing issues
    ```

3. **Review Recent Changes**

    Navigate to **Events > Configuration Changes**
    
    ```yaml
    Filter:
      - Device: Core switch
      - Time: Last 24 hours
    
    Look for:
      - Configuration changes
      - Software upgrades
      - Maintenance activities
    ```

4. **Coordinate Recovery**

    ```yaml
    Actions:
      - Contact on-site personnel
      - Verify physical connectivity
      - Check console access
      - Review device logs
      - Plan recovery steps
    ```

## Advanced Analytics

### Task 2: Capacity Planning Analysis

1. **Analyze Growth Trends**

    Navigate to **Analytics > Capacity Planning**
    
    ```yaml
    Select Metrics:
      - Interface utilization
      - Device CPU/Memory
      - Storage consumption
    
    Time Range: Last 6 months
    
    Analysis:
      - Calculate growth rate
      - Project future capacity needs
      - Identify bottlenecks
      - Plan upgrades
    ```

2. **Generate Forecast Report**

    ```yaml
    Report Parameters:
      - Forecast period: Next 12 months
      - Confidence level: 95%
      - Include recommendations: Yes
    
    Output:
      - Interfaces reaching 80% in next 6 months
      - Devices requiring memory upgrades
      - Recommended expansion timeline
      - Budget estimates
    ```

### Task 3: Application Performance Analysis

1. **Identify Application Issues**

    Navigate to **Analytics > Application Performance**
    
    ```yaml
    Select Application: Microsoft 365
    Time Range: Last 7 days
    
    Metrics:
      - Response time
      - Throughput
      - Packet loss
      - User experience score
    ```

2. **Compare Performance Across Sites**

    ```yaml
    Create Comparison:
      - Site A vs Site B vs Site C
      - Same application
      - Same time period
    
    Identify:
      - Performance differences
      - Site-specific issues
      - Network path variations
    ```

3. **Optimize Application Delivery**

    Based on analysis:
    
    ```yaml
    Recommendations:
      - QoS policy adjustments
      - Path selection optimization
      - Bandwidth allocation
      - Caching strategies
    ```

## Performance Optimization

### Task 4: Optimize Vantage Performance

1. **Review Data Collection**

    Navigate to **Settings > Data Sources**
    
    ```yaml
    Optimize:
      - Reduce collection frequency for stable metrics
      - Increase frequency for critical metrics
      - Disable unused telemetry paths
      - Use sampling for high-volume flows
    ```

2. **Manage Data Retention**

    Navigate to **Settings > Data Retention**
    
    ```yaml
    Configure:
      - Raw data: 7 days
      - Aggregated (5-min): 30 days
      - Aggregated (1-hour): 90 days
      - Aggregated (1-day): 1 year
    
    Archive:
      - Export old data to external storage
      - Compress archived data
      - Maintain compliance requirements
    ```

3. **Optimize Dashboards**

    ```yaml
    Best Practices:
      - Limit widgets per dashboard (< 12)
      - Use appropriate time ranges
      - Avoid complex queries
      - Cache frequently accessed data
      - Use filters to reduce data volume
    ```

## Operational Best Practices

### Maintenance Procedures

1. **Regular Health Checks**

    ```yaml
    Daily:
      - Review active alerts
      - Check device status
      - Verify data collection
    
    Weekly:
      - Review alert trends
      - Update dashboards
      - Check system performance
    
    Monthly:
      - Review and update alert thresholds
      - Analyze capacity trends
      - Update documentation
      - Review user access
    ```

2. **Alert Management**

    ```yaml
    Best Practices:
      - Tune thresholds to reduce noise
      - Use alert suppression during maintenance
      - Implement escalation policies
      - Regular review of alert effectiveness
      - Document common resolutions
    ```

3. **Documentation**

    ```yaml
    Maintain:
      - Dashboard purposes and usage
      - Alert definitions and thresholds
      - Troubleshooting procedures
      - Integration configurations
      - Change history
    ```

## Reporting and Communication

### Task 5: Generate Executive Reports

1. **Monthly Performance Report**

    ```yaml
    Sections:
      - Executive Summary
      - Network Health Trends
      - Incident Summary
      - Capacity Status
      - Recommendations
    
    Audience: Management
    Format: PDF with visualizations
    ```

2. **Technical Deep-Dive Report**

    ```yaml
    Sections:
      - Detailed metrics
      - Root cause analyses
      - Performance optimizations
      - Technical recommendations
    
    Audience: Network engineers
    Format: PDF + Excel data
    ```

## Summary

In this lab, you learned how to operate Arista Vantage in a production environment, including daily operations, troubleshooting techniques, advanced analytics, and performance optimization.

### Key Takeaways

- Proactive monitoring prevents issues
- Vantage provides powerful troubleshooting tools
- Advanced analytics enable data-driven decisions
- Regular optimization maintains performance
- Documentation is essential for operations

---

!!! success "Lab Series Complete"
    Congratulations! You have successfully completed all Vantage Professional Services labs. You now have the skills to deploy, configure, and operate Arista Vantage for comprehensive network observability.

## Additional Resources

- [Arista Vantage Operations Guide](https://www.arista.com/en/support/product-documentation)
- [Vantage Best Practices](https://www.arista.com/en/solutions)
- [Network Observability Webinars](https://www.arista.com/en/company/news/webinars)

