# DevSecOps Intermediate to Advanced Q\&A

### SAST / DAST / OWASP ZAP

1. **Q:** What is the difference between SAST and DAST?
    
   **A:** SAST analyzes source code or binaries without executing them (white-box), while DAST tests a running application (black-box) by simulating attacks like SQLi or XSS.

2. **Q:** Why use OWASP ZAP in a CI/CD pipeline?
  
   **A:** ZAP automates DAST scans, identifying runtime vulnerabilities like injection, misconfigurations, and authentication flaws before release.

3. **Q:** How do you integrate OWASP ZAP in Jenkins?
   
    **A:** Using ZAP Docker image or Jenkins ZAP plugin, run a scan stage with target URL, parse reports (HTML/XML/JSON), and set thresholds to fail builds on critical findings.

4. **Q:** Scenario: Your OWASP ZAP scan shows many false positives. What steps do you take?
   
   **A:** Tune scan policies, exclude static content paths, whitelist trusted endpoints, and maintain a suppression file for known issues.

5. **Q:** How can you ensure DAST scans don’t overload production?
   
   **A:** Run scans in staging, throttle request rates, limit scope, and use authentication tokens to test only authorized flows.

---

### Unit & Mutation Testing

6. **Q:** What is mutation testing?
   
    **A:** Mutation testing introduces small code changes (mutants) and checks if unit tests catch them, measuring test effectiveness.

7. **Q:** How do mutation tests improve security?
   
   **A:** They ensure test cases cover unexpected code paths, reducing the risk of untested vulnerabilities.

8. **Q:** Which tools are commonly used for mutation testing in Java projects?
   
    **A:** PIT Mutation Testing and Major.

9. **Q:** Scenario: Your mutation score is low despite high code coverage. Why?

    **A:** Code coverage only measures executed lines, while mutation testing measures whether logic flaws are detected. Low mutation score means weak test assertions.

10. **Q:** How do you balance mutation testing with build performance?
    
    **A:** Run full mutation tests nightly or on feature branches, and run partial tests (changed modules) on every commit.

---

### Trivy / CVEs / CWEs

11. **Q:** What does Trivy scan?
    
    **A:** It scans container images, filesystems, and Git repos for vulnerabilities (CVEs), misconfigurations, and secrets.

12. **Q:** How do you prioritize CVEs found in Trivy?
    
    **A:** Use CVSS score, exploitability, CWE type, business impact, and whether patches are available.

13. **Q:** Scenario: Trivy detects a high CVE in a base image. What’s your approach?

    **A:** Update the base image, rebuild, verify fixes, and pin versions to prevent reintroduction.

14. **Q:** What’s the difference between CVE and CWE?
    
    **A:** CVE identifies specific vulnerabilities (e.g., CVE-2023-XXXX), while CWE categorizes types of weaknesses (e.g., CWE-89: SQL Injection).

15. **Q:** How do you automate vulnerability scanning in CI/CD?
    
    **A:** Add a scan stage using Trivy, parse JSON reports, fail builds on critical CVEs, and push results to dashboards like DefectDojo.

---

### Kube-bench / Kubescan / EKS Security

16. **Q:** What does kube-bench do?
    
    **A:** It checks if Kubernetes is deployed securely per CIS benchmarks.

17. **Q:** How does Kubescan differ from kube-bench?
    
    **A:** Kubescan analyzes Kubernetes resources (YAML/Helm/CRDs) for misconfigurations, while kube-bench audits cluster components.

18. **Q:** Scenario: kube-bench fails CIS checks for etcd encryption. How do you remediate?

    **A:** Enable encryption at rest with KMS or secrets encryption config in API server flags.

19. **Q:** How do you secure EKS worker nodes?

    **A:** Harden AMIs, apply IAM roles with least privilege, restrict SSH, use Security Groups, and enable managed node groups.

20. **Q:** How do you implement pod security in EKS?
    
    **A:** Use PSPs (deprecated) → Pod Security Admission, OPA/Conftest policies, restrict capabilities, enforce seccomp and AppArmor.

---

### Istio Service Mesh / mTLS / Benchmarking

21. **Q:** Why use Istio in DevSecOps?
    
    **A:** It enforces mTLS, traffic encryption, zero-trust networking, policy enforcement, observability, and RBAC.

22. **Q:** Scenario: One microservice isn’t honoring mTLS in Istio. How do you debug?
    
    **A:** Check DestinationRule/PeerAuthentication policies, ensure sidecar injection, verify certificates with Envoy logs.

23. **Q:** How does Istio help in DAST testing?

    **A:** It mirrors traffic to test services, throttles requests, and isolates test workloads with traffic shifting.

24. **Q:** What benchmarking tools do you use for service mesh performance?
    
    **A:** Fortio, wrk, and JMeter to measure latency, throughput, and encryption overhead.

25. **Q:** How do you balance security vs. latency in Istio mTLS?

    **A:** Use mutual TLS with hardware acceleration, configure strict mode only where needed, and benchmark regularly.

---

### OPA / Conftest / Policy as Code

26. **Q:** What is OPA?
    
    **A:** Open Policy Agent is a policy engine that enforces rules across Kubernetes, CI/CD, APIs, and infrastructure.

27. **Q:** How do you use Conftest in pipelines?
    
    **A:** Write Rego policies to validate Kubernetes YAML, Terraform, or Dockerfiles; fail builds if policies are violated.

28. **Q:** Scenario: A developer tries to deploy a container as root. How do you block it?
    
    **A:** Conftest Rego policy checking `securityContext.runAsNonRoot` must be true.

