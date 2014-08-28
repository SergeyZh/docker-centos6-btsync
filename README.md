docker-centos6-btsync
=====================

#

### Environment variables
* `BTSYNC_USERID` Unix id of user to run btsync
* `STORAGE_SECRET` UID of share of btsync
* `USE_SYNC_TRASH` - `true` or `false` enable or disable SyncArchive to store files deleted on remote devices. Default `true`
* `USE_DHT` - `true` or `false` enable or disable DHT. Default `false`

You may set environment variable BTSYNC_USERID to run btsync under other Unix account.
If you want to add your data - place it under `/mnt/storage/` folder. To add
multiple folders you could add it as volumes: `-v /your/data/folder1:/mnt/storage/folder1 -v
/your/data/folder2:/mnt/storage/folder2`.
