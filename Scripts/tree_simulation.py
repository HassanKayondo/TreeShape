#! /usr/local/bin/python3
from ete3 import Tree, TreeStyle, NodeStyle, TextFace
import random
import numpy as np
import pandas as pd
from itertools import combinations

#function to label leaves
def name_leaves(tree):
	counter=1
	leaves = tree.get_leaves()
	for leaf in leaves:
		leaf.name = "l_%d" %counter
		counter+=1
	return tree

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
	for node in tree.traverse("preorder"): 
		if (not node.is_leaf()):
			node_children = node.get_children()
			#print(node_children)
			if(len(node_children)==1 & node_children[0].is_leaf()):
				lad_leg+=1
	lad_leg=lad_leg/norm_cons
	return(lad_leg)

#function to compute tree imbalance matrix
def treeImbalanceMatrix(tree):
	mat = np.zeros(shape=(0, 3), dtype=np.int)
	s1_nodes = tree.search_nodes(label="s1")
	s2_nodes = tree.search_nodes(label="s2")
	#print(len(s1_nodes)+len(s2_nodes))
	#print(len(tree.get_descendants()))
	for node in tree.traverse("preorder"): 
		node_children = node.get_children()
		if (not node.is_leaf()):
			if(len(node_children)>1):
				child1, child2 = node_children
				cleft, cright = len(child1.get_leaves()), len(child2.get_leaves())
				
				if node in s1_nodes:
					group = "s1"
				else:
					group = "s2"

				mat = np.append(mat, [[cleft, cright, group]], axis=0)
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
	mat = np.zeros(shape=(0, 2), dtype=np.int)
	s1_nodes = tree.search_nodes(label="s1")
	s2_nodes = tree.search_nodes(label="s2")

	for node in tree.get_leaves():
		
		depth = len(node.get_ancestors()) #-1
				
		if node in s1_nodes:
			group = "s1"
		else:
			group = "s2"

		mat = np.append(mat, [[depth, group]], axis=0)
	
	return(mat)

#function to compute number of cherries
def cherries(imbMatrix, n=None, norm=False): #n is the size of the tree, norm is a binary varible specifying 
	#whether to normalise the tree or not
	mat = imbMatrix[(imbMatrix[:,0]=='1')&(imbMatrix[:,1]=='1')] #pick only cherries
	cherriz = mat.shape[0] #getting number of cheries
	if norm and n!=None: #normalising the cherries
		cherriz = cherriz*2/n
	return cherriz

#function to compute number of the colless index
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

#function to color nodes
def colornodes(subpop): 
	if subpop=="s1":
		return "red"
	else:
		return "green"

def colormigrant(subpop): #coloring migrants
	if subpop=="s1":
		return "green"
	else:
		return "red"

#Defining a birth event
def birth(tree, node, subpop, setpop): #subpop is the subpopulation where the event is to occur, 
#setpop is the set of nodes in subpop
	child1, child2 = Tree(), Tree()
	child1.dist, child2.dist = 0, 0
	child1.add_features(extinct=False)
	child2.add_features(extinct=False)
	#add children to nodes
	node.add_child(child1)
	node.add_child(child2)
	#add the new nodes to correspoding set
	setpop.add(child1)
	setpop.add(child2)
	#add styles to the new nodes
	nstyle = NodeStyle()
	nstyle["fgcolor"] = colornodes(subpop)
	child1.set_style(nstyle)
	child2.set_style(nstyle)
	return tree, setpop

#defining a migration event
def migration(tree, node, subpop, sourcepop, targetpop): #sourcepop, targetpop are the sets for the 
	migrant = Tree()
	migrant.dist = 0.0
	migrant.add_features(extinct=False)
	node.add_child(migrant)
	#migrant styling
	mstyle = NodeStyle()
	mstyle["fgcolor"] = colormigrant(subpop)
	migrant.set_style(mstyle)
	sourcepop.remove(node)
	targetpop.add(migrant)
	return tree, sourcepop, targetpop

#Initialising the birth-death-miration process
def initialise(subpop, subprate, setpop1, setpop2):
	tree = Tree()
	tree.add_features(extinct=False)
	tree.dist = 0.0
	setpop1.add(tree)
	node = random.choice(tree.get_leaves())

	nstyle = NodeStyle()
	nstyle["fgcolor"] = colornodes(subpop)
	node.set_style(nstyle)
	node.add_feature("label",subpop)
	tree, setpop1 = birth(tree, node, subpop, setpop1)

	leaf_nodes = tree.get_leaves()
	wtime = random.expovariate(subprate)
	for leaf in leaf_nodes:
			if not leaf.extinct:
				leaf.dist += wtime
	#randomly select a node amongst the tree leaves
	mnode = random.choice(leaf_nodes)
	tree, source, target = migration(tree, mnode, subpop, setpop1, setpop2)
	return tree, source, target

#defining a death event
def death(tree, node, setpop, died): #died is a se for the dead, setpop is the set where the victim is picked
	node.extinct = True #kill the node
	died.add(node) #add to died
	setpop.remove(node) #make sure extinct nodes are removed to avoid errors arising from adding features to extinct nodes 
	return tree, died, setpop

