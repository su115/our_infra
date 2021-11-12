# Create SSH tunnel
![ssh tunnel](https://prnt.sc/1za09qy)
```sh
# 1. Create tunnel to master
ssh -fNL 6443:master-1:6443 debian@$EXTERNAL_IP
# or by `make`
#make get/create-ssh-tunnel # in future
```
# Set kubectl
```sh

# 2. add master-1 to localhost:/etc/hosts
# Once only!!!
sudo echo "127.0.0.1	master-1" >>  /etc/hosts 

# 3. Copy from master-1:/etc/kubernetes/admin.conf to localhost:~/.kube/config
# manual
# or by `make`
#make get/get-kubeconfig # in future

# 4. Test
kubectl get nodes
```
