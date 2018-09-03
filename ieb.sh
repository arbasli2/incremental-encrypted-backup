#!/bin/sh
# creates an incremental backup on an encrpyted directory. uses rsync and ecryptfs
# rsync options: --stats --progress  instead -v
#TODO make the following automatic:
## run in command line for the first time ln -s /media/usr1/path/to/backup/2013-08-31 /media/usr1/path/to/backup/current
#TODO move the file list to another file


sudo mount -t ecryptfs  /media/usr1/path/to/backup /media/usr1/path/to/backup  -o ecryptfs_cipher=aes,ecryptfs_key_bytes=16,ecryptfs_passthrough=no,ecryptfs_enable_filename_crypto=yes

if [ $? -eq 0 ]; then
    echo mounted
else
    echo
    echo  failed to mount, quitting.
    echo 
    exit 1
fi

cd
timeStamp=`date +%F-%H:%M`
rsync -a -h -E --delete -v --exclude=".svn" --exclude=".sync" --exclude=".zim" --exclude=".git" --relative --link-dest=/media/usr1/path/to/backup/current    \
Desktop  \
Documents  \
Music  \
Videos \
Pictures  \
Projects  \
.bash_history  \
.bashrc  \
.vimrc  \
/media/usr1/path/to/backup/$timeStamp

if [ $? -eq 0 ]; then
    echo rsync OK
    rm -f /media/usr1/path/to/backup/current
    ln -s /media/usr1/path/to/backup/$timeStamp     /media/usr1/path/to/backup/current
else
    echo
    echo  rsync FAIL
    echo  symlink \"current\"  link to the last successful backup
    echo 
fi

sudo umount /media/usr1/path/to/backup
