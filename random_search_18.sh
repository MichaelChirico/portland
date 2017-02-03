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

sh fit_features.bash 270.3 563.2 0.757 0.58 8.49 405 161.6 7 street 1w
sh fit_features.bash 434.1 355.5 0.479 0.29 1.07 274 595.0 5 street 1w
sh fit_features.bash 354.3 389.1 0.887 1.19 1.12 1129 244.8 6 all 1w
sh fit_features.bash 559.2 327.6 0.494 0.08 1.73 143 214.3 5 vehicle 1w
sh fit_features.bash 283.4 361.3 0.584 2.53 4.28 1097 1047.3 6 all 1m
sh fit_features.bash 300.7 351.2 0.143 1.96 2.82 189 413.3 5 burglary 2m
sh fit_features.bash 378.7 260.7 0.837 2.28 11.84 550 505.2 4 vehicle 1w
sh fit_features.bash 424.0 425.0 0.129 2.85 3.61 419 552.5 6 street 2w
sh fit_features.bash 515.1 268.2 0.334 0.94 9.21 131 816.0 4 street 1m
sh fit_features.bash 516.3 318.3 0.984 2.93 0.88 1200 299.6 4 street 2m
sh fit_features.bash 296.5 428.2 0.797 1.31 11.80 92 1014.9 4 all 2w
sh fit_features.bash 296.5 314.0 0.916 3.45 0.68 714 1019.8 3 vehicle 3m
sh fit_features.bash 526.6 510.9 0.643 1.84 2.88 410 110.5 6 all 3m
sh fit_features.bash 494.1 595.1 0.448 3.14 8.41 811 519.5 4 all 1m
sh fit_features.bash 580.3 526.5 0.725 1.76 2.17 855 351.2 1 burglary 1m
sh fit_features.bash 492.9 516.2 0.068 0.33 7.03 1085 1153.6 7 burglary 2m
sh fit_features.bash 258.8 344.6 0.809 3.41 7.98 667 704.4 6 all 1w
sh fit_features.bash 276.8 414.1 0.661 0.03 11.16 866 1152.5 2 street 2m
sh fit_features.bash 579.3 492.1 0.747 0.61 9.31 1045 731.8 3 street 3m
sh fit_features.bash 510.8 268.6 0.787 3.77 3.85 872 708.2 3 vehicle 1m
sh fit_features.bash 331.8 326.2 0.875 2.21 1.24 936 966.8 7 burglary 3m
sh fit_features.bash 492.1 498.7 0.106 1.40 9.91 1000 523.9 4 vehicle 1m
sh fit_features.bash 566.0 526.6 0.253 2.45 2.54 816 187.5 5 burglary 1w
sh fit_features.bash 567.3 542.1 0.228 1.96 4.65 144 918.4 3 street 1w
sh fit_features.bash 329.6 292.3 0.067 2.86 10.07 381 695.3 4 all 1w
sh fit_features.bash 507.8 401.1 0.440 3.06 7.24 899 731.1 5 all 3m
sh fit_features.bash 439.9 551.6 0.183 1.48 0.00 605 441.0 6 burglary 1w
sh fit_features.bash 552.1 532.7 0.500 1.28 5.34 52 822.0 3 street 1w
sh fit_features.bash 408.9 442.3 0.693 0.15 4.00 722 621.0 2 all 1m
sh fit_features.bash 507.6 318.8 0.320 3.49 3.42 814 1028.6 6 burglary 3m
sh fit_features.bash 291.2 543.4 0.037 0.01 7.80 1065 718.7 6 vehicle 3m
sh fit_features.bash 503.0 597.4 0.552 0.74 8.60 1167 286.7 4 street 2m
sh fit_features.bash 563.7 462.2 0.156 2.01 10.45 1056 583.9 5 burglary 1w
sh fit_features.bash 533.9 348.7 0.263 1.04 8.53 364 370.6 6 all 2w
sh fit_features.bash 546.1 566.5 0.503 1.33 9.57 180 1030.7 1 all 1w
sh fit_features.bash 363.4 401.6 0.484 3.98 4.02 1022 1026.8 2 burglary 1m
sh fit_features.bash 589.3 509.4 0.109 3.96 1.67 577 1041.7 4 all 3m
sh fit_features.bash 502.7 533.4 0.934 3.93 9.59 1183 209.6 8 all 1w
sh fit_features.bash 410.2 298.0 0.408 3.00 4.55 887 185.9 8 vehicle 3m
sh fit_features.bash 301.1 599.3 0.026 1.94 1.71 461 905.8 8 burglary 2m
sh fit_features.bash 587.8 582.4 0.447 1.47 9.67 250 1196.0 3 vehicle 3m
sh fit_features.bash 585.1 520.6 0.373 2.25 8.59 122 271.8 4 burglary 2w
sh fit_features.bash 389.8 422.2 0.671 3.16 6.58 752 196.1 7 street 3m
sh fit_features.bash 468.0 329.8 0.042 0.58 5.98 447 849.2 5 burglary 1m
sh fit_features.bash 417.4 301.3 0.069 1.75 8.75 1105 856.1 8 all 1w
sh fit_features.bash 326.8 594.1 0.928 0.37 5.26 772 279.7 3 burglary 1w
sh fit_features.bash 486.7 593.3 0.256 0.73 0.85 1156 134.0 3 all 2w
sh fit_features.bash 350.3 331.5 0.130 3.63 7.18 683 300.6 4 vehicle 2w
sh fit_features.bash 595.6 597.7 0.014 3.63 4.23 226 437.4 4 street 1w
sh fit_features.bash 266.2 597.7 0.674 2.92 8.98 524 528.0 6 burglary 3m
sh fit_features.bash 444.7 535.3 0.709 3.21 9.67 293 1162.6 6 burglary 2w
sh fit_features.bash 351.8 565.4 0.634 3.74 8.92 797 651.1 7 vehicle 3m
sh fit_features.bash 365.2 368.1 0.052 0.20 9.61 299 246.2 4 vehicle 2m
sh fit_features.bash 522.0 509.1 0.063 2.23 5.70 1139 1076.5 3 street 1m
sh fit_features.bash 282.6 391.8 0.835 2.20 11.65 329 746.5 5 all 3m
sh fit_features.bash 340.7 491.5 0.226 2.10 10.18 407 625.4 2 burglary 2w
sh fit_features.bash 588.3 395.6 0.237 3.68 3.36 647 353.0 5 burglary 1m
sh fit_features.bash 557.7 488.0 0.469 2.34 3.20 1178 402.8 4 all 1w
sh fit_features.bash 284.4 394.3 0.206 2.38 10.82 1099 786.0 3 all 2m
sh fit_features.bash 331.2 599.3 0.150 0.09 5.57 526 649.7 4 burglary 1m
sh fit_features.bash 520.9 409.9 0.178 1.06 1.57 57 925.9 7 burglary 2w
sh fit_features.bash 435.5 374.8 0.999 2.58 2.80 988 374.1 6 all 1m
sh fit_features.bash 266.4 574.1 0.999 1.34 11.29 63 284.5 1 burglary 2w
sh fit_features.bash 349.2 305.4 0.251 2.20 0.92 401 505.1 1 all 2w
sh fit_features.bash 421.0 265.3 0.154 2.02 3.55 1175 215.9 7 burglary 1m
sh fit_features.bash 462.3 527.9 0.637 2.23 10.84 1000 1052.2 7 burglary 2w
sh fit_features.bash 288.4 383.1 0.489 2.34 7.61 474 450.7 5 all 3m
sh fit_features.bash 439.7 293.0 0.385 1.49 10.25 434 104.7 7 burglary 1m
sh fit_features.bash 445.8 468.0 0.120 3.40 9.25 361 670.4 5 burglary 2m
sh fit_features.bash 332.2 430.3 0.357 3.73 6.55 300 569.7 7 all 1m
sh fit_features.bash 516.1 465.4 0.544 3.26 9.79 484 457.9 8 vehicle 3m
sh fit_features.bash 331.9 477.1 0.947 3.28 2.62 943 340.6 4 all 1w
sh fit_features.bash 518.2 351.8 0.678 2.68 1.23 870 434.6 5 vehicle 1m
sh fit_features.bash 311.4 387.2 0.647 3.34 9.25 1164 1149.1 6 vehicle 3m
sh fit_features.bash 422.3 326.0 0.039 0.83 8.78 997 182.7 6 all 1w
sh fit_features.bash 318.2 263.2 0.100 2.48 7.44 1105 868.8 6 all 2w
sh fit_features.bash 493.3 567.4 0.277 3.32 7.21 896 665.1 2 street 2w
sh fit_features.bash 571.7 273.5 0.117 0.48 9.26 788 945.9 2 vehicle 2m
sh fit_features.bash 267.8 511.9 0.487 3.98 8.38 572 160.1 3 all 2m
sh fit_features.bash 442.4 567.2 0.772 2.72 5.89 1150 756.7 4 vehicle 2w
sh fit_features.bash 471.3 450.2 0.829 1.96 7.73 616 354.0 8 vehicle 1m
sh fit_features.bash 362.9 513.1 0.731 2.46 3.66 1017 279.5 5 street 1m
sh fit_features.bash 266.0 452.8 0.859 3.50 3.19 1074 597.6 3 vehicle 2m
sh fit_features.bash 272.6 546.2 0.511 1.46 2.06 508 705.2 5 burglary 2m
sh fit_features.bash 565.0 416.8 0.166 1.96 0.23 827 1013.8 7 all 1w
sh fit_features.bash 526.6 309.4 0.189 0.75 2.40 78 414.0 1 street 1w
sh fit_features.bash 592.3 531.4 0.098 0.18 9.38 111 496.9 1 vehicle 2w
sh fit_features.bash 542.8 418.5 0.557 0.04 2.97 92 600.5 5 vehicle 2m
sh fit_features.bash 350.9 304.2 0.903 3.51 10.94 316 998.5 1 all 3m
sh fit_features.bash 560.6 457.5 0.634 1.20 5.56 1113 770.8 2 street 1w
sh fit_features.bash 329.9 408.6 0.390 3.05 11.76 1159 561.3 8 all 1w
sh fit_features.bash 452.8 254.6 0.111 0.42 4.03 967 338.7 1 street 1m
sh fit_features.bash 443.9 252.5 0.781 0.74 5.52 873 401.8 1 all 2m
sh fit_features.bash 302.8 443.2 0.983 1.74 6.53 749 452.8 3 vehicle 2w
sh fit_features.bash 297.8 329.8 0.643 0.21 2.43 1020 317.3 4 burglary 1w
sh fit_features.bash 470.9 586.3 0.019 3.64 0.21 695 321.9 4 vehicle 3m
sh fit_features.bash 254.7 400.5 0.836 1.96 7.51 464 437.3 1 vehicle 2w
sh fit_features.bash 278.3 522.7 0.508 3.79 6.44 921 517.2 1 street 2w
sh fit_features.bash 594.7 527.5 0.225 2.58 10.71 726 688.0 1 all 2w
sh fit_features.bash 454.7 535.4 0.861 2.89 8.42 1101 251.0 6 vehicle 1w
