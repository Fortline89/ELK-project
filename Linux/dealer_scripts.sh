
#!/bin/bash


cat Combined_Dealer_schedule | grep -E "05:00:00 AM|08:00:00 AM|02:00:00 PM|08:00:00 PM|11:00:00 PM" | awk -F " " '{print $1, $2, $5, $6}' 


# Roulette dealer finder by time
# prompt format hh:mm:ss AM/PM mmdd

read -p  "Enter the time (hh:mm:ss AM/PM) to find roulette dealer." time
read -p  "Enter the date (mmdd)." date

echo $date
grep "$time" "$date"_Dealer_schedule | awk -F" " ' {print $1, $2, $3, $4}'

 

