FROM openjdk:23-jdk-slim

ARG JMETER_VERSION=5.6.3

ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN ${JMETER_HOME}/bin
ENV MIRROR_HOST https://archive.apache.org
ENV JMETER_DOWNLOAD_URL ${MIRROR_HOST}/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz
ENV JMETER_PLUGINS_DOWNLOAD_URL https://repo1.maven.org/maven2/kg/apc
ENV JMETER_PLUGINS_FOLDER ${JMETER_HOME}/lib/ext/

RUN apt-get clean && \
    apt-get update && \
    apt-get -qy install \
    wget \
    telnet \
    iputils-ping \
    unzip \
    ca-certificates \
    curl \
    && update-ca-certificates

RUN mkdir -p /tmp/dependencies  \
    && curl -L ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
    && mkdir -p /opt  \
    && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
    && rm -rf /tmp/dependencies \
    && curl -L ${JMETER_PLUGINS_DOWNLOAD_URL}/cmdrunner/2.3/cmdrunner-2.3.jar -o ${JMETER_HOME}/lib/cmdrunner-2.3.jar \
    && curl -L ${JMETER_PLUGINS_DOWNLOAD_URL}/jmeter-plugins-manager/1.10/jmeter-plugins-manager-1.10.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-manager-1.10.jar

ENV PATH $PATH:$JMETER_BIN

COPY ./launch.sh /
RUN chmod +x /launch.sh

ENTRYPOINT ["/launch.sh"]
CMD ["-n -t /mnt/jmeter/script.jmx -l /mnt/jmeter/results/reslut-$(date +'%m_%d_%Y-%H_%M_%S_%N').jtl -j /mnt/jmeter/logs/master-log-$(date +'%m_%d_%Y-%H_%M_%S_%N').log"
