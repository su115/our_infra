#! /bin/bash
# Target: cluster/apply
list=$1
prepath="gcp"
modules_path="make_scripts/modules"


# check path
if ! $modules_path/check_path.sh $list; then
	exit 1
fi

# resfresh state
#if ! $modules_path/refresh_state.sh "$list";
#then
#		echo "state refresh"
#fi

# check_vm_status
$modules_path/check_vm_status_on.sh "echo" "$list"


# apply
for i in  $list ; do 
#	terraform -chdir="$prepath/$i" apply -auto-approve
	echo 0909
done
echo "[on cluster] OK"
