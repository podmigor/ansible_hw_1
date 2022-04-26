# First Ansible Playbook Demo VM

This project spins up a GCP VMs and demonstrates a very simple Ansible playbook.

## Quick Start Guide

### 1 - Install TF and configure project

  1. install TF to your local machine
  2. pass credentials, ssh public key location and ssh user to tf variables
  3. your tf SA shoud have next permissions 
     1. Compute Admin
     2. Network Management Admin
     3. Storage Admin
     4. Secret Manager Admin
  4. Add `Secret Manager Secret Version Manager` role to default compute engine service account
  5. Enable `secret manager api` in GCP API management and wait for 5 minutes before run TF code



### 2 - Build the GCP environment by TF

  1. deploy tf code from tf directory
  2. ssh to ansible-runner by using your ssh user and ip from tf outputs

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

### 3 - Run ansible playbook $HOME/ansible_demo
  1. ansible -m ping -i inventory_gcp_static all
  2. ansible-playbook -i inventory_gcp_static playbook.yml
  3. ssh to workers and checks that all steps are executed by ssh to your nodes

## Notes

  - To shut down the GCP env, enter `terraform destroy` in the Terminal 
  
