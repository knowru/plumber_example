FROM trestletech/plumber
RUN mkdir -p /app/
WORKDIR /app/
COPY run.R /app/
COPY functions.R /app/
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
