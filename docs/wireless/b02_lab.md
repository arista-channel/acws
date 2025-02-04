# B-02 | Guest Wireless & WIPS

## Overview

--8<--
docs/snippets/login_agni.md
--8<--

## Create an AGNI Guest Captive Portal

1. Next, we’ll configure a Guest Captive Portal using AGNI for wireless clients. To configure the guest portal, you must configure both AGNI and CV-CUE.
2. Navigate to `Identity > Guest > Portals`.
3. Click `+ Add Guest` Portal
4. In the `Configuration` tab, provide the portal name (A/B-Portal)
5. Leave the `Authentication` Type as `Clickthrough`.
6. Click the Customization tab to customize the portal settings, and notice the elements.
      - [x] Page
      - [x] Login Toggle
      - [x] Terms of Use and Privacy Policy
      - [x] Logo
      - [x] Guest Login Submit Button
      - [x] Etc
7. When done, click `Add Guest Portal`. The portal gets listed in the portal listing.
8. Click `Back`
9. Navigate to the `Access Control > Networks`.
10. Add a new network with following settings:

    ???+ example "Network Settings"
        | key                                     |              Student 1               |              Student 2               |
        | --------------------------------------- | :----------------------------------: | :----------------------------------: |
        | Name                                    |               A-GUEST                |               B-GUEST                |
        | Connection Type                         |               Wireless               |               Wireless               |
        | SSID                                    | Guest SSID in CV-CUE (ATD-##A-GUEST) | Guest SSID in CV-CUE (ATD-##B-GUEST) |
        | Authentication Type                     |            Captive Portal            |            Captive Portal            |
        | Captive Portal Type                     |               Internal               |               Internal               |
        | Select Internal Portal                  |               A-Portal               |               B-Portal               |
        | Internal Role for Portal Authentication |         Type “Portal A Role”         |         Type “Portal B Role”         |

11. Click `Add Network`.
12. Copy the portal URL at the bottom of the page.

--8<--
docs/snippets/login_cvcue.md
--8<--

## Configuring CV-CUE

1. In CV-CUE, configure a role profile and the SSID settings. Ensure that the SSID is enabled for the captive portal with redirection to the portal URL.
2. Configuring Portal and Guest Role Profiles
3. Portal Role Profile
4. Log in to CV-CUE and navigate to `Configure > Network Profiles > Role Profile`.
5. Add Role Profile.
6. Add the Role Name as Portal A Role/Portal B Role.
7. Enable the Redirection check box and select Static Redirection.
8. In the Redirect URL field, add the portal URL that you have copied from AGNI.
9. Click SAVE at the bottom of the page.

    !!! note "Information"

        The Guest Role and Wireless-Guest-CP Segment are not required for Click Through Guest Access. If users are required to create a guest account or receive approval, then the Guest Role and Wireless-Guest-CP Segment are required.

!!! danger "NOT REQUIRED"

    The sections below with `***` preceding the section are not required for Click Through Guest Access.

### Guest Role Profile

1. Next, we’ll configure a Guest Role in CV-CUE to assign to Guest Users post authentication.
2. In CV-CUE, navigate to Configure > Network Profiles > Role Profile.
3. Add Role Profile.
4. Add the Role Name as Guest Role.
5. Select the check box next to VLAN.
6. Click `Save` at the bottom of the page

#### Additional Information

<div class="grid cards" markdown>

- :material-access-point:{ .lg .middle } **VLAN**

    ---

    In this lab the VLAN is set to 0. In production networks you would define the Guest VLAN ID or Name that you want to assign to the Guest Users.

- :material-access-point:{ .lg .middle } **Firewall**

    ---

    Layer 3-4 and Application Firewall Rules can be assigned to the Guest User Role.

- :material-access-point:{ .lg .middle } **User Bandwidth Control**

    ---

    Upload and Download Bandwidth Limits can be assigned to the Guest User Role.

</div>

### Configure AGNI Wireless-Guest-CP Segment

1. Next, we’ll configure a Segment in AGNI to assign the Guest Role Profile post authentication.
2. Go back to AGNI and navigate to the Access Control > Segments.
3. Add a new Segment with following settings:
4. Name - ATD-##A/B-GUEST
5. Conditions - Network Name is Wireless-Guest-CP
6. Actions - Arista-WiFi - Role Profile - Guest Role
7. Click on Segments and then `+ Add Segment`
8. Next, type in the name:  `ATD-##A/B-GUEST`.
9. Next, let’s Add Conditions

    !!! note "Adding more than one condition means MATCH ALL"

10. Select, Network, Name, Is, ATD-##A/B-GUEST from the drop down lists.
11. Under Actions select Add Action.
12. Select, Arista-WiFi - Role Profile - Type Guest A/B Role
13. Finally, select Add Segment at the bottom of the page.
14. Your Conditions should now look like this.
15. Finally, select Add Segment at the bottom of the page.

### Configuring the Guest Captive Portal SSID

1. Next we’ll configure the Guest Captive Portal SSID and assign the pre and post authentication roles.
2. Select Correct location `ACorp` or  `BCorp`
3. Navigate to `Configure > WiFi`
4. `Add SSID`

    ??? example "Wifi Settings"
        | Setting   |       Value       |
        | --------- | :---------------: |
        | SSID Name | `ATD-##A/B-GUEST` |
        | SSID Type |      Private      |

5. Click the 3 dotsClick the Access Control tab.
6. Enable the Client Authentication check box and select RADIUS MAC Authentication.
7. Select RadSec
8. Authentication Server - AGNI-XX
9. Accounting Server - AGNI-XX
10. Select AGNI for the Authentication and Accounting servers, and select the check box next to Send DHCP Options and HTTP User Agent.
11. Select the Role Based Control checkbox and configure the following settings:
12. Rule Type — 802.1X Default VSA
13. Operand — Match
14. Assign Role — Select All. You created the Portal and Guest Roles profile in the previous section.

### Save & Turn SSID On 5Ghz only

Once you are done, connect your phone to this SSID and select Connect from the Captive Portal page. The clients get connected and authenticated via the portal authentication.

1. Verify connectivity in CUE and AGNI
2. CUE in Monitor>Clients
3. AGNI in Session
4. Lab section complete.

## WIPS Wireless Intrusion Prevention System

Arista Wireless Intrusion Prevention System (WIPS) leverages RF broadcast and protocol properties including packet formats like probe requests and beacons common to all 802.11 standards(including 802.11ac and 802.11ax) to detect and prevent unauthorized access.

!!! info "More Information"

    For more information about how Arista’s WIPS feature works, refer to this whitepaper: https://www.arista.com/assets/data/pdf/Whitepapers/Arista-Marker-Packet-Whitepaper.pdf

Wi-Fi threats include an ever changing landscape of vulnerabilities, such as:

- Rogue APs
- Unauthorized BYOD Client
- Misconfigured APs
- Client misassociation
- Unauthorized association
- Ad-hoc connections
- Honeypot AP or evil twin “Pineapple”
- AP MAC spoofing
- DoS attack
- Bridging client

### Configure WIPS

Let's go ahead and configure WIPS on our Access Point

1. In the menu on the left hand side of the screen, hover your cursor over “Monitor” and then click “WIPS”.  Now click on “Access Points” and “Clients” in the menu at the top of the screen and explore if any Rogue APs or Clients are connected to other APs in the area.
2. Access points that have been detected by WIPS but are not managed within Arista CV-CUE, they are designated as Rogue or External Access Points.
3. Next, let’s explore the information we can gather about the wireless environment using Arista’s WIPS.
4. Select Monitor,  WIPS:
5. In the simple lab environment, only your pod’s single AP is part of your managed wireless infrastructure. All of the other access points and clients on the network are like crowded neighbors or businesses in a shared office work space.
6. Under Monitor, WIPS, Access Points you can see all of the detected Rogue Access points. From this screen you can reclassify, set auto-prevention, add to ban list, name or move the AP.
7. Additional information about WIPS AP classification can be found here:
8. https://www.arista.com/en/ug-cv-cue/cv-cue-wireless-intrusion-prevention-techniques

<div class="grid cards" markdown>

- :material-access-point:{ .lg .middle } **Authorized APs**

    ---

    Access Points (APs) that are wired to the corporate network and are compliant with the Authorized Wireless LAN (WLAN) configuration defined by the Administrator in CV-CUE are classified as Authorized APs. Typically, these will be Arista APs, but the administrator can configure the Authorized WiFi policies for any AP vendors.

</div>

<div class="grid cards" markdown>

- :material-access-point-network-off:{ .lg .middle } **Rogue Access Point**

    ---

    APs that are wired to the corporate network and do not follow the Authorized WiFi configuration defined in CV-CUE are classified as Rogue APs.

    Even if this AP is disconnected from the network, it will continue to be classified as a Rogue. These APs are a potential threat to the corporate environment and can be used for intrusion into the corporate network over Wi-Fi. It is recommended to enable Intrusion Prevention for Rogue APs so that Wi-Fi communication with these APs is always disrupted. Using the Location Tracking ability of Arista WIPS, Rogue APs should be tracked down and physically removed from the network.
    Rogue APs are displayed in Red rows on the console.

</div>

<div class="grid cards" markdown>

- :material-access-point-minus:{ .lg .middle } **External Access Point**

    ---

    APs that are not wired to your corporate network are classified as External APs.
    Through the connectivity tests performed by the WIPS Sensors, Wireless Manager is able to determine that these APs are not connected to the wired network. These are neighboring APs that share the same spectrum as the Authorized APs and may cause interference with your Authorized WLAN. A site survey and channel optimization should be performed to reduce radio interference from the External APs. These APs are not always a threat and hence they should not be quarantined/prevented by default, as it would disrupt neighboring Wi-Fi activity. Intrusion Prevention policies can be configured to prevent Authorized clients from connecting to External APs.

    A Rogue Access point can be reclassified, moved or named from the 3-dots menu for each detected AP.

    Within an existing campus WiFi environment or one with a mix of wireless solutions, these discovered APs can be explicitly allowed to show the most accurate security profile.

    For this lab you do not need to authorize any APs.

</div>

### Classify and Prevent Individual client

Next, let’s use the WIPS system to identify and prevent an example problematic client from connecting to your network.

1. Within WIPS, Clients Menu.
2. Find your smartphone device connected to the previous Lab PSK. Reconnect it now to the PSK SSID, if it has been disconnected.
3. Since this client is associated with the correct PSK for the SSID, it is automatically classified as Authorized.
4. Next, click the 3-dots menu for the device, Change Classification, Rogue
5. Now, sort the clients menu by Classification column (left) and find the red marked Rogue device.
6. Next, Select the 3-dots menu for the Rogue client and click “Prevent This Device”
7. Click Prevent to start the WIPS prevention mechanism to disrupt the selected client from sending and receiving traffic.
8. Try to connect to a public website with your test client device with the prevention setting enabled versus disabled (be sure to disable backup wireless/LTE radios).
9. The test device should fail to connect to other devices through the protected WiFi network when prevention is active.
10. When you are finished, STOP the client prevention

    !!! danger "STOP Client Protection"
        🛑 When you are finished, **STOP** the client prevention so that you can use this test device in upcoming labs, optionally. 🛑

--8<-- "includes/abbreviations.md"
