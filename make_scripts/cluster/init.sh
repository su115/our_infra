#! /bin/bash
# Target: cluster/init
list=$1
prepath="gcp"
modules_path="make_scripts/modules"

# check path
if ! $modules_path/check_path.sh $list; then
	exit 1
fi

# init
for i in  $list ; do 
	terraform -chdir="$prepath/$i" init
done
echo "[init cluster] OK"
