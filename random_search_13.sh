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

sh fit_features.bash 324.4 383.0 0.793 3.35 6.58 988 1059.8 3 burglary 1w
sh fit_features.bash 449.2 258.0 0.698 1.18 2.07 650 1177.3 2 street 2w
sh fit_features.bash 350.2 392.2 0.487 3.94 8.73 475 661.7 5 vehicle 2m
sh fit_features.bash 401.9 478.3 0.361 3.83 10.46 1158 581.1 7 all 3m
sh fit_features.bash 535.6 307.7 0.618 1.34 0.34 766 315.5 7 burglary 2m
sh fit_features.bash 347.1 349.5 0.687 0.04 4.79 96 101.7 6 street 1m
sh fit_features.bash 351.5 401.8 0.420 1.80 11.13 648 1105.0 6 burglary 1w
sh fit_features.bash 339.9 313.6 0.530 2.66 8.85 147 1113.9 8 street 2w
sh fit_features.bash 316.9 551.9 0.161 2.69 8.24 1093 434.9 4 vehicle 3m
sh fit_features.bash 572.8 506.3 0.452 3.67 9.68 54 336.5 6 street 1w
sh fit_features.bash 407.8 390.8 0.033 2.15 2.74 990 1010.9 8 burglary 2m
sh fit_features.bash 275.0 263.3 0.032 2.24 5.82 1149 495.0 7 vehicle 1m
sh fit_features.bash 258.3 376.4 0.844 1.28 8.78 1032 809.8 1 burglary 2w
sh fit_features.bash 370.2 337.3 0.742 3.28 8.68 501 632.7 8 all 1m
sh fit_features.bash 540.8 493.1 0.333 1.74 3.64 917 849.5 6 street 2m
sh fit_features.bash 530.5 508.9 0.752 2.92 4.88 65 779.0 7 street 2w
sh fit_features.bash 448.6 277.7 0.775 3.83 3.38 223 523.6 3 street 1w
sh fit_features.bash 531.2 321.1 0.252 2.66 0.46 540 774.2 1 street 1m
sh fit_features.bash 531.4 531.2 0.901 1.52 3.09 917 654.0 2 street 1m
sh fit_features.bash 406.4 514.4 0.348 2.11 4.08 847 641.9 1 burglary 1w
sh fit_features.bash 379.2 409.5 0.666 0.65 3.28 1124 137.8 4 burglary 2m
sh fit_features.bash 480.2 354.3 0.430 0.68 10.10 210 284.6 1 vehicle 2m
sh fit_features.bash 561.7 295.5 0.881 2.53 4.86 62 973.4 5 vehicle 2m
sh fit_features.bash 325.9 436.9 0.913 3.04 11.49 406 1081.6 2 vehicle 3m
sh fit_features.bash 530.2 386.3 0.512 0.12 7.80 1078 763.9 5 street 1w
sh fit_features.bash 525.1 369.2 0.287 2.55 7.69 482 1125.8 6 vehicle 2w
sh fit_features.bash 592.1 313.1 0.959 2.52 10.58 812 400.9 7 vehicle 1m
sh fit_features.bash 406.7 253.4 0.606 0.52 8.56 200 507.2 7 all 2w
sh fit_features.bash 507.2 293.5 0.488 2.52 6.79 1036 439.4 8 all 1m
sh fit_features.bash 494.7 321.7 0.765 3.08 9.32 637 733.1 8 burglary 1w
sh fit_features.bash 351.9 278.0 0.920 1.06 5.89 1060 232.7 4 all 2m
sh fit_features.bash 255.6 275.7 0.460 1.26 3.96 774 475.7 8 burglary 1w
sh fit_features.bash 333.4 282.2 0.403 1.78 4.66 874 1069.9 7 burglary 3m
sh fit_features.bash 438.9 298.4 0.077 2.90 7.73 96 431.2 2 vehicle 3m
sh fit_features.bash 402.8 378.2 0.844 2.14 5.79 1131 239.4 1 burglary 2m
sh fit_features.bash 335.2 369.9 0.445 1.49 11.65 383 654.0 3 street 3m
sh fit_features.bash 405.3 335.5 0.319 2.10 6.78 236 779.1 4 vehicle 2m
sh fit_features.bash 421.4 302.4 0.390 0.88 7.65 441 1055.8 3 street 1w
sh fit_features.bash 500.5 582.0 0.700 1.43 3.08 947 175.8 4 all 2m
sh fit_features.bash 364.1 262.3 0.575 1.94 5.99 696 430.4 2 all 2w
sh fit_features.bash 521.4 303.2 0.535 2.52 11.16 955 639.2 5 all 1m
sh fit_features.bash 430.1 360.5 0.396 0.63 4.98 147 631.2 8 all 1w
sh fit_features.bash 581.0 331.3 0.017 1.73 10.70 660 1084.8 5 street 1w
sh fit_features.bash 472.5 268.4 0.639 3.82 11.39 237 1172.4 7 all 1w
sh fit_features.bash 387.9 497.9 0.778 3.94 10.89 1096 699.9 4 burglary 2w
sh fit_features.bash 268.1 307.7 0.208 2.91 7.62 794 802.7 2 burglary 2w
sh fit_features.bash 574.0 339.6 0.652 1.93 11.25 375 135.8 2 burglary 2m
sh fit_features.bash 438.8 300.1 0.753 3.04 0.93 138 1195.7 2 all 1w
sh fit_features.bash 313.6 528.2 0.700 3.70 3.27 1006 201.1 4 burglary 2m
sh fit_features.bash 447.6 379.6 0.410 3.29 1.23 420 722.5 5 all 2w
sh fit_features.bash 546.7 411.9 0.564 3.65 8.93 516 358.7 4 burglary 1m
sh fit_features.bash 386.7 477.8 0.625 0.17 6.02 562 213.8 5 all 3m
sh fit_features.bash 452.2 499.0 0.910 0.08 5.65 727 530.1 3 street 2m
sh fit_features.bash 520.1 523.5 0.868 3.29 1.49 425 180.8 3 street 2m
sh fit_features.bash 472.0 587.2 0.051 3.87 6.54 1145 1092.8 3 vehicle 2m
sh fit_features.bash 348.7 394.2 0.167 1.22 4.85 528 853.6 1 street 3m
sh fit_features.bash 301.6 371.7 0.226 1.05 11.87 458 750.7 6 all 3m
sh fit_features.bash 379.6 427.4 0.960 1.06 7.00 136 880.1 6 burglary 3m
sh fit_features.bash 505.6 496.1 0.068 3.95 9.68 673 158.2 7 street 1m
sh fit_features.bash 504.5 465.4 0.918 3.79 11.88 501 766.0 4 street 1m
sh fit_features.bash 370.4 350.8 0.219 0.59 10.06 1005 1159.3 8 street 2w
sh fit_features.bash 358.1 345.3 0.390 0.13 11.10 781 1118.4 1 burglary 2m
sh fit_features.bash 492.2 422.6 0.585 3.25 4.92 509 1118.8 4 vehicle 3m
sh fit_features.bash 585.4 387.9 0.711 2.47 4.98 484 686.2 7 vehicle 2m
sh fit_features.bash 353.7 280.7 0.434 1.60 4.73 397 508.4 7 street 1m
sh fit_features.bash 580.1 491.0 0.983 3.84 8.71 691 758.7 1 burglary 2m
sh fit_features.bash 475.8 576.3 0.549 1.69 2.94 315 542.4 4 street 2m
sh fit_features.bash 314.7 530.0 0.864 1.12 4.61 423 1147.9 2 street 2m
sh fit_features.bash 489.8 286.7 0.968 2.56 0.69 1199 451.9 4 all 2w
sh fit_features.bash 337.8 545.8 0.928 0.89 0.29 208 150.7 4 all 2w
sh fit_features.bash 521.5 418.8 0.055 1.06 7.97 156 920.3 5 street 1w
sh fit_features.bash 461.6 425.3 0.812 3.94 1.60 95 785.5 3 street 3m
sh fit_features.bash 483.6 595.9 0.252 1.80 6.81 780 198.1 4 all 1m
sh fit_features.bash 364.3 382.5 0.872 0.06 1.94 1164 990.8 2 street 1m
sh fit_features.bash 549.9 467.4 0.236 2.02 0.06 611 458.4 8 burglary 2w
sh fit_features.bash 589.5 469.1 0.091 3.02 4.89 642 1083.1 8 all 1w
sh fit_features.bash 576.3 452.2 0.419 3.10 7.34 191 356.8 7 street 1m
sh fit_features.bash 267.7 303.2 0.790 2.94 2.11 153 171.4 6 burglary 1w
sh fit_features.bash 274.4 537.4 0.411 2.06 11.96 185 234.7 3 all 1m
sh fit_features.bash 329.0 305.2 0.141 3.30 8.81 184 858.4 4 burglary 2w
sh fit_features.bash 525.4 505.0 0.665 2.49 9.20 1194 906.5 3 street 3m
sh fit_features.bash 367.3 416.1 0.903 1.99 5.83 684 893.1 4 burglary 1m
sh fit_features.bash 373.5 412.7 0.345 0.18 3.71 846 376.9 6 all 1m
sh fit_features.bash 558.0 388.8 0.465 3.28 9.56 1033 134.2 5 street 1w
sh fit_features.bash 322.7 263.6 0.321 0.29 5.36 949 731.8 7 all 2m
sh fit_features.bash 370.1 481.7 0.887 1.58 12.00 138 973.3 6 vehicle 1m
sh fit_features.bash 375.6 313.5 0.370 1.83 10.89 53 682.3 5 all 1w
sh fit_features.bash 326.3 412.9 0.777 0.20 3.48 521 917.6 2 all 1w
sh fit_features.bash 415.2 256.8 0.739 2.30 3.42 954 532.8 3 burglary 2w
sh fit_features.bash 446.9 369.6 0.741 3.08 8.49 1041 769.4 2 burglary 2m
sh fit_features.bash 260.9 334.8 0.418 3.23 2.89 1076 458.7 1 burglary 3m
sh fit_features.bash 377.8 588.2 0.208 0.69 9.97 901 174.9 8 street 2m
sh fit_features.bash 279.9 413.7 0.256 0.53 1.49 1151 966.9 1 burglary 2w
sh fit_features.bash 392.1 300.6 0.650 1.03 7.43 722 1199.5 3 burglary 1w
sh fit_features.bash 570.4 333.8 0.350 2.63 7.13 681 552.5 6 burglary 2m
sh fit_features.bash 423.9 574.8 0.819 1.41 10.19 273 112.0 1 all 2w
sh fit_features.bash 417.6 457.8 0.628 3.89 10.16 457 575.7 2 vehicle 2m
sh fit_features.bash 353.6 512.8 0.026 3.97 3.03 451 1071.0 5 all 3m
sh fit_features.bash 569.6 301.1 0.362 3.97 11.15 845 857.4 4 street 1m
sh fit_features.bash 579.8 250.7 0.851 2.22 5.85 1086 539.1 8 vehicle 1w
