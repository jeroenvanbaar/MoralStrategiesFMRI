import sys, glob, os, scipy
import numpy as np
import pandas as pd
from scipy.optimize import least_squares
from scipy.io import loadmat

import costFunctions
import choiceModels
import penalizedModelFit

from sklearn.model_selection import KFold

base_dir = 'yourprojectfolderhere'

# Arguments
sub = int(sys.argv[1]) # This takes the subject number
niter = int(sys.argv[2]) # This takes the number of iterations for the fitting algorithm
jobs_iteration = int(sys.argv[3]) # This takes the number of job iterations / output folder index
n_folds = int(sys.argv[4]) # Number of folds in CV
shuffle = str(sys.argv[5]) # Shuffle before folding

# Load data
dat = pd.read_csv(os.path.join(base_dir,'Data/1.TaskBehavior/allDataLong.csv'),header=None,index_col=None)
dat.columns=['sub','inv','mult','ret','exp','fair','soc1','soc2']
dat = dat.loc[dat['inv']>0,:]
subDat = dat.loc[dat['sub']==sub,:].reset_index(drop=True)

# Fit
import time
residShareChoice=False

results = pd.DataFrame(columns=['sub','model','fold','test','theta','phi','SSE','AIC','BIC'])
    
# Fold
kf = KFold(n_splits=n_folds,shuffle=(shuffle=='True'))
i_fold = 0
for train_index, test_index in kf.split(subDat):
#     print("TRAIN:", train_index, "TEST:", test_index)
    foldDat = subDat.iloc[train_index,:].copy().reset_index()

    # MP MODEL (second-order expectations fixed across subjects)
    model = 'MP_ppSOE'
    start = time.time()
    print 'subject %s model %s' %(sub,model),

    fitIters = np.zeros([niter,5])
    for i in range(niter):
        param0 = [scipy.random.uniform()/2,scipy.random.uniform()/5-0.1]
        fitIters[i,0:2] = param0[:]
        res_lsq = least_squares(costFunctions.MP_ppSOE_costfun, param0, args=(foldDat,),
                                kwargs={'printStep':False,'resid_share':residShareChoice},
                                diff_step=.05,bounds=([0,-.1],[.5,.1]),)
        theta,phi = res_lsq.x
        cost = res_lsq.cost
        fitIters[i,2:5] = [theta,phi,cost]
    cost_selected = np.min(fitIters[:,4]) #Minimal cost
    theta = fitIters[fitIters[:,4]==cost_selected,2][0] # First theta with minimal cost
    phi = fitIters[fitIters[:,4]==cost_selected,3][0] # First theta with minimal cost
    SSE = cost_selected*2
    AIC = penalizedModelFit.compute_AIC(subDat.shape[0],SSE,2)
    BIC = penalizedModelFit.compute_BIC(subDat.shape[0],SSE,2)
    results = results.append(pd.DataFrame([[sub,model,i_fold,test_index,theta,phi,SSE,AIC,BIC]],columns=results.columns))

    print 'took %.2f seconds to converge on theta = %.3f and phi = %.3f with SSE = %.2f'%(
        time.time() - start,theta,phi,SSE)
    
    i_fold += 1
    
# STORE RESULTS
results = results.reset_index(drop=True)
folder = os.path.join(base_dir,'Results/1.Behavior-FitModels/Iteration_%i'%jobs_iteration)
if not os.path.exists(folder):
    os.makedirs(folder)
if shuffle=='True':
    results.to_csv('%s/Results_sub-%03d_%i-folds_shuffled.csv'%(folder,sub,n_folds))
else:
    results.to_csv('%s/Results_sub-%03d_%i-folds.csv'%(folder,sub,n_folds))