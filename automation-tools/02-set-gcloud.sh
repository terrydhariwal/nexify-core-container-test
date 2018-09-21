gcloud components update
export PROJECT_ID=quorum-360-187413
export COMPUTE_ZONE=europe-west1-b
gcloud config set project ${PROJECT_ID};
gcloud config set compute/zone ${COMPUTE_ZONE};
gcloud beta auth configure-docker --quiet
