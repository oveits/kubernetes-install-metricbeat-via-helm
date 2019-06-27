

CMD=$1
[ "$CMD" == "" ] && CMD=install

if [ "$CMD" != "install" ] && [ "$CMD" != "template" ] && [ "$CMD" != "delete" ] && [ "$CMD" != "del" ] && [ "$CMD" != "upgrade" ]; then
  echo "usage: bash $0 [install|upgrade|delete|template]"
  exit 1
fi 

source 0_source_config.sh

OPTIONS=" --set daemonset.config.output\.file.enabled=false \
      --set daemonset.config.output\.elasticsearch.enabled=true \
      --set daemonset.config.output\.elasticsearch.hosts[0]=elasticsearch.vocon-it.com:80 \
      --set daemonset.modules.kubernetes.config[0].module=kubernetes \
      --set daemonset.modules.kubernetes.config[0].host=\$\{NODE_NAME\} \
      --set daemonset.modules.kubernetes.config[0].period=${PERIOD} \
      --set daemonset.modules.kubernetes.config[0].hosts[0]=127.0.0.1:10255 \
      --set daemonset.modules.kubernetes.config[0].metricsets[0]=node \
      --set daemonset.modules.kubernetes.config[0].metricsets[1]=system \
      --set daemonset.modules.kubernetes.config[0].metricsets[2]=pod \
      --set daemonset.modules.kubernetes.config[0].metricsets[3]=container \
      --set daemonset.modules.kubernetes.config[0].metricsets[4]=volume \
      --set daemonset.modules.system.config[0].metricsets[0]=cpu \
      --set daemonset.modules.system.config[0].metricsets[1]=load \
      --set daemonset.modules.system.config[0].metricsets[2]=memory \
      --set daemonset.modules.system.config[0].metricsets[3]=network \
      --set daemonset.modules.system.config[0].metricsets[4]=process \
      --set daemonset.modules.system.config[0].metricsets[5]=process_summary \
      --set daemonset.modules.system.config[0].module=system \
      --set daemonset.modules.system.config[0].period=${PERIOD} \
      --set daemonset.modules.system.config[0].process\.include_top_n.by_cpu=5 \
      --set daemonset.modules.system.config[0].process\.include_top_n.by_memory=5 \
      --set daemonset.modules.system.config[0].processes[0]=\.\* \
      --set daemonset.modules.system.config[1].metricsets[1]=filesystem \
      --set daemonset.modules.system.config[1].metricsets[0]=fsstat \
      --set daemonset.modules.system.config[1].module=system \
      --set daemonset.modules.system.config[1].period=${PERIOD} \
      --set deployment.config.output\.file.enabled=false \
      --set deployment.config.output\.elasticsearch.enabled=true \
      --set deployment.config.output\.elasticsearch.hosts[0]=elasticsearch.vocon-it.com:80 \
      --set deployment.modules.kubernetes.enabled=true \
      --set deployment.modules.kubernetes.config[0].module=kubernetes \
      --set deployment.modules.kubernetes.config[0].metricsets[0]=state_node \
      --set deployment.modules.kubernetes.config[0].metricsets[1]=state_deployment \
      --set deployment.modules.kubernetes.config[0].metricsets[2]=state_replicaset \
      --set deployment.modules.kubernetes.config[0].metricsets[3]=state_pod \
      --set deployment.modules.kubernetes.config[0].metricsets[4]=state_container \
      --set deployment.modules.kubernetes.config[0].period=${PERIOD} \
      --set deployment.modules.kubernetes.config[0].hosts=[\"kube-state-metrics:8080\"] \
      --set extraEnv[0].name=ELASTICSEARCH_HOST \
      --set extraEnv[0].value=elasticsearch.vocon-it.com \
      --set extraEnv[1].name=ELASTICSEARCH_PORT \
      --set extraEnv[1].value="\""80"\"" \
      --namespace ${NAMESPACE}"

echo "RELEASE=$RELEASE"
echo "CMD=$CMD"
echo "OPTIONS=$OPTIONS"

case $CMD in
  "delete"|"del")
    helm ls --all ${RELEASE} && helm del --purge ${RELEASE}
    ;;
  "install") 
    helm ls --all ${RELEASE} && helm del --purge ${RELEASE}
    helm install stable/metricbeat --name ${RELEASE} $OPTIONS
    ;;
  "upgrade") 
    helm upgrade --install ${RELEASE} stable/metricbeat $OPTIONS
    ;;
  "template")
    helm $CMD ../charts/stable/metricbeat $OPTIONS
    ;;
  *) echo "no clue - $CMD"; ;;
esac;
