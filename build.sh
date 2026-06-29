#!/bin/bash

export ANT_OPTS='-Xms64m -Xmx512m -XX:MaxMetaspaceSize=128m -Dinfo.aduna.platform.appdata.basedir=./webapps/openrdf-sesame/app_dir/ -Dorg.eclipse.jetty.LEVEL=WARN'

sw/ant/bin/ant -S -f local.build.xml $*
