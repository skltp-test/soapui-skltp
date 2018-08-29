FROM centos:7
FROM java:openjdk-7-jdk

#  Version
ENV   SOAPUI_VERSION  5.4.0
ENV   SOAPUI_SUPPORT_VERSION  1.5.7
ENV   SOAPUI_PROJECT soapuiskltp-soapui-project.xml

# Download and unarchive SoapUI
RUN mkdir -p /opt &&\
    curl https://s3.amazonaws.com/downloads.eviware/soapuios/${SOAPUI_VERSION}/SoapUI-x64-${SOAPUI_VERSION}.sh > /opt/SoapUI-x64-${SOAPUI_VERSION}.sh &&\
    cd /opt &&\
    chmod a+x ./SoapUI-x64-5.4.0.sh &&\
    ./SoapUI-x64-5.4.0.sh -q &&\
    ln -s /opt/SmartBear/SoapUI-${SOAPUI_VERSION} /opt/soapui


RUN curl https://ci.inera.se/job/Domains/job/servicedomain-test-framework/lastSuccessfulBuild/artifact/framework/soapui-support/build/libs/soapui-support-${SOAPUI_SUPPORT_VERSION}.jar > /opt/soapui/bin/ext/soapui-support-${SOAPUI_SUPPORT_VERSION}.jar


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
