#!/bin/sh
set -e
rc_user=ptc
rc_pass=ptc
if [[ "${RC_USER}X" != "X" ]]; then
  rc_user=${RC_USER}
fi
if [[ "${RC_PASSWORD}X" != "X" ]]; then
  rc_pass=${RC_PASSWORD}
fi
rclone rcd --rc-user=$rc_user --rc-pass=$rc_pass --rc-addr :5572 $RCLONE_FLAGS