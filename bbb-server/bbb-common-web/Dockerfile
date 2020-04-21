FROM bbb-common-message

ARG COMMON_VERSION

COPY . /bbb-common-web

RUN cd /bbb-common-web \
 && sed -i "s|\(version := \)\".*|\1\"$COMMON_VERSION\"|g" build.sbt \
 && find -name build.sbt -exec sed -i "s|\(.*org.bigbluebutton.*bbb-common-message[^\"]*\"[ ]*%[ ]*\)\"[^\"]*\"\(.*\)|\1\"$COMMON_VERSION\"\2|g" {} \; \
 && echo 'publishTo := Some(Resolver.file("file",  new File(Path.userHome.absolutePath+"/.m2/repository")))' | tee -a build.sbt \
 && sbt compile \
 && sbt publish \
 && sbt publishLocal



#[info]  published bbb-common-message_2.12 to /root/.ivy2/local/org.bigbluebutton/bbb-common-message_2.12/0.0.1-SNAPSHOT/poms/bbb-common-message_2.12.pom
#[info]  published bbb-common-message_2.12 to /root/.ivy2/local/org.bigbluebutton/bbb-common-message_2.12/0.0.1-SNAPSHOT/jars/bbb-common-message_2.12.jar
#[info]  published bbb-common-message_2.12 to /root/.ivy2/local/org.bigbluebutton/bbb-common-message_2.12/0.0.1-SNAPSHOT/srcs/bbb-common-message_2.12-sources.jar
#[info]  published bbb-common-message_2.12 to /root/.ivy2/local/org.bigbluebutton/bbb-common-message_2.12/0.0.1-SNAPSHOT/docs/bbb-common-message_2.12-javadoc.jar

#[info]  published bbb-common-message_2.12 to /root/.m2/repository/org/bigbluebutton/bbb-common-message_2.12/0.0.1-SNAPSHOT/bbb-common-message_2.12-0.0.1-SNAPSHOT.pom
#[info]  published bbb-common-message_2.12 to /root/.m2/repository/org/bigbluebutton/bbb-common-message_2.12/0.0.1-SNAPSHOT/bbb-common-message_2.12-0.0.1-SNAPSHOT.jar
#[info]  published bbb-common-message_2.12 to /root/.m2/repository/org/bigbluebutton/bbb-common-message_2.12/0.0.1-SNAPSHOT/bbb-common-message_2.12-0.0.1-SNAPSHOT-sources.jar
#[info]  published bbb-common-message_2.12 to /root/.m2/repository/org/bigbluebutton/bbb-common-message_2.12/0.0.1-SNAPSHOT/bbb-common-message_2.12-0.0.1-SNAPSHOT-javadoc.jar

