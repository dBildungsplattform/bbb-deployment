FROM bbb-fsesl-client AS builder

ARG COMMON_VERSION

COPY . /source

RUN cd /source \
 && find -name build.sbt -exec sed -i "s|\(.*org.bigbluebutton.*bbb-common-message[^\"]*\"[ ]*%[ ]*\)\"[^\"]*\"\(.*\)|\1\"$COMMON_VERSION\"\2|g" {} \; \
 && find -name build.sbt -exec sed -i "s|\(.*org.bigbluebutton.*bbb-fsesl-client[^\"]*\"[ ]*%[ ]*\)\"[^\"]*\"\(.*\)|\1\"$COMMON_VERSION\"\2|g" {} \; \
 && sbt compile

RUN apt-get update \
 && apt-get -y install fakeroot

RUN cd /source \
 && sbt debian:packageBin

FROM openjdk:8-jre-slim-stretch

USER root
COPY --from=builder /source/target/*.deb /root/

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update -y && \
    apt-get install -y openjdk-8-jdk
    
RUN dpkg -i /root/*.deb

COPY wait-for-it.sh /usr/local/bin/

CMD ["/usr/share/bbb-fsesl-akka/bin/bbb-fsesl-akka"]