#random choice of a node to under go an event
def choose_node(tree, setpop):
	leaf_nodes = set(tree.get_leaves())
	potential_nodes = list(leaf_nodes & setpop) #only select nodes from specified sub population
	if len(potential_nodes) > 0:
		select_node = random.choice(potential_nodes)
		return select_node
	else:
		return None
	
#defining waiting times
def waiting_times(rate_s1, rate_s2):
	#choose the sub-population in which the event should happen
    total_rate = rate_s1 + rate_s2
    subp = ""
    prob_s1 = rate_s1/(total_rate)#0.5 #insert expression to be used to decide sub-population
    sprob = random.random()
    if sprob <= prob_s1:
        subp = "s1"
        # waiting time based on event_rate
        wtime = random.expovariate(rate_s1)
    else:
        subp = "s2"
        # waiting time based on event_rate
        wtime = random.expovariate(rate_s2)
    return subp, wtime

#choosing an event to occur given different event rates
def event(eprob, lamda, gamma, subrate, subp, tree, node, source_set, target_set, died):
	
	if eprob < lamda / subrate :
		tree, setpop = birth(tree, node, subp, source_set)
	elif eprob < (lamda + gamma) / subrate:
		tree, source_set, target_set = migration(tree, node, subp, source_set, target_set)
	else:
		tree, died, source_set = death(tree, node, source_set, died) #this only takes extinct lineages
	return tree, source_set, target_set

#definign the birth-death-migration process
def birth_death_migration(nsize1, nsize2,
	birth1, birth2, death1, death2, 
	gamma12, gamma21):
	#compute total population size
	nsize = nsize1 + nsize2
	
	total_time = 0.0 #initial time
	died = set([])   #set to track dead individuals
	s1 = set([])     #set to accomodate members of the S1 sub-population
	s2 = set([])     #set to accomodate members of the S2 sub-population

	# total event rate to compute waiting time per sub population
	event_rate_s1 = float(birth1 + death1 + gamma12)
	event_rate_s2 = float(birth2 + death2 + gamma21)

	#the initiatial events happen in subpopulation s1
	tree, s1, s2 = initialise("s1",event_rate_s1,s1, s2) #we need to have better naming for the subpopulation events
	#curr_num_leaves = len(tree.get_leaves())

	#boolean variable to track process till stop
	done = False
	counter = 1
	while True:
		#print(s2)
		#print(len(tree.get_leaves()))
		leaf_nodes = tree.get_leaves()
		curr_num_leaves = len(leaf_nodes)
		#specify stopping criterion
		if curr_num_leaves == nsize:
			done = True
			break
		#get sub population in which event should occur currently
		#in addition get waiting time to next event 
		subp, wtime = waiting_times(event_rate_s1, event_rate_s2) 
		total_time += wtime

		#update the distance of live lineages using waiting time
		for leaf in leaf_nodes:
			if not leaf.extinct:
				leaf.dist += wtime

		#get a probability to be used in specifying which event is to happen		
		eprob = random.random()
		
		#choose a node from a specified sub population and perform the event
		if subp=="s1":
			node = choose_node(tree, s1)
			
			if node == None:
				pass
			else:
				#node.name = "N_%d" %counter
				node.add_feature("label",subp)
				tree, s1, s2 = event(eprob, birth1, gamma12, event_rate_s1, "s1", tree, node, s1, s2, died)
		else:
			node = choose_node(tree, s2)
			
			if node == None:
				pass
			else:
				#node.name = "N_%d" %counter
				node.add_feature("label",subp)
				tree, s2, s1 = event(eprob, birth2, gamma21, event_rate_s2, "s2", tree, node, s2, s1, died)
		counter+=1
			

	#note that the lesfnodes dont undergo any event and as such, they are not labelled, so label them here
	for node in tree.get_leaves():
		if node in s1:
			node.add_feature("label","s1")
		else:
			node.add_feature("label","s2")

	#for node in leaf_nodes:
	#	node.add_face(TextFace(node.name), column=0, position="branch-top")

	#add names to tree leaves
	tree = name_leaves(tree)

	assert curr_num_leaves == len(leaf_nodes)
	
	return tree

""" Execute the birth-death-migration process 
	given a set of parameters and compute the 
	tree statistics.
 """
if __name__ == '__main__':

	statics_matrix = np.zeros(shape=(0,8))
	for i in range(10):
		bdtree = birth_death_migration(
	    nsize1=100, nsize2=100,
		birth1=0.5, birth2=0.5, 
		death1=0.01, death2=0.01, 
		gamma12=0.02, gamma21=0.02)
	    
	    #get size of the tree
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
		statics_matrix = np.append(statics_matrix, [[cheriz, colless_ind, sackid, total_coph, ladder, width, depth, wid_dep]], axis=0)
	#save results to file
	np.savetxt("TEST_nonstructured_200_tips_50_trees.csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")