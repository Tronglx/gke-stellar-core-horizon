#!/bin/bash
############
# please set variable PROJECT_ID and ZONE in advance.
############

gcloud compute --project=${PROJECT_ID} disks create stellar-core-disk --zone=${ZONE} --type=pd-ssd --size=200GB
