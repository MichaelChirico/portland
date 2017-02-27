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

def runRmodel(param_vec, model_file = 'ar_ws_evaluate_param_vec.R'):
	# full path to R model
	model_file = os.path.join('/backup/portland/', model_file)

	# spearmint encloses params in [], remove them
	try:
		param_vec = [par[0] for par in param_vec]
	except TypeError:
		pass

	# add crime type and horizon
	param_vec = param_vec + ['vehicle', '2m']

	# call R and capture scores
	command = 'Rscript {0} {1}'.format(model_file, params2str(param_vec))
	print '******\n' + command + '\n*******'

	rout = subprocess.check_output(command.split(), shell=False)
	scores = rout[rout.find("[[[")+3:rout.find("]]]")].split('/')

	score_names = ['delx','dely','eta','lt','theta','k',
				   'l1','l2','p','kde_bw','kde_n','kde_lags','kde_win','pei','pai']
	return OrderedDict(zip(score_names, scores))

def objective(params):
	# define feasible region
	# in_region1 = params['delx']*params['dely'] <= 600**2
	# in_region2 = params['delx']*params['dely'] >= 250**2
	# if not in_region1 and not in_region2:
	# 	return np.nan

	# parse param dictionary
	param_names = ['delx', 'dely', 'eta', 'lt', 'theta',
		       'k', 'kde_bw', 'kde_lags', 'kde_win']
	param_vec = [params[name] for name in param_names]

	# run model in r and get score dict from stdout
	model_file = 'ar_ws_evaluate_params.R'
	score = runRmodel(param_vec, model_file)
	return -float(score['pai'])	

def main(job_id, params):
	# print 'Anything printed here will end up in the output directory for job #%d' % job_id
	print params
	return objective(params)
