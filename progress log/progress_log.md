progress log
================

### TODO:

-   First draft

### Done:

-   Raw data downloaded and processed
-   Modeling data EDA done
-   Three scripts all functioning: Processing, model objects and model training
-   (10/13/2017) Added all models of interest and run first successful full trial. Run time took 1.6 days with Random Forrest models eating up considerable computation time.
-   (10/18/2017) Optimized run time by swapping in modern algorithms for KNN and especially Random Forrest (using highly parallel h2o package which also boosts accuracy). Run time now completes in around 5 hours (down from 1.6 days)
-   (11/18/2017) Added additional evaluation metrics. Modeling: RMSE, MAPE, Spearman, Pearson, Rsq. AVM: Sales Ratio w/ CI's, COD
-   (01/06/2018) New game plan. Re-drew the steps of the procedure and am targeting 2 models: probability of sale & amount. Will have to step through the data processing steps once more and re-run the radii metrics calculations. Overhauled the directory structure. Project now has a clearer process and goal.
-   (01/23/2018) Progress update. scripts 00 through 06 all or nearly complete. Next tasks will be additional feature engineering and then modeling. Expecting the radii features to take significant time to sort out. I have some existing scripts which can be re-purposed for the modeling portion, so that should go quickly.
-   (01/24/2018) Had to manually correct the 2006 PLUTO data. Was missing some newline characters and variable names. Uploaded the corrected version so S3 and gave it public access. Updated download script to account for new destination.
-   (01/30/2018) Probability model now stable on base data. Working on evaluation script, then moving on to sales model, then zip code + radii features.
-   (01/30/2018) UPDATE: SALES model now also stable on base data. The sales eval metrics are suspiciously too good; need to backtrack through the preprocessing steps to see if I included the y variable in any of the training data ("Last Sale Amt" seems too good to be true). Evaluation scripts working for now, although could use some improvement. Last things to do is to create zip and radii features the wrap up
-   (02/02/2018) Currently running the radii indexing script. Has been running ~12 hours straight and still working at 100% CPU. I also added optparse() for Rscript argument parsing flexibility. Added argument help to README file as well. - (02/07/2018) By filtering the data to just Manhattan, have been able to successfully run all models. I also have a strategy for speeding up the radii calculations, which are the main bottleneck, but that may not be necessary for this project. Still to do: finish the model evaluation script and possibly fine-tune the data processing to maximize results. Note that on &gt;60 cores, total program run time with skip-dl and skip-pp enabled runs at just under 10 mins.
-   (02/24/2018): Radii indexing, on all boroughs, is now down to ~6 minutes. Using a grid-index approach, and massive parallelization, was able to bring the run time down from &gt;12 hours to under 6 minutes!s -(03/11/2018): Radii features are done. Implemented various distance weights including by euclidean distance, square footage, age, and combinations of those three. Weights are also Building Type conscious. Radii indexing has been significantly optimized, however, radii feature creation took 5 hours and required a substantial memory increase. Preliminary results are promising for lift over base model. Still to do: mirror the features at the zip level, then finish the evaluation scripts and run the full models.
-   (11/04/2018) Both the probability model and the sales model have now run and finished on the full dataset. Runtime is approx 5 hours. I may still wish to compare Random Forrest results with a GBM, but that will be an easy adjustment. I am now moving to the analysis folder to start an EDA of the resultant data.
