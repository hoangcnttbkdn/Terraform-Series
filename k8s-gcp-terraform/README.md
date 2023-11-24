This repository contain Terraform code to create a simple infrastructure. I think GPC is best choice for practice with kubernetes.
### Installation
**Terraform**

* Step 1 - Create `terraform.tfvars` file and fill variables

  ```js
  project_id  = "radiant-land-404711"
  region      = "asia-southeast1"
  credentials = "./gcp-credential.json"
  name        = "cka"
  username    = "hoangbvh"
  ```
* Step 2 - Run `terraform plan` to see estimate output 
* Step 3 - Run `terraform apply --auto-approve` to deploy your infrastructure
* Step 4 - Run `terraform destroy --auto-approve` to destroy your infrastructure

**SSH**

* Refresh old ssh
  ```shell
  ssh-keygen -R [bastion-ip]     # bastion host public IP
  ssh-keygen -R 10.0.16.2        # control plane private IP
  ssh-keygen -R 10.0.16.3        # worker node 1 private IP
  ...
  ```
* Using jump host to ssh to internal virtual machine
  ```shell
  ssh -J [username]:[bastion-ip] [username]:10.0.16.2       # control plane
  ssh -J [username]:[bastion-ip] [username]:10.0.16.3       # worker node
  ...
  ```
**Kubernetes**

Step 1 - Print join command for worker node
* SSH to control plane
* Run command `sudo kubeadm token create --print-join-command`
* Copy output and run it to each worker nodes
* Run command to label to each worker nodes `kubectl label node [node-name] node-role.kubernetes.io/worker=worker`

### Kubernetes Cheatsheet
**Node**
* Get node: `kubectl get nodes`
* Describe node: `kubectl describe nodes [node-name]`

**Deployment**
* Create deployment: `kubectl create deployment app-cache --image=memcached:1.6.8 --
  replicas=4`
* Get deployment: `kubectl get deployment`
* Describe deployment: `kubectl describe deployment [deployment-name]`
* Roll out a new version: `kubectl set image deployment [deployment-name] [image-name]:[image-name]:[image-tag]`
* Get current rollout status: `kubectl rollout status deployment [deployment-name]`
* Get list revision: `kubectl rollout history deployment [deployment-name]`
* Rollback to previous revision: `kubectl rollout undo deployment [deployment-name] --to-revision=[revision-id]`. When you rollback previous revision, the history will be remove previous revision id and create new revision id.
* Increase number of replica from 4 to 6: `kubectl scale deployment [deployment-name] --replicas=6`
* Create a HPA for an existing Deployment: `kubetcl autoscale deployment [deployment-name] --cpu-percent=[number] --min=[number] --max=[5]`
* List of HPA: `kubectl get hpa`
### References
* https://github.com/fabianlee/wireguard-test-gcp-aws-roaming/blob/main/gcp-infra/vms.tf