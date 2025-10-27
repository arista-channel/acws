# Arista Campus Workshop
<!-- CI/CD Refresh: 2025-10-27 14:50:58 -->
Welcome to our Arista hands-on campus workshop! 🚀

<!-- CI/CD Test: Updated at $(date) -->

Welcome to an immersive exploration of Arista's comprehensive campus networking solutions. This intensive workshop provides hands-on experience with enterprise-grade hardware and software platforms deployed in production environments worldwide.

Our carefully structured lab exercises mirror real-world implementation scenarios, enabling you to develop practical expertise across the complete campus network lifecycle. From initial device provisioning and configuration management to advanced network operations and client connectivity troubleshooting, each module builds upon foundational concepts while introducing industry best practices.

Through direct interaction with Arista's CloudVision platform, EOS operating system, and integrated campus solutions, you'll gain the technical proficiency and operational confidence essential for successful enterprise network deployments.

<div class="hero-banner">
    <div class="hero-container">

        <div class="hero-background"></div>

        <div class="hero-decorations">
            <div class="switch-element switch-1"></div>
            <div class="switch-element switch-2"></div>
            <div class="switch-element switch-3"></div>
        </div>

        <div class="hero-lines">
            <div class="pulse-line line-1"></div>
            <div class="pulse-line line-2"></div>
            <div class="pulse-line line-3"></div>
        </div>

        <div class="hero-badge">
            Hands-On Experience
        </div>

        <div class="hero-content">
            <div class="hero-brand">ARISTA</div>
            <h1 class="hero-title">Campus Workshop</h1>
            <p class="hero-subtitle">Master Modern Campus Networking Solutions<br class="hero-break">Real Hardware • Real Scenarios • Real Results</p>

            <div class="solutions-grid">
                <div class="solution-card">
                    <div class="solution-icon">🔌</div>
                    <div class="solution-title">Wired Solutions</div>
                    <div class="solution-desc">EOS, ZTP, CloudVision Studios</div>
                </div>

                <div class="solution-card">
                    <div class="solution-icon">📡</div>
                    <div class="solution-title">Wireless Edge</div>
                    <div class="solution-desc">CV-CUE, WiFi 6E/7, AGNI</div>
                </div>

                <div class="solution-card">
                    <div class="solution-icon">🛡️</div>
                    <div class="solution-title">Security</div>
                    <div class="solution-desc">EAP-TLS, UPSK, Zero Trust</div>
                </div>

                <div class="solution-card">
                    <div class="solution-icon">📊</div>
                    <div class="solution-title">Observability</div>
                    <div class="solution-desc">Monitoring, Analytics, AI Insights</div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="grid cards" markdown>

