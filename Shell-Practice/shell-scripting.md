# Shell Scripting
### 1. Why Shell Scripting in DevOps?
   -   Automate server setups (e.g., install packages, configure services)
   -    Write deployment scripts
   -    Manage logs and backups
   - Monitor system resources
   - Integrate with tools like Docker, Jenkins, Kubernetes

### 2. Basic Shell Script Structure
```commandline
#!/bin/bash
# This is a comment
echo "Hello, DevOps!"
```

### 3.  Install Packages
```commandline
#!/bin/bash
sudo apt update && sudo apt install -y tomcat
```
### 4. Monitor Disk Usage
```commandline
#!/bin/bash
df -h > disk
```
```commandline
usage
_
report.txt
Purpose: Saves disk space usage to a file for review later.
```

### 5. Backup Files
```commandline
#!/bin/bash
tar -czf backup_
$(date +%F).tar.gz /path/to/directory
```
**Purpose:** Compresses a directory into a .tar.gz backup file with the current date.

### 6. Jenkins Job Trigger
```commandline
#!/bin/bash
curl -X POST http://jenkins.local/job/your-job-name/build \
--user your-user:your-api-token
```
**Purpose:** Triggers a Jenkins CI job remotely using a POST request and
authentication
### 7. Docker Container Health Check
```commandline
#!/bin/bash
if docker ps | grep -q my_container; then
    echo "Container is running"
else
    echo "Container is down"
fi
```
**Purpose:** Checks if a specific Docker container (my_container) is running.

### 8. System Health Check
```commandline
#!/bin/bash
echo "CPU Load:"; uptime
echo -e "\nMemory Usage:"; free -m
echo -e "\nDisk Usage:"; df -h
echo -e "\nTop 5 Memory Consuming Processes:"; ps aux --sort=-%mem | head -n 6
```
**Purpose:** Shows system metrics like CPU load, memory, disk, and top
memory-consuming processes.

### 9. Service Restart on Failure
```commandline
#!/bin/bash
SERVICE="nginx"
if ! systemctl is-active --quiet $SERVICE; then
    echo "$SERVICE is down. Restarting..."
    systemctl start $SERVICE
else
    echo "$SERVICE is running"
fi
```
**Purpose:** Checks if nginx service is down and restarts it automatically.

### 10. Log Rotation Script
```commandline
#!/bin/bash

# Define the directories
LOG_DIR="/var/log/myapp"
ARCHIVE_DIR="/var/log/myapp/archive"

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

# Move logs older than 7 days to the archive directory
find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec mv {} "$ARCHIVE_DIR" \;

# Compress the moved log files
gzip "$ARCHIVE_DIR"/*.log

# Purpose:
# Moves .log files older than 7 days from LOG_DIR to ARCHIVE_DIR and compresses them.

```

### 11.Git Auto Pull
```commandline
#!/bin/bash
cd /home/ubuntu/my-repo
git pull origin main
Purpose: Automatically pulls the latest code from GitHub (useful with cron jobs).
```

### 12.Docker Cleanup Script
```commandline
#!/bin/bash
docker container prune -f
docker image prune -f
docker volume prune -f
```
Purpose: Frees disk space by removing unused Docker containers, images, and  volumes.

### 13.Kubernetes Pod Status Checker
```commandline
#!/bin/bash
NAMESPACE="default"
kubectl get pods -n $NAMESPACE | grep -v Running
```
Purpose: Lists non-running pods in a Kubernetes namespace.

### 14. Jenkins Job Trigger with Token
```commandline
#!/bin/bash

# Jenkins credentials and job details
JENKINS_URL="http://jenkins.local"
JOB_NAME="my-job"
USER="your-user"
API_TOKEN="your-token"

# Trigger the Jenkins job using curl
curl -X POST "${JENKINS_URL}/job/${JOB_NAME}/build" \
     --user "${USER}:${API_TOKEN}"

```