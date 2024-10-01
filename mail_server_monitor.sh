#!/bin/bash

# Configuration variables
THRESHOLD_DISK_USAGE=80        # Disk usage threshold (in percentage)
THRESHOLD_MAIL_QUEUE=100        # Maximum allowed mail queue size
MAIL_LOG_DIR="/var/log"         # Directory for mail server logs
MAIL_DATA_DIR="/var/vmail"      # Directory for mail server data (adjusted for iRedMail)
MAIL_QUEUE_DIR="/var/spool/postfix" # Postfix mail queue directory
ADMIN_EMAIL="admin@example.com" # Email to send alerts to
ALERT_LOG="/var/log/mail_server_alert.log"  # Log file for alerts

# Function to check disk usage
check_disk_usage() {
  for dir in $MAIL_LOG_DIR $MAIL_DATA_DIR; do
    usage=$(df -h "$dir" | grep -v Filesystem | awk '{print $5}' | sed 's/%//')
    if [ "$usage" -ge "$THRESHOLD_DISK_USAGE" ]; then
      echo "Disk usage for $dir is at ${usage}% (threshold: $THRESHOLD_DISK_USAGE%)" | tee -a "$ALERT_LOG"
      echo "Disk usage alert for $dir at $usage%" | mail -s "Mail Server Disk Usage Alert" "$ADMIN_EMAIL"
    fi
  done
}

# Function to check mail queue size
check_mail_queue() {
  queue_size=$(find "$MAIL_QUEUE_DIR" -type f | wc -l)
  if [ "$queue_size" -ge "$THRESHOLD_MAIL_QUEUE" ]; then
    echo "Mail queue size is ${queue_size} (threshold: $THRESHOLD_MAIL_QUEUE)" | tee -a "$ALERT_LOG"
    echo "Mail queue alert: $queue_size emails in queue" | mail -s "Mail Server Queue Alert" "$ADMIN_EMAIL"
  fi
}

# Function to check if a service is running
check_service() {
  service_name=$1
  if ! systemctl is-active --quiet "$service_name"; then
    echo "$service_name is not running" | tee -a "$ALERT_LOG"
    echo "$service_name service down" | mail -s "$service_name Service Down Alert" "$ADMIN_EMAIL"
  fi
}

# Monitor services
check_services() {
  check_service "postfix"
  check_service "dovecot"
  check_service "amavis"
  check_service "clamav-daemon"
}

# Main function to run checks
run_checks() {
  echo "Running mail server health checks..."
  check_disk_usage
  check_mail_queue
  check_services
  echo "Health checks completed at $(date)" >> "$ALERT_LOG"
}

# Run the checks
run_checks
