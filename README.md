# Welcome!

This documentation is to provide instructions for setting up and running a containerised Rails application that is connected to Redis and PostgreSQL, with Prometheus and Grafana for monitoring. Potential issues and their solutions are also mentioned.

The code section of this repository contains the script (named main.tf) that is used to achieve the containerized setup with little or no manual input.

## Pre-Requisites
* Git - Official documentation for installing git: [git installation link](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* Terraform - use Terraform's official documentation to install this: [Terraform official documentation for installation](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
* AWS-CLI - Use AWS official documentation to install this: [AWS official documentation for CLI installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* IAM Account with permission to create EC2 instance: Login to your AWS account, navigate to IAM service to create a user with the required permission.
* Create an access key for the IAM user that was created in the above step. Ensure that required permissions are rightly assigned to the user before you create the access key. This is to avoid permissions issues when you need to connect to your AWS account from AWScli\
* Get the AMI ID for the image you would want to use to create your EC2 instance using Ubuntu's official documentation: [Ubuntu Official AMI finder](https://cloud-images.ubuntu.com/locator/ec2/). Take note of the region that the AMI belongs to because the exact region needs to be specified in your terraform file to prevent error like: AMI ID could not be found

# Starting with Terraform
* Git clone the code in this repository

* Create a directory of your choice where you would store the terraform main.tf file that contains the automation script

* A sample dockerfile and dockercompose file are included in the repository. This could be tweaked to meet any new requirement

* A sample prometheus file is also in the repo that helps to scrape data from the services. This file could also be modified.

* If you are going to run the rails application in developmemt mode, create a .env file in the root directory that would utilised by the installed by the dotenv gem (dotenv gem was specified in the gemfile). Also, in the dockerfile and dockercompose file, remove the variable: RAILS_ENV="production". By default rails would run in development mode.

* If running in development mode, ensure that there are no port clashes between grafana and rails. You can modify grafana to listen on another port by specifying the port in the docker compose file

* After modifying the repo, change your main.tf file user data to clone from the modified repo source. If needs be, modify the ami-id, region to suite your need.

* Run AWS configure and follow the prompt, to input the data of the user that had been created as stated in the prerequisites section (if you skipped the user creation in the prerequisite section, it is not too late to create it. Just create it now, and continue the remaining steps below).
 
* Move the main.tf file from the directory in step 1 to the directory created in step 2

* Initiate the terraform directory by running: terraform init (NB: Internet access is required)

* Use "terraform plan --out "plan.tf" to save the plan to the file specified, so that you can repeatedly use the plan without running 'terraform init' again if you don't make changes to your main.tf file or modify the account that is used to connect to AWS in the script.

* Run terraform apply "plnat.tf" to implement process.

## Running This Process Locally
* Copy the contents of the user data in your main.tf file and save into a file <your_desired_file_name>.sh. Ensure the content of the <your_desired_file_name>.sh starts with "#!/bin/bash" then the commands that you copied from the user data come next in line.

* Make the file created an executable by running:
chmod +x <name_of_file_created>.sh

* Since all the processes are administrative, swtich to your root user by running "sudo su" or "su root". Input your password to confirm that you are part of sudo group. To add user to sudo group or edit sudoers file, use: [Add user to sudo group](https://askubuntu.com/questions/2214/how-do-i-add-a-user-to-the-sudo-group), [Edit Sudoer's file](https://help.ubuntu.com/community/Sudoers)

* Run script by doing "./<name_of_file_created>.sh"

Alerting rules used on monitoring

## Monitoring All Resources Created Above
Generally, the CPU utilization, memory usage of all resources should be monitored as these are core fundamentals resources that the services use to function.

Other individual attributes of the respective services to be monitored alongside their CPU and memory usage are:
### Rails App:
* Response Time: Monitored to ensure low latency of response to request. High response time could be caused by any of other factors mentioned below.
* Database Performance: Database performance is monitored to ensure that embedded queries and procedures are optimally written and connection to database is not been timed out due to high latency from network performance.
* Error Rate: The number of errors is monitored. This can give insight to how application needs to made more intuitive, or optimized for input validation, etc.

### PostgreSql:
* Database Connections: This prevents bottlenecks and can serve as a pointer as to other issues that could arise from connections spike.
* query performance: Can be very helpful to ensure that long resource consuming queries/procedures used by application are optimized
* Cache Hit Ratio: This is related to memory and would in turn give insight to memory performance to see if memory is being underutilized or overutilized. High cache hit ratio is desired to ensure that frequently accessed data are found in memory and have not been swapped due to insufficient memory.
* Disk I/O: This is monitored to ensure that application is able to easily write and read to disk. Helps to give insight on performance of disk and know if size needs to be increased, type needs to be changed, etc.
* Transaction rate: The number of transaction is monitored to ensure that there are no bottle necks such as queues and locks.

### Redis:
* Number of Connected Clients: The number of clients connected to server is monitored to help make decision if cluster size needs to be increased or what optimization can be done.
* Commands Processed: This is monitored to ensure performance is optimized.
* Hit Rate: The ratio of key hits to key misses.
* Latency: This is monitored to ensure that read latency is within threshold.
* Evicted Keys: This is monitored to ensure that memory capacity is sufficient and application is being able to readily find needed information.

Alerting (which are classified into severity) that is stemmed from the metrics being monitored is done to ensure that relevant recipients that can take action are notified when there is anomaly, or set performance threshold set is being exceeded.






