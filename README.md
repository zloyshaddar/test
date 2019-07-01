### Kops pre-installation actions:
```
aws s3api create-bucket --bucket shaddar-kops --create-bucket-configuration LocationConstraint=eu-central-1 --acl "private"
kops create secret --name cluster.k8s.local sshpublickey admin -i E:\work\keys\shaddar.ssh-rsa.pub
set KOPS_STATE_STORE=s3://shaddar-kops
```
### Create Route 53 hosted zone via web cosole with parameters:
```
Domain Name: cluster.shaddar.local
Type: Private Hosted Zone for Amazon VPC
Associated VPC: vpc-429feb29 | eu-central-1
```
### Create kops cluster with default configuration (1 master node, 2 worker nodes):
```
kops create cluster --name cluster.k8s.local --zones eu-central -1a,eu-central-1b --state s3://shaddar-kops --yes
```
### Checking cluster:
```
kops validate cluster
kubectl get nodes
```
### Creating instance for Concourse via web cosole with parameters:
```
OS: Debian 9
Instance size: t2.medium
Storage: 16GB
Security group: custom, ssh access only from own PC
```
### Install Docker:
```
sudo apt update
sudo apt upgrade
sudo apt install apt-transport-https ca-certificates curl software-properties-common gnupg2
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce
```
### Check Docker is ok and running:
```
sudo systemctl status docker
docker -v
```
### Install Concourse and Fly CLI:
```
wget https://concourse-ci.org/docker-compose.yml
docker-compose up -d
wget https://github.com/concourse/concourse/releases/download/v5.3.0/fly-5.3.0-linux-amd64.tgz
tar -zxf fly-5.3.0-linux-amd64.tgz -C /usr/bin
fly --target example login --concourse-url http://localhost:8080
```
### Create and run job for building docker image and pushing it to ECR:
```
fly -t example set-pipeline -p test -c job.yml
fly -t example unpause-pipeline -p test
fly -t example trigger-job -j test/push
```
