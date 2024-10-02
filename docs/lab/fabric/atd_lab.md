# ATD_LAB

## Table of Contents

- [Fabric Switches and Management IP](#fabric-switches-and-management-ip)
  - [Fabric Switches with inband Management IP](#fabric-switches-with-inband-management-ip)
- [Fabric Topology](#fabric-topology)
- [Fabric IP Allocation](#fabric-ip-allocation)
  - [Fabric Point-To-Point Links](#fabric-point-to-point-links)
  - [Point-To-Point Links Node Allocation](#point-to-point-links-node-allocation)
  - [Loopback Interfaces (BGP EVPN Peering)](#loopback-interfaces-bgp-evpn-peering)
  - [Loopback0 Interfaces Node Allocation](#loopback0-interfaces-node-allocation)
  - [VTEP Loopback VXLAN Tunnel Source Interfaces (VTEPs Only)](#vtep-loopback-vxlan-tunnel-source-interfaces-vteps-only)
  - [VTEP Loopback Node allocation](#vtep-loopback-node-allocation)

## Fabric Switches and Management IP

| POD | Type | Node | Management IP | Platform | Provisioned in CloudVision | Serial Number |
| --- | ---- | ---- | ------------- | -------- | -------------------------- | ------------- |
| ATD_LAB | leaf | [710p-01](../devices/710p-01.md) | 192.168.3.101/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-02](../devices/710p-02.md) | 192.168.3.102/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-03](../devices/710p-03.md) | 192.168.3.103/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-04](../devices/710p-04.md) | 192.168.3.104/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-05](../devices/710p-05.md) | 192.168.3.105/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-06](../devices/710p-06.md) | 192.168.3.106/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-07](../devices/710p-07.md) | 192.168.3.107/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-08](../devices/710p-08.md) | 192.168.3.108/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-09](../devices/710p-09.md) | 192.168.3.109/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-10](../devices/710p-10.md) | 192.168.3.110/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-11](../devices/710p-11.md) | 192.168.3.111/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-12](../devices/710p-12.md) | 192.168.3.112/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-13](../devices/710p-13.md) | 192.168.3.113/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-14](../devices/710p-14.md) | 192.168.3.114/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-15](../devices/710p-15.md) | 192.168.3.115/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-16](../devices/710p-16.md) | 192.168.3.116/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-17](../devices/710p-17.md) | 192.168.3.117/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-18](../devices/710p-18.md) | 192.168.3.118/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-19](../devices/710p-19.md) | 192.168.3.119/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-20](../devices/710p-20.md) | 192.168.3.120/24 | 710P-16P | Provisioned | - |
| ATD_LAB | leaf | [710p-24](../devices/710p-24.md) | 192.168.3.124/24 | 710P-16P | Provisioned | - |
| ATD_LAB | l3spine | core-7280SR-48C6 | 192.168.3.2/24 | 7280SR-48C6 | Provisioned | - |

> Provision status is based on Ansible inventory declaration and do not represent real status from CloudVision.

### Fabric Switches with inband Management IP

| POD | Type | Node | Management IP | Inband Interface |
| --- | ---- | ---- | ------------- | ---------------- |

## Fabric Topology

| Type | Node | Node Interface | Peer Type | Peer Node | Peer Interface |
| ---- | ---- | -------------- | --------- | ----------| -------------- |
| leaf | [710p-01](../devices/710p-01.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet1 |
| leaf | [710p-02](../devices/710p-02.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet3 |
| leaf | [710p-03](../devices/710p-03.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet5 |
| leaf | [710p-04](../devices/710p-04.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet7 |
| leaf | [710p-05](../devices/710p-05.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet9 |
| leaf | [710p-06](../devices/710p-06.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet11 |
| leaf | [710p-07](../devices/710p-07.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet13 |
| leaf | [710p-08](../devices/710p-08.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet15 |
| leaf | [710p-09](../devices/710p-09.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet17 |
| leaf | [710p-10](../devices/710p-10.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet19 |
| leaf | [710p-11](../devices/710p-11.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet25 |
| leaf | [710p-12](../devices/710p-12.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet27 |
| leaf | [710p-13](../devices/710p-13.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet29 |
| leaf | [710p-14](../devices/710p-14.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet31 |
| leaf | [710p-15](../devices/710p-15.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet33 |
| leaf | [710p-16](../devices/710p-16.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet35 |
| leaf | [710p-17](../devices/710p-17.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet37 |
| leaf | [710p-18](../devices/710p-18.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet39 |
| leaf | [710p-19](../devices/710p-19.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet41 |
| leaf | [710p-20](../devices/710p-20.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet43 |
| leaf | [710p-24](../devices/710p-24.md) | Ethernet18 | l3spine | core-7280SR-48C6 | Ethernet47 |

## Fabric IP Allocation

### Fabric Point-To-Point Links

| Uplink IPv4 Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ---------------- | ------------------- | ------------------ | ------------------ |

### Point-To-Point Links Node Allocation

| Node | Node Interface | Node IP Address | Peer Node | Peer Interface | Peer IP Address |
| ---- | -------------- | --------------- | --------- | -------------- | --------------- |

### Loopback Interfaces (BGP EVPN Peering)

| Loopback Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ------------- | ------------------- | ------------------ | ------------------ |
| 192.168.254.0/24 | 256 | 1 | 0.4 % |

### Loopback0 Interfaces Node Allocation

| POD | Node | Loopback0 |
| --- | ---- | --------- |
| ATD_LAB | core-7280SR-48C6 | 192.168.254.1/32 |

### VTEP Loopback VXLAN Tunnel Source Interfaces (VTEPs Only)

| VTEP Loopback Pool | Available Addresses | Assigned addresses | Assigned Address % |
| --------------------- | ------------------- | ------------------ | ------------------ |
| 192.168.255.0/24 | 256 | 0 | 0.0 % |

### VTEP Loopback Node allocation

| POD | Node | Loopback1 |
| --- | ---- | --------- |
