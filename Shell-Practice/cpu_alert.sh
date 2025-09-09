#!/bin/bash

THRESHOLD=70
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 -$1}')
if (( $(echo "$cpu_usage > $THRESHOLD" | bc -l ) )); then
	echo "WARNING!!!!!!: CPU usgae is above $THRESHOLD%. current usage: $cpu_usage%" | mail -s "CPU usage Alert" manojdevopstest@gmail.com
fi
