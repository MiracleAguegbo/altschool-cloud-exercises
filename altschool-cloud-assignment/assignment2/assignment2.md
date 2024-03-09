# Bash Script Assignment

# 1

Write a shell script that checks the disk usage in a given directory.
the script can take two optional arguments and one compulsory argument...

-d: which means that all files and directory within the specified directory or directories should be listed.

-n: which means that the top N enteries should be returned.
list of directories: this will be the directories you want to check it's disk usage

eg yourscript.sh -n 5 /var
should return the top 5 directories wrt disk usage in /var directory

yourscript.sh -d /var
should list both directories and files

Note: if -n argument is not given, it should return 8 enteries by default.


2. Create a backup script. This script creates a backup of a given directory and saves it in another directory with a timestamp. It takes two arguments:
the source directory and the destination directory

Note: The backup should be a tar archive

## Solution 1

The image below represents the bash script for checking the disk usage.

![](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/altschool-cloud-assignment/assignment2/images/disk_check.png)

This image represents how the command was executed;

![](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/altschool-cloud-assignment/assignment2/images/2.png)

![](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/altschool-cloud-assignment/assignment2/images/3.png)

This one represents when the command is executed without an arguement

![](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/altschool-cloud-assignment/assignment2/images/4.png)

 # 2

Create a backup script. This script creates a backup of a given directory and saves it in another directory with a timestamp. It takes two arguments: the source directory and the destination directory.

# Solution 2

![](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/altschool-cloud-assignment/assignment2/images/back_up_sh.png)

This image represents how the command was executed;

![](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/altschool-cloud-assignment/assignment2/images/Screenshot%202024-03-09%20120444.png).