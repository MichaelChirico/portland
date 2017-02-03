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

sh fit_features.bash 512.6 324.9 0.355 0.67 9.34 327 198.8 4 burglary 2w
sh fit_features.bash 573.4 315.9 0.269 3.08 10.94 838 1074.1 7 burglary 2m
sh fit_features.bash 433.8 375.7 0.032 0.23 1.30 201 595.0 7 all 2w
sh fit_features.bash 295.1 252.4 0.528 0.65 9.93 895 188.8 6 vehicle 1w
sh fit_features.bash 318.2 464.0 0.003 0.30 9.69 345 1174.7 5 vehicle 1m
sh fit_features.bash 534.1 554.8 0.190 1.09 0.31 174 297.6 6 burglary 2w
sh fit_features.bash 507.2 589.9 0.145 2.65 7.25 685 230.0 1 all 1w
sh fit_features.bash 290.1 285.5 0.754 3.62 9.08 232 1063.8 6 all 2w
sh fit_features.bash 475.0 421.0 0.673 1.43 4.52 1100 613.8 1 street 1m
sh fit_features.bash 524.4 261.6 0.028 0.16 0.18 666 782.9 2 street 2w
sh fit_features.bash 311.9 344.2 0.898 3.14 9.04 848 607.1 5 burglary 1m
sh fit_features.bash 550.5 283.4 0.870 0.37 6.72 179 154.1 3 street 3m
sh fit_features.bash 313.7 382.7 0.929 3.96 2.29 1187 223.0 1 all 2m
sh fit_features.bash 311.1 307.0 0.698 1.06 4.62 292 383.3 1 vehicle 2m
sh fit_features.bash 498.9 320.7 0.647 0.30 8.36 998 285.2 7 vehicle 1m
sh fit_features.bash 564.6 383.5 0.518 3.55 10.74 587 669.1 8 vehicle 1w
sh fit_features.bash 591.1 501.3 0.014 2.06 3.73 320 1168.9 1 street 3m
sh fit_features.bash 321.4 368.0 0.583 1.62 8.46 319 474.1 7 all 3m
sh fit_features.bash 380.9 511.1 0.665 0.35 7.60 181 634.6 5 vehicle 1w
sh fit_features.bash 358.9 482.2 0.031 0.20 1.87 566 320.1 6 burglary 3m
sh fit_features.bash 427.7 538.9 0.514 3.76 8.49 822 731.9 6 burglary 1m
sh fit_features.bash 289.8 468.0 0.308 2.09 0.77 466 383.2 2 burglary 1m
sh fit_features.bash 356.1 537.1 0.904 1.95 11.64 716 774.2 1 vehicle 3m
sh fit_features.bash 540.2 406.7 0.055 1.94 6.59 814 325.9 6 burglary 1w
sh fit_features.bash 442.5 366.1 0.470 0.89 6.55 92 780.2 6 burglary 1w
sh fit_features.bash 282.6 593.5 0.328 0.89 3.34 509 1104.0 4 vehicle 3m
sh fit_features.bash 251.2 598.1 0.326 1.37 10.42 688 239.1 6 street 3m
sh fit_features.bash 530.0 559.4 0.198 0.94 6.39 1033 1043.9 6 vehicle 2w
sh fit_features.bash 293.0 255.0 0.738 2.12 6.95 684 710.5 4 all 2w
sh fit_features.bash 281.6 481.5 0.956 3.38 2.55 900 1197.4 6 street 2m
sh fit_features.bash 395.4 389.6 0.750 3.24 5.08 221 558.0 5 vehicle 1w
sh fit_features.bash 478.6 333.9 0.644 1.95 2.84 1116 479.4 4 vehicle 2m
sh fit_features.bash 448.8 250.6 0.260 3.93 9.80 1045 169.5 6 street 1w
sh fit_features.bash 333.3 286.8 0.311 1.53 11.04 252 120.4 6 street 3m
sh fit_features.bash 520.8 275.8 0.829 2.11 6.76 974 128.5 4 all 2m
sh fit_features.bash 444.3 399.6 0.391 3.74 2.75 144 543.9 2 vehicle 1m
sh fit_features.bash 393.8 460.8 0.356 3.67 5.91 1106 441.1 6 street 3m
sh fit_features.bash 277.5 412.0 0.383 2.35 1.36 956 1126.7 3 street 2m
sh fit_features.bash 509.7 265.6 0.089 1.42 5.30 977 852.6 1 burglary 1m
sh fit_features.bash 425.0 551.2 0.583 1.39 9.05 976 1034.9 7 all 2w
sh fit_features.bash 469.9 425.8 0.916 0.61 10.38 735 1082.1 7 burglary 1m
sh fit_features.bash 414.5 473.9 0.097 1.41 5.40 1023 835.4 4 all 2m
sh fit_features.bash 362.7 397.6 0.967 0.07 4.59 698 1142.6 3 street 1w
sh fit_features.bash 264.2 335.9 0.114 1.70 10.56 965 303.6 5 vehicle 1w
sh fit_features.bash 339.6 453.9 0.909 3.65 3.96 951 927.3 3 vehicle 1m
sh fit_features.bash 598.5 370.6 0.052 0.54 11.00 63 1134.9 5 vehicle 3m
sh fit_features.bash 274.9 253.4 0.444 2.25 2.46 433 990.1 7 burglary 2w
sh fit_features.bash 436.6 312.5 0.982 0.39 8.45 351 686.9 1 all 1w
sh fit_features.bash 434.2 296.5 0.563 3.79 3.12 51 299.4 3 vehicle 3m
sh fit_features.bash 303.3 574.5 0.246 3.44 1.97 846 646.2 5 burglary 2m
sh fit_features.bash 289.5 477.3 0.494 3.58 4.33 178 928.0 7 burglary 2m
sh fit_features.bash 407.0 577.4 0.527 2.33 10.50 208 217.3 5 burglary 2w
sh fit_features.bash 524.1 266.2 0.626 1.16 3.36 938 513.0 8 all 2w
sh fit_features.bash 502.6 554.7 0.575 2.71 2.93 782 638.1 5 burglary 1m
sh fit_features.bash 557.0 434.9 0.110 0.95 11.93 798 923.3 4 vehicle 1m
sh fit_features.bash 497.9 429.3 0.928 1.11 4.56 1199 536.9 7 vehicle 1w
sh fit_features.bash 472.8 286.3 0.727 3.83 7.72 395 738.9 6 street 1m
sh fit_features.bash 261.4 591.1 0.803 1.24 9.17 522 799.3 7 all 3m
sh fit_features.bash 580.9 525.2 0.404 0.62 4.83 910 935.5 5 all 1m
sh fit_features.bash 335.9 369.0 0.480 0.09 11.68 940 333.7 6 burglary 2w
sh fit_features.bash 543.0 463.5 0.203 2.64 5.14 112 1018.6 3 street 2w
sh fit_features.bash 598.0 491.1 0.863 0.58 2.57 651 476.9 2 vehicle 1w
sh fit_features.bash 389.7 462.8 0.481 0.91 11.83 148 620.4 2 burglary 2m
sh fit_features.bash 558.7 472.6 0.455 1.64 11.46 1123 960.9 6 vehicle 3m
sh fit_features.bash 541.9 416.1 0.724 3.95 7.71 65 645.0 2 street 1w
sh fit_features.bash 437.5 420.6 0.718 2.24 3.36 1125 133.3 1 street 1w
sh fit_features.bash 547.9 468.8 0.002 1.30 0.15 778 899.3 1 burglary 3m
sh fit_features.bash 484.3 268.3 0.442 1.93 11.13 689 180.3 4 vehicle 1m
sh fit_features.bash 588.2 514.8 0.812 0.18 10.37 993 1080.1 1 street 2m
sh fit_features.bash 279.7 488.7 0.346 2.45 7.75 201 223.8 5 burglary 3m
sh fit_features.bash 268.0 328.3 0.398 2.29 3.29 383 1048.5 6 vehicle 2m
sh fit_features.bash 365.8 273.7 0.337 0.62 2.52 828 284.0 8 vehicle 1w
sh fit_features.bash 593.1 292.3 0.555 2.06 0.59 143 164.4 3 vehicle 1m
sh fit_features.bash 401.7 436.8 0.534 1.65 0.44 413 1001.1 6 all 2w
sh fit_features.bash 376.4 270.7 0.437 1.68 11.43 937 560.9 3 street 2w
sh fit_features.bash 486.4 547.6 0.801 0.06 6.39 122 266.7 6 vehicle 1m
sh fit_features.bash 347.5 384.0 0.735 1.87 6.16 85 964.5 7 burglary 1w
sh fit_features.bash 340.6 405.6 0.701 2.13 1.10 315 647.5 3 all 3m
sh fit_features.bash 361.5 434.6 0.112 3.12 8.44 757 663.2 6 all 1w
sh fit_features.bash 413.4 558.9 0.414 1.15 7.02 341 585.1 8 burglary 1w
sh fit_features.bash 260.8 465.6 0.001 1.70 4.67 374 152.5 3 street 2w
sh fit_features.bash 289.8 454.9 0.628 3.25 8.52 742 342.7 1 all 3m
sh fit_features.bash 534.3 420.0 0.315 1.54 7.52 982 571.4 2 vehicle 2w
sh fit_features.bash 420.7 384.5 0.803 2.80 8.11 104 583.0 3 all 2m
sh fit_features.bash 317.8 329.0 0.376 2.95 6.46 508 463.5 4 street 2w
sh fit_features.bash 488.8 575.4 0.518 3.10 7.35 549 712.0 6 vehicle 3m
sh fit_features.bash 577.0 415.3 0.871 0.13 2.85 423 603.6 2 all 2m
sh fit_features.bash 275.1 262.5 0.162 0.93 8.18 448 539.4 2 street 3m
sh fit_features.bash 566.4 407.0 0.931 1.72 7.52 609 701.1 4 all 3m
sh fit_features.bash 579.6 289.4 0.004 0.74 7.60 739 190.9 5 all 1m
sh fit_features.bash 456.4 321.3 0.345 1.50 10.67 61 404.4 1 street 2w
sh fit_features.bash 253.3 310.3 0.988 3.29 10.17 327 883.9 4 all 2w
sh fit_features.bash 464.7 558.4 0.216 1.94 9.46 648 616.2 2 street 1w
sh fit_features.bash 463.3 461.8 0.402 0.06 10.63 163 899.2 6 burglary 2w
sh fit_features.bash 410.5 509.3 0.766 3.40 1.79 1127 640.3 7 vehicle 2m
sh fit_features.bash 290.4 530.6 0.514 0.18 11.80 87 1012.7 7 burglary 1w
sh fit_features.bash 288.2 395.7 0.584 0.70 3.64 83 540.4 5 burglary 1w
sh fit_features.bash 511.0 309.6 0.867 1.14 4.35 221 246.4 4 all 1w
sh fit_features.bash 574.6 395.8 0.004 2.62 11.97 783 857.2 3 vehicle 1w
sh fit_features.bash 254.3 589.2 0.489 3.06 11.63 496 778.4 6 vehicle 3m
