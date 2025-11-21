# E-02 | Vantage Configuration

## Overview

In this lab, you'll learn how to configure Arista Vantage to meet your organization's specific monitoring and analytics needs. You'll create custom dashboards, configure alerts, set up data collection, and customize reports.

## Learning Objectives

By the end of this lab, you will be able to:

- Configure data collection from network devices
- Create custom dashboards and widgets
- Set up alerts and notifications
- Configure user roles and permissions
- Create custom reports and schedules
- Integrate Vantage with external systems

## Lab Topology

!!! info "Lab Environment"
    This lab builds on E-01 and uses the same Vantage deployment with:
    
    - **Pre-configured Devices**: Already streaming telemetry
    - **Sample Data**: Historical data for testing
    - **Admin Access**: Full configuration privileges

## Prerequisites

Before starting this lab, ensure you have:

- [ ] Completed E-01 - Vantage Overview
- [ ] Admin access to Vantage portal
- [ ] Understanding of your monitoring requirements

## Configuration Tasks

### Task 1: Configure Data Collection

1. Navigate to **Settings > Data Sources**

2. Add a new device for monitoring:

    ```yaml
    Device Type: Arista Switch
    Management IP: 10.1.1.10
    Protocol: gNMI (streaming telemetry)
    Credentials: Use existing credential profile
    ```

3. Configure collection intervals:

    ```yaml
    Interface Statistics: 30 seconds
    Device Health: 1 minute
    Flow Data: Real-time
    Configuration Changes: Event-driven
    ```

4. Enable specific telemetry paths:

    ```yaml
    Telemetry Paths:
      - /interfaces/interface[name=*]/state
      - /system/cpu/utilization
      - /system/memory/state
      - /network-instances/network-instance[name=*]/protocols
    ```

### Task 2: Create Custom Dashboards

1. Navigate to **Dashboards > Create New**

2. Configure dashboard properties:

    ```yaml
    Dashboard Name: Campus Network Overview
    Description: Real-time monitoring of campus infrastructure
    Refresh Interval: 30 seconds
    Visibility: Shared with team
    ```

3. Add widgets to the dashboard:

    **Widget 1: Network Health Score**
    ```yaml
    Widget Type: Gauge
    Data Source: Network Health Metrics
    Metric: Overall Health Score
    Thresholds:
      - Green: 90-100
      - Yellow: 70-89
      - Red: 0-69
    ```

    **Widget 2: Top Applications**
    ```yaml
    Widget Type: Bar Chart
    Data Source: Application Traffic
    Metric: Bandwidth (Mbps)
    Time Range: Last 1 hour
    Top N: 10
    ```

    **Widget 3: Device Status**
    ```yaml
    Widget Type: Table
    Data Source: Device Inventory
    Columns:
      - Device Name
      - Status
      - CPU %
      - Memory %
      - Uptime
    Filter: Status != Normal
    ```

    **Widget 4: Interface Utilization**
    ```yaml
    Widget Type: Time Series
    Data Source: Interface Statistics
    Metrics:
      - Ingress Bandwidth
      - Egress Bandwidth
    Time Range: Last 24 hours
    Aggregation: Average per 5 minutes
    ```

### Task 3: Configure Alerts

1. Navigate to **Alerts > Create Alert Rule**

2. Create a high CPU utilization alert:

    ```yaml
    Alert Name: High CPU Utilization
    Description: Alert when device CPU exceeds threshold
    
    Condition:
      Metric: system.cpu.utilization
      Operator: Greater than
      Threshold: 80%
      Duration: 5 minutes
    
    Severity: Warning
    
    Actions:
      - Send email to: netops@company.com
      - Create ticket in ServiceNow
      - Send webhook to Slack
    ```

3. Create an interface down alert:

    ```yaml
    Alert Name: Interface Down
    Description: Alert when critical interface goes down
    
    Condition:
      Metric: interface.oper_status
      Operator: Equals
      Value: down
      Filter: interface.name matches "Ethernet[1-4]"
    
    Severity: Critical
    
    Actions:
      - Send SMS to on-call engineer
      - Send email to: netops@company.com
      - Create high-priority ticket
    ```

4. Create an anomaly detection alert:

    ```yaml
    Alert Name: Traffic Anomaly Detected
    Description: Alert on unusual traffic patterns
    
    Condition:
      Type: Anomaly Detection
      Metric: interface.traffic.rate
      Baseline: Last 7 days
      Sensitivity: Medium
      Deviation: 3 standard deviations
    
    Severity: Info
    
    Actions:
      - Send email to: netops@company.com
      - Log to SIEM
    ```

### Task 4: Configure User Roles and Permissions

1. Navigate to **Settings > Users & Roles**

