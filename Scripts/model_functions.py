from ete3 import Tree, TreeStyle, NodeStyle, TextFace
import random
import numpy as np
#import pandas as pd
from datetime import datetime
from smt.sampling_methods import LHS

#Defining a birth event
def birth(tree, node): #subpop is the subpopulation where the event is to occur, 
#setpop is the set of nodes in subpop
	child1, child2 = Tree(), Tree()
	child1.dist, child2.dist = 0, 0
	child1.add_features(extinct=False)
	child2.add_features(extinct=False)
	#add children to nodes
	node.add_child(child1)
	node.add_child(child2)
	return tree

#Initialising the birth-death process
def initialise(rate):
	tree = Tree()
	tree.add_features(extinct=False)
	tree.dist = 0.0
	node = random.choice(tree.get_leaves())
	tree = birth(tree, node)
	leaf_nodes = tree.get_leaves()
	wtime = random.expovariate(rate)
	for leaf in leaf_nodes:
			if not leaf.extinct:
				leaf.dist += wtime
	return tree

#defining a death event
def death(tree, node): #died is a set for the dead, setpop is the set where the victim is picked
	node.extinct = True #kill the node
	nstyle = NodeStyle()
	nstyle["fgcolor"] = 'green'
	node.set_style(nstyle)
	return tree

#random choice of a node to under go an event
def choose_node(tree):
	leaf_nodes = tree.get_leaves()
	if len(leaf_nodes) > 0:
		select_node = random.choice(leaf_nodes)
		return select_node
	else:
		return None
	
#defining waiting times
def waiting_times(rate):
    wtime=random.expovariate(rate)
    return wtime

#choosing an event to occur given different event rates
def event(lamda, rate, tree, node):
    eprob = random.random()
    if eprob < lamda / rate:
        tree = birth(tree, node)
    else:
        tree = death(tree, node) #this only takes extinct lineages
    return tree

#defining the birth-death process
def birth_death(nsize,birth, death):	
	total_time = 0.0 #initial time
	# total event rate to compute waiting time
	rate = float(birth + death)
	tree = initialise(rate)
	#boolean variable to track process till stop
	done = False	
	while True:	
		leaf_nodes = tree.get_leaves()
		curr_num_leaves = len(leaf_nodes)
		#get waiting time to next event 
		wtime = waiting_times(rate) 
		total_time += wtime
		#update the distance of live lineages using waiting time
		for leaf in leaf_nodes:
			if not leaf.extinct:
				leaf.dist += wtime
			else:
				leaf.delete() #remove extinct nodes
		#specify stopping criterion
		if curr_num_leaves == nsize:
			done = True
			break
		#tree=prune_live_nodes(tree)
		node = choose_node(tree)	
		if node == None:
			pass
		else:
			tree=event(birth, rate, tree, node)				 
		assert curr_num_leaves == len(leaf_nodes)
	#add names to tree leaves
	tree = name_leaves(tree)
	return tree

#function to label leaves
def name_leaves(tree):
	counter=1
	leaves = tree.get_leaves()
	for leaf in leaves:
		leaf.name = "l_%d" %counter
		counter+=1
	return tree
