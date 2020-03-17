FROM centos:7
FROM java:openjdk-7-jdk

#  Version
ENV SOAPUI_VERSION=5.5.0 \
    SOAPUI_SUPPORT_VERSION=1.7.0 \
    SOAPUI_PROJECT=soapuiskltp-soapui-project.xml \
    SOAPUI_DIR=/opt/soapui
ENV SUPPORTLIB_URL=https://ci.inera.se/job/Domains/job/servicedomain-test-framework/lastSuccessfulBuild/artifact/framework/soapui-support/build/libs/soapui-support-${SOAPUI_SUPPORT_VERSION}.jar

# Download and unarchive SoapUI
RUN mkdir -p /opt && cd /opt \
 && curl -LO https://s3.amazonaws.com/downloads.eviware/soapuios/${SOAPUI_VERSION}/SoapUI-x64-${SOAPUI_VERSION}.sh \
 && /bin/bash ./SoapUI-x64-${SOAPUI_VERSION}.sh -q -dir ${SOAPUI_DIR} \
 && rm ./SoapUI-x64-${SOAPUI_VERSION}.sh \
 && curl ${SUPPORTLIB_URL} -L -o /opt/soapui/bin/ext/soapui-support-${SOAPUI_SUPPORT_VERSION}.jar \ 
 && rm -rf /root/.soapuios/plugins/*.jar 

# Copy the test suite
VOLUME /usr/src/soapui/

# Set working directory
WORKDIR /usr/src/soapui

# Set environment
ENV PATH ${PATH}:/opt/soapui/bin

# Copy SoapUI files to root folder (must be something better?...)
COPY data.xml /.
COPY cert.p12 /.

ENTRYPOINT ["./testrunner_all.sh"]
