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

sh fit_features.bash 457.7 524.0 0.441 0.69 5.71 371 780.4 5 vehicle 2w
sh fit_features.bash 253.6 317.0 0.679 2.81 2.67 495 778.8 4 vehicle 1m
sh fit_features.bash 277.5 399.1 0.232 3.13 3.56 206 347.3 3 all 3m
sh fit_features.bash 590.5 349.4 0.731 2.77 11.82 516 101.4 2 street 1m
sh fit_features.bash 449.1 349.9 0.514 1.89 10.76 460 1112.7 2 burglary 1m
sh fit_features.bash 250.1 546.4 0.450 2.71 4.57 1095 150.9 2 all 1w
sh fit_features.bash 515.4 506.0 0.405 1.18 5.56 457 367.2 4 burglary 1m
sh fit_features.bash 531.0 564.0 0.187 2.34 5.40 210 937.9 4 all 2m
sh fit_features.bash 306.8 347.1 0.937 2.89 5.68 437 435.6 4 burglary 3m
sh fit_features.bash 559.7 322.7 0.665 3.79 6.28 591 214.3 4 street 1m
sh fit_features.bash 256.4 508.1 0.340 2.43 9.07 663 1041.8 1 burglary 1w
sh fit_features.bash 269.8 397.7 0.186 1.80 10.32 285 1164.8 3 burglary 2w
sh fit_features.bash 540.3 426.6 0.064 2.11 0.90 555 957.9 6 burglary 2m
sh fit_features.bash 432.5 253.3 0.353 1.88 7.82 965 442.9 3 burglary 1m
sh fit_features.bash 497.8 541.0 0.032 3.43 11.56 1175 1068.9 5 burglary 1m
sh fit_features.bash 345.2 510.4 0.155 0.47 4.54 438 952.3 1 street 1w
sh fit_features.bash 468.5 285.8 0.119 1.61 10.33 147 466.0 5 burglary 2m
sh fit_features.bash 445.8 340.6 0.440 1.62 3.99 190 353.4 5 vehicle 2m
sh fit_features.bash 393.5 268.6 0.487 0.86 8.94 1026 476.9 3 vehicle 2m
sh fit_features.bash 552.8 383.9 0.688 3.95 5.05 734 907.3 1 street 2w
sh fit_features.bash 329.5 430.9 0.859 2.42 5.67 681 525.6 2 all 1w
sh fit_features.bash 527.0 322.1 0.783 2.02 2.24 400 982.6 1 burglary 1m
sh fit_features.bash 561.7 256.2 0.371 3.56 3.27 210 721.2 5 burglary 3m
sh fit_features.bash 586.7 361.9 0.197 2.33 10.20 852 612.3 2 vehicle 3m
sh fit_features.bash 459.2 596.6 0.878 2.40 3.72 739 991.8 3 vehicle 3m
sh fit_features.bash 458.3 501.2 0.592 1.12 2.88 496 679.0 2 burglary 2w
sh fit_features.bash 290.5 307.7 0.600 3.01 4.56 118 792.4 1 street 2m
sh fit_features.bash 439.8 578.9 0.477 1.55 4.60 975 891.2 1 all 2w
sh fit_features.bash 548.2 304.2 0.773 3.11 8.56 778 397.1 3 vehicle 1m
sh fit_features.bash 470.7 433.6 0.043 3.26 1.28 805 807.4 2 all 3m
sh fit_features.bash 547.1 587.3 0.670 2.19 10.62 1001 818.1 4 vehicle 1m
sh fit_features.bash 461.7 297.1 0.846 2.00 8.85 756 351.2 2 all 3m
sh fit_features.bash 564.9 424.1 0.906 2.37 4.52 157 1000.3 2 all 2w
sh fit_features.bash 416.3 286.7 0.064 2.03 5.96 587 450.8 1 street 1w
sh fit_features.bash 401.5 463.9 0.640 3.99 1.33 705 1168.6 5 burglary 1m
sh fit_features.bash 498.9 315.6 0.294 0.68 10.96 953 324.3 1 street 3m
sh fit_features.bash 340.1 428.5 0.924 1.38 2.19 1157 689.0 5 all 3m
sh fit_features.bash 405.0 258.3 0.341 1.20 5.11 304 475.7 5 all 3m
sh fit_features.bash 505.7 369.9 0.235 3.28 1.73 986 1006.6 1 street 1w
sh fit_features.bash 540.9 523.1 0.325 1.47 3.96 84 586.4 2 street 1w
sh fit_features.bash 290.7 483.8 0.574 1.25 2.76 995 338.8 5 street 1w
sh fit_features.bash 342.9 549.6 0.349 2.13 2.46 1116 345.5 2 vehicle 2w
sh fit_features.bash 268.0 321.8 0.584 3.40 6.25 503 1194.2 1 all 3m
sh fit_features.bash 553.9 379.8 0.693 3.18 10.28 903 811.3 4 burglary 2w
sh fit_features.bash 466.2 331.1 0.576 3.81 3.41 971 101.6 3 burglary 2w
sh fit_features.bash 576.3 595.0 0.583 0.58 5.35 701 638.7 5 street 2m
sh fit_features.bash 560.4 504.1 0.611 1.87 7.98 803 1086.5 1 vehicle 1m
sh fit_features.bash 315.2 423.9 0.980 3.03 4.17 946 122.8 4 all 3m
sh fit_features.bash 493.0 425.4 0.421 0.44 7.42 777 466.9 1 vehicle 1m
sh fit_features.bash 432.3 464.1 0.832 0.37 6.47 178 551.6 4 all 2w
sh fit_features.bash 570.3 370.7 0.036 2.69 7.22 120 577.2 1 vehicle 3m
sh fit_features.bash 554.2 545.9 0.219 1.52 2.93 1067 858.2 3 burglary 2m
sh fit_features.bash 533.6 329.0 0.997 3.34 0.03 760 792.5 4 burglary 2w
sh fit_features.bash 313.0 422.8 0.718 0.93 2.03 206 1059.4 6 all 2w
sh fit_features.bash 253.5 547.8 0.676 1.00 4.38 645 1166.8 3 all 1m
sh fit_features.bash 587.8 290.6 0.848 2.22 0.02 810 103.3 4 all 2m
sh fit_features.bash 327.4 516.2 0.127 2.69 3.13 317 990.4 2 vehicle 3m
sh fit_features.bash 322.7 330.1 0.356 2.24 9.20 884 910.1 6 all 1m
sh fit_features.bash 472.3 307.1 0.544 0.40 11.19 1158 555.7 5 street 1w
sh fit_features.bash 392.0 411.3 0.706 2.95 1.67 233 254.5 3 all 3m
sh fit_features.bash 450.3 439.4 0.584 0.69 1.73 214 1011.3 3 burglary 2m
sh fit_features.bash 343.8 576.8 0.023 1.76 7.78 613 610.0 4 all 1m
sh fit_features.bash 323.9 318.6 0.123 1.69 11.29 455 121.9 1 burglary 1w
sh fit_features.bash 260.6 414.9 0.229 1.77 1.54 547 1141.6 3 street 1w
sh fit_features.bash 410.9 487.0 0.703 3.23 7.23 346 867.2 3 vehicle 2w
sh fit_features.bash 456.6 532.2 0.321 0.79 11.70 353 1068.2 6 street 2m
sh fit_features.bash 359.9 309.1 0.003 3.59 3.30 349 819.1 4 burglary 1w
sh fit_features.bash 570.3 528.6 0.445 2.65 8.12 393 868.5 6 burglary 2w
sh fit_features.bash 395.9 550.3 0.375 2.72 7.88 1104 697.4 2 vehicle 2m
sh fit_features.bash 409.2 303.9 0.683 2.29 3.74 1024 787.4 2 all 2w
sh fit_features.bash 355.9 582.9 0.656 2.59 7.47 474 1106.2 2 vehicle 2m
sh fit_features.bash 481.1 464.6 0.702 1.23 6.93 1136 999.7 4 street 2m
sh fit_features.bash 314.7 288.4 0.849 1.59 6.68 73 366.7 2 burglary 3m
sh fit_features.bash 574.1 349.6 0.537 0.64 4.87 349 1040.5 3 street 2w
sh fit_features.bash 331.5 461.1 0.849 0.42 10.43 680 1094.3 6 street 1w
sh fit_features.bash 263.7 591.2 0.556 3.28 8.08 374 833.6 6 all 2w
sh fit_features.bash 402.2 385.9 0.939 3.17 11.79 497 630.8 3 vehicle 1w
sh fit_features.bash 511.2 267.7 0.882 3.22 5.78 760 1141.6 3 street 3m
sh fit_features.bash 450.6 280.6 0.881 2.23 11.01 692 964.9 5 street 2m
sh fit_features.bash 569.2 451.0 0.693 2.51 8.96 955 929.6 3 vehicle 2m
sh fit_features.bash 534.3 558.6 0.829 0.05 1.92 1074 457.8 1 street 1w
sh fit_features.bash 436.8 526.7 0.561 0.84 11.86 1030 599.4 1 street 2w
sh fit_features.bash 483.5 474.9 0.768 0.98 7.29 1117 346.3 5 burglary 2m
sh fit_features.bash 400.6 379.6 0.244 0.03 2.12 816 207.1 1 all 2m
sh fit_features.bash 289.0 364.4 0.021 1.88 1.42 799 1043.4 2 street 1m
sh fit_features.bash 580.4 446.5 0.956 1.64 3.35 528 820.4 1 street 2w
sh fit_features.bash 371.5 474.6 0.393 3.67 7.48 903 326.2 4 vehicle 1m
sh fit_features.bash 268.3 315.1 0.379 0.11 8.17 113 323.5 4 all 1m
sh fit_features.bash 471.1 263.7 0.761 1.27 10.62 1182 327.3 1 burglary 1w
sh fit_features.bash 463.0 558.5 0.318 3.57 8.16 624 621.0 5 all 2m
sh fit_features.bash 313.7 492.3 0.007 3.87 9.06 330 867.8 1 all 1m
sh fit_features.bash 382.6 376.2 0.130 2.35 5.68 1115 1023.5 5 burglary 3m
sh fit_features.bash 428.7 495.8 0.744 3.94 10.29 489 353.0 5 burglary 1m
sh fit_features.bash 479.7 494.1 0.058 0.99 10.09 394 553.7 3 vehicle 3m
sh fit_features.bash 282.7 257.7 0.082 3.23 5.42 188 1143.6 1 burglary 3m
sh fit_features.bash 526.2 522.5 0.468 1.26 3.02 109 559.4 5 street 2m
sh fit_features.bash 441.0 496.5 0.944 3.12 6.54 276 905.5 4 all 3m
sh fit_features.bash 364.3 511.0 0.256 3.53 0.02 1175 1109.8 6 street 1w
sh fit_features.bash 552.5 567.7 0.416 0.74 3.83 491 1088.1 4 vehicle 2w
sh fit_features.bash 303.1 368.1 0.274 1.65 10.17 477 464.2 4 all 1w
