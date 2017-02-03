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

sh fit_features.bash 465.8 312.1 0.227 3.64 6.09 134 413.2 2 all 2m
sh fit_features.bash 514.2 350.0 0.823 2.41 6.74 341 590.2 4 vehicle 3m
sh fit_features.bash 261.3 275.2 0.250 3.91 0.18 489 529.0 4 all 2m
sh fit_features.bash 301.8 252.9 0.446 2.10 2.48 1056 1107.0 8 vehicle 1m
sh fit_features.bash 445.2 344.4 0.043 2.43 8.90 1028 654.7 5 all 3m
sh fit_features.bash 507.3 421.8 0.176 1.23 10.24 389 1168.5 5 street 3m
sh fit_features.bash 285.4 415.8 0.958 0.40 1.59 329 355.9 2 vehicle 1w
sh fit_features.bash 269.7 524.5 0.259 2.19 10.27 1093 959.9 4 vehicle 1m
sh fit_features.bash 464.6 491.3 0.075 3.60 10.96 1083 705.8 1 vehicle 1m
sh fit_features.bash 562.3 593.6 0.568 1.06 4.52 848 557.3 5 all 1w
sh fit_features.bash 536.7 527.4 0.149 1.43 2.92 580 414.0 2 all 2w
sh fit_features.bash 552.5 334.0 0.056 1.28 3.55 296 834.8 3 burglary 2w
sh fit_features.bash 415.0 285.8 0.112 1.69 6.06 1182 177.5 1 all 1w
sh fit_features.bash 552.0 504.6 0.311 3.00 10.35 382 848.9 5 vehicle 2w
sh fit_features.bash 445.0 293.0 0.146 0.82 8.14 392 359.5 6 street 1w
sh fit_features.bash 269.8 541.3 0.920 3.48 3.98 511 693.4 6 street 3m
sh fit_features.bash 371.8 313.1 0.007 0.73 9.52 683 782.2 6 vehicle 2m
sh fit_features.bash 317.4 596.2 0.068 3.56 5.00 606 748.6 6 all 3m
sh fit_features.bash 331.3 409.1 0.010 1.77 10.42 668 685.7 4 all 2m
sh fit_features.bash 307.0 455.1 0.913 1.80 10.27 744 810.7 6 street 2w
sh fit_features.bash 373.1 270.6 0.829 1.45 0.33 890 593.3 6 burglary 2m
sh fit_features.bash 291.0 381.0 0.471 1.46 7.49 167 708.3 6 all 1m
sh fit_features.bash 325.1 484.0 0.614 1.69 7.72 133 1050.3 7 all 1w
sh fit_features.bash 251.6 557.6 0.982 3.53 1.60 1160 373.4 4 vehicle 1m
sh fit_features.bash 478.8 304.8 0.621 3.62 1.87 682 241.0 5 burglary 2w
sh fit_features.bash 439.2 466.2 0.431 0.94 8.63 217 647.6 7 burglary 2m
sh fit_features.bash 420.5 416.6 0.927 1.16 11.95 112 1095.9 7 street 1w
sh fit_features.bash 580.3 429.1 0.467 2.92 6.62 1089 747.8 2 all 2w
sh fit_features.bash 565.2 437.8 0.260 2.88 2.62 211 207.5 7 all 2w
sh fit_features.bash 400.5 381.5 0.706 2.62 5.17 911 566.2 2 vehicle 1m
sh fit_features.bash 501.1 358.0 0.922 3.01 5.85 1064 861.0 8 vehicle 1w
sh fit_features.bash 563.6 430.9 0.297 2.90 0.05 601 147.6 7 burglary 1m
sh fit_features.bash 595.4 475.3 0.766 2.23 8.88 152 1024.4 4 burglary 2m
sh fit_features.bash 422.8 389.3 0.740 0.95 1.61 404 889.7 3 burglary 2w
sh fit_features.bash 544.8 450.4 0.192 3.75 5.87 875 430.8 7 all 1w
sh fit_features.bash 445.3 253.5 0.790 1.58 0.04 804 579.1 2 burglary 1w
sh fit_features.bash 327.3 439.8 0.005 3.67 4.99 1104 266.3 3 vehicle 3m
sh fit_features.bash 347.0 304.7 0.623 1.39 11.21 110 598.3 4 vehicle 2w
sh fit_features.bash 330.5 483.2 0.361 2.36 6.68 220 785.5 8 street 3m
sh fit_features.bash 268.1 446.6 0.535 0.08 5.15 374 229.0 3 street 1w
sh fit_features.bash 382.4 563.0 0.721 2.07 5.29 623 115.0 5 street 2w
sh fit_features.bash 298.1 252.4 0.494 3.15 10.68 1068 1081.6 1 street 1m
sh fit_features.bash 533.4 447.2 0.789 3.15 2.59 94 1004.7 5 all 2m
sh fit_features.bash 562.3 573.9 0.653 3.51 1.83 125 739.8 6 vehicle 2w
sh fit_features.bash 506.6 326.6 0.105 2.96 4.04 613 467.3 1 vehicle 2m
sh fit_features.bash 330.8 564.1 0.784 1.28 0.33 868 574.9 3 burglary 3m
sh fit_features.bash 251.7 476.9 0.845 1.04 8.28 1136 602.1 7 vehicle 3m
sh fit_features.bash 298.3 523.9 0.706 1.88 6.18 1178 261.4 2 burglary 1w
sh fit_features.bash 446.9 566.8 0.439 2.81 11.12 706 958.8 7 burglary 2m
sh fit_features.bash 593.7 567.1 0.403 1.52 0.16 495 490.4 2 vehicle 3m
sh fit_features.bash 551.0 325.6 0.650 1.22 0.88 287 268.3 7 burglary 2m
sh fit_features.bash 523.9 587.2 0.806 3.63 3.53 655 743.8 5 burglary 2w
sh fit_features.bash 518.1 374.3 0.963 2.84 8.51 906 1151.3 2 vehicle 1w
sh fit_features.bash 501.1 382.6 0.265 1.95 5.73 670 1101.7 5 street 1m
sh fit_features.bash 530.8 323.7 0.898 3.08 5.05 848 187.5 4 all 1m
sh fit_features.bash 524.2 583.6 0.781 1.03 1.82 854 1145.2 3 street 1w
sh fit_features.bash 531.4 380.3 0.190 1.46 11.30 669 879.0 7 street 1m
sh fit_features.bash 307.5 561.8 0.423 3.96 1.53 1053 1006.4 8 burglary 2w
sh fit_features.bash 335.8 418.2 0.203 2.07 4.65 1097 670.2 2 all 2m
sh fit_features.bash 446.3 404.8 0.988 2.49 1.71 921 203.6 7 vehicle 1w
sh fit_features.bash 546.4 366.1 0.181 1.53 3.55 576 1090.5 3 burglary 2w
sh fit_features.bash 373.1 572.1 0.448 0.55 6.28 1053 1061.7 4 street 2m
sh fit_features.bash 568.9 367.4 0.317 1.04 7.83 900 267.3 2 all 1w
sh fit_features.bash 554.4 599.4 0.710 1.24 11.14 127 100.3 4 vehicle 2w
sh fit_features.bash 517.7 280.2 0.987 2.92 6.39 490 310.2 2 burglary 2w
sh fit_features.bash 397.7 509.5 0.614 1.08 5.97 444 352.5 6 all 3m
sh fit_features.bash 479.4 598.7 0.864 0.70 3.11 695 221.1 3 burglary 2m
sh fit_features.bash 595.3 328.8 0.163 2.02 8.08 126 355.9 7 vehicle 1w
sh fit_features.bash 459.9 557.5 0.658 1.48 10.99 192 730.6 3 all 2w
sh fit_features.bash 498.5 259.2 0.349 2.32 3.34 668 994.8 1 vehicle 1m
sh fit_features.bash 403.7 565.3 0.619 2.04 8.32 113 104.2 8 burglary 3m
sh fit_features.bash 442.0 579.3 0.987 2.55 6.01 1049 1155.9 3 burglary 3m
sh fit_features.bash 465.1 277.4 0.074 3.63 11.96 787 387.0 2 vehicle 1m
sh fit_features.bash 520.5 498.1 0.862 2.80 1.12 1021 439.3 1 burglary 2m
sh fit_features.bash 539.6 453.3 0.084 0.90 3.91 442 307.5 2 all 3m
sh fit_features.bash 285.4 332.4 0.475 2.68 5.91 335 1195.2 1 all 1m
sh fit_features.bash 540.7 582.3 0.611 2.61 5.23 1085 1164.6 2 all 2w
sh fit_features.bash 446.4 373.7 0.239 2.86 5.16 738 970.8 3 vehicle 3m
sh fit_features.bash 292.9 571.6 0.018 1.72 3.47 803 817.5 1 burglary 1w
sh fit_features.bash 537.7 415.9 0.343 3.27 1.56 699 798.3 8 street 1w
sh fit_features.bash 425.9 250.1 0.889 1.49 5.90 149 535.6 1 all 2w
sh fit_features.bash 259.0 307.7 0.290 0.02 2.15 919 924.4 3 burglary 1m
sh fit_features.bash 516.1 519.6 0.921 0.62 6.64 1058 132.7 6 vehicle 3m
sh fit_features.bash 474.7 284.1 0.765 1.76 9.43 864 112.0 2 burglary 2w
sh fit_features.bash 304.8 590.4 0.831 0.90 1.97 850 862.3 8 burglary 1m
sh fit_features.bash 402.3 550.9 0.248 2.62 10.28 145 789.1 6 vehicle 1m
sh fit_features.bash 568.4 568.6 0.581 2.45 5.42 645 242.9 7 vehicle 2w
sh fit_features.bash 398.9 328.2 0.361 3.27 11.81 283 648.3 8 all 1w
sh fit_features.bash 420.8 532.3 0.096 4.00 5.77 589 693.0 7 vehicle 2w
sh fit_features.bash 555.9 425.0 0.690 2.58 9.05 758 495.4 5 street 1w
sh fit_features.bash 465.7 302.4 0.901 2.18 9.93 765 590.5 7 burglary 3m
sh fit_features.bash 481.4 506.5 0.412 0.89 11.16 1007 820.3 1 street 1m
sh fit_features.bash 561.1 268.3 0.514 3.26 9.27 98 272.0 5 street 1m
sh fit_features.bash 423.3 297.9 0.003 2.17 3.44 65 280.7 6 street 2w
sh fit_features.bash 400.4 263.6 0.413 1.15 0.85 280 874.8 8 street 3m
sh fit_features.bash 311.6 317.1 0.070 1.54 9.45 723 339.2 7 burglary 2m
sh fit_features.bash 538.0 557.4 0.698 2.11 2.34 350 324.3 2 street 1m
sh fit_features.bash 499.3 513.2 0.916 1.27 3.29 466 506.0 3 burglary 2m
sh fit_features.bash 555.2 524.3 0.578 3.57 10.24 559 578.8 8 burglary 2m
sh fit_features.bash 485.6 546.8 0.565 1.95 3.14 713 107.6 8 street 1m
