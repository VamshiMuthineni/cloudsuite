FROM alok123t/java:openjdk8
# Install dependencies
RUN apt-get update -y && apt-get install -y --no-install-recommends \
      libblas3 \
      libgfortran3 \
      liblapack3 \
      wget \
    && rm -rf /var/lib/apt/lists/*
ENV SPARK_VERSION 2.3.1
ENV HADOOP_VERSION 2.7
ENV MIRROR  https://archive.apache.org/dist/spark/
ENV SPARK_HOME /opt/spark-${SPARK_VERSION}
# Install Spark
RUN set -x \
&& wget -q --show-progress --progress=bar:force https://archive.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz \
&& mkdir -p $SPARK_HOME \
&& tar -xzf spark-2.3.1-bin-hadoop2.7.tgz --directory=$SPARK_HOME --strip 1
COPY files /root/
# Expose Spark ports
ENV SPARK_MASTER_PORT 7077
ENV SPARK_WEBUI_PORT 8080
EXPOSE ${SPARK_MASTER_PORT} ${SPARK_WEBUI_PORT}
ENTRYPOINT [“/root/entrypoint.sh”]

