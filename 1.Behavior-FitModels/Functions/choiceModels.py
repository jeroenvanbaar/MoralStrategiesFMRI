import os
import numpy as np
import pandas as pd

def MP_model(inv, mult, exp, theta, phi):
    inv = float(inv); mult = float(mult);
    exp = float(exp); theta = float(theta); phi = float(phi);

    totalAmt = inv*mult
    choiceOpt = np.unique(np.round(np.arange(0,totalAmt+1,totalAmt/10)))
    
    own = totalAmt-choiceOpt
    ownShare = own/totalAmt
    other = 10 - inv + choiceOpt

    guilt = np.square(np.maximum((exp-choiceOpt)/(inv*4),0))
    inequity = np.square(own/(own+other) - .5)

    utility = theta*ownShare - (1-theta)*np.minimum(guilt+phi, inequity-phi)
    
    return choiceOpt[np.where(utility == np.max(utility))[0][0]]

def MP_model_ppSOE(inv, mult, exp, theta, phi):
	# ppSOE = pre-programmed second-order expectation (equal across subjects at 2*inv)
    inv = float(inv); mult = float(mult);
    exp = float(2*inv); theta = float(theta); phi = float(phi);
	
    totalAmt = inv*mult
    choiceOpt = np.unique(np.round(np.arange(0,totalAmt+1,totalAmt/10)))
    
    own = totalAmt-choiceOpt
    ownShare = own/totalAmt
    other = 10 - inv + choiceOpt

    guilt = np.square(np.maximum((exp-choiceOpt)/(inv*4),0))
    inequity = np.square(own/(own+other) - .5)

    utility = theta*ownShare - (1-theta)*np.minimum(guilt+phi, inequity-phi)
    
    return choiceOpt[np.where(utility == np.max(utility))[0][0]]

def IA_model(inv, mult, theta):
    inv = float(inv); mult = float(mult); theta = float(theta);

    totalAmt = inv*mult
    choiceOpt = np.unique(np.round(np.arange(0,totalAmt+1,totalAmt/10)))
    
    own = totalAmt-choiceOpt
    other = 10 - inv + choiceOpt
    ownShare = own/(own+other)

    inequity = np.square(ownShare - .5)

    utility = own - theta*inequity

    return choiceOpt[np.where(utility == np.max(utility))[0][0]]

def GA_model(inv, mult, exp, theta):
    inv = float(inv); mult = float(mult);
    exp = float(exp); theta = float(theta);

    totalAmt = inv*mult
    choiceOpt = np.unique(np.round(np.arange(0,totalAmt+1,totalAmt/10)))
    
    guilt = np.square(np.maximum((exp-choiceOpt)/(inv*4),0))
    
    own = totalAmt-choiceOpt

    utility = own - theta*guilt

    return choiceOpt[np.where(utility == np.max(utility))[0][0]]

def GA_model_ppSOE(inv, mult, exp, theta):
	# ppSOE = pre-programmed second-order expectation (2*inv)
    inv = float(inv); mult = float(mult);
    exp = float(2*inv); theta = float(theta);

    totalAmt = inv*mult
    choiceOpt = np.unique(np.round(np.arange(0,totalAmt+1,totalAmt/10)))
    
    guilt = np.square(np.maximum((exp-choiceOpt)/(inv*4),0))
    
    own = totalAmt-choiceOpt

    utility = own - theta*guilt

    return choiceOpt[np.where(utility == np.max(utility))[0][0]]
def GR_model():
    return 0
