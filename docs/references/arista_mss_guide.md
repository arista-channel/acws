# Microperimeter Segmentation Using Multi-Domain Segmentation Service (MSS) for Zero Trust Networking

## Description

CloudVision provides support for microperimeter segmentation and enforcement as part of Arista's Multi-Domain Segmentation Service (MSS) for Zero Trust Networking (ZTN).

ZTN works to reduce lateral movement into increasingly smaller areas where workloads are granularly identified and only approved connections are permitted. In this way, microperimeter segmentation allows you to enhance network security by implementing fine-grained security policies based on microperimeters defined around the identity of endpoints or the applications, rather than on traditional network boundaries like subnets and VRFs. Microperimeters minimize the overall attack surface available at any endpoint, providing a better defense against lateral attacks.

### Three-Step MSS Process

The MSS implementation follows a three-step process:

1. **Building the Network Microperimeter**: CloudVision discovers dynamic groups using a range of data sources, including Arista's network identity service AGNI, VMWare's vCenter, configuration management databases (CMDBs) like ServiceNow, and CSV files. Through these integrations, CloudVision learns about endpoints and builds them into group member mappings that are stored in a CloudVision database.

2. **Monitoring and Policy Recommendations**: In monitoring mode, CloudVision mirrors network traffic to Arista's ZTX-7250S appliance. The ZTX node does stateful traffic analysis and sends session data back to CloudVision, where group member mappings are stored. Sessions are then mapped into group-to-group communication to produce a set of policy recommendations for users to review and audit.

3. **Policy Management and Enforcement**: Users create and manage security policies and push them to EOS devices for segmentation enforcement.

!!! note "Feature Prerequisites"
    To use CloudVision's MSS features, ensure that the Studios - MSS Studio and Network Security - MSS beta toggles are enabled in General Settings > Features.

## Overview

CloudVision enables you to manage, monitor, and provision your network from a single platform. Telemetry information is streamed in real-time from devices, giving you immediate feedback on the state of your network.

MSS brings microperimeter segmentation and enforcement to CloudVision. With new features like MSS Policy Manager, Policy Monitor, Policy Builder, and the MSS Studio, you'll have the tools to both statically map endpoints to groups or leverage integration with external asset- and endpoint-management databases to dynamically learn endpoints and how they map to groups.

### Key Components

- **MSS Policy Manager**: View and manage security policies and groups
- **MSS Policy Monitor**: Monitor policy statistics and traffic flows
- **MSS Policy Builder**: Generate and review policy recommendations
- **MSS Studio**: Configure security policies and microperimeter segmentation

## Getting Started

To get the most out of CloudVision's MSS monitoring and enforcement functionality, follow these essential steps:

