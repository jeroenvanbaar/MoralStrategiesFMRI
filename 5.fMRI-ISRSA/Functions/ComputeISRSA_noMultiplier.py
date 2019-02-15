
import os, sys, glob, scipy
import numpy as np
import pandas as pd
from scipy.stats import spearmanr

# Arguments
screen = str(sys.argv[1])
# cond = str(sys.argv[2])
nparcel = int(sys.argv[2])
parcel = int(sys.argv[3])
metric_model = str(sys.argv[4])
metric_brain = str(sys.argv[5])
permutation_method = str(sys.argv[6])
n_permute = int(sys.argv[7])

# Select participants
base_dir = 'yourprojectfolderhere'
oldSubs = np.array(pd.read_csv(os.path.join(base_dir,'Data/subjectsIncluded_batch1.csv'),header=None,index_col=None))[0]
newSubs = np.array(pd.read_csv(os.path.join(base_dir,'Data/subjectsIncluded_batch2.csv'),header=None,index_col=None))[0]
fullSample = np.hstack([oldSubs,newSubs])
subNums = fullSample
params = pd.read_csv(os.path.join(base_dir,'Results/2.Behavior-ClusterModel/ParticipantClustering.csv'),index_col=0)
subIndices = np.where(pd.DataFrame(fullSample).isin(subNums))[0]

# Compute model distance
modelDist = scipy.spatial.distance.pdist(params.loc[params['sub'].isin(subNums),['theta','phi']],metric=metric_model)
	
# Data
brainDist = pd.read_csv(os.path.join(base_dir,'Results/3.fMRI-ISRSA/BrainDist/BrainDist_%s_%s_roi%i.csv' % (
				metric_brain,screen,nparcel)))
brainDist = brainDist.iloc[:,parcel]
brainDist_mat = pd.DataFrame(scipy.spatial.distance.squareform(brainDist)).iloc[subIndices,subIndices]
brainDist_vec = brainDist_mat.values[np.triu_indices(len(subIndices),k=1)]

# Operations
corr = spearmanr(modelDist,brainDist_vec)[0]

if n_permute is None:
	pval = spearmanr(modelDist,brainDist_vec)[1]
elif isinstance(n_permute, int):
    perm = []
    if permutation_method == 'vector':
        for p in range(n_permute):
            perm.append(spearmanr(np.random.permutation(modelDist),brainDist_vec)[0])
    if corr>=0:
        perm_p = np.mean(perm>=corr)
    else:
        perm_p = np.mean(perm<=corr)
    pval = perm_p

out = pd.DataFrame([[corr,pval]],columns=['r','p'])
pathCur = os.path.join(base_dir,
        'Results/3.fMRI-ISRSA/IS-RSA/IS-RSA_nparcel-%i_perm-%s_%s/'%(
        nparcel,permutation_method,screen))
# if ~os.path.exists(pathCur):
#     os.mkdir(pathCur)
out.to_csv(os.path.join(pathCur,'parcel%03d.csv'%(parcel)))