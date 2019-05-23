ARG BASE_IMAGE
FROM ${BASE_IMAGE} as builder

WORKDIR /opt

ARG SPARK_VER
ARG HADOOP_VER
ARG HIVE_VER
ARG SCALA_VER

ARG SPARK="https://archive.apache.org/dist/spark/spark-${SPARK_VER}/spark-${SPARK_VER}-bin-without-hadoop.tgz"
ARG HADOOP="http://apache.claz.org/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz"
ARG HIVE="https://archive.apache.org/dist/hive/hive-${HIVE_VER}/apache-hive-${HIVE_VER}-bin.tar.gz"

# ARG REPOSITORY=""
# ARG OJDBS="${REPOSITORY}/ojdbc8-full.tar"
# ADD ${OJDBS} ./

ADD ${SPARK} ${HADOOP} ${HIVE} ./

RUN mkdir -p /opt/build && \
    tar -zxf spark-${SPARK_VER}-bin-without-hadoop.tgz && \ 
    mv spark-${SPARK_VER}-bin-without-hadoop /opt/build/ && \
    tar -zxf hadoop-${HADOOP_VER}.tar.gz && \
    mv hadoop-${HADOOP_VER} /opt/build/ && \
    tar -zxf apache-hive-${HIVE_VER}-bin.tar.gz && \
    cp apache-hive-${HIVE_VER}-bin/lib/hive-exec-${HIVE_VER}.jar /opt/build/spark-${SPARK_VER}-bin-without-hadoop/jars && \
    mv apache-hive-${HIVE_VER}-bin /opt/build/ && \
    # tar -xf ojdbc8-full.tar && cp OJDBC8-Full/ojdbc8.jar /opt/build/spark-${SPARK_VER}-bin-without-hadoop/jars/ && \
    cp /opt/build/spark-${SPARK_VER}-bin-without-hadoop/jars/* /opt/build/apache-hive-${HIVE_VER}-bin/lib/


FROM ${BASE_IMAGE}

ARG SPARK_VER
ARG HADOOP_VER
ARG HIVE_VER
ARG SCALA_VER

# ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk \
ENV HIVE_HOME=/opt/apache-hive-${HIVE_VER}-bin \
    SPARK_HOME=/opt/spark-${SPARK_VER}-bin-without-hadoop \
    HADOOP_HOME=/opt/hadoop-${HADOOP_VER}

ENV PATH="${PATH}:${SPARK_HOME}/bin:${HIVE_HOME}/bin:${HADOOP_HOME}/bin"

ENV SPARK_DIST_CLASSPATH="${HADOOP_HOME}/etc/hadoop:${HADOOP_HOME}/share/hadoop/common/lib/*:${HADOOP_HOME}/share/hadoop/common/*:${HADOOP_HOME}/share/hadoop/hdfs:${HADOOP_HOME}/share/hadoop/hdfs/lib/*:${HADOOP_HOME}/share/hadoop/hdfs/*:${HADOOP_HOME}/share/hadoop/yarn:${HADOOP_HOME}/share/hadoop/yarn/lib/*:${HADOOP_HOME}/share/hadoop/yarn/*:${HADOOP_HOME}/share/hadoop/mapreduce/lib/*:${HADOOP_HOME}/share/hadoop/mapreduce/*:${HADOOP_HOME}/contrib/capacity-scheduler/*.jar"

RUN ln -s ${SPARK_HOME} /opt/spark && \
    ln -s ${HADOOP_HOME} /opt/hadoop && \
    ln -s ${HIVE_HOME} /opt/hive

COPY --from=builder /opt/build/ /opt/

# ADD jars/hadoop-aws-2.8.5.jar /opt/hive/lib/
# ADD jars/aws-java-sdk-core-1.11.414.jar /opt/hive/lib/
# ADD jars/aws-java-sdk-kms-1.11.414.jar /opt/hive/lib/
# ADD jars/aws-java-sdk-s3-1.11.414.jar /opt/hive/lib/
ADD jars/*.jar /opt/hive/lib/

CMD ["hiveserver2"]
