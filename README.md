# TreeShape
Employing phylogenetic tree shape statistics to resolve the underlying host population structure

The structure of this repository is as shown below. Tree statistics generated for four parameter sets are located in four sub-folders of the Data folder. The scripts used for analysis are located in the scripts folder. Data files used for estimating R0 from cherry to tip ratio (CTR) are located in the CTR sub-folder.

```
TreeShape
│   README.md 
|
|____Data
│   │___RealData
|   |   |   subpopn1.csv
|   |   |   subpopn2.csv
|   |   |   subpopn1_and_subpopn2.csv
|   |   
│   │___SimulatedData
|       |___Dataset1
|       |___Dataset2
|       |___Dataset3
|       |___Dataset4
|           
└───Scripts
    │   classification.R
    |   classify_realdata.R
    │   tree_shape_comparisons.R
    │   str_simulation.py
    │   unstr_simulation.py
    │   model_functions.py
    │   tree_shape_statistics.py
    │   compute_realdata_statistics.py

```


### Simulating trees and estimating tree statistics
The four sets of simulated data were generated using the `str_simulation.py` and `unstr_simulation.py` for structured and unstructured populations respectively. Models and tree shape statistics are defined in `model_functions.py` and `tree_shape_statistics.py` scripts respectively.  

* Dataset1

### Sensitivity analysis

* Dataset2
      
* Dataset3
    
* Dataset4

### Comparing tree statistics between structured and un-structured populations
This is done using the `tree_shape_comparisons.R` script. The input of this script are csv files created by `str_simulation.py` and `unstr_simulation.py`. The comparisons are  based on the Kolmogorov–Smirnov test.

### Classiﬁcation of simulated trees as structured or non-structured based on their tree statistics
The `classification.R` takes as input two csv files created by `str_simulation.py` or `unstr_simulation.py`. Majorly, it uses `Caret` package for parameter tuning and model training at 10-fold cross validation. Model performance is assessed using four metrics, that is; accuracy, sensitivity, specificify and area under the receiver operating characteristic curve.

### Validation of the simulation procedure using R0 estimates based on cherry to tip ratio
The `CTR_analysis.R` script takes a csv file created by either `str_simulation.py` or `unstr_simulation.py`, computes cherry to tip ratio and finally computes the basic reproductive number as a function of CTR.

### Applying models to real world genomic data
The `compute_realdata_statistics.py` script reads a file containing trees (in newick format, single tree per line) generated from actual sequence data. It outputs a csv file containing values for the eight tree shape statistics for each tree. The script `classify_realdata.R` takes the csv file created by  the `compute_realdata_statistics.py` script and a model object created by `classification.R` script. It reports a matrix showing number of trees classified as either structured or unstructured.  
