# Atlanta Lab Assignment - November 11-12, 2025

## Access Points and Switches Serial Numbers

{{ read_csv('data/lab_assignment.csv',colalign=("left","center","center","center"), usecols=['Email','AP#1','AP#2','Switch']) }}

## Student and Pod Assignment

{{ read_csv('data/lab_assignment.csv',colalign=("left","center","center","left"), usecols=['Email','Lab Assignment','Student Pod #','CV-CUE ATN']) }}

## ATD Token Access - One-Click Launch

!!! tip "🚀 One-Click ATD Access"
    Click any ATD Token URL below to launch your Arista Test Drive topology in a new browser tab.

{{ read_csv('data/lab_assignment.csv',colalign=("left","center","center","left"), usecols=['Email','Lab Assignment','Student Pod #','ATD Token']) }}

## Topology

![ATD Student Topology](../assets/images/topology/atd_student-light.png)

### 📧 Support
If you experience any issues with ATD access:
- Verify your internet connection
- Try refreshing the ATD page
- Contact the workshop instructor for assistance
