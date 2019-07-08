[ "$RELEASE" == "" ]             && export RELEASE=metricbeat
[ "$NAMESPACE" == "" ]           && export NAMESPACE=metricbeat
[ "$PERIOD" == "" ]              && export PERIOD=1m
[ "$PERIOD_LONG" == "" ]         && export PERIOD_LONG=10m
[ "$ELASTIC_SEARCH_HOST" == "" ] && export ELASTIC_SEARCH_HOST=elasticsearch.vocon-it.com
[ "$ELASTIC_SEARCH_PORT" == "" ] && export ELASTIC_SEARCH_PORT=80
export NODE_NAME='${NODE_NAME}'
