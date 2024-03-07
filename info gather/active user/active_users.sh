#!/bin/bash
# Filename: active_users.sh
# Description: Reporting tool to find out active users

log_file="/var/log/wtmp"

if [[ -n $1 ]]; then
  log_file="$1"
fi

temp_ulog="/tmp/ulog.$$"
temp_users="/tmp/users.$$"
temp_user_log="/tmp/user.$$"

printf "%-4s %-10s %-10s %-6s %-8s\n" "Rank" "User" "Start" "Logins" "Usage hours"

# Get the user activity from the log file
last -f "$log_file" | head -n -2 > "$temp_ulog"

# Extract unique users
cut -d' ' -f1 "$temp_ulog" | sort | uniq > "$temp_users"

# Process each user
while read -r user; do
  grep "^$user " "$temp_ulog" > "$temp_user_log"
  
  total_minutes=0
  while read -r line; do
    time_field=$(echo "$line" | awk '{print $NF}' | tr -d ')(')
    minutes=$(awk -F: '{print ($1 * 60) + $2}' <<< "$time_field")
    ((total_minutes += minutes))
  done < <(awk '{print $NF}' "$temp_user_log" | tr -d ')(')
  
  firstlog=$(tail -n 1 "$temp_user_log" | awk '{print $5,$6}')
  login_count=$(wc -l < "$temp_user_log")
  hours=$(awk "BEGIN {printf \"%.2f\", ${total_minutes}/60}")
  
  printf "%-10s %-10s %-6s %-8s\n" "$user" "$firstlog" "$login_count" "$hours"
done < "$temp_users" | sort -nrk 4 | awk '{ printf("%-4s %s\n", NR, $0) }'

# Clean up temporary files
rm -f "$temp_ulog" "$temp_users" "$temp_user_log"