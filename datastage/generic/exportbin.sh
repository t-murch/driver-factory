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

# read -p "Please enter Openshift Login Name: " oc_username #

# read -p "Please enter Openshift Password: " -r -s oc_password # $(oc whoami -t)

# read -p "Please provide Openshift URL: " oc_url # oc version |grep -Eo 'https://[^ >]+'|head -1

# read -p "Please provide Target Pod Name: " oc_pod # is-en-conductor-0

# read -p "Please provide Project/Namespace: " oc_project # zen

# oc login -u $(oc whoami) -p $(oc whoami -t) $(oc version |grep -Eo 'https://[^ >]+'|head -1) -n mcm-squad

oc exec test4 -- mkdir -v --parents /clients/$TARGET_FOLDER

oc rsync $TARGET_FOLDER test4:/clients/$TARGET_FOLDER

# read -p "Ensuring transfer and directory creation is complete..." -t 5

oc exec test4 -- $(/usr/bin/cp -r -v /clients/myfiles/usr/bin/* /usr/bin/)

# oc exec test4 -- cp -v /clients/myfiles/lib64/ /lib64/

oc exec test4 -- rsync -v /clients/myfiles/lib64/* /lib64/

# oc exec test4 -- /usr/bin/grep -rn --color "export PATH" ~/. 2> /dev/null

# oc exec test4 -n mcm-squad -- source $(/usr/bin/grep -rn --color "export PATH" ~/. 2> /dev/null)

# oc exec test4 -- ssh