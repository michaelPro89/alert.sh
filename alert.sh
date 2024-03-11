#!/bin/bash
# Author : Michal Switala
# Compare strings
string1="jira"
string2="09"
string3="10"

# array with created jira servers
jiras=()

# declare inital start here
initial_start=true
scanning=true
total_jiras=

# Specify the file name for Alerts
# Check if the file already exists
if [ ! -e "alerts.txt" ]; then
          # Create the file only if it doesn't exist
            echo "Hello, this is some text." > "alerts.txt"
            echo "File created successfully."
      else
            echo "File already exists. Not overwriting."
fi


# start scanning
while [ scanning ]; do

# this will return all jira dir where script has been executed
dires=$(ls | grep "jira*")

# Convert the space-separated list into an array
IFS=$'\n' read -r -d '' -a sorted_array <<< "$dires"


for item in "${sorted_array[@]}"; do

counter2=10
counter=1
max=9
max2=99
 


#checking dirs from 01 to 09
while [ "$counter" -le "$max" ]; do

  number=0
  string=$string1$number$counter

 # echo " test checking string >  $string"

        if [ "$item" == "$string" ]; then
        
        jiras+=("$item")
        break
     
        fi
        ((counter++))


done

# chceking dirs from 10 to 99
while [ "$counter2" -le "$max2" ]; do

  string=$string1$counter2

  #echo " test checking string >  $string"

        if [ "$item" == "$string" ]; then
        #   echo " adding $item because it is equal to $string"
       jiras+=("$item")
        break
        #else
        #      echo "The string $item ise not equal to $string"
        fi
        ((counter2++))
done


done


# check now if all jira dirs have been collected if new have been created
if $initial_start; then

     
        # save just ONCE how many jira dir there is now
        total_jiras="${#jiras[@]}"
        initial_start=false
  

fi

current_jiras=${#jiras[@]}

# create alerts here to notifty user
if [ "$current_jiras" -gt "$total_jiras" ]; then

        current_date=$(date)
 
        echo "ALERT on $current_date there has been created new jira server. " >> "alerts.txt"


        break
fi

if [ "$current_jiras" -lt "$total_jiras" ]; then


        echo "ALERT some jira server has been deleted. "

        current_date=$(date)
 
        echo  "ALERT on $current_date ALERT some jira server has been deleted. " >> "alerts.txt"


        break

fi

# remove data from variables before next run
unset jiras
unset dires

done
