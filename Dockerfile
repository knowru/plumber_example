FROM trestletech/plumber
ENV http_proxy http://10.1.4.44:8080
ENV https_proxy http://10.1.4.44:8080
# Install OpenJDK-8
#RUN apt-get update && \
#    apt-get install -y openjdk-8-jdk && \
#    apt-get install -y ant && \
#    apt-get clean;
# Fix certificate issues
#RUN apt-get update && \
#    apt-get install ca-certificates-java && \
#    apt-get clean && \
#    update-ca-certificates -f;
# Setup JAVA_HOME -- useful for docker commandline
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
#RUN export JAVA_HOME
#RUN R CMD javareconf
RUN apt-get update
RUN R -e "install.packages('jsonlite', repos='https://cloud.r-project.org/')"
RUN R -e "install.packages('ranger', repos='https://cloud.r-project.org/')"

RUN mkdir -p /app/
WORKDIR /app/
COPY run.R /app/
COPY functions.R /app/
COPY data/churnModelBOX_1.rds /app/
COPY data/churnModelBOX_1_modelmeta.RData /app/
COPY data/churnModelNHK_1.rds /app/
COPY data/churnModelNHK_1_modelmeta.RData /app/
COPY data/churnModelNHK_1_scale.rds /app/
COPY data/churnModelRUK_1.rds /app/
COPY data/churnModelRUK_1_modelmeta.RData /app/
COPY data/churnModelRUK_1_scale.rds /app/

COPY data/training_meta.RData /app/

CMD ["/app/run.R"]
