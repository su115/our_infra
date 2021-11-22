#! /bin/bash
# Target: cluster/destroy
list=$1
prepath="gcp"
modules_path="make_scripts/modules"


# check path
if ! $modules_path/check_path.sh $list; then
	exit 1
fi

# destroy
for i in  $list ; do 
	terraform -chdir="$prepath/$i" destroy -auto-approve
	echo "$prepath/$i"
done
echo "[destroy cluster] OK"
