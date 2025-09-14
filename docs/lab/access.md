# Lab Access

Welcome to the Arista Campus Workshop! This page provides you with the necessary information to access your lab environment.

## Lab Environment

Each participant will be assigned a dedicated lab environment with the following components:

- **Student Pod**: Your assigned pod number
- **Lab Assignment**: Your student designation (Student-a, Student-b, etc.)
- **ATD Token**: Your Arista Test Drive token for lab access

## Important Notes

- Please use only your assigned lab environment
- Do not interfere with other participants' lab setups
- If you encounter any issues, please notify your instructor immediately

## Lab Credentials

Your instructor will provide you with the necessary credentials to access:

- **CloudVision-as-a-Service (CVaaS)**: Your ATD Token
- **AGNI Portal**: For wireless policy management
- **Lab Switches**: Direct CLI access when needed

## Topology

![ATD Student Topology](../assets/images/topology/atd_student-light.png)

## Lab Assignment

<div class="grid cards" markdown>
 {{ read_csv('data/lab_assignment.csv',colalign=("left","center","center","left"), usecols=['Email','Lab Assignment','Student Pod #','ATD Token']) }}
</div>

--8<--
"snippets/workspace.md"
--8<--
