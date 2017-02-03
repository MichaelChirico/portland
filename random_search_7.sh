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

sh fit_features.bash 525.9 395.9 0.580 3.43 9.07 333 846.1 2 street 2m
sh fit_features.bash 296.9 413.5 0.367 0.53 5.87 244 1045.8 6 all 1w
sh fit_features.bash 396.6 463.2 0.217 2.69 3.47 391 138.4 4 all 2m
sh fit_features.bash 345.6 435.2 0.474 0.02 10.18 538 289.5 2 all 3m
sh fit_features.bash 595.5 386.3 0.085 2.29 9.05 391 881.5 7 burglary 2w
sh fit_features.bash 406.9 537.8 0.935 0.38 11.12 700 343.7 6 vehicle 2w
sh fit_features.bash 425.1 320.8 0.117 0.31 6.46 583 123.8 8 burglary 3m
sh fit_features.bash 333.4 431.1 0.943 1.00 3.59 745 586.4 5 burglary 3m
sh fit_features.bash 536.3 257.9 0.987 0.10 8.43 384 951.7 6 vehicle 3m
sh fit_features.bash 355.6 307.1 0.267 0.04 7.00 851 1059.5 4 vehicle 1m
sh fit_features.bash 340.3 531.3 0.172 1.17 9.94 1074 1129.1 2 all 2w
sh fit_features.bash 480.8 397.7 0.988 0.25 0.92 57 473.3 2 burglary 1w
sh fit_features.bash 570.6 260.2 0.304 1.27 0.14 130 575.5 3 burglary 1m
sh fit_features.bash 387.4 406.4 0.122 2.92 8.90 1002 362.9 8 vehicle 3m
sh fit_features.bash 581.0 254.1 0.223 2.45 9.04 928 720.7 1 street 1w
sh fit_features.bash 464.1 572.9 0.185 1.77 4.98 695 169.2 6 burglary 3m
sh fit_features.bash 331.7 535.2 0.389 1.32 8.36 267 409.7 1 all 2w
sh fit_features.bash 421.9 494.4 0.881 0.27 1.47 877 715.0 8 all 2w
sh fit_features.bash 268.3 595.9 0.678 1.56 6.16 521 1131.7 7 burglary 1m
sh fit_features.bash 343.3 441.7 0.706 0.49 8.73 938 144.5 8 burglary 3m
sh fit_features.bash 374.8 550.1 0.545 1.23 8.91 263 493.8 2 all 1m
sh fit_features.bash 261.4 407.7 0.843 0.76 11.07 118 161.5 6 all 2m
sh fit_features.bash 475.9 524.9 0.884 2.08 7.90 478 1046.2 7 all 1m
sh fit_features.bash 585.9 309.6 0.300 0.78 2.79 133 413.1 1 burglary 1m
sh fit_features.bash 469.5 432.6 0.634 1.62 4.08 1140 500.0 8 all 1m
sh fit_features.bash 348.1 350.9 0.874 2.47 10.84 925 515.3 7 burglary 1w
sh fit_features.bash 453.1 461.8 0.788 3.20 4.42 341 515.7 6 burglary 1w
sh fit_features.bash 369.3 250.3 0.978 3.41 8.24 1101 264.7 2 burglary 1w
sh fit_features.bash 579.8 379.4 0.793 3.75 8.21 840 494.7 5 burglary 1w
sh fit_features.bash 382.3 501.5 0.676 3.15 6.79 650 785.1 8 all 2m
sh fit_features.bash 597.9 570.1 0.321 3.94 6.80 1009 689.6 3 all 2w
sh fit_features.bash 307.2 322.9 0.024 0.49 4.63 981 1048.0 5 vehicle 1m
sh fit_features.bash 266.7 526.6 0.914 1.05 3.40 88 867.5 1 vehicle 1w
sh fit_features.bash 516.0 428.1 0.174 0.23 7.02 203 1025.3 2 vehicle 3m
sh fit_features.bash 343.7 479.6 0.196 3.88 2.30 457 845.5 4 burglary 1w
sh fit_features.bash 567.0 514.3 0.814 3.60 5.51 952 270.2 2 vehicle 2w
sh fit_features.bash 422.3 502.0 0.599 2.76 11.48 549 526.8 7 all 2m
sh fit_features.bash 525.1 287.9 0.124 1.91 3.99 595 643.9 5 vehicle 2m
sh fit_features.bash 530.8 314.0 0.022 2.85 9.12 1109 420.3 2 all 2m
sh fit_features.bash 579.4 288.4 0.300 3.72 11.73 234 206.5 2 street 1w
sh fit_features.bash 380.8 468.1 0.666 0.47 6.39 304 374.3 8 all 1m
sh fit_features.bash 387.9 311.2 0.456 2.82 1.98 962 439.3 8 burglary 1w
sh fit_features.bash 547.5 386.6 0.355 2.90 10.52 279 299.2 4 all 1w
sh fit_features.bash 387.7 254.3 0.822 1.92 3.74 260 896.5 1 burglary 2m
sh fit_features.bash 557.7 531.5 0.035 2.38 4.36 263 652.1 4 burglary 1m
sh fit_features.bash 567.5 557.8 0.973 0.09 5.37 1063 407.7 1 burglary 1m
sh fit_features.bash 308.0 270.0 0.508 0.90 4.37 975 1177.4 3 all 1m
sh fit_features.bash 478.4 364.8 0.219 1.72 4.29 990 116.7 3 vehicle 1m
sh fit_features.bash 338.7 546.3 0.569 0.96 9.40 678 377.3 4 vehicle 3m
sh fit_features.bash 455.7 520.7 0.572 3.32 10.01 576 1069.7 3 street 1w
sh fit_features.bash 456.1 525.8 0.563 0.46 0.07 1108 119.2 4 all 1m
sh fit_features.bash 348.3 412.2 0.944 3.44 4.46 59 1012.2 5 street 2w
sh fit_features.bash 416.1 477.6 0.201 1.07 10.07 188 654.8 3 street 1m
sh fit_features.bash 551.7 478.4 0.872 0.98 7.54 1117 1031.3 2 street 3m
sh fit_features.bash 481.2 303.6 0.111 2.19 8.06 164 485.0 1 vehicle 1w
sh fit_features.bash 448.1 471.0 0.915 1.32 8.99 556 528.4 5 burglary 3m
sh fit_features.bash 309.3 567.5 0.750 3.76 6.38 518 151.6 6 burglary 3m
sh fit_features.bash 384.5 332.4 0.802 2.34 6.68 959 633.0 4 all 2w
sh fit_features.bash 321.6 310.8 0.897 0.22 11.95 261 1117.5 3 vehicle 2w
sh fit_features.bash 449.7 360.4 0.663 1.25 3.26 578 807.9 8 burglary 1w
sh fit_features.bash 319.9 304.5 0.709 1.35 4.68 309 1162.0 8 burglary 2m
sh fit_features.bash 398.8 403.6 0.674 2.98 5.15 269 832.1 8 vehicle 2m
sh fit_features.bash 495.8 474.7 0.870 3.01 10.12 1173 622.4 1 all 1m
sh fit_features.bash 280.8 263.2 0.302 1.53 10.84 1127 142.6 3 street 1m
sh fit_features.bash 464.4 534.5 0.677 2.99 8.61 693 598.2 1 burglary 1w
sh fit_features.bash 390.6 283.7 0.150 2.44 9.42 575 942.3 4 all 1w
sh fit_features.bash 275.6 357.1 0.607 2.39 9.52 618 190.1 5 all 2m
sh fit_features.bash 486.5 308.6 0.283 1.17 6.61 482 853.7 6 all 3m
sh fit_features.bash 327.0 569.9 0.105 0.68 8.80 601 672.6 3 all 2m
sh fit_features.bash 582.7 263.8 0.398 1.02 8.36 69 505.1 1 street 2m
sh fit_features.bash 564.3 297.1 0.351 3.25 3.38 960 924.7 7 burglary 2w
sh fit_features.bash 524.1 550.0 0.213 0.62 11.92 482 724.9 5 street 2m
sh fit_features.bash 538.2 306.2 0.978 1.16 1.44 430 875.2 6 all 1m
sh fit_features.bash 321.1 493.6 0.352 3.16 6.09 1039 995.5 7 street 2m
sh fit_features.bash 547.4 320.2 0.294 3.62 3.60 744 911.7 7 vehicle 3m
sh fit_features.bash 481.2 388.9 0.011 2.44 8.11 276 128.0 2 street 1w
sh fit_features.bash 457.4 322.2 0.069 2.28 10.52 399 1163.9 7 all 1w
sh fit_features.bash 461.9 542.8 0.862 3.70 6.60 138 790.8 1 vehicle 3m
sh fit_features.bash 484.8 326.8 0.065 0.99 8.72 416 439.6 1 street 1w
sh fit_features.bash 475.1 434.6 0.654 3.48 9.25 1003 269.1 5 vehicle 3m
sh fit_features.bash 442.7 309.2 0.195 0.69 7.53 1167 786.8 5 all 2w
sh fit_features.bash 489.8 318.0 0.473 2.28 7.39 1129 826.5 2 all 1m
sh fit_features.bash 481.7 411.7 0.727 2.67 3.81 1101 288.2 5 street 2w
sh fit_features.bash 253.6 356.9 0.314 1.40 3.84 1119 491.7 8 burglary 2w
sh fit_features.bash 419.5 504.9 0.197 1.25 3.53 926 692.0 8 street 2w
sh fit_features.bash 590.9 426.6 0.236 0.30 6.37 719 452.1 8 street 3m
sh fit_features.bash 292.7 292.1 0.148 0.49 9.67 551 387.6 5 burglary 1w
sh fit_features.bash 388.0 326.0 0.740 0.49 0.07 1156 569.0 8 vehicle 1w
sh fit_features.bash 501.7 268.0 0.013 2.75 3.35 722 769.8 1 burglary 1w
sh fit_features.bash 360.3 269.7 0.179 1.63 6.65 914 698.7 7 burglary 1m
sh fit_features.bash 300.0 454.1 0.613 0.84 8.62 1185 214.0 6 vehicle 2w
sh fit_features.bash 374.4 393.2 0.114 1.30 1.43 227 664.4 2 street 3m
sh fit_features.bash 587.5 451.7 0.227 1.58 10.10 364 329.4 5 all 1m
sh fit_features.bash 598.1 487.2 0.741 3.35 6.29 231 390.0 3 street 1w
sh fit_features.bash 485.3 285.7 0.664 0.17 3.87 194 142.0 1 burglary 1m
sh fit_features.bash 580.6 495.3 0.249 1.36 10.70 554 650.6 4 burglary 1w
sh fit_features.bash 463.2 405.7 0.125 1.51 5.69 285 899.7 7 street 1w
sh fit_features.bash 485.7 403.3 0.683 2.80 4.30 67 1039.3 5 street 2m
sh fit_features.bash 416.9 287.2 0.438 3.29 11.52 830 589.8 8 vehicle 3m
sh fit_features.bash 593.8 319.8 0.851 1.66 0.53 1156 921.4 2 vehicle 2m
