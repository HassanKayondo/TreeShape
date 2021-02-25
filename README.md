# TreeShape
Employing phylogenetic tree shape statistics to resolve the underlying host population structure

The structure of this repository is as shown below. Tree statistics generated for four parameter sets are located in four sub-folders of the Data folder. The scripts used for analysis are located in the scripts folder. Data files used for estimating R0 from cherry to tip ratio (CTR) are located in the CTR sub-folder.

```
TreeShape
│   README.md 
|
|____Data
│   |___CTR
|   |   |   str.csv
|   |   |   unstr.csv
|   |
│   │___RealData
|   |   |   subpopn1.csv
|   |   |   subpopn2.csv
|   |   |   subpopn1_and_subpopn2.csv
|   |   
│   │___SimulatedData
|       |___Dataset1
|       |   |   str.csv
|       |   |   unstr.csv
|       |___Dataset2
|       |   |   str.csv
|       |   |   unstr.csv
|       |___Dataset3
|       |   |   str.csv
|       |   |   unstr.csv
|       |___Dataset4
|           |   str.csv
|           |   unstr.csv
|           
└───Scripts
    │   Classification_with_crossvalidation.R
    │   CTR_analysis.R
    │   Komogorov_Smirnov_Test.R
    │   str_simulation.py
    │   unstr_simulation.py
    │   model_functions.py
    │   tree_shape_statistics.py
    │   compute_realdata_statistics.py

```


### Simulating trees and estimating tree statistics
The four sets of simulated data were generated using the `str_simulation.py` and `unstr_simulation.py` for structured and unstructured populations respectively.

* Dataset1

### Sensitivity analysis

* Dataset2
      
* Dataset3
    
* Dataset4

### Comparing tree statistics between structured and un-structured populations
This is done using the `Komogorov_Smirnov_Test.R` script. The input of this script are csv files created by `tree_simulation.py` script. The comparisons are  based on the Kolmogorov–Smirnov test. `Tree_statistics_boxplots.R` script is used to produce boxplots that visualise the distribution of tree statistics between structured and un-structured populations.

### Classiﬁcation of simulated trees as structured or non-structured population based on their tree statistics
We built ML models that use tree shape statistics mentioned above to classify trees as structured or un-structured. This is done using the `Classification_with_crossvalidation.R` script. The script takes as input csv files created by `tree_simulation.py` script. Majorly, it uses `Caret` package for parameter tuning and model training at 10-fold cross validation. Model performance is assessed using four metrics, that is; accuracy, sensitivity, specificify and area under the receiver operating characteristic curve. `pROC` package was used for ROC analysis. `ROC_CM_classification.R` script is used to produce visualisation of roc-curves and confusion matrices.

### Validation of the simulation procedure using R0 estimates based on cherry to tip ratio
Takes csv file created by `tree_simulation.py`, computes cherry to tip ratio and finally computes the basic reproductive number as a function of CTR.

## Applying models to real world genomic data


