#!/bin/bash
DockerHealth=$(systemctl status docker | awk '/Active/ {print $3}' | tr -d "[()]")
DockerVersion=$(docker -v | awk '{print $3}' | tr -d ",")

echo "The Docker Health is: $DockerHealth"
echo "The Docker Version is: $DockerVersion"

if [[ "$DockerHealth" == "dead" ]]; then
    echo -e "Subject: CRITICAL ALERT - Docker is dead on $(hostname)\n\nDocker service is not running.\n\nStatus: $DockerHealth\nDocker current Version: $DockerVersion" | msmtp manojdevopstest@gmail.com hanhksp@gmail.com jyothij1056@gmail.com
    echo "Alert email sent"

    sleep 10

    systemctl restart docker

    NewHealth=$(systemctl status docker | awk '/Active/ {print $3}' | tr -d "[()]")

    echo -e "Docker service is restarted... on $(hostname).\n\nStatus: $NewHealth \nDocker current Version: $DockerVersion"\
     | mail -s "INFO ALERT - RESTORED THE DOCKER HEALTH ON $(hostname)" manojdevopstest@gmail.com hanhksp@gmail.com jyothij1056@gmail.com
    echo "Aler is sent"
fi
