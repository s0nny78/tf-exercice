# AWS Terraform Exercise Notes
$ terraform --version
Terraform v0.11.11
+ provider.aws v1.57.0
--

```bash
terraform plan -var-file=[region].tfvars -parallelism=1
terraform apply -var-file=[region].tfvars -auto-approve -parallelism=1
terraform destroy -var-file=[region].tfvars -auto-approve -parallelism=1
```

You can test the deployment using the following command:

```bash
terraform output web_domain | xargs curl
```

`https://github.com/sebwells/example-java-spring-boot-app`

To do:
⋅⋅* 1 SG for the 2 EC2. Code ++
⋅⋅* More vars and nothing hardcoded. Code ++
⋅⋅* Naming and Taging. Code ++
⋅⋅* Use EFS. Security ++
⋅⋅* Autoscaling group for ELB instead of 2 EC2. Cost ++
⋅⋅* 80 on EC2 only from the ELB. Security ++
⋅⋅* Try bastion module: https://registry.terraform.io/modules/Guimove/bastion/aws/1.1.0