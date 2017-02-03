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

sh fit_features.bash 510.8 490.9 0.844 3.44 5.86 162 720.9 1 all 1w
sh fit_features.bash 265.4 427.3 0.437 3.00 8.93 834 1014.9 5 vehicle 2m
sh fit_features.bash 368.6 343.3 0.266 0.23 1.42 613 177.2 1 all 1w
sh fit_features.bash 358.7 487.1 0.486 0.97 10.24 257 686.8 1 all 3m
sh fit_features.bash 492.7 466.8 0.544 2.95 4.79 710 119.2 4 vehicle 2m
sh fit_features.bash 513.2 288.2 0.620 1.85 11.45 434 489.4 2 vehicle 1m
sh fit_features.bash 334.6 369.0 0.732 0.78 3.85 867 401.7 1 street 1m
sh fit_features.bash 534.3 336.6 0.846 3.30 0.95 1091 274.3 4 burglary 3m
sh fit_features.bash 378.0 499.6 0.500 0.38 10.29 926 674.4 4 all 2m
sh fit_features.bash 399.6 262.4 0.781 1.90 2.16 410 576.7 5 vehicle 1w
sh fit_features.bash 403.6 513.1 0.896 1.73 3.26 668 729.7 2 street 2m
sh fit_features.bash 556.2 457.0 0.058 0.98 0.70 325 963.2 6 all 1w
sh fit_features.bash 255.5 303.6 0.846 2.22 9.74 225 984.0 2 vehicle 2m
sh fit_features.bash 318.8 351.3 0.312 0.27 8.05 1123 500.6 1 street 2m
sh fit_features.bash 253.8 571.7 0.428 3.78 5.37 264 359.6 4 vehicle 3m
sh fit_features.bash 434.5 346.2 0.288 2.06 1.27 266 285.0 4 street 1w
sh fit_features.bash 384.6 462.6 0.881 3.14 7.49 725 495.8 5 vehicle 1m
sh fit_features.bash 494.4 398.4 0.195 1.53 1.26 170 880.7 6 burglary 2w
sh fit_features.bash 507.3 348.0 0.173 1.46 1.92 942 567.7 2 street 2m
sh fit_features.bash 598.6 448.1 0.907 1.99 11.35 891 470.3 5 burglary 2m
sh fit_features.bash 368.2 389.1 0.506 3.17 2.71 53 743.4 1 all 1m
sh fit_features.bash 579.7 591.9 0.407 3.77 10.68 786 809.9 6 burglary 2m
sh fit_features.bash 555.8 534.7 0.169 3.78 2.38 844 289.2 1 vehicle 2w
sh fit_features.bash 499.0 372.0 0.399 0.96 10.90 123 208.7 3 burglary 1m
sh fit_features.bash 339.1 260.8 0.970 0.55 0.60 338 102.2 6 vehicle 2w
sh fit_features.bash 298.3 568.6 0.024 0.04 9.70 885 1012.8 5 street 3m
sh fit_features.bash 589.0 557.8 0.908 2.20 0.51 421 857.4 1 all 2w
sh fit_features.bash 473.0 262.4 0.455 3.04 7.66 654 1188.3 4 all 2w
sh fit_features.bash 348.9 511.4 0.281 0.34 0.33 585 1183.2 1 burglary 1m
sh fit_features.bash 316.2 504.0 0.509 1.41 9.94 776 346.5 3 burglary 1w
sh fit_features.bash 297.9 311.2 0.660 1.19 4.01 437 735.3 2 vehicle 2w
sh fit_features.bash 362.0 444.7 0.053 3.56 5.26 776 155.0 4 vehicle 1m
sh fit_features.bash 352.6 562.9 0.639 3.04 5.11 941 151.1 3 all 1w
sh fit_features.bash 322.2 343.3 0.252 1.78 5.21 1194 148.9 2 all 1w
sh fit_features.bash 572.2 315.5 0.135 0.74 7.89 220 588.1 1 burglary 2m
sh fit_features.bash 546.8 417.7 0.363 1.55 5.18 868 643.4 5 street 2m
sh fit_features.bash 552.7 274.7 0.833 0.55 5.55 479 725.3 3 burglary 1m
sh fit_features.bash 320.4 418.6 0.349 2.88 3.92 254 295.1 6 street 1w
sh fit_features.bash 582.1 456.2 0.023 0.22 11.85 292 135.6 2 burglary 1w
sh fit_features.bash 328.5 525.3 0.217 0.98 1.00 854 1069.1 1 vehicle 2m
sh fit_features.bash 498.5 250.9 0.978 1.44 7.19 52 376.4 4 burglary 2w
sh fit_features.bash 497.8 435.5 0.285 1.15 8.27 120 1185.5 2 burglary 3m
sh fit_features.bash 250.8 359.8 0.485 2.65 5.94 1168 229.6 1 all 1w
sh fit_features.bash 593.8 563.2 0.312 1.28 2.89 811 404.0 3 all 1w
sh fit_features.bash 493.0 327.9 0.444 0.47 0.31 169 743.0 3 burglary 2m
sh fit_features.bash 427.3 340.7 0.453 1.13 10.88 229 1068.2 5 burglary 1m
sh fit_features.bash 422.2 594.0 0.883 2.76 6.52 73 614.0 3 street 3m
sh fit_features.bash 454.5 288.0 0.332 1.97 2.93 202 453.4 5 all 3m
sh fit_features.bash 476.9 356.9 0.362 3.60 11.59 1003 1187.1 6 burglary 2w
sh fit_features.bash 510.1 589.7 0.992 2.04 2.16 1113 197.9 5 all 3m
sh fit_features.bash 517.9 419.1 0.472 0.68 6.69 332 903.6 1 vehicle 3m
sh fit_features.bash 259.1 598.9 0.607 0.90 9.46 90 383.7 5 burglary 2w
sh fit_features.bash 352.2 318.8 0.878 1.83 4.31 859 762.0 3 street 1m
sh fit_features.bash 394.1 397.5 0.755 3.07 3.21 1144 1197.0 3 street 2w
sh fit_features.bash 577.8 471.8 0.575 1.61 8.44 858 532.4 2 street 1w
sh fit_features.bash 351.9 596.9 0.117 2.74 11.33 1097 451.2 3 burglary 1w
sh fit_features.bash 382.4 431.7 0.957 2.08 7.25 717 804.4 6 street 1m
sh fit_features.bash 391.0 568.8 0.300 0.92 2.44 953 813.7 1 street 1w
sh fit_features.bash 370.5 527.3 0.224 0.86 8.20 279 471.3 2 all 3m
sh fit_features.bash 320.5 466.0 0.666 0.39 8.85 132 539.5 6 vehicle 3m
sh fit_features.bash 533.6 494.7 0.956 0.19 3.50 957 951.4 2 vehicle 3m
sh fit_features.bash 291.2 435.2 0.215 3.87 4.44 1184 892.1 2 all 1m
sh fit_features.bash 572.2 484.0 0.822 0.93 9.71 717 1093.7 1 street 2w
sh fit_features.bash 510.4 477.2 0.215 3.33 8.37 947 1039.4 5 burglary 2m
sh fit_features.bash 556.5 354.8 0.486 2.86 9.52 528 1162.8 6 vehicle 1m
sh fit_features.bash 368.6 389.5 0.306 2.49 3.83 829 133.1 6 all 1w
sh fit_features.bash 541.7 426.3 0.711 2.31 7.45 895 1029.9 4 burglary 3m
sh fit_features.bash 293.7 565.0 0.745 0.32 3.38 463 416.2 6 vehicle 2m
sh fit_features.bash 346.3 309.7 0.882 1.16 5.34 314 307.8 4 street 1w
sh fit_features.bash 457.7 529.4 0.669 3.88 10.93 243 603.4 6 vehicle 1m
sh fit_features.bash 351.9 313.6 0.106 1.91 9.20 139 872.5 1 all 3m
sh fit_features.bash 293.1 504.9 0.610 3.01 11.94 593 384.3 4 burglary 3m
sh fit_features.bash 298.0 533.6 0.986 0.05 6.66 716 1122.0 6 street 2m
sh fit_features.bash 364.6 465.4 0.482 2.13 2.39 418 1107.5 2 street 1w
sh fit_features.bash 474.3 552.3 0.341 0.95 6.73 998 528.1 6 vehicle 2w
sh fit_features.bash 435.6 439.5 0.973 1.13 8.74 785 1096.9 5 vehicle 2w
sh fit_features.bash 364.5 322.8 0.630 1.79 9.94 919 892.4 4 burglary 2m
sh fit_features.bash 265.6 469.0 0.936 3.68 5.97 102 530.8 5 street 3m
sh fit_features.bash 259.5 418.8 0.651 1.31 0.00 1041 802.4 1 vehicle 2m
sh fit_features.bash 333.3 386.1 0.314 3.41 0.60 595 168.7 1 burglary 2w
sh fit_features.bash 537.6 341.7 0.806 3.81 3.03 633 639.0 6 vehicle 1m
sh fit_features.bash 292.8 420.6 0.302 1.08 5.75 487 804.9 4 vehicle 2w
sh fit_features.bash 430.0 570.5 0.527 0.28 0.22 874 325.3 3 all 1w
sh fit_features.bash 492.8 359.2 0.931 0.20 6.28 756 1018.9 1 vehicle 2w
sh fit_features.bash 465.0 357.2 0.285 0.30 10.89 171 1106.2 6 street 2w
sh fit_features.bash 474.8 574.4 0.116 2.06 5.46 950 630.2 5 vehicle 2w
sh fit_features.bash 408.2 310.5 0.991 3.72 11.47 310 1102.1 1 street 2m
sh fit_features.bash 415.5 471.9 0.820 0.92 9.45 427 764.4 5 burglary 3m
sh fit_features.bash 580.0 408.8 0.052 0.86 7.55 824 1102.2 6 all 3m
sh fit_features.bash 525.7 529.9 0.545 1.24 7.16 615 1085.8 3 vehicle 1m
sh fit_features.bash 581.7 282.2 0.180 2.75 3.66 1088 373.6 5 all 2w
sh fit_features.bash 471.4 311.2 0.566 1.45 11.24 149 736.8 4 street 1w
sh fit_features.bash 346.6 499.5 0.726 1.25 2.20 192 480.8 3 burglary 1w
sh fit_features.bash 452.1 356.8 0.027 3.19 4.49 507 571.6 1 street 1m
sh fit_features.bash 378.0 383.2 0.715 3.02 3.28 883 193.5 1 street 2m
sh fit_features.bash 410.7 394.4 0.971 1.01 6.79 606 747.5 4 vehicle 1w
sh fit_features.bash 333.4 367.6 0.630 1.26 2.69 199 872.0 6 burglary 3m
sh fit_features.bash 544.7 576.6 0.895 0.92 5.89 213 753.6 6 burglary 2w
sh fit_features.bash 265.8 439.5 0.773 3.28 7.53 559 895.6 1 street 1m
sh fit_features.bash 333.1 572.6 0.458 3.81 4.09 913 109.4 3 all 1m
