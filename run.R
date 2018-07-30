setwd("C:/Users/E014556/Documents/repository/churn/apis/ruk_2/")

library(ranger)
library(jsonlite)

source("functions.R")
load("data/training_meta.RData")

#RUK
model_ruk <- readRDS("data/churnModelRUK_1.rds")
scaler_ruk <- readRDS("data/churnModelRUK_1_scale.rds")
load("data/churnModelRUK_1_modelmeta.RData")
numericColumns_ruk <- numericColumns[!numericColumns%in%not_used_variables_ruk]
categoricalColumns_ruk <- categoricalColumns[!categoricalColumns%in%not_used_variables_ruk]
binaryColumns_ruk <- binaryColumns[!binaryColumns%in%not_used_variables_ruk]

#NHK
model_nhk <- readRDS("data/churnModelNHK_1.rds")
scaler_nhk <- readRDS("data/churnModelNHK_1_scale.rds")
load("data/churnModelNHK_1_modelmeta.RData")
numericColumns_nhk <- numericColumns[!numericColumns%in%not_used_variables_nhk]
categoricalColumns_nhk <- categoricalColumns[!categoricalColumns%in%not_used_variables_nhk]
binaryColumns_nhk <- binaryColumns[!binaryColumns%in%not_used_variables_nhk]

#BOX
model_box <- readRDS("data/churnModelBOX_1.rds")
scaler_box <- readRDS("data/churnModelBOX_1_scale.rds")
load("data/churnModelBOX_1_modelmeta.RData")
numericColumns_box <- numericColumns[!numericColumns%in%not_used_variables_box]
categoricalColumns_box <- categoricalColumns[!categoricalColumns%in%not_used_variables_box]
binaryColumns_box <- binaryColumns[!binaryColumns%in%not_used_variables_box]


req <- fromJSON("data/test_4.json")
# req <- req[colnames(req)%in%c(numericColumns,categoricalColumns,binaryColumns)]
# write_json(req,"data/test_4.json")
 
#x <- '[{"contact_id":105150,"current_month":3,"current_year":2018,"churn":0,"payment_failure":0,"active_change":0,"inactive_change":0,"system_cancelled_change":0,"cancel_scheduled_change":0,"customer_cancelled_change":0,"monthly_contract":1,"pending_cancellation":0,"inactive_count":4,"inactive_count_last_year":0,"inactive_count_last_month":0,"customer_cancelled_count":2,"cancel_scheduled_count":0,"system_cancelled_count":2,"inactive_this_time_last_year":0,"days_since_creation":1595,"creation":"creation_up_to_max","last_inactive_end":"up_to_7_days_ago","last_inactive_start":"over_1_year_ago","month_of_change":"MARCH    ","month_of_creation":11,"no_term":0,"standard_class":1,"hogarth":0,"last_payment_method":"realex","last_pay_method_expiry":"over_one_month","payment_amount_last_month":24.98,"payment_amount_last_year":299.76,"sum_payment":1332.42,"sum_succ_payment":1140.22,"sum_unsucc_payment":192.2,"last_succ_payment":"up_to_7_days_ago","last_payment_when":"up_to_7_days_ago","refund_count":0,"refund_sum":0,"refund_reason_1":0,"refund_reason_2":0,"refund_reason_4":0,"payment_failure_count":10,"last_year_payment_failure":0,"last_month_payment_failure":0,"last_payment_what":"authorised","cases_count":21,"financial_case_count":0,"cases_count_last_month":0,"cases_count_last_year":1,"open_case_count_last_year":0,"cancel_case_count_last_year":0,"complaint_case_count_last_year":0,"admin_case_count_last_year":0,"financial_case_count_last_year":0,"last_case_when":"up_to_one_year_ago","last_case_is_open":0,"last_case_what":"missing","postcode":"rg303hh","eur_contracts":0,"gbp_contracts":2,"max_of_contract_month":45,"min_of_contract_month":21,"years_end":0,"first_years_end":0,"sum_of_avg_charges":34.98,"avg_of_avg_charges":17.49,"min_of_avg_charges":10,"max_of_avg_charges":24.98,"oac11":"4C1"}]'
#x <- fromJSON(x)


#* Echo back the input
#* @param req The message to echo
#* @post /run
#* @json
function(req){

req <- fromJSON(req$postBody)
 req <- data.frame(req)
  
    cats <- cbind(level_binr(req,creation_levels,"creation","cr")
                  ,level_binr(req,last_change_levels,"last_change","lc")
                  ,level_binr(req,last_inactive_end_levels,"last_inactive_end","lie")
                  ,level_binr(req,last_inactive_start_levels,"last_inactive_start","lis")
                  ,level_binr(req,last_payment_method_levels,"last_payment_method","lpm")
                  ,level_binr(req,last_pay_method_expiry_levels,"last_pay_method_expiry","lpme")
                  ,level_binr(req,last_succ_payment_levels,"last_succ_payment","lsp")
                  ,level_binr(req,last_payment_when_levels,"last_payment_when","lpw")
                  ,level_binr(req,last_payment_what_levels,"last_payment_what","lpwha")
                  ,level_binr(req,last_case_when_levels,"last_case_when","lcw")
                  ,level_binr(req,last_case_what_levels,"last_case_what","lcwha")
                  ,level_binr(req,oac11_levels_levels,"oac11","oac11"),
                  level_binr(req,month_of_change_levels,"month_of_change","moc"))
    
    
    
    if("tennant"%in%colnames(req)){
          req$t <- tolower(req$tennant)
          req$t <- "other"
          req$t[grepl("racinguk",req$tennant)|grepl("ruk",req$tennant)] <- "ruk"
          req$t[grepl("nhk",req$tennant)] <- "nhk"
          req$t[grepl("box",req$tennant)|grepl("bx",req$tennant)] <- "box"
    } else {
      req$t <- "missing"
    }
  
    
    if(any(req$t=="ruk")){
            prediction <- run(req,used_variables_ruk,numericColumns_ruk,cats,model_ruk,scaler_ruk,"yes")          
      }
      else if(any(req$t=="nhk")){
            prediction <- run(req,used_variables_nhk,numericColumns_nhk,cats,model_nhk,scaler_nhk,"yes") 
      }
      else if(any(req$t=="box")){
        prediction <- run(req,used_variables_box,numericColumns_box,cats,model_box,scaler_box,"no") 
      }
      else if(any(req$t=="other")) {
            prediction <- run(req,used_variables_ruk,numericColumns_ruk,cats,model_ruk,scaler_ruk,"yes")     
            warning("model for tennant not developed. trying to run without but results may be inacurate. "
                    , call. = TRUE, immediate. = FALSE, noBreaks. = FALSE,
                    domain = NULL)
            }
     else {
          prediction <- run(req,used_variables_ruk,numericColumns_ruk,cats,model_ruk,scaler_ruk,"yes")     
          warning("tennant not supplied. trying to run without but results may be inacurate. "
                  , call. = TRUE, immediate. = FALSE, noBreaks. = FALSE,
                  domain = NULL)
     }

    return(prediction)
    
}

