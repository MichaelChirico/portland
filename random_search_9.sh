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

sh fit_features.bash 492.0 305.0 0.275 0.35 10.47 479 481.3 3 street 1w
sh fit_features.bash 533.4 588.3 0.710 0.25 6.07 1057 563.2 2 burglary 2m
sh fit_features.bash 482.9 345.4 0.090 0.14 7.24 474 1169.3 4 all 3m
sh fit_features.bash 438.5 377.1 0.807 3.34 5.15 673 691.8 8 street 3m
sh fit_features.bash 250.1 446.2 0.602 0.94 8.00 398 787.6 7 burglary 3m
sh fit_features.bash 551.3 539.7 0.602 2.71 8.53 291 898.2 3 burglary 1w
sh fit_features.bash 485.4 273.8 0.631 0.50 4.88 328 633.6 1 all 3m
sh fit_features.bash 368.8 496.7 0.966 2.14 6.27 1191 636.0 4 vehicle 3m
sh fit_features.bash 498.2 487.7 0.107 2.08 1.12 1030 511.8 8 vehicle 2m
sh fit_features.bash 482.2 471.4 0.465 1.46 1.18 707 492.3 8 all 3m
sh fit_features.bash 451.6 366.6 0.577 0.92 2.67 347 1113.3 8 street 2m
sh fit_features.bash 432.5 450.4 0.222 0.83 3.06 141 877.1 7 burglary 2m
sh fit_features.bash 588.5 263.8 0.264 0.45 1.75 403 675.7 2 all 3m
sh fit_features.bash 348.4 458.5 0.267 3.80 2.97 544 436.0 1 all 3m
sh fit_features.bash 374.4 426.7 0.780 1.03 2.10 1198 669.2 4 vehicle 2m
sh fit_features.bash 417.5 578.9 0.127 2.18 11.77 756 1088.3 1 street 2w
sh fit_features.bash 588.3 332.7 0.092 2.47 4.26 409 331.3 1 all 3m
sh fit_features.bash 433.2 594.5 0.675 1.05 4.36 1042 725.9 5 burglary 2m
sh fit_features.bash 263.8 480.1 0.669 1.39 0.22 506 449.4 3 all 2m
sh fit_features.bash 439.6 576.8 0.438 2.24 10.73 1140 250.9 1 vehicle 2w
sh fit_features.bash 514.7 333.3 0.106 0.42 9.70 1083 518.8 7 burglary 1m
sh fit_features.bash 402.3 360.6 0.193 2.29 4.38 840 1140.7 3 vehicle 2w
sh fit_features.bash 596.7 510.6 0.329 2.21 2.78 812 603.2 7 vehicle 2m
sh fit_features.bash 423.0 419.2 0.383 2.26 1.62 322 781.9 2 vehicle 2m
sh fit_features.bash 396.1 362.9 0.258 2.79 6.73 75 881.8 8 vehicle 3m
sh fit_features.bash 562.6 250.3 0.627 2.27 8.33 593 622.9 4 all 1w
sh fit_features.bash 521.6 590.4 0.738 0.58 5.52 937 959.6 4 street 2m
sh fit_features.bash 506.2 322.0 0.432 0.63 10.51 978 118.9 8 all 2m
sh fit_features.bash 435.3 415.2 0.031 0.34 0.45 342 729.9 4 vehicle 1m
sh fit_features.bash 307.3 258.1 0.190 3.53 6.17 453 171.9 5 street 3m
sh fit_features.bash 369.9 483.2 0.601 1.47 3.00 179 684.8 8 street 1m
sh fit_features.bash 332.2 537.7 0.671 2.80 9.94 805 1019.8 8 vehicle 2w
sh fit_features.bash 462.3 298.0 0.380 2.79 11.25 1091 1042.1 4 burglary 1m
sh fit_features.bash 280.0 567.4 0.033 1.40 10.21 238 659.3 3 vehicle 2m
sh fit_features.bash 554.6 562.8 0.104 3.77 2.07 58 103.8 4 vehicle 2w
sh fit_features.bash 378.2 353.6 0.630 1.45 5.95 647 1066.1 7 street 2w
sh fit_features.bash 519.3 340.1 0.044 0.96 5.95 638 414.4 2 burglary 3m
sh fit_features.bash 567.7 422.1 0.345 1.83 10.80 908 1026.2 2 street 2m
sh fit_features.bash 376.8 507.6 0.264 1.39 11.21 497 959.7 3 vehicle 2w
sh fit_features.bash 529.0 285.8 0.686 1.66 0.07 323 680.6 8 all 2w
sh fit_features.bash 434.7 290.6 0.227 0.98 6.59 523 334.1 4 all 1w
sh fit_features.bash 270.0 541.1 0.136 0.58 3.87 1082 995.1 6 vehicle 2m
sh fit_features.bash 539.3 528.3 0.424 3.53 1.33 531 550.5 7 burglary 2w
sh fit_features.bash 389.5 483.8 0.740 0.67 1.32 329 1067.0 3 burglary 2m
sh fit_features.bash 429.7 540.3 0.986 1.78 10.63 84 870.4 3 burglary 1w
sh fit_features.bash 378.5 315.6 0.647 1.10 2.31 101 457.7 5 street 3m
sh fit_features.bash 287.7 274.2 0.339 3.18 5.80 974 210.2 4 street 1w
sh fit_features.bash 345.1 561.0 0.254 1.02 6.17 634 114.6 6 all 1w
sh fit_features.bash 286.6 341.7 0.012 1.48 6.83 1045 897.6 5 all 1w
sh fit_features.bash 517.7 579.4 0.073 0.64 6.15 453 1088.6 8 burglary 2w
sh fit_features.bash 547.9 567.8 0.668 3.32 8.53 477 223.3 7 burglary 2w
sh fit_features.bash 255.5 323.2 0.081 0.02 11.61 444 1045.7 6 street 1m
sh fit_features.bash 295.6 569.2 0.190 2.83 0.65 1188 436.9 2 vehicle 2m
sh fit_features.bash 257.1 508.5 0.636 1.55 1.81 1010 1182.0 3 burglary 2w
sh fit_features.bash 354.2 516.9 0.122 0.15 4.88 403 778.4 7 street 1w
sh fit_features.bash 330.3 500.1 0.741 1.30 11.07 366 769.4 3 vehicle 1w
sh fit_features.bash 428.4 328.5 0.856 2.63 7.42 605 196.9 5 vehicle 3m
sh fit_features.bash 298.2 390.6 0.317 1.21 2.88 488 531.4 8 burglary 2w
sh fit_features.bash 328.0 577.9 0.282 2.08 1.67 238 903.6 7 vehicle 2m
sh fit_features.bash 551.4 427.7 0.899 1.76 3.40 453 304.8 4 all 3m
sh fit_features.bash 548.2 345.6 0.139 1.53 4.73 259 766.1 1 vehicle 2w
sh fit_features.bash 421.3 541.6 0.192 2.93 6.11 495 422.2 8 burglary 1m
sh fit_features.bash 432.8 485.9 0.990 1.62 7.08 248 1137.3 4 street 1w
sh fit_features.bash 335.2 294.0 0.569 2.40 6.23 374 445.7 7 all 2w
sh fit_features.bash 571.3 582.0 0.195 1.64 2.21 1028 822.6 4 all 1m
sh fit_features.bash 597.5 416.6 0.210 2.92 0.77 949 325.7 4 all 3m
sh fit_features.bash 362.9 393.3 0.769 2.87 2.69 1105 897.9 6 vehicle 3m
sh fit_features.bash 323.6 508.1 0.879 1.82 2.51 511 876.3 1 vehicle 3m
sh fit_features.bash 334.6 569.2 0.389 2.70 7.63 951 605.3 8 vehicle 1m
sh fit_features.bash 284.4 281.8 0.131 1.94 4.98 247 714.2 4 all 2w
sh fit_features.bash 362.3 419.4 0.861 0.95 7.25 81 1006.2 1 vehicle 2m
sh fit_features.bash 427.8 598.5 0.381 1.10 1.35 711 814.3 8 vehicle 2w
sh fit_features.bash 580.6 400.0 0.282 2.28 6.82 314 1089.6 3 all 3m
sh fit_features.bash 539.8 535.3 0.581 2.78 2.51 357 1115.7 2 burglary 2w
sh fit_features.bash 560.7 573.1 0.458 2.61 0.76 578 122.0 4 street 1w
sh fit_features.bash 454.2 273.8 0.895 2.68 0.60 461 513.9 1 burglary 1w
sh fit_features.bash 320.5 453.0 0.006 2.64 9.87 780 114.2 3 burglary 2w
sh fit_features.bash 596.1 266.9 0.794 2.30 2.06 991 684.8 6 vehicle 2m
sh fit_features.bash 400.8 452.1 0.927 0.65 11.73 856 774.4 1 all 1w
sh fit_features.bash 506.7 443.3 0.138 0.41 2.60 754 262.5 3 all 2m
sh fit_features.bash 454.1 514.0 0.757 2.79 2.82 694 1053.9 2 street 1m
sh fit_features.bash 450.2 299.9 0.618 3.87 6.00 947 1190.8 2 all 1m
sh fit_features.bash 592.7 438.7 0.089 2.32 9.61 319 1070.7 8 street 1w
sh fit_features.bash 444.0 559.5 0.946 3.67 9.59 301 280.9 8 burglary 1m
sh fit_features.bash 533.5 284.7 0.984 0.48 5.84 962 104.9 1 vehicle 2w
sh fit_features.bash 592.5 358.8 0.374 0.32 2.21 462 195.7 4 street 1m
sh fit_features.bash 300.8 582.0 0.915 2.88 4.18 804 1027.2 8 all 1w
sh fit_features.bash 360.5 594.0 0.029 2.85 6.75 160 757.4 7 all 3m
sh fit_features.bash 477.4 300.2 0.761 2.79 4.05 87 1092.4 2 vehicle 2w
sh fit_features.bash 285.0 598.1 0.654 1.08 9.95 1200 590.2 2 burglary 3m
sh fit_features.bash 444.6 555.8 0.951 2.19 3.83 1095 119.9 7 all 1w
sh fit_features.bash 357.1 523.2 0.849 2.80 3.40 803 313.8 1 vehicle 2w
sh fit_features.bash 535.5 416.5 0.065 1.25 5.70 869 112.3 4 burglary 1m
sh fit_features.bash 528.4 489.8 0.184 2.73 5.33 914 1155.2 5 burglary 3m
sh fit_features.bash 350.1 485.0 0.586 1.41 0.67 830 1120.0 6 burglary 2m
sh fit_features.bash 512.5 430.1 0.463 0.88 0.36 953 272.4 6 street 2m
sh fit_features.bash 582.7 295.7 0.520 2.37 8.25 303 139.7 8 burglary 2w
sh fit_features.bash 523.7 528.2 0.906 1.76 10.68 1123 1016.6 3 all 1w
sh fit_features.bash 339.4 274.7 0.865 1.39 4.78 1168 1117.9 8 vehicle 2m
sh fit_features.bash 281.4 555.1 0.689 0.73 10.01 816 422.1 1 burglary 1w
