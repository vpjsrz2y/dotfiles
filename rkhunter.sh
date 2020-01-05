#!/bin/sh
(
/usr/bin/rkhunter --versioncheck
/usr/bin/rkhunter --update
/usr/bin/rkhunter -c -sk
) >> /var/log/messages
