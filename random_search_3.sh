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

sh fit_features.bash 413.8 361.6 0.127 0.76 8.62 828 407.5 1 all 2m
sh fit_features.bash 414.7 547.8 0.717 1.32 11.86 1006 563.9 3 street 2m
sh fit_features.bash 500.5 419.9 0.782 3.48 3.66 265 636.4 6 street 1w
sh fit_features.bash 250.0 417.1 0.392 1.65 9.32 641 689.9 5 street 1m
sh fit_features.bash 339.1 472.2 0.441 2.23 11.14 930 838.4 1 all 1w
sh fit_features.bash 429.6 511.5 0.711 0.29 3.20 1033 137.3 1 street 1m
sh fit_features.bash 450.9 458.5 0.848 3.51 6.22 603 677.1 4 all 2w
sh fit_features.bash 271.7 488.6 0.562 1.73 10.65 86 1173.1 2 street 1m
sh fit_features.bash 393.5 543.9 0.094 3.81 4.86 1161 378.0 4 street 2w
sh fit_features.bash 442.2 512.7 0.814 1.83 6.63 1047 279.4 6 burglary 2w
sh fit_features.bash 253.3 367.2 0.315 3.07 2.15 1163 650.7 6 vehicle 2m
sh fit_features.bash 304.6 485.9 0.925 0.69 9.30 1039 420.8 3 all 2w
sh fit_features.bash 509.4 496.5 0.251 0.35 7.81 849 295.2 5 burglary 2w
sh fit_features.bash 535.9 304.4 0.653 2.92 6.92 522 430.5 3 street 1w
sh fit_features.bash 539.5 299.0 0.528 1.40 6.74 1030 837.4 4 vehicle 3m
sh fit_features.bash 309.5 486.1 0.479 3.12 5.03 424 995.3 1 burglary 2w
sh fit_features.bash 323.3 493.2 0.996 1.88 1.30 1017 870.7 3 all 1w
sh fit_features.bash 494.2 554.4 0.164 3.01 11.64 129 844.6 1 burglary 3m
sh fit_features.bash 511.6 398.3 0.950 0.91 4.05 203 810.3 6 street 1w
sh fit_features.bash 567.9 562.8 0.888 0.60 9.05 795 1055.7 1 street 2w
sh fit_features.bash 351.9 269.2 0.148 1.08 11.70 1066 797.7 6 street 1m
sh fit_features.bash 264.5 339.1 0.212 1.08 8.11 273 355.9 3 all 1w
sh fit_features.bash 535.1 420.8 0.101 1.17 2.41 312 1044.3 4 all 3m
sh fit_features.bash 405.9 409.5 0.204 3.35 11.08 379 415.7 4 burglary 3m
sh fit_features.bash 509.4 453.1 0.122 0.03 8.78 1174 458.2 4 burglary 1w
sh fit_features.bash 526.4 437.0 0.874 3.64 3.50 669 753.6 1 all 3m
sh fit_features.bash 340.7 444.1 0.000 2.75 1.45 237 1133.7 2 vehicle 1m
sh fit_features.bash 590.2 488.9 0.146 2.13 7.81 437 1158.4 1 street 1m
sh fit_features.bash 407.2 395.1 0.312 2.53 5.06 594 786.3 6 all 3m
sh fit_features.bash 404.8 403.3 0.362 2.45 1.52 899 586.7 6 street 3m
sh fit_features.bash 442.2 478.4 0.434 0.46 8.76 1157 1122.6 4 vehicle 1m
sh fit_features.bash 361.3 262.9 0.312 0.91 2.62 974 923.5 3 street 1m
sh fit_features.bash 582.9 298.8 0.929 3.51 3.36 1183 123.0 3 vehicle 2m
sh fit_features.bash 521.5 477.6 0.603 3.24 5.86 1176 438.0 4 all 2m
sh fit_features.bash 279.1 518.4 0.359 2.67 2.05 896 216.3 4 vehicle 1w
sh fit_features.bash 373.7 580.9 0.251 1.08 11.40 666 439.9 2 burglary 2w
sh fit_features.bash 349.4 504.0 0.201 0.32 0.84 1151 140.6 5 burglary 2w
sh fit_features.bash 300.1 517.5 0.422 2.45 0.70 1123 400.7 2 burglary 2w
sh fit_features.bash 283.8 332.1 0.438 2.63 5.60 719 1079.2 4 all 3m
sh fit_features.bash 331.6 504.2 0.179 2.13 7.03 1103 998.7 3 vehicle 2w
sh fit_features.bash 403.6 596.3 0.853 1.90 4.23 1089 1084.7 3 all 3m
sh fit_features.bash 354.0 568.6 0.584 2.78 9.77 1072 233.6 6 street 2w
sh fit_features.bash 405.3 396.5 0.483 0.09 6.76 186 834.2 2 vehicle 3m
sh fit_features.bash 546.9 367.3 0.570 1.91 5.75 406 533.9 1 vehicle 2m
sh fit_features.bash 397.9 524.5 0.976 3.87 6.73 456 135.2 6 burglary 1m
sh fit_features.bash 280.6 356.7 0.321 3.33 11.07 869 946.2 4 all 2w
sh fit_features.bash 598.4 552.8 0.619 0.28 1.14 937 932.0 3 all 2w
sh fit_features.bash 542.7 447.6 0.052 1.18 6.37 1045 426.3 4 burglary 1m
sh fit_features.bash 411.2 377.8 0.732 3.17 3.20 486 779.7 2 all 1w
sh fit_features.bash 387.5 268.5 0.708 0.29 7.55 195 588.1 4 street 1w
sh fit_features.bash 268.8 569.8 0.470 2.65 11.92 348 873.6 4 all 1w
sh fit_features.bash 363.7 473.1 0.695 3.70 5.58 1078 834.0 3 street 2w
sh fit_features.bash 571.8 308.2 0.404 2.02 4.08 489 1092.0 6 burglary 3m
sh fit_features.bash 268.7 547.3 0.770 3.66 8.27 305 631.0 1 burglary 2m
sh fit_features.bash 554.9 376.9 0.268 1.89 5.09 970 1004.4 4 vehicle 2w
sh fit_features.bash 583.4 346.2 0.706 3.12 4.81 1007 689.1 1 burglary 1w
sh fit_features.bash 528.9 373.9 0.599 0.74 3.81 195 1085.7 4 all 1w
sh fit_features.bash 595.1 399.5 0.343 1.02 4.49 1010 273.9 6 all 1m
sh fit_features.bash 278.7 374.2 0.239 3.54 3.45 135 908.4 6 burglary 3m
sh fit_features.bash 339.3 291.3 0.725 0.11 2.58 600 578.7 4 all 2m
sh fit_features.bash 297.5 373.9 0.172 0.45 1.76 843 964.8 1 all 1m
sh fit_features.bash 368.4 354.6 0.438 2.07 2.19 240 552.1 3 burglary 2w
sh fit_features.bash 290.9 292.9 0.688 3.64 4.03 234 713.4 5 burglary 1m
sh fit_features.bash 432.9 501.7 0.666 1.51 10.40 216 507.3 1 street 2w
sh fit_features.bash 353.8 300.0 0.690 2.62 1.71 649 518.8 3 street 3m
sh fit_features.bash 345.1 555.8 0.306 3.86 5.32 114 1061.3 6 vehicle 3m
sh fit_features.bash 355.4 483.7 0.356 1.37 5.40 461 984.6 1 all 1w
sh fit_features.bash 450.9 297.0 0.456 2.96 11.72 331 185.4 5 burglary 3m
sh fit_features.bash 279.0 592.8 0.773 3.97 9.10 838 786.5 4 vehicle 2w
sh fit_features.bash 590.1 505.0 0.163 0.88 3.35 953 505.6 2 all 2m
sh fit_features.bash 400.7 309.7 0.393 1.84 8.06 444 814.0 4 vehicle 1w
sh fit_features.bash 547.5 363.2 0.804 2.27 10.44 1015 106.7 6 burglary 2w
sh fit_features.bash 429.9 269.0 0.967 0.35 8.30 703 895.7 4 street 1m
sh fit_features.bash 547.6 458.5 0.942 2.60 10.66 563 851.3 4 all 2m
sh fit_features.bash 402.9 549.4 0.674 2.77 8.48 915 869.6 1 all 2m
sh fit_features.bash 347.4 301.8 0.743 2.39 2.31 249 958.6 6 burglary 1m
sh fit_features.bash 490.6 336.3 0.529 0.03 0.97 271 131.5 5 burglary 1m
sh fit_features.bash 361.6 497.5 0.305 1.38 11.26 100 195.4 2 all 2w
sh fit_features.bash 385.7 252.3 0.989 1.71 9.14 119 468.5 1 burglary 2m
sh fit_features.bash 554.0 534.4 0.951 2.99 6.02 1151 396.1 3 vehicle 1w
sh fit_features.bash 562.2 296.0 0.603 3.94 8.25 1132 1096.4 5 vehicle 1w
sh fit_features.bash 527.0 425.1 0.690 3.91 8.29 189 826.9 2 burglary 2w
sh fit_features.bash 257.9 474.3 0.184 1.76 3.76 309 287.6 6 all 1w
sh fit_features.bash 339.9 594.8 0.767 2.97 2.52 878 1076.9 5 street 1w
sh fit_features.bash 518.9 558.8 0.715 1.50 2.45 79 862.8 1 street 2w
sh fit_features.bash 580.3 404.8 0.878 0.01 8.39 1148 420.5 1 street 3m
sh fit_features.bash 570.0 594.5 0.751 0.62 7.31 129 493.6 2 burglary 2w
sh fit_features.bash 490.8 561.6 0.300 1.78 1.94 814 1005.4 6 vehicle 1m
sh fit_features.bash 361.4 585.4 0.363 2.27 10.56 576 459.5 4 vehicle 1w
sh fit_features.bash 395.2 461.3 0.360 0.84 0.26 644 345.2 4 burglary 2m
sh fit_features.bash 564.3 322.4 0.798 1.73 11.15 528 317.4 3 vehicle 2w
sh fit_features.bash 255.8 492.8 0.879 3.18 0.54 366 816.7 5 vehicle 2w
sh fit_features.bash 266.1 287.3 0.942 2.68 6.28 640 666.6 5 street 1w
sh fit_features.bash 392.4 496.5 0.023 3.75 3.89 445 132.3 6 all 2m
sh fit_features.bash 576.4 276.1 0.171 2.21 6.18 174 1009.3 4 street 1w
sh fit_features.bash 422.9 384.5 0.435 2.26 4.19 1084 630.6 3 all 2w
sh fit_features.bash 449.7 599.5 0.780 2.98 6.61 1085 472.4 2 all 1w
sh fit_features.bash 481.0 549.5 0.324 2.78 5.25 544 1092.0 5 vehicle 1m
sh fit_features.bash 273.2 513.3 0.868 1.53 0.78 875 501.6 2 all 3m
sh fit_features.bash 378.4 444.4 0.510 1.61 2.87 994 1150.7 6 street 1m
