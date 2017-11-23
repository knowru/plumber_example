# For details related to this data set
# please refer https://archive.ics.uci.edu/ml/datasets/Statlog+(German+Credit+Data)
url <- "https://archive.ics.uci.edu/ml/machine-learning-databases/statlog/german/german.data"
col.names <- c(
  'Status of existing checking account', 'Duration in month', 'Credit history'
  , 'Purpose', 'Credit amount', 'Savings account/bonds'
  , 'Employment years', 'Installment rate in percentage of disposable income'
  , 'Personal status and sex', 'Other debtors / guarantors', 'Present residence since'
  , 'Property', 'Age in years', 'Other installment plans', 'Housing', 'Number of existing credits at this bank'
  , 'Job', 'Number of people being liable to provide maintenance for', 'Telephone', 'Foreign worker', 'Status'
)
# Get the data
data <- read.csv(
  url
  , header=FALSE
  , sep=' '
  , col.names=col.names
)

library(rpart)
# Build a tree
# I already figured these significant variables from my first iteration (not shown in this code for simplicity)
decision.tree <- rpart(
  Status ~ Status.of.existing.checking.account + Duration.in.month + Credit.history + Savings.account.bonds
  , method="class"
  , data=data
)

install.packages("rpart.plot")
library(rpart.plot)
# Visualize the tree
prp(
  decision.tree
  , extra=1
  , varlen=0
  , faclen=0
  , main="Decision Tree for German Credit Data"
)

save(decision.tree, file='Decision Tree for German Credit Data.RData')

new.data <- list(
  Status.of.existing.checking.account='A11'
  , Duration.in.month=20
  , Credit.history='A32'
  , Savings.account.bonds='A65'
)
predict(decision.tree, new.data)
#           1         2
# 1 0.6942446 0.3057554