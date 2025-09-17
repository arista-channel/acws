# Orlando Lab Assignment - July 14-15, 2025

## Access Points and Switches Serial Numbers
{{ read_csv('data/orlando_lab_assignment.csv',colalign=("left","center","center","center"), usecols=['Email','AP#1','AP#2','Switch']) }}

## Student and Pod Assignment
{{ read_csv('data/orlando_lab_assignment.csv',colalign=("left","center","center","left"), usecols=['Email','Lab Assignment','Student Pod #','CV-CUE ATN']) }}

## Topology

![ATD Student Topology](../assets/images/topology/atd_student-light_orlando.png)
