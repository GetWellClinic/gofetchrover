#!/bin/bash

echo "Container started. Starting Mule"

cp $MULE_HOME/bin/muled $MULE_HOME/bin/muled.bak
eval "sed 's:MULE_HOME_REPLACE:$MULE_HOME:' $MULE_HOME/bin/muled > ./muled"
eval "sed 's:JAVA_HOME_REPLACE:$JAVA_HOME:' ./muled > /etc/init.d/muled"
rm ./muled

chown root:root /etc/init.d/muled
chmod 755 /etc/init.d/muled

update-rc.d muled defaults

> "$MULE_HOME/logs/mule.log"

mule start

# Keep container running with tail mule log
tail -f $MULE_HOME/logs/mule.log
