import numpy as np
from itertools import combinations

#function of cophenetic statistic
def total_cophenetic(tree):
	leaves = tree.get_leaves()
	leaf_pairs = list(combinations(leaves, 2))
	total_cophenetic_index = 0
	for leaf_pair in leaf_pairs:
		l1 = leaf_pair[0].name
		l2 = leaf_pair[1].name
		pair_parent = tree.get_common_ancestor(l1,l2) 
		cophenetic_index =  len(list(pair_parent.get_ancestors()))  
		total_cophenetic_index = total_cophenetic_index + cophenetic_index 
		#print(cophenetic_index)
	return total_cophenetic_index

#function to compute ladder length
def ladder_length(tree):
	leaves = tree.get_leaves()
	norm_cons = len(leaves)
	lad_leg = 0.
	set_leaves=set(leaves)
	for node in tree.traverse("preorder"): 
		if (not node.is_leaf()):
			node_children = set(node.get_children())
			leaf_children = list(set_leaves & node_children)
			if(len(leaf_children)==1):
				lad_leg+=1
	lad_leg=lad_leg/norm_cons
	return(lad_leg)

#function to compute tree imbalance matrix
def treeImbalanceMatrix(tree):
	mat = np.zeros(shape=(0, 2), dtype=np.int)
	for node in tree.traverse("preorder"): 
		node_children = node.get_children()
		if (not node.is_leaf()):
			if(len(node_children)==2):
				child1, child2 = node_children
				cleft, cright = len(child1.get_leaves()), len(child2.get_leaves())
				mat = np.append(mat, [[cleft, cright]], axis=0)
	return(mat)

#function to compute node depth
def nodeDepth(tree):
	depth_vec=[]
	for node in tree.traverse("preorder"): 
		depth=len(node.get_ancestors())
		depth_vec.append(depth)
	return(depth_vec)

#function to compute ratio of maximum width to maximum depth 
def max_width_depth(tree):
	node_depth = nodeDepth(tree)
	depth, width = np.unique(node_depth, return_counts=True)
	mat = np.column_stack((depth, width))
	max_width = max(mat[:,1])
	max_depth = max(node_depth)
	width_depth = max_width/max_depth
	return max_depth, max_width, width_depth

#function to compute leaf depth matrix
def leafDepthMatrix(tree):
	mat = np.zeros(shape=(0, 1), dtype=np.int)
	for node in tree.get_leaves():
		depth = len(node.get_ancestors()) #-1
		mat = np.append(mat, [[depth]], axis=0)
	return(mat)

#function to compute number of cherries
def cherries(imbMatrix, n=None, norm=False): #n is the size of the tree, norm is a binary varible specifying 
	#whether to normalise the tree or not
	mat = imbMatrix[(imbMatrix[:,0]==1)&(imbMatrix[:,1]==1)] #pick only cherries
	cherriz = mat.shape[0] #getting number of cheries
	if norm and n!=None: #normalising the cherries
		cherriz = cherriz*2/n
	return cherriz

#function to compute the colless index
def colless(imbMatrix, n=None, norm=False):
	mat = (imbMatrix[:, :2]).astype(int) #pick the first two columns of imbalance matrix, make sure the matrix had int values
	colless_indx = sum(abs(mat[:,0]-mat[:,1]))  #compute colless index
	if norm and n!=None:
		norm_cons=float((n-1)*(n-2)/2) #normalising constant
		#print(norm_cons)
		colless_indx=colless_indx/norm_cons #normalised colless index
	return colless_indx

#function to compute the Sackin index
def sackin(depthMatrix, n=None, norm=False):
	mat = (depthMatrix[:,0]).astype(int) #get the depth as integers
	sack_indx = sum(mat) #compute the sackin index
	if norm and n!=None:
		norm_cons = 0.5*(n*(n+1))-1
		#print(norm_cons)
		sack_indx=sack_indx/norm_cons
	return sack_indx

#compute tree shape stats given a phylogeny
def compute_tree_shape_stats(bdtree):
	n = len(bdtree.get_leaves())
	#compute tree imbalance matrix
	matImb=treeImbalanceMatrix(bdtree)
	#compute cherries
	cheriz = cherries(matImb, n, norm=True)
	#compute colless index
	colless_ind = colless(matImb, n, norm=True)
	#compute depth matrix and use it to compute sackin index
	matDep=leafDepthMatrix(bdtree)
	sackid = sackin(matDep, n, norm=True)
	#calculate cophetic index
	total_coph = total_cophenetic(bdtree)
	#compute ladder-length
	ladder = ladder_length(bdtree)
	#compute width, depth and widthto depth ratio
	width, depth, wid_dep = max_width_depth(bdtree)
	#combine stats in single matrix
	shape_stats = [cheriz, colless_ind, sackid, total_coph, ladder, width, depth, wid_dep]
	return shape_stats