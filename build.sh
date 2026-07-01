#!/bin/bash

set -e

JAVA_XMS="${JAVA_XMS:-256m}"
JAVA_XMX="${JAVA_XMX:-2560m}"
JAVA_MAX_METASPACE="${JAVA_MAX_METASPACE:-384m}"
WEBAPP_CONTEXT_PATH="${WEBAPP_CONTEXT_PATH:-/}"

case "${WEBAPP_CONTEXT_PATH}" in
  "") WEBAPP_CONTEXT_PATH="/" ;;
  /*) ;;
  *) WEBAPP_CONTEXT_PATH="/${WEBAPP_CONTEXT_PATH}" ;;
esac

case "${WEBAPP_CONTEXT_PATH}" in
  "/") KILN_MOUNT_PATH="" ;;
  */) KILN_MOUNT_PATH="${WEBAPP_CONTEXT_PATH%/}" ;;
  *) KILN_MOUNT_PATH="${WEBAPP_CONTEXT_PATH}" ;;
esac

sed -i "s|<xsl:variable name=\"kiln:mount-path\" select=\"'.*'\" />|<xsl:variable name=\"kiln:mount-path\" select=\"'${KILN_MOUNT_PATH}'\" />|" webapps/ROOT/stylesheets/defaults.xsl

export ANT_OPTS="-Xms${JAVA_XMS} -Xmx${JAVA_XMX} -XX:MaxMetaspaceSize=${JAVA_MAX_METASPACE} -Dinfo.aduna.platform.appdata.basedir=./webapps/openrdf-sesame/app_dir/ -Dorg.eclipse.jetty.LEVEL=WARN ${ANT_OPTS_EXTRA:-}"

sw/ant/bin/ant -S -Dwebapp.context.path="${WEBAPP_CONTEXT_PATH}" -f local.build.xml "$@"
