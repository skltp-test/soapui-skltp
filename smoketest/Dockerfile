FROM openjdk:11

#  Version
ENV SOAPUI_VERSION=5.7.0 \
    SOAPUI_SUPPORT_VERSION=1.8.0 \
    SOAPUI_DIR=/opt/soapui
ENV SUPPORTLIB_URL=https://rivta-tools.bitbucket.io/soapui-support/builds/soapui-support-${SOAPUI_SUPPORT_VERSION}.jar
ENV SOAPUI_URL=https://s3.amazonaws.com/downloads.eviware/soapuios/${SOAPUI_VERSION}/SoapUI-${SOAPUI_VERSION}-linux-bin.tar.gz

# Download and unarchive SoapUI
RUN mkdir -p /opt \
 && curl ${SOAPUI_URL} | gunzip -c - | tar -xf - -C /opt \
 && mv /opt/SoapUI-${SOAPUI_VERSION} ${SOAPUI_DIR} \
 && curl ${SUPPORTLIB_URL} -L -o ${SOAPUI_DIR}/bin/ext/soapui-support-${SOAPUI_SUPPORT_VERSION}.jar

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
