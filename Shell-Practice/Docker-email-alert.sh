## control the email alerts 

#!/bin/bash

ALERT_LIMIT=5
COUNTER_FILE="/tmp/docker_alert_count"

if [ ! -f "$COUNTER_FILE" ]; then
    echo 0 > "$COUNTER_FILE"
fi

count=$(cat "$COUNTER_FILE")

DockerHealth=$(systemctl status docker | awk '/Active/ {print $3}' | tr -d "[()]")
DockerVersion=$(docker -v | awk '{print $3}' | tr -d ",")

echo "The Docker Health is: $DockerHealth"
echo "The Docker Version is: $DockerVersion"

if [[ "$DockerHealth" == "dead" ]]; then
    if [ "$count" -lt "$ALERT_LIMIT" ]; then
        # Send critical alert
        echo -e "Subject: CRITICAL ALERT - Docker is dead on $(hostname)\n\nDocker service is not running.\n\nStatus: $DockerHealth\nDocker current Version: $DockerVersion" \
        | msmtp manojdevopstest@gmail.com hanhksp@gmail.com jyothij1056@gmail.com
        echo "Alert email sent"

        count=$((count+1))
        echo $count > "$COUNTER_FILE"

        sleep 10
        systemctl restart docker

        NewHealth=$(systemctl status docker | awk '/Active/ {print $3}' | tr -d "[()]")

        echo -e "Docker service is restarted... on $(hostname).\n\nStatus: $NewHealth\nDocker current Version: $DockerVersion" \
        | mail -s "INFO ALERT - RESTORED THE DOCKER HEALTH ON $(hostname)" manojdevopstest@gmail.com hanhksp@gmail.com jyothij1056@gmail.com
        echo "Recovery alert sent"
    else
        echo "Alert limit ($ALERT_LIMIT) reached. No more emails will be sent."
    fi
fi
