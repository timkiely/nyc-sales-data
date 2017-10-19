Analysis of NYC Sales Data
================

A model to predict NYC sales amounts and frequencies.

### Objective

Create a modeling data set with NYC sales data. To enrich features, we want to map in PLUTO and ACRIS information. In particular, mapping in lat/lon coordinates from PLUTO will allow us to locate our observations in space, which, in turn, will enable geo-spatial analysis of the data set. ACRIS is primarily for filtering purposes, e.g., remove "Time Share Deed" transfers that bloat the data set with small frequent non-sale transactions.

### Done:

-   Raw data downloaded and processed
-   Modeling data EDA done
-   Three scripts all functioning: Processing, model objects and model training
-   (10/13/2017) Added all models of interest and run first successful full trial. Run time took 1.6 days with Random Forrest models eating up considerable computation time.
-   (10/18/2017) Optimized run time by swapping in modern algorithms for KNN and especially Random Forrest (using highly parallel h2o package which also boosts accuracy). Run time now completes in around 5 hours (down from 1.6 days)

### To do:

-   Implement evaluation metrics to mimic Antipov, et. al. 2011.
    -   *Sales Ratio* (Model Prediction / Actual). the 95% CI must overlap 0.9-1.1 range according to international standards
    -   *Coefficient of dispersion* (COD). Average percentage deviation of Sales Ratio (SR) from it's median value. International stadnards states a COD of 5-20% is acceptable
    -   *Mean Average Percentage Error* (MAPE) Easy to interpret and refelct accuracy of model
-   Proximity features, i.e., features that take into account geographic position

MODEL RUN LOG:
==============

### Model Run Oct 16th, 2017

First complete model training run complete. Total run time was 1.6 days, with considerable time dedicated to Random Forrest (approx. 1.3 days for just RF). We can significantly improve the model training time by optimizing the RF routine, possibly by experimenting with alternative implementations of RF. In addition, the Multi layer perceptron models performed exceedingly poorly and also required some of the longest training times. It's possible that they require significant tuning in order to be competitive. Literature suggests that MLP's won't compete vs GBM or RF without significant pre-processing and computation time. I will consider tuning MLP further.

### Model Run Oct 19th, 2017

After optimizing several of the slowest models, the entire runtime has been reduced by a factor of 8 (from ~40 hours down to 5). This despite adding several models. The largest speedup was due to incorporating H2O for Random Forrest rather than the caret version.

Interestingly, the best performing models are trained on the numeric\_only and numeric\_processed datasets. The vtreat packages appears to help with parametric models but the non-linear models don't seem to benefit from such treatment. It's possible and worth investigating alternative methods for dealing with categorial variables, such as one-hot encoding. This seems like the logical next step as the overall process will no doubt benefit from having the best possible baseline models prior to introducing proximity features.
