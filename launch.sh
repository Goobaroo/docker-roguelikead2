#!/bin/bash

set -x

if [ -w "/data" ]; then

FORGE_VERSION=1.16.5-36.2.39
cd /data

if ! [[ "$EULA" = "false" ]]; then
  echo "eula=true" > eula.txt
else
  echo "You must accept the EULA to install."
exit 99
fi

if ! [[ -f "RAD2-Serverpack-1.10a.zip" ]]; then
  curl -Lo 'RAD2-Serverpack-1.10a.zip' 'https://edge.forgecdn.net/files/5186/687/RAD2-Serverpack-1.10a.zip' && unzip -u -o 'RAD2-Serverpack-1.10a.zip' -d /data
  DIR_TEST=$(find . -type d -maxdepth 1 | tail -1 | sed 's/^.\{2\}//g')
  if [[ $(find . -type d -maxdepth 1 | wc -l) -gt 1 ]]; then
    cd "${DIR_TEST}"
    mv -f * /data
    cd /data
    rm -fr "$DIR_TEST"
  fi
  # This pack ships a EULA, if we said yes above, then this is fine.
  echo "eula=true" > eula.txt
  # curl -Lo forge-${FORGE_VERSION}-installer.jar 'https://maven.minecraftforge.net/net/minecraftforge/forge/'${FORGE_VERSION}'/forge-'${FORGE_VERSION}'-installer.jar'
  # java -jar forge-${FORGE_VERSION}-installer.jar --installServer && rm -f forge-${FORGE_VERSION}-installer.jar
fi

if [[ -n "$MOTD" ]]; then
  sed -i "s/motd\s*=/ c motd=$MOTD" /data/server.properties
fi
if [[ -n "$OPS" ]]; then
  echo $OPS | awk -v RS=, '{print}' > ops.txt
fi

sed -i 's/server-port.*/server-port=25565/g' server.properties

java -server ${JVM_OPTS} -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode -XX:-UseAdaptiveSizePolicy -Xmn128M ${JAVA_PARAMETERS} -jar forge-${FORGE_VERSION}.jar nogui

else
  echo "Directory is not writable, check permissions in /mnt/user/appdata/roguelikead2"
  exit 66
fi