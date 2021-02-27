from ete3 import Tree, TreeStyle, NodeStyle, TextFace
import numpy as np
from datetime import datetime
from smt.sampling_methods import LHS
import tree_shape_statistics as ts
import model_functions as mf

"""Execute the birth-death-migration process
given a set of parameters and compute the 	
tree statistics."""

if __name__ == '__main__':
	startTime = datetime.now()
	print(startTime)
	num_trees=500 #number of trees to generate say 500
	
	#Baseline parameters
	base_death=3*0.014
	base_r0=9.09
	base_birth=base_r0/base_death
	base_n_tips=10

	#Sensitivity analysis parameters
	base_death_lower,base_death_upper=3*0.01,3*0.02
	base_r0_lower,base_r0_upper=4.18,36.75
	base_birth_lower=base_r0_lower/base_death_lower
	base_birth_upper=base_r0_upper/base_death_upper
	base_n_tips_lower, base_n_tips_upper=150,250
	
	#######################
	print('####### Baseline run ########')
	filename='baseline_'
	statics_matrix = np.zeros(shape=(0,8))
	for i in range(num_trees):
		print("Tree"+str(i))
		bdtree=mf.birth_death(base_n_tips,base_birth,base_death)
		statics=ts.compute_tree_shape_stats(bdtree)
		statics_matrix = np.append(statics_matrix, [statics], axis=0)
		#save tree shape stats to file
	np.savetxt(filename+"stats"+".csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")
	print("Time taken on simulating baseline dataset")
	print(datetime.now() - startTime)

	#######################
	print('####### Varying the tree size for constant parameters ########')
	filename='variedNumTips_'
	statics_matrix = np.zeros(shape=(0,8))
	tiplimits = np.array([[base_n_tips_lower, base_n_tips_upper]])
	tip_sampling = LHS(xlimits=tiplimits)
	tip_vec=tip_sampling(num_trees)
	for i in range(num_trees):
		print("Tree"+str(i))
		nsize=int(tip_vec[i])#int(np.random.uniform(100,150)) #sensitivity on tree size
		bdtree=mf.birth_death(nsize,base_birth,base_death)
		statics=ts.compute_tree_shape_stats(bdtree)
		statics_matrix = np.append(statics_matrix, [statics], axis=0)
	np.savetxt(filename+"stats"+".csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")
	print("Time taken on simulating dataset for varied number of tips and constant parameters")
	print(datetime.now() - startTime)
	
	################
	print('####### Varying parameters while keeping constant tree size ########')
	filename='variedParameters_'
	statics_matrix = np.zeros(shape=(0,8))
	r0_limits = np.array([[base_r0_lower, base_r0_upper]])
	r0_sampling = LHS(xlimits=r0_limits)
	r0_vec=r0_sampling(num_trees)
	death_limits=np.array([[base_death_lower, base_death_upper]])
	death_sampling=LHS(xlimits=death_limits)
	death_vec=death_sampling(num_trees)

	for i in range(num_trees):
		print("Tree"+str(i))
		r0=r0_vec[i]#np.random.uniform(1.25,2.5) #sensitivity on R0 hence the paramters
		death_rate=death_vec[i]
		birth_rate=r0*death_rate
		bdtree=mf.birth_death(base_n_tips,birth_rate,death_rate)
		statics=ts.compute_tree_shape_stats(bdtree)
		statics_matrix = np.append(statics_matrix, [statics], axis=0)
		#save tree shape stats to file
		np.savetxt(filename+"stats"+".csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")
	print("Time taken on simulating dataset for varied paramters and constant number of tips")
	print(datetime.now() - startTime)
	
	####################
	print('####### Varying both the tree size and parameters ########')
	filename='variedBoth_'
	statics_matrix = np.zeros(shape=(0,8))
	for i in range(num_trees):
		print("Tree"+str(i))
		r0=r0_vec[i]#np.random.uniform(1.25,2.5) #sensitivity on R0 hence the paramters
		death_rate=death_vec[i]
		birth_rate=r0*death_rate
		nsize=int(tip_vec[i])#int(np.random.uniform(100,150)) #sensitivity on tree size
		bdtree = mf.birth_death(nsize,birth_rate,death_rate)
		statics=ts.compute_tree_shape_stats(bdtree)
		statics_matrix = np.append(statics_matrix, [statics], axis=0)
		#save tree shape stats to file
	np.savetxt(filename+"stats"+".csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")	
	print("Time taken on simulating dataset for varied paramters and number of tips")
	print(datetime.now() - startTime) """
	print('Completed!')
