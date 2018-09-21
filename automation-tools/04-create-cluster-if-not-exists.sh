export cluster_names=`gcloud container clusters list --zone=${COMPUTE_ZONE} --format=json | jq -r ".[].name"`
#echo "cluster_names = $cluster_names"

# Create cluster
if [[ $cluster_names = *"$CLUSTER_NAME"* ]]; then
   echo "Cluster $CLUSTER_NAME already exists!"
else
  gcloud beta container --project ${PROJECT_ID} clusters create "${CLUSTER_NAME}" --zone "${COMPUTE_ZONE}" --username "admin" --cluster-version "1.9.7-gke.6" --machine-type ${machine_type} --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/compute","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "1" --enable-cloud-logging --enable-cloud-monitoring --network "projects/quorum-360-187413/global/networks/hortonworks-network" --addons HorizontalPodAutoscaling,HttpLoadBalancing,KubernetesDashboard --no-enable-autoupgrade --enable-autorepair
fi
