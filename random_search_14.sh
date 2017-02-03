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

sh fit_features.bash 357.2 454.3 0.212 1.32 6.00 222 440.6 6 all 2m
sh fit_features.bash 447.0 398.2 0.755 3.02 6.40 318 985.5 5 vehicle 1m
sh fit_features.bash 509.9 341.7 0.314 2.42 1.64 328 358.9 5 burglary 1m
sh fit_features.bash 445.6 578.0 0.404 3.88 3.67 427 388.5 4 all 3m
sh fit_features.bash 404.6 447.1 0.424 1.62 7.67 638 918.0 2 street 1w
sh fit_features.bash 440.0 304.9 0.433 0.37 9.40 562 766.3 5 burglary 3m
sh fit_features.bash 327.7 380.6 0.128 0.43 8.73 267 943.7 2 street 2w
sh fit_features.bash 378.6 522.8 0.054 2.53 8.07 765 1111.5 4 all 1w
sh fit_features.bash 596.1 514.7 0.522 3.11 8.03 811 445.5 1 street 3m
sh fit_features.bash 278.3 342.5 0.692 3.26 11.88 534 704.3 4 vehicle 1w
sh fit_features.bash 508.1 342.3 0.174 0.38 3.22 1139 584.8 2 burglary 1m
sh fit_features.bash 420.7 285.1 0.756 3.60 6.51 1139 1031.6 3 vehicle 2w
sh fit_features.bash 553.6 484.1 0.201 2.30 3.72 435 501.6 6 burglary 1m
sh fit_features.bash 574.3 334.8 0.024 0.63 3.34 1111 147.3 5 vehicle 2m
sh fit_features.bash 256.3 497.3 0.510 2.70 9.50 926 566.9 2 vehicle 1m
sh fit_features.bash 292.2 519.9 0.795 3.68 5.64 65 815.7 4 all 3m
sh fit_features.bash 286.5 458.8 0.554 2.37 4.37 497 100.7 1 burglary 2w
sh fit_features.bash 503.5 492.5 0.487 2.42 11.20 875 1053.1 5 vehicle 1m
sh fit_features.bash 423.9 417.5 0.973 1.18 1.63 606 1122.9 6 street 2w
sh fit_features.bash 520.8 588.3 0.159 2.14 5.37 631 869.8 2 burglary 2m
sh fit_features.bash 562.1 489.5 0.882 1.59 6.04 401 202.5 2 all 2w
sh fit_features.bash 278.6 428.9 0.576 0.47 7.61 886 652.1 1 street 2w
sh fit_features.bash 308.6 412.9 0.806 1.66 10.67 616 909.5 3 burglary 3m
sh fit_features.bash 510.3 501.1 0.320 0.14 3.25 404 773.4 4 vehicle 3m
sh fit_features.bash 475.1 257.7 0.659 2.09 9.45 381 710.9 5 vehicle 1w
sh fit_features.bash 421.1 369.9 0.075 0.02 1.60 174 449.3 5 all 1m
sh fit_features.bash 423.7 556.5 0.347 2.74 10.51 719 923.0 2 vehicle 1m
sh fit_features.bash 447.2 357.9 0.019 4.00 6.43 1152 748.0 6 burglary 1m
sh fit_features.bash 370.5 487.0 0.534 2.88 2.68 118 200.3 2 burglary 2m
sh fit_features.bash 340.5 264.1 0.749 1.37 8.67 272 986.8 1 street 1w
sh fit_features.bash 514.1 550.8 0.974 0.25 7.08 490 284.2 4 vehicle 1w
sh fit_features.bash 258.7 551.5 0.668 0.59 4.08 322 787.2 5 all 3m
sh fit_features.bash 580.1 424.8 0.033 3.49 1.19 336 403.7 3 burglary 1m
sh fit_features.bash 536.4 441.9 0.585 1.20 0.56 659 158.1 6 vehicle 2w
sh fit_features.bash 419.8 592.4 0.341 1.81 1.38 670 914.9 4 burglary 1w
sh fit_features.bash 264.9 301.0 0.192 3.75 0.24 943 1082.3 1 vehicle 1w
sh fit_features.bash 523.2 386.3 0.862 2.66 7.59 177 553.9 4 all 1w
sh fit_features.bash 595.8 458.7 0.464 0.14 7.39 176 1022.2 3 street 2w
sh fit_features.bash 343.2 315.4 0.380 2.81 9.16 251 1143.5 3 street 1w
sh fit_features.bash 585.0 445.5 0.532 3.48 10.85 964 430.9 6 vehicle 3m
sh fit_features.bash 517.9 389.4 0.498 0.22 5.21 171 542.4 3 burglary 1w
sh fit_features.bash 440.3 418.7 0.781 2.64 2.90 1060 851.6 2 street 3m
sh fit_features.bash 369.9 460.4 0.042 0.31 8.37 214 131.5 2 all 2m
sh fit_features.bash 355.4 549.0 0.249 3.35 1.04 297 1080.7 6 all 3m
sh fit_features.bash 382.0 352.6 0.338 0.00 5.66 641 816.9 2 vehicle 2m
sh fit_features.bash 298.8 347.8 0.325 3.71 0.14 152 375.1 6 all 1w
sh fit_features.bash 575.1 315.8 0.407 0.73 10.90 1000 619.4 5 vehicle 2m
sh fit_features.bash 303.5 387.6 0.303 3.64 2.26 818 1106.4 4 burglary 1w
sh fit_features.bash 408.3 357.6 0.625 0.84 6.94 328 456.5 5 burglary 2m
sh fit_features.bash 415.1 517.2 0.841 2.50 0.61 243 830.4 5 all 1m
sh fit_features.bash 460.3 385.6 0.268 3.24 4.39 436 823.5 6 burglary 2w
sh fit_features.bash 528.2 409.1 0.960 1.20 2.81 63 567.3 6 all 2m
sh fit_features.bash 371.1 271.7 0.652 3.63 6.17 732 662.1 4 burglary 2m
sh fit_features.bash 298.4 564.8 0.097 3.29 11.27 679 941.1 2 all 2w
sh fit_features.bash 569.3 285.4 0.308 3.48 10.24 982 970.4 3 burglary 1w
sh fit_features.bash 261.8 447.5 0.411 1.41 1.21 789 380.3 1 street 3m
sh fit_features.bash 365.3 555.1 0.606 2.93 10.64 453 375.2 4 vehicle 2w
sh fit_features.bash 362.5 494.5 0.074 1.68 6.87 198 800.4 5 all 3m
sh fit_features.bash 295.8 561.1 0.374 3.90 10.22 183 436.8 3 street 2w
sh fit_features.bash 482.1 463.2 0.795 0.89 0.88 1099 964.7 4 burglary 3m
sh fit_features.bash 561.8 571.5 0.551 2.07 6.90 1154 1107.7 5 vehicle 2m
sh fit_features.bash 253.7 570.2 0.588 0.76 9.74 889 231.6 1 burglary 3m
sh fit_features.bash 487.6 344.9 0.368 1.81 11.88 184 266.1 6 vehicle 2m
sh fit_features.bash 269.5 286.9 0.491 3.92 0.58 371 677.2 5 street 1w
sh fit_features.bash 581.3 431.9 0.573 1.05 11.44 829 1035.4 5 burglary 2w
sh fit_features.bash 379.1 269.3 0.501 0.51 6.28 786 1076.9 1 burglary 1w
sh fit_features.bash 395.1 254.3 0.417 2.67 4.54 760 945.2 4 all 1m
sh fit_features.bash 514.3 426.1 0.187 3.39 8.77 485 1097.0 5 street 2m
sh fit_features.bash 468.8 528.2 0.865 1.42 9.30 869 172.1 4 burglary 2m
sh fit_features.bash 389.8 559.1 0.972 2.79 10.12 510 651.3 6 all 1m
sh fit_features.bash 524.5 480.4 0.346 1.16 1.30 356 290.3 3 all 3m
sh fit_features.bash 487.6 452.9 0.969 3.62 5.27 406 931.5 1 burglary 1w
sh fit_features.bash 492.0 292.3 0.245 0.32 5.06 62 124.7 3 street 1m
sh fit_features.bash 405.9 589.4 0.464 3.52 2.42 944 1004.0 1 vehicle 1w
sh fit_features.bash 253.6 402.7 0.841 0.91 7.70 587 336.4 6 burglary 2w
sh fit_features.bash 392.4 330.9 0.650 1.05 4.75 271 259.2 5 burglary 1m
sh fit_features.bash 522.4 262.9 0.462 1.33 6.14 872 854.6 1 street 2m
sh fit_features.bash 339.2 529.4 0.119 1.68 3.19 1000 264.5 2 street 1m
sh fit_features.bash 504.5 353.6 0.160 2.27 10.80 1050 791.2 1 burglary 2m
sh fit_features.bash 448.4 292.9 0.463 0.05 0.51 457 258.9 6 street 3m
sh fit_features.bash 309.2 564.1 0.453 1.51 6.45 900 695.0 2 all 3m
sh fit_features.bash 534.1 436.2 0.287 2.42 3.59 1082 471.9 5 burglary 2w
sh fit_features.bash 579.4 329.7 0.033 1.10 3.33 710 1178.1 2 all 1w
sh fit_features.bash 341.2 320.5 0.895 3.81 1.39 204 285.4 5 burglary 2m
sh fit_features.bash 549.2 580.5 0.947 3.64 3.54 157 311.9 6 burglary 3m
sh fit_features.bash 572.8 326.6 0.325 2.00 8.03 191 832.9 4 burglary 2w
sh fit_features.bash 303.3 528.5 0.704 1.18 7.78 808 983.6 5 burglary 1w
sh fit_features.bash 273.4 355.6 0.015 2.95 1.91 1174 435.0 2 vehicle 1m
sh fit_features.bash 567.5 518.5 0.912 2.01 2.20 760 491.5 5 all 1w
sh fit_features.bash 468.6 555.4 0.407 0.66 8.25 1091 346.4 1 vehicle 3m
sh fit_features.bash 553.2 370.9 0.847 1.88 5.23 364 488.0 6 all 2w
sh fit_features.bash 379.1 464.9 0.594 2.53 2.59 757 926.8 6 vehicle 2w
sh fit_features.bash 543.9 281.8 0.043 0.19 7.82 1143 168.5 3 vehicle 3m
sh fit_features.bash 468.6 514.7 0.690 1.23 6.96 757 989.6 2 burglary 2w
sh fit_features.bash 476.2 593.4 0.384 1.66 8.39 1013 1053.0 6 vehicle 3m
sh fit_features.bash 335.5 291.6 0.368 1.96 3.06 734 247.8 3 street 1w
sh fit_features.bash 596.1 579.9 0.763 1.78 1.40 266 630.9 2 street 1w
sh fit_features.bash 279.8 336.9 0.930 0.30 7.09 582 792.0 6 burglary 2m
sh fit_features.bash 425.8 592.6 0.326 0.57 1.41 1104 1107.6 4 all 1w
sh fit_features.bash 381.0 354.8 0.081 3.26 8.04 180 901.5 3 street 2m
