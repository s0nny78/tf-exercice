# AWS Terraform Exercise Notes
$ terraform --version
Terraform v0.11.11
+ provider.aws v1.57.0
--

```bash
terraform plan -var-file=[region].tfvars -parallelism=1
terraform apply -var-file=[region].tfvars -auto-approve -parallelism=1

terraform destroy -target RESOURCE_TYPE.NAME -var-file=[region].tfvars
terraform destroy -var-file=[region].tfvars -auto-approve -parallelism=1
```

You can test the deployment using the following command:

```bash
terraform output web_domain | xargs curl
```

`https://github.com/sebwells/example-java-spring-boot-app`

For testing (UL/DL):
https://transfer.sh/

Java commands:
```bash
wget https://transfer.sh/%28/qPvSl/demo-0.0.1-SNAPSHOT.jar%29.zip
unzip "demo-0.0.1-SNAPSHOT.jar).zip"
rm -rf "demo-0.0.1-SNAPSHOT.jar).zip"

sudo yum install java-1.8.0
# sudo yum remove java-1.7.0-openjdk
# sudo yum install tomcat8
java8 -jar demo-0.0.1-SNAPSHOT.jar

lsof -i -P -n |grep 8080

# update conf
# /etc/nginx/conf.d/java.conf

# add at the end of file /etc/nginx/nginx.conf
server_names_hash_bucket_size 128;

sudo nginx -t
sudo service nginx restart

```


To do:
* 1 SG for the 2 EC2. Code ++
* More vars and nothing hardcoded. Code ++
* Naming and Taging. Code ++
* Use EFS. Security ++
* Autoscaling group for ELB instead of 2 EC2. Cost ++
* 80 on EC2 only from the ELB. Security ++
* Try bastion module: https://registry.terraform.io/modules/Guimove/bastion/aws/1.1.0
* re-org the module (seperate vpc and ec2,s3)
* bucket policy for s3