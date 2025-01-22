# B-03 | Arista Smart System Upgrade (SSU)

## Overview

Arista's Smart System Upgrade is a feature to minimize traffic loss when upgrading from one SSU-supported EOS version to a newer SSU-supported EOS version. SSU is also referred to as ‘hitless’ upgrades. The SSU feature allows a switch to maintain packet forwarding (Data Plane) while the management/Control plane performs an OS upgrade.  

!!! info "Arista Smart System Upgrade"

    Additional information about this feature can be found in the [Arista TOI for Smart System Upgrade](https://www.arista.com/en/support/toi/eos-4-15-2f/13710-hitless-ssu)

In our workshop lab topology you will see that each leaf in your pod is directly connected to the  access point and RaspberryPi client. Traditionally, a firmware upgrade on the lead in the pod would cause the access point, wireless clients connected to the access point, and the raspberry pi client to lose network connectivity. In this lab, we will use Arista SSU on the leaf switch in your pod to perform a firmware upgrade without causing network connectivity loss on wireless clients connected to the pod access point or loss on any wired client connected to the switch.

--8<--
docs/snippets/login_cv.md
--8<--

## Prerequisites

- [x] Continuous POE should be configured to maintain POE power delivery to connected devices.
- [x] Must be running an EOS version that includes the SSU feature. 
- [x] Must be upgrading to a new EOS version that also includes the SSU feature.
- [x] Spanning-tree must be running in MST mode or disabled.
- [x] Spanning-tree edge ports must have portfast and BPDUGuard enabled.
- [x] If a switch is running BGP, it must be configured with graceful-restart or BGP routing information will be lost and the ASIC may fail to forward traffic.

## Caveats

- [x] SSU only supports upgrades. Hitless image downgrades are not supported.
- [x] If a new EOS version includes an FPGA upgrade, the FPGA upgrade will be suppressed.  FPGA upgrades require a full reboot of a switch to apply.
- [x] Some switch features, when in use, will prevent SSU from starting. See the [Arista TOI](https://www.arista.com/en/support/toi/eos-4-15-2f/13710-hitless-ssu#limitations) for more details


## Perform Arista SSU on `leaf1b`

Let's begin the hands-on portion of this lab.  SSU can be triggered on the command line, or through CloudVision.  For this lab, we will be triggering an SSU upgrade using the command line on the serial console port of the switch.  You will need to have a usb-to-rj45 console adapter to connect to the switch on its console port.

1. Connect to the campus-pod<##>-leaf1c switch serial port (where ## is a 2 digit character between 01-20 that was assigned to your lab/Pod).  The login username and password are both ‘arista’. Type ‘enable’ to enter privileged commands mode.

    ```yaml
    campus-pod00-leaf1c login: arista
    Last login: Tue Jul 30 22:16:56 on ttyS0
    campus-pod00-leaf1c>enable
    campus-pod00-leaf1c#
    ```

2. Type `show version` to show the current running version of the switch.  

    !!! note "EOS Version"
    
        That the switch is currently running EOS-4.31.3M. EOS-4.31.3M is a supported starting version for Arista SSU on the CCS-710P-16P model switch we are using in this lab.

    ```yaml
    campus-pod00-leaf1c#show version
    Arista CCS-710P-16P
    Hardware version: 11.02
    Serial number: WTW22200366
    Hardware MAC address: 2cdd.e9fd.87d4
    System MAC address: 2cdd.e9fd.87d4

    Software image version: 4.31.3M
    Architecture: i686
    Internal build version: 4.31.3M-36737551.4313M
    Internal build ID: c8d3a574-c649-455d-90a4-b2510051cf0d
    Image format version: 3.0
    Image optimization: Strata-4GB

    Uptime: 18 hours and 56 minutes
    Total memory: 3952504 kB
    Free memory: 2362268 kB
    ```

3. Type `dir` to show the list of files in the `flash:` filesystem.  You should note that there are some EOS image versions already on the flash storage of the leaf1c switch. EOS-4.31.3M, which we are currently using, and EOS-4.31.4M, which is our target update version for this lab.

    ```yaml hl_lines="5 6"
    campus-pod00-leaf1c#dir
    Directory of flash:/

        -rw-        2496           Jul 30 22:05  AsuFastPktTransmit.log
        -rw-   833973337           Jul 30 21:58  EOS-4.31.3M.swi
        -rw-  1331877083           Jul 30 21:34  EOS-4.31.4M.swi
        drwx        4096            Feb 5  2023  Fossil
        -rw-       11189           Jul 30 22:00  SsuRestore.log
        -rw-        1332           Jul 30 22:00  SsuRestoreLegacy.log
        drwx        4096            Dec 6  2021  aboot
        -rw-         297           Jul 30 21:59  arpAsuDb.bak
        -rw-          27           Jul 30 21:56  boot-config
        drwx        4096           Jul 31 16:56  debug
        -rw-        4929           Jul 30 22:00  eventhistory-persistent-store.bak
        drwx        4096           Jul 30 22:05  fastpkttx
        drwx        4096           Jul 30 22:05  fastpkttx.backup
        drwx       16384            Dec 6  2021  lost+found
        drwx        4096           Jul 31 16:58  persist
        drwx        4096            Feb 5  2023  schedule
        drwx        4096           Jul 30 21:59  ssu
        -rw-        8716           Jul 30 21:56  startup-config
        drwx        4096           Jun 19 06:36  tpm-data
        -rw-           0           Jun 19 04:30  zerotouch-config

    7527178240 bytes total (4104290304 bytes free) on flash:
    ```

4. Type `show reload fast-boot`.  This command will show you an output of warnings or incompatibilities with the current configuration of the switch.  As mentioned in the prerequisites section above, if any configuration is set in a way that prevents SSU from starting, the reasons will be listed here.  In our output, we see that there are no configuration incompatibilities.

    ```yaml
    campus-pod00-leaf1c#show reload fast-boot 
    No warnings or unsupported configuration found.
    ```

5. Now that we have confirmed our configuration is ready to allow SSU, let's prepare the switch for the upgrade process by setting the new boot image in the configuration of the switch.  Issue the following commands:

    ```yaml
    configure
    boot system flash:EOS-4.31.4M.swi
    exit
    write
    ```
    
    ??? quote "Example Output"

        ```yaml
        campus-pod00-leaf1c#configure
        campus-pod00-leaf1c(config)#boot system flash:EOS-4.31.4M.swi 
        campus-pod00-leaf1c(config)#exit
        campus-pod00-leaf1c#write
        Copy completed successfully.
        ```

6. Before we apply the new firmware, let's start a ping test which will run during the switch upgrade process.  We will see that the ping traffic will continue to flow through the switch even while its software is being upgraded.
   1. Please make sure that your laptop is connected to the wireless network called `ATD-##-PSK`. Use the PSK you configured in the previous lab to associate with this wireless network.
   2. Open a command prompt (or a terminal window if using a macbook), and issue the command `ping -t 10.0.1##.1` (or the command `ping 10.0.1##.1` if using macbook).  Please replace ## with your pod number.  Now leave this window open for the following steps.  We will see ping packets being sent and received every second.  You are now pinging the gateway IP address for your pod from your wireless device connected to your pods access point.  The ping traffic must traverse the leaf1c switch to reach the gateway.  We should be able to observe how traffic is affected while leaf1c is upgrading during SSU.

7. Now, in a standard firmware upgrade process, you would issue a normal reload command.  However,  in this lab, we want to trigger a SSU upgrade.  This is where we use the command `reload fast-boot now`.  Issue that command now.

    ```yaml
    reload fast-boot now
    ```

8. As the SSU process proceeds, you can watch the output on the serial console showing the switch preparing itself for reboot.  The switch will reboot shortly, and you should see the normal output of a switch reboot.

    !!! note "ASU vs SSU" 
    
        During the SSU reboot process, you may see messages referring to Arista Smart Upgrade, or ASU. ASU is a previous version of SSU, and some references to ASU still exist in code for the SSU process.

9. When you see the following message in your serial console of the switch, the switch is now rebooting.  

`reloading /mnt/flash/EOS-4.31.4M.swi`

10. SSH to the switch is not possible since the management plane of the switch is rebooting. However, the dataplane is still functional. Open the ping terminal window we started in `step 7` and note that ping packets are still being sent and received even though the switch is in the middle of its reboot process.

11. Below is the output of the full process, with highlights on terminal messages indicating the progress of the upgrade.

    ??? quote "Expand/Collapse"

        ```yaml
        campus-pod00-leaf1c#reload fast-boot now
        Running AsuPatchDb:doPatch( version=4.31.3M-36737551.4313M, model=Strata )
        Optimizing image for current system - this may take a minute...
        No warnings or unsupported configuration found.
        2024-07-31 17:51:14.459848 Kernel Files /mnt/flash/EOS-4.31.4M.swi extracted from SWI
        2024-07-31 17:51:16.439052 ProcOutput passed to Kernel ['crashkernel=512-4G:45M,4G-8G:59M,8G-32G:89M,32G-:121M', 'nmi_watchdog=panic', 'tsc=reliable', 'pcie_ports=native', 'reboot=p', 'usb-storage.delay_use=0', 'pti=off', 'crash_kexec_post_notifiers', 'watchdog.stop_on_reboot=0', 'mds=off', 'nohz=off', 'printk.console_no_auto_verbose=1', 'CONSOLESPEED=9600', 'console=ttyS0', 'gpt', 'Aboot=Aboot-norcal6-6.2.1-2-25288791', 'net_ma1=pci0000:00/0000:00:12.0/usb1/.*$', 'platform=raspberryisland', 'scd.lpc_irq=3', 'scd.lpc_res_addr=0xf00000', 'scd.lpc_res_size=0x100000', 'block_flash=pci0000:00/0000:00:14.7/mmc_host/.*$', 'block_usb1=pci0000:00/0000:00:12.0/usb1/1-1/1-1.1/.*$', 'block_usb2=pci0000:00/0000:00:12.0/usb1/1-1/1-1.4/.*$', 'block_drive=pci0000:00/0000:00:11.0/.*host./target.:0:0/.*$', 'sid=RaspberryIsland16', 'log_buf_len=2M', 'systemd.show_status=0', 'sdhci.append_quirks2=0x40', 'amd_iommu=off', 'nvme_core.default_ps_max_latency_us=0', 'SWI=/mnt/flash/EOS-4.31.4M.swi', 'arista.asu_hitless']
        Proceeding with reload
        No qualified FPGAs to upgrade
        waiting for platform processing ..........................................................ok
        Shutting down packet drivers
        2024-07-31 17:52:54.117479 bringing fab down
        2024-07-31 17:52:54.437128 bringing fifo down
        reloading /mnt/flash/EOS-4.31.4M.swi
        Shutting down management interface(s)
        1 block
        umount: /mnt/flash: target is busy.
        [71576.090602][T15227] kexec_core: Starting new kernel
        [    2.363505][  T296] Running e2fsck on: /mnt/flash
        [    2.803117][  T303] e2fsck on /mnt/flash took 1s
        [    3.116739][  T370] Running e2fsck on: /mnt/crash
        [    3.181814][  T375] e2fsck on /mnt/crash took 0s
        Mounting SWIM Filesystem
        Optimization Strata-4GB root squash found
        Optimization Strata-4GB all squashes found
        Mounting optimization Strata-4GB
        Switching rootfs
        Welcome to Arista Networks EOS 4.31.4M
        Architecture: i386
        [   43.938521] sh[2099]: Starting EOS initialization stage 1
        Starting NorCal initialization: [  OK  ]
        [   48.023047] sh[2181]: Starting EOS initialization stage 2
        Completing EOS initialization (press ESC to skip): [  OK  ]
        Model: CCS-710P-16P
        Serial Number: WTW22200366
        System RAM: 3952504 kB
        Flash Memory size:  7.1G

        campus-pod00-leaf1c login: 



        Wait for the SSU process to complete. This can take up to 10 minute.  When you see the following console message, the switch management plane has finished its reboot.  


        campus-pod00-leaf1c login:
        ```



12. You can now login with the username and password of `arista`, and type `enable` to get back to privileged commands mode.  Check the new current running version of the switch with the command `show version`.  You should now see the switch has upgraded to EOS-4.31.4M

    ```yaml
    campus-pod00-leaf1c login: arista
    Last login: Tue Jul 30 22:16:56 on ttyS0
    campus-pod00-leaf1c>enable
    campus-pod11-leaf1c#show version
    Arista CCS-710P-16P
    Hardware version: 11.04
    Serial number: WTW23350461
    Hardware MAC address: 2cdd.e9f6.e9f2
    System MAC address: 2cdd.e9f6.e9f2

    Software image version: 4.31.4M
    Architecture: i686
    Internal build version: 4.31.4M-37710335.4314M
    Internal build ID: d26721db-c526-41ec-bf9d-0a14b4edfcf5
    Image format version: 3.0
    Image optimization: Strata-4GB

    Uptime: 5 minutes
    Total memory: 3952504 kB
    Free memory: 2880904 kB
    ```

13. After the management plane boots up, there are still some processes running before SSU can be considered successful.  Run the following command to watch for the log message indicating SSU is fully successful. `show log follow | inc hitless`  You should see the message `reload hitless reconciliation complete` about 2 minutes after the switch completes its bootup.

    ```yaml
    campus-pod11-leaf1c#show log follow | inc hitless
    Aug  8 19:51:59 campus-pod11-leaf1c StageMgr: %LAUNCHER-6-BOOT_STATUS: 'reload hitless' reconciliation complete.
    ```

14. As our final step, take another look at the terminal window that was running the consistent pings.  You should see pings continue to flow without issue during the upgrade.  Only towards the end of the process you may see 1 or 2 pings lost as the ASIC reconnects to the updated management plane.

    ```yaml
    nhancock@Nates-MacBook-Pro ~ % ping 10.0.111.1
    PING 10.0.111.1 (10.0.111.1): 56 data bytes
    64 bytes from 10.0.111.1: icmp_seq=0 ttl=64 time=4.681 ms
    64 bytes from 10.0.111.1: icmp_seq=1 ttl=64 time=4.510 ms
    64 bytes from 10.0.111.1: icmp_seq=2 ttl=64 time=4.063 ms
    64 bytes from 10.0.111.1: icmp_seq=3 ttl=64 time=4.417 ms
    64 bytes from 10.0.111.1: icmp_seq=4 ttl=64 time=4.575 ms
    64 bytes from 10.0.111.1: icmp_seq=5 ttl=64 time=5.000 ms
    ... truncated for brevity
    64 bytes from 10.0.111.1: icmp_seq=579 ttl=64 time=3.853 ms
    64 bytes from 10.0.111.1: icmp_seq=580 ttl=64 time=3.993 ms
    64 bytes from 10.0.111.1: icmp_seq=581 ttl=64 time=4.263 ms
    64 bytes from 10.0.111.1: icmp_seq=582 ttl=64 time=6.234 ms
    64 bytes from 10.0.111.1: icmp_seq=583 ttl=64 time=4.219 ms
    64 bytes from 10.0.111.1: icmp_seq=584 ttl=64 time=3.267 ms
    64 bytes from 10.0.111.1: icmp_seq=585 ttl=64 time=3.196 ms
    64 bytes from 10.0.111.1: icmp_seq=586 ttl=64 time=3.535 ms
    64 bytes from 10.0.111.1: icmp_seq=587 ttl=64 time=4.167 ms
    64 bytes from 10.0.111.1: icmp_seq=588 ttl=64 time=3.977 ms
    64 bytes from 10.0.111.1: icmp_seq=589 ttl=64 time=4.937 ms
    64 bytes from 10.0.111.1: icmp_seq=590 ttl=64 time=4.248 ms
    Request timeout for icmp_seq 591
    64 bytes from 10.0.111.1: icmp_seq=592 ttl=64 time=4.348 ms
    64 bytes from 10.0.111.1: icmp_seq=593 ttl=64 time=4.337 ms
    64 bytes from 10.0.111.1: icmp_seq=594 ttl=64 time=3.766 ms
    64 bytes from 10.0.111.1: icmp_seq=595 ttl=64 time=5.510 ms
    64 bytes from 10.0.111.1: icmp_seq=596 ttl=64 time=4.399 ms
    64 bytes from 10.0.111.1: icmp_seq=597 ttl=64 time=4.167 ms
    64 bytes from 10.0.111.1: icmp_seq=598 ttl=64 time=4.033 ms
    64 bytes from 10.0.111.1: icmp_seq=599 ttl=64 time=3.904 ms
    ```

15. We see from this example output above, only 1 ping reply was lost at the end of the process near the 10 minute mark after starting the ping test.

## Lab Conclusion

We just observed how Arista SSU allows network connected devices to continue to operate on the network even while an EOS firmware update occurs on the connected switch.

--8<-- "includes/abbreviations.md"
