

CMD=$1
[ "$CMD" == "" ] && CMD=install

if [ "$CMD" != "install" ] && [ "$CMD" != "template" ] && [ "$CMD" != "delete" ] && [ "$CMD" != "del" ]; then
  echo "usage: bash $0 [install|template]"
  exit 1
fi 

source 0_source_config.sh


OPTIONS="--name ${RELEASE} \
      --set daemonset.config.output\.file.enabled=false \
      --set daemonset.config.output\.elasticsearch.enabled=true \
      --set daemonset.config.output\.elasticsearch.hosts[0]=elasticsearch.vocon-it.com:80 \
      --set daemonset.modules.kubernetes.config[0].module=kubernetes \
      --set daemonset.modules.kubernetes.config[0].host=\$\{NODE_NAME\} \
      --set daemonset.modules.kubernetes.config[0].period=10s \
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
      --set daemonset.modules.system.config[0].period=10s \
      --set daemonset.modules.system.config[0].process\.include_top_n.by_cpu=5 \
      --set daemonset.modules.system.config[0].process\.include_top_n.by_memory=5 \
      --set daemonset.modules.system.config[0].processes[0]=\.\* \
      --set daemonset.modules.system.config[1].metricsets[1]=filesystem \
      --set daemonset.modules.system.config[1].metricsets[0]=fsstat \
      --set daemonset.modules.system.config[1].module=system \
      --set daemonset.modules.system.config[1].period=5s \
      --set deployment.config.output\.file.enabled=false \
      --set deployment.config.output\.elasticsearch.enabled=true \
      --set deployment.config.output\.elasticsearch.hosts[0]=elasticsearch.vocon-it.com:80 \
      --set extraEnv[0].name=ELASTICSEARCH_HOST \
      --set extraEnv[0].value=elasticsearch.vocon-it.com \
      --set extraEnv[1].name=ELASTICSEARCH_PORT \
      --set extraEnv[1].value="\""80"\"" \
      --namespace ${NAMESPACE}"

#      --set daemonset.modules.system.config[0].metricsets

echo "RELEASE=$RELEASE"
echo "CMD=$CMD"
echo "OPTIONS=$OPTIONS"
#exit

      #--set daemonset.config.metricbeat.config.output.elasticsearch.hosts[0]=myelasticsearch:9200
      #--set daemonset.config.output.elasticsearch.hosts[0]=myelasticsearch:9200
      #--set cluster.env.EXPECTED_MASTER_NODES=${MIN_REPLICAS} \

#[ "$STORAGE_CLASS" != "" ] && OPTIONS="$OPTIONS \
#      --set data.persistence.storageClass=${STORAGE_CLASS}"

case $CMD in
  "delete"|"del")
    helm ls --all ${RELEASE} && helm del --purge ${RELEASE}
    bash 4_create_pvc_master.sh -d
    bash 3_create_pvc_data.sh -d
    ;;
  "install") 
    helm ls --all ${RELEASE} && helm del --purge ${RELEASE}
    #bash 4_create_pvc_master.sh -d
    #bash 3_create_pvc_data.sh -d
    helm $CMD stable/metricbeat $OPTIONS
    ;;
  "template")
    helm $CMD ../charts/stable/metricbeat $OPTIONS
    ;;
  *) echo "no clue - $CMD"; ;;
esac;
