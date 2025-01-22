# Lab Access

Welcome to the Arista Cmapus ATD Workshop! 

## Labs

As part of this workshop, you will be copnfiguring and interacting with Arista's campus ecosystem. Each pod is con

- [x] 12 x Arista Campus Pods
- [x] 2 x Students assigned per pod

Each Arista Campus Pod is equiped with the hardware in front of you and the software

<div class="grid cards" markdown>

- :cloudvision: **Software**

    ---

    Each pod will be provided their own instance of each of the following:

      - [x] Arista CloudVision as a Service (CVaaS)
      - [x] Arista Guardian Network Identity
      - [x] Arista CloudVision Cognitive Unified Edge (CV-CUE)

- :material-router-network-wireless: **Hardware**

    ---

    Each pod will be provided the following hardware:

      - [x] 2 x C-360 
      - [x] 2 x 710P-16P
      - [x] 2 x Raspberry Pi 

</div>

## Login

Each lab is assigned with the following login information

| Student 1 Email | tola.atd1+pod##@gmail.com |
| Student 2 Email | tola.atd2+pod##@gmail.com |
| Password | `will be provided` |
| Launchpad Access | https://login.wifi.arista.com/ | 

There are three peices of software (wired, wirless, and NAC) we interact with, but all is configured with SSO and managed within Arista Luanchpad. Follow the steps below to get logged in.

1. Navigate to the [Arista CloudVision as a Service (CVaaS) instance](https://www.cv-staging.corp.arista.io/) for your lab to access: [https://www.cv-staging.corp.arista.io/](https://www.cv-staging.corp.arista.io/)

    [:cloudvision: Open CVaaS](https://www.cv-staging.corp.arista.io/){ .md-button .md-button--primary target=_blank}

2. In the `Organization` box enter the Organization name `tola-atd-##`  where `##` is a 2 digit character between 01-12 that was assigned to your lab/pod, then click “Enter”.

    ![CloudVision Login](../assets/images/login/00_cvaas_login.png)

3. Click the `Log in with Launchpad` button and provide your assigned lab/pod email address and password:

    ![Launchpad Login](../assets/images/login/01_launchpad_login.png)

## Topoology

=== "Student Lab"

    ![ATD Student Pod](../assets/images/login/atd_student-light.png#only-light)
    ![ATD Student Pod](../assets/images/login/atd_student-dark.png#only-dark)


=== "Full Lab topology"

    ![ATD Low Level](./assets/images/login/atd_low_level.png)

--8<-- "includes/abbreviations.md"
