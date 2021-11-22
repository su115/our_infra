#! /bin/bash
# Target: cluster/apply
list=$1
prepath="gcp"
modules_path="make_scripts/modules"


# check path
if ! $modules_path/check_path.sh $list; then
	exit 1
fi

# apply
for i in  $list ; do 
	terraform -chdir="$prepath/$i" apply -auto-approve
done
echo "[apply cluster] OK"
