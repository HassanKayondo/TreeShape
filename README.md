# TreeShape
Employing phylogenetic tree shape statistics to resolve the underlying host population structure

The structure of this repository is as shown below. Tree statistics generated for three parameter sets are located in three sub-folders of the Data folder. The scripts used for analysis are located in the scripts folder. Trees used for computing Cherry to tip ratio (CTR) are located in the CTR sub-folder.

```
TreeShape
│   README.md  
│
└───Data
│   │___Dataset1
|   |   |   structured.csv
|   |   |   unstructured.csv
|   |
│   │___Dataset2
|   |   |   structured.csv
|   |   |   unstructured.csv
|   |
│   │___Dataset3
|   |   |   structured.csv
|   |   |   unstructured.csv
|   |
│   └───CTR
│       │   tree1.tree
│       │   tree2.tree
|       |   treen.tree
│   
└───Scripts
    │   file1.R
    │   file2.R
    │   file3.py
    
```

### Simulating trees
Three sets of data were generated using the `simulate_trees.py` script for three different pairs of parameter sets as specified below;

* Dataset1: 
    * Structured: <img src="https://latex.codecogs.com/svg.latex?\lambda_{1}=0.01,\lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" title="\lambda_{1}=0.01, \lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" />

    * Non-structured: <img src="https://latex.codecogs.com/svg.latex?\lambda_{1}=0.01,\lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" title="\lambda_{1}=0.01, \lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" />

* Dataset2: 
    * Structured: <img src="https://latex.codecogs.com/svg.latex?\lambda_{1}=0.01,\lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" title="\lambda_{1}=0.01, \lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" />

    * Non-structured: <img src="https://latex.codecogs.com/svg.latex?\lambda_{1}=0.01,\lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" title="\lambda_{1}=0.01, \lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" />
    
* Dataset3:
    * Structured: <img src="https://latex.codecogs.com/svg.latex?\lambda_{1}=0.01,\lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" title="\lambda_{1}=0.01, \lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" />

    * Non-structured: <img src="https://latex.codecogs.com/svg.latex?\lambda_{1}=0.01,\lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" title="\lambda_{1}=0.01, \lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" />

### Comparing tree statistics between structured and un-structured populations

This is done using the `compare_stats.R` script. The input of this script are csv files created by `simulate_trees.py` script. The comparisons are mainly based on the Kolmogorov–Smirnov test. Boxplots are used to visualise the results.

### Classification

We built ML models that use tree shape statistics mentioned above to classify trees as structured or un-structured. This is done using the `classifiers.R` script. The script takes as input csv files created by `simulate_trees.py` script. Majorly, it uses `Caret` package for parameter tuning and model training at 10-fold cross validation. Model performance is assessed using four metrics, that is; accuracy, sensitivity, specificify and area under the receiver operating characteristic curve.

### Cherry to tip ratio (CTR) and Basic reproductive number
