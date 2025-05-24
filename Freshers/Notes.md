# Docker Interview Scenarios

## 1. Docker Image Size Is Too Large – How Do You Optimize It?
**Scenario:**
You’ve built a Docker image for a Python app, and it's 1.5GB. How would you reduce it?
#### What They Look For:

-   Multi-stage builds

-   Use of minimal base images (alpine, distroless)

-   Avoid unnecessary layers

-   Clear .dockerignore

**Sample Answer:**

    I’d start by switching to a minimal base image like python:3.10-slim or alpine, and use multi-stage builds to separate build-time dependencies from runtime. 
    I’d also use .dockerignore to keep source control and logs out of the image. Finally, I’d remove unused packages and clean up temporary files in the same layer to avoid bloating.

## 2. App Crashes When Run in Container, Works Locally
**Scenario:**
Your app works locally but fails inside a container with an error like **"file not found"**.

#### What They Look For:

-   Debugging containers (docker exec, docker logs)

-   Volume mounts

-   Working directory issues

-   Environment differences

**Sample Answer:**

    I'd docker exec into the container to inspect the environment. Often it’s due to incorrect paths, missing volume mounts, or a mismatch between local and container environments. 
    I'd also check if the Dockerfile sets the correct WORKDIR, and verify file paths and case sensitivity.

## 3. Dockerfile Is Not Caching Properly
**Scenario:**
Your Dockerfile builds from scratch each time, not using cache.

#### What They Look For:

-   Understanding of Docker layer caching

-   Optimized ordering in Dockerfiles

**Sample Answer:**

    Docker caches layers sequentially. If a frequently changing line (like COPY . .) comes early, it invalidates all subsequent layers. 
    I’d re-order the Dockerfile to put stable lines first, like installing dependencies, and move COPY and RUN commands that change frequently later.

##  4. ENV vs ARG in Dockerfile
**Scenario:**
Your team is confused about whether to use ENV or ARG for passing variables in a Dockerfile.

#### What They Look For:

- Understanding build-time vs. runtime variables

- Security and scope of variables

- Dockerfile syntax

**Sample Answer:**

    ARG is for build-time variables and does not persist in the final image. 
    ENV is for runtime and is accessible within the running container. 
    For example, I use ARG VERSION=1.0 during build and ENV DEBUG=true for app configuration.

## 5.Docker Container Uses Too Much Memory
**Scenario:**
A container is using more memory than expected and causing system instability.

#### What They Look For:

-   Resource limits (--memory)

-   Container resource management

-   Process leaks inside containers

**Sample Answer:**

    I’d first inspect the container with docker stats. 
    Then, I’d limit memory with the --memory flag, like docker run --memory=500m. 
    I’d also check the app for memory leaks and ensure it's properly configured to use limited resources.

## 6. Docker Tagging Confusion
**Scenario:**
Your CI/CD pipeline pushes images, but the wrong versions are used.

#### What They Look For:

-   Proper image tagging practices

-   Versioning and immutability

-   Image promotion strategies

**Sample Answer:**
    
    Tags should be unique and versioned (v1.2.3, latest, staging). 
    I’d configure the pipeline to use Git tags or commit hashes for image tags, and avoid reusing latest in production.
    I’d also consider using a promotion pipeline for moving from dev to prod.

## 7. Docker Container Exits Immediately
**Scenario:**
You run a container and it exits instantly.
#### What They Look For:

-   Entry point and command configuration

-   Interactive vs. detached mode

-   Base image behavior

**Sample Answer:**

    It’s likely the container’s default command exited. 
    I’d check the CMD or ENTRYPOINT in the Dockerfile. 
    If it runs a script that exits, I’d use tail -f /dev/null for debugging. 
    Also, running with -it may help keep it interactive.

## 8. Docker Volume Not Updating Code
**Scenario:**
You mounted code into a container, but changes aren't reflected.

#### What They Look For:

-   Bind mount vs. volume

-   File syncing behavior

-   Docker Desktop limitations (Windows/macOS)

**Sample Answer:**
    
    I’d confirm that a bind mount is used (-v $(pwd):/app) and not a named volume, which can override host data. 
    On Docker Desktop, I’d ensure file sharing is enabled for the mounted directory.


## 9.Docker Build Fails Due to Proxy or Firewall
**Scenario:** Docker can’t access the internet or specific URLs during image build.

### What They Look For:

-   Network/proxy configuration

-   ENV for proxy variables in Dockerfile

-   Corporate firewall knowledge

**Sample Answer:**

    I’d configure proxy settings using build args or ENV:
```commandline
ENV http_proxy=http://proxy.local:8080
ENV https_proxy=http://proxy.local:8080
```
Also, I'd test internet access from inside the container with curl or ping.

## 10 Container Needs Host Device Access (e.g., USB, GPU)
**Scenario:**
The containerized app needs access to a hardware device on the host.

####  What They Look For:

-   Using --device and privileged mode

-   Security implications

**Sample Answer:**
    
    For USB or GPU access, I use --device=/dev/bus/usb or --gpus all. If required, --privileged can be used, but it should be limited to trusted environments due to security risks.

## 11.Docker Security Best Practices
**Scenario:**
You’re asked to audit a Docker image and container setup for security.

####  What They Look For:

-   Image scanning tools

-   Running as non-root

-   Limiting capabilities

**Sample Answer:**

    I’d scan images using tools like Trivy or Docker Scout. 
    I’d ensure containers don’t run as root, use USER in the Dockerfile, and limit Linux capabilities with --cap-drop=ALL and --cap-add only what's needed



# Kubernetes Interview Scenarios
## 1. Pod Is CrashLoopBackOff – What Do You Do?
**Scenario:**
A pod is failing repeatedly and showing CrashLoopBackOff.

#### What They Look For:

