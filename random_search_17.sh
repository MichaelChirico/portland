#!/bin/sh
#$ -cwd
#$ -q all.q
#$ -pe openmp 1
#$ -S /bin/bash
#$ -o /home/chiricom/portland/output_random.log
#$ -e /home/chiricom/portland/error_random.log

source /etc/profile.d/modules.sh
module unload R/3.2.3
module load shared R/3.3.2 vowpal_wabbit gcc/5.2.0
#see http://stackoverflow.com/questions/6395078/
unset R_HOME

sh fit_features.bash 444.1 407.6 0.966 0.67 1.83 197 117.3 2 vehicle 3m
sh fit_features.bash 349.0 502.4 0.047 3.66 9.25 1173 408.8 4 street 1m
sh fit_features.bash 477.8 343.8 0.836 0.36 0.15 577 915.3 8 street 2m
sh fit_features.bash 535.1 393.5 0.229 0.24 6.33 1025 443.5 3 burglary 2m
sh fit_features.bash 563.8 304.9 0.953 2.75 0.96 887 634.8 1 vehicle 2w
sh fit_features.bash 597.5 403.1 0.148 2.38 1.45 915 879.8 5 vehicle 3m
sh fit_features.bash 382.4 432.6 0.979 2.98 0.49 736 251.2 7 vehicle 2w
sh fit_features.bash 464.0 326.9 0.321 3.56 4.60 469 1061.0 6 all 3m
sh fit_features.bash 264.9 275.1 0.726 3.03 11.76 844 1031.4 6 street 1w
sh fit_features.bash 504.8 495.4 0.370 2.44 0.15 813 479.6 1 street 1m
sh fit_features.bash 260.6 476.6 0.552 2.61 1.62 583 1087.2 6 burglary 1w
sh fit_features.bash 487.4 251.1 0.764 2.24 9.31 900 1090.4 7 burglary 3m
sh fit_features.bash 563.2 429.1 0.233 3.33 7.09 881 261.4 1 vehicle 2w
sh fit_features.bash 558.0 568.9 0.141 1.20 6.92 763 275.7 6 all 2m
sh fit_features.bash 493.1 579.0 0.768 3.98 11.96 281 696.3 1 street 1m
sh fit_features.bash 487.9 377.5 0.094 2.56 8.56 533 376.0 6 burglary 3m
sh fit_features.bash 526.5 506.9 0.215 1.23 7.74 1154 1014.0 2 all 1m
sh fit_features.bash 425.9 429.9 0.401 3.92 7.70 278 711.1 6 street 3m
sh fit_features.bash 281.6 326.4 0.473 2.80 4.86 889 959.0 5 vehicle 1m
sh fit_features.bash 512.2 270.4 0.550 1.53 5.02 474 114.6 8 burglary 1m
sh fit_features.bash 333.2 588.0 0.754 0.49 2.67 217 132.9 1 burglary 1w
sh fit_features.bash 433.9 481.6 0.699 2.08 6.80 108 914.8 2 all 1m
sh fit_features.bash 259.7 591.8 0.496 2.86 9.01 682 363.5 6 burglary 1m
sh fit_features.bash 450.9 400.8 0.375 2.51 8.01 915 1168.7 3 vehicle 1m
sh fit_features.bash 403.2 581.3 0.453 2.20 3.30 1182 1117.2 2 vehicle 1m
sh fit_features.bash 348.4 506.1 0.038 1.40 7.08 125 502.1 4 vehicle 2m
sh fit_features.bash 482.9 551.7 0.089 0.03 7.07 889 530.6 1 all 3m
sh fit_features.bash 264.5 496.7 0.944 2.46 5.57 762 177.2 5 vehicle 1w
sh fit_features.bash 266.5 540.1 0.228 3.54 9.84 946 341.7 7 all 1m
sh fit_features.bash 281.8 529.5 0.269 0.29 2.85 829 910.3 1 burglary 3m
sh fit_features.bash 546.7 468.9 0.831 3.72 7.74 186 279.5 7 all 1w
sh fit_features.bash 403.6 333.0 0.576 2.41 0.22 1133 226.3 7 vehicle 1m
sh fit_features.bash 267.6 409.6 0.669 0.44 1.91 884 310.4 6 vehicle 1w
sh fit_features.bash 503.1 445.3 0.720 0.69 9.51 518 524.3 6 all 2w
sh fit_features.bash 377.8 543.4 0.111 3.30 2.18 217 484.9 5 burglary 2w
sh fit_features.bash 405.2 324.3 0.491 0.63 3.74 768 980.9 3 vehicle 2w
sh fit_features.bash 590.7 494.7 0.678 1.53 5.37 829 178.9 6 all 3m
sh fit_features.bash 263.1 441.5 0.302 3.19 6.64 729 954.6 3 street 1w
sh fit_features.bash 432.8 300.4 0.340 3.39 3.29 204 454.3 4 vehicle 2m
sh fit_features.bash 423.4 407.5 0.458 3.23 11.95 1081 133.1 6 street 3m
sh fit_features.bash 309.5 422.0 0.770 1.84 5.76 1129 543.7 6 street 1w
sh fit_features.bash 421.4 302.3 0.072 0.77 10.86 794 541.9 5 burglary 1w
sh fit_features.bash 296.3 466.5 0.021 0.84 2.94 301 122.7 7 burglary 1w
sh fit_features.bash 479.2 481.5 0.478 3.86 8.30 278 1007.7 4 street 3m
sh fit_features.bash 292.8 589.9 0.801 3.65 7.59 621 506.5 3 all 2m
sh fit_features.bash 458.5 577.6 0.038 2.59 7.49 1120 382.5 7 burglary 2m
sh fit_features.bash 488.9 561.9 0.090 3.11 10.52 1193 808.4 5 all 1w
sh fit_features.bash 325.4 513.6 0.266 3.35 7.15 115 1009.2 3 burglary 2w
sh fit_features.bash 530.8 535.8 0.538 2.32 9.03 827 208.5 3 burglary 1m
sh fit_features.bash 547.3 554.7 0.818 2.84 8.28 1027 860.6 5 vehicle 2w
sh fit_features.bash 457.1 490.2 0.331 3.86 11.42 675 593.6 7 vehicle 3m
sh fit_features.bash 316.9 323.2 0.322 1.85 0.02 165 344.0 1 all 2w
sh fit_features.bash 528.0 411.8 0.063 3.77 2.00 413 554.7 7 all 2m
sh fit_features.bash 531.3 552.0 0.562 0.64 9.76 359 597.7 2 street 1m
sh fit_features.bash 305.8 268.9 0.980 0.04 2.96 154 658.5 2 burglary 2m
sh fit_features.bash 498.3 433.6 0.997 1.90 9.93 921 378.1 4 burglary 3m
sh fit_features.bash 465.3 442.8 0.274 1.82 1.11 657 628.2 5 burglary 1w
sh fit_features.bash 447.7 452.1 0.014 1.68 7.31 896 746.4 4 all 2w
sh fit_features.bash 330.6 391.2 0.228 3.63 8.76 716 118.2 4 all 2m
sh fit_features.bash 320.3 378.1 0.831 1.93 9.11 957 1176.0 6 burglary 1m
sh fit_features.bash 475.9 518.2 0.732 2.75 11.58 398 395.0 3 burglary 2m
sh fit_features.bash 399.2 387.1 0.583 3.31 11.12 582 1107.1 7 vehicle 2w
sh fit_features.bash 496.9 558.5 0.567 1.97 5.63 180 294.1 5 all 1m
sh fit_features.bash 550.0 355.6 0.745 0.41 1.69 387 343.3 7 vehicle 1w
sh fit_features.bash 474.1 394.5 0.901 2.76 2.82 570 886.3 2 vehicle 3m
sh fit_features.bash 585.1 489.7 0.443 1.70 9.91 345 1034.2 4 vehicle 2w
sh fit_features.bash 468.8 430.0 0.867 3.94 6.74 537 545.1 8 burglary 3m
sh fit_features.bash 463.6 557.5 0.410 1.33 3.27 93 628.0 2 all 1w
sh fit_features.bash 255.8 291.7 0.283 1.88 8.69 531 1041.8 5 vehicle 1m
sh fit_features.bash 545.8 442.1 0.725 0.22 0.64 312 953.5 8 vehicle 1m
sh fit_features.bash 504.9 433.5 0.068 3.56 10.89 386 479.2 2 all 2w
sh fit_features.bash 441.0 429.6 0.327 3.03 6.25 839 875.9 4 all 2w
sh fit_features.bash 345.8 293.0 0.622 0.56 8.43 337 1012.8 4 burglary 2w
sh fit_features.bash 488.0 409.2 0.410 3.95 2.52 653 1115.2 8 all 2m
sh fit_features.bash 581.3 571.8 0.717 2.73 11.17 345 717.0 5 street 2w
sh fit_features.bash 466.4 378.3 0.955 0.91 5.45 1034 133.8 7 burglary 1m
sh fit_features.bash 599.8 424.9 0.647 3.76 11.01 1067 1052.1 4 burglary 1w
sh fit_features.bash 377.3 324.8 0.564 1.02 8.99 803 866.5 6 burglary 2m
sh fit_features.bash 453.8 593.2 0.360 1.90 1.50 669 1048.4 2 vehicle 3m
sh fit_features.bash 259.3 336.0 0.889 3.27 9.36 717 515.6 1 street 1w
sh fit_features.bash 308.7 387.8 0.866 0.89 3.10 776 755.6 3 all 1m
sh fit_features.bash 397.4 332.8 0.020 0.95 6.03 877 272.0 5 burglary 3m
sh fit_features.bash 337.5 408.5 0.729 2.68 11.43 1144 145.8 2 vehicle 3m
sh fit_features.bash 370.3 562.7 0.145 3.75 5.88 528 1050.1 3 vehicle 1m
sh fit_features.bash 352.9 250.7 0.510 1.58 5.08 650 313.6 5 vehicle 1m
sh fit_features.bash 250.8 420.6 0.195 2.07 2.61 181 872.4 4 all 2m
sh fit_features.bash 585.2 488.4 0.144 3.96 11.08 804 1115.9 4 street 1m
sh fit_features.bash 599.1 352.2 0.389 3.85 10.74 1121 458.8 4 all 1w
sh fit_features.bash 415.6 332.9 0.267 3.20 8.93 910 1152.8 2 vehicle 2m
sh fit_features.bash 451.1 508.6 0.171 1.56 3.42 880 396.6 1 all 2w
sh fit_features.bash 383.9 381.9 0.684 0.18 0.62 238 238.8 4 vehicle 1w
sh fit_features.bash 412.0 595.3 0.818 0.18 1.14 124 799.1 7 street 1w
sh fit_features.bash 489.4 278.2 0.724 1.93 1.46 496 757.8 2 burglary 2w
sh fit_features.bash 528.6 513.6 0.374 1.90 8.36 1174 317.9 1 vehicle 1m
sh fit_features.bash 263.4 458.3 0.625 1.02 4.47 442 217.3 6 burglary 1m
sh fit_features.bash 487.0 322.4 0.262 0.61 9.66 715 1063.4 5 street 3m
sh fit_features.bash 555.5 292.4 0.721 0.20 2.25 871 880.1 3 street 1w
sh fit_features.bash 401.4 405.9 0.467 2.10 6.73 1100 833.0 4 all 2w
sh fit_features.bash 436.8 385.9 0.191 2.05 2.07 984 997.1 8 street 2m
sh fit_features.bash 496.1 394.5 0.099 0.01 1.82 645 285.9 8 vehicle 2w
