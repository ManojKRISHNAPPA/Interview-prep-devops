# 50 Kubernetes Scenario-Based Questions and Answers (Detailed)

---

## 1. Pod CrashLoopBackOff Issue

**Scenario:** A pod keeps crashing immediately after starting and enters `CrashLoopBackOff`.

**Explanation:** This usually happens when the container process inside the pod crashes repeatedly due to application errors, misconfiguration, or resource constraints.

**Troubleshooting Steps:**
- Run `kubectl logs <pod-name>` to check application error messages.
- Inspect readiness and liveness probes; misconfigured probes can cause restarts.
- Verify resource limits are not too low causing OOMKilled errors.
- Check environment variables, config maps, and secrets for correctness.

---

## 2. Node Not Ready State

**Scenario:** A node shows `NotReady` status and doesn’t schedule pods.

**Explanation:** This indicates the kubelet or node components are unhealthy or the node lost connectivity to the cluster.

**Troubleshooting Steps:**
- Run `kubectl describe node <node-name>` to see node conditions.
- Check kubelet service on the node (`systemctl status kubelet`).
- Verify network connectivity, firewall rules, and disk space.
- Restart kubelet or reboot the node if needed.

---

## 3. Service Not Accessible

**Scenario:** Kubernetes service exists, but pods behind it are unreachable.

**Explanation:** The service routes traffic to pods selected by labels. If selectors are mismatched or network policies block traffic, connectivity fails.

**Troubleshooting Steps:**
- Check service selectors match pod labels (`kubectl get pods --show-labels`).
- Verify endpoints with `kubectl get endpoints <service-name>`.
- Inspect network policies or firewall rules.
- Test pod-to-pod communication using debug pods.

---

## 4. PersistentVolumeClaim Pending

**Scenario:** PVC remains in `Pending` state indefinitely.

**Explanation:** This means Kubernetes cannot find or provision a PersistentVolume matching the PVC’s requirements.

**Troubleshooting Steps:**
- Confirm there are PVs with matching StorageClass, capacity, and access modes.
- If dynamic provisioning is used, verify the provisioner is running and StorageClass exists.
- Use `kubectl describe pvc <name>` to get detailed status.

---

## 5. Image Pull BackOff

**Scenario:** Pods fail to pull container images, showing `ImagePullBackOff`.

**Explanation:** The container runtime cannot download the specified image due to wrong image name, tag, or authentication failure.

**Troubleshooting Steps:**
- Check the image name and tag for typos.
- Verify the container registry credentials (image pull secret).
- Test pulling image manually on node: `docker pull <image>`.
- Check network connectivity to the registry.

---

## 6. Pods Not Scheduling

**Scenario:** Pods remain in `Pending` with no node assigned.

**Explanation:** Scheduler cannot find suitable nodes due to resource constraints, taints, or affinity rules.

**Troubleshooting Steps:**
- Inspect pod events: `kubectl describe pod <pod>`.
- Verify node resource availability (CPU, memory).
- Check for node taints and pod tolerations.
- Review node selectors and affinity rules.

---

## 7. ConfigMap Not Updating in Pod

**Scenario:** Changes to ConfigMap are not reflected in running pods.

**Explanation:** ConfigMaps mounted as files are loaded at pod start; changes require pod restart.

**Troubleshooting Steps:**
- Trigger rolling update or manually delete pods to reload ConfigMap.
- For environment variables from ConfigMap, restart pod to apply changes.
- Use `kubectl rollout restart deployment/<deployment-name>`.

---

## 8. Secret Not Found Error

**Scenario:** Pod fails to mount secret volume or environment variable.

**Explanation:** The referenced secret may be missing or in the wrong namespace.

**Troubleshooting Steps:**
- Verify secret exists in the pod’s namespace (`kubectl get secrets`).
- Check secret name and spelling in pod manifest.
- Confirm RBAC policies allow access.

---

## 9. Horizontal Pod Autoscaler Not Scaling

**Scenario:** HPA does not increase pod count despite high CPU usage.

**Explanation:** Metrics server may be missing or misconfigured, or resource requests are not set.

**Troubleshooting Steps:**
- Ensure metrics-server is deployed and healthy (`kubectl get pods -n kube-system`).
- Verify pods have CPU requests and limits set.
- Confirm HPA targets the correct deployment and metric.

---

## 10. Node Disk Pressure

**Scenario:** Node reports DiskPressure condition, evicting pods.

**Explanation:** Node disk space is low, causing kubelet to evict pods to reclaim space.

**Troubleshooting Steps:**
- Check disk usage with `df -h`.
- Clean unused files, logs, or docker images.
- Consider increasing disk size or adding nodes.

---

## 11. Kubernetes API Server Timeout

**Scenario:** `kubectl` commands hang or time out.

**Explanation:** API server is unreachable due to network, DNS, or certificate issues.

**Troubleshooting Steps:**
- Ping or curl API server endpoint.
- Verify API server pod status if self-hosted.
- Check firewall, load balancer, and kubeconfig certificates.

---

## 12. StatefulSet Pod Not Retaining Identity

