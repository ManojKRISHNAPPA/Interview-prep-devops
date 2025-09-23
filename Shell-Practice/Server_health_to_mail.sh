#!/bin/bash

# Collect stats
os_info=$(lsb_release -d | cut -f2)
uptime_info=$(uptime -p)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')

# Memory
mem_total=$(free -m | awk 'NR==2{print $2}')
mem_used=$(free -m | awk 'NR==2{print $3}')
mem_free=$(free -m | awk 'NR==2{print $4}')
mem_used_pct=$(free -m | awk 'NR==2{printf "%.1f", $3*100/$2}')
mem_free_pct=$(free -m | awk 'NR==2{printf "%.1f", $4*100/$2}')

# Disk
disk_info=$(df -h / | awk 'NR==2{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>", $1,$2,$3,$4,$5}')

# Top processes
top_cpu=$(ps -eo user,pid,%cpu,%mem,comm --sort=-%cpu | head -n 6 | awk 'NR>1{printf "<tr><td>%s</td><td>%s</td><td>%s%%</td><td>%s%%</td><td>%s</td></tr>", $1,$2,$3,$4,$5}')
top_mem=$(ps -eo user,pid,%cpu,%mem,comm --sort=-%mem | head -n 6 | awk 'NR>1{printf "<tr><td>%s</td><td>%s</td><td>%s%%</td><td>%s%%</td><td>%s</td></tr>", $1,$2,$3,$4,$5}')

# Build HTML report
report=$(cat <<EOF
<html>
<head>
  <style>
    body { font-family: Arial, sans-serif; background: #f9f9f9; color: #333; }
    h2 { background: #4CAF50; color: white; padding: 8px; border-radius: 5px; }
    table { width: 90%; border-collapse: collapse; margin: 10px 0; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background: #f2f2f2; }
    .section { margin-bottom: 20px; }
  </style>
</head>
<body>
  <h2>📊 System Report - $(hostname)</h2>
  <p><b>Generated at:</b> $(date +"%Y-%m-%d %H:%M:%S")</p>

  <div class="section">
    <h3>🖥️ OS Info</h3>
    <p>$os_info</p>
  </div>

  <div class="section">
    <h3>⏱️ CPU Uptime</h3>
    <p>$uptime_info</p>
  </div>

  <div class="section">
    <h3>⚡ CPU Usage</h3>
    <p><b>Usage:</b> $cpu_usage</p>
  </div>

  <div class="section">
    <h3>🧠 Memory Usage</h3>
    <table>
      <tr><th>Total (MB)</th><th>Used (MB)</th><th>Used %</th><th>Free (MB)</th><th>Free %</th></tr>
      <tr><td>$mem_total</td><td>$mem_used</td><td>$mem_used_pct%</td><td>$mem_free</td><td>$mem_free_pct%</td></tr>
    </table>
  </div>

  <div class="section">
    <h3>💾 Disk Usage</h3>
    <table>
      <tr><th>Filesystem</th><th>Size</th><th>Used</th><th>Available</th><th>Use %</th></tr>
      $disk_info
    </table>
  </div>

  <div class="section">
    <h3>🔥 Top 5 Processes by CPU</h3>
    <table>
      <tr><th>User</th><th>PID</th><th>%CPU</th><th>%MEM</th><th>Command</th></tr>
      $top_cpu
    </table>
  </div>

  <div class="section">
    <h3>🧠 Top 5 Processes by Memory</h3>
    <table>
      <tr><th>User</th><th>PID</th><th>%CPU</th><th>%MEM</th><th>Command</th></tr>
      $top_mem
    </table>
  </div>
</body>
</html>
EOF
)

# Email settings
TO="manojdevopstest@gmail.com"
SUBJECT="📊 System Report: $(hostname)"

# Send email (HTML format)
echo "$report" | mail -a "Content-Type: text/html" -s "$SUBJECT" "$TO"
