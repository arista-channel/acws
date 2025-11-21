# E-01 | Vantage Overview

## Overview

In this lab, you'll learn about Arista Vantage Professional Services, an in-house developed application suite designed to generate a variety of deliverables for Arista Professional Services and channel partners. Vantage streamlines the delivery process of projects and delivers consistent artifacts efficiently, allowing users to input minimum data and generate documents, configurations, and the whole deployment pipeline.

## Learning Objectives

By the end of this lab, you will be able to:

- Understand Arista Vantage Professional Services platform and its purpose
- Navigate the Vantage user interface
- Generate solution designs and knowledge transfer (KT) slides
- Create baseline AVD (Arista Validated Designs) repositories for L2LS and L3LS designs
- Understand the deployment pipeline automation for DC and Campus networks
- Explore the benefits of streamlined project delivery

## Lab Topology

!!! info "Lab Environment"
    This lab uses the Vantage Professional Services platform to generate:

    - **Solution Design Documents**: Comprehensive network design documentation
    - **Knowledge Transfer Slides**: Project handoff presentations
    - **AVD Repositories**: Baseline configurations for L2LS and L3LS topologies
    - **GitLab Integration**: Pre-configured CI/CD pipelines for deployment automation

## Prerequisites

Before starting this lab, ensure you have:

- [ ] Access to Vantage portal
- [ ] Basic understanding of network concepts
- [ ] Familiarity with Arista CloudVision

## What is Arista Vantage Professional Services?

### Platform Overview

Arista Vantage Professional Services is an in-house developed application suite designed to streamline the delivery process of network projects and deliver consistent artifacts efficiently. The platform enables users to input minimum data and automatically generate:

- **Solution Design Documents**: Comprehensive technical design documentation
- **Knowledge Transfer (KT) Slides**: Professional presentation materials for project handoff
- **Baseline AVD Repositories**: Pre-configured Arista Validated Designs for L2LS and L3LS topologies
- **Deployment Pipelines**: Complete CI/CD automation hosted on GitLab
- **Configuration Files**: Ready-to-deploy network configurations

### Key Components

1. **Input Interface**
   - Simplified data entry forms
   - Topology designer
   - Design parameter selection
   - Template customization options

2. **Document Generation Engine**
   - Solution design document creation
   - Knowledge transfer slide generation
   - Bill of materials (BOM) generation
   - Network diagrams and topology visualization

3. **AVD Repository Generator**
   - L2LS (Layer 2 Leaf-Spine) baseline configurations
   - L3LS (Layer 3 Leaf-Spine) baseline configurations
   - Data Center fabric designs
   - Campus network designs
   - GitLab repository creation with pre-configured pipelines

4. **Deployment Automation**
   - CI/CD pipeline configuration
   - Automated validation and testing
   - Configuration deployment workflows
   - Version control integration

## Getting Started

### Step 1: Access Vantage Portal

1. Login to Arista Vantage Professional Services platform using the provided credentials:

    ```yaml
    URL: https://vantage.arista.com
    Username: student#
    Password: Arista123
    ```

2. Upon login, you'll see the main dashboard with:
   - Project creation wizard
   - Recent projects and deliverables
   - Template library
   - Quick start guides

### Step 2: Navigate the User Interface

1. **Project Dashboard**
   - Overview of active projects
   - Project status and progress
   - Recent deliverables generated
   - Team collaboration tools

2. **Design Input Section**
   - Network topology designer
   - Design parameter forms
   - Device selection and configuration
   - Naming conventions and standards

3. **Document Generation**
   - Solution design templates
   - Knowledge transfer slide templates
   - Custom branding options
   - Export and download options

4. **AVD Repository Manager**
   - L2LS design templates
   - L3LS design templates
   - GitLab integration settings
   - Pipeline configuration options

### Step 3: Create Your First Project

1. Navigate to **Projects > New Project**

2. Enter project details:
   - Project name and description
   - Customer information
   - Network topology type (DC or Campus)
   - Design architecture (L2LS or L3LS)

3. Input minimum required data:
   - Number of spine switches
   - Number of leaf switches
   - IP addressing scheme
   - VLAN/VRF requirements

## Vantage Features

### Document Generation

1. **Solution Design Documents**

    Automatically generates comprehensive design documentation including:
    - Executive summary
    - Network architecture diagrams
    - Design rationale and best practices
    - Hardware and software specifications
    - IP addressing and VLAN schemes
    - Security and QoS policies
    - Implementation timeline

