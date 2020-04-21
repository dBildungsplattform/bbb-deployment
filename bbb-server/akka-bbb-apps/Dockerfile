FROM bbb-common-message AS builder

ARG COMMON_VERSION

COPY . /source

RUN cd /source \
 && find -name build.sbt -exec sed -i "s|\(.*org.bigbluebutton.*bbb-common-message[^\"]*\"[ ]*%[ ]*\)\"[^\"]*\"\(.*\)|\1\"$COMMON_VERSION\"\2|g" {} \; \
 && sbt compile

RUN apt-get update \
 && apt-get -y install fakeroot

RUN cd /source \
 && sbt debian:packageBin

# FROM ubuntu:16.04
FROM openjdk:8-jre-slim-stretch
#FROM openjdk:8

USER root
COPY --from=builder /source/target/*.deb /root/

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update -y && \
    apt-get install -y openjdk-8-jdk

RUN dpkg -i /root/*.deb

CMD ["/usr/share/bbb-apps-akka/bin/bbb-apps-akka"]
