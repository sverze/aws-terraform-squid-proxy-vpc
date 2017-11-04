# AWS / Terraform Squid Proxy VPC

This project aims to build a secure network hosting resilient micro services and a database cluster all in [AWS](https://aws.amazon.com/).
The provisioing of all the infrastructure and services is done using [Terraform](https://www.terraform.io/).
The micro services are [Spring Boot](https://projects.spring.io/spring-boot/) java containers offering a simple RESTfull CRuD service.
The data base cluster is an [RDS Aurora](https://aws.amazon.com/rds/aurora) cluster.

The following diagram depicts what you can build if you follow the subsequent instructions.

![Resilent VPC](aws-terraform-squid-proxy-vpc.png)

## Set-Up

You will need the following tools and accounts to make it happen

### AWS Account

You will need an AWS account, just [Sign-Up](https://aws.amazon.com/free)

### SSH Key

You will need to set-up your desired AWS region with a secure key pair.
This project is using London (eu-west-2) as the region I suggest you keep this the same as there are AMI's referenced that are region sensitive.

[EC2 Key Pairs](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html) has instructions on how to set-up your key pair.

Once you have set-up key pair you will have access to the PEM file that needs to be stored safely.
Terraform assumes that the PEM is available in your local key chain, you can add it it to your key-chain by running the following command

```commandline
ssh-add -K your-key.pem
```

### Terraform

Install terraform command line tool. Depends on your OS, [Install Terraform](https://www.terraform.io/intro/getting-started/install.html) has some descent instructions.

If you are using OSX I suggest you use [Homebrew](https://brew.sh/) to install the terraform package.

### Anything Else

If you intend to play around with the micro-service you will need a few other tools as well.
There will be further instructions on setting up the micro service a little latter.

## Building / Running

### First Time

There is an issue with the REST services not starting correctly if the Aurora cluster has not completed creation in time.
Terraform should have proper module dependencies in place shortly, follow this thread [1178](https://github.com/hashicorp/terraform/issues/1178) for details.
In the mean time the workaroud has been implemented although it does not always work.

The Aurora cluster takes quite a bit of time to create so I suggest that you target build that module first

```commandline
terraform apply -target=module.aws_aurora_cluster
```

Once the Aurota cluster is up and running in the Green Zone of the VPC you are ready to apply the remaining template

```commandline
terraform apply
```

If you decide to build the whole estate upfront and the micro service did not start up correctly you have 2 option.
Firstly you can SSH to the Amber Zone instances re-start the docker containers or secondly you can taint the instances and reapply the template.
The following section explains how you do that.

### Subsequent Times

You will find that you may want to play around with the REST services which means you will redeploy them regularly.
If you do get this point you will undoubtedly changed the terraform scripts to source your own REST docker servcie from your own registry.

The following command is how to teardown the Amber Zone instances and redeploy them without destroying the entire stack.

```commandline
terraform taint -module=aws_docker_amb_az_a aws_instance.docker
terraform taint -module=aws_docker_amb_az_b aws_instance.docker
terraform apply
```

## Microservice

```commandline
mvn clean package docker:build
docker push sverze/aws-terraform-2-tier-service:latest
docker run -p 8080:8080 aws-terraform-2-tier-service
```
