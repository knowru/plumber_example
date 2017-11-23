FROM trestletech/plumber
RUN mkdir -p /app/
WORKDIR /app/
COPY deploy_credit_model.R /app/
COPY decision_tree_for_german_credit_data.RData /app/
CMD ["/app/deploy_credit_model.R"]