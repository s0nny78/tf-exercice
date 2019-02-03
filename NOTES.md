# AWS Terraform Exercise Notes
https://github.com/s0nny78/tf-exercice

Req:
$ terraform --version
Terraform v0.11.11
+ provider.aws v1.57.0
--
Most of it is in user-data for now. Would be able to improve the solution with more time
This use S3 for config file. Would need to use File Provisioner with more time

I used my own nginx.conf file but could have added the line: "server_names_hash_bucket_size 128" (for longer DNS)
The deployment takes around 5min so there is a sleep before trying the curl but could have made a while bash

--
Create and Run TF final ex
```bash
git clone -b javaf git@github.com:s0nny78/tf-exercice.git
cd tf-exercice/
terraform init
# terraform plan -var-file=virginia.tfvars
terraform apply -var-file=virginia.tfvars -auto-approve

terraform destroy -var-file=virginia.tfvars -auto-approve
```

Debug commands in the EC2:
```bash
lsof -i -P -n |grep 8080
sudo nginx -t
```

Exercices:
1st elb branch
2nd elb-us branch
3rd bastion branch
4th javaf branch
(! nothing merged to master)


To do:
* Use Bastion id-rsa for ec2 or add the bastion in authorized_hosts
* More vars and nothing hardcoded. Code ++
* Naming and Taging. Code ++
* Use EFS. Security ++
* Autoscaling group for ELB instead of 2 EC2. Cost ++
* 80 on EC2 only from the ELB. Security ++
* Try bastion module: https://registry.terraform.io/modules/Guimove/bastion/aws/1.1.0
* re-org the module (seperate vpc and elb,ec2,s3)
* bucket policy for s3
* Stop to use s3 for files but push them from tf
* Route53
* Create an AMI to re-use