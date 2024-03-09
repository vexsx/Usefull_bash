#!/bin/bash
# Filename: intruder_detect.sh
# Description: Intruder reporting tool with auth.log input

AUTHLOG=/var/log/auth.log

# Use provided log file if specified
if [[ -n $1 ]]; then
  AUTHLOG="$1"
  echo "Using Log file: $AUTHLOG"
fi

# Temporary log file for valid entries
VALID_LOG="/tmp/valid.$$.log"
grep -v "invalid" "$AUTHLOG" > "$VALID_LOG"

# Temporary files for processing
TEMP_LOG="/tmp/temp.$$.log"
TIME_LOG="/tmp/time.$$.log"

# Extract unique users and IP addresses
users=$(grep "Failed password" "$VALID_LOG" | awk '{print $(NF-5)}' | sort -u)
ip_list=$(egrep -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" "$VALID_LOG" | sort -u)

printf "%-5s|%-10s|%-10s|%-15s|%-33s|%s\n" "Sr#" "User" "Attempts" "IP address" "Host_Mapping" "Time range"

ucount=0

for ip in $ip_list; do
  grep "$ip" "$VALID_LOG" > "$TEMP_LOG"
  
  for user in $users; do
    grep "$user" "$TEMP_LOG" > "$TIME_LOG"
    
    if [[ -s $TIME_LOG ]]; then
      tstart=$(head -1 "$TIME_LOG" | cut -c-16)
      tend=$(tail -1 "$TIME_LOG" | cut -c-16)
      start=$(date -d "$tstart" "+%s")
      end=$(date -d "$tend" "+%s")
      limit=$((end - start))
      
      if [ $limit -gt 120 ]; then
        ((ucount++))
        ATTEMPTS=$(wc -l < "$TIME_LOG")
        HOST=$(host "$ip" | awk '/has address/ {print $NF}' || echo "Unknown")
        
        printf "%-5s|%-10s|%-10s|%-15s|%-33s|%s\n" "$ucount" "$user" "$ATTEMPTS" "$ip" "$HOST" "$tstart-->$tend"
      fi
    fi
  done
done

# Clean up
rm -f "$VALID_LOG" "$TEMP_LOG" "$TIME_LOG"