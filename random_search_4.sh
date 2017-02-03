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

sh fit_features.bash 288.9 546.2 0.184 2.68 1.52 1013 901.2 4 all 3m
sh fit_features.bash 406.5 288.2 0.296 1.17 7.43 320 700.4 4 street 2m
sh fit_features.bash 501.2 369.3 0.896 2.62 2.22 989 400.9 1 burglary 1w
sh fit_features.bash 394.1 316.2 0.467 2.67 7.57 561 848.1 3 street 3m
sh fit_features.bash 513.0 460.8 0.808 4.00 5.55 1052 1141.2 6 burglary 2m
sh fit_features.bash 323.7 467.8 0.471 4.00 8.83 624 780.1 3 vehicle 2w
sh fit_features.bash 293.2 529.4 0.628 1.59 8.69 1181 1199.4 3 burglary 3m
sh fit_features.bash 476.9 352.7 0.531 0.99 3.50 962 500.0 2 burglary 2w
sh fit_features.bash 269.7 427.9 0.949 1.05 7.30 627 740.4 6 street 1m
sh fit_features.bash 300.2 419.5 0.281 2.20 1.05 918 129.2 2 vehicle 3m
sh fit_features.bash 313.5 468.4 0.647 1.63 1.09 1131 284.6 3 vehicle 2w
sh fit_features.bash 404.5 498.3 0.103 3.69 0.36 432 563.3 2 all 2w
sh fit_features.bash 393.5 494.0 0.212 3.85 5.48 958 375.0 3 burglary 2m
sh fit_features.bash 551.3 294.0 0.812 0.62 9.41 924 478.2 6 all 3m
sh fit_features.bash 553.5 399.1 0.377 2.69 7.67 455 423.5 1 burglary 2w
sh fit_features.bash 524.7 316.7 0.526 3.24 1.42 1006 102.4 3 all 1m
sh fit_features.bash 254.0 566.3 0.630 1.15 4.61 281 1153.5 5 all 3m
sh fit_features.bash 511.2 377.5 0.329 3.15 8.87 1191 1197.3 2 street 3m
sh fit_features.bash 566.2 289.1 0.489 3.23 10.13 1199 620.4 2 street 2m
sh fit_features.bash 565.3 426.9 0.533 3.89 6.93 187 732.1 5 all 2w
sh fit_features.bash 471.0 358.9 0.298 0.56 6.18 967 520.8 3 burglary 1w
sh fit_features.bash 507.1 306.5 0.505 2.31 10.54 238 609.3 6 vehicle 1w
sh fit_features.bash 331.9 345.5 0.150 0.71 6.20 797 852.6 1 burglary 1m
sh fit_features.bash 440.7 537.7 0.519 1.31 10.36 470 975.7 5 street 1m
sh fit_features.bash 584.2 348.1 0.701 1.61 1.08 522 142.2 4 burglary 2w
sh fit_features.bash 265.2 549.8 0.786 2.98 9.08 253 844.8 2 street 1w
sh fit_features.bash 372.6 553.4 0.758 3.67 6.08 268 1060.1 1 burglary 1w
sh fit_features.bash 261.2 404.9 0.603 3.79 5.54 145 575.8 3 street 1m
sh fit_features.bash 400.6 443.4 0.749 3.80 4.96 332 687.0 3 all 1m
sh fit_features.bash 539.1 475.8 0.400 2.53 5.92 992 873.6 3 all 1w
sh fit_features.bash 392.3 400.4 0.947 3.95 9.49 688 595.3 6 all 1w
sh fit_features.bash 515.4 295.8 0.683 0.84 11.84 375 893.2 1 vehicle 2m
sh fit_features.bash 512.1 505.8 0.391 1.31 11.59 799 394.8 6 all 1w
sh fit_features.bash 407.1 348.7 0.773 0.66 3.89 987 550.9 2 all 1m
sh fit_features.bash 310.0 320.0 0.603 1.93 10.67 1081 272.5 6 burglary 1w
sh fit_features.bash 513.8 412.0 0.894 2.88 10.34 1192 581.2 1 burglary 1w
sh fit_features.bash 506.2 338.6 0.701 3.69 6.11 485 673.9 6 burglary 1w
sh fit_features.bash 595.1 435.9 0.114 3.88 6.46 753 341.8 2 vehicle 2w
sh fit_features.bash 504.7 324.0 0.039 3.69 2.19 99 178.8 5 vehicle 3m
sh fit_features.bash 494.7 455.6 0.029 2.48 10.13 887 871.3 3 burglary 1w
sh fit_features.bash 528.9 279.1 0.115 2.12 1.90 84 812.2 4 burglary 1w
sh fit_features.bash 533.5 450.6 0.167 3.20 11.27 830 103.5 5 burglary 2m
sh fit_features.bash 561.9 289.7 0.299 3.92 0.42 1079 662.8 2 vehicle 1m
sh fit_features.bash 436.2 589.0 0.832 3.81 2.26 1062 1102.1 1 street 1m
sh fit_features.bash 443.4 317.5 0.739 1.21 10.23 849 1134.1 5 vehicle 3m
sh fit_features.bash 348.3 306.8 0.070 0.13 5.97 832 500.8 1 burglary 2m
sh fit_features.bash 400.5 436.2 0.855 2.25 10.84 959 907.4 2 street 2m
sh fit_features.bash 444.2 339.1 0.139 2.03 2.68 628 665.5 3 vehicle 2m
sh fit_features.bash 504.2 348.6 0.506 3.95 11.56 153 340.1 3 burglary 1m
sh fit_features.bash 280.2 499.1 0.613 0.70 0.13 912 164.2 4 street 1m
sh fit_features.bash 318.6 539.3 0.715 0.47 11.73 323 1162.1 5 all 2w
sh fit_features.bash 341.8 390.6 0.695 0.85 6.43 654 827.8 5 burglary 1m
sh fit_features.bash 391.0 387.8 0.880 2.53 6.59 82 1174.2 3 burglary 2m
sh fit_features.bash 318.8 552.0 0.877 3.56 10.13 710 573.8 3 burglary 2m
sh fit_features.bash 498.8 343.4 0.307 1.00 0.18 553 1141.2 3 burglary 2w
sh fit_features.bash 526.3 361.7 0.332 0.19 10.11 373 904.9 1 street 1m
sh fit_features.bash 546.5 351.7 0.939 1.57 5.11 816 1048.3 1 all 1m
sh fit_features.bash 461.8 388.0 0.286 0.17 4.86 97 875.4 6 burglary 1m
sh fit_features.bash 306.5 553.2 0.203 3.71 8.18 104 1011.8 2 vehicle 3m
sh fit_features.bash 300.0 254.5 0.464 2.32 6.12 154 978.5 2 all 2w
sh fit_features.bash 355.0 554.5 0.700 2.86 1.56 1025 787.8 5 vehicle 2m
sh fit_features.bash 576.1 290.3 0.943 3.50 7.11 555 361.0 4 burglary 1w
sh fit_features.bash 563.3 293.2 0.473 3.84 9.59 107 601.4 5 all 1w
sh fit_features.bash 365.9 324.5 0.150 2.35 3.27 882 713.7 5 all 2m
sh fit_features.bash 587.7 470.5 0.485 1.52 5.78 470 1022.0 1 vehicle 1w
sh fit_features.bash 422.6 549.6 0.844 2.01 7.10 560 333.6 3 all 2w
sh fit_features.bash 592.3 317.6 0.695 1.17 9.06 1170 869.0 5 street 1m
sh fit_features.bash 494.7 493.2 0.302 2.22 9.00 93 701.9 2 vehicle 1m
sh fit_features.bash 335.5 478.6 0.494 0.13 10.98 651 258.6 3 vehicle 2w
sh fit_features.bash 398.7 499.1 0.259 2.58 9.04 620 595.1 3 vehicle 3m
sh fit_features.bash 522.8 499.2 0.003 3.28 4.72 245 640.7 5 street 1m
sh fit_features.bash 345.7 544.7 0.116 1.43 9.69 613 264.4 1 all 3m
sh fit_features.bash 284.6 552.0 0.092 2.82 1.81 202 780.6 1 all 2w
sh fit_features.bash 347.4 532.0 0.509 0.16 10.98 803 827.4 3 vehicle 2m
sh fit_features.bash 357.3 477.6 0.917 3.39 10.07 190 1168.4 5 vehicle 2m
sh fit_features.bash 518.9 333.1 0.515 0.63 9.17 735 1129.5 1 burglary 2m
sh fit_features.bash 416.8 525.0 0.391 0.68 5.85 835 1080.3 1 vehicle 3m
sh fit_features.bash 313.7 488.2 0.008 2.36 6.32 297 928.4 2 vehicle 1m
sh fit_features.bash 362.2 437.3 0.114 2.70 5.40 973 998.3 4 burglary 2m
sh fit_features.bash 266.6 502.7 0.761 1.49 4.92 1027 1057.5 5 burglary 2m
sh fit_features.bash 284.5 367.2 0.595 1.07 0.62 731 855.0 2 vehicle 3m
sh fit_features.bash 395.6 326.6 0.450 1.98 2.18 269 330.0 2 street 1w
sh fit_features.bash 508.1 531.1 0.336 1.72 4.61 964 608.5 1 vehicle 1w
sh fit_features.bash 572.6 336.7 0.685 1.86 10.07 974 1049.3 4 all 3m
sh fit_features.bash 465.5 266.0 0.224 3.08 1.62 233 159.5 6 all 2w
sh fit_features.bash 425.7 548.5 0.245 2.56 0.60 866 677.1 6 street 3m
sh fit_features.bash 348.3 547.4 0.352 0.36 2.36 758 705.9 2 street 1w
sh fit_features.bash 359.4 530.3 0.881 2.28 3.11 700 735.3 1 street 2m
sh fit_features.bash 561.6 483.4 0.184 3.34 2.33 315 543.7 2 vehicle 2m
sh fit_features.bash 397.6 455.0 0.348 3.39 11.91 281 502.7 5 street 2m
sh fit_features.bash 447.7 468.0 0.956 4.00 4.51 793 942.8 5 burglary 3m
sh fit_features.bash 435.6 584.1 0.223 2.94 1.54 540 531.0 4 vehicle 3m
sh fit_features.bash 256.7 259.6 0.091 1.18 9.65 861 1069.5 4 street 1m
sh fit_features.bash 453.6 350.8 0.265 3.38 10.46 1036 432.0 5 all 1w
sh fit_features.bash 583.1 472.2 0.140 0.48 6.97 786 554.1 6 burglary 2w
sh fit_features.bash 406.9 372.9 0.903 0.04 8.13 1152 853.2 3 street 3m
sh fit_features.bash 319.8 357.1 0.972 0.82 2.26 769 665.8 6 vehicle 1m
sh fit_features.bash 435.1 389.2 0.748 0.15 0.35 752 1066.4 3 street 2w
sh fit_features.bash 418.4 503.8 0.590 2.08 11.15 69 231.2 2 street 2m
sh fit_features.bash 263.9 378.8 0.125 1.46 3.33 1022 703.9 5 all 1w
