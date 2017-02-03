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

sh fit_features.bash 391.7 467.5 0.715 3.59 10.71 746 545.9 6 vehicle 1m
sh fit_features.bash 484.8 473.5 0.248 0.82 9.39 840 169.0 7 burglary 2m
sh fit_features.bash 405.8 347.5 0.866 2.82 9.97 629 1195.2 4 all 2w
sh fit_features.bash 490.8 276.3 0.859 2.40 8.07 981 254.1 6 street 3m
sh fit_features.bash 583.0 577.9 0.661 2.61 5.00 421 273.1 8 street 2m
sh fit_features.bash 250.3 387.2 0.161 1.99 11.87 1048 389.1 7 burglary 2w
sh fit_features.bash 383.8 464.5 0.758 1.27 10.59 342 139.6 5 all 1w
sh fit_features.bash 578.0 462.2 0.153 3.14 11.18 904 852.4 6 all 1m
sh fit_features.bash 548.6 437.8 0.932 3.10 6.14 613 314.9 1 vehicle 2m
sh fit_features.bash 364.5 273.4 0.692 2.62 4.98 901 830.1 1 burglary 3m
sh fit_features.bash 502.8 441.5 0.405 1.29 1.12 731 923.0 3 vehicle 2w
sh fit_features.bash 335.8 472.6 0.726 2.93 7.31 490 1022.4 1 street 2m
sh fit_features.bash 392.2 301.8 0.471 0.74 9.76 323 548.2 6 vehicle 1w
sh fit_features.bash 442.7 378.6 0.805 1.81 8.80 146 944.7 2 street 2m
sh fit_features.bash 427.6 580.8 0.512 3.52 9.80 103 708.4 8 vehicle 1w
sh fit_features.bash 390.4 255.6 0.074 2.12 5.24 865 1075.8 5 all 1w
sh fit_features.bash 378.2 395.3 0.434 3.75 8.81 373 960.6 1 all 1m
sh fit_features.bash 273.0 320.4 0.334 1.73 7.71 413 259.6 8 all 1w
sh fit_features.bash 403.0 558.6 0.904 0.72 11.03 149 388.7 3 vehicle 1w
sh fit_features.bash 510.8 524.7 0.520 1.58 9.18 930 494.7 5 all 1w
sh fit_features.bash 462.1 297.6 0.447 1.77 8.55 660 899.1 3 burglary 2w
sh fit_features.bash 520.7 523.6 0.359 1.13 2.00 744 611.1 2 burglary 3m
sh fit_features.bash 434.3 486.1 0.689 3.22 3.17 444 607.0 5 burglary 3m
sh fit_features.bash 575.4 383.5 0.540 3.65 0.74 338 273.9 8 all 2m
sh fit_features.bash 422.3 537.4 0.416 1.41 11.02 1159 422.0 8 street 1w
sh fit_features.bash 420.2 407.4 0.093 0.88 0.18 978 541.9 4 vehicle 2m
sh fit_features.bash 476.2 504.8 0.307 2.05 11.82 257 889.5 5 all 1m
sh fit_features.bash 575.1 415.6 0.859 2.26 5.44 656 204.3 2 all 1w
sh fit_features.bash 554.7 346.0 0.687 2.08 1.13 511 1134.5 2 vehicle 1m
sh fit_features.bash 580.2 567.3 0.657 0.83 10.34 343 799.7 8 vehicle 1m
sh fit_features.bash 343.3 363.7 0.982 2.00 2.13 1084 387.9 2 vehicle 2w
sh fit_features.bash 525.3 497.8 0.084 1.13 5.19 124 384.8 8 burglary 1w
sh fit_features.bash 568.7 326.2 0.737 1.20 11.40 274 771.5 2 all 2w
sh fit_features.bash 440.1 484.3 0.256 3.48 0.87 102 349.2 4 burglary 2w
sh fit_features.bash 264.5 484.9 0.164 3.30 1.37 485 425.2 2 vehicle 2w
sh fit_features.bash 566.7 521.4 0.900 2.70 3.90 599 356.2 6 street 2m
sh fit_features.bash 581.4 454.9 0.788 0.99 8.92 984 314.5 5 street 1w
sh fit_features.bash 254.1 389.0 0.040 1.78 6.48 515 890.0 2 vehicle 2w
sh fit_features.bash 582.3 291.4 0.958 0.10 5.79 453 623.4 5 street 1m
sh fit_features.bash 444.0 534.3 0.418 3.12 2.78 1131 650.9 8 street 1m
sh fit_features.bash 545.3 451.8 0.562 1.02 11.83 302 1186.6 6 vehicle 1m
sh fit_features.bash 312.8 298.1 0.998 3.74 6.46 1022 1149.1 5 vehicle 1w
sh fit_features.bash 400.1 555.3 0.306 0.33 2.83 341 399.2 1 burglary 2w
sh fit_features.bash 326.7 398.4 0.939 1.04 3.17 510 146.8 2 street 1m
sh fit_features.bash 450.8 421.1 0.520 1.03 4.36 834 927.5 8 street 2m
sh fit_features.bash 385.0 493.2 0.390 1.35 8.51 118 1164.2 3 all 2m
sh fit_features.bash 583.6 303.5 0.575 1.91 6.34 1176 1005.5 3 burglary 2m
sh fit_features.bash 574.7 436.6 0.848 3.78 2.75 665 209.6 7 burglary 2m
sh fit_features.bash 509.3 583.1 0.978 1.80 5.81 587 1033.0 3 all 2m
sh fit_features.bash 311.8 435.9 0.367 3.23 11.54 1169 1051.0 6 burglary 2w
sh fit_features.bash 289.2 541.5 0.575 2.19 10.75 923 688.6 8 vehicle 2w
sh fit_features.bash 541.0 556.6 0.331 0.15 4.03 1142 752.2 6 all 2w
sh fit_features.bash 324.3 570.6 0.080 3.82 5.56 1126 553.9 5 all 1m
sh fit_features.bash 439.8 492.8 1.000 3.23 0.79 937 1054.9 3 burglary 1m
sh fit_features.bash 402.4 361.1 0.729 2.33 6.81 404 688.5 3 vehicle 2w
sh fit_features.bash 553.1 430.1 0.347 1.05 2.92 335 646.2 2 street 1w
sh fit_features.bash 285.4 563.9 0.687 1.16 8.11 603 1181.6 1 burglary 1m
sh fit_features.bash 457.6 360.6 0.380 2.24 2.27 1113 327.5 4 vehicle 1m
sh fit_features.bash 523.6 299.5 0.836 3.84 3.39 462 1199.5 7 all 3m
sh fit_features.bash 527.2 465.4 0.702 1.62 9.16 66 1059.6 6 burglary 2m
sh fit_features.bash 594.4 281.6 0.985 3.75 9.81 592 266.4 3 burglary 2m
sh fit_features.bash 262.7 514.8 0.185 2.85 5.37 858 667.9 2 burglary 2m
sh fit_features.bash 481.1 354.8 0.876 0.40 5.23 264 400.0 5 street 3m
sh fit_features.bash 413.5 335.0 0.534 3.76 3.76 1047 922.2 5 street 2w
sh fit_features.bash 382.9 400.3 0.787 2.90 7.70 180 971.6 7 vehicle 2w
sh fit_features.bash 502.1 346.1 0.508 0.49 5.65 503 146.2 4 burglary 1m
sh fit_features.bash 525.1 545.1 0.964 3.78 0.75 609 136.5 1 vehicle 1m
sh fit_features.bash 355.4 550.2 0.585 3.13 5.23 283 123.5 3 all 3m
sh fit_features.bash 370.5 428.3 0.685 3.20 1.36 1152 595.9 8 street 2w
sh fit_features.bash 476.6 362.5 0.573 2.74 10.20 874 662.4 1 burglary 2m
sh fit_features.bash 477.4 386.2 0.761 2.03 8.61 213 1104.8 8 street 2m
sh fit_features.bash 403.1 458.3 0.048 2.28 5.49 357 823.1 8 burglary 3m
sh fit_features.bash 288.8 314.7 0.751 0.08 5.75 936 625.1 6 vehicle 2m
sh fit_features.bash 449.1 509.6 0.036 0.74 10.86 461 925.8 7 street 1m
sh fit_features.bash 276.6 493.1 0.038 3.50 8.81 909 139.8 6 burglary 3m
sh fit_features.bash 341.0 564.6 0.842 0.89 2.67 907 823.7 8 vehicle 2m
sh fit_features.bash 278.1 514.9 0.973 2.97 3.71 914 441.9 4 burglary 1w
sh fit_features.bash 537.7 595.2 0.599 1.94 4.89 1108 1165.4 3 burglary 2m
sh fit_features.bash 436.7 342.4 0.036 1.43 10.32 539 272.9 4 all 3m
sh fit_features.bash 598.8 317.3 0.590 2.54 8.14 254 644.9 3 burglary 1w
sh fit_features.bash 392.0 502.2 0.427 3.13 2.15 893 562.8 6 burglary 2m
sh fit_features.bash 549.0 449.3 0.790 2.62 2.80 888 110.9 7 vehicle 1w
sh fit_features.bash 428.4 546.3 0.024 3.90 3.04 638 966.4 6 all 2w
sh fit_features.bash 306.0 333.4 0.490 2.58 10.54 715 838.0 5 all 3m
sh fit_features.bash 270.1 304.9 0.994 3.85 5.01 88 321.1 1 all 1w
sh fit_features.bash 478.7 333.7 0.483 3.71 2.93 735 826.8 2 street 2w
sh fit_features.bash 350.5 402.8 0.548 3.07 11.07 250 1092.4 3 burglary 2w
sh fit_features.bash 310.5 567.2 0.623 0.18 11.17 515 249.9 1 street 3m
sh fit_features.bash 483.8 345.2 0.799 2.02 0.58 411 601.1 5 street 2w
sh fit_features.bash 399.1 407.1 0.873 3.60 7.02 608 376.9 5 all 2w
sh fit_features.bash 402.0 335.1 0.855 2.37 3.66 629 682.3 6 all 1w
sh fit_features.bash 458.8 260.9 0.685 2.10 0.54 116 850.5 4 all 2w
sh fit_features.bash 534.7 328.3 0.816 2.02 4.70 794 1003.7 5 vehicle 1m
sh fit_features.bash 464.8 333.1 0.816 0.12 8.28 169 976.4 8 all 3m
sh fit_features.bash 477.9 383.6 0.783 0.89 1.50 99 203.8 2 street 3m
sh fit_features.bash 437.0 563.2 0.079 2.50 3.54 507 1023.2 2 street 2m
sh fit_features.bash 498.3 299.8 0.413 2.81 9.53 534 183.8 6 all 1w
sh fit_features.bash 352.3 588.6 0.737 0.36 7.88 441 573.0 8 street 1w
sh fit_features.bash 387.3 314.7 0.541 2.38 4.69 1150 214.1 7 street 2w
sh fit_features.bash 476.1 477.8 0.814 2.57 10.96 346 147.9 3 burglary 1w
