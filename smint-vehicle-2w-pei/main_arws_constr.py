# from __future__ import division
# import numpy as np 
import numpy as np
import subprocess, re, os
from collections import OrderedDict

# param_names = ['delx', 'dely', 'eta', 'lt', 'theta',
# 			   'k', 'kde_bw', 'kde_lags', 'kde_win']
# param_vals = [600,600,1,1,0,5,150,2,3]
# test_params = OrderedDict(zip(param_names, param_vals))

def params2str(params):
	return ' '.join([str(par) for par in params])

def runRmodel(param_vec, crime, horizon, model_file = 'ar_ws_evaluate_params.R'):
	# Inpu
	# full path to R model
	model_file = os.path.join('..', model_file)

	# spearmint encloses params in [], remove them
	try:
		param_vec = [par[0] for par in param_vec]
	except TypeError:
		pass

	# add crime type and horizon
	param_vec = param_vec + [crime, horizon]

	# call R and capture scores from stdout
	command = 'Rscript {0} {1}'.format(model_file, params2str(param_vec))
	print '******\n' + command + '\n*******'

	rout = subprocess.check_output(command.split(), shell=False)
	scores = rout[rout.find("[[[")+3:rout.find("]]]")].split('/')
	print scores
	score_names = ['pai','pei']
	return OrderedDict(zip(score_names, scores))

def objective(params):
	# define feasible region
	in_region1 = params['delx']*params['dely'] <= 600**2
	in_region2 = params['delx']*params['dely'] >= 250**2
	if not in_region1 and not in_region2:
		return np.nan

	# TODO pei or pai
	try:
		experfile = [f for f in os.listdir('.') if f.endswith('.exper')][0]
	except IndexError:
		 raise Exception('Pau: No experiment file!')
	crime, horizon, paiorpei = experfile.split('.')[0].split('-')

	# parse param dictionary and turn into list
	param_names = ['delx', 'dely', 'eta', 'lt', 'theta',
		       'k', 'kde_bw', 'kde_lags', 'kde_win']    
	param_vec = [params[name] for name in param_names]
	
	# run model in r and get score dict from stdout
	model_file = 'ar_ws_evaluate_params.R'
	score = runRmodel(param_vec, crime, horizon, model_file)
	return -float(score[paiorpei])	

def evaluate(job_id, params):
	obj = objective(params)
	con1 = float(600**2 - params['delx']*params['dely'])
	con2 = float(params['delx']*params['dely'] - 250**2)
	return {
		"arws"     : obj,
		"max_area" : con1,
		"min_area" : con2
	}

def main(job_id, params):
	# print 'Anything printed here will end up in the output directory for job #%d' % job_id
	print params
	return evaluate(job_id, params)
