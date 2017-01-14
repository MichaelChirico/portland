#!/bin/sh

qsub vary_delta.sh
qsub vary_features.sh
qsub vary_l1.sh
qsub vary_l2.sh
qsub vary_lambda.sh
qsub vary_p.sh
qsub vary_t0.sh
