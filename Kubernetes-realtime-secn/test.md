# Scenario-Based Kubernetes Interview Questions (Frequently Asked)

These are **real-world Kubernetes scenarios** commonly asked in **DevOps / SRE interviews (2–5 years experience)**.

---

## 1. Pod in CrashLoopBackOff

**Scenario:**  
A pod keeps restarting and shows `CrashLoopBackOff`.

**Interview Questions:**
- How do you debug this issue?
- Which commands will you use?
- What are common root causes?

**Key Areas to Cover:**
- `kubectl logs <pod-name>`
- `kubectl describe pod <pod-name>`
- Application crash
- Wrong CMD / ENTRYPOINT
- Missing environment variables or config

---

## 2. Application Running but Not Accessible

**Scenario:**  
Pod is running, Service exists, but application is not accessible.

**Interview Questions:**
- How do you debug connectivity issues?
- How do you verify Service to Pod communication?

**Key Areas to Cover:**
- Service type (ClusterIP / NodePort / LoadBalancer)
- Pod labels vs Service selectors
- Endpoints
- Container port vs Service port

---

## 3. Deployment Causing Downtime

**Scenario:**  
A new application version caused downtime during deployment.

**Interview Questions:**
- How do you avoid downtime?
- Which deployment strategy would you use?

**Key Areas to Cover:**
- Rolling updates
- `maxUnavailable` and `maxSurge`
- Readiness probes
- Blue-Green and Canary deployments

---

## 4. ConfigMap Changes Not Reflected

**Scenario:**  
ConfigMap was updated but the application didn’t pick up changes.

**Interview Questions:**
- Why didn’t the app reflect the change?
- How can you reload config without downtime?

**Key Areas to Cover:**
- ConfigMaps as env vars vs volume mounts
- Pod restart requirement
- Rolling restart
- Config reload tools (reloader)

---

## 5. Secrets Exposed in Plain Text

**Scenario:**  
Secrets are visible in pod logs or environment variables.

**Interview Questions:**
- Why is this a security risk?
- How do you secure secrets?

**Key Areas to Cover:**
- Base64 encoding vs encryption
- RBAC restrictions
- External secret managers (Vault, AWS Secrets Manager)

---

## 6. Pod Getting OOMKilled

**Scenario:**  
Pod frequently restarts with `OOMKilled`.

**Interview Questions:**
- What does OOMKilled mean?
- How do you fix it?

**Key Areas to Cover:**
- Memory requests and limits
- JVM memory tuning
- Horizontal Pod Autoscaler
- Monitoring memory usage

---

## 7. Node Becomes NotReady

**Scenario:**  
A Kubernetes node suddenly goes to `NotReady`.

**Interview Questions:**
- How do you troubleshoot this?
- What happens to pods running on this node?

**Key Areas to Cover:**
- Kubelet status
- Disk / memory pressure
- Pod eviction
- Node draining

---

## 8. Application Slow During Traffic Spike

**Scenario:**  
Application becomes slow during peak traffic.

**Interview Questions:**
- How do you handle scaling?
- Difference between HPA and Cluster Autoscaler?

**Key Areas to Cover:**
- Horizontal Pod Autoscaler (HPA)
- CPU / memory based scaling
- Custom metrics
- Pod vs Node scaling

---

## 9. Developer Has Cluster-Admin Access

**Scenario:**  
Developers have full `cluster-admin` access.

**Interview Questions:**
- Why is this risky?
- How do you restrict access?

**Key Areas to Cover:**
- RBAC
- Role vs ClusterRole
- Principle of least privilege
- Service accounts

---

## 10. Pod Accessing Kubernetes API

**Scenario:**  
A pod is unexpectedly accessing the Kubernetes API.

**Interview Questions:**
- How is this possible?
- How do you restrict API access?

**Key Areas to Cover:**
- ServiceAccount tokens
- `automountServiceAccountToken`
- Network policies

---

## 11. Data Lost After Pod Restart

**Scenario:**  
Application data is lost after pod restart.

**Interview Questions:**
- Why did this happen?
- How do you persist data?

**Key Areas to Cover:**
- `emptyDir` vs PersistentVolumes
- PersistentVolumeClaim (PVC)
- StorageClasses

---

## 12. Pod Stuck in Pending State

**Scenario:**  
Pod remains in `Pending` state.

**Interview Questions:**
- What are possible causes?
- How do you troubleshoot?

**Key Areas to Cover:**
- Insufficient CPU / memory
- PVC not bound
- Node selectors
- Taints and tolerations

---

## 13. Image Updated but Old Version Running

**Scenario:**  
New image pushed, but pods still run old version.

**Interview Questions:**
- Why did this happen?
- How do you force update?

**Key Areas to Cover:**
- Image tags (`latest`)
- `imagePullPolicy`
- Rolling restart
