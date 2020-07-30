**These steps add sftp client to datastage**

1. Backup your configuration: oc get statefulset is-en-conductor -o yaml > is-en-conductor.yaml.backup

2. Add PVC for clients: oc apply -f client-pvc.yaml

2. Patch Conductor StatefulSet: kubectl patch statefulset is-en-conductor --patch "$(cat ds-patch.yaml)"


This adds a PVC, a sidecar which adds files to the PVC, and modifies DataStage slightly to use the PVC for binaries 
