# gke-stellar-core-horizon

Home of the GKE stellar core horizon

This project is created by the insight of ["Stellar Quickstart Docker Image"](https://github.com/stellar/docker-stellar-core-horizon) project.
This project provides a method to create "stellar-core" and "stellar-horizon" service on the Google Kubernetes Engine.


## Hardware Requirements

According to the [article](https://www.stellar.org/developers/guides/hardware.html), we can see the minimum and recommended hardware requirements.

### Stellar-Core

#### Recommended

CPU: 8-Core (16-Thread) Intel i7/Xeon or equivalent (c5.2xlarge on AWS)
RAM: 16GB DDR4
SSD: 120GB

### Horizon

#### Recommended

CPU: 16-Core (32-Thread) Intel i7/Xeon or equivalent (c5.4xlarge on AWS)
RAM: 32GB DDR4
SSD: 120GB

## How to Setup

- create GCP project first.
- you need to create CloudSQL postgres database
  - create `core` database
  - create `horizon` database
  - create `stellar` user with password
  - enable API access to those database
  - create Service Account which you have to give `CloudSQL Client` role
- you need to create `Kubernetes Engine Cluster`
  - you have to install `kubectl` to manuplate k8s engine

### Tips

- install `gcloud` command and authorize it to access to your GCP project.
- install `kubectl` command and authorize it to access to your k8s engine cluster.

## How to Build

### Stellar-Core

```bash
$ cd src/core
$ PROJECT_ID=YOUR_GCP_PROJECT_ID
$ APP_NAME=stellar-core
$ tag=v1.0.0
$ docker build -t gcr.io/${PROJECT_ID}/${APP_NAME}:${tag} -f Dockerfile .
$ gcloud --project=${PROJECT_ID} docker -- push gcr.io/${PROJECT_ID}/${APP_NAME}:${tag}
```

### Horizon

```bash
$ cd src/horizon
$ PROJECT_ID=YOUR_GCP_PROJECT_ID
$ APP_NAME=stellar-horizon
$ tag=v1.0.0
$ docker build -t gcr.io/${PROJECT_ID}/${APP_NAME}:${tag} -f Dockerfile .
$ gcloud --project=${PROJECT_ID} docker -- push gcr.io/${PROJECT_ID}/${APP_NAME}:${tag}
```

## How to Deploy

#### Secrets

```bash
$ cd k8s/pubnet/secrets
$ kubectl create -f cloudsql-instance-credentials.yaml
$ kubectl create -f stellar-core-db.yaml
$ kubectl create -f stellar-horizon-db.yaml
```

### Disks

```bash
$ cd k8s/pubnet/core
$ ./create-stellar-core-disk.sh
```

### Global IP Address

```bash
$ cd k8s/pubnet/ingress
$ ./create-global-ipaddress.sh
```

### Stellar-Core

```bash
$ cd src/core
$ PROJECT_ID=YOUR_GCP_PROJECT_ID
$ APP_NAME=stellar-core
$ tag=v1.0.0
deployment_exists=`kubectl get deployment | awk '{print $1}' | grep -c "stellar-core"` && :
if [ $deployment_exists -gt 0 ] ; then
    kubectl set image deployment/stellar-core stellar-core=gcr.io/${PROJECT_ID}/${APP_NAME}:${tag}
else
    kubectl apply -f ../../k8s/${NETWORK_TYPE}/core/deployment.yaml
fi
```

### Horizon

```bash
$ cd src/horizon
$ PROJECT_ID=YOUR_GCP_PROJECT_ID
$ APP_NAME=stellar-horizon
$ tag=v1.0.0
deployment_exists=`kubectl get deployment | awk '{print $1}' | grep -c "stellar-horizon"` && :
if [ $deployment_exists -gt 0 ] ; then
    kubectl set image deployment/stellar-horizon stellar-horizon=gcr.io/${PROJECT_ID}/${APP_NAME}:${tag}
else
    kubectl apply -f ../../k8s/${NETWORK_TYPE}/horizon/deployment.yaml
fi
```

