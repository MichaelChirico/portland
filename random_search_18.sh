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

sh fit_features.bash 544.8 448.3 0.927 2.65 8.18 1051 760.0 2 burglary 2w
sh fit_features.bash 538.7 554.6 0.572 3.25 4.82 702 107.2 6 street 3m
sh fit_features.bash 439.3 570.9 0.047 3.69 2.29 298 879.1 4 all 1m
sh fit_features.bash 422.8 303.8 0.586 0.60 8.86 354 681.7 4 all 3m
sh fit_features.bash 271.1 487.8 0.167 1.74 2.39 347 922.3 4 vehicle 3m
sh fit_features.bash 585.2 371.9 0.414 1.01 10.65 360 972.8 1 vehicle 2m
sh fit_features.bash 548.0 288.7 0.621 0.09 10.15 691 168.3 6 burglary 3m
sh fit_features.bash 488.3 445.3 0.941 1.02 11.88 801 598.7 1 all 2m
sh fit_features.bash 525.5 291.2 0.403 2.53 5.76 420 866.2 1 vehicle 2w
sh fit_features.bash 275.8 488.8 0.796 3.68 9.98 705 738.6 3 burglary 1w
sh fit_features.bash 317.2 347.9 0.210 2.82 11.90 239 929.9 3 all 3m
sh fit_features.bash 291.8 398.0 0.316 1.10 2.62 783 300.2 6 all 3m
sh fit_features.bash 412.0 436.5 0.557 0.95 8.80 323 847.1 5 street 2m
sh fit_features.bash 437.3 389.6 0.780 1.36 5.07 906 393.5 3 burglary 2w
sh fit_features.bash 358.4 415.7 0.280 2.70 10.73 689 281.9 3 burglary 1w
sh fit_features.bash 390.5 527.1 0.298 0.39 1.18 487 512.0 4 burglary 1m
sh fit_features.bash 386.5 358.4 0.219 1.92 5.03 1182 1110.0 5 all 1m
sh fit_features.bash 343.3 587.6 0.393 0.85 5.62 925 862.7 4 street 3m
sh fit_features.bash 348.5 464.8 0.394 0.31 0.32 1072 974.1 5 street 3m
sh fit_features.bash 302.8 440.1 0.344 1.79 6.54 747 110.4 2 all 1w
sh fit_features.bash 283.0 402.9 0.152 2.04 8.93 1103 586.4 1 all 3m
sh fit_features.bash 399.5 479.9 0.367 0.62 1.06 1063 1028.8 4 vehicle 2w
sh fit_features.bash 571.1 490.3 0.936 2.23 3.53 246 319.7 1 burglary 1m
sh fit_features.bash 399.7 313.7 0.149 0.90 11.87 981 223.3 2 vehicle 2m
sh fit_features.bash 280.5 414.3 0.653 3.75 5.97 1099 161.5 6 all 2w
sh fit_features.bash 585.6 355.2 0.121 1.85 8.83 604 574.8 1 vehicle 1m
sh fit_features.bash 560.5 491.7 0.047 0.21 10.92 922 305.1 4 burglary 1w
sh fit_features.bash 563.6 363.1 0.641 2.01 5.61 1013 724.9 6 burglary 3m
sh fit_features.bash 470.6 370.3 0.734 0.38 0.26 980 757.1 1 street 3m
sh fit_features.bash 416.4 279.1 0.201 1.03 4.61 882 953.8 2 all 2m
sh fit_features.bash 372.9 304.9 0.615 0.75 2.41 264 749.4 3 all 1w
sh fit_features.bash 361.0 363.2 0.346 0.34 4.86 652 1186.7 2 burglary 1m
sh fit_features.bash 383.7 338.6 0.233 2.01 8.95 303 1067.9 3 street 1m
sh fit_features.bash 439.5 284.1 0.196 0.82 7.09 1005 115.9 6 street 1m
sh fit_features.bash 382.5 407.2 0.407 2.63 4.29 148 965.5 2 burglary 2m
sh fit_features.bash 435.0 502.2 0.126 1.48 11.82 246 1188.4 6 street 2m
sh fit_features.bash 310.6 581.4 0.588 2.65 6.76 432 1163.2 3 street 1w
sh fit_features.bash 354.6 524.3 0.390 1.24 0.65 419 719.8 1 street 2m
sh fit_features.bash 322.4 522.0 0.639 1.68 2.51 752 636.4 5 vehicle 2w
sh fit_features.bash 434.6 304.4 0.419 2.50 4.70 888 528.1 2 street 1w
sh fit_features.bash 307.8 485.9 0.238 2.17 0.05 976 157.6 6 burglary 2w
sh fit_features.bash 380.1 569.4 0.851 3.56 6.57 343 755.0 1 burglary 2m
sh fit_features.bash 357.6 277.5 0.547 2.99 2.94 587 522.1 5 burglary 3m
sh fit_features.bash 595.7 305.4 0.422 2.82 8.56 1079 1086.3 6 burglary 1w
sh fit_features.bash 458.7 591.7 0.764 0.88 7.41 68 497.8 3 all 1m
sh fit_features.bash 280.1 496.7 0.489 2.98 7.97 698 206.1 2 burglary 2m
sh fit_features.bash 296.8 414.4 0.637 1.23 4.00 609 691.3 3 street 2m
sh fit_features.bash 444.6 469.4 0.445 3.35 9.63 130 920.4 5 all 2m
sh fit_features.bash 313.7 267.6 0.045 1.37 9.52 1052 1120.0 1 all 1m
sh fit_features.bash 360.8 597.4 0.814 0.62 2.69 1082 277.2 6 burglary 2w
sh fit_features.bash 408.5 542.6 0.825 3.91 10.11 425 529.1 3 vehicle 1m
sh fit_features.bash 372.2 401.3 0.119 2.45 1.66 466 182.6 2 vehicle 2w
sh fit_features.bash 410.1 304.1 0.169 0.57 4.15 909 226.3 3 street 3m
sh fit_features.bash 285.7 514.8 0.143 0.89 6.70 247 116.2 2 all 1w
sh fit_features.bash 399.6 354.4 0.204 3.14 9.79 1074 1070.4 3 burglary 1m
sh fit_features.bash 403.9 535.5 0.545 3.47 1.77 373 1070.0 4 street 1w
sh fit_features.bash 532.6 419.7 0.903 2.13 3.52 695 1093.7 6 street 1m
sh fit_features.bash 396.4 457.8 0.453 2.51 4.67 747 539.6 4 burglary 1m
sh fit_features.bash 360.3 469.7 0.730 2.91 2.91 1177 810.8 5 vehicle 1w
sh fit_features.bash 461.7 478.9 0.936 2.13 9.86 1023 1164.5 3 street 3m
sh fit_features.bash 367.2 262.7 0.427 1.42 2.32 1113 1099.2 6 burglary 2w
sh fit_features.bash 558.8 592.7 0.847 2.31 8.03 1191 302.5 5 burglary 2m
sh fit_features.bash 280.8 295.1 0.588 2.27 2.97 984 848.6 3 street 1w
sh fit_features.bash 445.7 585.5 0.709 0.40 10.90 516 555.3 1 all 2w
sh fit_features.bash 262.6 378.2 0.015 2.82 3.09 811 1085.3 6 street 2w
sh fit_features.bash 456.7 475.4 0.561 3.57 2.22 1104 1138.4 4 all 2w
sh fit_features.bash 530.2 297.7 0.692 2.09 2.26 219 875.3 2 vehicle 1m
sh fit_features.bash 272.6 503.4 0.120 0.88 8.35 771 333.5 1 street 3m
sh fit_features.bash 524.5 309.7 0.180 3.93 1.57 224 1100.2 6 street 1m
sh fit_features.bash 310.7 405.2 0.475 2.84 0.87 1175 266.4 3 vehicle 3m
sh fit_features.bash 453.6 558.9 0.882 0.43 1.17 401 175.3 6 all 2w
sh fit_features.bash 534.3 298.5 0.361 1.80 5.75 464 1111.9 6 all 2m
sh fit_features.bash 509.8 484.3 0.729 1.47 6.71 656 124.1 4 all 3m
sh fit_features.bash 391.1 330.3 0.485 3.82 11.40 143 1070.1 6 vehicle 1w
sh fit_features.bash 558.2 507.3 0.788 3.36 4.51 940 867.5 6 all 3m
sh fit_features.bash 479.6 467.0 0.890 3.48 9.68 545 1175.8 3 burglary 1m
sh fit_features.bash 522.6 291.2 0.737 3.98 9.90 1162 1156.6 4 vehicle 2w
sh fit_features.bash 532.7 344.3 0.649 1.57 10.40 639 504.3 5 vehicle 2w
sh fit_features.bash 585.0 574.4 0.043 1.17 9.44 816 489.8 2 street 2m
sh fit_features.bash 319.1 273.9 0.896 1.98 8.48 516 226.6 5 vehicle 2w
sh fit_features.bash 583.3 276.0 0.067 1.25 0.21 729 786.0 3 burglary 1m
sh fit_features.bash 441.2 590.0 0.832 3.11 5.30 514 713.8 6 all 1m
sh fit_features.bash 431.9 492.0 0.927 2.49 11.94 465 413.6 5 street 3m
sh fit_features.bash 365.2 337.3 0.532 2.01 0.57 129 546.5 5 burglary 1w
sh fit_features.bash 400.4 273.9 0.461 3.35 0.75 296 1161.2 1 burglary 2w
sh fit_features.bash 517.7 339.0 0.297 1.27 2.59 561 1007.6 4 all 1w
sh fit_features.bash 551.0 397.4 0.386 1.57 2.16 235 518.5 3 all 2m
sh fit_features.bash 292.7 361.1 0.300 2.71 5.10 345 1029.8 5 all 2w
sh fit_features.bash 412.0 388.5 0.470 3.18 11.49 1008 217.7 2 all 1m
sh fit_features.bash 379.4 331.2 0.392 3.37 1.92 973 435.0 2 vehicle 3m
sh fit_features.bash 520.2 414.8 0.655 1.36 6.70 623 294.3 4 burglary 2m
sh fit_features.bash 596.4 380.1 0.387 1.22 5.99 446 822.1 1 all 2w
sh fit_features.bash 258.8 507.0 0.523 3.99 1.72 79 139.6 1 vehicle 1m
sh fit_features.bash 467.3 405.8 0.306 0.94 8.63 632 1172.5 4 all 2m
sh fit_features.bash 379.9 540.8 0.257 3.56 10.68 119 730.3 5 all 3m
sh fit_features.bash 445.0 338.4 0.706 0.14 8.78 122 1198.1 4 all 2m
sh fit_features.bash 276.2 352.3 0.022 1.71 9.31 61 973.4 5 vehicle 1m
sh fit_features.bash 293.6 337.6 0.244 1.24 6.31 679 563.7 4 all 3m
sh fit_features.bash 357.0 341.7 0.251 1.86 1.00 60 407.0 5 all 2w
sh fit_features.bash 458.4 489.5 0.745 0.26 9.76 860 438.4 1 burglary 2w
