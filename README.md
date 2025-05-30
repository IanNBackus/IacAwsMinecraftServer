# AWS Minecraft Server With IaC Guide

This document will take you through the step-by-step process of getting your AWS-Hosted Minecraft Server up and running without manually using the AWS Management Console or manually SSH-ing into an AWS EC2 instance. 

_-This tutorial assumes that you are in posession of a funded "AWS Learner Lab" account._
_-This tutorial assumes that you are on a local Windows system._

## Running On Local System Guide Sections:
- Local Tool Requirements
- Local Pipeline Section 1: EC2 Instance Setup/Configuration
- Local Pipeline Section 2: Minecraft Server Setup Via AWS CLI

## >Local Tool Requirements:

Before we're able to run these scripts we'll need to download and configure Terraform and AWS CLI.

1. Download the 64-bit Terraform for Windows [here](https://releases.hashicorp.com/terraform/1.12.1/terraform_1.12.1_windows_amd64.zip).
2. Note where you put this terraform.exe file, add the filepath to your system's PATH variable.
3. Download AWS CLI [here](https://awscli.amazonaws.com/AWSCLIV2.msi).
4. Run the downloaded AWS CLI installer and follow its steps.
5. In your Windows filesystem, in your current user folder, create an ".aws" folder if there is not one.
6. In your new .aws folder, create 2 files titled "config" and "credentials" if they don't exist.
7. In your config file, ensure the following contents are present, create them if they're not:

_For the region field, use whichever region you're in, I happen to use "us-west-2"._
```
[default]
region = us-west-2
```

8. For your credentials file, start your AWS Learner Lab, and select "AWS Details", this will produce file contents, copy these file contents verbatim into your local credentials file. Note that with the AWS Learner Lab, you will need to do this credential copy step every time you start the lab.
9. You should now have your tools setup.

## >Local Pipeline Section 1: EC2 Instance Setup/Configuration:

Now that we've set up our tools, we can start running our automation scripts.

1. Pull down this repository to gain access to the scripts.
2. Once pulled, open Powershell and navigate to the repository, once in the repository, navigate down into the "ProvisioningScripts" folder.
3. Inside the "main.tf" terraform script you may edit line 13 to match the region you chose in your /.aws/config file. As stated before, my region is us-west-2.
4. Once in the ProvisioningScripts folder, run the 3 following commands:
```
#Intializes Terraform in the dir (installs any dependencies)
terraform init
#Checks main.tf Terraform file for proper syntax
terraform validate
#Runs the main.tf script to provision/configure our resources
terraform apply
```
_You will be prompted to confirm "yes" by the final command before it proceeds provisioning our resources, write "yes" to confirm._
4. Your AWS resources are now provisioned. The output of the "terraform apply" will include 2 variables in the final 2 lines: **"minecraft\_ec2\_id"** and **"minecraft\_public\_ip"**. Copy the values for these 2, we'll use them later to configure/join our minecraft server.

## >Local Pipeline Section 2: Minecraft Server Setup Via AWS CLI:

Now that we've created our AWS resources, we need to setup the Minecraft server on them, this can be done via a small handful of AWS CLI commands using some included scripts.

1. Before running our AWS CLI commands, navigate back "up" one file level into the main repo folder, then navigate down into the "ServerSetupScripts" folder.
2. Once in the ServerSetupScripts folder, run the following command to setup your minecraft server. Be sure to replace the **"YOUR\_INSTANCE\_ID\_FROM\_EARLIER"** field with the **"minecraft\_ec2\_id"** you copied at the end of **Local Pipeline Section 1**.
```
#This will send a bash script remotely to your AWS EC2 instance which sets up your Minecraft server.
#Please replace "YOUR_INSTANCE_ID_FROM_EARLIER" with your EC2 instance ID.
aws send command `
--document-name "AWS-RunShellScript" `
--targets "Key=InstanceIds,Values=YOUR_INSTANCE_ID_FROM_EARLIER" `
--cli-input-json file://ServerSetup.json

```
3. This code may take some time to boot the Minecraft server, wait approximately 2 minutes prior to trying to connect. Once you're ready to connect, use the **"minecraft\_public\_ip"** value you copied at the end of **Local Pipeline Section 1**. From now on, your server will automatically boot whenever the EC2 instance starts.

# References
This guide takes inspiration from the following helpful sources:
- [Setting up a Minecraft Java server on Amazon EC2](https://aws.amazon.com/blogs/gametech/setting-up-a-minecraft-java-server-on-amazon-ec2/)
