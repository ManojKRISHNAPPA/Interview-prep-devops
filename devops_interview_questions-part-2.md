# DevOps Interview Questions: Part 2 - Detailed Explanations

This document covers behavioral and advanced Kubernetes interview questions with human-like, practical answers. Each answer is written the way an experienced DevOps engineer would explain it in a real interview — conversational, honest, and backed by hands-on examples.

---

## General / Behavioral Questions

### 1. Explain your branching strategy.

**Interviewer's Expectation:**
They want to assess whether you have actually worked in a team environment with version control discipline. They are checking if you understand the why behind branching, not just the what. They also want to know how your branching ties into your CI/CD pipeline.

**Detailed Explanation:**

Let me explain this from scratch — zero to hero.

When I first started, I used to just commit everything to `main` directly. That worked fine alone, but in a team it was a disaster. One broken commit would break everyone. That is when I started learning about branching strategies properly.

We follow **GitFlow** in our current project, but adapted to work well with GitHub Actions.

Here is how it works:

* **main** — This is the production branch. Nothing goes here directly. It only receives merges from `release` branches after proper testing.
* **develop** — This is our integration branch. All feature work merges here first. Our staging environment is always pointing at this branch.
* **feature/\<ticket-id\>-description** — Whenever a developer picks up a task, they create a feature branch from `develop`. Example: `feature/DEVOPS-123-add-monitoring`. Once the work is done, they raise a pull request back into `develop`.
* **release/\<version\>** — When we are ready to cut a release, we branch off `develop` into a release branch like `release/1.4.0`. Only bug fixes go here — no new features. After QA sign-off, this merges into both `main` and back into `develop`.
* **hotfix/\<description\>** — If something breaks in production at 2 AM, we cut a `hotfix` branch directly from `main`, fix it, and merge it back into both `main` and `develop`.

The reason this works well for us is that it gives us a clear picture of what is in production, what is being tested, and what is being developed — all at any point in time.

Our CI/CD pipeline is also built around this:
* Push to any `feature/*` branch: runs unit tests and linting
* Merge to `develop`: builds a Docker image, runs integration tests, deploys to staging
* Merge to `main`: triggers production deployment with a manual approval gate

**Demo Commands:**

```bash
# Start working on a new feature
git checkout develop
git pull origin develop
git checkout -b feature/DEVOPS-456-setup-hpa

# Do your work, commit
git add .
git commit -m "feat: add HPA config for payments service"
git push origin feature/DEVOPS-456-setup-hpa

# Open a pull request to develop via GitHub UI or CLI
gh pr create --base develop --title "Add HPA for payments service" --body "Adds HPA with CPU and memory thresholds"

# Cut a release branch when ready
git checkout develop
git pull origin develop
git checkout -b release/1.5.0
git push origin release/1.5.0

# Hotfix example
git checkout main
git pull origin main
git checkout -b hotfix/fix-payments-crash
git push origin hotfix/fix-payments-crash
```

---

### 2. What are the challenges you have faced?

**Interviewer's Expectation:**
They want to see your problem-solving ability, how you handle pressure, and whether you can communicate technical issues clearly. They are not looking for a perfect answer — they want to see maturity, ownership, and what you learned from it.

**Detailed Explanation:**

I will share three real challenges I faced that shaped how I work today.

**Challenge 1: Kubernetes pods going OOMKilled in production**

We had a Node.js microservice that kept crashing with `OOMKilled`. The service was running fine in staging, but in production it would die under load. I spent hours thinking it was a code bug.

What actually happened: developers had set memory requests and limits to the same value — `256Mi`. In production, the service had traffic spikes and needed burst memory, but Kubernetes was killing it the moment it exceeded the limit. In staging, traffic was low so it never hit the limit.

Fix: I separated requests and limits. Requests at `256Mi` (what it needs at idle) and limits at `512Mi` (what it can burst to). That immediately stopped the OOMKills.

Lesson: Never blindly copy resource values from staging to production. Always profile under realistic load.

```bash
# Check why a pod was killed
kubectl describe pod <pod-name> -n <namespace>
# Look for: Last State: Terminated, Reason: OOMKilled

# Check resource usage
kubectl top pods -n <namespace>
```

**Challenge 2: Terraform state file conflicts in a team**

