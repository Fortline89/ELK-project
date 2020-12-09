#!/bin/bash

#Check if script was run as root. Exit if false.
if [ $UID -ne 0 ]; then
  echo "Please run this script as root."
  exit
fi

# Define Variables
output=$HOME/research/sys_info.txt
ip=$(ip addr | grep inet | tail -2 | head -1)
execs=$(sudo find /home -type f -perm 777 2>/dev/null)
cpu=$(lscpu | grep CPU)
disk=$(df -H | head -2)

# Define Lists to use later
commands=(
  'date'
  'uname -a'
  'hostname -s'
)

files=(
  '/etc/passwd'
  '/etc/shadow'
)

#Check for research directory. Create it if needed.
if [ ! -d $HOME/research ]; then
  mkdir $HOME/research
fi

# Check for output file. Clear it if needed.
if [ -f $output ]; then
  > ~/research/sys_info.txt
fi

##################################################
#Start Script

echo "A Quick System Audit Script" >> ~/research/sys_info.txt
echo "" >> ~/research/sys_info.txt

for x in {0..2}; do
  results=$(${commands[$x]})
  echo "Results of "${commands[$x]}" command:" >> ~/research/sys_info.txt
  echo $results >> ~/research/sys_info.txt
  echo "" >> ~/research/sys_info.txt
done

# Display Machine type
echo "Machine Type Info:" >> ~/research/sys_info.txt
echo -e "$MACHTYPE \n" >> ~/research/sys_info.txt

# Display IP Address info
echo -e "IP Info:" >> ~/research/sys_info.txt
echo -e "$ip \n" >> ~/research/sys_info.txt

# Display Memory usage
echo -e "\nMemory Info:" >> ~/research/sys_info.txt
free >> ~/research/sys_info.txt

#Display CPU usage
echo -e "\nCPU Info:" >> ~/research/sys_info.txt
lscpu | grep CPU >> ~/research/sys_info.txt

# Display Disk usage
echo -e "\nDisk Usage:" >> ~/research/sys_info.txt
df -H | head -2 >> ~/research/sys_info.txt

#Display who is logged in
echo -e "\nCurrent user login information: \n $(who -a) \n" >> ~/research/sys_info.txt

# Display DNS Info
echo "DNS Servers: " >> ~/research/sys_info.txt
cat /etc/resolv.conf >> ~/research/sys_info.txt

# List exec files
echo -e "\nexec Files:" >> ~/research/sys_info.txt
for exec in $execs; do
  echo $exec >> ~/research/sys_info.txt
done

# List top 10 processes
echo -e "\nTop 10 Processes" >> ~/research/sys_info.txt
ps aux --sort -%mem | awk {'print $1, $2, $3, $4, $11'} | head >> ~/research/sys_info.txt

# Check the permissions on files
echo -e "\nThe permissions for sensitive /etc files: \n" >> ~/research/sys_info.txt
for file in ${files[@]}; do
  ls -l $file >> ~/research/sys_info.txt
done