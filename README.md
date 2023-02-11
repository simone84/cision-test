# cision-test
tech assignment 

```
1. Write a Dockerfile to run nginx version 1.19 in a container.

Choose a base image of your liking.

The build should be security conscious and ideally pass a container
image security test. [20 pts]

The image is automatically scanned by X-Ray (Jfrog) after each building
```
![alt text](https://github.com/simone84/cision-test/blob/main/screenshots/xray.png?raw=true)

```
2.  Write a Kubernetes StatefulSet to run the above, using persistent volume claims and
resource limits. [15 pts]
few additional objects have been added to make a complete and fuctional "deployment"
```
![alt text](https://github.com/simone84/cision-test/blob/main/screenshots/limits.png?raw=true)

```
3. Write a simple build and deployment pipeline for the above using groovy /
Jenkinsfile, CircleCI or GitHub Actions. [15 pts]
A GH action (self hosted) build the image and push it over jfrog artifactory.
The last step run the kubernetes deployment pulling the new image building a local nginx environment 
``` 
![alt text](https://github.com/simone84/cision-test/blob/main/screenshots/k8sresources.png?raw=true)

```
4. Source or come up with a text manipulation problem and solve it with at least two of
awk, sed, tr and / or grep. Check the question below first though, maybe. [10pts]
An easy text has been mounted as config map to parse the version (grep and awk have been used)
```

```
5. Solve the problem in question 4 using any programming language you like. [15pts]
Instead to bother OS System libraries I used directly bash. Check the workflow.
Otherwise would be something like:
import os
os.system("grep version statefulset.yaml | awk '{print $2}' ")
```

```
6. Write a Terraform module that creates the following resources in IAM;
---
• -  A role, with no permissions, which can be assumed by users within the same account,
• -  A policy, allowing users / entities to assume the above role,
• -  A group, with the above policy attached,
• -  A user, belonging to the above group.
All four entities should have the same name, or be similarly named in some meaningful way given the
context e.g. prod-ci-role, prod-ci-policy, prod-ci-group, prod-ci-user; or just prod-ci. Make the suffixes
toggleable, if you like. [25pts]

Module calling: ./main.tf
tfvars: ./prod.tfvars
module: ./modules/role
```
![alt text](https://github.com/simone84/cision-test/blob/main/screenshots/tfstatelist.png?raw=true)
![alt text](https://github.com/simone84/cision-test/blob/main/screenshots/testassumerole.png?raw=true)

## Requirements ##
Nginx exercise:

- Minikube / K3S / EKS / ETC
- Docker libraries
- Docker Artifactory / Jfrog / ETC

IAM Role exercise:

- Terraform
- AWS
- awscli

## How I did it and why ##

### Nginx: ###
```
Would be easier to discuss about my choices but I will try to wrap it up breafly
I used an existent minikube k8s cluster, EKS for one instance seems wasted!
This is a challenging solution because can't be reach from internet being localhost on my machine
but we do like challenges ;-)
Having already a Github self hosted, action runner and cert manager that was the best solution just
whitelisting the new repository.
XRay is one of the best product to catch vulnerabilities and I decide to spin up a free trial jfrog
instance. A GH user has been created with enough privilidges to push/pull on the registry and a secret
has been added on kubernetes to allow the deployment.
To make a sense of the docker building I've added a static index.
The statefulset yaml file includes on the bottom a configmap to verify with apply completed if the new
modified have been picked up.
I used 1GB pvc, a service load balancer wiht a minikube tunnel to hit the url without ssh on the pod.
I had a good challenge modifying the kubeconfig to allow the action to reach the minikube api on the NAT
ip and the cert managent.
The Action doesn't expose secrets. They all been saved in the action secrets included the kubeconfig base64.
Of course having the self host runner nothing roam free over Internet.
I didn't get the chance to add the security context for missing time. That needed on the dockerfile the
change of configuration files and file ownership.
I felt free to add readiness and liveness probe.  
```

### Terrafrom Module ###
```
TBH not to much to say... few resources using the name prefix. In this way you can reuse the same code and
DRY. If you want to spin up a new unvironment you will need only a new tfvars file
Having a local vault raft cluster I decided to integrate it with the module. This will mark policy and the 
assume role as sensitive over the building.
```
