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

sh fit_features.bash 562.4 389.0 0.831 2.85 4.34 569 1058.8 3 all 1m
sh fit_features.bash 266.5 300.8 0.345 0.11 0.10 690 159.4 4 burglary 1m
sh fit_features.bash 506.3 593.3 0.326 3.07 7.44 817 499.9 4 all 1w
sh fit_features.bash 560.5 281.6 0.155 1.36 7.42 432 103.3 1 vehicle 2w
sh fit_features.bash 459.0 270.1 0.878 2.15 4.14 437 1132.5 3 vehicle 2m
sh fit_features.bash 370.2 389.9 0.484 3.11 2.71 642 681.8 6 street 2w
sh fit_features.bash 434.7 536.7 0.373 2.42 10.42 912 1125.4 5 vehicle 1w
sh fit_features.bash 584.9 303.5 0.576 1.02 2.87 118 531.3 2 street 1w
sh fit_features.bash 376.6 482.3 0.100 0.23 8.75 568 1176.7 3 street 2m
sh fit_features.bash 321.2 372.4 0.415 1.48 8.39 413 977.3 2 vehicle 2m
sh fit_features.bash 367.6 502.3 0.398 3.79 2.44 937 469.4 5 burglary 2m
sh fit_features.bash 374.8 291.5 0.539 2.05 5.27 204 1155.1 5 burglary 1w
sh fit_features.bash 464.1 495.2 0.727 1.35 6.13 778 590.3 4 vehicle 3m
sh fit_features.bash 445.2 313.9 0.154 0.24 6.68 725 428.3 6 all 1m
sh fit_features.bash 584.2 364.0 0.691 0.33 1.76 492 1026.7 6 all 1m
sh fit_features.bash 426.3 530.1 0.047 2.47 8.14 566 732.4 1 vehicle 2m
sh fit_features.bash 283.9 504.1 0.550 1.57 9.84 1005 1163.3 3 street 3m
sh fit_features.bash 453.9 564.3 0.506 1.20 6.85 161 350.3 6 burglary 2m
sh fit_features.bash 455.5 407.7 0.875 3.36 4.97 799 307.7 5 burglary 2m
sh fit_features.bash 387.0 344.9 0.298 0.16 8.76 992 921.6 1 vehicle 2m
sh fit_features.bash 320.5 412.1 0.407 0.74 8.54 181 1178.5 2 street 2m
sh fit_features.bash 573.9 262.8 0.577 0.81 4.61 842 107.1 4 street 2m
sh fit_features.bash 291.8 531.1 0.091 3.20 6.01 874 551.6 4 all 2m
sh fit_features.bash 260.1 416.4 0.536 0.36 5.98 387 418.3 1 street 1m
sh fit_features.bash 544.4 272.2 0.925 3.91 1.07 834 108.1 4 all 1m
sh fit_features.bash 563.8 405.2 0.309 1.14 11.36 233 189.4 5 burglary 1m
sh fit_features.bash 305.5 557.4 0.491 3.55 5.48 399 1182.0 6 all 1w
sh fit_features.bash 530.3 428.0 0.320 3.57 2.67 926 1156.4 4 all 2m
sh fit_features.bash 322.0 343.6 0.293 2.07 3.26 150 579.3 5 burglary 3m
sh fit_features.bash 454.3 487.3 0.455 0.37 11.09 407 867.1 1 all 2w
sh fit_features.bash 279.5 335.4 0.279 0.06 1.79 492 855.8 4 burglary 3m
sh fit_features.bash 519.5 451.6 0.908 1.43 9.82 265 968.3 6 all 2m
sh fit_features.bash 356.0 402.0 0.293 3.89 6.18 1059 818.1 1 street 1w
sh fit_features.bash 412.1 523.9 0.167 0.93 9.86 240 362.2 4 street 1m
sh fit_features.bash 533.4 359.6 0.333 0.76 6.32 977 933.8 6 street 2w
sh fit_features.bash 395.3 468.7 0.069 3.65 0.41 371 701.9 1 all 2m
sh fit_features.bash 314.4 256.9 0.774 3.73 10.86 525 433.7 3 burglary 1m
sh fit_features.bash 296.5 395.1 0.118 3.03 4.25 654 450.7 3 burglary 1w
sh fit_features.bash 482.8 277.2 0.555 2.07 10.69 976 716.9 6 street 2m
sh fit_features.bash 366.2 405.5 0.132 1.99 3.98 1027 1046.4 3 all 1m
sh fit_features.bash 390.3 280.1 0.881 0.57 9.25 1093 688.0 2 burglary 2m
sh fit_features.bash 289.8 473.3 0.212 3.90 5.48 986 668.6 3 burglary 2w
sh fit_features.bash 524.8 373.9 0.550 0.84 8.68 493 336.4 6 burglary 1m
sh fit_features.bash 490.1 386.5 0.514 1.72 6.77 924 994.7 5 street 1m
sh fit_features.bash 559.4 410.9 0.713 1.89 0.56 293 511.6 2 street 2m
sh fit_features.bash 437.6 294.3 0.569 2.38 11.99 877 291.3 3 burglary 3m
sh fit_features.bash 591.7 268.4 0.855 1.71 8.34 206 312.5 1 street 1m
sh fit_features.bash 317.9 595.2 0.166 2.75 7.90 883 462.1 3 all 1m
sh fit_features.bash 580.2 433.1 0.903 2.79 10.70 844 242.8 2 street 1w
sh fit_features.bash 410.9 340.9 0.081 3.97 6.14 115 675.1 6 street 2w
sh fit_features.bash 312.2 386.9 0.385 3.88 0.40 724 590.0 3 burglary 2w
sh fit_features.bash 304.6 583.9 0.526 1.92 1.07 1077 381.5 1 burglary 2m
sh fit_features.bash 295.8 475.3 0.474 1.61 2.38 1171 918.1 4 all 3m
sh fit_features.bash 340.5 545.1 0.891 2.35 2.95 980 847.8 2 vehicle 2w
sh fit_features.bash 572.1 520.1 0.962 1.67 9.32 538 725.8 1 street 1m
sh fit_features.bash 354.8 457.5 0.504 3.20 9.60 502 511.5 1 burglary 2w
sh fit_features.bash 307.0 373.5 0.791 2.33 0.87 852 1058.0 1 street 3m
sh fit_features.bash 336.6 511.2 0.879 0.49 8.40 1152 251.2 6 all 2w
sh fit_features.bash 452.0 590.4 0.669 0.75 11.80 348 910.8 2 vehicle 1m
sh fit_features.bash 472.7 511.5 0.896 0.78 3.73 374 388.7 3 street 2m
sh fit_features.bash 353.8 322.4 0.154 1.63 11.02 753 323.3 6 burglary 1w
sh fit_features.bash 397.7 319.5 0.017 2.09 4.77 832 135.4 3 burglary 3m
sh fit_features.bash 340.9 536.0 0.760 2.45 1.38 1198 1043.2 5 all 1w
sh fit_features.bash 572.0 328.3 0.706 2.81 10.19 804 371.2 1 street 1w
sh fit_features.bash 458.5 557.4 0.385 0.65 5.64 531 792.9 5 burglary 1m
sh fit_features.bash 398.2 555.0 0.610 0.72 8.80 1001 1047.0 5 vehicle 1m
sh fit_features.bash 507.7 590.0 0.388 3.87 6.98 1019 339.6 4 burglary 2w
sh fit_features.bash 330.5 486.0 0.318 0.13 5.11 563 1009.9 6 vehicle 3m
sh fit_features.bash 560.3 500.8 0.280 1.65 8.35 545 339.0 2 vehicle 3m
sh fit_features.bash 250.5 584.4 0.196 0.38 10.35 647 871.1 6 all 2w
sh fit_features.bash 441.9 421.2 0.063 2.96 4.11 1138 839.5 6 street 1m
sh fit_features.bash 596.3 509.5 0.418 1.89 7.53 326 1184.1 3 vehicle 1w
sh fit_features.bash 472.5 444.2 0.341 2.10 4.61 52 212.9 3 vehicle 3m
sh fit_features.bash 337.5 368.0 0.120 1.57 3.93 338 646.3 6 street 2m
sh fit_features.bash 287.2 426.2 0.054 0.86 5.33 952 1118.9 1 street 2m
sh fit_features.bash 524.2 371.8 0.258 2.88 5.85 242 505.5 2 burglary 2m
sh fit_features.bash 511.5 426.5 0.421 0.94 8.54 710 811.1 6 vehicle 1m
sh fit_features.bash 315.5 463.8 0.594 0.60 0.94 1177 519.0 3 vehicle 3m
sh fit_features.bash 473.9 504.5 0.712 2.27 7.05 278 333.1 5 burglary 2m
sh fit_features.bash 408.3 373.2 0.521 2.14 8.74 632 828.2 4 vehicle 2w
sh fit_features.bash 554.8 560.6 0.894 2.05 2.43 678 369.7 4 all 1w
sh fit_features.bash 585.7 556.1 0.899 1.70 6.95 882 910.5 5 all 3m
sh fit_features.bash 475.4 484.9 0.262 2.12 11.51 227 925.7 4 street 1w
sh fit_features.bash 397.3 375.5 0.906 2.26 7.07 1013 897.0 1 vehicle 3m
sh fit_features.bash 310.2 474.7 0.030 3.74 9.40 149 492.6 2 burglary 1m
sh fit_features.bash 332.5 497.0 0.061 2.63 5.48 191 786.3 4 vehicle 2w
sh fit_features.bash 542.2 460.0 0.615 3.99 3.21 114 463.7 2 street 2m
sh fit_features.bash 290.3 326.9 0.590 2.75 0.62 588 437.5 5 vehicle 2m
sh fit_features.bash 457.7 328.9 0.413 2.14 6.69 815 808.7 3 street 1w
sh fit_features.bash 449.0 487.1 0.696 1.41 5.84 247 972.5 6 vehicle 1m
sh fit_features.bash 366.1 348.4 0.604 0.39 8.10 740 549.1 4 street 1m
sh fit_features.bash 344.7 391.0 0.215 0.79 10.54 1030 650.0 4 burglary 3m
sh fit_features.bash 283.5 278.2 0.510 2.52 10.26 61 813.9 3 burglary 1w
sh fit_features.bash 551.9 315.4 0.497 0.95 0.77 310 405.6 6 all 1w
sh fit_features.bash 323.6 581.3 0.978 0.07 8.71 377 310.2 4 burglary 2w
sh fit_features.bash 330.6 520.1 0.045 2.46 1.99 651 1025.1 2 vehicle 2w
sh fit_features.bash 452.8 300.7 0.380 1.96 1.14 814 758.5 4 vehicle 2m
sh fit_features.bash 489.5 487.1 0.206 3.02 6.23 184 754.6 2 street 2w
sh fit_features.bash 479.5 368.7 0.939 1.27 11.62 413 646.4 1 burglary 2w
sh fit_features.bash 534.2 394.8 0.368 0.52 5.13 372 370.0 3 vehicle 2w
