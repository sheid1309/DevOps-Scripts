#!/bin/bash

#Turn off swap
swapoff -a

#Disable SELinux
setenforce 0
sed -i 's/enforcing/disabled/g' /etc/selinux/config
grep disabled /etc/selinux/config | grep -v '#'

#Disable firewalld
systemctl stop firewalld && systemctl disable firewalld

#sysctl
cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sysctl --system >/dev/null 2>&1

#Install kubelet kubeadm kubectl
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

yum install -y -q kubeadm kubelet kubectl

#Start kubelet
systemctl enable kubelet
systemctl start kubelet

#Config NetworkManager before using Calico
cat >>/etc/NetworkManager/conf.d/calico.conf<<EOF
[keyfile]
unmanaged-devices=interface-name:cali*;interface-name:tunl*
EOF

