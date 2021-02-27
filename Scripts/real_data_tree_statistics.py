import numpy as np
from datetime import datetime
import tree_shape_statistics as ts

if __name__ == '__main__':
    startTime = datetime.now()
    print(startTime)
    fileName='subpopn1.fasta.ufboot' #file of newick trees (one tree per line)
    tree_bootstraps=open(fileName, 'r')
    trees=tree_bootstraps.readlines()
    count=0
    statics_matrix = np.zeros(shape=(0,8))
    for t in trees:
        tree=Tree(t.strip())
        statics=ts.compute_tree_shape_stats(tree)
        statics_matrix = np.append(statics_matrix, [statics], axis=0)
        print("Tree"+str(count))
        count+=1
    np.savetxt(fileName+"_stats"+".csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")	#save results to file
    print("Time taken on calculating stats for dataset "+fileName)
    print(datetime.now() - startTime)
    print('Completed!')
    tree_bootstraps.close()