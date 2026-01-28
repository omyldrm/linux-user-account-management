# linux-user-account-management
A simple bash script to lock a Linux user account, archive the home directory, and remove it safely after backup.
Written as part of self-study in Linux administration and cybersecurity during my first year of Applied Computer Science at KdG Hogeschool.

Features
  - Checks that the script is run as root
  - Verifies if the specified user exists
  - Locks the user account
  - Archives the home directory to /root/blockedUsers
  - Removes the home directory after successful backup
  - Logs all actions to /var/log/blocked_users.log
  - Unlocks the user if the backup fails

Requirements
  - Linux system
  - Bash
  - Root privileges
  - Standard utilities: passwd, tar, id

Usage: ` sudo ./lock_and_archive_user.sh <username> `

Example: ` sudo ./lock_and_archive_user.sh testuser `

Backup & Logs
  - Backups stored at:
    ``` /root/blockedUsers/ ```
  - Logs stored at:
    ``` /var/log/blocked_users.log ```

Warning
  - This script modifies system user accounts and deletes home directories.
  - Use only in test environments or on systems where you have permission.

Learning Goals
  - Bash scripting fundamentals
  - Linux user management
  - Error handling and rollback
  - Logging and auditing
  - Security-aware scripting practices

License
  - MIT License