2. **Knowledge Transfer Slides**

    Creates professional presentation materials for:
    - Project overview and objectives
    - Network topology and architecture
    - Configuration highlights
    - Operational procedures
    - Troubleshooting guides
    - Handoff documentation

### AVD Repository Generation

1. **L2LS (Layer 2 Leaf-Spine) Designs**
   - Campus network topologies
   - Access-distribution-core architectures
   - VLAN-based segmentation
   - MLAG configurations
   - Port profiles and templates

2. **L3LS (Layer 3 Leaf-Spine) Designs**
   - Data center fabric topologies
   - BGP EVPN/VXLAN overlays
   - Multi-tenancy with VRFs
   - Anycast gateway configurations
   - Spine-leaf routing protocols

3. **GitLab Integration**
   - Automated repository creation
   - Pre-configured CI/CD pipelines
   - Ansible playbook integration
   - Configuration validation workflows
   - Deployment automation scripts

## Lab Tasks

!!! note "Task 1: Create a New Project"
    Create your first Vantage project:

    - [ ] Navigate to Projects > New Project
    - [ ] Enter project name: "Campus Network Design - Student#"
    - [ ] Select topology type: Campus
    - [ ] Select design architecture: L2LS
    - [ ] Save project

!!! note "Task 2: Input Design Parameters"
    Enter the minimum required data for your design:

    - [ ] Number of spine switches: 2
    - [ ] Number of leaf switches: 4
    - [ ] Management IP range: 10.1.100.0/24
    - [ ] Loopback IP range: 10.1.0.0/24
    - [ ] VLAN range: 100-199

!!! note "Task 3: Generate Deliverables"
    Generate project deliverables:

    - [ ] Click "Generate Solution Design"
    - [ ] Review the generated design document
    - [ ] Click "Generate KT Slides"
    - [ ] Download the presentation
    - [ ] Click "Create AVD Repository"
    - [ ] Review the GitLab repository URL

## Use Cases

### Professional Services Delivery

- **Consistent Deliverables**: Standardized documentation across all projects
- **Rapid Project Deployment**: Reduce design and documentation time by 70%
- **Quality Assurance**: Pre-validated configurations and best practices
- **Customer Satisfaction**: Professional, comprehensive project deliverables

### Channel Partner Enablement

- **Self-Service Design**: Partners can generate designs independently
- **Reduced Training Time**: Simplified interface requires minimal training
- **Scalable Delivery**: Handle more projects with the same resources
- **Brand Consistency**: Maintain Arista standards across all partner deliverables

## Benefits

### Time Efficiency

- **70% Faster Documentation**: Automated generation vs. manual creation
- **Instant AVD Repository**: Pre-configured baseline in minutes
- **Rapid Deployment**: GitLab pipelines ready to use immediately
- **Reduced Errors**: Automated validation and consistency checks

### Quality and Consistency

- **Standardized Deliverables**: Every project follows best practices
- **Professional Documentation**: Polished, customer-ready materials
- **Validated Configurations**: Pre-tested AVD designs
- **Version Control**: All artifacts tracked in GitLab

### Business Impact

- **Increased Project Capacity**: Deliver more projects with same resources
- **Higher Margins**: Reduced labor costs for documentation
- **Customer Satisfaction**: Faster delivery with higher quality
- **Competitive Advantage**: Professional deliverables differentiate your services

## Next Steps

In the next lab (E-02), you'll learn how to customize Vantage templates, configure advanced design parameters, and integrate with your organization's GitLab instance.

## Additional Resources

- [Arista Validated Designs (AVD) Documentation](https://avd.arista.com)
- [Arista Professional Services](https://www.arista.com/en/services)
- [GitLab CI/CD Integration Guide](https://docs.gitlab.com/ee/ci/)
- [Arista Campus Design Guides](https://www.arista.com/en/solutions/campus)

## Summary

In this lab, you explored Arista Vantage Professional Services, an in-house developed platform that streamlines project delivery by automatically generating solution designs, knowledge transfer slides, and baseline AVD repositories for L2LS and L3LS network designs. You learned how Vantage enables efficient, consistent, and professional deliverables for both Arista Professional Services and channel partners.

---

!!! success "Lab Complete"
    You have successfully completed the Vantage Overview lab. Proceed to **E-02 - Vantage Configuration** to continue your learning journey.
