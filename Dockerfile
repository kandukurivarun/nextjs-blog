FROM openjdk:23-jdk-slim

ARG JMETER_VERSION=5.6.3

ENV PATH="$PATH:/jmeter/apache-jmeter-$JMETER_VERSION/bin"

RUN apt-get clean && \
    apt-get update && \
    apt-get -qy install \
    wget \
    telnet \
    iputils-ping \
    unzip

RUN  mkdir /jmeter \
    && cd /jmeter/ \
    && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz \
    && tar -xzf apache-jmeter-$JMETER_VERSION.tgz \
    && rm apache-jmeter-$JMETER_VERSION.tgz


COPY jmeter-plugins-manager-1.10.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/

RUN cd /jmeter/apache-jmeter-$JMETER_VERSION/lib \
      && wget https://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.3/cmdrunner-2.3.jar -O cmdrunner-2.3.jar

RUN java -cp /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext/jmeter-plugins-manager-1.10.jar org.jmeterplugins.repository.PluginManagerCMDInstaller

RUN wget http://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.0/cmdrunner-2.0.jar

RUN PluginsManagerCMD.sh install cmdrunner
