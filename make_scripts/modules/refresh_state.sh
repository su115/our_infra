#! /bin/bash

path=$1
prepath=gcp/

tmp=$PWD

# refresh state
for i in ${path[@]}
do
	cd "$tmp/$prepath$i"
	terraform refresh 
done


