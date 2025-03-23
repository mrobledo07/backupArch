#!/bin/bash

SYSTEM_BACKUP_DIR="/mnt/systemBackup"
HOME_BACKUP_DIR="/mnt/homeBackup"
RCLONE_REMOTE_SYSTEM=”google_drive:/backupArch/systemBackup”
RCLONE_REMOTE_HOME=”google_drive:/backupArch/homeBackup”

mkdir -p "$SYSTEM_BACKUP_DIR/etc/"
mkdir -p "$SYSTEM_BACKUP_DIR/root/"
mkdir -p "$SYSTEM_BACKUP_DIR/boot/"

mkdir -p "$HOME_BACKUP_DIR/miguelrk/"


rsync -aAXv --delete -P /etc/ "$SYSTEM_BACKUP_DIR/etc/"
rsync -aAXv --delete -P /root/ "$SYSTEM_BACKUP_DIR/root/"
rsync -aAXv --delete -P /boot/ "$SYSTEM_BACKUP_DIR/boot/"

rsync -aAXv --delete -P --exclude=".cache" --exclude="Android" --exclude=".gradle/caches" --exclude=".vscode" --exclude=".config/Code" /home/miguelrk/ "$HOME_BACKUP_DIR/miguelrk/"

pacman -Qqe > "$HOME_BACKUP_DIR/pacman_packages.txt"
yay -Qqe > "$HOME_BACKUP_DIR/yay_packages.txt"

rclone sync "$SYSTEM_BACKUP_DIR" "$RCLONE_REMOTE_SYSTEM" --config="/home/miguelrk/.config/rclone/rclone.conf"
rclone sync "$HOME_BACKUP_DIR" "$RCLONE_REMOTE_HOME" --config="/home/miguelrk/.config/rclone/rclone.conf"