- :material-file-document-multiple:{ .lg .middle } **Lab Access**

    ---

    Your instructor will guide you with more details, but feel free to jump right in and understand what you have in front of you!

    [:material-login: Let's get started!](./lab/access.md){ .md-button .md-button--primary }

</div>

## :material-router-network: Wired Guides

<div class="grid cards" markdown>

- :material-cloud: **A01-Lab: Explore EOS**

    ---

    Get familiar with Arista's Extensible Operating System using the CLI

    [:material-login: Hop into A-01](./a_wired/a01_lab.md){ .md-button .md-button--primary }

<!-- - :material-cloud: **A02-Lab: Day 1 Operations**

    ---

    Get started with onboarding new Arista EOS switches using ZTP, CloudVision, and our Campus Studios.

    [:material-login: Hop into A-02](./a_wired/a02_lab.md){ .md-button .md-button--primary } -->

- :material-cloud: **A02-ATD-Lab: Day 1 Operations - Virtual Lab**

    ---

    Experience campus fabric provisioning using Arista Test Drive (ATD) virtual lab environment with CloudVision Studios.

    [:material-login: Hop into A-02-ATD](./a_wired/a02_atd.md){ .md-button .md-button--primary }

- :material-cloud: **A03-Lab: Day 2 Operations**

    ---

    Continue with day 2 operations, using CloudVision to manage campus port profiles, access port configuration, and streamlined task execution.

    [:material-login: Hop into A-03](./a_wired/a03_lab.md){ .md-button .md-button--primary }

- :material-cloud: **A04-Lab: Operations and Monitoring**

    ---

    The campus is deployed, explore the CloudVision observability, altering, troubleshooting, and more!

    [:material-login: Hop into A-04](./a_wired/a04_lab.md){ .md-button .md-button--primary }

</div>

## :material-wifi: Wireless Guides

<div class="grid cards" markdown>

- :material-cloud: **B01-Lab: Wireless Setup**

    ---

    Deploy and explore the features of CloudVision Cognitive Unified Edge (CV-CUE)

    [:material-login: Hop into B-01](./b_wireless/b01_lab.md){ .md-button .md-button--primary }

- :material-cloud: **B02-Lab: Troubleshooting WiFi**

    ---

    Explore the wireless client troubleshooting tools like packet capture and client testing

    [:material-login: Hop into B-02](./b_wireless/b02_lab.md){ .md-button .md-button--primary }

- :material-cloud: **B03-Lab: Guest WiFi with AGNI**

    ---

    Configure a guest WiFi SSID with a captive guest portal and tunnel wireless traffic

    [:material-login: Hop into B-03](./b_wireless/b03_lab.md){ .md-button .md-button--primary }

- :material-cloud: **B04-Lab: Smart System Upgrade**

    ---

    Using Arista EOS Smart System Upgrade (SSU) we can avoid downtime when upgrading our wired network!

    [:material-login: Hop into B-04](./b_wireless/b04_lab.md){ .md-button .md-button--primary }

</div>

## :material-security: Security Guides

<div class="grid cards" markdown>

- :material-cloud: **C01-Lab: EAP-TLS Wireless Policy**

    ---

    Use Arista AGNI to enforce wireless access via dot1x EAP-TLS policy on a given SSID

    [:material-login: Hop into C-01](./c_security/c01_lab.md){ .md-button .md-button--primary }

- :material-cloud: **C02-Lab: UPSK Wireless Policy**

    ---

    Configure unique pre-shared keys for an SSID and get familiar with device groupings

    [:material-login: Hop into C-02](./c_security/c02_lab.md){ .md-button .md-button--primary }

- :material-cloud: **C03-Lab: EAP-TLS Wired Policy**

    ---

    Using Arista AGNI to enforce wired access via dot1x EAP-TLS policy

    [:material-login: Hop into C-03](./c_security/c03_lab.md){ .md-button .md-button--primary }

<!-- - :material-cloud: **C04-Lab: Multi-Domain Segmentation Services**

    ---

    Using Arista Multi-Domain Segmentation Services (MSS) for standards-based, non-proprietary, intelligent and dynamic network segmentation

    [:material-login: Hop into C-04](./references/under_constructions.md){ .md-button .md-button--primary } -->

<!-- - :material-cloud: **C05-Lab: Network Detect and Response (NDR)**

    ---

    Using Arista NDR to detect and respond to network anomolous behavior and unauthorized acces

    [:material-login: Hop into C-05](./references/under_constructions.md){ .md-button .md-button--primary } -->

</div>

<!-- ## :material-eye-outline: Network Observability

<div class="grid cards" markdown>

- :material-cloud: **O01-Lab: Universal Network Observability with CloudVision**

    ---

    Use CloudVision to monitor and troubleshoot your network

    [:material-login: Hop into O-01](./references/under_constructions.md){ .md-button .md-button--primary }

</div> -->

## :material-tools: Tools For The Job

<div class="grid cards" markdown>

- :material-cloud: **D01-Lab: Iris Design, Configuration and Pricing**

    ---

    Use Intangi Iris to design, configurre and price Arista campus products and solutions

    [:material-login: Hop into D-01](./references/config_tools.md){ .md-button .md-button--primary }

<!-- - :material-cloud: **D02-Lab: AROC**

    ---

    Use Arista Order and Configuration (AROC) to create bill of materials

    [:material-login: Hop into D-02](./references/under_constructions.md){ .md-button .md-button--primary }

- :material-cloud: **D03-Lab: CPQ**

    ---

    Use Configure Price Quote (CPQ) to quote Arista approved BOMs

    [:material-login: Hop into D-03](./references/under_constructions.md){ .md-button .md-button--primary } -->

</div>