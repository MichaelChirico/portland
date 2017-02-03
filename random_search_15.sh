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

sh fit_features.bash 384.6 490.5 0.569 2.07 11.76 681 817.8 4 all 2m
sh fit_features.bash 315.5 526.3 0.899 0.29 9.30 416 140.4 3 all 2w
sh fit_features.bash 556.9 478.5 0.046 1.91 0.58 1144 253.3 8 vehicle 2w
sh fit_features.bash 307.8 333.4 0.665 1.06 6.70 942 815.3 5 vehicle 1m
sh fit_features.bash 532.1 515.3 0.911 1.09 3.35 145 943.4 3 burglary 1w
sh fit_features.bash 347.8 441.5 0.024 0.87 7.68 456 1139.9 3 street 3m
sh fit_features.bash 394.6 356.2 0.361 2.84 6.05 376 898.4 2 all 1w
sh fit_features.bash 433.7 361.6 0.463 2.46 1.86 214 940.9 4 burglary 1w
sh fit_features.bash 531.7 446.3 0.842 1.39 8.60 161 358.0 4 burglary 1m
sh fit_features.bash 547.1 551.1 0.335 0.50 6.93 318 898.8 2 burglary 1m
sh fit_features.bash 567.3 437.1 0.270 2.56 8.82 555 1188.5 7 street 2w
sh fit_features.bash 534.8 430.9 0.434 2.98 3.05 391 1101.4 5 burglary 3m
sh fit_features.bash 384.8 325.2 0.992 2.14 6.24 560 560.4 4 all 1m
sh fit_features.bash 516.0 534.7 0.827 1.37 5.85 1026 468.8 5 street 1m
sh fit_features.bash 324.0 381.0 0.235 1.75 8.16 536 962.6 8 vehicle 1m
sh fit_features.bash 501.6 310.9 0.465 2.80 10.60 150 435.2 3 vehicle 3m
sh fit_features.bash 297.6 317.6 0.139 1.13 5.22 1195 1051.6 5 all 1w
sh fit_features.bash 503.5 365.2 0.353 0.02 5.42 1012 721.0 1 street 1m
sh fit_features.bash 491.7 295.4 0.250 1.89 0.48 580 501.6 6 vehicle 2w
sh fit_features.bash 270.0 433.0 0.953 1.93 2.42 502 158.2 6 all 2m
sh fit_features.bash 455.1 405.9 0.380 2.34 4.29 111 1105.1 4 burglary 3m
sh fit_features.bash 562.6 339.6 0.067 2.14 9.36 423 801.0 6 vehicle 1m
sh fit_features.bash 591.1 510.3 0.627 0.32 9.88 1108 283.1 4 burglary 2w
sh fit_features.bash 533.0 487.9 0.321 3.56 3.63 111 1034.4 7 vehicle 2m
sh fit_features.bash 398.7 449.1 0.020 1.87 6.47 1052 498.7 3 street 1m
sh fit_features.bash 387.7 380.9 0.133 2.48 4.66 1146 402.2 6 vehicle 1m
sh fit_features.bash 493.9 554.8 0.023 1.07 10.13 967 489.4 5 all 2w
sh fit_features.bash 585.4 298.1 0.891 0.81 3.09 1184 570.0 3 street 2w
sh fit_features.bash 340.9 508.0 0.304 3.11 6.00 144 490.3 2 vehicle 2w
sh fit_features.bash 348.6 341.9 0.347 1.13 8.25 343 229.7 6 all 2w
sh fit_features.bash 463.9 321.0 0.971 2.87 2.09 206 489.6 2 all 1w
sh fit_features.bash 488.0 261.3 0.372 2.63 11.35 439 428.8 4 burglary 1w
sh fit_features.bash 599.2 550.1 0.673 0.41 0.55 184 234.8 6 vehicle 2w
sh fit_features.bash 479.4 336.3 0.132 1.20 1.72 651 890.9 6 street 3m
sh fit_features.bash 396.5 470.5 0.670 2.98 7.15 391 257.1 6 burglary 1w
sh fit_features.bash 539.3 551.3 0.727 3.73 6.39 362 1061.2 3 vehicle 1m
sh fit_features.bash 544.9 326.3 0.532 2.14 4.36 396 834.6 3 street 1m
sh fit_features.bash 406.0 539.5 0.875 3.59 10.63 710 247.8 4 burglary 3m
sh fit_features.bash 400.7 326.0 0.324 3.20 11.78 145 1177.4 7 vehicle 2m
sh fit_features.bash 431.7 495.4 0.842 0.01 3.94 1168 901.4 2 all 2w
sh fit_features.bash 581.1 485.3 0.848 1.13 6.06 545 287.7 4 street 2m
sh fit_features.bash 334.0 594.9 0.475 3.86 2.28 1028 455.7 7 burglary 3m
sh fit_features.bash 250.9 285.9 0.383 3.63 11.84 641 159.6 8 all 2m
sh fit_features.bash 337.9 423.8 0.994 1.26 8.41 1028 755.3 8 burglary 3m
sh fit_features.bash 524.4 574.2 0.111 1.63 9.34 552 1040.9 6 burglary 2m
sh fit_features.bash 308.6 379.0 0.300 2.20 7.49 370 262.8 6 burglary 1w
sh fit_features.bash 450.8 476.3 0.857 3.30 5.63 841 371.4 5 all 1w
sh fit_features.bash 592.7 383.3 0.374 3.73 9.64 417 878.0 3 street 3m
sh fit_features.bash 319.4 324.2 0.706 2.17 8.74 496 107.1 8 street 2m
sh fit_features.bash 427.1 481.7 0.603 3.83 4.40 1049 993.8 8 burglary 1m
sh fit_features.bash 441.2 335.8 0.576 0.97 0.04 1076 244.5 5 vehicle 2m
sh fit_features.bash 503.0 507.9 0.771 0.40 9.94 960 650.3 6 vehicle 2m
sh fit_features.bash 303.9 512.7 0.522 1.14 1.25 75 804.8 2 street 2w
sh fit_features.bash 542.9 503.6 0.148 3.62 11.66 345 1183.7 7 burglary 2w
sh fit_features.bash 280.2 374.9 0.168 2.74 6.24 934 1070.5 6 street 2w
sh fit_features.bash 293.1 468.4 0.521 3.58 2.56 1136 586.4 8 all 2m
sh fit_features.bash 269.6 365.7 0.308 1.46 8.67 1102 1182.8 7 all 2m
sh fit_features.bash 413.8 357.4 0.830 3.56 7.59 842 1079.3 3 street 1w
sh fit_features.bash 482.8 475.5 0.488 1.28 0.48 416 1154.3 3 burglary 3m
sh fit_features.bash 309.9 527.6 0.904 3.10 5.94 527 764.0 3 all 1w
sh fit_features.bash 459.9 392.9 0.666 1.27 6.73 1083 327.4 7 street 3m
sh fit_features.bash 548.3 425.0 0.555 2.27 10.85 68 863.2 8 vehicle 1w
sh fit_features.bash 253.5 477.2 0.421 2.01 0.46 103 217.1 8 burglary 1m
sh fit_features.bash 329.2 347.2 0.981 0.27 0.38 518 874.7 1 vehicle 2w
sh fit_features.bash 349.6 316.9 0.574 2.06 4.63 1123 182.1 2 burglary 1m
sh fit_features.bash 432.9 544.3 0.321 3.04 4.50 618 522.6 4 burglary 2w
sh fit_features.bash 482.5 459.5 0.525 3.83 7.71 706 1198.4 7 burglary 1m
sh fit_features.bash 291.0 458.3 0.199 1.06 4.22 809 1041.2 3 burglary 1m
sh fit_features.bash 360.7 423.9 0.057 2.40 4.52 126 927.5 7 street 1w
sh fit_features.bash 348.0 335.9 0.435 3.90 3.32 472 710.9 5 street 2w
sh fit_features.bash 555.1 385.5 0.018 2.12 5.62 417 239.8 2 burglary 2m
sh fit_features.bash 268.9 477.0 0.750 2.30 5.65 1029 888.4 3 vehicle 3m
sh fit_features.bash 377.2 468.2 0.029 0.45 8.59 608 960.6 7 street 1w
sh fit_features.bash 251.0 251.0 0.943 1.17 0.00 599 530.7 4 vehicle 1m
sh fit_features.bash 578.5 383.7 0.942 2.71 3.05 780 584.9 5 vehicle 2m
sh fit_features.bash 435.1 560.1 0.499 1.36 6.16 909 882.0 1 street 3m
sh fit_features.bash 576.3 516.7 0.930 0.14 6.89 735 1032.4 8 burglary 1m
sh fit_features.bash 387.2 333.7 0.319 0.20 0.75 834 717.7 4 vehicle 1w
sh fit_features.bash 592.6 389.1 0.322 2.88 4.92 1016 202.9 8 street 3m
sh fit_features.bash 529.1 308.5 0.789 2.52 6.59 913 995.1 4 burglary 3m
sh fit_features.bash 367.5 504.1 0.565 2.63 0.11 435 446.6 7 all 3m
sh fit_features.bash 585.7 502.0 0.716 0.71 1.87 825 1117.4 2 vehicle 3m
sh fit_features.bash 406.0 478.9 0.764 3.71 8.89 860 376.2 1 burglary 2m
sh fit_features.bash 354.5 582.4 0.083 2.23 9.80 228 818.0 6 burglary 1m
sh fit_features.bash 544.9 556.8 0.247 2.09 9.93 211 680.6 3 burglary 3m
sh fit_features.bash 451.2 304.4 0.988 2.58 2.04 826 627.4 7 street 2w
sh fit_features.bash 588.3 398.7 0.464 3.52 2.51 849 1195.7 4 all 3m
sh fit_features.bash 329.6 560.1 0.579 2.91 8.37 1050 280.5 7 vehicle 1w
sh fit_features.bash 316.1 529.9 0.635 2.93 8.97 537 1144.8 2 street 1w
sh fit_features.bash 511.4 279.8 0.946 2.74 10.90 1078 1076.3 2 vehicle 2m
sh fit_features.bash 593.2 350.5 0.473 3.15 3.49 113 262.5 3 vehicle 3m
sh fit_features.bash 252.3 459.3 0.443 2.88 0.50 343 333.3 3 burglary 1w
sh fit_features.bash 393.7 452.5 0.141 2.73 9.77 611 211.0 3 all 2w
sh fit_features.bash 351.3 252.4 0.353 1.65 5.35 574 324.3 7 vehicle 2w
sh fit_features.bash 252.6 460.0 0.129 2.40 8.89 717 234.2 1 burglary 3m
sh fit_features.bash 278.4 494.8 0.648 2.38 9.48 664 1060.9 8 street 1m
sh fit_features.bash 594.3 569.9 0.022 0.62 3.11 688 100.2 6 all 1w
sh fit_features.bash 586.1 425.7 0.117 2.79 11.66 835 261.0 5 burglary 2w
sh fit_features.bash 402.5 534.8 0.605 3.91 5.39 527 443.6 6 street 1m
sh fit_features.bash 494.1 289.7 0.196 1.52 5.31 554 498.7 5 all 2m
