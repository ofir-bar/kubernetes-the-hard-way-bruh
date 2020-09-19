#!/usr/bin/env bash

for instance in worker-0--async worker-1--async worker-2--async; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

EXTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')

INTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].networkIP)')

cfssl gencert \
  -ca=/Users/ofirbar/Desktop/kubernetes-hard-way/ca_files/ca.pem \
  -ca-key=/Users/ofirbar/Desktop/kubernetes-hard-way/ca_files/ca-key.pem \
  -config=/Users/ofirbar/Desktop/kubernetes-hard-way/ca_configuration_files/ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}

done
