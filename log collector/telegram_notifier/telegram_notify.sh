#!/bin/bash

# Send a Telegram notification when a user logs in via SSH

# Function to retrieve the IP address of the SSH client
get_client_ip() {
  echo "$SSH_CONNECTION" | awk '{print $1}'
}

# Function to get the current timestamp
get_current_timestamp() {
  date +"%Y-%m-%d %H:%M:%S"
}

# Function to get the current hostname
get_hostname() {
  hostname
}

# Function to get the SSH port
get_ssh_port() {
  echo "$SSH_CONNECTION" | awk '{print $3}'
}


# Get the user's operating system
get_os_name() {
uname -a | awk '{print $1 " " $2 " " $3}'
}


# Get the user's current directory
get_pwd(){
PWD=$(pwd)
}

#get user last login
get_last_login(){
last -a $USER | head -n 1 | awk '{print $3, $4, $5, $6}'
}


# Function to send message to Telegram
send_telegram_message() {
  local message=$1
  local token=""
  local chat_id=""
  local url="https://api.telegram.org/bot${token}/sendMessage"

  curl -s -X POST "${url}" -d chat_id="${chat_id}" -d text="${message}" >/dev/null 2>&1 &
}

# Main execution flow of the script
main() {
  local ip=$(get_client_ip)
  local time=$(get_current_timestamp)
  local hostname=$(get_hostname)
  local ssh_port=$(get_ssh_port)
  local os=$(get_os_name)
  local pwd=$(get_pwd)
  local last_login=$(get_last_login "$")
  local message="User $USER logged into $hostname running $os (real IP $ssh_port) from $ip at $time.
   Current Directory: $PWD
   Last Login: $last_login"

  send_telegram_message "$message"
}

# Execute the main function
main

# give session shell
/bin/bash