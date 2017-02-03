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

sh fit_features.bash 397.5 411.4 0.368 2.79 5.81 107 1194.7 5 vehicle 2w
sh fit_features.bash 295.3 528.9 0.888 1.86 7.50 105 827.5 2 vehicle 2w
sh fit_features.bash 275.3 597.8 0.403 3.96 11.12 721 920.2 5 all 2w
sh fit_features.bash 512.1 419.6 0.018 1.93 7.96 251 323.8 4 all 2w
sh fit_features.bash 332.7 336.5 0.303 0.93 1.90 878 1058.5 2 all 1m
sh fit_features.bash 385.2 326.9 0.560 1.22 4.92 299 1152.7 2 all 2w
sh fit_features.bash 415.4 346.6 0.724 2.47 2.60 788 358.8 6 burglary 3m
sh fit_features.bash 589.2 390.0 0.906 3.64 1.76 140 420.1 3 all 1w
sh fit_features.bash 453.6 341.2 0.524 0.45 11.77 432 295.0 6 all 1w
sh fit_features.bash 516.8 358.0 0.037 0.06 3.94 302 344.5 3 vehicle 1m
sh fit_features.bash 275.4 371.9 0.698 0.62 6.55 783 687.7 2 all 1m
sh fit_features.bash 412.3 328.3 0.639 1.73 8.20 952 628.4 5 vehicle 3m
sh fit_features.bash 417.5 525.9 0.091 3.42 10.85 320 549.0 6 all 2w
sh fit_features.bash 496.7 268.5 0.136 0.16 0.69 284 845.1 2 burglary 1m
sh fit_features.bash 338.5 507.0 0.945 0.71 4.18 298 1135.2 3 burglary 2w
sh fit_features.bash 579.5 450.9 0.031 3.59 1.60 563 654.9 4 vehicle 1m
sh fit_features.bash 312.7 428.5 0.089 2.46 6.85 899 1154.4 4 burglary 1w
sh fit_features.bash 376.1 455.6 0.247 2.12 11.10 1104 493.5 1 vehicle 2w
sh fit_features.bash 576.3 566.1 0.304 0.44 6.71 297 875.1 1 street 2m
sh fit_features.bash 379.8 461.4 0.358 2.20 5.61 577 221.3 5 street 1w
sh fit_features.bash 319.8 529.3 0.257 1.15 0.87 349 926.1 5 all 2m
sh fit_features.bash 504.4 570.4 0.591 2.15 9.57 334 995.9 6 all 2m
sh fit_features.bash 328.0 330.2 0.124 1.63 4.89 303 762.9 1 burglary 1m
sh fit_features.bash 591.5 478.6 0.286 1.77 10.12 911 1139.3 4 all 3m
sh fit_features.bash 393.1 538.9 0.138 1.50 5.41 547 820.6 4 street 1m
sh fit_features.bash 487.9 338.6 0.365 1.58 5.85 1081 861.0 2 street 1w
sh fit_features.bash 588.8 311.9 0.601 1.04 2.46 499 713.9 3 burglary 1w
sh fit_features.bash 438.9 269.1 0.446 2.73 3.05 120 498.1 3 all 1w
sh fit_features.bash 443.0 583.8 0.902 1.74 5.46 624 669.8 3 all 3m
sh fit_features.bash 365.9 418.9 0.500 0.40 7.84 423 136.1 5 burglary 3m
sh fit_features.bash 542.5 274.6 0.717 3.75 10.86 918 631.5 5 burglary 1w
sh fit_features.bash 343.0 578.2 0.003 3.69 7.10 892 1099.8 5 all 1m
sh fit_features.bash 479.2 463.7 0.229 3.53 0.76 825 1138.0 6 street 2m
sh fit_features.bash 598.9 459.1 0.347 2.01 6.71 839 422.2 5 burglary 1w
sh fit_features.bash 280.0 278.3 0.197 3.70 3.04 322 791.1 2 street 1w
sh fit_features.bash 359.4 452.3 0.809 2.44 3.78 1051 137.7 5 vehicle 2m
sh fit_features.bash 351.2 481.3 0.942 2.71 4.35 126 183.7 1 burglary 2w
sh fit_features.bash 510.2 577.8 0.047 2.31 5.31 141 360.6 3 all 2m
sh fit_features.bash 577.9 365.7 0.762 0.10 4.46 953 243.5 3 vehicle 2w
sh fit_features.bash 391.6 369.4 0.995 2.44 11.81 843 1057.2 4 street 2m
sh fit_features.bash 568.4 426.5 0.614 0.88 10.93 201 388.7 4 vehicle 1w
sh fit_features.bash 531.5 382.9 0.023 0.96 0.77 974 785.4 4 all 2w
sh fit_features.bash 540.5 373.2 0.430 2.92 4.26 217 352.2 5 all 1m
sh fit_features.bash 341.9 334.1 0.537 1.32 8.34 601 840.9 4 street 1m
sh fit_features.bash 419.5 506.7 0.833 3.70 1.62 393 460.2 3 burglary 1w
sh fit_features.bash 306.6 291.6 0.349 3.03 3.92 492 700.5 2 vehicle 1m
sh fit_features.bash 334.6 280.6 0.760 2.09 0.53 981 902.8 3 vehicle 3m
sh fit_features.bash 583.8 311.9 0.156 1.61 0.67 935 1157.1 3 street 2m
sh fit_features.bash 580.1 293.2 0.488 0.51 3.15 281 237.6 1 burglary 2m
sh fit_features.bash 376.6 513.6 0.798 0.57 1.21 436 678.9 3 street 2m
sh fit_features.bash 307.1 297.4 0.993 1.69 8.25 874 939.2 3 all 3m
sh fit_features.bash 297.7 470.4 0.350 0.93 9.82 1199 545.0 3 burglary 1m
sh fit_features.bash 326.0 458.6 0.872 3.09 4.39 79 1078.7 4 street 3m
sh fit_features.bash 386.7 290.3 0.082 1.20 6.16 476 1171.5 6 burglary 1w
sh fit_features.bash 394.5 508.1 0.720 1.75 7.99 1108 997.7 4 vehicle 1m
sh fit_features.bash 469.7 267.2 0.088 1.24 2.07 1084 413.0 2 vehicle 1m
sh fit_features.bash 528.1 290.9 0.729 3.15 11.36 288 489.9 6 burglary 2m
sh fit_features.bash 599.9 460.1 0.572 0.91 8.13 266 323.2 6 burglary 2m
sh fit_features.bash 329.0 412.2 0.996 0.32 10.84 715 349.3 3 street 2w
sh fit_features.bash 458.7 270.1 0.660 3.28 3.93 461 865.7 3 street 1w
sh fit_features.bash 318.9 429.4 0.349 3.16 10.40 681 464.8 4 vehicle 2m
sh fit_features.bash 590.1 291.6 0.175 1.08 3.74 758 528.5 3 vehicle 2w
sh fit_features.bash 488.5 329.1 0.833 3.65 7.33 335 358.5 4 street 2w
sh fit_features.bash 345.8 572.4 0.471 1.09 6.96 327 1113.5 2 all 2m
sh fit_features.bash 473.1 496.8 0.783 2.76 5.60 1102 541.6 6 vehicle 2w
sh fit_features.bash 376.1 275.8 0.975 0.49 11.46 1064 156.8 3 street 1m
sh fit_features.bash 537.6 336.8 0.202 2.20 1.14 983 1101.5 4 burglary 2w
sh fit_features.bash 363.6 340.4 0.423 2.26 0.88 832 235.7 4 vehicle 1w
sh fit_features.bash 569.3 280.3 0.895 0.44 4.42 70 305.0 6 vehicle 2m
sh fit_features.bash 264.5 328.0 0.779 0.17 7.20 168 415.8 2 all 1m
sh fit_features.bash 501.6 485.2 0.074 0.33 5.70 875 541.3 5 all 2m
sh fit_features.bash 508.1 551.6 0.954 0.67 3.31 352 519.2 5 all 2w
sh fit_features.bash 525.6 321.0 0.222 1.07 9.37 984 705.6 3 all 1m
sh fit_features.bash 317.5 549.8 0.642 0.78 0.60 87 823.2 5 vehicle 2m
sh fit_features.bash 598.5 483.2 0.512 0.15 11.35 1131 180.3 5 street 1m
sh fit_features.bash 451.2 561.2 0.341 2.51 3.11 304 707.8 4 street 3m
sh fit_features.bash 527.6 432.1 0.492 1.89 8.50 303 286.2 1 all 2w
sh fit_features.bash 262.1 323.4 0.539 2.78 9.36 1083 947.4 6 burglary 3m
sh fit_features.bash 412.9 461.2 0.253 2.67 9.44 816 887.5 1 all 2m
sh fit_features.bash 543.9 551.4 0.318 2.79 2.78 428 1059.6 5 street 1m
sh fit_features.bash 336.8 377.9 0.001 3.46 8.92 708 589.1 4 burglary 1m
sh fit_features.bash 511.8 361.2 0.492 1.46 9.67 1066 518.2 1 vehicle 1w
sh fit_features.bash 559.2 334.8 0.663 1.96 1.10 894 402.3 4 all 2m
sh fit_features.bash 383.2 403.2 0.819 1.69 5.65 781 349.9 2 vehicle 1w
sh fit_features.bash 457.1 299.4 0.972 1.18 1.09 238 923.2 3 vehicle 2m
sh fit_features.bash 585.2 431.4 0.853 1.11 6.78 407 224.6 6 all 1w
sh fit_features.bash 442.5 456.7 0.053 2.40 6.94 817 249.5 1 burglary 2m
sh fit_features.bash 256.4 571.0 0.298 2.36 5.34 939 450.2 3 street 3m
sh fit_features.bash 562.1 527.2 0.681 3.59 2.19 527 182.8 4 street 1m
sh fit_features.bash 393.9 372.2 0.486 3.87 1.16 571 950.3 2 all 2w
sh fit_features.bash 275.5 255.4 0.395 1.76 11.28 853 303.3 4 all 2m
sh fit_features.bash 359.0 557.1 0.734 1.52 7.67 779 250.2 4 all 3m
sh fit_features.bash 301.1 290.3 0.138 1.86 8.41 1158 815.5 3 street 3m
sh fit_features.bash 358.5 310.0 0.406 0.69 8.43 334 422.1 1 all 2w
sh fit_features.bash 394.8 281.7 0.019 3.95 2.31 81 369.1 3 vehicle 1w
sh fit_features.bash 279.0 278.1 0.428 2.40 6.51 319 710.5 5 street 2m
sh fit_features.bash 487.9 393.4 0.194 2.82 6.64 52 735.6 6 vehicle 1w
sh fit_features.bash 432.8 257.5 0.667 2.98 2.72 897 795.5 5 all 2w
sh fit_features.bash 481.7 339.3 0.460 1.01 5.39 1190 766.6 1 street 1w
sh fit_features.bash 313.2 319.7 0.018 3.20 11.30 251 1109.4 5 all 2m