When I joined the team, everyone was running `terraform apply` locally and the state file was stored in a shared S3 bucket without locking. Two engineers ran `terraform apply` at the same time once, and it corrupted the state file. We had to manually reconstruct what was deployed.

Fix: I added DynamoDB-based state locking to our backend config and enforced that all Terraform changes go through CI/CD — no more running apply locally. I also added a `terraform plan` review step in pull requests so changes are visible before apply.

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

**Challenge 3: CI/CD pipeline taking 45 minutes to complete**

Our GitHub Actions pipeline was slow. Every push triggered a full build including Docker image build, integration tests, security scanning, and deployment. It was taking 45 minutes which killed developer productivity.

What I did:
* Added Docker layer caching using `cache-from` and `cache-to` with GitHub Actions cache — cut image build time from 12 minutes to 2 minutes
* Split the pipeline into two workflows: a fast feedback loop (lint + unit tests — runs in 3 minutes) and a full pipeline (only runs on PR to develop)
* Parallelized independent jobs using `needs` and `strategy.matrix`

Result: developers got feedback in under 5 minutes instead of waiting 45.

---

### 3. Can you explain your current project?

**Interviewer's Expectation:**
They want to understand your environment, scale, and the complexity you have dealt with. Be specific about the stack, team size, cloud provider, and the problems you were solving. Avoid vague answers like "I worked on a microservices project."

**Detailed Explanation:**

In my current project, I am part of a platform engineering team supporting a fintech application. The application is a set of around 25 microservices — a mix of Node.js and Python services — running on AWS EKS.

Here is the full stack:

* **Cloud:** AWS (EKS, RDS Aurora, ElastiCache Redis, S3, CloudFront, Route53, ACM)
* **Container Orchestration:** Kubernetes 1.29 on EKS with managed node groups
* **Infrastructure as Code:** Terraform — we manage everything from VPCs to EKS clusters to IAM roles
* **CI/CD:** GitHub Actions for builds and deployments, ArgoCD for GitOps-based Kubernetes deployments
* **Monitoring and Observability:** Prometheus + Grafana for metrics, Loki for log aggregation, Jaeger for distributed tracing
* **Secret Management:** AWS Secrets Manager integrated with Kubernetes via External Secrets Operator
* **Service Mesh:** We recently evaluated Istio but decided to use AWS App Mesh for our use case
* **Team size:** 4 DevOps/Platform engineers supporting around 30 developers

The main challenge we were brought in to solve was that deployments were manual, risky, and took half a day. When I joined, developers would SSH into boxes and run scripts. Now every deployment is automated, audited, and reversible through ArgoCD.

---

### 4. What are your roles and responsibilities?

**Interviewer's Expectation:**
They want to understand the breadth of your work — whether you are someone who only does one thing (just pipelines, or just infra) or whether you own the full DevOps lifecycle. Be specific and give context for why each responsibility exists.

**Detailed Explanation:**

My responsibilities span three main areas: infrastructure, platform, and developer enablement.

**Infrastructure:**
* Own and maintain all Terraform code for AWS infrastructure — VPCs, subnets, EKS clusters, RDS, IAM, and security groups
* Review and approve infrastructure pull requests from the team
* Handle capacity planning — reviewing node group sizes, scaling policies, and cost optimization

**Platform and Kubernetes:**
* Manage EKS clusters — upgrades, node group changes, add-ons like CoreDNS, kube-proxy, and the AWS Load Balancer Controller
* Set up and maintain namespaces, RBAC, resource quotas, and limit ranges for each team
* Own the ArgoCD setup — application definitions, sync policies, and rollback procedures
* Manage Helm charts for internal platform components

**CI/CD:**
* Build and maintain GitHub Actions workflows for all 25 microservices
* Own the Docker image build process, registry (AWS ECR), and image scanning with Trivy
* Manage deployment pipelines and approval gates for production releases

**Monitoring and Incident Response:**
* Own the Prometheus and Grafana setup — dashboards, alerting rules, and PagerDuty integration
* Act as first responder for production infrastructure incidents
* Write post-mortems and drive improvements after incidents

**Developer Enablement:**
* Run onboarding sessions for new developers on how to use the platform
* Write internal documentation and runbooks
* Define and enforce standards for Dockerfiles, resource requests, and health check configurations

---

### 5. What are your daily activities?

