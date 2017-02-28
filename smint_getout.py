
# coding: utf-8

# In[47]:

import os, glob
from os.path import abspath, join
import re
from numpy import array
import pandas as pd


# In[93]:

def parse_out(fout):
    from numpy import array
    regex = re.compile('uniprotkb:P([0-9]*)')
    get_score = re.compile(r"{u'main': ([+-]?\d+\.\d+|\d+)")
    get_params = re.compile(r"}]\n(.*)\n")                   

    score = get_score.findall(fout)[0]
    params = get_params.findall(fout)[0]                   
    return {'score':float(score), 'params':params}

def extract_output(exp_dir):
    outfiles = glob.glob(join(exp_dir, 'output/*.out'))
    experout = []
    for outfile in outfiles:
        outname = os.path.basename(outfile)
        with open(outfile) as f:
            fout = f.read()
            try:
                experout.append(parse_out(fout))
            except IndexError:
                pass
            # add output file name
            experout[-1].update({'outfile':outname})
    return experout


# In[95]:

dirs_smint = [abspath(d) for d in os.listdir('.') if 'smint' in d and os.path.isdir(d)]
expout = {}
for path_out in dirs_smint:
    print 'exctracting output from:', path_out
    experiment = os.path.basename(path_out)
    expout[experiment] = extract_output(path_out)


# In[110]:

best = []
for experiment, output in expout.iteritems():
    print 'Choosing best trial in experiment:', experiment
    # select best score
    df = pd.DataFrame(expout[experiment])
    best_out = df.iloc[df.score.argmin()].to_dict()
    best_out.update({'experiment':experiment})
    best.append(best_out)


# In[111]:

pd.DataFrame(best)

