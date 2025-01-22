# A-02 | Access Interface Configuration

## Overview

This lab will guide you through creating port profiles and applying them to interfaces in your network.

--8<--
docs/snippets/topology.md
docs/snippets/login_cv.md
docs/snippets/workspace.md
--8<--

## 01 | Creating Port Profiles

1. From the `Studios` home page, disable the `Active Studios` toggle to display all available CloudVision Studios (which when enabled will only show used/active Studios).

    !!! note "The toggle may already be in the disabled position"

2. Let's create two port profiles using the `Access Interface Configuration` studio that will be used to provision connected hosts.

      1. Launch the `Access Interface Configuration`
      2. Click Add Port Profile, name it `Wireless-Access-Point`, and click the arrow on the right
      3. Enter the following values on this configuration page

    ???+ example "Wireless-Access-Point"

        | Key                  | Value                                     |
        | -------------------- | ----------------------------------------- |
        | Description          | `Wireless-Access-Point`                   |
        | Enable               | True                                      |
        | Mode                 | Access                                    |
        | VLANS                | `1##` where `##` is a 2 digit pod number* |
        | POE Reboot Action    | Maintain                                  |
        | POE Link Down Action | Maintain                                  |
        | POE Shutdown Action  | Maintain                                  |

        *VLAN pod numbers between 01-12 that was assigned to your lab/Pod. Example: `Pod01` is `VLAN101`, `Pod13` is `VLAN113`*

      4. Navigate back to `Access interface Configuration` by clicking on the top
      5. Click `Add Port Profile`, name it `Wired-RasPi`, and click the arrow on the right
      6. Enter the following values on this configuration page

    ???+ example "Wired-RasPi"

        | Key                      | Value                                     |
        | ------------------------ | ----------------------------------------- |
        | Description              | `Wired-RasPi`                             |
        | Enable                   | True                                      |
        | Mode                     | Access                                    |
        | VLANS                    | `1##` where `##` is a 2 digit pod number* |
        | 802.1X                   | Enabled                                   |
        | MAC Based Authentication | True                                      |
        | POE Shutdown Action      | Maintain                                  |
        | POE Reboot Action        | Maintain                                  |
        | POE Link Down Action     | Maintain                                  |
        | POE Shutdown Action      | Maintain                                  |

        *VLAN pod numbers between 01-12 that was assigned to your lab/Pod. Example: `Pod01` is `VLAN101`, `Pod13` is `VLAN113`*

      7. Navigate back to the previous page

3. Review and `Submit the Workspace`
      1. Click `Review Workspace`
           !!! note "Note that none of the device configurations have been change after submitting this workspace"
      2. Click Submit Workspace 
      3. Click Close

## 02 | Assigning Port Profiles for AP and RPI

1. Assign the configured port profiles to the switches access ports

2. Click `Overview` option on the navigation bar

3. Locate the `Quick Actions` panel on the lower left of the screen and `Click Access Interface Configuration`

4. Select the following:

    !!! note "There is only one option for each drop-down"

      1. Campus: `Workshop`
      2. Campus Pod: `IT-Bldg`
      3. Access Pod: `IDF1`
      
5. Select to highlight port `Ethernet1` on bottom switch: `campus-pod<##>-leaf1c`
   
    !!! note "You will may see the bottom device with a hostname format: `sw-<IP> Example: sw-10.0.113.40`"

      1. Choose the `Port Profile` of `Wireless-Access-Point`
      2. Click `Yes` radio button under `Enabled`

6. Click `Submit`

7.  Once the `Change Control` has been executed, click `Configure Additional Inputs` to configure another access port

8.  Again, select the following
      1. Campus: `Workshop`
      2.  Campus Pod: `IT-Bldg`
      3.  Access Pod: `IDF1`

9.  Select to highlight port `Ethernet2` on `campus-pod<##>-leaf1b` (hostname may not match)
      1. Choose the `Port Profile` of `Wired-RasPI`
      2. Click `Yes` radio button under `Enabled`

10. Click `Submit`

11. Once the `Change Control` has been executed, click `Finish`

--8<-- "includes/abbreviations.md"
