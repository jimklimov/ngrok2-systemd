#!/bin/sh

# Chrooting wrapper for the ngrok binary. For details see
#   https://github.com/jimklimov/ngrok2-systemd.git
# Usually call with "$0 start --all" or "$0 start ssh_tunnel" etc.
# Can also do "$0 --help" etc. of course :)
DIRNAME="`dirname $0`"
DIRNAME="`cd "$DIRNAME" && pwd`"

exec /usr/sbin/chroot "$DIRNAME" /bin/ngrok "$@"
