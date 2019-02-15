import numpy as np
import pandas as pd
import choiceModels

def MP_costfun(param,subDat,printStep=False,printPredictions=False,resid_share=False):
    theta = param[0]
    phi = param[1]

    for trial in range(subDat.shape[0]):
        subDat.loc[trial,'prediction'] = choiceModels.MP_model(
            subDat.loc[trial,'inv'],
            subDat.loc[trial,'mult'],
            subDat.loc[trial,'exp'],
            theta, phi)
    if resid_share == True:
        residuals = (subDat.loc[:,'ret'] - subDat.loc[:,'prediction'])/(subDat.loc[:,'inv'] * subDat.loc[:,'mult'])
    else:
        residuals = subDat.loc[:,'ret'] - subDat.loc[:,'prediction']
    residuals = residuals.astype('float')
    SSE = np.sum(np.square(residuals))
    if printStep==True:
        print 'theta = %.2f, phi = %.2f, SSE = %.2f'%(theta,phi,SSE)
    if printPredictions == True:
        print subDat
    return residuals

def MP_ppSOE_costfun(param,subDat,printStep=False,printPredictions=False,resid_share=False):
    theta = param[0]
    phi = param[1]

    for trial in range(subDat.shape[0]):
        subDat.loc[trial,'prediction'] = choiceModels.MP_model_ppSOE(
            subDat.loc[trial,'inv'],
            subDat.loc[trial,'mult'],
            subDat.loc[trial,'exp'],
            theta, phi)
    if resid_share == True:
        residuals = (subDat.loc[:,'ret'] - subDat.loc[:,'prediction'])/(subDat.loc[:,'inv'] * subDat.loc[:,'mult'])
    else:
        residuals = subDat.loc[:,'ret'] - subDat.loc[:,'prediction']
    residuals = residuals.astype('float')
    SSE = np.sum(np.square(residuals))
    if printStep==True:
        print 'theta = %.2f, phi = %.2f, SSE = %.2f'%(theta,phi,SSE)
    if printPredictions == True:
        print subDat
    return residuals

def IA_costfun(theta,subDat,printStep=False,printPredictions=False,resid_share=False):

    for trial in range(subDat.shape[0]):
        subDat.loc[trial,'prediction'] = choiceModels.IA_model(
            subDat.loc[trial,'inv'],
            subDat.loc[trial,'mult'],
            theta)
    if resid_share == True:
        residuals = (subDat.loc[:,'ret'] - subDat.loc[:,'prediction'])/(subDat.loc[:,'inv'] * subDat.loc[:,'mult'])
    else:
        residuals = subDat.loc[:,'ret'] - subDat.loc[:,'prediction']
    residuals = residuals.astype('float')
    SSE = np.sum(np.square(residuals))
    if printStep==True:
        print 'theta = %.2f, SSE = %.2f'%(theta,SSE)
    if printPredictions == True:
        print subDat
    return residuals

def GA_costfun(theta,subDat,printStep=False,printPredictions=False,resid_share=False):

    for trial in range(subDat.shape[0]):
        subDat.loc[trial,'prediction'] = choiceModels.GA_model(
            subDat.loc[trial,'inv'],
            subDat.loc[trial,'mult'],
            subDat.loc[trial,'exp'],
            theta)
    if resid_share == True:
        residuals = (subDat.loc[:,'ret'] - subDat.loc[:,'prediction'])/(subDat.loc[:,'inv'] * subDat.loc[:,'mult'])
    else:
        residuals = subDat.loc[:,'ret'] - subDat.loc[:,'prediction']
    residuals = residuals.astype('float')
    SSE = np.sum(np.square(residuals))
    if printStep==True:
        print 'theta = %.2f, SSE = %.2f'%(theta,SSE)
    if printPredictions == True:
        print subDat
    return residuals

def GA_ppSOE_costfun(theta,subDat,printStep=False,printPredictions=False,resid_share=False):

    for trial in range(subDat.shape[0]):
        subDat.loc[trial,'prediction'] = choiceModels.GA_model_ppSOE(
            subDat.loc[trial,'inv'],
            subDat.loc[trial,'mult'],
            subDat.loc[trial,'exp'],
            theta)
    if resid_share == True:
        residuals = (subDat.loc[:,'ret'] - subDat.loc[:,'prediction'])/(subDat.loc[:,'inv'] * subDat.loc[:,'mult'])
    else:
        residuals = subDat.loc[:,'ret'] - subDat.loc[:,'prediction']
    residuals = residuals.astype('float')
    SSE = np.sum(np.square(residuals))
    if printStep==True:
        print 'theta = %.2f, SSE = %.2f'%(theta,SSE)
    if printPredictions == True:
        print subDat
    return residuals
	
def GR_costfun(subDat,printPredictions=False,resid_share=False):
    
    for trial in range(subDat.shape[0]):
        subDat.loc[trial,'prediction'] = choiceModels.GR_model()
    if resid_share == True:
        residuals = (subDat.loc[:,'ret'] - subDat.loc[:,'prediction'])/(subDat.loc[:,'inv'] * subDat.loc[:,'mult'])
    else:
        residuals = subDat.loc[:,'ret'] - subDat.loc[:,'prediction']
    residuals = residuals.astype('float')
    SSE = np.sum(np.square(residuals))
    if printPredictions == True:
        print subDat
    return residuals