**Scenario:** Pods in StatefulSet lose stable hostname or persistent storage.

**Explanation:** StatefulSet ensures stable identities; issues arise if PVCs or pod templates are misconfigured.

**Troubleshooting Steps:**
- Verify pod names follow StatefulSet pattern.
- Check PVC binding and StorageClass.
- Review StatefulSet update strategy.

---

## 13. DaemonSet Pods Not Running on All Nodes

**Scenario:** DaemonSet pods missing on some nodes.

**Explanation:** Node selectors, taints, or node readiness affect DaemonSet scheduling.

**Troubleshooting Steps:**
- Check DaemonSet pod status: `kubectl get pods -o wide`.
- Review node taints and tolerations.
- Confirm node labels match selectors.

---

## 14. Ingress Controller Not Routing Traffic

**Scenario:** Ingress resource exists but traffic is not reaching backend services.

**Explanation:** Missing or misconfigured ingress controller, or backend services unavailable.

**Troubleshooting Steps:**
- Verify ingress controller pods are running.
- Check ingress resource annotations and rules.
- Test backend service endpoints.

---

## 15. PersistentVolume VolumeMode Mismatch

**Scenario:** PVC fails due to VolumeMode mismatch (Filesystem vs Block).

**Explanation:** PVC and PV must have matching VolumeModes.

**Troubleshooting Steps:**
- Check PVC and PV definitions.
- Correct VolumeMode fields.
- Recreate PVC if necessary.

---

## 16. CronJob Not Triggering

**Scenario:** CronJob pods are never created at scheduled times.

**Explanation:** Invalid schedule, suspended jobs, or controller issues.

**Troubleshooting Steps:**
- Validate cron schedule syntax.
- Check CronJob status (`kubectl describe cronjob`).
- Ensure CronJob controller is running.

---

## 17. NetworkPolicy Blocking Traffic

**Scenario:** Pods cannot communicate due to restrictive NetworkPolicies.

**Explanation:** NetworkPolicies default deny traffic if not explicitly allowed.

**Troubleshooting Steps:**
- Review NetworkPolicy rules.
- Add ingress/egress rules as needed.
- Test connectivity between pods.

---

## 18. Rolling Update Stuck

**Scenario:** Deployment update hangs during rolling update.

**Explanation:** New pods fail readiness or liveness probes.

**Troubleshooting Steps:**
- Check pod logs for errors.
- Review probe configuration.
- Manually rollout restart if stuck.

---

## 19. Job Failing Immediately

**Scenario:** Kubernetes Job pods fail on startup.

**Explanation:** Application or command errors.

**Troubleshooting Steps:**
- Inspect pod logs.
- Check job spec commands.
- Verify image and environment.

---

## 20. Node Resource Pressure

**Scenario:** Pods evicted due to resource pressure.

**Explanation:** Node runs out of CPU or memory.

**Troubleshooting Steps:**
- Optimize pod resource requests.
- Scale out cluster or add nodes.

---

## 21. Service Account Permission Denied

**Scenario:** Pods unable to access API due to RBAC.

**Explanation:** Service accounts lack proper roles or bindings.

**Troubleshooting Steps:**
- Review RoleBindings and ClusterRoleBindings.
- Assign necessary permissions.

---

## 22. PersistentVolume Storage Class Not Found

**Scenario:** PVC creation fails with StorageClass not found.

**Explanation:** StorageClass missing or typo in PVC.

**Troubleshooting Steps:**
- List StorageClasses.
- Correct PVC manifest.

---

## 23. Pod Security Policy Blocking Pod Creation

**Scenario:** Pod creation fails with PSP rejection.

**Explanation:** Pod spec violates PSP restrictions.

**Troubleshooting Steps:**
- Review PSP policies.
- Modify PSP or pod spec accordingly.

---

## 24. API Server Certificate Expired

**Scenario:** API server rejects connections due to expired cert.

**Explanation:** Certificates must be renewed periodically.

**Troubleshooting Steps:**
- Renew certs.
- Restart API server.

---

## 25. Logs Not Accessible for Pods

**Scenario:** `kubectl logs` shows no output.

**Explanation:** Container may have crashed or logging misconfigured.

**Troubleshooting Steps:**
- Check pod events.
- Verify logging drivers.

---

## 26. PVC Volume Not Mounting

**Scenario:** Pod stuck in ContainerCreating due to volume mount failure.

**Explanation:** PV unavailable or permissions incorrect.

**Troubleshooting Steps:**
- Inspect events.
- Check PV status.

---

## 27. Unable to Scale Deployment

**Scenario:** Scaling command does not affect pod count.

**Explanation:** Pod disruption budget or resource constraints.

**Troubleshooting Steps:**
- Check PDBs.
- Inspect events and status.

---

## 28. DNS Resolution Fails in Pods

**Scenario:** Pods fail to resolve domain names.

**Explanation:** CoreDNS failure or misconfiguration.

**Troubleshooting Steps:**
- Check CoreDNS pods.
- Inspect config maps.

---

## 29. Cluster Autoscaler Not Scaling Up

