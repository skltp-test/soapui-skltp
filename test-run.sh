#!/bin/bash

SOAPUI_HOME=/opt/soapui
SOAPUI_BIN=${SOAPUI_HOME}/bin
SOAPUI_LIB=${SOAPUI_HOME}/lib
SOAPUI_VER=5.4.0

SOAPUI_CLASSPATH=${SOAPUI_BIN}/soapui-${SOAPUI_VER}.jar:${SOAPUI_LIB}/*
JFXRTPATH=$(java -cp ${SOAPUI_CLASSPATH} com.eviware.soapui.tools.JfxrtLocator)
SOAPUI_CLASSPATH=${JFXRTPATH}:${SOAPUI_CLASSPATH}

JAVA_OPTS="-Xms128m -Xmx1024m -Dsoapui.properties=soapui.properties -Dsoapui.home=${SOAPUI_BIN}"
JAVA_OPTS="$JAVA_OPTS -Dsoapui.ext.libraries=$1"
JAVA_OPTS="$JAVA_OPTS -Dsoapui.ext.listeners=${SOAPUI_BIN}/listeners"
JAVA_OPTS="$JAVA_OPTS -Dsoapui.ext.actions=${SOAPUI_BIN}/actions"

# java ${JAVA_OPTS} -cp ${SOAPUI_CLASSPATH} com.eviware.soapui.tools.SoapUITestCaseRunner NTjP-RT-soapui-project.xml

# One test...
#${SOAPUI_BIN}/testrunner.sh -s "Ursprunglig avsändare" -c "1.1.1 - Angränsande konsument skickar fråga via aggregerande tjänst" -A -r -j -M -f `pwd`/result -I `pwd`/NTjP-RT-soapui-project.xml
# All tests in suite...
${SOAPUI_BIN}/testrunner.sh -s "Ursprunglig avsändare" -A -r -j -M -f `pwd`/result -I `pwd`/NTjP-RT-soapui-project.xml
