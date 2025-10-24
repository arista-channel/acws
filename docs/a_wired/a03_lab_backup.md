# BACKUP FILE - Created before GIF conversion
# Original file: docs/a_wired/a03_lab.md
# Backup created: $(date)

This is a backup of the original a03_lab.md file before converting MP4 references to GIF files.
The original content has been preserved in case rollback is needed.

To restore the original file:
1. Delete the current docs/a_wired/a03_lab.md
2. Copy this backup file content back to docs/a_wired/a03_lab.md
3. Remove this backup notice from the top

---

# A-03 | Switch Onboarding with Inventory Studio & Access Interface Configuration

## Overview

This lab combines two essential CloudVision workflows: onboarding switches using Inventory Studio and configuring access interfaces. You'll learn to use CloudVision's visual interface to add new devices and then configure port profiles for connected hosts.

!!! info "Lab Prerequisites"
    - Access to CloudVision Portal
    - Switches available for onboarding
    - Basic understanding of network topology

## Part 1: Inventory Studio - Switch Onboarding

### Step 1: Access Inventory Studio

Navigate to CloudVision Portal and access the Inventory Studio interface.

<video 
    width="100%" 
    height="auto" 
    controls 
    muted 
    loop
    preload="metadata"
    poster="../assets/demos/01_inventory_studio_poster.jpg"
    onerror="videoError()"
  >
    <source src="../assets/demos/01_inventory_studio.mp4" type="video/mp4">
    
    <!-- Fallback content -->
    <div style="background-color: #f5f5f5; padding: 20px; text-align: center; border: 1px solid #ddd;">
      <p><strong>Video not available</strong></p>
      <p>Please ensure your browser supports HTML5 video or check your network connection.</p>
    </div>
  </video>

### Detailed Steps:

1. **Login to CloudVision Portal**
   - Navigate to your CloudVision instance
   - Enter your credentials and authenticate

2. **Access Inventory Studio**
   - From the main dashboard, locate "Inventory Studio"
   - Click to enter the inventory management interface

3. **Prepare for Device Addition**
   - Review the current inventory status
   - Identify available slots for new devices
   - Ensure proper network connectivity for device discovery

## Part 2: Base Configuration

### Step 2: Configure Base Settings

Set up the fundamental configuration for your newly onboarded switches.

<video 
    width="100%" 
    height="auto" 
    controls 
    muted 
    loop
    preload="metadata"
    poster="../assets/demos/02_base_config_poster.jpg"
    onerror="videoError()"
  >
    <source src="../assets/demos/02_base_config.mp4" type="video/mp4">
    
    <!-- Fallback content -->
    <div style="background-color: #f5f5f5; padding: 20px; text-align: center; border: 1px solid #ddd;">
      <p><strong>Video not available</strong></p>
      <p>Please ensure your browser supports HTML5 video or check your network connection.</p>
    </div>
  </video>

### Configuration Steps:

1. **System Settings**
   - Configure hostname and domain settings
   - Set up NTP servers for time synchronization
   - Configure DNS servers for name resolution

2. **Management Interface**
   - Assign management IP addresses
   - Configure default gateway
   - Set up SNMP community strings

3. **User Authentication**
   - Create local user accounts
   - Configure AAA settings if applicable
   - Set up SSH access parameters

## Part 3: Campus Fabric Configuration

### Step 3: Campus Fabric Setup

Configure the campus fabric settings to integrate switches into the network topology.

<video 
    width="100%" 
    height="auto" 
    controls 
    muted 
    loop
    preload="metadata"
    poster="../assets/demos/03_campus_fabric_poster.jpg"
    onerror="videoError()"
  >
    <source src="../assets/demos/03_campus_fabric.mp4" type="video/mp4">
    
    <!-- Fallback content -->
    <div style="background-color: #f5f5f5; padding: 20px; text-align: center; border: 1px solid #ddd;">
      <p><strong>Video not available</strong></p>
      <p>Please ensure your browser supports HTML5 video or check your network connection.</p>
    </div>
  </video>

### Campus Fabric Steps:

1. **Fabric Topology**
   - Define the campus fabric architecture
   - Configure spine-leaf relationships
   - Set up MLAG pairs if applicable

2. **VLAN Configuration**
   - Create necessary VLANs for the campus
   - Configure VLAN assignments
   - Set up inter-VLAN routing

3. **Port Configuration**
   - Configure access ports for end devices
   - Set up trunk ports for inter-switch links
   - Apply appropriate port profiles

## Additional Configuration Tasks

### Access Interface Configuration

After completing the main onboarding process, configure access interfaces for connected devices:

1. **Port Profiles**
   - Create standardized port profiles
   - Define VLAN assignments
   - Configure security settings

2. **Device Connection**
   - Connect end devices to access ports
   - Verify connectivity and VLAN assignment
   - Test network access and functionality

3. **Monitoring and Verification**
   - Monitor port status and utilization
   - Verify proper VLAN assignment
   - Check for any configuration errors

## Troubleshooting

### Common Issues

**Device Discovery Problems**
- Verify network connectivity
- Check LLDP/CDP settings
- Ensure proper credentials

**Configuration Errors**
- Review syntax and formatting
- Check for conflicting settings
- Verify template compatibility

**Connectivity Issues**
- Test physical connections
- Verify VLAN configurations
- Check routing settings

## Best Practices

1. **Documentation**
   - Maintain accurate inventory records
   - Document configuration changes
   - Keep topology diagrams updated

2. **Security**
   - Use strong authentication
   - Implement proper access controls
   - Regular security audits

3. **Monitoring**
   - Set up proactive monitoring
   - Configure alerting thresholds
   - Regular performance reviews

## Conclusion

This lab demonstrates the complete workflow for onboarding switches using CloudVision's Inventory Studio and configuring essential access interface settings. The visual approach provided by CloudVision simplifies complex network operations while maintaining enterprise-grade functionality.

## Next Steps

- Explore advanced fabric configurations
- Implement additional security policies
- Set up automated compliance monitoring
- Configure advanced monitoring and alerting
