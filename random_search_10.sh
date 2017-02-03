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

sh fit_features.bash 448.7 295.2 0.909 3.88 0.66 1080 1093.4 3 vehicle 1w
sh fit_features.bash 297.4 482.4 0.483 1.91 9.27 906 595.1 4 vehicle 1w
sh fit_features.bash 414.0 525.9 0.460 1.61 4.75 819 427.1 2 vehicle 2m
sh fit_features.bash 564.2 558.0 0.323 1.10 1.74 1117 757.4 1 street 1w
sh fit_features.bash 422.8 486.4 0.429 0.04 8.08 651 571.1 1 vehicle 1m
sh fit_features.bash 290.5 573.6 0.961 1.04 6.68 404 840.2 2 street 2w
sh fit_features.bash 502.9 470.8 0.398 2.01 7.32 462 1081.9 3 street 1m
sh fit_features.bash 304.4 307.5 0.638 3.19 3.14 183 646.2 2 all 3m
sh fit_features.bash 327.5 303.1 0.069 3.45 7.44 459 873.0 6 all 2m
sh fit_features.bash 414.9 488.3 0.078 0.47 3.08 151 251.6 3 street 3m
sh fit_features.bash 410.3 589.9 0.060 0.76 8.98 58 1182.6 5 all 1w
sh fit_features.bash 561.9 481.3 0.381 1.11 6.51 869 410.3 5 street 2w
sh fit_features.bash 511.3 387.2 0.062 1.71 4.44 689 607.6 2 all 2m
sh fit_features.bash 496.0 436.8 0.175 1.21 4.88 933 1184.1 1 street 1m
sh fit_features.bash 587.7 569.4 0.540 2.86 6.13 1096 750.1 1 street 1w
sh fit_features.bash 383.7 566.6 0.199 1.54 11.67 1127 202.8 2 burglary 2m
sh fit_features.bash 454.7 294.9 0.589 2.20 1.04 690 579.2 4 vehicle 2w
sh fit_features.bash 508.9 308.4 0.471 3.77 5.58 379 796.5 4 burglary 2w
sh fit_features.bash 579.7 451.0 0.099 3.01 5.93 469 514.1 5 burglary 2w
sh fit_features.bash 578.0 457.5 0.446 3.54 3.94 410 663.6 5 burglary 3m
sh fit_features.bash 434.1 478.1 0.539 3.82 3.44 326 766.6 6 all 2m
sh fit_features.bash 470.3 304.6 0.560 1.07 1.93 879 320.8 3 burglary 3m
sh fit_features.bash 350.1 499.8 0.752 1.38 4.94 451 1125.9 2 street 1m
sh fit_features.bash 519.7 370.2 0.886 3.97 10.37 1015 658.2 1 vehicle 3m
sh fit_features.bash 565.8 268.7 0.274 1.24 0.15 1162 347.0 2 vehicle 2m
sh fit_features.bash 589.7 591.3 0.747 0.51 7.49 1172 674.4 2 all 2m
sh fit_features.bash 418.0 410.7 0.234 2.03 7.05 788 637.1 5 street 1m
sh fit_features.bash 281.0 257.7 0.146 2.35 2.55 994 277.0 1 burglary 1w
sh fit_features.bash 525.6 428.0 0.542 0.70 10.63 728 560.4 3 burglary 2m
sh fit_features.bash 320.8 365.7 0.329 2.63 2.93 717 758.7 5 burglary 3m
sh fit_features.bash 379.7 342.4 0.565 3.02 0.51 995 1030.2 1 street 1m
sh fit_features.bash 417.6 307.6 0.700 1.19 8.57 973 872.9 2 vehicle 1m
sh fit_features.bash 411.6 398.4 0.069 3.44 8.37 455 152.8 1 all 2w
sh fit_features.bash 525.1 424.7 0.951 1.45 1.35 1139 777.4 3 vehicle 1w
sh fit_features.bash 451.4 580.2 0.539 3.66 4.08 642 237.9 2 vehicle 2w
sh fit_features.bash 376.3 414.9 0.804 2.45 5.89 108 1167.0 2 all 1m
sh fit_features.bash 553.9 598.1 0.134 2.66 4.65 817 700.6 1 street 1m
sh fit_features.bash 370.4 441.8 0.983 1.25 10.62 672 901.8 3 vehicle 3m
sh fit_features.bash 360.4 407.1 0.762 1.35 7.29 283 237.4 4 burglary 1m
sh fit_features.bash 287.9 394.5 0.247 2.46 2.51 785 104.9 2 street 2m
sh fit_features.bash 282.1 456.5 0.221 1.13 10.71 493 278.3 6 burglary 2m
sh fit_features.bash 539.7 593.1 0.146 3.50 7.54 842 550.7 5 street 2m
sh fit_features.bash 280.0 577.4 0.059 0.36 5.26 855 925.8 6 burglary 3m
sh fit_features.bash 541.1 364.8 0.976 2.04 4.25 1098 181.1 5 all 1m
sh fit_features.bash 576.3 411.0 0.844 0.29 7.79 791 101.4 4 burglary 1m
sh fit_features.bash 388.3 338.9 0.671 0.24 8.76 51 471.8 6 vehicle 1m
sh fit_features.bash 348.4 471.4 0.255 2.94 9.98 1134 361.1 6 all 1w
sh fit_features.bash 310.2 252.6 0.909 1.79 1.45 1132 851.1 5 vehicle 3m
sh fit_features.bash 431.4 402.5 0.791 1.80 2.30 733 1160.0 2 vehicle 1w
sh fit_features.bash 453.3 523.9 0.315 1.03 2.98 861 192.2 5 burglary 2m
sh fit_features.bash 307.7 503.8 0.840 0.48 8.97 858 337.6 1 burglary 1w
sh fit_features.bash 311.7 444.9 0.312 0.15 1.33 112 730.0 6 street 1m
sh fit_features.bash 407.7 271.3 0.717 0.94 9.06 1167 1040.8 2 all 1w
sh fit_features.bash 351.9 365.4 0.371 1.83 8.78 335 547.4 5 street 2m
sh fit_features.bash 535.1 288.0 0.737 3.67 9.57 138 479.2 6 burglary 2m
sh fit_features.bash 496.9 538.1 0.450 3.52 8.33 94 1007.7 5 street 2w
sh fit_features.bash 326.7 557.7 0.871 0.15 9.89 493 814.7 1 all 2w
sh fit_features.bash 534.3 542.0 0.864 3.95 1.72 182 932.7 4 burglary 1w
sh fit_features.bash 275.2 435.9 0.024 1.54 1.22 84 519.1 5 all 2w
sh fit_features.bash 348.2 486.2 0.545 1.50 3.73 757 718.9 6 vehicle 3m
sh fit_features.bash 557.5 513.1 0.354 3.35 10.22 947 355.5 4 street 3m
sh fit_features.bash 412.9 276.9 0.275 1.72 9.02 575 897.2 6 burglary 1m
sh fit_features.bash 348.1 286.1 0.680 3.32 9.91 1047 433.6 5 burglary 2m
sh fit_features.bash 588.3 421.4 0.423 2.07 7.27 1108 966.6 1 burglary 3m
sh fit_features.bash 327.4 523.2 0.999 3.10 6.71 1018 674.9 3 all 1w
sh fit_features.bash 285.9 546.4 0.207 1.65 7.79 752 439.1 5 all 3m
sh fit_features.bash 310.2 473.9 0.759 0.08 3.14 322 850.6 5 burglary 1w
sh fit_features.bash 486.0 327.2 0.889 3.51 5.70 847 547.2 3 all 2m
sh fit_features.bash 447.2 531.5 0.113 0.01 9.35 264 1125.5 5 all 3m
sh fit_features.bash 375.7 434.4 0.149 2.99 9.80 722 195.3 1 burglary 2w
sh fit_features.bash 385.1 539.5 0.831 0.52 2.57 1027 209.1 1 burglary 1m
sh fit_features.bash 506.7 504.3 0.513 2.73 1.37 1092 1066.1 6 burglary 2m
sh fit_features.bash 366.4 530.5 0.089 2.66 11.09 419 348.6 3 burglary 1m
sh fit_features.bash 597.7 358.6 0.427 0.75 7.08 301 678.4 4 vehicle 2w
sh fit_features.bash 279.8 260.5 0.607 1.81 7.03 1044 1077.2 4 all 2m
sh fit_features.bash 471.3 364.8 0.188 0.85 11.91 739 465.9 3 street 1m
sh fit_features.bash 261.3 332.2 0.438 1.18 2.08 981 681.7 5 burglary 1w
sh fit_features.bash 445.9 583.8 0.158 0.14 4.59 771 567.0 5 burglary 1m
sh fit_features.bash 256.6 381.9 0.140 0.89 6.49 1070 177.0 2 vehicle 2m
sh fit_features.bash 476.7 583.7 0.135 0.12 1.33 1085 971.8 4 vehicle 2w
sh fit_features.bash 346.0 495.4 0.721 1.57 2.11 606 1131.0 6 all 2w
sh fit_features.bash 552.3 411.1 0.519 2.89 6.14 179 493.1 5 street 1w
sh fit_features.bash 489.8 562.2 0.861 0.08 11.33 86 619.2 3 all 2w
sh fit_features.bash 556.0 560.6 0.046 3.18 4.49 920 819.4 4 burglary 2w
sh fit_features.bash 517.5 527.2 0.952 3.42 2.94 965 867.0 6 street 1w
sh fit_features.bash 333.7 504.7 0.152 0.76 5.54 221 279.1 1 vehicle 1m
sh fit_features.bash 303.3 481.9 0.190 0.08 2.39 777 460.9 1 vehicle 2m
sh fit_features.bash 384.7 414.3 0.430 3.59 3.54 226 1036.3 3 burglary 2m
sh fit_features.bash 453.4 598.9 0.626 3.71 8.68 631 411.9 6 vehicle 3m
sh fit_features.bash 424.5 318.8 0.799 1.41 6.94 589 525.2 5 burglary 2w
sh fit_features.bash 256.4 365.4 0.250 2.04 9.50 702 603.9 1 vehicle 1w
sh fit_features.bash 293.0 585.3 0.076 3.73 7.93 1028 840.5 5 street 3m
sh fit_features.bash 569.0 275.3 0.670 2.00 10.42 1024 690.9 3 vehicle 2m
sh fit_features.bash 495.5 339.4 0.973 0.66 3.29 366 175.5 5 burglary 1w
sh fit_features.bash 506.7 464.8 0.589 1.94 5.59 149 628.7 5 all 2m
sh fit_features.bash 565.3 390.6 0.399 2.44 3.35 587 1180.3 1 burglary 3m
sh fit_features.bash 444.9 448.1 0.989 0.83 4.56 356 519.2 5 all 1m
sh fit_features.bash 591.4 335.3 0.343 1.13 6.16 238 489.6 1 street 1w
sh fit_features.bash 480.8 449.0 0.837 3.26 10.40 554 350.8 5 burglary 1w
sh fit_features.bash 575.1 424.6 0.550 3.08 4.28 602 1179.4 2 burglary 2w
