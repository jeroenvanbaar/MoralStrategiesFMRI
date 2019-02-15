import sys, glob, os, scipy
import numpy as np
import pandas as pd
from scipy.optimize import least_squares
from scipy.io import loadmat

import costFunctions
import choiceModels
import penalizedModelFit

base_dir = 'yourprojectfolderhere'

# Arguments
thetaPhiRow = int(sys.argv[1])
trueTheta = float(sys.argv[2])
truePhi = float(sys.argv[3])
niter = int(sys.argv[4]) # This takes the number of iterations for the fitting algorithm
fitIteration = int(sys.argv[5])

# Load trial set
dat = pd.read_csv(os.path.join(base_dir,'Data/1.TaskBehavior/trialSet.csv'),header=0,index_col=0)
dat.columns = ['inv','mult']
dat.head()

# Simulate data
trueDat = dat.copy()
for j,trial in trueDat.iterrows():
    inv,mult = trial
    trueDat.loc[j,'ret'] = choiceModels.MP_model_ppSOE(inv,mult,0,trueTheta,truePhi)
trueDat['exp'] = 0

# Fit
fitIters = np.zeros([niter,5])
for i in range(niter):
    param0 = [scipy.random.uniform()/2,scipy.random.uniform()/5-0.1]
    fitIters[i,0:2] = param0[:]
    res_lsq = least_squares(costFunctions.MP_ppSOE_costfun, param0, args=(trueDat,),
                            kwargs={'printStep':False,'resid_share':False},
                            diff_step=.05,bounds=([0,-.1],[.5,.1]),)
    theta,phi = res_lsq.x
    cost = res_lsq.cost
    fitIters[i,2:5] = [theta,phi,cost]
cost_selected = np.min(fitIters[:,4]) #Minimal cost
theta = fitIters[fitIters[:,4]==cost_selected,2][0] # First theta with minimal cost
phi = fitIters[fitIters[:,4]==cost_selected,3][0] # First theta with minimal cost
print trueTheta, truePhi, theta, phi

# STORE RESULTS
results = pd.DataFrame([[fitIteration,thetaPhiRow,trueTheta,truePhi,theta,phi,cost_selected]],columns=[
    'fitIteration','thetaPhiRow','trueTheta','truePhi','theta','phi','cost'])
folder = os.path.join(base_dir,'Results/1.Behavior-FitModels/ParameterRecovery/A_RecoverFromGrid')
if not os.path.exists(folder):
    os.makedirs(folder)
results.to_csv('%s/ThetaPhiRow-%i_fitIter-%i_niter-%i.csv'%(folder,thetaPhiRow,fitIteration,niter))
