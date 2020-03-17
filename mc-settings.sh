#!/bin/bash

# settings
INSTANCE_NAME="mcz15"
INSTANCE_PATH="/srv/mc/1.15"
INSTANCE_JAR="forge-1.15.2-31.1.19.jar"
INSTANCE_WORLD="world"

RCONC_NAME="mcz15"

BACKUP_DIR="backup"
BACKUP_TIMESTAMP="%Y%m%d-%H%M%S"
BACKUP_PATH="$INSTANCE_PATH/$BACKUP_DIR"
BACKUP_KEEP=10

JAVA="java"
MEMORY_OPTS="-Xmx12G -Xms12G"
CPU_COUNT=2
JAVA_OPTS="$MEMORY_OPTS -XX:+UseG1GC -Dsun.rmi.dgc.server.gcInterval=2147483646 -XX:+UnlockExperimentalVMOptions \
            -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M\
            -XX:ParallelGCThreads=$CPU_COUNT -XX:+AggressiveOpts"

INVOCATION="$JAVA $JAVA_OPTS -jar $INSTANCE_JAR nogui"