29. **Q:** How do you centralize OPA policies across environments?
    
    **A:** Store in Git repos, apply via Gatekeeper in Kubernetes, reuse in CI/CD with Conftest, and manage via version control.

30. **Q:** How do OPA policies improve compliance?
    
    **A:** They enforce consistent guardrails (encryption, least privilege, rootless containers) automatically at scale.

---

### CI/CD Pipeline Security

31. **Q:** What’s the order of scans in a DevSecOps pipeline?
    
    **A:** Start with SAST → Dependency scans (Trivy) → Unit/Mutation tests → Build → DAST (ZAP) → Infrastructure scans (Kube-bench/Kubescan) → Deployment.

32. **Q:** How do you prevent secrets from leaking in CI/CD?
    
    **A:** Use secret scanners (Trivy, Gitleaks), vault integrations, avoid hardcoding, and enforce policy-as-code.

33. **Q:** Scenario: Your Jenkins build fails on a false-positive Trivy scan. What do you do?
    
    **A:** Create an allowlist for specific CVEs, document business justification, and review regularly.

34. **Q:** Why run security scans early in pipelines?
    
    **A:** To shift left, reduce remediation cost, and catch vulnerabilities before deployment.

35. **Q:** How do you integrate OPA with Jenkins?

    **A:** Add a `conftest test` stage in Jenkinsfile to validate configs against Rego policies before deploying.

---

### Scenario-based / Advanced

36. **Q:** Scenario: Your container passed Trivy but fails CIS Kubernetes benchmark. Why?
    
    **A:** Trivy checks vulnerabilities in images, while CIS benchmarks check cluster-level security (RBAC, audit logging, TLS).

37. **Q:** Scenario: After deployment, a pod is running with hostPath mount. What’s the risk?
    
    **A:** Privilege escalation and host compromise. Fix with OPA policy to deny hostPath unless justified.

38. **Q:** How do you secure CI/CD agents in Jenkins?
    
    **A:** Run agents in isolated containers, use minimal permissions, rotate credentials, and scan agent images.

39. **Q:** What role does CVSS score play in remediation SLA?
    
    **A:** Defines priority: Critical (24h), High (72h), Medium/Low (planned patch cycles).

40. **Q:** How do you ensure reproducible builds for security?
    
    **A:** Pin dependencies, use build caches carefully, and generate SBOMs (e.g., with Syft/Trivy).

---

### Medium-Hard Technical

41. **Q:** How do you enforce mTLS across namespaces in Istio?
    
    **A:** Apply PeerAuthentication in strict mode at namespace level and align DestinationRules.

42. **Q:** How do you scan Helm charts for misconfigurations?
    
    **A:** Render templates (`helm template`) and test with Conftest or Kube-linter.

43. **Q:** Scenario: A vulnerable dependency is not patched upstream. What’s your approach?
    
    **A:** Apply temporary patch, vendor dependency, or isolate the service with strict Istio policies.

44. **Q:** How do you use mutation testing in a security context?
    
    **A:** Create mutants simulating insecure code (e.g., bypassing input validation) and ensure tests catch them.

45. **Q:** How do you ensure Istio sidecars don’t introduce vulnerabilities?
    
    **A:** Keep Envoy images updated, scan sidecar containers with Trivy, and monitor CVEs.

46. **Q:** How do you benchmark EKS cluster performance with security features enabled?
    
    **A:** Use kube-bench/kubescan before/after enabling features like encryption and network policies, then run load tests.

47. **Q:** Scenario: Dev team wants to skip mutation tests due to slow builds. How do you handle?
    
    **A:** Compromise with partial testing per commit and full nightly runs, emphasizing quality benefits.

48. **Q:** How do you automate policy testing for Terraform in CI/CD?
    
    **A:** Use Conftest with Rego rules (e.g., deny public S3 buckets) and enforce via Jenkins/GitHub Actions.

49. **Q:** How do you secure application deployments on EKS?
    
    **A:** Use IaC scanning, enforce OPA policies, enable network policies, scan images, enforce mTLS, and audit logs.

50. **Q:** Scenario: A deployment failed because Conftest blocked it. How do you troubleshoot?
    
    **A:** Check policy violation messages, update policies if needed, and communicate with devs to adjust manifests.

---

# Resume Points

1. Designed and implemented end-to-end **DevSecOps pipelines** using Jenkins.
2. Integrated **SAST tools** for static code vulnerability scanning.
3. Automated **DAST scans with OWASP ZAP** in staging environments.
4. Applied **unit and mutation testing** to ensure robust application logic.
5. Integrated **Trivy** for container image scanning and CVE detection.
6. Established vulnerability management process using **CVSS prioritization**.
7. Conducted security audits with **kube-bench** for CIS Kubernetes benchmarks.
8. Scanned Kubernetes manifests with **Kubescan and Conftest**.
9. Enforced **OPA/Rego policies** to block insecure deployments.
10. Implemented **Istio service mesh** for secure service-to-service mTLS.
11. Benchmarked Istio performance and optimized security vs. latency trade-offs.
12. Built and deployed **Spring Boot applications** to secure EKS clusters.
13. Automated remediation workflows for high/critical CVEs.
14. Developed policy-as-code for **Terraform and Kubernetes**.
15. Ensured compliance with **CWE and CIS standards**.
16. Configured Jenkins agents with hardened and scanned images.
17. Integrated SBOM generation and dependency scanning in pipelines.
18. Established security gates for every stage of CI/CD lifecycle.
19. Collaborated with developers to reduce false positives and enhance test coverage.
20. Delivered a scalable, secure, and automated **DevSecOps framework** for cloud-native applications.
