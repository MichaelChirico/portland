#!/usr/bin/python
import os, sys, subprocess

crime, horizon, score = sys.argv[1:]
subprocess.call(['touch',crime+'-'+horizon+'-'+score+'.exper'])
