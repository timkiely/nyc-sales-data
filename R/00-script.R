
## run the entire analysis from this script file
script_start <- Sys.time()

# load/install necessary packages (ask first) and source the various project functions:
source("R/helper/display-opener.R")
source("R/helper/load-packages.R")
source("R/helper/source-files.R")

# checking file structure
project_makefile()

# parse command arguments passed to 'Rscript R/00-script.R'
# for arguments, enter 'Rscript R/00-script.R -h' on the command line
cli_args <- parse_cmd_args()
cli_args$`skip-dl` = TRUE
cli_args$`skip-pp` = FALSE
cli_args$`run-radii` = TRUE
cli_args$`run-sample` = FALSE

# data --------------------------------------------------------------------
if(cli_args$`skip-dl` == TRUE) message("=====> Bypassing download functions") else {
  download_nyc_pluto( save_file = "data/processing steps/p01_pluto_raw.rds")
  download_nyc_pad(   save_file = "data/processing steps/p02_pad_raw.rds") # steps 1 and 2 take 13.5 minutes
  download_nyc_sales( save_file = "data/processing steps/p03_sales_raw.rds") # steps 1, 2 and 3 take 55 mins (from scratch)
}  


# processing --------------------------------------------------------------
if(cli_args$`skip-pp` == TRUE) message("=====> Bypassing preprocessing functions") else {
  
  # merging -----------------------------------------------------------------
  
  combine_sales_and_pad(sales_infile = "data/processing steps/p03_sales_raw.rds"
                        , pad_infile = "data/processing steps/p02_pad_raw.rds"
                        , pluto_infile = "data/processing steps/p01_pluto_raw.rds"
                        , outfile = "data/processing steps/p04_sales_and_pad.rds")
  
  
  combine_pluto_with_sales(pluto_infile = "data/processing steps/p01_pluto_raw.rds"
                           , sales_pad_infile = "data/processing steps/p04_sales_and_pad.rds"
                           , outfile = "data/processing steps/p05_pluto_with_sales.rds")
  
  
  # features and partitions -------------------------------------------------
  
  # base data
  create_base_data(pluto_with_sales_infile = "data/processing steps/p05_pluto_with_sales.rds"
                   , outfile = "data/processing steps/p06_base_model_data.rds"
                   , limit_boros = FALSE)
  
  # zipcode data
  create_zipcode_data(base_model_data = "data/processing steps/p06_base_model_data.rds"
                      , outfile = "data/processing steps/p07_zipcode_model_data.rds")
  
  # radii data. Note: extremely time intensive. Last full data run was 3.3 hours
  create_radii_data(base_model_data = "data/processing steps/p06_base_model_data.rds"
                    , outfile = "data/processing steps/p08_radii_model_data.rds"
                    
                    #  to run, explicity supply the "--run-radii" argument or modify the funtion argument run_radii below
                    , run_radii = cli_args$`run-radii`)
  
}





# Prob of sale model ------------------------------------------------------

# base data
run_probability_model(model_data_infile = "data/processing steps/p06_base_model_data.rds"
                      , outfile = "data/processing steps/p09_prob_of_sale_model_base.rds"
                      , dev = cli_args$`run-sample`
                      , helper_title = "BASE DATA")

# zipcode data
run_probability_model(model_data_infile = "data/processing steps/p07_zipcode_model_data.rds"
                      , outfile = "data/processing steps/p10_prob_of_sale_model_zipcode.rds"
                      , dev = cli_args$`run-sample`
                      , helper_title = "ZIPCODE DATA")

# radii data
run_probability_model(model_data_infile = "data/processing steps/p08_radii_model_data.rds"
                      , outfile = "data/processing steps/p11_prob_of_sale_model_radii.rds"
                      , dev = cli_args$`run-sample`
                      , helper_title = "RADII DATA")



# sale price model --------------------------------------------------------

# base data
run_sales_model(model_data_infile = "data/processing steps/p06_base_model_data.rds"
                , outfile = "data/processing steps/p12_sale_price_model_base.rds"
                , dev = cli_args$`run-sample`
                , helper_title = "BASE DATA")

# zipcode data
run_sales_model(model_data_infile = "data/processing steps/p07_zipcode_model_data.rds"
                , outfile = "data/processing steps/p13_sale_price_model_zipcode.rds"
                , dev = cli_args$`run-sample`
                , helper_title = "ZIPCODE DATA")

# radii data
run_sales_model(model_data_infile = "data/processing steps/p08_radii_model_data.rds"
                , outfile = "data/processing steps/p14_sale_price_model_radii.rds"
                , dev = cli_args$`run-sample`
                , helper_title = "RADII DATA")



# Evaluate model output ---------------------------------------------------
evaluate_probability_models(base_data_infile = "data/processing steps/p09_prob_of_sale_model_base.rds"
                            , zip_data_infile = "data/processing steps/p10_prob_of_sale_model_zipcode.rds"
                            , radii_data_infile = "data/processing steps/p11_prob_of_sale_model_radii.rds"
                            , outfile = "data/processing steps/p15_prob_model_evaluations.rds")

evalutate_sales_models(base_data_infile = "data/processing steps/p12_sale_price_model_base.rds"
                       , zip_data_infile = "data/processing steps/p13_sale_price_model_zipcode.rds"
                       , radii_data_infile = "data/processing steps/p14_sale_price_model_radii.rds"
                       , outfile = "data/processing steps/p16_sales_model_evaluations.rds")



# wrapping up -------------------------------------------------------------
# copy model results to analysis folder
file.copy(from = "data/processing steps/p15_prob_model_evaluations.rds"
          , to = "analysis/results/p15_prob_model_evaluations.rds"
          , overwrite = TRUE)

file.copy(from = "data/processing steps/p16_sales_model_evaluations.rds"
          , to = "analysis/results/p16_sales_model_evaluations.rds"
          , overwrite = TRUE)

c("data/processing steps/p09_prob_of_sale_model_base.rds"
  , "data/processing steps/p10_prob_of_sale_model_zipcode.rds"
  , "data/processing steps/p11_prob_of_sale_model_radii.rds") %>% 
  map(function(x) file.copy(from = x, to = paste0("analysis/results/prob/",basename(x)), overwrite = TRUE))

c("data/processing steps/p12_sale_price_model_base.rds"
  , "data/processing steps/p13_sale_price_model_zipcode.rds"
  , "data/processing steps/p14_sale_price_model_radii.rds") %>% 
  map(function(x) file.copy(from = x, to = paste0("analysis/results/sales/",basename(x)), overwrite = TRUE))

script_end <- Sys.time()
message("Program Total Run Time: ", round(script_end - script_start,2), units(script_end - script_start))













