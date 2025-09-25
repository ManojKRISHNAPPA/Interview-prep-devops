#!/bin/bash

# Update and install msmtp
sudo apt-get update
sudo apt-get install -y msmtp msmtp-mta ca-certificates
sudo apt-get install -y bsd-mailx
# Create the msmtp configuration directory
mkdir -p ~/.msmtp
chmod 777 ~/.msmtp

# Create the msmtp configuration file
cat <<EOF > ~/.msmtprc
# Set default values for all accounts.
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp/msmtp.log

# Gmail account
account        gmail
host           smtp.gmail.com
port           587
from           manojdevopstest@gmail.com
user           manojdevopstest@gmail.com
password       

# Set a default account
account default : gmail
EOF

# Set the correct permissions for the msmtp configuration file
chmod 600 ~/.msmtprc

# Create a log file for
touch ~/.msmtp/msmtp.log
chmod 777 ~/.msmtp/msmtp.log

echo "msmtp configuration completed. You can now send emails using the configured Gmail account."
