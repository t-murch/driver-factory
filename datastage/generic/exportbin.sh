#!/bin/bash

# if [ $# != 3 ] ; then
#     echo "usage $0 PATH_TO_BINARY TARGET_FOLDER CONTAINER_ID"
#     exit 1
# fi

# PATH_TO_BINARY="$1"
# TARGET_FOLDER="$2" 
# CONTAINER_ID="$3"

# # if we cannot find the the binary we have to abort
# if [ ! -f "$PATH_TO_BINARY" ] ; then
#     echo "The file '$PATH_TO_BINARY' was not found. Aborting!"
#     exit 1
# fi

# # copy the binary to the target folder
# # create directories if required
# echo "---> copy binary itself"
# cp --parents -v "$PATH_TO_BINARY" "$TARGET_FOLDER"

# # copy the required shared libs to the target folder
# # create directories if required
# echo "---> copy libraries"
# for lib in `ldd "$PATH_TO_BINARY" | cut -d'>' -f2 | awk '{print $1}'` ; do
#    if [ -f "$lib" ] ; then
#         cp -v --parents "$lib" "$TARGET_FOLDER"
#    fi  
# done

# # I'm on a 64bit system at home. the following code will be not required on a 32bit system.
# # however, I've not tested that yet
# # create lib64 - if required and link the content from lib to it
# if [ ! -d "$TARGET_FOLDER/lib64" ] ; then
#     mkdir -v "$TARGET_FOLDER/lib64"
# fi

# Prompt user into Openshift - using linux read, save to variable. 

read -p "Please enter Openshift Login Name: " oc_username

read -p "Please enter Openshift Password: " -r -s oc_password

read -p "Please provide Openshift URL: " oc_url

read -p "Please provide Target Pod Name: " oc_pod

read -p "Please provide Project/Namespace: " oc_project

oc login -u $oc_username -p $oc_password $oc_url -n $oc_project

oc rsync "./${TARGET_FOLDER}" $oc_pod:/data/$TARGET_FOLDER