**Interviewer's Expectation:**
They want to know if you are reactive (only firefighting) or proactive. A good DevOps engineer has structure in their day. They also want to understand the operational load you carry.

**Detailed Explanation:**

My day is roughly split into three types of work: planned work, operational work, and collaboration.

**Morning (first 30 minutes):**
* Check PagerDuty and Slack for any overnight alerts or incidents
* Review Grafana dashboards for the previous night — any anomalies in error rates, latency, or resource usage
* Check ArgoCD sync status — are all applications in sync with what is in Git?
* Review open pull requests assigned to me

**Core work hours:**
* Work on sprint tasks — this could be a new Terraform module, a pipeline improvement, a Kubernetes upgrade, or a new monitoring dashboard
* Review pull requests from developers — checking Dockerfiles, CI pipeline changes, and Kubernetes manifest changes
* Respond to developer questions on Slack — things like "my pod is crashing, can you help?" or "I need access to a new S3 bucket"

**Afternoon:**
* Attend the daily standup with the wider engineering team
* Any scheduled infra work — applying Terraform changes, cluster upgrades, or certificate renewals
* Write documentation for anything new I completed

**Ad-hoc (anytime):**
* If an alert fires, I drop what I am doing and investigate
* On-call rotation means I occasionally handle incidents outside business hours — usually once every 4-5 weeks

---

## Kubernetes Deep Dive

### 6. What is Pod Affinity, Pod Anti-Affinity, and Node Affinity?

**Interviewer's Expectation:**
They want to know if you understand how Kubernetes schedules pods intelligently — beyond just "it schedules based on resource availability." They will often ask follow-up questions like "When would you use anti-affinity over node affinity?" So understand the difference clearly.

**Detailed Explanation:**

Think of affinity rules as telling Kubernetes: "I have preferences or requirements about where my pods should land."

**Node Affinity** — controls which nodes a pod can be scheduled on, based on node labels.

There are two types:
* `requiredDuringSchedulingIgnoredDuringExecution` — hard rule. If no node matches, the pod stays unscheduled.
* `preferredDuringSchedulingIgnoredDuringExecution` — soft rule. Kubernetes tries its best but will schedule elsewhere if needed.

Example: You want your GPU-intensive ML job to only run on nodes that have GPUs.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: ml-job
spec:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: node-type
                operator: In
                values:
                  - gpu
  containers:
    - name: ml-container
      image: my-ml-image:latest
```

Label your GPU node first:
```bash
kubectl label node <node-name> node-type=gpu
```

---

**Pod Affinity** — schedule pods near other pods, based on pod labels.

Example: You have a caching service and your application. You want the application pod to be scheduled on the same node (or in the same availability zone) as the cache to reduce latency.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  affinity:
    podAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: app
                operator: In
                values:
                  - redis-cache
          topologyKey: "kubernetes.io/hostname"
  containers:
    - name: app
      image: my-app:latest
```

The `topologyKey` is important — `kubernetes.io/hostname` means "same node", while `topology.kubernetes.io/zone` means "same availability zone."

---

**Pod Anti-Affinity** — the opposite of pod affinity. Schedule pods away from each other.

Example: You are running 3 replicas of a critical service. You do not want all 3 on the same node because if that node dies, all 3 replicas go down. Anti-affinity spreads them across nodes.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payments-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: payments
  template:
    metadata:
      labels:
        app: payments
    spec:
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: app
                    operator: In
                    values:
                      - payments
              topologyKey: "kubernetes.io/hostname"
      containers:
        - name: payments
          image: payments-service:latest
```

**Demo Commands:**

```bash
# Check where pods are running
kubectl get pods -o wide -n <namespace>

# Check node labels
kubectl get nodes --show-labels

# Label a node manually
kubectl label node <node-name> node-type=gpu

# Describe a pod to see affinity rules applied
kubectl describe pod <pod-name> -n <namespace>

