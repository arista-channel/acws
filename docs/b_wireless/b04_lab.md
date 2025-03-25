# B-04 | Arista Smart System Upgrade (SSU)

## Overview

Arista's Smart System Upgrade (SSU) is a feature to minimize traffic loss when upgrading from one SSU-supported EOS version to a newer SSU-supported EOS version. SSU is also referred to as ‘hitless’ upgrades. The SSU feature allows a switch to maintain packet forwarding (Data Plane) while the Management and Control plane perform the OS upgrade.

!!! info "Arista Smart System Upgrade"

    Additional information about this feature can be found in the [Arista TOI for Smart System Upgrade](https://www.arista.com/en/support/toi/eos-4-15-2f/13710-hitless-ssu)

In our workshop lab topology you will see that each leaf in your pod is directly connected to the access point and RaspberryPi client. Traditionally, a firmware upgrade on the lead in the pod would cause the access point, wireless clients connected to the access point, and the raspberry pi client to lose network connectivity. In this lab, we will use Arista SSU on the leaf switch in your pod to perform a firmware upgrade minimizing any network disruptions for both wired and wireless clients.

## Prerequisites

- [x] Continuous POE should be configured to maintain POE power delivery to connected devices.
- [x] Must be running an EOS version that includes the SSU feature.
- [x] Must be upgrading to a new EOS version that also includes the SSU feature.
- [x] Spanning-tree must be running in MST mode or disabled.
- [x] Spanning-tree edge ports must have portfast and BPDUGuard enabled.
- [x] Switches running BGP must be configured with `graceful-restart` otherwise routes are lost and the hardware may fail to forward traffic.

## Caveats

As you can imagine, disconnecting the Control and Management plane off the data plane will come with some caveats depending on what features you are running! While that's the case, most instances where SSU is valuable is where we have no resiliency or ability to "route around" the switch in maintenance.

- [x] SSU only supports upgrades. Hitless image downgrades are not supported.
- [x] If a new EOS version includes an FPGA upgrade, the FPGA upgrade will be suppressed. FPGA upgrades require a full reboot of a switch to apply.
- [x] Some switch features, when in use, will prevent SSU from starting. See the [Arista TOI](https://www.arista.com/en/support/toi/eos-4-15-2f/13710-hitless-ssu#limitations) for more details

## Perform Arista SSU

Let's begin the hands-on portion of this lab. SSU can be triggered on the command line or via CloudVision. For this lab we will be triggering an SSU upgrade using the command line, preferably using the serial port of the switch. As in

!!! tip "Console via SSH"

    Using the console we will get a more in depth look at the logs as the switch upgrades. However, SSH is fine if you do not have a console cable. There is example output below you can refer to.

1. Connect to the `pod<##>-leaf1a` switch serial port (where ## is a 2 digit character between 01-20 that was assigned to your lab/Pod). The login username/password is `arista/arista`. Type `enable` to enter privileged mode.

    ???+ quote "Example Output"

        ```yaml
        pod00-leaf1a login: arista
        Last login: Tue Jul 30 22:16:56 on ttyS0
        pod00-leaf1a>enable
        pod00-leaf1a#
        ```

2. Type `show version` to show the current running version of the switch.

    !!! note "EOS Version"

        That the switch is currently running EOS-4.31.5M, this is a supported starting version for Arista SSU on the CCS-710P-16P model switch we are using in this lab.

    ```yaml
    show version
    ```

    ???+ quote "Example Output"

        ```yaml
        Arista CCS-710P-12
        Hardware version: 11.03
        Serial number: WTW22261433
        Hardware MAC address: 2cdd.e9fe.dc0e
        System MAC address: 2cdd.e9fe.dc0e

        Software image version: 4.31.5M
        Architecture: i686
        Internal build version: 4.31.5M-38783123.4315M
        Internal build ID: a514fb70-598b-4084-975c-4f5978421b10
        Image format version: 3.0
        Image optimization: Strata-4GB

        Uptime: 59 minutes
        Total memory: 3952504 kB
        Free memory: 2408036 kB
        ```

3. Type `dir` to show the list of files in the `flash:` filesystem. You should note that there are some EOS image versions already on the flash storage of the leaf1a switch. `EOS-4.31.5M`, which we are currently using, and `EOS-4.31.6M`, which is our target update version for this lab.

    ```yaml
    dir
    ```

    ???+ quote "Example Output"

        ```yaml hl_lines="5 6"
        Directory of flash:/

            -rw-    32184348           Jan 19 10:06  AristaCloudGateway-1.0.2-1.swix
            -rw-        7161           Jan 23 09:58  AsuFastPktTransmit.log
            -rwx   834075912           Jan 22 19:51  EOS-4.31.5M.swi
            -rwx   834335804           Jan 22 21:21  EOS-4.31.6M.swi
            drwx        4096            Feb 4  2023  Fossil
            -rw-        4402           Jan 23 09:58  SsuRestore.log
            -rw-        4402           Jan 23 09:58  SsuRestoreLegacy.log
            -rw-     6829174            May 6  2024  TerminAttr-1.31.2-1.swix
            drwx        4096            Dec 6  2021  aboot
            -rw-        8355           Jan 18 14:21  backup-config
            -rw-         143           Jan 23 09:54  boot-config
            -rw-           1           Jan 22 19:52  boot-extensions
            drwx        4096           Jan 23 10:53  debug
            drwx        4096            Feb 4  2023  fastpkttx.backup
            -rw-          98            Jun 5  2024  id_ed25519.pub
            -rw-          24           May 13  2024  intf-ap-access.pcap
            drwx       16384            Dec 6  2021  lost+found
            drwx        4096           Jan 23 10:57  persist
            drwx        4096            Feb 4  2023  schedule
            -rw-        4816           Jan 23 10:23  startup-config
            drwx        4096           Apr 30  2024  tpm-data
            -rw-           0           Jan 22 20:48  zerotouch-config
            drwx        4096           Jan 20 08:26  ztp-debug

        7526043648 bytes total (4948328448 bytes free) on flash:
        ```

4. Type `show reload fast-boot`.  This command will show you an output of warnings or incompatibilities with the current configuration of the switch. As mentioned in the prerequisites section above, if any configuration is set in a way that prevents SSU from starting, the reasons will be listed here. In our output, we see that there are no configuration incompatibilities.

    ```yaml
    show reload fast-boot
    ```

    ???+ quote "Example Output"

        ```yaml hl_lines="2"
        pod00-leaf1a#show reload fast-boot
        No warnings or unsupported configuration found.
        ```

5. Now that we have confirmed our configuration is ready to allow SSU, let's prepare the switch for the upgrade process by setting the new boot image in the configuration of the switch. Issue the following commands:

    !!! tip "⏲ Setting the boot flash will take a few seconds!"

    ```bash
    configure
    boot system flash:EOS-4.31.6M.swi
    exit
    write
    ```

    ???+ quote "Example Output"

        ```yaml
        pod00-leaf1a#configure
        pod00-leaf1a(config)#boot system flash:EOS-4.31.6M.swi
        pod00-leaf1a(config)#exit
        pod00-leaf1a#write
        Copy completed successfully.
        ```

6. Before we apply the new firmware, let's start a ping test which will run during the switch upgrade process. We will see that the ping traffic will continue to flow through the switch even while its software is being upgraded.
    1. Please make sure that your laptop is connected to the wireless network called `ATD-##-PSK`. Use the PSK you configured in the previous lab to associate with this wireless network.
    2. Open a terminal and ping your gateway using the commands below. If you want to increase the interval to get more granular results, feel free!

        ??? info ":material-apple: MAC OS"

            Open Terminal and run the following, please replace ## with your pod number (1-12)

            ```bash
            ping 10.1.##.1
            ```

        ??? info ":material-microsoft-windows: Windows"

            Open Command Prompt and run the following, please replace ## with your pod number (1-12)

            ```bash
            ping -t 10.1.##.1
            ```

    3. Now leave this window open for the following steps. We will see ping packets being sent and received every second. You are now pinging the gateway IP address for your pod from your wireless device connected to your pods access point. The ping traffic must traverse the `leaf1a` or `leaf1b` switch to reach the gateway.  We should be able to observe how traffic is affected while the switch is upgrading during SSU.

7. Now, in a standard firmware upgrade process, you would issue a normal reload command. However, in this lab, we want to trigger a SSU upgrade. This is where we use the command below, go ahead and issue that command now. 🚀

    !!! danger "REMINDER"

        During this test, **do not plug in or unplug devices from the switch**. Recall, the control plane will effectively be down, so changes or updates to the switch at a hardware level (like populating MAC add/removals) are unavailable.

    ```yaml
    reload fast-boot now
    ```

8. As the SSU process proceeds, you can watch the output on the serial console showing the switch preparing itself for reboot. The switch will reboot shortly, and you should see the normal output of a switch reboot.

    !!! note "ASU vs SSU"

        During the SSU reboot process, you may see messages referring to Arista Smart Upgrade, or ASU. ASU is a previous version of SSU, and some references to ASU still exist in code for the SSU process.

9. When you see the following message in your serial console of the switch, the switch is now rebooting.

    ```yaml
    reloading /mnt/flash/EOS-4.31.6M.swi
    ```

10. SSH to the switch is not possible since the management plane of the switch is rebooting. However, the dataplane is still functional. Open the ping terminal window we started in `step 8` and note that ping packets are still being sent and received even though the switch is in the middle of its reboot process.

11. Below is the output of the full process, with highlights on terminal messages indicating the progress of the upgrade.

    ???+ quote "Example Output"

        ```yaml hl_lines="2 5 8 13 25"
        pod00-leaf1a#reload fast-boot now
        Running AsuPatchDb:doPatch( version=4.31.5M-38783123.4315M, model=Strata ) #(1)!
        Optimizing image for current system - this may take a minute...
        No warnings or unsupported configuration found.
        2024-07-31 17:51:14.459848 Kernel Files /mnt/flash/EOS-4.31.6M.swi extracted from SWI #(2)!
        2024-07-31 17:51:16.439052 ProcOutput passed to Kernel ['crashkernel=512-4G:45M,4G-8G:59M,8G-32G:89M,32G-:121M', 'nmi_watchdog=panic', 'tsc=reliable', 'pcie_ports=native', 'reboot=p', 'usb-storage.delay_use=0', 'pti=off', 'crash_kexec_post_notifiers', 'watchdog.stop_on_reboot=0', 'mds=off', 'nohz=off', 'printk.console_no_auto_verbose=1', 'CONSOLESPEED=9600', 'console=ttyS0', 'gpt', 'Aboot=Aboot-norcal6-6.2.1-2-25288791', 'net_ma1=pci0000:00/0000:00:12.0/usb1/.*$', 'platform=raspberryisland', 'scd.lpc_irq=3', 'scd.lpc_res_addr=0xf00000', 'scd.lpc_res_size=0x100000', 'block_flash=pci0000:00/0000:00:14.7/mmc_host/.*$', 'block_usb1=pci0000:00/0000:00:12.0/usb1/1-1/1-1.1/.*$', 'block_usb2=pci0000:00/0000:00:12.0/usb1/1-1/1-1.4/.*$', 'block_drive=pci0000:00/0000:00:11.0/.*host./target.:0:0/.*$', 'sid=RaspberryIsland16', 'log_buf_len=2M', 'systemd.show_status=0', 'sdhci.append_quirks2=0x40', 'amd_iommu=off', 'nvme_core.default_ps_max_latency_us=0', 'SWI=/mnt/flash/EOS-4.31.6M.swi', 'arista.asu_hitless']
        Proceeding with reload
        No qualified FPGAs to upgrade #(3)!
        waiting for platform processing ..........................................................ok
        Shutting down packet drivers
        2024-07-31 17:52:54.117479 bringing fab down
        2024-07-31 17:52:54.437128 bringing fifo down
        reloading /mnt/flash/EOS-4.31.6M.swi #(4)!
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
        Mounting optimization Strata-4GB #(5)!
        Switching rootfs
        Welcome to Arista Networks EOS 4.31.6M
        Architecture: i386
        [   43.938521] sh[2099]: Starting EOS initialization stage 1
        Starting NorCal initialization: [  OK  ]
        [   48.023047] sh[2181]: Starting EOS initialization stage 2
        Completing EOS initialization (press ESC to skip): [  OK  ]
        Model: CCS-710P-16P
        Serial Number: WTW22200366
        System RAM: 3952504 kB
        Flash Memory size:  7.1G

        pod00-leaf1a login:



        Wait for the SSU process to complete. This can take up to 10 minute.  When you see the following console message, the switch management plane has finished its reboot.


        pod00-leaf1a login:
        ```

        1. Remember the mention, there may still be some mention of ASU in the code. This is the SSU process kicking off.
        2. Extracting the boot image we configured
        3. No FPGAs to upgrade, recall if there were, this would require a full reload!
        4. Reloading the management and control plane to the new software image
        5. Mounting the software on to the hardware, `Strata` in this case is the family of ASICs

12. You can now login with the username/password and type `enable` to get back to privileged commands mode. Check the new current running version of the switch with the command `show version`. You should see the switch has upgraded to `EOS-4.31.6M`

    ???+ quote "Example Output"

        ```yaml hl_lines="7"
        Arista CCS-710P-16P
        Hardware version: 11.04
        Serial number: WTW23350461
        Hardware MAC address: 2cdd.e9f6.e9f2
        System MAC address: 2cdd.e9f6.e9f2

        Software image version: 4.31.6M
        Architecture: i686
        Internal build version: 4.31.6M-37710335.4314M
        Internal build ID: d26721db-c526-41ec-bf9d-0a14b4edfcf5
        Image format version: 3.0
        Image optimization: Strata-4GB

        Uptime: 5 minutes
        Total memory: 3952504 kB
        Free memory: 2880904 kB
        ```

13. After the management plane boots up, there are still some processes running before SSU can be considered successful. Run the following command to watch for the log message indicating SSU is fully successful. You should see the message `reload hitless reconciliation complete` about 2 minutes after the switch completes its reload.

    ```yaml
    show log follow | inc hitless
    ```

    ???+ quote "Example Output"

        ```yaml hl_lines="2"
        campus-pod11-leaf1a#show log follow | inc hitless
        Aug  8 19:51:59 campus-pod11-leaf1a StageMgr: %LAUNCHER-6-BOOT_STATUS: 'reload hitless' reconciliation complete.
        ```

14. As our final step, take another look at the terminal window that was running the consistent pings. You should see pings continue to flow without issue during the upgrade. Only towards the end of the process you may see 1 or 2 pings lost as the ASIC reconnects to the updated management plane.

    !!! success "800 ms Cutover 🏎️"

        The below example output was sending pings every 100ms, as you see below the cutover time to the new EOS image disrupted the dataplane for all of 700-800ms!! This is fast enough you may not even notice the disruption on an active zoom call!

    ???+ quote "Example Output"

        ```yaml hl_lines="10-17"
        kbush@MacBook-Pro ~ % ping -i 0.1 10.0.111.1
        64 bytes from 9.9.9.9: icmp_seq=0 ttl=51 time=10.974 ms
        64 bytes from 9.9.9.9: icmp_seq=1 ttl=51 time=10.147 ms
        64 bytes from 9.9.9.9: icmp_seq=2 ttl=51 time=10.583 ms
        64 bytes from 9.9.9.9: icmp_seq=3 ttl=51 time=10.657 ms
        ... truncated for brevity
        64 bytes from 9.9.9.9: icmp_seq=4885 ttl=51 time=10.586 ms
        64 bytes from 9.9.9.9: icmp_seq=4886 ttl=51 time=10.954 ms
        64 bytes from 9.9.9.9: icmp_seq=4887 ttl=51 time=10.632 ms
        Request timeout for icmp_seq 4888
        Request timeout for icmp_seq 4889
        Request timeout for icmp_seq 4890
        Request timeout for icmp_seq 4891
        Request timeout for icmp_seq 4892
        Request timeout for icmp_seq 4893
        Request timeout for icmp_seq 4894
        Request timeout for icmp_seq 4895
        64 bytes from 9.9.9.9: icmp_seq=4896 ttl=51 time=11.481 ms
        64 bytes from 9.9.9.9: icmp_seq=4897 ttl=51 time=11.637 ms
        64 bytes from 9.9.9.9: icmp_seq=4898 ttl=51 time=11.237 ms
        64 bytes from 9.9.9.9: icmp_seq=4899 ttl=51 time=10.859 ms
        64 bytes from 9.9.9.9: icmp_seq=4900 ttl=51 time=10.595 ms
        64 bytes from 9.9.9.9: icmp_seq=4901 ttl=51 time=10.516 ms
        ```

15. We see from this example output above, only 8 pings were lost (100 ms each) at the end of the process near the 10 minute mark after starting the ping test. If you we're pinging at 1 per second, you should see 1 maybe 2 pings drop.

16. As a last item to leave you with, you can validate your reload reason to confirm why the switch last reloaded using the command below.

    ```yaml
    show reload cause
    ```

    ???+ quote "Example Output"

        ```yaml hl_lines="3 7"
        Reload Cause 1:
        -------------------
        Hitless reload requested by the user.

        Reload Time:
        ------------
        Reload occurred at Thu Jan 23 11:08:51 2025 CST.

        Recommended Action:
        -------------------
        No action necessary.

        Debugging Information:
        -------------------------------
        None available.
        ```

## Lab Conclusion

We just observed how Arista SSU allows network connected devices to continue to operate on the network even while an EOS firmware update occurs on the connected switch.

!!! tip "🎉 CONGRATS! You have completed the Wireless labs! 🎉"

--8<-- "includes/abbreviations.md"
