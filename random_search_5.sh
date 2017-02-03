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

sh fit_features.bash 567.7 352.4 0.345 0.65 0.12 356 936.4 4 burglary 3m
sh fit_features.bash 432.2 490.1 0.705 1.84 0.30 393 357.3 4 vehicle 3m
sh fit_features.bash 495.9 337.6 0.830 1.75 7.32 308 943.1 2 burglary 2m
sh fit_features.bash 323.4 433.5 0.923 3.83 2.56 850 292.8 3 burglary 3m
sh fit_features.bash 575.7 339.7 0.561 2.21 3.11 446 641.7 2 all 2w
sh fit_features.bash 408.9 549.3 0.031 3.16 7.58 667 314.3 1 all 2m
sh fit_features.bash 571.1 559.3 0.866 1.98 6.52 271 864.6 6 street 3m
sh fit_features.bash 512.2 479.0 0.697 2.58 8.06 819 1111.2 1 all 1w
sh fit_features.bash 293.6 438.4 0.862 0.53 11.31 1139 156.1 5 street 3m
sh fit_features.bash 523.1 453.0 0.378 0.16 4.25 85 704.6 6 vehicle 2m
sh fit_features.bash 340.3 470.8 0.596 1.18 0.84 608 795.6 4 vehicle 1m
sh fit_features.bash 425.8 501.7 0.156 2.04 7.54 1135 454.9 5 burglary 2m
sh fit_features.bash 583.4 582.8 0.042 0.70 11.11 997 150.4 4 vehicle 3m
sh fit_features.bash 421.4 395.4 0.864 1.23 11.09 530 171.1 6 burglary 2w
sh fit_features.bash 398.3 432.7 0.194 2.21 10.16 661 1089.8 3 all 1m
sh fit_features.bash 326.1 290.1 0.702 1.93 1.36 785 969.5 2 all 1w
sh fit_features.bash 573.3 479.4 0.924 1.60 5.95 590 1175.8 5 all 1w
sh fit_features.bash 563.4 575.9 0.326 1.93 1.82 120 1020.3 3 burglary 1w
sh fit_features.bash 510.6 511.7 0.957 0.67 9.99 808 417.0 1 vehicle 3m
sh fit_features.bash 349.7 502.6 0.270 0.49 1.45 366 1076.3 4 burglary 2w
sh fit_features.bash 268.2 307.4 0.126 1.66 9.03 52 351.1 3 street 2m
sh fit_features.bash 283.4 272.6 0.636 3.35 4.04 272 737.4 1 all 1w
sh fit_features.bash 292.7 385.7 0.598 0.72 8.82 348 709.5 1 vehicle 1w
sh fit_features.bash 493.9 592.0 0.198 0.27 11.13 568 266.0 4 vehicle 1m
sh fit_features.bash 380.4 369.4 0.107 2.93 6.53 721 250.2 2 burglary 1w
sh fit_features.bash 531.8 452.4 0.876 2.40 3.16 1017 794.4 6 all 3m
sh fit_features.bash 315.7 499.7 0.709 1.25 5.95 210 114.7 3 vehicle 1m
sh fit_features.bash 446.2 569.3 0.666 1.64 2.32 341 188.8 5 burglary 3m
sh fit_features.bash 310.3 534.0 0.816 3.92 3.89 889 1183.5 5 all 2m
sh fit_features.bash 303.2 431.1 0.169 3.98 9.52 430 743.5 5 vehicle 2m
sh fit_features.bash 294.9 255.5 0.208 3.26 10.67 116 1084.5 5 all 2m
sh fit_features.bash 591.6 348.3 0.435 1.62 5.90 655 431.7 3 all 1w
sh fit_features.bash 410.5 509.4 0.879 1.15 8.74 393 537.2 6 street 1w
sh fit_features.bash 546.8 359.3 0.315 2.43 7.75 1066 343.8 3 all 1w
sh fit_features.bash 504.6 420.2 0.013 3.27 4.23 159 449.7 4 burglary 2w
sh fit_features.bash 513.0 498.1 0.571 3.78 11.02 216 418.0 1 street 2w
sh fit_features.bash 458.9 298.1 0.799 3.75 4.12 473 133.7 6 burglary 3m
sh fit_features.bash 377.4 555.8 0.686 0.70 11.47 622 649.9 1 burglary 2w
sh fit_features.bash 491.5 546.3 0.725 1.46 0.18 921 157.2 3 all 2m
sh fit_features.bash 482.1 370.8 0.026 1.97 7.06 925 314.6 6 burglary 1w
sh fit_features.bash 412.3 564.1 0.684 2.46 0.18 202 660.2 5 street 3m
sh fit_features.bash 508.8 565.1 0.802 2.78 11.18 202 301.2 6 vehicle 1w
sh fit_features.bash 502.9 301.3 0.097 3.28 2.91 959 920.1 4 street 2w
sh fit_features.bash 466.9 305.9 0.711 0.48 8.18 852 1184.6 3 vehicle 2m
sh fit_features.bash 320.4 439.7 0.076 1.40 5.21 1136 968.9 5 street 1w
sh fit_features.bash 397.2 337.8 0.703 2.08 10.09 848 936.6 1 all 1m
sh fit_features.bash 585.9 540.8 0.162 0.98 5.74 78 397.3 5 vehicle 2m
sh fit_features.bash 319.5 444.5 0.719 1.31 11.90 138 615.6 4 all 3m
sh fit_features.bash 505.4 523.3 0.621 3.02 5.61 1133 860.8 5 all 2m
sh fit_features.bash 379.1 254.6 0.939 2.70 5.72 907 158.5 5 vehicle 2w
sh fit_features.bash 300.9 260.5 0.004 2.58 0.22 319 339.6 6 burglary 1w
sh fit_features.bash 267.9 509.3 0.206 0.40 6.70 846 881.6 1 street 3m
sh fit_features.bash 442.3 333.8 0.679 2.80 5.22 1089 969.4 2 burglary 2w
sh fit_features.bash 513.1 590.0 0.338 3.24 5.43 1093 1018.2 2 street 2w
sh fit_features.bash 594.4 573.7 0.172 3.01 6.92 311 232.8 1 burglary 3m
sh fit_features.bash 273.1 377.9 0.481 3.65 8.52 897 574.9 3 vehicle 2m
sh fit_features.bash 505.3 387.0 0.080 0.48 11.64 674 1047.7 2 street 1w
sh fit_features.bash 466.5 274.5 0.509 3.73 0.35 1043 988.4 4 street 1m
sh fit_features.bash 522.7 326.9 0.836 0.54 6.87 572 704.3 5 all 2w
sh fit_features.bash 486.9 507.8 0.062 2.45 11.55 897 316.1 2 vehicle 2w
sh fit_features.bash 291.5 307.1 0.816 0.66 0.46 185 1022.0 1 all 2m
sh fit_features.bash 579.5 290.2 0.753 3.25 6.47 881 1192.0 4 all 2m
sh fit_features.bash 503.7 316.9 0.631 3.24 0.17 1081 766.8 1 burglary 3m
sh fit_features.bash 392.4 385.0 0.665 0.76 4.04 983 410.3 2 street 2m
sh fit_features.bash 300.9 372.5 0.621 2.55 3.24 1023 1094.9 4 street 2m
sh fit_features.bash 468.6 530.3 0.303 3.54 2.85 422 576.5 3 vehicle 2w
sh fit_features.bash 487.0 275.1 0.676 0.17 9.76 1165 915.4 1 vehicle 1w
sh fit_features.bash 456.7 521.9 0.290 1.19 0.71 881 990.6 6 vehicle 2m
sh fit_features.bash 297.0 362.7 0.409 3.51 9.42 576 250.9 3 burglary 2w
sh fit_features.bash 563.6 260.5 0.687 1.44 10.59 218 1197.7 1 street 1w
sh fit_features.bash 578.2 391.2 0.729 1.31 0.38 1160 1144.6 3 street 3m
sh fit_features.bash 476.4 390.6 0.606 2.96 1.54 1151 950.5 3 burglary 2m
sh fit_features.bash 326.4 257.2 0.781 2.96 1.93 509 641.3 5 vehicle 1m
sh fit_features.bash 319.4 538.8 0.437 1.92 11.88 766 350.9 1 all 1m
sh fit_features.bash 423.7 379.3 0.311 0.89 9.13 600 261.1 1 street 2m
sh fit_features.bash 575.5 339.9 0.859 2.14 8.48 302 1181.5 6 all 1m
sh fit_features.bash 597.7 475.4 0.612 0.49 0.26 828 1178.9 2 all 1w
sh fit_features.bash 270.0 539.3 0.284 2.37 3.97 379 356.2 1 vehicle 1m
sh fit_features.bash 486.4 284.5 0.308 2.99 5.79 1186 1192.9 1 vehicle 2w
sh fit_features.bash 547.4 492.0 0.539 3.76 3.15 103 1192.7 5 burglary 2m
sh fit_features.bash 440.1 407.1 0.857 3.67 11.63 690 996.8 5 vehicle 3m
sh fit_features.bash 285.0 327.6 0.039 0.61 4.47 384 1091.1 4 vehicle 2m
sh fit_features.bash 360.5 394.7 0.756 0.79 8.29 428 471.3 1 all 3m
sh fit_features.bash 344.1 408.4 0.130 1.01 5.86 944 914.5 1 burglary 1m
sh fit_features.bash 281.6 427.7 0.210 2.79 9.38 157 545.7 6 burglary 3m
sh fit_features.bash 515.0 338.5 0.407 2.72 10.46 348 859.1 2 burglary 3m
sh fit_features.bash 434.6 418.1 0.579 2.89 2.34 1162 557.7 2 vehicle 2w
sh fit_features.bash 507.4 455.7 0.473 0.31 4.19 1061 847.8 3 burglary 2w
sh fit_features.bash 452.6 255.8 0.470 0.01 9.53 163 553.6 2 burglary 3m
sh fit_features.bash 526.0 592.3 0.726 2.40 6.59 316 1197.6 1 all 1m
sh fit_features.bash 356.0 343.9 0.314 2.52 9.10 940 602.7 2 street 1w
sh fit_features.bash 412.0 570.4 0.852 3.10 3.18 660 492.1 6 burglary 2w
sh fit_features.bash 289.6 311.8 0.573 0.23 5.39 104 1118.7 6 street 3m
sh fit_features.bash 352.6 327.4 0.872 3.87 0.41 376 274.1 2 burglary 1w
sh fit_features.bash 408.2 500.2 0.230 3.03 9.69 612 148.0 1 burglary 2w
sh fit_features.bash 340.0 547.2 0.397 3.02 2.45 748 973.3 4 burglary 3m
sh fit_features.bash 398.2 391.6 0.877 2.65 10.32 176 518.3 3 burglary 2m
sh fit_features.bash 263.1 418.0 0.238 0.95 0.32 673 235.0 3 street 3m
sh fit_features.bash 396.4 549.6 0.520 3.00 5.88 693 785.3 1 vehicle 2m
sh fit_features.bash 329.9 521.6 0.990 3.27 4.93 320 666.7 3 vehicle 1m
