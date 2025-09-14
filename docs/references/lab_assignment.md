# Nashville Lab Assignment - Oct. 28-29, 2025

## Access Points Serial Numbers
{{ read_csv('data/lab_assignment.csv',colalign=("left","center","center"), usecols=['Email','AP#1','AP#2']) }}

## Student and Pod Assignment
{{ read_csv('data/lab_assignment.csv',colalign=("left","center","center","left"), usecols=['Email','Lab Assignment','Student Pod #','ATD Token']) }}

## Topology

![ATD Student Topology](../assets/images/topology/atd_student-light.png)
