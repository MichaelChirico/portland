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

sh fit_features.bash 593.0 301.1 0.506 2.17 0.03 938 426.7 1 all 1m
sh fit_features.bash 549.0 262.5 0.312 3.38 7.68 1154 138.9 4 vehicle 2w
sh fit_features.bash 569.9 347.6 0.426 1.15 0.13 131 1129.0 7 burglary 2w
sh fit_features.bash 559.5 321.4 0.368 0.70 7.71 968 736.9 8 street 3m
sh fit_features.bash 321.0 559.0 0.154 3.73 11.00 1031 1051.1 4 burglary 1m
sh fit_features.bash 584.5 310.7 0.316 2.14 7.30 190 566.4 8 street 2m
sh fit_features.bash 364.6 459.0 0.249 1.97 5.55 384 1185.8 8 vehicle 3m
sh fit_features.bash 571.4 323.9 0.510 0.07 8.32 1187 422.6 2 street 2w
sh fit_features.bash 412.9 475.8 0.610 2.18 1.79 481 1172.0 3 vehicle 2m
sh fit_features.bash 435.6 352.2 0.648 1.21 9.58 98 126.9 5 street 1m
sh fit_features.bash 257.6 400.8 0.448 0.98 4.29 960 378.0 8 burglary 2m
sh fit_features.bash 279.0 451.0 0.013 2.06 3.45 935 153.7 8 vehicle 2m
sh fit_features.bash 515.2 573.9 0.933 2.68 6.40 590 1034.7 4 all 1m
sh fit_features.bash 287.9 442.0 0.081 3.94 2.46 507 1080.0 2 vehicle 1m
sh fit_features.bash 369.4 370.3 0.573 1.57 9.57 200 592.6 1 vehicle 1m
sh fit_features.bash 362.4 388.8 0.263 2.27 5.99 1026 635.9 7 vehicle 2m
sh fit_features.bash 321.0 414.3 0.920 3.18 2.74 618 540.0 6 all 2m
sh fit_features.bash 511.8 427.4 0.134 1.81 3.47 368 1120.4 7 vehicle 3m
sh fit_features.bash 456.2 463.1 0.615 1.99 2.44 858 305.7 4 burglary 2m
sh fit_features.bash 290.4 305.0 0.773 1.41 5.68 135 307.9 7 street 2w
sh fit_features.bash 411.6 522.2 0.689 0.21 7.00 321 667.5 2 street 3m
sh fit_features.bash 253.0 256.6 0.455 1.31 6.87 1163 900.7 7 all 1m
sh fit_features.bash 557.0 341.9 0.058 2.75 9.00 648 1166.8 7 burglary 2m
sh fit_features.bash 339.9 553.3 0.858 1.16 11.78 271 371.3 8 burglary 2w
sh fit_features.bash 304.9 438.1 0.304 0.50 0.24 721 204.1 5 burglary 2m
sh fit_features.bash 553.1 577.4 0.147 1.40 11.71 981 461.6 5 burglary 3m
sh fit_features.bash 506.6 494.5 0.607 2.20 11.92 965 505.0 4 burglary 1m
sh fit_features.bash 293.2 537.7 0.596 1.19 8.78 648 700.8 2 street 2w
sh fit_features.bash 556.0 595.9 0.580 0.35 8.15 153 917.5 4 all 1w
sh fit_features.bash 292.7 305.7 0.029 2.75 5.86 394 628.3 8 all 3m
sh fit_features.bash 486.7 337.6 0.236 1.62 4.16 863 551.2 5 vehicle 3m
sh fit_features.bash 546.3 531.0 0.322 1.02 10.45 280 1170.2 8 vehicle 2m
sh fit_features.bash 528.7 565.3 0.039 0.13 6.66 193 690.4 1 burglary 3m
sh fit_features.bash 345.2 398.9 0.252 0.42 4.85 1064 959.5 3 vehicle 2m
sh fit_features.bash 438.7 269.5 0.717 3.36 11.24 713 132.3 2 burglary 1m
sh fit_features.bash 315.8 483.1 0.116 0.62 5.96 236 1106.4 7 vehicle 3m
sh fit_features.bash 577.9 562.2 0.630 2.39 2.01 602 108.5 4 street 3m
sh fit_features.bash 492.3 397.4 0.810 2.09 9.38 72 1162.5 2 vehicle 1w
sh fit_features.bash 483.0 436.5 0.893 1.97 0.48 560 442.9 2 street 1m
sh fit_features.bash 275.1 291.6 0.059 0.79 0.15 66 435.3 2 burglary 2m
sh fit_features.bash 365.2 356.0 0.667 2.47 0.97 945 750.8 8 all 3m
sh fit_features.bash 560.3 344.8 0.709 1.61 4.55 598 1030.8 5 vehicle 3m
sh fit_features.bash 491.2 299.1 0.601 0.42 3.14 141 803.7 2 vehicle 1m
sh fit_features.bash 589.1 568.0 0.634 2.77 1.36 606 345.3 7 street 2m
sh fit_features.bash 332.4 401.2 0.786 1.82 0.22 275 518.7 2 street 2w
sh fit_features.bash 495.7 566.3 0.612 3.69 3.98 936 713.7 7 street 2w
sh fit_features.bash 278.4 453.1 0.493 0.35 9.52 1171 788.4 3 burglary 1w
sh fit_features.bash 477.7 419.9 0.642 3.21 0.74 398 1186.5 1 street 1m
sh fit_features.bash 305.6 465.6 0.573 1.97 3.01 922 845.9 2 street 1m
sh fit_features.bash 592.0 474.4 0.828 1.10 10.04 1029 542.6 2 all 3m
sh fit_features.bash 440.9 509.6 0.282 1.79 1.75 422 601.0 8 burglary 1m
sh fit_features.bash 449.1 487.8 0.147 0.30 3.53 289 889.6 3 burglary 2w
sh fit_features.bash 584.2 453.0 0.759 1.93 11.33 887 823.7 6 burglary 2w
sh fit_features.bash 375.1 253.7 0.048 2.37 6.21 131 446.8 5 street 2w
sh fit_features.bash 253.7 363.8 0.768 0.98 3.93 720 539.8 5 all 2w
sh fit_features.bash 381.2 588.6 0.231 1.77 11.93 824 966.6 5 street 1m
sh fit_features.bash 356.3 417.6 0.339 2.89 1.26 353 1170.5 8 street 2w
sh fit_features.bash 420.7 476.1 0.238 2.56 6.48 1192 937.3 8 vehicle 1m
sh fit_features.bash 272.2 544.2 0.791 1.64 8.17 693 142.3 2 street 2m
sh fit_features.bash 563.3 449.2 0.380 2.48 2.51 330 334.1 4 vehicle 1w
sh fit_features.bash 571.6 493.0 0.166 1.94 9.10 1058 892.4 5 burglary 1m
sh fit_features.bash 412.1 564.5 0.718 0.70 7.01 118 1073.5 4 all 2w
sh fit_features.bash 327.2 439.4 0.597 1.31 11.56 719 937.8 8 burglary 2w
sh fit_features.bash 338.9 377.3 0.956 0.11 11.54 709 507.0 2 street 2m
sh fit_features.bash 556.1 589.6 0.530 0.97 10.17 1175 764.3 3 street 3m
sh fit_features.bash 252.2 516.6 0.037 2.16 10.24 273 273.0 3 vehicle 2m
sh fit_features.bash 559.0 448.9 0.548 2.05 2.39 1151 770.9 3 burglary 2w
sh fit_features.bash 413.6 421.1 0.550 2.79 11.69 969 521.6 7 street 2w
sh fit_features.bash 335.1 535.8 0.573 2.49 10.56 327 517.5 8 all 2m
sh fit_features.bash 404.9 348.6 0.495 2.40 5.07 1023 1143.7 2 street 2w
sh fit_features.bash 495.7 477.1 0.998 2.33 3.99 699 496.3 5 street 1w
sh fit_features.bash 513.4 406.2 0.475 0.61 11.15 349 945.7 5 all 2m
sh fit_features.bash 314.3 357.7 0.539 0.54 7.89 1100 254.8 1 street 1w
sh fit_features.bash 598.3 497.2 0.451 2.56 11.46 485 230.2 6 vehicle 1w
sh fit_features.bash 452.1 329.4 0.146 3.06 5.39 709 715.6 3 all 3m
sh fit_features.bash 563.8 272.4 0.779 1.63 6.25 887 111.9 6 vehicle 2m
sh fit_features.bash 313.4 401.1 0.557 2.19 2.51 1128 405.4 1 burglary 1m
sh fit_features.bash 309.1 263.0 0.782 2.63 7.11 853 148.3 3 burglary 1m
sh fit_features.bash 258.7 564.8 0.104 3.06 6.91 132 1049.5 3 street 1w
sh fit_features.bash 478.5 510.3 0.054 3.28 4.11 647 426.9 3 street 1m
sh fit_features.bash 469.5 374.4 0.456 0.05 7.66 217 561.7 6 street 3m
sh fit_features.bash 342.1 579.1 0.555 0.51 9.62 267 190.4 5 vehicle 2m
sh fit_features.bash 471.7 394.7 0.770 0.54 11.87 801 236.2 4 vehicle 2w
sh fit_features.bash 523.5 360.1 0.980 0.64 4.03 564 885.2 2 vehicle 2m
sh fit_features.bash 421.6 343.6 0.694 1.23 0.23 240 847.8 2 vehicle 2m
sh fit_features.bash 372.5 349.8 0.731 0.65 4.60 1151 587.7 3 burglary 3m
sh fit_features.bash 334.7 435.0 0.044 0.83 0.19 969 611.7 2 street 3m
sh fit_features.bash 278.6 562.7 0.723 0.51 2.47 112 838.1 3 all 3m
sh fit_features.bash 469.2 548.4 0.215 2.94 10.00 798 484.8 1 street 3m
sh fit_features.bash 425.1 274.0 0.134 1.02 2.34 309 126.2 5 burglary 3m
sh fit_features.bash 389.8 385.8 0.958 2.00 6.08 476 808.8 8 vehicle 2w
sh fit_features.bash 494.6 516.9 0.105 1.70 2.60 315 945.1 3 vehicle 2w
sh fit_features.bash 254.9 565.2 0.773 0.43 1.34 1119 475.4 8 vehicle 2w
sh fit_features.bash 380.1 594.9 0.871 0.47 10.43 478 1065.7 6 all 1m
sh fit_features.bash 330.8 560.7 0.670 2.62 4.73 777 1190.3 2 street 1m
sh fit_features.bash 477.4 482.6 0.397 2.26 11.47 949 1174.5 2 street 2w
sh fit_features.bash 458.1 377.8 0.822 1.41 3.46 394 744.3 7 vehicle 2w
sh fit_features.bash 302.4 273.1 0.798 0.71 8.71 307 434.3 1 burglary 1w
sh fit_features.bash 463.1 269.2 0.486 0.85 4.34 376 808.8 4 burglary 2m
sh fit_features.bash 504.4 285.3 0.675 3.47 7.12 1199 791.9 7 burglary 1m
