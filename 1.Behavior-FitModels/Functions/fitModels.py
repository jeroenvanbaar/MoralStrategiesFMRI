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
sub = int(sys.argv[1]) # This takes the subject number
niter = int(sys.argv[2]) # This takes the number of iterations for the fitting algorithm
jobs_iteration = int(sys.argv[3]) # This takes the number of job iterations / output folder index

# Load data
dat = pd.read_csv(os.path.join(base_dir,'Data/1.TaskBehavior/allDataLong.csv'),header=None,index_col=None)
dat.columns=['sub','inv','mult','ret','exp','fair','soc1','soc2']
dat = dat.loc[dat['inv']>0,:] #Only trials with non-zero investment are of interest
subDat = dat.loc[dat['sub']==sub,:].reset_index(drop=True)

# Fit
import time
residShareChoice=False

results = pd.DataFrame(columns=['sub','model','theta','phi','SSE','AIC','BIC'])

# GREED MODEL
model = 'GR'
theta = np.nan
phi = np.nan
SSE = np.sum(np.square(subDat['ret']))
AIC = penalizedModelFit.compute_AIC(subDat.shape[0],SSE,0)
BIC = penalizedModelFit.compute_BIC(subDat.shape[0],SSE,0)
results = results.append(pd.DataFrame([[sub,model,theta,phi,SSE,AIC,BIC]],columns=results.columns))
print results

# GA MODEL
model = 'GA'
phi = np.nan
start = time.time()
print 'subject %s model %s' %(sub,model),

fitIters = np.zeros([niter,3])
for i in range(niter):
    theta0 = scipy.random.uniform()*10000
    fitIters[i,0] = theta0
    res_lsq = least_squares(costFunctions.GA_costfun, theta0, args=(subDat,),
                            kwargs={'printStep':False,'resid_share':residShareChoice},
                            diff_step=.1,bounds=([0],[10000]),)
    theta = res_lsq.x
    cost = res_lsq.cost
    fitIters[i,1:3] = [theta,cost]
cost_selected = np.min(fitIters[:,2]) #Minimal cost
theta = fitIters[fitIters[:,2]==cost_selected,1][0] # First theta with minimal cost
SSE = cost_selected*2
AIC = penalizedModelFit.compute_AIC(subDat.shape[0],SSE,1)
BIC = penalizedModelFit.compute_BIC(subDat.shape[0],SSE,1)
results = results.append(pd.DataFrame([[sub,model,theta,phi,SSE,AIC,BIC]],columns=results.columns))

print 'took %.2f seconds to converge on theta = %.3f with SSE = %.3f'%(time.time() - start,theta,SSE)

# GA MODEL (pre-programmed second-order expectations)
model = 'GA_ppSOE'
phi = np.nan
start = time.time()
print 'subject %s model %s' %(sub,model),

fitIters = np.zeros([niter,3])
for i in range(niter):
    theta0 = scipy.random.uniform()*10000
    fitIters[i,0] = theta0
    res_lsq = least_squares(costFunctions.GA_ppSOE_costfun, theta0, args=(subDat,),
                            kwargs={'printStep':False,'resid_share':residShareChoice},
                            diff_step=.1,bounds=([0],[10000]),)
    theta = res_lsq.x
    cost = res_lsq.cost
    fitIters[i,1:3] = [theta,cost]
cost_selected = np.min(fitIters[:,2]) #Minimal cost
theta = fitIters[fitIters[:,2]==cost_selected,1][0] # First theta with minimal cost
SSE = cost_selected*2
AIC = penalizedModelFit.compute_AIC(subDat.shape[0],SSE,1)
BIC = penalizedModelFit.compute_BIC(subDat.shape[0],SSE,1)
results = results.append(pd.DataFrame([[sub,model,theta,phi,SSE,AIC,BIC]],columns=results.columns))

print 'took %.2f seconds to converge on theta = %.3f with SSE = %.3f'%(time.time() - start,theta,SSE)

# IA MODEL
model = 'IA'
phi = np.nan
start = time.time()
print 'subject %s model %s' %(sub,model),