# Check scheduling events if a pod is Pending
kubectl get events --field-selector involvedObject.name=<pod-name> -n <namespace>
```

---

### 7. What are Kubernetes Network Policies?

**Interviewer's Expectation:**
They want to know if you understand Kubernetes security at the network level. By default, all pods can talk to all pods — which is a security risk. Network Policies let you lock this down. They want to see if you have actually used this in a real environment.

**Detailed Explanation:**

By default, Kubernetes has no network isolation. Any pod in any namespace can send traffic to any other pod. In a production environment with sensitive services like databases or payment processors, this is a problem.

Network Policies are Kubernetes resources that define rules for how pods are allowed to communicate — both ingress (incoming) and egress (outgoing) traffic.

Important: Network Policies only work if your CNI (Container Network Interface) plugin supports them. Common ones that support it are Calico, Cilium, and WeaveNet. The default CNI on EKS (aws-node/VPC CNI) does not enforce Network Policies natively — you need to install Calico or Cilium as the network policy enforcer.

**Scenario 1: Deny all traffic to a namespace by default**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: production
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
```

An empty `podSelector` matches all pods in the namespace. This policy denies all ingress and egress — nothing can talk to anything.

**Scenario 2: Allow only the frontend to talk to the backend**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-backend
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
```

Only pods with label `app: frontend` can send traffic to pods with label `app: backend` on port 8080.

**Scenario 3: Allow backend to reach database, but nothing else**

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-backend-to-db
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: database
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: backend
      ports:
        - protocol: TCP
          port: 5432
```

**Scenario 4: Allow DNS egress (commonly needed when you apply a deny-all)**

If you apply a deny-all egress policy, pods cannot resolve DNS and nothing works. Always allow DNS:

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns-egress
  namespace: production
spec:
  podSelector: {}
  policyTypes:
    - Egress
  egress:
    - ports:
        - protocol: UDP
          port: 53
        - protocol: TCP
          port: 53
```

**Demo Commands:**

```bash
# List all network policies in a namespace
kubectl get networkpolicy -n production

# Describe a specific network policy
kubectl describe networkpolicy allow-frontend-to-backend -n production

# Apply a network policy
kubectl apply -f network-policy.yaml

# Test connectivity between pods (exec into pod and curl another)
kubectl exec -it <frontend-pod> -n production -- curl http://backend-service:8080/health

# Test blocked connection
kubectl exec -it <some-other-pod> -n production -- curl http://backend-service:8080/health
# Should fail with connection refused or timeout

# Delete a network policy
kubectl delete networkpolicy allow-frontend-to-backend -n production
```

---

### 8. What are Kubernetes Operators?

**Interviewer's Expectation:**
They want to know if you understand the concept of extending Kubernetes beyond its built-in resources. Operators are a more advanced topic and if you can explain them clearly with a real-world example, it signals strong Kubernetes maturity.

**Detailed Explanation:**

A Kubernetes Operator is a pattern for managing complex, stateful applications on Kubernetes by encoding operational knowledge into code.

Think of it this way: Kubernetes knows how to manage stateless applications really well — deploy pods, restart them if they crash, scale them. But stateful applications like databases, message queues, or Elasticsearch have complex operations: backups, failover, version upgrades, and data replication. You cannot just kill and restart a database pod the way you restart a web server.

An Operator extends Kubernetes by adding:
1. A **Custom Resource Definition (CRD)** — a new resource type specific to your application
2. A **Custom Controller** — a program that watches those custom resources and acts on them

Real example: The **Prometheus Operator**. Instead of manually writing Prometheus scrape configs, you create a `ServiceMonitor` resource (a custom resource), and the Prometheus Operator watches for those resources and automatically updates Prometheus config. The operator knows how Prometheus works internally and manages it accordingly.

Another example: The **PostgreSQL Operator (e.g., CloudNativePG)**. You define a `Cluster` resource with your desired state (3 replicas, 50Gi storage), and the operator creates the primary, two replicas, sets up streaming replication, manages failover, and handles backups.

**How it works (under the hood):**

The operator uses the Kubernetes reconciliation loop — it continuously watches the current state and compares it to the desired state, then takes action to make them match. This is the same pattern Kubernetes itself uses internally for Deployments.

**Demo: Using the Prometheus Operator**

First, install via Helm:
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace
```

The Prometheus Operator installs CRDs. Check them:
```bash
kubectl get crd | grep monitoring.coreos.com
# Output includes:
# prometheuses.monitoring.coreos.com
# servicemonitors.monitoring.coreos.com
# alertmanagers.monitoring.coreos.com
# prometheusrules.monitoring.coreos.com
```

Create a ServiceMonitor to scrape your app:
```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: my-app-monitor
  namespace: production
  labels:
    release: kube-prometheus-stack
spec:
  selector:
    matchLabels:
      app: my-app
  endpoints:
    - port: metrics
      interval: 30s
      path: /metrics
```

