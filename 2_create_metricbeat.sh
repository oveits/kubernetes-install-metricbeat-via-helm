

CMD=$1
[ "$CMD" == "" ] && CMD=upgrade

if [ "$CMD" != "install" ] && [ "$CMD" != "template" ] && [ "$CMD" != "delete" ] && [ "$CMD" != "del" ] && [ "$CMD" != "upgrade" ]; then
  echo "usage: bash $0 [install|upgrade|delete|template]"
  exit 1
fi 

source 0_source_config.sh

echo "RELEASE=$RELEASE"
echo "CMD=$CMD"

# create values.yaml from template:
[ -f "values.yaml.tmpl" ] \
  && source 0_source_config.sh \
  && envsubst < values.yaml.tmpl > values.yaml

[ ! -f values.yaml ] && echo "values.yaml missing! Exiting..." && exit 1

case $CMD in
  "delete"|"del")
    helm ls --all ${RELEASE} && helm del --purge ${RELEASE}
    ;;
  "install") 
    # purge old versions:
    helm ls --all ${RELEASE} && helm del --purge ${RELEASE}

    # install release using values.yaml:
    helm install stable/metricbeat --name ${RELEASE} --namespace ${NAMESPACE} --values ./values.yaml
    ;;
  "upgrade") 
    helm upgrade --install --force ${RELEASE} stable/metricbeat --namespace ${NAMESPACE} --values ./values.yaml
    ;;
  "template")
    helm $CMD ../charts/stable/metricbeat --namespace ${NAMESPACE} --values ./values.yaml
    ;;
  *) echo "no clue - $CMD"; ;;
esac;
