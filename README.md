# Sample Kubernetes Escape via [CVE-2017-1002101](https://nvd.nist.gov/vuln/detail/CVE-2017-1002101)

## Description

After hearing about the issue and following [this guide](https://www.twistlock.com/2018/03/21/deep-dive-severe-kubernetes-vulnerability-date-cve-2017-1002101/), I wanted to explore things a bit more.  This repo contains a couple pod deployments and helper shell scripts that demonstrate the attack mechanism in the simplest way possible so that Kubernetes administrators and operators can fully understand the severity and potential risks.  You must be an authenticated user or able to control a pod's spec/template at creation, so this escape is not likely going to be anonymous unless combined with other attacks like [this](https://medium.com/handy-tech/analysis-of-a-kubernetes-hack-backdooring-through-kubelet-823be5c3d67c).

## Quick Explanation

When the Kubelet goes to mount a volume/secret/configmap, etc, it incorrectly follows symlinks inside the volume to locations outside the scope of where it should.  Because the Kubelet is running as root, this means it can be tricked into mounting privileged parts of the host filesystem inside a non-privileged pod's container.

My approach was to use a single pod with two "normal" containers.  One container creates the symlink to `/` or `/home/ubuntu` and the other crashloops until that succeeds (forcing the volume to be remounted and following that symlink path), allowing the user to exec into the second container and access the mount point.

## Quick Run

Note: These examples work without modification against an Ubuntu 16.04 host, but they can be easily tweaked for other setups.

1. Examine the files in the repo before running anything.
2. Run `./run-as-root.sh` if your cluster is fairly "stock".
3. Run `./run-as-root-no-chroot.sh` or `./run-as-user-1000.sh` for other variations.

[![asciicast](https://asciinema.org/a/alFqdDOlyud1NJUCPABpgOf0v.png)](https://asciinema.org/a/alFqdDOlyud1NJUCPABpgOf0v)

## Mitigation Strategy

It's really a "must-patch" situation.  Unfortunately, the workarounds listed [here](https://github.com/kubernetes/kubernetes/issues/60813) aren't terribly practical for most folks.  Nearly all prior versions are vulnerable.

## References
- [https://github.com/kubernetes/kubernetes/issues/60813](https://github.com/kubernetes/kubernetes/issues/60813)
- [https://nvd.nist.gov/vuln/detail/CVE-2017-1002101](https://nvd.nist.gov/vuln/detail/CVE-2017-1002101)
- [https://www.twistlock.com/2018/03/21/deep-dive-severe-kubernetes-vulnerability-date-cve-2017-1002101/](https://www.twistlock.com/2018/03/21/deep-dive-severe-kubernetes-vulnerability-date-cve-2017-1002101/)