-   Using kubectl describe, logs, and exec

-   Understanding of liveness/readiness probes

-   Application startup issues

**Sample Answer:**

    First, I’d check kubectl describe pod and kubectl logs for errors. 
    If it’s an initialization or dependency error, I’d check the config or secrets. 
    If probes are failing, I’d verify the endpoints and adjust probe thresholds or timings.

## 2. How Do You Perform a Rolling Update Without Downtime?
**Scenario:**
You need to update a deployment without causing any user-facing downtime.

#### What They Look For:

- Knowledge of Deployment strategies

- Readiness probes

- Configuration via maxUnavailable, maxSurge

**Sample Answer:**

    Kubernetes handles rolling updates by default. 
    I ensure readiness probes are set correctly, so traffic is only routed to healthy pods. 
    I can configure maxUnavailable=0 and maxSurge=1 in the strategy section to ensure zero downtime.

## 3. Service Not Reaching Pods
**Scenario:**
You deploy a service, but it doesn't reach the pods.

#### What They Look For:

-   Service types

-   Label selectors

-   Networking/DNS knowledge

**Sample Answer:**

    I’d first check if the service’s selector matches pod labels. 
    Then I'd test connectivity using a busybox pod. 
    If it’s a ClusterIP service, I’d verify DNS resolution with nslookup or dig, and check if the network policy allows access.

## 4. You Need to Run a Job Once and Exit
**Scenario:**
You want to run a task (e.g., DB migration) once and ensure it doesn’t rerun.

#### What They Look For:

- Understanding of Kubernetes Job and CronJob

- Cleanup strategies

- Exit code monitoring

**Sample Answer:**

    I’d create a Job resource with a restart policy of Never and configure backoff limits. For DB migrations, 
    I ensure idempotency. To prevent re-runs, I label the Job or manage it through CI/CD pipelines with proper state checks.

## 5. Kubernetes Cluster Is Full – How Do You Troubleshoot?
**Scenario:**
Pods are pending, and you discover that nodes are out of resources.

#### What They Look For:

-   Resource management (requests/limits)

-   Horizontal autoscaling or cluster autoscaler

-   Resource quota inspection

**Sample Answer:**

    I’d use kubectl describe nodes and top pods to identify pods overusing resources. 
    Then, I'd check if pods have proper requests/limits set. If scaling is enabled, I’d verify if the cluster autoscaler is functional or if there are constraints like max node count.

## 6.Pod Is Not Starting Due to ImagePullBackOff
**Scenario:**
A pod fails to start and shows ImagePullBackOff.

#### what They Look For:

-   Image availability
    
-   Secret configuration for private registries

-   Typo or tag mismatch

**Sample Answer:**

    I’d check the image name and tag. If it’s private, I’d ensure the image pull secret is correctly set and referenced in the pod spec. 
    Also, I’d try pulling the image manually with docker pull to verify access.

## 7. Ingress Not Routing Traffic Correctly
**Scenario:**
Your Ingress is not forwarding traffic to the backend service.

#### what They Look For:

-   Ingress controller configuration

-   Service and path matching

-   Annotations and TLS setup

**Sample Answer:**
    
    I’d confirm that an Ingress controller like NGINX is deployed. 
    Then check the ingress.yaml paths, ensure the backend service is reachable, and verify annotations or TLS settings. 
    Testing with curl and checking controller logs helps isolate the issue.

## 8. How Do You Debug a Node Not Joining the Cluster?
**Scenario:**
A worker node is not joining the Kubernetes cluster during setup.

#### What They Look For:

-   kubelet/kubeadm logs

-   Token expiration

-   Firewall and networking

**Sample Answer:**

    I’d check logs with journalctl -u kubelet. I’d verify the join command token is valid (kubeadm token list) and confirm that required ports (e.g., 6443, 10250) are open between the master and worker node.

## 9.Configure Pod Affinity/Anti-Affinity
**Scenario:**
You want to ensure certain pods run on the same or different nodes.

### What They Look For:

-   Pod affinity/anti-affinity usage

-   Understanding of node/pod labels

**Sample Answer:**
I’d use affinity rules in the pod spec. For anti-affinity:
```commandline
affinity:
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
    - labelSelector:
        matchLabels:
          app: my-app
      topologyKey: "kubernetes.io/hostname"
```
This keeps similar pods on separate nodes for HA.

## 10.Managing Secrets Across Multiple Environments
**Scenario:**
You have different secrets for dev, staging, and prod environments.

### What They Look For:

-   Secret management practices

-   External secret stores (e.g., HashiCorp Vault, AWS Secrets Manager)

-   Namespace isolation

**Sample Answer:**
    
    I’d store secrets per namespace, manage access via RBAC, and use external secret operators (like ExternalSecrets or SealedSecrets) for centralized management. 
    Environment-specific secrets would be separated via CI/CD pipelines and namespace-based policies.

## 11.Limiting Resource Usage per Namespace
**Scenario:**
Developers are over-consuming resources in a shared cluster.

### What They Look For:

-   Quota management using ResourceQuota

-   Default limits with LimitRange

**Sample Answer:**

    I’d apply a ResourceQuota to limit CPU/memory per namespace and use a LimitRange to enforce default request/limit values for new pods. 
    This prevents noisy neighbors and enforces resource fairness.

## 12. App Needs to Access External Service with Static IP
**Scenario:**
Your app needs to call an external API that only allows whitelisted IPs.

### What They Look For:

-   Egress control

-   NAT gateway setup

-   Using egress IPs or static IP on cloud

**Sample Answer:**

    In cloud environments, I’d assign a static outbound IP via a NAT gateway or egress service. 
    In self-managed clusters, I’d use a dedicated node or interface with a known IP and force traffic from specific pods through that path using routing rules or network policies.