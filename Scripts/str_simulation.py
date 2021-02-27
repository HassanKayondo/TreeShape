from ete3 import Tree, TreeStyle, NodeStyle, TextFace
import numpy as np
from datetime import datetime
from smt.sampling_methods import LHS
import tree_shape_statistics as ts
import model_functions as mf

""" Execute the birth-death-migration process 
	given a set of parameters and compute the 
	tree statistics.
 """
if __name__ == '__main__':
	startTime = datetime.now()
	print(startTime)
	num_trees=500

	#Baseline parameters
	#low risk
	base_death=0.014
	base_r0=4.99
	base_birth=base_r0/base_death
	base_n_tips=350
	base_migration=0.30
	
	#high risk
	base_death2=3*base_death
	base_r02=9.09
	base_birth2=base_r02/base_death2
	base_n_tips2=200
	base_migration2=0.20

	#Sensitivity analysis parameters
	#low risk
	base_death_lower,base_death_upper=0.01,0.02
	base_r0_lower,base_r0_upper=0.45,6.34
	base_birth_lower=base_r0_lower/base_death_lower
	base_birth_upper=base_r0_upper/base_death_upper
	base_n_tips_lower, base_n_tips_upper = 300,400
	base_migration_lower,base_migration_upper=0.18,0.44

	#high risk
	base_death2_lower,base_death2_upper=3*base_death_lower,3*base_death_upper
	base_r02_lower,base_r02_upper=4.18,36.75
	base_birth2_lower=base_r02_lower/base_death2_lower
	base_birth2_upper=base_r02_upper/base_death2_upper
	base_n_tips2_lower, base_n_tips2_upper = 150,250
	base_migration2_lower,base_migration2_upper=0.10,0.33
	
	print('####### Varying the tree size for constant parameters ########')
	statics_matrix = np.zeros(shape=(0,8))
	filename='baseline_str_'
	for i in range(num_trees):
		bdtree = mf.birth_death_migration(base_n_tips, base_n_tips2,
		base_birth, base_birth2, 
		base_death, base_death2, 
		base_migration, base_migration2)
		print("Tree"+str(i))
		statics=ts.compute_tree_shape_stats(bdtree)
		statics_matrix = np.append(statics_matrix, [statics], axis=0)
		#save tree shape stats to file
	np.savetxt(filename+"stats"+".csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")	#save results to file
	print("Time taken on simulating baseline dataset")
	print(datetime.now() - startTime)

	print('####### Varying the tree size for constant parameters ########')
	filename='variedNumTrees_str_'
	statics_matrix = np.zeros(shape=(0,8))
	
	tiplimits = np.array([[base_n_tips_lower, base_n_tips_upper]
						,[base_n_tips2_lower, base_n_tips2_upper]])
	tip_sampling = LHS(xlimits=tiplimits)
	tip_vec=tip_sampling(num_trees)
	
	for i in range(num_trees):
		nsize1,nsize2=int(tip_vec[i][0]), int(tip_vec[i][1])
		bdtree = mf.birth_death_migration(nsize1, nsize2,
		base_birth, base_birth2,base_death, base_death2, 
		base_migration, base_migration2)
		print("Tree"+str(i))
		statics=ts.compute_tree_shape_stats(bdtree)
		statics_matrix = np.append(statics_matrix, [statics], axis=0)
		#save parametres and tree shape stats to file
	np.savetxt(filename+"stats"+".csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")	#save results to file
	print("Time taken on simulating dataset for"+filename)
	print(datetime.now() - startTime) 
######################################################
	
	statics_matrix = np.zeros(shape=(0,8))
	filename='variedParameters_str_'
	print('####### Varying parameters while keeping constant tree size ########')
	
	r0_limits=np.array([[base_r0_lower,base_r0_upper],
			[base_r02_lower,base_r02_upper]])
	r0_sampling=LHS(xlimits=r0_limits)
	r0_vec=r0_sampling(num_trees)

	death_limits=np.array([[base_death_lower, base_death_upper],
				[base_death2_lower, base_death2_upper]])
	death_sampling=LHS(xlimits=death_limits)
	death_vec=death_sampling(num_trees)

	migration_limits=np.array([[base_migration_lower,base_migration_upper],
				  [base_migration2_lower,base_migration2_upper]])
	migration_sampling=LHS(xlimits=migration_limits)
	migration_vec=migration_sampling(num_trees)
	
	for i in range(num_trees):
		r01,r02=r0_vec[i][0],r0_vec[i][1]#np.random.uniform(1.25,2.5) #sensitivity on R0 hence the paramters
		death1,death2=death_vec[i][0], death_vec[i][1]
		gamma12,gamma21=migration_vec[i][0], migration_vec[i][1]
		birth1=r01*(death1+gamma12)
		birth2=r02*(death2+gamma21)
		bdtree = mf.birth_death_migration(base_n_tips, base_n_tips2,
		birth1, birth2, death1, death2,gamma12, gamma21)
		print("Tree"+str(i))
		statics=ts.compute_tree_shape_stats(bdtree)
		statics_matrix = np.append(statics_matrix, [statics], axis=0)
		#save parametres and tree shape stats to file
	np.savetxt(filename+"stats"+".csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")	#save results to file
	print("Time taken on simulating dataset for"+filename)
	print(datetime.now() - startTime) 
#######################################################
	statics_matrix = np.zeros(shape=(0,8))
	filename='variedBoth_str_'
	print('####### Varying both the tree size and parameters ########')
	for i in range(num_trees):
		r01,r02=r0_vec[i][0],r0_vec[i][1]#np.random.uniform(1.25,2.5) #sensitivity on R0 hence the paramters
		death1,death2=death_vec[i][0], death_vec[i][1]
		gamma12,gamma21=migration_vec[i][0], migration_vec[i][1]
		birth1=r01*(death1+gamma12)
		birth2=r02*(death2+gamma21)

		nsize1=int(tip_vec[i][0])#int(np.random.uniform(20,50)) #sensitivity on tree size
		nsize2=int(tip_vec[i][1])#int(np.random.uniform(20,50)) #sensitivity on tree size

		bdtree=mf.birth_death_migration(nsize1, nsize2,
		birth1, birth2, death1, death2, gamma12, gamma21)
		print("Tree"+str(i))
		statics=ts.compute_tree_shape_stats(bdtree)
		statics_matrix = np.append(statics_matrix, [statics], axis=0)
		#save tree shape stats to file
	np.savetxt(filename+"stats"+".csv", statics_matrix, delimiter=",", header="Cherries,colless,sackin,total_cophenetic,ladder,width,depth,wid_dep_ratio")	#save results to file
	print("Time taken on simulating dataset for"+filename)
	print(datetime.now() - startTime)
	print('Completed!')