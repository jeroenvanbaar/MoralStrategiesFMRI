import numpy as np
def compute_BIC(nObs,SSE,nPar):
    BIC = nObs * np.log(SSE / nObs) + nPar * np.log(nObs)
    return BIC
def compute_AIC(nObs,SSE,nPar):
    AIC = nObs * np.log(SSE/nObs) + 2*nPar
    return AIC
