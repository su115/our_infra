***
## Installing cluster 
***
### Before instalation you will need have 
---
* Terraform on your side
* credential file >>> *.json
* ssh key  >>> id_rsa.pub
> ### > Check in cloud-config file > node-tags = "instance tag"
> ### > You need to labele your instances 
1. Make a clone repo 
    ```sh
    git clone https://github.com/su115/our_infra.git
    cd our_infra
    ```
2. Build infrastructure by
    ```sh
    terraform init
    terraform apply -auto-approve
    ```
    You will get 
    ![infra](https://lucid.app/publicSegments/view/26cca3ba-e60f-4c0a-b04c-934f3c6abd24/image.jpeg)

3. Copy ssh key to bastion & change permitions to it
    ```sh
    scp <path to id_rsa> <bastion ip>:/home/<user>/.ssh/
    scp helm-install.sh <bastion>:/
    ssh bastion
    chmod 400 /home/<user>/.ssh/id_rsa
    ```
4. Installing cluster
    * Preperation befor install (bastion)
        * 
        ```sh
        cd kube-gcp
        chmod 700 ansible_install.sh
        ./ansible_install.sh
        ```
    * Installing
        ```sh
        cd kube-gcp
        ansible-playbook -i hosts -m cluster-install.yml
        ```
    
5. Go to master VM and install helm
    ```sh
    ./helm-install.sh
    ```
6. ### Installing Prometheus & Grafana by using  [HELM charts](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack#configuration)
    
7. ### CLUSTER
    ![Cluster](https://lucid.app/publicSegments/view/0d136a97-87b0-45a4-b7d7-5fe7323f947f/image.jpeg)