2. Create a custom role for network operators:

    ```yaml
    Role Name: Network Operator
    Description: Read-only access with dashboard creation
    
    Permissions:
      - View all dashboards: Yes
      - Create dashboards: Yes
      - Modify dashboards: Own only
      - View alerts: Yes
      - Acknowledge alerts: Yes
      - Configure alerts: No
      - View devices: Yes
      - Configure devices: No
      - View reports: Yes
      - Create reports: Yes
    ```

3. Assign users to roles:

    ```yaml
    User: john.doe@company.com
    Role: Network Operator
    Teams: Campus Network Team
    ```

### Task 5: Create Custom Reports

1. Navigate to **Reports > Create Report**

2. Create a weekly performance report:

    ```yaml
    Report Name: Weekly Network Performance
    Description: Summary of network performance metrics
    
    Report Type: Scheduled
    Schedule: Every Monday at 8:00 AM
    
    Sections:
      1. Executive Summary
         - Network health score
         - Total incidents
         - Mean time to resolution
      
      2. Device Performance
         - Average CPU utilization
         - Average memory utilization
         - Device availability %
      
      3. Traffic Analysis
         - Total bandwidth consumed
         - Top 10 applications
         - Traffic growth trend
      
      4. Incidents and Alerts
         - Alert summary by severity
         - Top 5 devices with most alerts
         - Resolution time analysis
    
    Format: PDF
    Recipients:
      - management@company.com
      - netops@company.com
    ```

3. Create an on-demand capacity planning report:

    ```yaml
    Report Name: Capacity Planning Analysis
    Description: Forecast network capacity needs
    
    Report Type: On-Demand
    
    Sections:
      1. Current Utilization
         - Interface utilization trends
         - Device resource usage
      
      2. Growth Analysis
         - Traffic growth rate (last 6 months)
         - Projected growth (next 6 months)
      
      3. Recommendations
         - Interfaces approaching capacity
         - Devices requiring upgrades
         - Suggested expansion timeline
    
    Time Range: Last 6 months
    Format: PDF + Excel
    ```

## Integration Configuration

### Task 6: Configure External Integrations

1. **Slack Integration**

    Navigate to **Settings > Integrations > Slack**
    
    ```yaml
    Webhook URL: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
    Channel: #network-alerts
    Events to Send:
      - Critical alerts
      - Device down
      - Configuration changes
    ```

2. **ServiceNow Integration**

    Navigate to **Settings > Integrations > ServiceNow**
    
    ```yaml
    Instance URL: https://yourcompany.service-now.com
    Username: vantage_integration
    Password: [encrypted]
    
    Ticket Creation Rules:
      - Critical alerts → Incident (Priority 1)
      - Warning alerts → Incident (Priority 3)
      - Info alerts → Event (No ticket)
    ```

3. **Syslog Export**

    Navigate to **Settings > Integrations > Syslog**
    
    ```yaml
    Syslog Server: 10.1.1.100
    Port: 514
    Protocol: UDP
    Facility: Local7
    
    Events to Export:
      - All alerts
      - Configuration changes
      - Authentication events
    ```

## Verification

### Verify Configuration

1. Test data collection:

    ```yaml
    Navigate to: Devices > [Select Device] > Telemetry
    Verify: Data is being received in real-time
    ```

2. Test dashboard:

    ```yaml
    Navigate to: Dashboards > Campus Network Overview
    Verify: All widgets display data correctly
    ```

3. Test alerts:

    ```yaml
    Navigate to: Alerts > Test Alert
    Select: High CPU Utilization alert
    Action: Send test notification
    Verify: Email/Slack notification received
    ```

4. Test report generation:

    ```yaml
    Navigate to: Reports > Weekly Network Performance
    Action: Generate Now
    Verify: Report generated successfully
    ```

## Best Practices

### Configuration Best Practices

- [ ] Start with pre-built dashboards and customize as needed
- [ ] Use meaningful names and descriptions for all objects
- [ ] Set appropriate alert thresholds to avoid alert fatigue
- [ ] Test alerts before enabling in production
- [ ] Document custom configurations
- [ ] Regular review and update of dashboards and alerts
- [ ] Use role-based access control (RBAC) appropriately

### Performance Optimization

- [ ] Adjust collection intervals based on requirements
- [ ] Use filters to reduce data volume
- [ ] Archive old data regularly
- [ ] Optimize dashboard queries
- [ ] Limit number of widgets per dashboard

## Next Steps

In the next lab (E-03), you'll learn about Vantage operations, including troubleshooting, optimization, and advanced analytics techniques.

## Summary

In this lab, you configured Arista Vantage for your monitoring needs, including data collection, custom dashboards, alerts, user roles, reports, and external integrations.

---

!!! success "Lab Complete"
    You have successfully completed the Vantage Configuration lab. Proceed to **E-03 - Vantage Operations** to continue.

