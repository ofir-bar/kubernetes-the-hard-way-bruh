#!/usr/bin/env bash

#Note: Make sure you pass the kubernetes public ip as variable $1, and CA file path as $2

echo "public kubernetes address: $1"

kubectl config set-cluster kubernetes-hard-ofir --certificate-authority=$2 \
	--embed-certs=true \
	--server=https://${1}:6443 \
	--kubeconfig=kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
       	--client-certificate=kube-proxy.pem \
	--client-key=kube-proxy-key.pem \
	--embed-certs=true \
	--kubeconfig=kube-proxy.kubeconfig

kubectl config set-context default \
	--cluster=kubernetes-hard-ofir \
	--user=system:kube-proxy \
	--kubeconfig=kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
