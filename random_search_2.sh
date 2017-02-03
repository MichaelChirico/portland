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

sh fit_features.bash 326.2 339.9 0.139 1.89 11.04 410 472.5 1 street 2m
sh fit_features.bash 479.1 371.7 0.533 3.94 9.71 778 547.4 6 burglary 3m
sh fit_features.bash 513.5 501.2 0.328 0.74 5.21 940 889.4 2 vehicle 2m
sh fit_features.bash 272.9 426.1 0.546 1.45 6.94 303 646.1 1 vehicle 1m
sh fit_features.bash 349.9 596.0 0.430 3.60 5.16 727 433.9 4 all 2w
sh fit_features.bash 345.5 536.5 0.962 2.76 6.34 851 699.5 8 street 1m
sh fit_features.bash 431.5 359.5 0.156 2.62 4.28 612 1039.7 6 all 2m
sh fit_features.bash 486.0 336.4 0.051 3.56 2.63 1067 509.4 6 street 2w
sh fit_features.bash 406.6 406.4 0.691 3.83 11.63 491 417.6 4 burglary 2w
sh fit_features.bash 268.1 521.0 0.276 3.03 8.65 1176 1145.0 7 burglary 1w
sh fit_features.bash 584.1 507.2 0.608 3.48 7.09 227 453.9 7 vehicle 1w
sh fit_features.bash 515.2 436.1 0.381 1.47 5.64 363 582.9 3 all 3m
sh fit_features.bash 377.2 555.1 0.728 2.22 11.52 1155 589.7 7 vehicle 2w
sh fit_features.bash 253.1 501.7 0.440 3.79 10.96 183 1158.9 4 street 3m
sh fit_features.bash 377.2 309.8 0.539 1.62 1.65 131 1039.0 1 vehicle 2w
sh fit_features.bash 582.8 292.5 0.415 3.16 6.77 937 467.2 3 all 2w
sh fit_features.bash 374.1 251.4 0.805 3.79 0.90 628 994.2 5 all 2m
sh fit_features.bash 415.3 501.5 0.205 0.00 6.44 85 733.7 2 vehicle 3m
sh fit_features.bash 390.9 533.7 0.187 2.55 0.85 546 892.9 7 burglary 1m
sh fit_features.bash 502.6 340.0 0.502 2.90 7.05 1200 142.7 1 burglary 2m
sh fit_features.bash 380.9 501.4 0.483 1.44 8.45 668 472.4 4 vehicle 2m
sh fit_features.bash 327.4 271.9 0.344 0.77 8.96 571 1096.4 5 street 3m
sh fit_features.bash 307.3 542.8 0.695 0.64 7.68 330 586.8 4 street 2m
sh fit_features.bash 554.9 366.2 0.293 3.26 2.81 1075 792.7 1 street 1w
sh fit_features.bash 302.0 498.6 0.264 1.94 5.44 517 504.0 8 burglary 2w
sh fit_features.bash 353.0 464.4 0.657 3.08 8.34 814 866.7 6 street 1w
sh fit_features.bash 566.2 411.8 0.160 3.87 11.25 1124 305.6 2 all 1w
sh fit_features.bash 560.5 486.0 0.770 2.82 8.49 504 292.2 2 vehicle 1w
sh fit_features.bash 496.6 429.5 0.843 3.10 10.38 1025 900.4 3 vehicle 1w
sh fit_features.bash 492.8 263.4 0.439 0.41 7.36 715 667.6 3 burglary 2w
sh fit_features.bash 430.7 555.4 0.990 2.42 8.92 336 1002.0 4 street 3m
sh fit_features.bash 440.0 293.0 0.903 2.97 5.41 244 880.8 5 burglary 2w
sh fit_features.bash 382.1 391.7 0.322 0.03 11.49 642 272.3 2 burglary 3m
sh fit_features.bash 288.4 406.8 0.740 1.70 0.86 382 203.9 5 vehicle 1w
sh fit_features.bash 258.8 359.4 0.660 3.51 0.57 326 1156.6 7 vehicle 3m
sh fit_features.bash 356.1 412.7 0.303 0.13 1.14 261 1032.9 1 all 1m
sh fit_features.bash 524.1 305.9 0.704 2.07 5.84 549 790.3 8 street 2w
sh fit_features.bash 309.9 451.7 0.219 3.29 6.29 423 678.7 5 street 1w
sh fit_features.bash 525.4 379.9 0.754 2.47 4.33 430 532.4 7 street 1w
sh fit_features.bash 468.9 303.3 0.023 2.97 6.90 237 289.0 1 vehicle 2w
sh fit_features.bash 353.2 282.3 0.512 0.14 8.52 189 667.9 6 all 1m
sh fit_features.bash 390.9 575.3 0.260 2.83 5.29 781 1164.8 7 all 3m
sh fit_features.bash 573.2 509.3 0.135 0.15 4.95 66 515.5 2 street 2w
sh fit_features.bash 527.8 373.4 0.220 2.98 6.95 308 839.2 7 burglary 1w
sh fit_features.bash 277.7 488.7 0.428 1.51 0.75 168 816.2 2 all 2m
sh fit_features.bash 313.0 421.0 0.163 3.81 2.18 1020 960.5 7 street 2m
sh fit_features.bash 396.3 321.8 0.992 2.14 5.25 163 1037.8 6 burglary 3m
sh fit_features.bash 431.1 418.2 0.965 1.43 3.93 120 388.0 5 vehicle 1w
sh fit_features.bash 384.3 476.7 0.946 0.99 3.63 686 585.2 3 burglary 2w
sh fit_features.bash 462.8 597.9 0.639 0.08 1.24 324 1117.5 4 all 2w
sh fit_features.bash 597.7 362.1 0.459 1.92 2.13 839 113.2 1 burglary 1m
sh fit_features.bash 365.1 457.3 0.662 3.83 7.66 990 576.8 2 vehicle 1w
sh fit_features.bash 580.1 592.3 0.238 3.54 2.70 414 689.8 3 burglary 1w
sh fit_features.bash 598.0 532.1 0.969 0.86 6.49 324 1132.3 4 burglary 3m
sh fit_features.bash 323.4 421.8 0.158 3.57 7.70 332 886.4 8 burglary 1w
sh fit_features.bash 375.4 439.7 0.829 0.12 6.32 611 640.3 8 all 1m
sh fit_features.bash 506.6 560.9 0.748 1.99 4.69 958 359.3 7 burglary 3m
sh fit_features.bash 587.7 358.6 0.277 3.27 9.67 242 836.6 2 all 1m
sh fit_features.bash 321.9 428.3 0.841 0.71 2.09 538 911.2 4 burglary 2w
sh fit_features.bash 492.5 438.0 0.675 3.47 3.10 627 427.3 6 all 1m
sh fit_features.bash 349.1 312.1 0.089 2.54 2.19 149 1056.3 1 burglary 2w
sh fit_features.bash 592.4 344.3 0.558 1.94 2.57 799 785.0 8 street 2w
sh fit_features.bash 280.0 312.1 0.093 3.18 7.93 281 454.1 3 all 1m
sh fit_features.bash 538.1 525.8 0.428 1.56 9.51 128 730.5 7 all 3m
sh fit_features.bash 332.6 551.2 0.150 1.38 4.17 520 798.1 1 burglary 1w
sh fit_features.bash 388.7 560.2 0.702 0.27 3.21 1138 1054.7 3 burglary 3m
sh fit_features.bash 383.2 457.8 0.344 3.56 4.33 527 828.3 7 burglary 1m
sh fit_features.bash 312.5 278.2 0.915 2.91 11.06 708 1021.4 3 burglary 1w
sh fit_features.bash 405.0 353.1 0.581 1.64 0.15 165 201.1 8 vehicle 2m
sh fit_features.bash 368.4 567.7 0.403 1.87 2.58 1101 148.9 2 vehicle 1w
sh fit_features.bash 324.2 446.9 0.801 1.54 1.83 1163 1195.2 2 all 2m
sh fit_features.bash 432.8 471.3 0.951 1.06 11.54 659 376.5 4 burglary 3m
sh fit_features.bash 399.8 262.6 0.339 2.62 6.32 91 574.5 5 vehicle 1m
sh fit_features.bash 422.1 509.2 0.053 0.52 11.05 1038 844.6 8 vehicle 1w
sh fit_features.bash 422.3 509.0 0.124 1.20 11.32 726 292.4 5 all 2w
sh fit_features.bash 548.1 339.9 0.368 3.51 4.46 877 811.5 3 street 1w
sh fit_features.bash 396.6 425.4 0.089 2.95 7.31 877 724.6 2 all 2w
sh fit_features.bash 342.9 331.3 0.706 0.54 8.21 107 271.9 4 all 1m
sh fit_features.bash 537.2 513.8 0.570 0.94 7.00 627 1190.9 8 vehicle 1w
sh fit_features.bash 294.6 499.1 0.695 0.69 4.19 106 899.5 3 street 1m
sh fit_features.bash 541.9 478.3 0.449 3.81 3.37 807 896.6 1 burglary 1w
sh fit_features.bash 358.2 258.5 0.263 3.80 3.20 710 608.1 1 all 2m
sh fit_features.bash 493.6 314.7 0.616 2.01 2.49 430 412.3 3 street 3m
sh fit_features.bash 300.5 394.8 0.559 1.54 3.86 862 994.0 4 all 2w
sh fit_features.bash 571.3 313.7 0.068 2.85 0.42 1164 462.8 5 vehicle 2m
sh fit_features.bash 343.7 312.9 0.490 1.96 0.71 1131 617.3 3 burglary 1m
sh fit_features.bash 325.0 284.0 0.150 1.95 7.97 920 403.0 6 vehicle 2w
sh fit_features.bash 571.9 444.6 0.128 2.67 8.09 1189 737.9 1 street 1w
sh fit_features.bash 571.2 583.1 0.903 2.31 11.18 230 604.8 1 burglary 1w
sh fit_features.bash 561.4 403.9 0.006 2.09 5.89 499 521.3 3 all 1m
sh fit_features.bash 368.8 548.8 0.239 1.23 1.26 829 1180.6 1 all 2w
sh fit_features.bash 296.6 374.0 0.030 0.95 10.71 179 313.3 1 all 2w
sh fit_features.bash 449.4 403.9 0.806 1.65 9.39 393 105.2 7 vehicle 1w
sh fit_features.bash 501.2 333.8 0.204 1.04 5.13 144 202.2 8 street 2w
sh fit_features.bash 553.0 434.6 0.052 2.55 3.05 599 152.7 8 burglary 1w
sh fit_features.bash 524.0 491.0 0.538 2.89 10.38 888 611.6 3 all 2w
sh fit_features.bash 369.0 325.3 0.571 2.54 4.12 927 508.5 5 vehicle 2m
sh fit_features.bash 251.9 570.6 0.029 3.69 1.15 875 532.1 6 vehicle 1m
sh fit_features.bash 390.9 380.0 0.857 2.44 6.50 649 322.8 6 vehicle 3m
sh fit_features.bash 571.6 584.2 0.385 2.06 0.30 726 1052.0 5 all 2m
