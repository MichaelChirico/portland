import numpy as np 
import sys, subprocess, re
from collections import OrderedDict

def params2str(params):
	return ' '.join([str(par) for par in params])

param_names = ['delx', 'dely', 'alpha', 'eta', 'lt', 'theta',
			   'features', 'kde.bw', 'kde.lags', 'kde.win', 'crime.type', 'horizon']
param_vals = [600,600,0,1,1,0,5,150,2,3,'burglary','3m']
test_params = OrderedDict(zip(param_names, param_vals))

# model_file = 'ar_ws_evaluate_params.R'
# command = 'Rscript {0} {1}'.format(model_file, params2str(test_params.values()))
# rout = subprocess.check_output(command.split(), shell=False)
# scores = rout[rout.find("[[[")+3:rout.find("]]]")].split('/')

def runR(params):
	model_file = 'ar_ws_evaluate_params.R'
	command = 'Rscript {0} {1}'.format(model_file, params2str(params.values()))
	rout = subprocess.check_output(command.split(), shell=False)
	scores = rout[rout.find("[[[")+3:rout.find("]]]")].split('/')
	return scores

s = runR(test_params)
s
# def objective(params):

