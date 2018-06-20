#!/bin/bash

############
# please set variable PROJECT_ID in advance.
############

gcloud beta compute --project=${PROJECT_ID} addresses create stellar-horizon-static-ip --global --network-tier=PREMIUM
