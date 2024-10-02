# CVaas Setup: AVD

This is a how to deploy the Campus Workshop using Arista AVD and the `cv_deploy` module. The reuslts of this setup will include

- [x] An AVD repostiory of the lab configuration
  - [x] AVD Documentation 
  - [x] ANTA Validation 
- [x] CloudVision Static Studios
  - [x] Devices onboard to studios
  - [x] Single configlet per device powered by AVD
  - [x] Change Control deployment

## CVaaS Setup

Details needed for CVaaS setup

- Enable `Studios - End-to-End Provisioning`
- Generate a Service Account for Automation
  - Create a new service account and document the API key (this will be used for AVD)
- ZTP Switches: pre cabled to match Pod architecture
- Run the AVD playbook

