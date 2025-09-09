#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

# Check if username and email are provided
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 username email"
  exit 1
fi

# Assign arguments to variables
USERNAME="$1"
EMAIL="$2"

# Check if user already exists
if id "$USERNAME" &>/dev/null; then
  echo "User '$USERNAME' already exists"
  exit 1
fi

# Generate a random password
PASSWORD=$(openssl rand -base64 12)

# Create the user and set the password
useradd "$USERNAME"
echo "$USERNAME:$PASSWORD" | chpasswd

# Immediately expire the password to force a password change on first login
chage -d 0 "$USERNAME"

# Output username and password
echo "Username: $USERNAME"
echo "Generated Password: $PASSWORD"
echo "User '$USERNAME' created successfully with the generated password."

# Compose the email message
SUBJECT="New User Account Created"
MESSAGE="Hello,\n\nA new user account has been created for you on the system.\n\nUsername: $USERNAME\nPassword: $PASSWORD\n\nPlease change your password upon first login."

# Send the email with the user's details
echo -e "$MESSAGE" | mail -s "$SUBJECT" "$EMAIL"

# Check if email was sent successfully
if [ $? -eq 0 ]; then
  echo "Email sent to $EMAIL with the username and password."
else
  echo "Failed to send email."
fi
