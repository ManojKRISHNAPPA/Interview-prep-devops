# DevOps & Cloud Concepts Documentation

---

## 1. How to Reduce Cost of EC2 Hosting Applications?
- Use **right-sized instance types** based on workload.
- Opt for **Spot Instances** or **Reserved Instances** for steady workloads.
- Use **Auto Scaling** to adjust capacity dynamically.
- Leverage **Amazon EC2 Savings Plans**.
- Stop or terminate instances when not in use.
- Use **Elastic Load Balancers** efficiently and optimize storage.

---

## 2. Difference Between NACL and Security Group

| Feature           | NACL (Network ACL)                   | Security Group                  |
|-------------------|------------------------------------|--------------------------------|
| Scope             | Subnet-level                       | Instance-level                 |
| Statefulness      | Stateless (requires rules for both in/out traffic) | Stateful (automatically allows response traffic) |
| Rules             | Ordered, evaluated top-down        | All rules evaluated            |
| Default Behavior  | Deny all inbound and outbound if no rule matches | Deny all inbound, allow all outbound by default |

---

## 3. IAM User with Both Allow and Deny Permissions

- **Explicit deny always overrides allow.**
- If a user has a deny statement, the action will be denied regardless of other allow permissions.

---

## 4. Kubernetes Architecture

- **Master Node:** API Server, Scheduler, Controller Manager, etcd (store cluster data).
- **Worker Nodes:** Kubelet, Kube-proxy, Container runtime (e.g., Docker).
- **Pods:** Smallest deployable units.
- Components communicate via API Server.

---

## 5. What is Ingress?

- Manages external access to services in a cluster, typically HTTP.
- Provides routing, SSL termination, and load balancing.

---

## 6. Difference Between ENTRYPOINT and CMD in Docker

| Feature          | ENTRYPOINT                                  | CMD                                  |
|------------------|--------------------------------------------|------------------------------------|
| Purpose          | Configures container's executable          | Provides default arguments/options  |
| Override         | Hard to override via docker run             | Can be overridden easily             |
| Use Case         | When container runs a specific app/script  | Default command or parameters        |

---

## 7. Difference Between COPY and ADD in Dockerfile

| Instruction | Description                                          |
|-------------|------------------------------------------------------|
| COPY        | Copies files/directories from local to container     |
| ADD         | Same as COPY + supports URL extraction and tar files |

---

## 8. What is Multi-stage Dockerfile?

- Multiple `FROM` statements in one Dockerfile.
- Build artifacts in one stage, copy to a smaller final image.
- Reduces final image size by excluding build tools.

---

## 9. What is Multi-branch Jenkins Job?

- A Jenkins job that automatically discovers and builds branches in a repo.
- Simplifies CI for multiple branches.

---

## 10. Difference Between git pull and git fetch

| Command    | Description                              |
|------------|------------------------------------------|
| git fetch  | Downloads commits and updates remote refs, no merge |
| git pull   | Runs `fetch` + merges changes into current branch |

---

## 11. Difference Between git reset and git revert

| Command     | Description                                 |
|-------------|---------------------------------------------|
| git reset   | Moves HEAD to a previous commit (can rewrite history) |
| git revert  | Creates a new commit that undoes changes from a previous commit |

---

## 12. How to Connect Git with Jenkins for Job Triggering?

- Configure **Jenkins Git plugin** with repo URL.
- Setup **webhook** from GitHub/GitLab to Jenkins URL for triggering.
- In Jenkins job, enable **Poll SCM** or **Build when a change is pushed to GitHub**.

---

## 13. Difference Between port and targetPort in Kubernetes Service Manifest

| Field      | Description                                   |
|------------|-----------------------------------------------|
| port       | The port exposed by the service                |
| targetPort | The port on the pod where the service directs traffic |

---

## 14. Node Selector

- Simple label-based scheduling to assign pods to nodes with matching labels.

---

## 15. Node Affinity

- More expressive version of node selection using rules and operators.
- Preferred or required rules for scheduling.

---

## 16. Taints and Tolerations

- **Taints:** Mark nodes to repel certain pods.
- **Tolerations:** Pods can tolerate taints to be scheduled on tainted nodes.

---

## 17. RBAC (Role-Based Access Control)

- Manages permissions in Kubernetes via Roles, ClusterRoles, RoleBindings, ClusterRoleBindings.

---

## 18. Helm Charts

- Package manager for Kubernetes.
- Defines, installs, and upgrades complex Kubernetes applications.

---

## 19. Deployment

- Kubernetes controller for declarative updates to Pods and ReplicaSets.

---

## 20. StatefulSet and DaemonSet

| Controller   | Use Case                                  |
|--------------|--------------------------------------------|
| StatefulSet  | Stateful applications with persistent IDs  |
| DaemonSet    | Runs a copy of a pod on all/selected nodes |

