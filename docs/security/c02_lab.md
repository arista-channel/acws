# C-02 | AGNI UPSK Wireless Policy
## Overview

In this lab...

--8<--
docs/snippets/topology.md
docs/snippets/login_agni.md
--8<--

## Create Identity UPSK SSID:

1. Return to the LaunchPad tab and Log into CV-CUE https://launchpad.wifi.arista.com/, or access the CV-CUE tab in your browser.
2. Next, we will modify the PSK SSID we created in the CV-CUE lab.
3. While on the Corp folder, Click on Configure and then WiFi
4. Next, click on the 3 Dots and select Create a Copy on the SSID ATD-##-PSK where ## is a 2 digit character between 01-20 that was assigned to your lab/Pod
5. Select - Currently Selected Folders and then Continue.
6. Click on the new SSID and select Edit.
7. On the Basic Tab rename the SSID to ATD-##-UPSK, and copy the SSID Name and paste it in the Profile Name field.
8. Next, click on the Security Tab and change the WPA2 Security from PSK to UPSK
9. Next, select UPSK Identity Lookup
10. For more information on UPSK click here: https://arista.my.site.com/AristaCommunity/s/article/Unique-PSKs
11. Next, Click on the Access Control tab.  Under RADIUS Settings, select RadSec and then AGNI for the Authentication and Accounting Servers.
12. Confirm the Username and Password, Called Station, COA information.
13. Finally, Save and turn on the SSID.

## Create UPSK Network and Segment

1. Return to the LaunchPad tab, and select the AGNI tile, or go to your AGNI tab in your browser.
2. Click on Networks and then + Add Network.
3. Add the following:
4. Name: Wireless-UPSK
5. Connection Type: Wireless
6. SSID: ATD-##-UPSK
7. Authentication Type: Unique PSK (UPSK)
8. Add Network
9. You should now see this listed in your networks.
10. Next, we will add the Segment.
11. Under Access Control, click on Segments and then + Add Segment
12. Name: Wireless-UPSK
13. Description: Wireless-UPSK
14. Click on + Add Condition
15. Conditions: Network:Authentication Type is UPSK
16. *Note: Conditions are always Matches ALL.
17. Click on + Add Action
18. Actions: Allow Access
19. Finally, click on Add Segment.
20. You should now see Wireless-UPSK in the list of segments.

## Create an AGNI Local User and Enroll Personal Device

1. In this section you will create a local user and enroll the MAC of your device.
2. In AGNI, under Identity, click on User and then + Add User.
3. Fill out the sections.  Use Arista01! for the password.
4. Disable - User must change password at next login:
5. Click Add User
6. You will notice that Password has now changed to UPSK Passphrase
7. Copy and write down or save to text file the new UPSK Passphrase.
8. Next, connect your client to ATD-##-UPSK using your UPSK Passphrase.
9. Click on Sessions and validate your device connection.
10. Next, validate your device by clicking on User and then Users.  Select your user.
11. Click on Show Clients

## Create an AGNI Client Group

1. In this section, you will simulate your device as an IoT device.
2. Disable and forget previously saved lab networks so your wireless connection on your test device does not auto connect.  Under your user client list, delete your device.
3. Next, you will add your client device as an IoT device in a Client Group.
4. First, we will need to create the Client Group.
5. In AGNI, under Identity, click on Client Groups and then + Add Client Group.
6. Name: Corp Approved Devices
7. Description: Corp Approved Devices
8. User Association: Not user associated
9. Enable the Group UPSK.  Copy the UPSK Passphrase
10. Then click on Add Group
11. Next, connect your client to ATD-##-UPSK using the Client Group UPSK Passphrase.
12. Click on Sessions and validate your device connection.
13. Next Click on your Client.
14. Notice your Client Group.  Here you have the option to change the Client Group your device belongs to.
15. Next, delete your device from the Client Group - Corp Approved Devices.
16. Next, under Identity, click on Clients and then + Add Client.
17. Select the Client Group: Corp Approved Devices
18. Add in the MAC Address of your test device like your phone that is not randomized.
19. Then select Add Client
20. You will then see the Client added to the Group.
21. Validate and Verify your connection using the Client Group UPSK Passphrase.

--8<-- "includes/abbreviations.md"
