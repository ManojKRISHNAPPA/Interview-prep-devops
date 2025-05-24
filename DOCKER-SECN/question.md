# Docker Scenario-Based Interview Questions and Answers

## 1. You’ve made changes to your application code. How do you rebuild and run your updated Docker container?
To rebuild and run the updated Docker container, use:
```bash
docker build -t your-image-name .
docker run -d --name your-container-name your-image-name
```
## 2. A container keeps crashing after a few seconds. How would you debug the issue?
Check container logs using:
```commandline
docker logs <container_id_or_name>
```
Inspect container exit status:
```commandline
docker inspect <container_id> --format='{{.State.ExitCode}}'
```
Run the container interactively to debug:
```commandline
docker run -it --entrypoint /bin/bash your-image
```

## 3 You want to persist logs generated inside a container. How would you do that using Docker?
Use volumes to map container log directory to host:
```commandline
docker run -v /host/log/dir:/container/log/dir your-image
```
## 4. You need to run a temporary container to test a new image without saving changes. What command would you use?
Run a container interactively and remove it after exit:
```commandline
docker run --rm -it your-image /bin/bash
```
--rm removes container after exit, perfect for temporary tests.

## 5. You’re asked to reduce the size of a Docker image. What are some strategies you’d use?
-   Use a smaller base image (e.g., alpine).

-   Multi-stage builds to separate build environment from runtime.

-   Remove unnecessary files/packages in the image.

-   Combine RUN commands to reduce layers.

-   Use .dockerignore to exclude files from build context.

## 6. How would you allow communication between two containers without exposing ports to the host machine?
```commandline
docker network create my-network
docker run --net my-network --name container1 ...
docker run --net my-network --name container2 ...
```
Containers can access each other by container name.

### 7. You need to schedule a nightly cleanup task inside a Docker container. How would you achieve that?

Options:
- Use a cron job inside the container (not ideal).

- Use the host’s cron to run a cleanup script that interacts with Docker (recommended).

- Use Docker’s built-in scheduling with external tools like Kubernetes CronJobs or Jenkins pipelines.

### 8. You notice high CPU usage by a container. How would you limit its resource usage?
```commandline
docker run --cpus=".5" your-image
```
This limits the container to half a CPU. You can also limit memory with --memory flag.

### 9. Your app uses environment-specific configs (dev, staging, prod). How would you manage this in Docker?
```commandline
docker run --env-file ./prod.env your-image
```
Alternatively, mount config files as volumes, or use Docker Compose overrides per environment.

### 10. How can you share data between your host and a container during development?
Use bind mounts to map host directory to container:
```commandline
docker run -v /host/code:/app your-image
```

## 11. You're using Docker Compose and want to ensure your web app waits until the database is ready. How do you handle this?
Use a wait script (e.g., wait-for-it.sh) in the web app’s Dockerfile or entrypoint, or use Docker Compose’s depends_on (note: it doesn’t wait for service readiness, only start order).
Better to implement retry logic inside the application or entrypoint script.

## 12.Explain how you would debug a networking issue between two services running in the same Docker network.
-   Check container IPs and connectivity with docker exec and ping.

-   Use docker network inspect <network> to verify network config.

-   Verify port exposure and container firewall rules.

-   Check logs for DNS or connection errors.

-   Test connecting to ports using curl or telnet.

## 13. How would you expose a service running inside a container to the public internet, securely?
-   Map container port to host with -p host_port:container_port.

-   Use a reverse proxy like Nginx or Traefik with SSL termination.

-   Use firewall rules to restrict access.

-   Avoid running containers as root and minimize permissions.

-   Use authentication and encryption on exposed endpoints.

## 14. A database in Docker Compose is not persisting data across restarts. What's the likely issue?
Probably the database volume is not mounted or incorrectly configured. Use named or bind volumes to persist data.


## 15. How would you connect to a running container’s shell for inspection or debugging?
Use:
```commandline
docker exec -it <container_name_or_id> /bin/bash
```

## 16. What happens if you bind port 80 of two containers to the host? How would you handle it properly?
-   Port conflict error occurs because only one container can bind to a host port. To fix:

-   Use different host ports, e.g., -p 8080:80 and -p 8081:80.

-   Use a reverse proxy to route requests internally.

## 17. Your container has a volume mounted, but changes aren’t reflected on the host. Why might that happen?
Possible causes:
-   Volume is a named volume masking the bind mount.

-   Container is writing to a different path.

-   Filesystem permission issues.

-   Overlay filesystem caching delays.

## 18. How would you perform a zero-downtime deployment with Docker containers in production?
-   Use orchestration tools (Kubernetes, Docker Swarm) to update containers incrementally. Alternatively:

-   Start new container with updated image.

-   Switch traffic via load balancer or proxy.

-   Stop old container only after new one is ready.

## 19. You’re tasked with scanning Docker images for vulnerabilities. What tools or steps would you take?
Use vulnerability scanners like:
Docker Hub built-in scanning

-   trivy

-   clair

-   anchore

Run scans as part of CI/CD pipeline and update base images regularly.

## 20. How can you ensure that containers are only allowed to use limited memory and CPU?
Use resource constraints flags during run:
```commandline
docker run --memory="512m" --cpus=".5" your-image
```

## 21.Your Docker image has sensitive information (e.g., secrets). How do you avoid this during image builds?
-   Don’t hardcode secrets in Dockerfile.

-   Use build arguments carefully.

-   Use Docker secrets or environment variables at runtime.

-   Remove secrets after use in multi-stage builds.

## 22. What are some best practices to secure Docker containers in a production environment?
- Run containers with least privileges (--user flag).

- Use read-only filesystems (--read-only).

- Avoid running containers as root.

- Keep images updated and minimal.

- Use security scanning tools.

# Network .

## 23. You need to run database migrations before starting your application. How do you handle this in Docker Compose?
Use a separate migration service that runs once before app starts, or use entrypoint scripts with wait logic to run migrations.

## 24. During a CI/CD pipeline, your Docker build fails due to missing packages. How do you debug and fix this?
Check Dockerfile for missing apt-get update or package installs. Run intermediate container interactively to test installs:
```commandline
docker run -it <image_id> /bin/bash
```

## 25. A container running in CI fails intermittently due to network issues. How do you make the build more reliable?
-   Retry network commands.

-   Increase timeouts.

-   Use Docker build cache properly.

-   Ensure stable CI environment network.

## 26. You need to create a multi-stage Dockerfile to optimize image size. What does that look like?
```
# Build stage
FROM golang:alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

# Final stage
FROM alpine
COPY --from=builder /app/myapp /usr/local/bin/myapp
ENTRYPOINT ["myapp"]
```

Build dependencies are discarded in the final image.

## 27. You are deploying an application with Docker and need to monitor container logs and health. What strategies and tools would you use?
-   Use Docker logging drivers (e.g., json-file, syslog).

-   Centralize logs with ELK stack or Splunk.

-   Use docker inspect and healthcheck in Dockerfile.

-   Use orchestration tools (Kubernetes) with built-in health monitoring.