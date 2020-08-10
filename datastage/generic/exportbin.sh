#!/bin/bash

if [ $# != 2 ] ; then
    echo "usage $0 PATH_TO_BINARY TARGET_FOLDER CONTAINER_ID"
    exit 1
fi

PATH_TO_BINARY="$1"
TARGET_FOLDER="$2" # clients
# CONTAINER_ID="$3"

# if we cannot find the the binary we have to abort
if [ ! -f "$PATH_TO_BINARY" ] ; then
    echo "The file '$PATH_TO_BINARY' was not found. Aborting!"
    exit 1
fi

# need to ensure target folder exists and has correct permissions
if [ ! -d "$TARGET_FOLDER" ] ; then
    mkdir -m 777 "$TARGET_FOLDER"
else
    chmod -R 777 $TARGET_FOLDER
fi

# copy the binary to the target folder
# create directories if required
echo "---> copy binary itself"
cp --parents -v "$PATH_TO_BINARY" "$TARGET_FOLDER"

# need to ensure target folder retains correct permissions
chmod -R 777 $TARGET_FOLDER

# copy the required shared libs to the target folder
# create directories if required
echo "---> copy libraries"
for lib in `ldd "$PATH_TO_BINARY" | cut -d'>' -f2 | awk '{print $1}'` ; do
   chmod -R 777 $TARGET_FOLDER
   if [ -f "$lib" ] ; then
        cp -v --parents "$lib" "$TARGET_FOLDER"
   fi
done

# I'm on a 64bit system at home. the following code will be not required on a 32bit system.
# however, I've not tested that yet
# create lib64 - if required and link the content from lib to it
if [ ! -d "$TARGET_FOLDER/lib64" ] ; then
    mkdir -v "$TARGET_FOLDER/lib64"
fi

# Prompt user into Openshift - using linux read, save to variable.

read -p "Please provide Target Pod Name: " oc_pod # is-en-conductor-0

read -p "Please provide Project/Namespace: " oc_project # zen

echo "---> Confirming correct Openshift Project"
oc project $oc_project

oc exec $oc_pod -- mkdir -v --parents /clients/$TARGET_FOLDER

echo "---> Syncing Target Folder with Pod directory."
oc rsync $TARGET_FOLDER/ $oc_pod:/clients/$TARGET_FOLDER/

echo "---> Syncing new binaries in /usr/bin & /lib64. "
oc exec $oc_pod -- rsync -r --verbose /clients/myfiles/usr/bin/ /usr/bin/

oc exec $oc_pod -- rsync -r --verbose /clients/myfiles/lib64/ /lib64/

echo "Confirming functionality of new binary..."
$($PATH_TO_BINARY)

echo "Script Completed. "