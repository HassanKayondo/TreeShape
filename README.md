# TreeShape
Employing phylogenetic tree shape statistics to resolve the underlying host population structure

The structure of this repository is as shown below. Tree statistics generated for three parameter sets are located in three sub-folders of the Data folder. The scripts used for analysis are located in the scripts folder. Trees used for computing Cherry to tip ratio (CTR) are located in the CTR sub-folder.

```
TreeShape
│   README.md  
│
└───Data
│   │___Dataset1
|   |       structured.csv
|   |       unstructured.csv
|   |
│   │___Dataset2
|   |       structured.csv
|   |       unstructured.csv
|   |
│   │___Dataset3
|   |       structured.csv
|   |       unstructured.csv
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
Three sets of data were generated using the `simulate_trees.py` script for three different sets of parameters as specified below;

* Dataset1: <img src="https://latex.codecogs.com/svg.latex?\lambda_{1}=0.01,\lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" title="\lambda_{1}=0.01, \lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" />

* Dataset2: <img src="https://latex.codecogs.com/svg.latex?\lambda_{1}=0.01,\lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" title="\lambda_{1}=0.01, \lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" />

* Dataset3:<img src="https://latex.codecogs.com/svg.latex?\lambda_{1}=0.01,\lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" title="\lambda_{1}=0.01, \lambda_{2}=0.003,\mu_{1}=0.001,\mu_{2}=0.001,\gamma_{12}=0.001,\gamma_{21}=0.003" />

### Classification algorithms


### Generating Box-plots and comparing 


### Cherry to tip ratio (CTR) and Basic reproductive number
