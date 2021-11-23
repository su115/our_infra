#! /bin/bash

path=$2
prepath=gcp/

script=$1
tmp=$PWD

# refresh state
for i in ${path[@]}
do
	cd "$tmp/$prepath$i"
#	echo "$tmp/$prepath$i" # Debug
	for item in $(terraform state list)
	do
#		echo $item # Debug
		if [[ $item =~ "google_compute_instance" ]]; then
#			echo $item is instance # Debug
#			terraform state show google_compute_instance.gitlab[0] |  grep "desired_status" | cut -d "\"" -f 2	
			state=$(terraform state show $item)
			$script $state
		fi
	done
done


