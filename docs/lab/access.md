# Campus Lab Overview

You've made it, now what? Well, you and a room full of other engineers are sitting in front of a series of access pods. These Arista switches, while small, run the same Arista EOS images as our 1700lb 16 slot chassis.

Get familiar with your fellow student, you will be working together to configure the pod in front of you. In total there are:

- [x] 2 x Students assigned per pod
- [x] 12 x Arista Campus Pods

## Topology

![ATD Student Pod](../assets/images/topology/atd_student-light.png#only-light)

## Equipment

The hardware you see sitting in front of you can

<div class="grid cards" markdown>

- :cloudvision: **Lab Software**

    ---

    Each pod will be provided their own instance of:

      - [x] **Arista CloudVision as a Service (CVaaS)** - Our management, orchestration, and visibility
      - [x] **Arista CloudVision Cognitive Unified Edge (CV-CUE)** - Our wireless management, orchestration, and visibility
      - [x] **Arista Guardian Network Identity (AGNI)** - Our Network Access Control

- :fontawesome-solid-flask: **Lab Hardware**

    ---

    The hardware you see sitting in front of you:

      - [x] 2 x C-230 controllerless AP
      - [x] 1 x 710P-12P running EOS

- :fontawesome-solid-user: **Student Equipment**

    ---

    As part of this lab workshop, it was recommended to have brought the following:

      - [x] Laptop
      - [x] Extra screen (optional)
      - [x] USB/USB-C Ethernet dongle
      - [x] Ethernet Cable
      - [x] Console Cable

- :octicons-tasklist-24: **Student Config**

    ---

    You will work in collaboration with your fellow student, keep this information handy

      - [x] Your STUDENT number. See Lab Assignment
      - [x] Your POD number. See Lab Assignment
      - [x] Your LOGIN ID. Your corporate email address.
      - [x] Your PASSWORD. Emailed to you upon Arista Launchpad account creation

</div>

## Lab Assignment

<div class="grid cards" markdown>
{{ read_csv('data/orlando_lab_assignment.csv',colalign=("left","center","center"), usecols=['Email','Lab Assignment','Student Pod #']) }}
</div>

--8<--
docs/snippets/login_cv.md
--8<--
