# APPLICATION PACKAGE MANAGEMENT

In this exercise PHP7.4 was installed using the ppa:ondrej/php package repository.

In this exercise we were asked to install PHP7.4 using the ppa:ondrej/php package repository.


I installed php7.4 using the following commands:

1. `sudo apt update` to ensure I have the latest versions of anything i want to install.

2. `sudo add-apt-repository ppa:ondrej/php` Add the PPA Repository which gives access to updated PHP packages.

3. `sudo apt-get update` Refreshes the local package list, ensuring the system recognizes the newly added repository and its available packages.

4. `sudo apt-get install php7.4` Installs PHP version 7.4 and its common modules onto the system.

5. `php7 -v` Checks and displays the installed PHP version to confirm that PHP 7.4 is now the active version on the system. See the output below

![php -v](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/exercise-4/images/Screenshot%20(5).png)

6. The `/etc/apt/sources.list` file is a configuration file for Linux's Advanced Package Tool (APT). It contains URLs and other details about remote repositories, serving as a reference for installing software packages and applications on the system.

![cat /etc/sources.list](https://raw.githubusercontent.com/MiracleAguegbo/altschool-cloud-exercises/main/exercise-4/images/Screenshot%20(6).png)