**Scenario:** Pending pods not triggering node addition.

**Explanation:** Autoscaler misconfigured or limits reached.

**Troubleshooting Steps:**
- Check autoscaler logs.
- Review cloud provider limits.

---

## 30. Unable to Access Kubernetes Dashboard

**Scenario:** Dashboard UI inaccessible.

**Explanation:** RBAC or ingress issues.

**Troubleshooting Steps:**
- Check service and ingress.
- Review access tokens.

---

## 31. Container Running but Application Not Responding

**Scenario:** Pod is running but app unreachable.

**Explanation:** Internal app errors or network policies.

**Troubleshooting Steps:**
- Inspect logs.
- Verify probes.

---

## 32. ConfigMap Updates Not Reflected

**Scenario:** ConfigMap changes do not affect pods.

**Explanation:** Pods cache ConfigMaps on start.

**Troubleshooting Steps:**
- Restart pods.

---

## 33. Helm Release Upgrade Fails

**Scenario:** Helm upgrade fails with conflicts.

**Explanation:** Resource mismatch or conflicts.

**Troubleshooting Steps:**
- Review error logs.
- Rollback or fix manifests.

---

## 34. Taint Preventing Pod Scheduling

**Scenario:** Pods stay pending due to node taint.

**Explanation:** Missing tolerations.

**Troubleshooting Steps:**
- Add tolerations to pod spec.

---

## 35. Pod Evicted Due to Node Pressure

**Scenario:** Pods evicted because node resources are insufficient.

**Explanation:** High resource usage.

**Troubleshooting Steps:**
- Free resources or scale cluster.

---

## 36. PersistentVolume Binding Delays

**Scenario:** PVC stays pending due to volume binding issues.

**Explanation:** Provisioner or StorageClass misconfiguration.

**Troubleshooting Steps:**
- Check provisioner logs.

---

## 37. Unable to Delete Stuck Finalizers

**Scenario:** Resource stuck terminating due to finalizers.

**Explanation:** Finalizer preventing deletion.

**Troubleshooting Steps:**
- Patch resource to remove finalizers manually.

---

## 38. Cluster DNS Not Working After Upgrade

**Scenario:** DNS breaks after cluster upgrade.

**Explanation:** Incompatible CoreDNS version.

**Troubleshooting Steps:**
- Upgrade CoreDNS or revert.

---

## 39. Pod IP Not Assigned

**Scenario:** Pods have no IPs assigned.

**Explanation:** CNI plugin issues.

**Troubleshooting Steps:**
- Check CNI logs.

---

## 40. Kubernetes Events Fill Up Disk

**Scenario:** Disk full due to excessive event logs.

**Explanation:** No log rotation.

**Troubleshooting Steps:**
- Configure event retention and rotation.

---

## 41. Node Draining Causes Pod Disruptions

**Scenario:** Pods evicted on node drain but don’t reschedule.

**Explanation:** Pod Disruption Budget or resource limits.

**Troubleshooting Steps:**
- Review PDBs and cluster capacity.

---

## 42. Cluster Role Binding Not Working

**Scenario:** User lacks permissions despite bindings.

**Explanation:** Namespace mismatch or API group issues.

**Troubleshooting Steps:**
- Verify binding scopes.

---

## 43. Persistent Volume Reclaim Policy Issues

**Scenario:** PVs not deleted after PVC removal.

**Explanation:** Reclaim policy set to Retain.

**Troubleshooting Steps:**
- Modify reclaim policy.

---

## 44. Custom Resource Definition (CRD) Fails

**Scenario:** CRD objects rejected by API server.

**Explanation:** Invalid schema or API version.

**Troubleshooting Steps:**
- Validate CRD YAML.

---

## 45. Kubernetes Cluster Downtime During Upgrades

**Scenario:** Cluster goes down upgrading master nodes.

**Explanation:** Single control plane node.

**Troubleshooting Steps:**
- Use HA control plane for rolling upgrades.

---

## 46. Unable to Access Pod via Port Forward

**Scenario:** Port-forward fails.

**Explanation:** Pod down or network blocks.

**Troubleshooting Steps:**
- Check pod status and firewall.

---

## 47. Pod Logs Show OOMKilled

**Scenario:** Pod terminated due to out of memory.

**Explanation:** Insufficient memory limits.

**Troubleshooting Steps:**
- Increase pod memory or optimize app.

---

## 48. Service Type LoadBalancer Not Getting External IP

**Scenario:** LoadBalancer service IP stays pending.

**Explanation:** Missing cloud provider integration.

**Troubleshooting Steps:**
- Verify cloud controller manager.

---

## 49. Kubernetes Events Show ImagePullBackOff

**Scenario:** Image pull errors due to authentication.

**Explanation:** Invalid or missing image pull secret.

**Troubleshooting Steps:**
- Create or update pull secrets.

---

## 50. Kubernetes Audit Logs Missing Entries

**Scenario:** Audit logs incomplete.

**Explanation:** Misconfigured audit policy.

**Troubleshooting Steps:**
- Review API server audit flags and policy.

---

