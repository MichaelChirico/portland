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

sh fit_features.bash 340.5 311.3 0.729 3.66 9.72 333 607.8 5 burglary 1m
sh fit_features.bash 287.6 597.0 0.447 1.15 1.24 142 661.7 6 burglary 1m
sh fit_features.bash 560.3 379.0 0.276 3.25 8.45 700 1105.8 3 vehicle 2m
sh fit_features.bash 374.1 463.2 0.499 1.09 3.97 204 565.6 7 vehicle 1w
sh fit_features.bash 420.8 588.3 0.749 2.29 10.55 465 824.7 8 burglary 3m
sh fit_features.bash 400.5 486.1 0.968 1.92 1.80 262 859.8 3 street 3m
sh fit_features.bash 590.9 593.3 0.573 2.40 3.40 637 1132.2 3 burglary 2w
sh fit_features.bash 498.9 277.6 0.018 0.96 3.27 865 619.5 2 burglary 3m
sh fit_features.bash 489.1 521.4 0.691 2.54 3.25 1037 167.6 3 all 1m
sh fit_features.bash 469.5 595.8 0.401 3.85 3.30 265 509.9 4 vehicle 3m
sh fit_features.bash 370.6 254.7 0.396 2.75 7.24 1179 479.3 6 all 3m
sh fit_features.bash 413.6 593.6 0.078 3.13 5.93 785 1049.4 7 all 2m
sh fit_features.bash 268.6 498.8 0.842 1.58 7.91 448 110.6 5 vehicle 3m
sh fit_features.bash 408.7 454.1 0.137 0.82 9.63 513 438.4 3 street 2w
sh fit_features.bash 376.6 512.4 0.951 3.41 9.35 248 120.6 1 burglary 1m
sh fit_features.bash 578.7 250.9 0.836 0.14 10.97 956 1037.3 7 street 2m
sh fit_features.bash 526.7 584.0 0.962 3.51 5.48 823 955.3 5 vehicle 3m
sh fit_features.bash 416.6 335.0 0.864 3.03 9.04 265 119.2 5 vehicle 1m
sh fit_features.bash 389.5 322.4 0.814 0.62 4.63 222 468.7 4 all 3m
sh fit_features.bash 501.7 424.9 0.306 2.62 8.89 970 217.3 2 street 3m
sh fit_features.bash 328.9 307.0 0.651 2.49 5.02 358 335.5 2 street 1m
sh fit_features.bash 551.5 272.5 0.534 3.63 7.48 995 101.0 2 vehicle 3m
sh fit_features.bash 595.7 522.7 0.672 1.17 2.62 1025 166.5 5 all 2w
sh fit_features.bash 541.4 265.6 0.693 3.12 1.01 398 131.6 3 all 1w
sh fit_features.bash 259.3 347.5 0.559 0.59 1.36 1027 569.9 4 street 2w
sh fit_features.bash 433.4 442.1 0.004 2.76 6.43 911 965.2 5 street 1w
sh fit_features.bash 264.9 329.5 0.834 3.71 8.51 373 535.3 5 vehicle 3m
sh fit_features.bash 360.8 408.3 0.416 1.71 4.29 1075 411.6 8 burglary 2m
sh fit_features.bash 340.8 510.3 0.850 2.64 1.70 999 159.6 1 street 1m
sh fit_features.bash 373.5 521.7 0.669 3.15 0.57 931 411.2 6 all 2m
sh fit_features.bash 287.1 291.3 0.610 1.10 5.35 177 845.7 4 street 1w
sh fit_features.bash 584.9 346.1 0.685 0.74 7.32 529 618.6 6 street 1w
sh fit_features.bash 368.4 264.9 0.070 2.34 7.12 875 1074.0 2 street 3m
sh fit_features.bash 348.1 344.3 0.700 0.73 4.02 302 207.0 4 all 2m
sh fit_features.bash 419.8 277.0 0.334 3.86 0.99 470 357.5 8 street 2w
sh fit_features.bash 542.7 359.1 0.746 0.12 10.09 554 1046.6 1 street 1w
sh fit_features.bash 438.8 506.5 0.329 1.47 0.13 1102 183.4 5 street 2w
sh fit_features.bash 338.4 475.1 0.506 1.33 10.18 793 168.7 4 all 2m
sh fit_features.bash 562.2 544.3 0.880 1.02 2.49 1018 287.6 2 street 2m
sh fit_features.bash 492.9 267.0 0.190 3.48 0.25 79 657.3 1 vehicle 3m
sh fit_features.bash 444.3 522.2 0.340 0.08 4.25 108 498.1 2 vehicle 1w
sh fit_features.bash 269.9 348.0 0.443 2.46 9.44 335 567.2 5 all 1w
sh fit_features.bash 578.0 351.9 0.112 2.44 10.05 352 937.9 8 street 3m
sh fit_features.bash 540.7 495.2 0.788 0.20 1.02 507 654.8 3 burglary 3m
sh fit_features.bash 251.2 282.3 0.061 0.98 7.30 676 988.1 4 all 1w
sh fit_features.bash 483.5 295.3 0.925 1.86 3.04 803 196.4 6 burglary 1w
sh fit_features.bash 502.6 316.0 0.086 0.90 5.81 742 270.0 2 street 3m
sh fit_features.bash 393.9 498.6 0.553 2.05 10.70 397 234.6 5 all 1w
sh fit_features.bash 285.5 375.7 0.272 0.23 8.89 99 567.9 1 all 3m
sh fit_features.bash 256.6 358.6 0.539 0.74 10.75 959 978.7 6 all 2w
sh fit_features.bash 332.0 592.5 0.063 3.77 1.43 119 718.3 7 street 1m
sh fit_features.bash 456.6 544.7 0.136 0.25 10.06 999 500.2 7 burglary 3m
sh fit_features.bash 322.8 342.5 0.389 0.47 8.48 405 126.4 2 vehicle 2w
sh fit_features.bash 582.2 425.2 0.120 1.32 4.64 516 527.7 8 vehicle 1w
sh fit_features.bash 477.6 594.4 0.420 2.41 7.26 762 141.2 3 street 3m
sh fit_features.bash 564.3 291.7 0.615 1.48 9.25 153 1040.6 3 street 1m
sh fit_features.bash 459.6 435.6 0.166 3.59 10.80 690 192.4 7 vehicle 2w
sh fit_features.bash 332.2 518.9 0.226 2.91 5.22 774 417.1 6 street 1w
sh fit_features.bash 463.4 318.2 0.897 2.21 5.87 1057 425.3 2 vehicle 3m
sh fit_features.bash 515.3 362.0 0.592 0.63 3.71 366 1130.8 7 burglary 2w
sh fit_features.bash 310.5 443.3 0.147 2.57 0.80 578 451.2 1 all 1m
sh fit_features.bash 310.6 540.6 0.632 3.72 1.52 1186 1163.4 7 vehicle 3m
sh fit_features.bash 470.7 500.0 0.080 0.23 1.81 892 778.1 6 burglary 2m
sh fit_features.bash 429.8 575.9 0.591 1.16 11.37 486 548.7 2 vehicle 1w
sh fit_features.bash 291.2 334.7 0.418 1.05 3.54 929 761.3 7 vehicle 2w
sh fit_features.bash 592.7 495.4 0.832 1.68 11.48 395 1160.5 8 street 1w
sh fit_features.bash 282.6 408.7 0.529 0.48 10.48 178 994.3 2 vehicle 2m
sh fit_features.bash 542.2 446.7 0.925 1.66 8.23 818 514.1 7 vehicle 2m
sh fit_features.bash 585.6 439.2 0.841 3.03 8.24 469 738.1 1 burglary 2m
sh fit_features.bash 290.0 511.4 0.414 1.29 4.82 985 758.8 5 burglary 2w
sh fit_features.bash 400.6 449.0 0.767 1.55 3.75 601 896.9 5 vehicle 1w
sh fit_features.bash 372.0 514.8 0.545 1.66 7.69 498 511.9 6 vehicle 1w
sh fit_features.bash 538.6 315.3 0.833 2.49 1.77 98 882.6 3 street 2m
sh fit_features.bash 382.7 597.9 0.424 3.17 5.14 625 1029.3 7 street 2m
sh fit_features.bash 385.6 580.4 0.939 0.20 7.60 889 552.3 3 all 1w
sh fit_features.bash 449.6 408.3 0.802 1.23 10.29 436 405.7 7 all 1m
sh fit_features.bash 379.7 354.1 0.673 0.01 3.06 419 243.7 2 burglary 3m
sh fit_features.bash 362.4 393.3 0.517 1.87 3.68 58 521.0 3 burglary 1w
sh fit_features.bash 355.1 520.6 0.199 0.03 9.29 512 192.1 1 vehicle 1w
sh fit_features.bash 385.4 540.4 0.626 0.23 3.27 317 950.4 3 burglary 1m
sh fit_features.bash 518.6 370.4 0.911 3.96 11.89 954 1040.0 6 street 1w
sh fit_features.bash 545.7 359.7 0.171 1.01 5.52 704 712.5 5 burglary 3m
sh fit_features.bash 393.0 586.4 0.353 3.06 0.68 877 859.7 8 street 2w
sh fit_features.bash 469.4 528.4 0.250 2.26 6.37 769 971.8 1 vehicle 2m
sh fit_features.bash 390.7 564.7 0.050 3.07 0.50 92 225.4 6 burglary 1m
sh fit_features.bash 406.2 428.4 0.540 0.14 10.24 1098 429.9 2 vehicle 3m
sh fit_features.bash 413.7 255.6 0.933 3.79 4.51 561 182.8 5 all 3m
sh fit_features.bash 348.8 452.2 0.301 1.32 9.46 439 202.4 6 street 1w
sh fit_features.bash 362.9 520.4 0.097 0.15 9.50 316 385.0 5 vehicle 1w
sh fit_features.bash 264.9 564.5 0.433 2.01 10.07 934 492.5 1 vehicle 1m
sh fit_features.bash 418.2 260.0 0.413 0.97 11.48 127 680.9 7 vehicle 3m
sh fit_features.bash 420.6 590.5 0.572 1.43 3.20 1128 732.5 8 all 1w
sh fit_features.bash 499.4 261.1 0.180 1.53 1.77 695 637.3 6 vehicle 3m
sh fit_features.bash 277.4 344.4 0.023 3.95 3.08 710 329.0 8 burglary 2w
sh fit_features.bash 383.4 264.5 0.168 2.74 0.75 88 236.3 8 all 1m
sh fit_features.bash 563.7 391.1 0.972 2.36 11.64 485 486.9 3 burglary 2m
sh fit_features.bash 265.2 512.5 0.065 0.58 0.51 943 627.6 6 burglary 1w
sh fit_features.bash 335.9 358.0 0.808 1.09 4.56 1199 710.1 1 burglary 1m
sh fit_features.bash 509.2 389.7 0.535 2.22 4.24 613 1133.5 3 street 2w
sh fit_features.bash 399.8 300.3 0.063 0.50 7.95 120 1056.4 3 street 2w