```bash
kubectl apply -f servicemonitor.yaml

# The operator picks this up and Prometheus starts scraping automatically
# Verify by checking Prometheus targets
kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090 -n monitoring
# Open http://localhost:9090/targets in browser
```

**Verify the Operator is running:**
```bash
kubectl get pods -n monitoring
kubectl logs deployment/kube-prometheus-stack-operator -n monitoring
```

---

### 9. What is the difference between CMD and ENTRYPOINT in Docker?

**Interviewer's Expectation:**
They want to see if you understand Dockerfile internals and can explain when to use each. This is a common Docker question that trips up many people because both seem similar. The key is understanding what is overridable and what is not.

**Detailed Explanation:**

Both `CMD` and `ENTRYPOINT` define what runs when a container starts. The difference is in how they interact with arguments passed at runtime.

**ENTRYPOINT** defines the executable that always runs. It is the main command that the container exists to run. You cannot override it at runtime without explicitly using `--entrypoint`.

**CMD** defines default arguments. It can be completely overridden by passing arguments at the end of `docker run`.

When both are used together, `ENTRYPOINT` is the executable and `CMD` provides the default arguments to it.

**Example 1: CMD only**

```dockerfile
FROM ubuntu:22.04
CMD ["echo", "Hello from CMD"]
```

```bash
# Build the image
docker build -t cmd-demo .

# Run with default CMD
docker run cmd-demo
# Output: Hello from CMD

# Override CMD at runtime
docker run cmd-demo echo "Overridden"
# Output: Overridden
```

**Example 2: ENTRYPOINT only**

```dockerfile
FROM ubuntu:22.04
ENTRYPOINT ["echo"]
```

```bash
docker build -t entrypoint-demo .

# Run — echo is always the executable
docker run entrypoint-demo "Hello from ENTRYPOINT"
# Output: Hello from ENTRYPOINT

# Try to override
docker run entrypoint-demo ls
# Output: ls   (it does echo ls, not run ls as a command)
```

**Example 3: ENTRYPOINT + CMD together (best practice for flexible images)**

```dockerfile
FROM ubuntu:22.04
ENTRYPOINT ["echo"]
CMD ["Hello, default message"]
```

```bash
docker build -t both-demo .

# Run with default CMD
docker run both-demo
# Output: Hello, default message

# Override CMD — pass your own argument to the entrypoint
docker run both-demo "Custom message"
# Output: Custom message
```

**Real-world example: A Flask application**

```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .

ENTRYPOINT ["python"]
CMD ["app.py"]
```

```bash
docker build -t flask-app .

# Normal run — runs python app.py
docker run flask-app

# Override CMD to run a different script (e.g., a migration)
docker run flask-app migrate.py

# Override ENTRYPOINT entirely (rarely needed)
docker run --entrypoint /bin/sh flask-app -c "ls /app"
```

**Shell form vs Exec form:**

There are two ways to write CMD and ENTRYPOINT:

```dockerfile
# Shell form — runs via /bin/sh -c, so signals (like SIGTERM) may not reach the process
CMD python app.py

# Exec form — runs directly, signals reach the process correctly
CMD ["python", "app.py"]
```

Always use exec form (the JSON array format) in production. Shell form causes issues with graceful shutdowns because the process is a child of `/bin/sh`, not the container's PID 1.

**Summary Table:**

| | CMD | ENTRYPOINT |
|---|---|---|
| Purpose | Default arguments | Fixed executable |
| Overridable at runtime | Yes, by passing args to `docker run` | Only with `--entrypoint` flag |
| Used together | Provides default args to ENTRYPOINT | Acts as the executable |
| Best for | Default behavior that can be changed | Core process that must always run |

**Demo Commands:**

```bash
# Inspect what CMD and ENTRYPOINT a pulled image uses
docker inspect nginx:latest | grep -A 5 '"Cmd"'
docker inspect nginx:latest | grep -A 5 '"Entrypoint"'

# Override entrypoint to debug inside a container
docker run --entrypoint /bin/bash -it my-image

# Override CMD when running
docker run my-image --config /custom/config.yaml

# Check what command is running inside a container
docker inspect <container-id> | grep -A 5 '"Cmd"'
```
