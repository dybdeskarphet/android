#!/bin/sh
set -eu

PUBKEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPMPqQN4OnvtNa3sArn0qbaD6tZPK9GFvfKPaoic1xVO ahmetardakavakci@gmail.com"

AUTH_FILE="$HOME/.ssh/authorized_keys"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$AUTH_FILE"
chmod 600 "$AUTH_FILE"

if ! grep -Fqx "$PUBKEY" "$AUTH_FILE"; then
  printf "%s\n" "$PUBKEY" >>"$AUTH_FILE"
fi
