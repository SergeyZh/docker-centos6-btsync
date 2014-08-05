#!/bin/sh


NODENAME=`hostname -s`

if [ -z "${STORAGE_SECRET}" ] ; then
    echo "Can't run without environment variable STORAGE_SECRET !"
    TMP_VAL=`/btsync --generate-secret`
    echo "You can use the following generated value: "${TMP_VAL}" ."
    echo "Just add the following parameter to your \"docker run\" command : -e STORAGE_SECRET="${TMP_VAL}
    echo "Exiting..."
    exit 1
fi

if [ ! -z "`grep MY_SECRET_1 btsync.conf`" ] ; then
    echo "Configuring btsync ..."
    echo "Node name: ${NODENAME}"
    sed -i "s/MY_SECRET_1/${STORAGE_SECRET}/" btsync.conf
    sed -i "s/\"device_name\": \"My Sync Device\",/\"device_name\": \"${NODENAME}\",/" btsync.conf
fi

if [ ! -z "${USE_SYNC_TRASH}" ] ; then
    echo "use_sync_trash : ${USE_SYNC_TRASH}"
    sed -i "s/use_sync_trash : .*/use_sync_trash : ${USE_SYNC_TRASH},/" btsync.conf
fi

if [ ! -z "${USE_SYNC_TRASH}" ] ; then
    echo "use_sync_trash : ${USE_SYNC_TRASH}"
    sed -i "s/\"use_sync_trash\" : .*/\"use_sync_trash\" : ${USE_SYNC_TRASH},/" btsync.conf
fi

if [ ! -z "${USE_DHT}" ] ; then
    echo "use_dht : ${USE_DHT}"
    sed -i "s/\"use_dht\" : .*/\"use_dht\" : ${USE_DHT},/" btsync.conf
fi

shutdown_btsync()
{
    echo "Stopping container..."
    killall btsync
    while [ ! -z "`ps x | grep -v grep | grep btsync`" ] ; do echo -n "." ; sleep 1 ; done
    exit 0
}

trap shutdown_btsync SIGINT SIGTERM SIGHUP


if [ ! -z "${BTSYNC_USERID}" ] ; then
    BTSYNC_USER=`getent passwd ${BTSYNC_USERID} | awk -F: '{ print $1 }'`
    if [ -z "${BTSYNC_USER}" ] ; then
	/usr/sbin/useradd -u ${BTSYNC_USERID} btsync-user
	BTSYNC_USER=btsync-user
    fi
    chown -R ${BTSYNC_USER} /mnt/storage /.sync
fi

su ${BTSYNC_USER} -c "/btsync --config /btsync.conf --nodaemon" &

wait
