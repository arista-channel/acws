# RadSec | Installing the AP Certificate

## What is RadSec?

RadSec is a protocol that supports RADIUS over TCP and TLS. For mutual authentication it is required to install a client certificate with corresponding private key as well as your AGNI CA certificate.

With the proliferation of IoT devices, mobile users, and remote access, networks have become more complex and diverse, making traditional RADIUS susceptible to eavesdropping and man-in-the-middle attacks. RadSec's integration of secure Transport Layer Security (TLS) encryption addresses these vulnerabilities, providing a robust defense against unauthorized access, data interception, and tampering.

Arista Switches can form a RadSec tunnel using SSL encryption with AGNI:

- AGNI integrates with network infrastructure devices (wired switches and wireless access points) through a RadSec tunnel over `Port 2083`
- The highly secure and encrypted tunnel offers complete protection to the communications that happen in a distributed network environment. This mechanism offers much greater security to AAA workflows when compared with traditional unencrypted RADIUS workflows.

!!! info "More information on RadSec"
    - [Configuring a RadSec profile in EOS](https://arista.my.site.com/AristaCommunity/s/article/Configuring-RadSec-profile-in-EOS){target="_blank"}
    - [RADIUS Dynamic Authorization over TLS](https://www.arista.com/en/support/toi/eos-4-27-0f/14891-radius-dynamic-authorization-over-tls){target="_blank"}

!!! note "Open AGNI and CV-CUE"

    When applying the Certificate to the AP it is recommended to have both the CV-CUE and AGNI windows opened side by side.
    - [Login to CV-CUE](../snippets/login_cvcue.md)
    - [Login to AGNI](../snippets/login_agni.md)

## Configure RadSec

It's important to identify if the wired or wireless device you are configuring is manufactured with a Trusted Platform Module (TPM) chip. This chip contains the required certificate used for RadSec. However, if the TPM chip does not exist, CV-CUE supports Custom Certificate Management for Access Points.

!!! info "More information on TPM"
    - [Wireless TPM vs Non-TPM](https://www.arista.com/en/support/toi/cv-cue-18-0-0/20886-wi-fi-access-point-server-communication-workflow){target="_blank"}
    - [TPM chip APs - RadSec Tunnel Configuration](https://www.youtube.com/watch?v=9kxJDjRnVnE){target="_blank"}
    - [Non-TPM chip APs - RadSec Tunnel with Custom Certificate](https://www.youtube.com/watch?v=kFJ24zRHYJ8&list=PL3NLCp8DnVftRcsTAa8xmKBrJ3WJLxvzn&index=4)

### Summary

1. **Launchpad** Add AP and assign the Service
2. **CV-CUE** Create a Folder and move the AP
3. **CV-CUE** Generate CSR TAG and then Download CSR `.zip`.
4. **AGNI** Add the device as a new AP under Access Devices
5. **AGNI** Click on your AP and then select Get Client Certificate
6. **AGNI** Upload the CSR and Generate Certificate
7. **CV-CUE** Click on your AP and Upload Device Certificate and select TAG and `AP.pem` file
8. **AGNI** Under Administration click on RadSec settings and download Cert and copy hostname
9. **CV-CUE** In your Folder, Create a RADIUS RadSec server and apply the RadSec Cert from AGNI and Select your CSR TAG -> FQDN: `radsec.beta.agni.arista.io`
10. **CV-CUE** Create an SSID and point to the RADIUS client you created using WPA2 802.1X RadSec.
11. **AGNI** Create a User Account
12. **AGNI** Add Client
13. **AGNI** Under Networks, recommend starting with just a MAC auth example to make sure everything is running like you expected and point it to your SSID

### Detailed Steps

1. `CV-CUE`
      1. First we Generate a CSR. Click on `Monitor > WiFi Access Points`
      2. On right hand side on top and click on `Certificate Actions`
      3. Next, right click on the AP and select `Generate CSR` and select your `Add New Certificate Tag`. Type in a name for your Certificate Tag. Click on `Generate`.
      4. Next, right click on the AP and select `Download CSR` and select your `Certificate Tag`.

2. `AGNI`
      1. Click on Access Devices and click on `+ Add or Import`. Specify the following in the table below. Click on `Add Device` when done.

        | Field | Value | Notes |
        | --- | --- | --- |
        | Choose Action | `Add Device` | Select radio button |
        | Name | `Your AP Name` | Enter descriptive name for the AP |
        | MAC Address | `xx:xx:xx:xx:xx:xx` | Optional - Enter AP MAC address |
        | Vendor | `Arista WiFi` | Select from dropdown |
        | Serial Number | `Your AP Serial` | **Required for RadSec** - Enter AP serial number |
        | IP Address | `Your AP IP` | Optional - Enter AP IP address |
        | Access Device Group | `Select Group` | Optional - Choose appropriate group |
        | Location | `Your Location` | Optional - Example: Global/America/California/Site-1 |

      2. Access Devices → Devices → Select AP → Get Client Certificate
      3. Next, select `Generate Certificate: Use CSR (Single Device)`, and select `Action: Upload CSR File`, and browse to and select the CSR zip file.
      4. Select `Generate Certificate` and the AP Client Certificate will be created and downloaded to your device.
      5. Under `System -> RadSec Settings` copy the `Radsec Server Hostname` and `Download Certificate` at the bottom.

!!! danger "🚨 CRITICAL STEP - DO NOT SKIP!"
    <div style="background-color: #ffebee; border-left: 5px solid #f44336; padding: 15px; margin: 10px 0;">
    <strong>⚠️ MANDATORY:</strong> You MUST download the RadSec certificate from AGNI before proceeding to CV-CUE configuration.
    <br><br>
    <strong>📥 Download Certificate</strong> - This certificate is required for the RadSec tunnel to work properly.
    <br><br>
    <strong>🔗 Copy Hostname</strong> - The RadSec Server Hostname is needed for CV-CUE RADIUS server configuration.
    </div>

3. `CV-CUE`
      1. Upload the Device Certificate
      2. Go to `Monitor → WiFi → Access Points → Select AP → Certificate → Upload Device Certificate`, and upload the Client/Device Certificate that was downloaded to your device. Use the same Certificate Tag as when you Downloaded the CSR above.
      3. Configuring AGNI RadSec Server.
      4. Go to `Configure → Network Profiles → RADIUS` and create a new RADIUS Server.
      5. Select `Add RADIUS Server`. Specify the following in the table below.

        | Field | Value |
        | --- | --- |
        | Server Name | `AGNI-01` |
        | Server Address | `radsec.beta.agni.arista.io` |
        | Radsec | `ON` |
        | Radsec Port | `2083` |
        | Add CA Certificate | `Downloaded from AGNI` |
        | Certificate Tag | `Select your tag created in Step 1` |

      6. Select `Save` to commit the changes.

4. `AGNI`
      1. Click on Access Devices and then Devices look at the RadSec Status.
      2. 🟢 **Green dot** means connected and an active SSID is using AGNI.
