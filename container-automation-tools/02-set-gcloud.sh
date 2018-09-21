#!/bin/sh

gcloud components update
gcloud config set project ${PROJECT_ID};
gcloud config set compute/zone ${COMPUTE_ZONE};
gcloud beta auth configure-docker --quiet
