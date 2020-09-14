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

* Dataset1: Number of trees=500
    * Structured: <img src="https://latex.codecogs.com/svg.latex?n_1=n_2=100,\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" title="\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" />

    * Non-structured: <img src="https://latex.codecogs.com/svg.latex?n_1=n_2=100,\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" title="\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" />

* Dataset2: Number of trees=500
    * Structured: <img src="https://latex.codecogs.com/svg.latex?n_1=n_2=250,\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" title="\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" />

    * Non-structured: <img src="https://latex.codecogs.com/svg.latex?n_1=n_2=250,\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" title="\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" />
    
* Dataset3: Number of trees=1000
    * Structured: <img src="https://latex.codecogs.com/svg.latex?n_1=n_2=100,\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" title="\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" />

    * Non-structured: <img src="https://latex.codecogs.com/svg.latex?n_1=n_2=100\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" title="\lambda_{1}=1.5,\lambda_{2}=0.5,\mu_{1}=0.03,\mu_{2}=0.01,\gamma_{12}=0.06,\gamma_{21}=0.02" />

### Comparing tree statistics between structured and un-structured populations

This is done using the `compare_stats.R` script. The input of this script are csv files created by `simulate_trees.py` script. The comparisons are mainly based on the Kolmogorov–Smirnov test. Boxplots are used to visualise the results.

### Classification

We built ML models that use tree shape statistics mentioned above to classify trees as structured or un-structured. This is done using the `classifiers.R` script. The script takes as input csv files created by `simulate_trees.py` script. Majorly, it uses `Caret` package for parameter tuning and model training at 10-fold cross validation. Model performance is assessed using four metrics, that is; accuracy, sensitivity, specificify and area under the receiver operating characteristic curve.

### Cherry to tip ratio (CTR) and Basic reproductive number
