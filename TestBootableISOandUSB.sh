#!/bin/bash 
#Author: Narges Ahmadi (NarcisLinux)  Email:n.sedigheh.ahmadi@gmail.com
#Vertion 1
#
#Using QEMU to test an ISO or bootable USB drive.
#
if [ $(which apt >/dev/null 2>&1 ; echo $?) -eq 0 ]
then
   
   if [ ! $( dpkg -s qemu >/dev/null 2>&1;echo $?) -eq 0 ]
   then 
   	apt install qemu
	
   fi
   qemu-system-x86_64 -hda /dev/$1

elif [ $(which pacman >/dev/null 2>&1 ; echo $?) -eq 0 ]
then
   
   if [ ! $( pacman -Qi qemu >/dev/null 2>&1;echo $?) -eq 0 ]
   then 
	pacman -Sy qemu
   fi
   qemu-system-x86_64 -hda /dev/$1

elif [ $(which yum >/dev/null 2>&1 ; echo $?) -eq 0 ]
then
   
   if [ ! $( dpkg -s qemu >/dev/null 2>&1;echo $?) -eq 0 ]
   then 
	yum install epel-release
   	yum install qemu-system-x86.x86_64
    fi
    qemu-system-x86_64 -hda /dev/$1

else
    echo "Script: I can't find your pakage manager! open script and change it :D! bye! "
fi 