1. [Onboard Devices](#onboard-devices)
2. [Define Static Groups and Policy Rules](#define-static-groups-and-policy-rules)
3. [Onboard Data Sources](#onboard-data-sources)
4. [Review Dynamic Groups](#review-dynamic-groups)
5. [Review Policy Recommendations](#review-policy-recommendations)

### Onboard Devices

Onboard 7280R3 and 7050X3/720/722-series EOS devices with MSS capability and the ZTX monitor node to configure microperimeter segmentation and enforcement through Arista's Multi-Domain Segmentation Service (MSS).

#### Steps

1. **Onboard Compatible Devices**
   - Onboard 7280R3 and 7050X3/720/722-series devices 
   - Onboard the ZTX monitor node

    !!! tip
        See Help Center guidance on device onboarding.

2. **Register Devices in Studios**

    !!! note
        If the End-to-End Provisioning toggle is enabled in General Settings > Features, newly-onboarded devices will automatically be registered for use in Studios.

   - Navigate to **Provisioning > Studios > Inventory and Topology Studio**
   - Click **Network Updates**
   - Enable the checkbox next to the onboarded device or devices
   - Click **Accept Updates**

You'll now be able to use these devices in the MSS Studio where you'll configure static security domain groups and security policy rules.

### Define Static Groups and Policy Rules

Once you've onboarded the monitoring appliance and any relevant EOS devices, you'll use the MSS Studio to define static groups by IP prefixes and create policy rules that govern how group traffic within a security domain is forwarded.

!!! note
    Ensure that you've accepted recently onboarded devices for use in Studios by accepting Network Updates in the Inventory and Topology Studio.

#### Example Scenario

The following example demonstrates the workflow applied to a security domain with 3 applications. These might be email clients, web browsers, or other software applications. Each application has 3 tiers (web, backend, and database), replicated in three environments: production, development, and certification.

We'll define groups for:
- **3 application groups** (purple)
- **3 tier groups** (blue) 
- **3 environment groups** (gray)

This creates a total of 9 address groups that we'll use in security policy rules for the domain.

#### Configuration Steps

1. **Create Workspace**
   - Click **Create a Workspace** or select an open workspace

2. **Configure Security Domain**
   - Under **Security Domains**, click **Add Security Domain**
   - Enter a title for the domain
   - Add devices by clicking the dropdown and selecting the security domain name
   - Select devices by name to add to the security domain

    !!! important
        - Devices are automatically tagged with the label:value pair `security-domain:<domain name>`
        - A device cannot belong to more than one security domain
        - The security domain includes all endpoints for which you want to configure security policy

    !!! tip "YAML Import"
        You can import a YAML file to autofill the MSS Studio inputs from a previous configuration. See MSS Studio for more details.

3. **Configure Static Groups**
   - Under **Static Groups**, click **Add Static Group**
   - Enter a title for the group
   - Click **View** to configure the IP prefixes
   - Click **Add Member** and enter an IP prefix

    !!! info "Prefix Formats"
        Prefixes can be entered in:
        - CIDR notation (e.g. `1.2.3.0/24`)
        - Range format (e.g. `1.2.3.4-2.3.4.5`)
        - Individual host specification

    !!! tip "Exception Lists"
        When configuring a group, you can create and enable an exception list of IP prefixes to exclude from membership. See MSS Studio for details.

4. **Configure Services**
   - Under **Services**, click **Add Service**
   - Enter a service name and configure:
     - **Protocol**: Select ICMP, TCP or UDP
     - **Ports**: Select All or enter specific values
       - Add a list or range of ports (0-65535) for TCP or UDP
       - Add a message type (0-255) for ICMP

5. **Configure Policies**
   - Under **Policies**, click **Add Policy**
   - Enter a policy name and optional description
   - Click **View** to define policy rules

    !!! info "Policy Definition"
        A policy is an ordered set of security rules that apply to a defined domain and VRF. CloudVision checks policy rules sequentially to determine the appropriate forwarding actions for matched traffic.

6. **Configure Policy Rules**
   - Click **Add New Rule**
   - Configure each rule with:
     - **Name**: Create a name to identify the rule
     - **Description**: Optional rule description
     - **Source**: Select the traffic source group
     - **Destination**: Select the traffic destination group
     - **Service**: Select the service to allow or restrict
     - **Action**: Select `forward` or `drop`
     - **Direction**: 
       - `Unidirectional`: Apply rule from source to destination only
       - `Bidirectional`: Apply rule in both directions

    !!! warning "Control Plane Traffic"
        Policy rules apply to control plane protocol messages in the security domain. Ensure that you've configured rules to permit such traffic to be forwarded appropriately.

7. **Configure Catchall Rule (Recommended)**
   - Create a catchall drop rule to handle rogue traffic:
     - **Name**: Create an identifying name
     - **Description**: Optional description
     - **Source**: Select `<any>`
     - **Destination**: Select `<any>`
     - **Service**: Select `<any>`
     - **Action**: Select `drop`
     - **Direction**: Select `bidirectional`

8. **Associate Policy with Domain**
   - Return to **Security Domains**
   - Use dropdowns to select the VRF and policy for the security domain
   - Typically, select the default VRF and the policy you've configured

9. **Submit Configuration**
   - Click **Review Workspace**
   - Once the workspace builds successfully, click **Submit Workspace**

    !!! info "Change Control"
        This creates a change request that must be approved and executed in Change Control. Once executed, the policy will be pushed to all devices in the security domain VRF.

## Onboard Data Sources

In addition to static groups created in the MSS Studio, CloudVision uses dynamic group discovery to help build the network microperimeter. Dynamic groups are created from various data sources:

- Arista's network identity service AGNI
- VMWare's vCenter
- Configuration management databases (CMDBs) like ServiceNow
- CSV files

### AGNI Integration

Onboard CloudVision AGNI, Arista's network identity management service, by collecting data from your AGNI cluster.

#### Prerequisites
- Access to AGNI cluster and tenant
- Organization ID from AGNI
- AGNI Event Notification application installed

#### Configuration Steps

1. **Gather AGNI Information**
   - Select the AGNI cluster and tenant
   - Note the Organization ID
   
    !!! tip
        Click "Copy Organization ID" below user data in the Profile section to copy the ID.

2. **Access AGNI Event Notification**
   - Click **Installed Apps** from the navigation bar
   - Open the **AGNI Event Notification** application
   
    !!! warning
        If the cluster is missing the application, contact the AGNI Team to have it installed.

3. **Generate API Credentials**
   - Click **Regenerate Token** and **Copy**
   - Click **Copy** to copy the API URL

4. **Configure in CloudVision**
   - Navigate to **Device Registration > Data Sources**
   - Click **Onboard via YAML File**
   - Click **Clear Device Configuration** to clear the sample YAML file

5. **Create AGNI YAML Configuration**

```yaml
- Type: AGNI
  Name: agni_tenant_2
  Sensor: default
  LogLevel: LOG_LEVEL_INFO
  Enabled: true
  Options:
    base_url: https://next.agnieng.net/api/
    org_id: E4e4e5b6a-247b-4b04-bb5e-228526e92498
    poll_interval: 30s
    device_id: agniCat
    trafficPolicy: true
  Credentials:
    auth_token: <token>
```

#### YAML Configuration Parameters

| Parameter | Description |
|-----------|-------------|
| `Type` | Must be `AGNI` |
| `Name` | Identifier for the source in Data Sources table |
| `Sensor` | Enter `default` to use the default sensor |
| `LogLevel` | Enter `LOG_LEVEL_INFO` |
| `Enabled` | Set to `true` |
| `base_url` | API URL copied from AGNI (up to and including `api/`) |
| `org_id` | Organization ID copied from AGNI |
| `poll_interval` | How often CloudVision retrieves data from AGNI |
| `device_id` | Device ID to identify the source in CloudVision |
| `trafficPolicy` | Enter `true` |
| `auth_token` | Token copied from AGNI |

6. **Complete Onboarding**
   - Click **Onboard**
   - Verify AGNI source appears in Data Sources table with green checkmark

### vCenter Integration

Onboard vCenter as a datasource for VMware environment integration.

#### Prerequisites
- VMware tools installed on relevant VMs
- vCenter access URL
- vCenter login credentials (username and password)

!!! note "Existing vCenter Integration"
    If you have already onboarded vCenter as a data source for CV-UNO, you'll need to edit the YAML file to include `trafficPolicy: true` to use the sensor for MSS. You may also optionally configure the `tpExcludeNetworks` field.

#### Configuration Steps

1. **Access Data Sources**
   - Navigate to **Device Registration > Data Sources**
   - Click **Onboard via YAML File**
   - Click **Clear Device Configuration**

2. **Create vCenter YAML Configuration**

```yaml
- Sensor: default
  Enabled: true
  Type: vCenter_v2
  Name: vcenter89
  Options:
    URL: https://example-vcenter89.yourcompany.com/sdk
    username: administrator@vsphere.local
    inventoryPollInterval: 5m
    tagsPollInterval: 2m
    statsPollInterval: 2m
    deviceID: vcenter89
    trafficPolicy: true
    tpExcludeNetworks: 172.32.157.0/16
  Credentials:
    password: <Vcenter-password>
```

#### YAML Configuration Parameters

| Parameter | Description |
|-----------|-------------|
| `Sensor` | Enter `default` to use the default sensor |
| `Enabled` | Enter `true` |
| `Type` | Enter `vCenter_v2` |
| `Name` | Name of the vCenter you're onboarding |
| `URL` | Access URL from your vCenter setup |
| `username` | Username from your vCenter setup |
| `inventoryPollInterval` | Frequency for retrieving inventory data (hosts, VMs, VDSs) |
| `tagsPollInterval` | Frequency for retrieving tag data |
| `statsPollInterval` | Frequency for collecting statistics (MSS doesn't use statistics) |
| `deviceID` | User-friendly device ID to identify the source |
| `trafficPolicy` | Enter `true` |
| `tpExcludeNetworks` | Optional IP addresses to exclude (e.g., management networks) |
| `password` | Password from your vCenter setup |

!!! warning "Password Handling"
    When you create and save the initial YAML file for onboarding vCenter, additional characters are added to the password string. If you change your vCenter password, you'll need to edit the file to remove the additional characters and enter the new password.

3. **Complete Onboarding**
   - Click **Onboard**
   - Verify vCenter source appears in Data Sources table with green checkmark

### CSV Integration

Onboard any database that exports data via CSV using SFTP.

#### Prerequisites
- SFTP location for CSV file transfer
- CSV file with proper column headings (up to 5 columns, `cat_1` is mandatory)

#### Configuration Steps

1. **Prepare CSV Information**
   - Note the SFTP location for CSV file transfer
   - Identify CSV column headings

2. **Access Data Sources**
   - Navigate to **Device Registration > Data Sources**
   - Click **Onboard via YAML File**
   - Click **Clear Device Configuration**

3. **Create CSV YAML Configuration**

```yaml
- Type: mss_csv
  Name: mssCSVFileWithEnvAppService
  Sensor: default
  LogLevel: LOG_LEVEL_INFO
  Enabled: true
  Options:
    device_id: cs22Feb
    poll_interval: 5m
    sftp_filename: CSVFiles/appEnv.csv
    sftp_host: cvp623
    sftp_username: root
    cat_1: Env
    cat_2: App
    cat_3: Service
    endpoint: Hostname
    ip_prefix: IP Prefix
  Credentials:
    sftp_password: xxxx
```

#### YAML Configuration Parameters

| Parameter | Description |
|-----------|-------------|
| `Type` | Enter `mss_csv` |
| `Name` | Identifier for the source in Data Sources table |
| `Sensor` | Enter `default` to use the default sensor |
| `LogLevel` | Enter `LOG_LEVEL_INFO` |
| `Enabled` | Enter `true` |
| `device_id` | Device ID to identify the source in CloudVision |
| `poll_interval` | Desired poll interval |
| `sftp_filename` | Source directory and filename for file transfer |
| `sftp_host` | Host that CloudVision will use to transfer the file |
| `sftp_username` | Username for SFTP credentials |
| `cat_1, cat_2, cat_3` | Category headings from the CSV file |
| `endpoint` | Optional column heading containing the hostname |
| `ip_prefix` | Column heading containing the IP prefix |
| `sftp_password` | Password for SFTP credentials |

4. **Complete Onboarding**
   - Click **Onboard**
   - Verify CSV sensor appears in Data Sources table with green checkmark

### Configuration Management Databases (CMDBs)

Onboard CMDBs like ServiceNow as a datasource by importing custom data storage tables.

#### Prerequisites
- CMDB table with relevant data
- CMDB login credentials
- Optional: IP Address Management service (IPAM) like Infoblox if CMDB doesn't contain IP Prefix column

#### ServiceNow Only Configuration

```yaml
- Type: mssdatasource
  Sensor: default
  Name: mssDataSourceAppService
  LogLevel: LOG_LEVEL_INFO
  Enabled: true
  Options:
    cmdb_colheadings: App,Service,Env
    cmdb_tablename: u_mssapptablewithip
    cmdb_type: ServiceNow
    cmdb_url: https://ven28231.service-now.com/api/now/table
    cmdb_endpoint: Hostname
    device_id: mssdts1
    ip_prefix: IPAddr
    poll_interval: 5m
  Credentials:
    cmdb_username: <username>
    cmdb_password: <password>
```

#### ServiceNow with InfoBlox Configuration

```yaml
- Type: mssdatasource
  Sensor: default
  Name: mssDataSourceAppService
  LogLevel: LOG_LEVEL_INFO
  Enabled: true
  Options:
    cmdb_colheadings: App,Service,Env
    cmdb_endpoint: Hostname
    cmdb_tablename: u_mssapptablewithip
    cmdb_type: ServiceNow
    cmdb_url: https://ven28231.service-now.com/api/now/table
    ipam_endpoint: hostname
    ipam_type: Infoblox
    ipam_url: https://10.120.1.104/wapi/v2.11/record:host
    device_id: mssdts1
    ip_prefix: IP Prefix
    poll_interval: 5m
  Credentials:
    cmdb_username: <username>
    cmdb_password: <password>
    ipam_username: <username>
    ipam_password: <password>
```

#### CMDB Configuration Parameters

| Parameter | Description |
|-----------|-------------|
| `Type` | Enter `mssdatasource` |
| `Sensor` | Enter `default` |
| `Name` | Identifier for the source in Data Sources table |
| `LogLevel` | Enter `LOG_LEVEL_INFO` |
| `Enabled` | Enter `true` |
| `cmdb_colheadings` | Column headings from ServiceNow table (comma-separated) |
| `cmdb_tablename` | Table name from ServiceNow |
| `cmdb_type` | Enter `ServiceNow` |
| `cmdb_url` | API URL format: `https://<sessionurl>/api/now/table` |
| `cmdb_endpoint` | Column heading containing hostname values |
| `device_id` | Device ID to identify the source |
| `ip_prefix` | Column containing IP prefix |
| `poll_interval` | How often CloudVision retrieves data |
| `ipam_endpoint` | (Infoblox) Column heading containing hostname values |
| `ipam_type` | Enter `Infoblox` |
| `ipam_url` | WAPI URL format: `https://<url>/wapi/v2.11/record:host` |

## Review Dynamic Groups

Once you've onboarded data sources to CloudVision, you can review dynamically-learned groups in the Policy Manager. Accepted groups will be available for use in configuring security policy rules.

### Review Process

1. **Access Group Review**
   - Navigate to **Network Security > MSS > Policy Manager > Groups**
   - Click **Review Groups**

2. **Select Groups**
   - Enable the checkbox next to any groups to accept
   - Groups not selected are categorized as "Ignored" and can be accepted later

    !!! tip "Group Details"
        - Clicking on any row allows you to view group members
        - Sort groups by data source or status (New, Ignored, or both)

3. **Submit Changes**
   - Click **Submit Changes**
   - Once validated, click **Finish** or **Configure Additional Inputs**

    !!! warning
        If validation fails, you'll have the option to manually review the changes.

4. **Verification**
   - Accepted groups appear in the Groups table in Policy Manager
   - Groups become available for configuring rules in the MSS Studio

!!! note "Alternative Method"
    You can perform the same workflow using the Review Dynamic Groups quick action in the MSS Studio.

## Review Policy Recommendations

Create a monitoring rule in the MSS Studio to mirror traffic to the monitoring node. This allows CloudVision to collect traffic sessions and generate policy rule recommendations.

### Create a Traffic Monitoring Rule

#### Configure Monitor Object

1. **Access MSS Studio**
   - Navigate to the MSS Studio
   - Create a new or open an unsubmitted workspace

2. **Create Monitor Object**
   - Under **Monitor Objects**, click **Add Monitor Object**
   - Configure the monitoring session parameters:

| Parameter | Description |
|-----------|-------------|
| **Name** | Name for the monitor object |
| **Monitor Node** | Select the monitoring appliance from dropdown |
| **Exporter Interface** | Local interface name for IPFIX export on monitor node |
| **Active Timeout** | IPFIX data timeout on monitor node (3,000 to 36,000,000 ms) |
| **Tunnel Destination IP** | Destination interface on monitor node for tunnel connection |
| **Tunnel Source Interface** | Interface name on ToR devices for tunnel connection |
| **Truncation** | Yes/No - whether mirrored packets are truncated |
| **Rate Limit** | Rate limit in mbps for mirroring packets |

!!! info "Truncation Benefits"
    Truncation increases throughput and reduces the amount of data that the monitor node needs for processing.

!!! important "Interface Consistency"
    An interface with the same name should exist on all ToR devices for tunnel connectivity.

#### Configure Monitoring Rule

3. **Create Monitoring Rule**
   - Under **Policies**, click **View** to edit existing policy rules
   - Click **Add New Rule**
   - Configure the monitoring rule:

| Parameter | Value |
|-----------|-------|
| **Name** | Create identifying name |
| **Description** | Optional description |
| **Source** | Select `<any>` |
| **Destination** | Select `<any>` |
| **Service** | Select `<any>` |
| **Action** | Select `forward` |
| **Direction** | Select `Bidirectional` |
| **Monitor Name** | Enter the monitor object name |

4. **Position Monitoring Rule**
   - Drag and drop the monitoring rule to be the first rule in the policy

    !!! important "Rule Order"
        Since CloudVision processes rules sequentially, this ensures no traffic is dropped by previous rules before analysis by the monitor node.

5. **Verify Domain Association**
   - Click **View** under the relevant domain in Security Domains
   - Verify the policy containing the monitoring rule appears in Domain Policies
   - If missing, click **Add Domain Policy** and enter the relevant VRF and policy name

6. **Finalize Configuration**
   - Click the action icon next to Security Domains to autofill hidden device and VFS mapping tables
   - Click **Review Workspace**
   - Click **Submit Workspace** once workspace builds successfully

!!! info "Result"
    After execution, any traffic in the security domain VRF from any source to any destination using any service will be mirrored to the monitoring node for stateful traffic analysis.

### Generate and Review Rules

Once the monitoring policy is enacted, the monitor node conducts stateful traffic analysis and sends session data back to CloudVision.

#### Access Policy Builder

1. **Navigate to Policy Builder**
   - Go to **Network Security > MSS > Policy Builder**
   - View all configured monitoring rules

#### Monitoring Rule States

| State | Description |
|-------|-------------|
| **Collecting Sessions** | CloudVision is collecting sessions via monitoring node |
| **Generating Rules** | CloudVision is mapping sessions to group-to-group communication |
| **Review Rules** | Rules are ready for review and can be accepted, edited, or rejected |
| **Completed** | Policy recommendations have been reviewed and decisions made |

!!! tip "View Completed Rules"
    Monitoring rules marked as completed are hidden by default but can be viewed by enabling the "Show Completed" toggle.

#### Generate Policy Rules

2. **Initiate Rule Generation**
   - Click on a monitoring rule where sessions are collecting
   - Click **Generate Rules**

    !!! note "Session Collection"
        - The monitor node continues collecting sessions until the rule is deleted from the domain policy
        - Generate Rules button is enabled once a single session is collected
        - View elapsed time under the Policy tab and sessions under Collected Sessions tab

3. **Select Categories**
   - Enable checkboxes for relevant categories to generate security policy rules
   - Categories and group names are learned from onboarded data sources

    !!! tip "View Category Details"
        Clicking on a row in the Generate Rules modal enables you to view the address groups included in the category.

4. **Generate Rules**
   - Click **Generate**

    !!! info "Processing Time"
        On average it takes 5-10 minutes for CloudVision to generate security policy rules, but could take longer.

#### Review and Submit Rules

5. **Review Generated Rules**
   - Once rules are generated, they appear on screen
   - If you navigated away, click the rule in the Monitoring Rules table when "Review rules" appears

6. **Edit Rules (if needed)**
   - Use available dropdowns and icons to remove or edit rule recommendations
   - Drag and drop rules to reorder
   - Some rules may require you to select appropriate service, action, or direction

    !!! info "Rule Management Icons"
        - Reset changes icon
        - Regenerate rules icon (to change categories)

7. **Submit or Archive**
   - **Submit Rules**: Creates auto-approved and auto-executed change control
   - **Archive**: Mark rule as Completed and store it (archived rules are viewable but not actionable)

!!! success "Final Result"
    Submitted rules push new configuration to devices in the security domain VRF.

## CloudVision Features

As part of Arista's Multi-Domain Segmentation Service (MSS), a new suite of tools has been added to CloudVision for microperimeter segmentation and enforcement.

### MSS Dashboard

The MSS dashboard provides an at-a-glance overview of your network security domain(s) with the following panels:

#### Group Sources
- Displays streaming status of data sources for dynamic group discovery
- Click "View in Devices" to see data source details under Device Registration

#### Monitoring Nodes
- Shows streaming status of onboarded monitoring nodes
- Click "View in Policy Builder" to view monitoring rule status

#### MSS Devices
- View device capacity for devices tagged with `security-domain:` label
- Device capacity represents the chip with highest utilization, not average across all chips
- Click "View in MSS Domains" for detailed LPML and TCAM utilization

#### Events
- Displays events for devices with `security-domain:` tag or streaming traffic-policy configurations
- Filter events by severity using severity icons
- Click "View in Events" for further details

#### Topology View
- Visual topology of devices tagged with `security-domain:` label
- Zoom, expand, or collapse using topology controls

#### Recent Logs
- Highlights changes to static and dynamically-learned groups
- Shows 50 most recent changes from the last 7 days

#### Policy Monitor
- Provides packet and byte counts for security policy rules pushed to devices
- Counters show traffic across all VRFs where the rule is applied
- Click device names to access Inventory, policy/rule/domain names to access Policy Manager

### MSS Policy Manager

Policy Manager allows you to view and manage security domain policies through five main tables:

#### Domains Table
- Lists devices from CloudVision inventory
- Shows LPML and TCAM utilization rates (percentage and count)
- Utilization represents the chip with highest utilization
- Assigned devices show domain name, unassigned show "Unassigned"
- ZTX monitor appliances show as "Unassigned"

#### Policies Table
- Lists security policies configured in MSS Studio
- Shows number of devices and rules in each policy
- Policies can be "Assigned" or "Unassigned"
- Filter by security domain, VRF, and assignment status

#### Rules Table
- Shows all security policy and monitoring rules
- Includes both statically configured and recommended rules
- Filter by security policy and forwarding action
- Click rows to view detailed policy objects and security policies

#### Groups Table
- Lists all groups (static and dynamic)
- Shows group source, category, and member count
- Groups can be "Active" (used in policies) or "Accepted" (not used)
- Filter by group source and category

#### Policy Objects Table
- Lists policy building blocks:
  - Destination IP groups
  - Source IP groups
  - Services
  - Traffic monitors
- Shows object type, details, and policy usage count

### MSS Policy Monitor

View policy statistics including packet and byte counts for security policies pushed to devices.

**Features:**
- Filter by device name, security domain, source, destination, rule, or traffic counts
- Counters show traffic across all VRFs where traffic policy is applied
- Click policy/rule/domain names to access Policy Manager
- Click device names to access Device Inventory

### MSS Policy Builder

Generate and review security policy recommendations based on stateful traffic analysis.

#### Monitoring Rules Management

**Rule States:**
- **Collecting Sessions**: Collecting traffic data
- **Generating Rules**: Processing session data
- **Review Rules**: Ready for user review
- **Completed**: Decisions made (hidden by default)

**Features:**
- View monitoring rule details and progress
- Edit rule names
- View collected session statistics
- Monitor session collection duration

#### Rule Generation Process

1. **Session Collection**: Monitor node analyzes traffic patterns
2. **Category Selection**: Choose categories for rule generation based on data sources
3. **Rule Generation**: CloudVision maps sessions to group-to-group communication
4. **Review and Edit**: Modify recommendations as needed
5. **Submit or Archive**: Deploy rules or save for later review

### MSS Studio

The MSS Studio is the primary interface for creating device configuration for microperimeter segmentation and enforcement.

#### Core Functions

**Security Policy Creation:**
- Define security domains and associate devices
- Create static groups with IP prefixes
- Configure services (Layer 4 ports, Layer 7 application IDs)
- Build policy rules governing group communication

**Traffic Monitoring Setup:**
- Define monitor objects for ZTX-7250S appliance
- Configure monitoring rules for traffic analysis
- Enable policy recommendation generation

**Dynamic Group Integration:**
- Review dynamically-learned groups from data sources
- Accept groups for use in security policies
- Quick actions for streamlined workflows

#### Key Features

- **YAML Import/Export**: Save and reuse configurations
- **Exception Lists**: Exclude specific IP prefixes from groups
- **Rule Ordering**: Drag-and-drop rule prioritization
- **Workspace Management**: Create, review, and submit changes
- **Change Control Integration**: Automated approval and execution workflows

!!! tip "Best Practices"
    - Always include a catchall drop rule at the end of policy rules
    - Position monitoring rules first to ensure traffic capture
    - Consider control plane traffic requirements when designing policies
    - Use exception lists carefully as they're not used in monitoring or dashboard features

---

*Copyright 2025 Arista Networks, Inc. The information contained herein is subject to change without notice. Arista, the Arista logo and EOS are trademarks of Arista Networks.*