---

## 21. Egress and Ingress

- **Ingress:** Traffic entering a system or cluster.
- **Egress:** Traffic leaving a system or cluster.

---

## 22. Reset, Revert, Rebase (Git)

- **Reset:** Moves HEAD to another commit, can discard commits.
- **Revert:** Creates new commit undoing changes.
- **Rebase:** Moves or combines commits on top of another base tip.

---

## 23. Multistage Build in Docker

- Build in multiple stages to optimize image size by copying only necessary artifacts.

---

## 24. Difference Between CMD and ENTRYPOINT (Repeat from #6)

(See #6)

---

## 25. Difference Between ADD and COPY (Repeat from #7)

(See #7)

---

## 26. .dockerignore File

- Defines files/folders to exclude from docker build context to reduce image size.

---

## 27. Terraform Concepts

- **Input Variables:** Parameters passed to Terraform modules.
- **Output Variables:** Values returned after execution.
- **Backend:** Where state is stored (local/remote).
- **terraform.tfvars:** File containing variable values.
- **Modules:** Reusable terraform code packages.

---

## 28. Difference Between A Record and Alias Record

| Record Type | Description                                      |
|-------------|--------------------------------------------------|
| A Record    | Maps domain to IPv4 address                       |
| Alias       | AWS-specific, points to AWS resources (ELB, S3) |

---

## 29. What is Sticky Sessions?

- Session affinity ensuring user requests go to the same backend server.

---

## 30. What is Hibernating EC2 Instance?

- EC2 instance state saved to EBS, instance stops but can resume faster than reboot.

---

## 31. What is Swap Memory?

- Disk space used as virtual RAM when physical RAM is full.

---

## 32. What are Git Submodules?

- Git repositories embedded within other repositories to manage dependencies.

---

## 33. Difference Between Local Repository and Index (Staging) Area

| Term           | Description                                  |
|----------------|----------------------------------------------|
| Local Repo     | Your working directory and commits            |
| Index (Staging)| Area where changes are prepared before commit |

---

## 34. What is Whitelist?

- List of approved entities granted access.

---

## 35. What is Service Account in Kubernetes?

- Identity attached to pods for API access with specific permissions.

---

## 36. Handling Version Compatibility Issues When Adding New Libraries

- Use dependency management tools.
- Specify version ranges.
- Test thoroughly in staging environments.
- Use containers or virtual environments.

---

## 37. Difference Between S3, EFS, and EBS

| Storage Type | Description                          | Use Case                  |
|--------------|------------------------------------|---------------------------|
| S3           | Object storage                     | Static files, backups      |
| EFS          | Shared file system (NFS)           | Shared persistent storage  |
| EBS          | Block storage for EC2 instances    | Persistent volume for single instance |

---

## 38. Common Linux Commands

- `ls`, `cd`, `grep`, `chmod`, `top`, `ps`, `df`, `du`, `tar`, `curl`, `netstat`

---

## 39. CIDR (Classless Inter-Domain Routing)

- IP address notation for flexible IP allocation (e.g., 192.168.1.0/24).

---

## 40. Difference Between Hard Link and Soft Link

| Link Type   | Description                             |
|-------------|----------------------------------------|
| Hard Link   | Points directly to inode, same file    |
| Soft Link   | Symbolic pointer to file path           |

---

## 41. Difference Between Application Load Balancer and Transport Layer Load Balancer

| Load Balancer Type       | Layer               | Use Case                          |
|-------------------------|---------------------|----------------------------------|
| Application Load Balancer| Layer 7 (HTTP/HTTPS) | Content-based routing             |
| Transport Layer LB       | Layer 4 (TCP/UDP)    | High performance, protocol agnostic|

---

## 42. Liveness Probe in Kubernetes

- Checks if pod is alive, restarts container if probe fails.

---

## 43. Types of Kubernetes Services

- **ClusterIP:** Internal cluster access.
- **NodePort:** Expose on node port.
- **LoadBalancer:** External LB from cloud provider.
- **ExternalName:** Maps to external DNS name.

---

## 44. Git Cherry-pick

- Apply specific commit from one branch into current branch.

---

## 45. Read Replica

- Copy of a database used for scaling read operations.

---

## 46. Disaster Recovery

- Backup, replication, and failover strategies to recover systems after failure.

---

## 47. Complete CI/CD Pipeline Until Hosting in GoDaddy

- Code commit → Jenkins build → Docker image → Push to registry → Deploy to Kubernetes/EKS → Configure domain in GoDaddy → SSL setup → Monitoring.

---

## 48. SSL Certification

- Digital certificate to secure communication with HTTPS.

---

## 49. Deployment File with Two Containers (Kubernetes)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: multi-container-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: multi-container-app
  template:
    metadata:
      labels:
        app: multi-container-app
    spec:
      containers:
      - name: container-one
        image: image-one
      - name: container-two
        image: image-two
```

## 50. Jenkins Pipeline to Pull Docker Image and Deploy to EKS (Two Stages)
```commandline
pipeline {
  agent any
  stages {
    stage('Pull Docker Image') {
      steps {
        sh 'docker pull myrepo/myimage:latest'
      }
    }
    stage('Deploy to EKS') {
      steps {
        sh 'kubectl apply -f deployment.yaml'
      }
    }
  }
}
```
 
## 51. Can We Shrink EBS Volumes?
No, you can increase EBS volume size but shrinking is not supported directly.

## 52. Cordon, Drain, and Uncordon in Kubernetes
    Cordon: Mark node unschedulable.
    Drain: Evict pods safely from node.
    Uncordon: Mark node schedulable again.



# Scenario-Based Questions

---

## 1. Multi-branch Jenkins Job

**Scenario:**  
You have a repository with multiple feature branches. You want Jenkins to automatically build and test any new branch pushed to the repo without manually creating jobs for each branch.  

**Question:**  
How would you configure Jenkins to achieve this? What are the advantages of using a multi-branch pipeline job in this case?

---

## 2. Git Pull vs Git Fetch

**Scenario:**  
You are collaborating on a project and want to check if your remote repository has new changes before merging them into your local branch without automatically merging.  

**Question:**  
Which git command would you use and why? What risks can arise if you use the other command carelessly?

---

## 3. Git Reset and Revert

**Scenario:**  
You accidentally committed sensitive data to the repository and pushed it to the remote. You want to remove that commit from history in your local and remote repository.  

**Question:**  
Would you use `git reset` or `git revert`? Explain the consequences of each in this situation.

---

## 4. Connecting Git with Jenkins for Job Triggering

**Scenario:**  
You want Jenkins to start a build immediately when a developer pushes code to the GitHub repository.  

**Question:**  
How do you set up this automation? What configurations are needed both in Jenkins and GitHub?

---

## 5. Kubernetes Service Port vs TargetPort

**Scenario:**  
Your Kubernetes Service exposes port 80, but the container inside the Pod listens on port 8080.  

**Question:**  
How would you configure the service manifest to allow traffic on port 80 to be routed to the container’s port 8080?

---

## 6. Node Selector vs Node Affinity

**Scenario:**  
You want to schedule a pod only on nodes labeled with `disktype=ssd`, but you also want to prefer nodes in the `zone=us-east-1a` when available.  

**Question:**  
How would you achieve this using node selector and node affinity? Which is more flexible?

---

## 7. Taints and Tolerations

**Scenario:**  
You have a node dedicated for GPU workloads and want to ensure only GPU-enabled pods run on it, preventing other pods from scheduling there.  

**Question:**  
How can you configure taints and tolerations to enforce this?

---

## 8. RBAC in Kubernetes

**Scenario:**  
You want to restrict a developer's access so they can only view pods but cannot create or delete any resources.  

**Question:**  
How would you implement this using Kubernetes RBAC?

---

## 9. Helm Charts

**Scenario:**  
You want to deploy a complex microservices application with multiple Kubernetes resources and want easy upgrades and rollbacks.  

**Question:**  
Why would you use Helm charts, and how do they simplify application lifecycle management?

---

## 10. Deployment vs StatefulSet

**Scenario:**  
You are deploying a database that requires stable network IDs and persistent storage across pod restarts.  

**Question:**  
Which Kubernetes controller would you choose, Deployment or StatefulSet, and why?

---

## 11. Git Reset vs Revert in Team Environment

**Scenario:**  
You want to undo the last commit but the commit has already been pushed and other team members may have pulled it.  

**Question:**  
Which command is safer to use and why?

---

## 12. CI/CD Pipeline with Jenkins and Docker

**Scenario:**  
Your Jenkins pipeline needs to build a Docker image, push it to Docker Hub, and then deploy it on an EKS cluster in two separate stages.  

**Question:**  
How would you structure this pipeline? What are the key steps?

---

## 13. Shrinking EBS Volume

**Scenario:**  
Your EBS volume was allocated larger than needed, and you want to reduce its size to save cost.  

**Question:**  
Can you shrink an EBS volume directly? If not, what alternatives do you have?

---

## 14. Cordon, Drain, and Uncordon

**Scenario:**  
You need to perform maintenance on a Kubernetes node without disrupting workloads.  

**Question:**  
Explain how you would use cordon, drain, and uncordon commands in this scenario.

---

Feel free to ask if you want detailed answers or solutions for any of these scenarios!
