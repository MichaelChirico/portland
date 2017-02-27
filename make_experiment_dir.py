#!/usr/bin/python
import os, sys, subprocess

crime, horizon = sys.argv[1:]
subprocess.call(['touch',crime+'_'+horizon+'.exp'])

