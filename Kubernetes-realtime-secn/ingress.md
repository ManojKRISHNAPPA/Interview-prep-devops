## What is Ingress in Kubernetes?
-   Ingress is a Kubernetes API object that manages external access to services in a cluster, typically HTTP and HTTPS traffic.

  -   It's like a smart gateway that:

      - Routes incoming requests (based on path or domain)

      - Handles SSL/TLS termination (HTTPS)

      - Can load balance traffic across services

## How It Works
By default, Kubernetes services like ClusterIP and NodePort expose apps inside the cluster or on specific ports. But if you want to expose multiple apps under one IP or domain, you use Ingress + Ingress Controller.

## Requirements:
-   Ingress resource – defines rules for routing.

-   Ingress Controller – implements those rules (e.g., NGINX, Traefik, AWS ALB Ingress).

## Example Use Case
-   You have two services:

    - frontend (serving on /)

    -   api (serving on /api)

    - You want both to be accessible under a single domain example.com.

ingress.yaml
```commandline
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api
            port:
              number: 80

```
## What This Does:
-   Requests to example.com/ go to the frontend service.

-   Requests to example.com/api go to the api service.

## TLS/HTTPS with Ingress
```commandline
spec:
  tls:
  - hosts:
    - example.com
    secretName: tls-secret
```

## Ingress Controllers
Ingress resources do nothing on their own. You need an Ingress Controller deployed in your cluster to interpret and act on them.

**Popular Controllers:**
-   NGINX Ingress Controller (most common)

-   Traefik

-   HAProxy

-   AWS ALB Ingress Controller

-   GKE Ingress (Google Cloud)

### To install NGINX ingress (for example):
```commandline
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.1/deploy/static/provider/cloud/deploy.yaml
```

## When to Use Ingress
Use Ingress when:

-   You need host- or path-based routing

-   You want to expose multiple services under one IP

-   You need HTTPS termination

-   You want to control traffic with annotations and middleware




