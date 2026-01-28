#!/bin/bash

# Script to lock a user account, archive the home directory,
# and remove the home directory after a successful backup.

user="$1"
BACKUP_DIR="/root/blockedUsers"
LOG_FILE="/var/log/blocked_users.log"

#functions

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

#check if root

if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root"
    exit 1
fi

#argument check

if [ $# -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

#check if user exists

if ! id "$user" &>/dev/null; then
    echo "Error: User $user does not exist"
    log "ERROR: Attempted to lock non-existing user $user"
    exit 1
fi

echo "User: ${user}"
log "Processing user $user"

#lock the user account

if ! passwd -l "$user"; then
    echo "User locking failed"
    log "ERROR: Failed to lock user $user"
    exit 1
fi

echo "User $user locked successfully"
log "User account $user locked"

#create backup directory

mkdir -p "$BACKUP_DIR"

echo "Creating archive of the home folder"

#backup home directory

HOME_DIR="/home/$user"
BACKUP_FILE="$BACKUP_DIR/${user}.backup.tar.gz"

if [ -d "$HOME_DIR" ]; then
    if tar -czf "$BACKUP_FILE" -C /home "$user" 2>/dev/null; then
        echo "Backup created successfully"
        log "Backup created for user $user"

        echo "Removing home directory..."
        rm -rf "$HOME_DIR"
        log "Home directory /home/$user removed"

        echo "User $user has been locked and archived"
        log "User $user successfully locked and archived"
    else
        echo "Backup creation failed"
        log "ERROR: Backup failed for user $user"

        # Roll back: unlock user if backup fails
        passwd -u "$user"
        log "User $user unlocked due to backup failure"
        exit 1
    fi
else
    echo "Home directory does not exist, skipping backup"
    log "WARNING: Home directory for user $user not found"
fi
