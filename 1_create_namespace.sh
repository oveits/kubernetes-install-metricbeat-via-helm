
source 0_source_config.sh

kubectl get namespace ${NAMESPACE} \
  || kubectl create namespace ${NAMESPACE}
