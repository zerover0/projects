# Evergreen Server Setup

### Hardware configuration
- Model : HPE DL360 Gen9 (1U)
- CPU : 1 x Intel Xeon E5-2630 v4 10 cores 2.2GHz
- RAM : 1 x 16GB DDR4 2400MHz
- LAN : 4 x 1Gbps Ethernet
- HDD : HP 300GB 6G SAS 10K 2.5in (8 SFF HDD Bays)
- DVD : DVD-RW
- PCIe : 2 x PCIe 3.0 (1-FH, 1-LP)
- Power : HP 500W
- Warranty : 3 years

### Softwares installed
- OS : Ubuntu 14.04 LTS Desktop x86_64
- NTP server
- SSH server

### Initial setup after Ubuntu installation

##### Newtork configuration
* Edit '/etc/network/interfaces' by adding static IP settings
```
- File: /etc/network/interfaces
auto eth0
iface eth0 inet static
address 10.0.0.188
netmask 255.255.254.0
gateway 10.0.0.1
dns-nameservers 10.0.0.1
```
* Edit '/etc/hostname' to change hostname
```
- File: /etc/hostname
evergreen
```
* It's necessary to boot in order to apply the setting.

##### File system setup
* Edit '/etc/fstab' to set 'noatime' for performance improvement
```
- File: /etc/fstab
UUID=3ddbc40e-6829-4007-b6b3-86b674781389 /               ext4    errors=remount-ro,noatime 0       1
```
* It's necessary to boot in order to apply the setting.

##### Initial system update
* Please check date and time by running 'date' command before software update if date and time is correct. If there is a big gap between real and system time, the upate may fail with errors.
```sh
$ date
2016. 12. 23. (금) 16:41:08 KST
```
* Update software repositories information
```sh
$ sudo apt-get update
```
* Update all packages and system
```sh
$ sudo apt-get upgrade
```

##### NTP setup
* NTP server will sync date and time automatically with Internet NTP servers.
* Install NTP server
```sh
$ sudo apt-get install ntp
```

##### SSH setup
* SSH server is necessary to log in and open the terminal remotely.
* Install SSH server
```sh
$ sudo apt-get install ssh
```


##### JDK setup
* JDK(Java Development Kit) is necessary to run Hadoop ecosystem.
* Install JDK 8
```sh
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update
$ sudo apt-get install oracle-java8-installer
```
* Make a symbolic link to JDK 8 in order to set the JAVA environment variable easily
```sh
$ sudo ln -s /usr/lib/jvm/java-8-oracle /usr/lib/jvm/default-java
```

##### Python Anaconda setup
* Anaconda is an open data science platform by Python.
* Download Anaconda Linux 64 bit version for Python 3.5
  - https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh
* Open a terminal and run the following command to install Anaconda
```sh
$ bash Anaconda3-4.2.0-Linux-x86_64.sh
```

##### Creating a user account for Hadoop ecosystem
* Generate a public/private RSA key pair for later use.
```sh
$ ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa
```