fitIters = np.zeros([niter,3])
for i in range(niter):
    theta0 = scipy.random.uniform()*10000
    fitIters[i,0] = theta0
    res_lsq = least_squares(costFunctions.IA_costfun, theta0, args=(subDat,),
                            kwargs={'printStep':False,'resid_share':residShareChoice},
                            diff_step=.1,bounds=([0],[10000]),)
    theta = res_lsq.x
    cost = res_lsq.cost
    fitIters[i,1:3] = [theta,cost]
cost_selected = np.min(fitIters[:,2]) #Minimal cost
theta = fitIters[fitIters[:,2]==cost_selected,1][0] # First theta with minimal cost
SSE = cost_selected*2
AIC = penalizedModelFit.compute_AIC(subDat.shape[0],SSE,1)
BIC = penalizedModelFit.compute_BIC(subDat.shape[0],SSE,1)
results = results.append(pd.DataFrame([[sub,model,theta,phi,SSE,AIC,BIC]],columns=results.columns))

print 'took %.2f seconds to converge on theta = %.3f with SSE = %.3f'%(time.time() - start,theta,SSE)

# MP MODEL
model = 'MP'
start = time.time()
print 'subject %s model %s' %(sub,model),

fitIters = np.zeros([niter,5])
for i in range(niter):
    param0 = [scipy.random.uniform()/2,scipy.random.uniform()/5-0.1]
    fitIters[i,0:2] = param0[:]
    res_lsq = least_squares(costFunctions.MP_costfun, param0, args=(subDat,),
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
results = results.append(pd.DataFrame([[sub,model,theta,phi,SSE,AIC,BIC]],columns=results.columns))

print 'took %.2f seconds to converge on theta = %.3f and phi = %.3f with SSE = %.2f'%(
    time.time() - start,theta,phi,SSE)

# MP MODEL (pre-programmed second-order expectations)
model = 'MP_ppSOE'
start = time.time()
print 'subject %s model %s' %(sub,model),

fitIters = np.zeros([niter,5])
for i in range(niter):
    param0 = [scipy.random.uniform()/2,scipy.random.uniform()/5-0.1]
    fitIters[i,0:2] = param0[:]
    res_lsq = least_squares(costFunctions.MP_ppSOE_costfun, param0, args=(subDat,),
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
results = results.append(pd.DataFrame([[sub,model,theta,phi,SSE,AIC,BIC]],columns=results.columns))

print 'took %.2f seconds to converge on theta = %.3f and phi = %.3f with SSE = %.2f'%(
    time.time() - start,theta,phi,SSE)

# MP MODEL (pre-programmed second-order expectations)
model = 'MP_ppSOE_noDiffStep'
start = time.time()
print 'subject %s model %s' %(sub,model),

fitIters = np.zeros([niter,5])
for i in range(niter):
    param0 = [scipy.random.uniform()/2,scipy.random.uniform()/5-0.1]
    fitIters[i,0:2] = param0[:]
    res_lsq = least_squares(costFunctions.MP_ppSOE_costfun, param0, args=(subDat,),
                            kwargs={'printStep':False,'resid_share':residShareChoice},
#                             diff_step=.05,
                            bounds=([0,-.1],[.5,.1]),)
    theta,phi = res_lsq.x
    cost = res_lsq.cost
    fitIters[i,2:5] = [theta,phi,cost]
cost_selected = np.min(fitIters[:,4]) #Minimal cost
theta = fitIters[fitIters[:,4]==cost_selected,2][0] # First theta with minimal cost
phi = fitIters[fitIters[:,4]==cost_selected,3][0] # First theta with minimal cost
SSE = cost_selected*2
AIC = penalizedModelFit.compute_AIC(subDat.shape[0],SSE,2)
BIC = penalizedModelFit.compute_BIC(subDat.shape[0],SSE,2)
results = results.append(pd.DataFrame([[sub,model,theta,phi,SSE,AIC,BIC]],columns=results.columns))

print 'took %.2f seconds to converge on theta = %.3f and phi = %.3f with SSE = %.2f'%(
    time.time() - start,theta,phi,SSE)

# STORE RESULTS
results = results.reset_index(drop=True)
folder = os.path.join(base_dir,'Results/1.Behavior-FitModels/Iteration_%i'%jobs_iteration)
if not os.path.exists(folder):
    os.makedirs(folder)
results.to_csv('%s/Results_sub-%03d.csv'%(folder,sub))
