#!/usr/bin/env bash
export CATALINA_OPTS="$CATALINA_OPTS -Xms12288m -Xmx12288m"

export CLASSPATH="$CLASSPATH:$CATALINA_HOME/lib/*:"`/opt/hbase/bin/hbase classpath`
