#!/bin/bash

source mc-settings.sh

mc_running() {
  rconc $RCONC_NAME list >/dev/null 2>&1
  return $?
}

mc_exec() {
  if mc_running; then
    echo "$INSTANCE_NAME: $*"
    rconc $INSTANCE_NAME "$*"
  fi
}

mc_saveoff() {
  if mc_running; then
    mc_exec "say §9§lSERVER BACKUP STARTING!"
    mc_exec "say §9Pausing world saves"
    mc_exec "save-off"
    mc_exec "save-all"
    sync
  fi
}

mc_saveon() {
  if mc_running; then
    mc_exec "save-on"
    mc_exec "say §9Resuming world saves"
  fi
}

mc_backup() {
  [ -d "$BACKUP_PATH/$INSTANCE_WORLD" ] || mkdir -p "$BACKUP_PATH/$INSTANCE_WORLD"
  rsync -a $INSTANCE_PATH/$INSTANCE_WORLD $BACKUP_PATH/$INSTANCE_WORLD
}

mc_compressbackup() {
  archive_name="${INSTANCE_WORLD}_$(date +"$BACKUP_TIMESTAMP").tar.lzop"
  tar --lzop -cf $BACKUP_PATH/$archive_name $BACKUP_PATH/$INSTANCE_WORLD/
  mc_exec "say §9§lWORLD BACKUP FINISHED!"
  mc_exec "say §8§oFinished backup + compression in $(expr $(date +%s) - $1) seconds"
  mc_exec "say §8§oCompressed $(expr $(du -bs $BACKUP_PATH/$INSTANCE_WORLD | awk '{print $1}') / 1024 / 1024)MB to $(expr $(stat --printf "%s" $BACKUP_PATH/$archive_name) / 1024 / 1024)MB"
}

mc_cleanbackups() {
  backups=$(ls -1 $BACKUP_PATH | grep $INSTANCE_WORLD | wc -l)
  if [[ $backups -gt $BACKUP_KEEP ]]; then
    echo "Purging old backups..."
    files=$(ls -1t $BACKUP_PATH | tail -n $(expr $backups - $BACKUP_KEEP))
    for f in $files; do
      echo "Removing $f!"
      rm $BACKUP_PATH/$f
    done
  fi
}

mc_clearitems() {
  mc_exec "say §6Killing items on the ground in 15 seconds..."
  sleep 10
  mc_exec "say §65 seconds..."
  sleep 5
  mc_exec "kill @e[type=minecraft:item]"
  mc_exec "say §6Deleted items!"
}

case "$1" in
backup)
  backup_start=$(date +%s)
  mc_saveoff
  mc_backup
  mc_saveon
  mc_compressbackup $backup_start
  mc_cleanbackups
  ;;
cleanup)
  mc_cleanbackups
  ;;
exec)
  shift
  mc_exec "$@"
  ;;
say)
  shift
  mc_exec "say $@"
  ;;
clearitems)
  mc_clearitems
  ;;
status)
  if mc_running; then
    echo "$INSTANCE_NAME is running."
  else
    echo "$INSTANCE_NAME is not running."
  fi
  ;;

*)
  echo "Usage: $(readlink -f $0) {backup|exec|say|status|clearitems}"
  exit 1
  ;;
esac

exit 0
