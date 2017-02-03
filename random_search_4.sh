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

sh fit_features.bash 260.4 471.9 0.973 3.02 4.88 951 959.4 7 vehicle 2w
sh fit_features.bash 566.9 270.1 0.206 0.24 7.63 129 509.9 8 all 1w
sh fit_features.bash 450.2 255.9 0.207 0.51 5.56 869 283.7 6 all 3m
sh fit_features.bash 293.4 295.1 0.520 0.74 3.83 252 516.6 5 street 2w
sh fit_features.bash 565.8 279.8 0.425 3.23 11.78 692 345.4 2 burglary 2w
sh fit_features.bash 273.4 434.5 0.941 0.79 9.34 528 1185.2 4 vehicle 3m
sh fit_features.bash 396.1 416.9 0.169 0.94 9.21 90 889.5 6 all 3m
sh fit_features.bash 254.6 471.1 0.165 1.52 11.50 1078 160.4 8 vehicle 2w
sh fit_features.bash 461.6 288.6 0.566 1.67 2.27 729 609.8 4 all 2w
sh fit_features.bash 544.5 424.1 0.653 1.92 9.80 84 1036.9 2 burglary 2m
sh fit_features.bash 588.0 296.8 0.479 1.44 4.42 563 610.7 5 all 1w
sh fit_features.bash 447.6 481.5 0.995 2.32 4.15 366 1179.2 8 all 3m
sh fit_features.bash 391.1 341.2 0.923 1.44 5.54 904 743.0 7 street 1m
sh fit_features.bash 595.4 390.3 0.852 3.50 3.35 916 853.7 7 street 1m
sh fit_features.bash 570.4 580.7 0.351 3.91 5.67 626 960.0 7 burglary 2w
sh fit_features.bash 266.0 468.7 0.534 2.43 11.42 1152 651.3 2 burglary 1m
sh fit_features.bash 282.3 485.0 0.240 2.62 9.36 896 594.4 6 street 2w
sh fit_features.bash 443.7 314.3 0.428 1.13 6.39 199 462.0 6 all 2w
sh fit_features.bash 521.7 594.8 0.449 1.22 10.63 414 1014.0 5 burglary 2m
sh fit_features.bash 359.7 262.0 0.461 1.39 4.96 323 895.6 7 burglary 1w
sh fit_features.bash 413.0 535.5 0.756 0.65 3.51 202 176.7 1 all 3m
sh fit_features.bash 257.3 340.8 0.127 3.65 2.75 324 921.3 6 street 2m
sh fit_features.bash 484.4 553.1 0.361 0.21 8.35 827 424.9 7 vehicle 2m
sh fit_features.bash 435.2 351.8 0.055 0.21 7.43 803 681.3 3 street 3m
sh fit_features.bash 489.1 274.8 0.100 1.96 3.38 830 643.4 2 street 2w
sh fit_features.bash 260.3 284.8 0.824 3.14 6.25 812 868.2 6 street 1w
sh fit_features.bash 478.0 570.5 0.870 2.24 2.40 1167 848.3 2 street 1m
sh fit_features.bash 551.9 583.9 0.825 2.15 1.72 194 136.0 2 street 2w
sh fit_features.bash 581.2 504.7 0.048 0.33 10.30 635 1093.0 5 street 3m
sh fit_features.bash 419.1 542.4 0.567 1.02 11.93 834 625.9 3 vehicle 2w
sh fit_features.bash 477.8 550.6 0.120 1.31 0.50 347 1041.9 1 vehicle 1w
sh fit_features.bash 550.2 346.7 0.026 2.93 11.87 1079 369.9 1 burglary 1m
sh fit_features.bash 589.2 437.6 0.655 2.02 7.44 1029 792.1 2 burglary 1w
sh fit_features.bash 276.2 424.0 0.799 3.24 7.69 305 310.1 6 burglary 2w
sh fit_features.bash 544.2 380.5 0.953 3.76 0.48 908 690.3 1 street 1w
sh fit_features.bash 394.6 491.2 0.260 3.02 3.08 710 1045.7 3 all 2m
sh fit_features.bash 599.9 420.0 0.891 1.55 11.09 755 724.1 8 burglary 2w
sh fit_features.bash 363.0 577.9 0.714 1.90 6.87 295 507.6 4 street 1w
sh fit_features.bash 515.5 538.8 0.435 2.78 6.14 56 1004.0 6 all 1w
sh fit_features.bash 504.6 272.7 0.365 3.02 5.00 291 1017.9 2 burglary 2m
sh fit_features.bash 559.5 503.8 0.759 2.00 2.75 986 1120.2 2 burglary 2m
sh fit_features.bash 509.6 277.5 0.066 1.53 3.88 1088 581.5 3 burglary 1w
sh fit_features.bash 367.1 567.5 0.412 1.88 3.61 569 574.8 6 vehicle 3m
sh fit_features.bash 533.3 360.7 0.968 3.06 9.66 144 776.8 8 burglary 2w
sh fit_features.bash 598.9 569.5 0.461 0.09 9.30 743 916.8 4 vehicle 2w
sh fit_features.bash 438.1 597.1 0.166 2.69 10.02 798 613.8 3 vehicle 1m
sh fit_features.bash 590.4 538.2 0.107 1.69 6.03 855 1199.5 4 street 1w
sh fit_features.bash 553.4 541.6 0.981 0.40 11.47 387 948.9 8 vehicle 2m
sh fit_features.bash 543.4 374.9 0.298 3.94 9.99 430 900.4 2 vehicle 3m
sh fit_features.bash 282.1 279.4 0.011 2.87 8.32 195 880.6 8 vehicle 2w
sh fit_features.bash 579.7 388.0 0.984 0.50 0.03 497 406.1 4 all 3m
sh fit_features.bash 296.8 553.8 0.898 3.62 9.60 342 901.4 6 all 3m
sh fit_features.bash 278.6 525.3 0.228 0.73 6.39 530 1168.3 3 street 2w
sh fit_features.bash 487.0 379.1 0.420 1.09 2.15 1005 1146.9 3 all 2w
sh fit_features.bash 333.6 389.2 0.766 1.30 4.22 1134 741.2 1 street 3m
sh fit_features.bash 436.7 491.2 0.397 1.85 9.19 727 652.2 1 vehicle 1w
sh fit_features.bash 486.6 283.6 0.730 2.45 5.72 577 398.6 4 burglary 3m
sh fit_features.bash 530.8 329.2 0.246 0.98 9.84 622 699.7 8 vehicle 2m
sh fit_features.bash 347.6 258.2 0.274 0.70 10.79 969 1130.9 2 vehicle 2w
sh fit_features.bash 365.7 419.5 0.832 0.68 7.36 525 608.8 4 all 3m
sh fit_features.bash 402.8 265.9 0.337 1.67 10.12 193 562.1 1 burglary 1m
sh fit_features.bash 358.3 454.8 0.998 2.68 1.45 123 960.9 6 street 2w
sh fit_features.bash 593.8 528.1 0.183 0.32 2.87 1120 414.4 7 street 1m
sh fit_features.bash 397.8 462.5 0.002 1.33 9.98 346 106.2 6 street 2w
sh fit_features.bash 576.5 548.0 0.687 3.27 4.06 1167 251.5 2 vehicle 1m
sh fit_features.bash 457.9 525.3 0.094 1.53 1.04 250 904.8 4 burglary 1m
sh fit_features.bash 396.6 430.4 0.774 1.77 9.57 191 746.8 7 burglary 1w
sh fit_features.bash 558.9 497.8 0.180 1.21 1.52 749 521.7 6 vehicle 2m
sh fit_features.bash 406.6 264.0 0.774 2.34 11.15 1002 144.4 1 street 1m
sh fit_features.bash 262.9 260.0 0.786 3.25 8.93 600 346.5 7 burglary 3m
sh fit_features.bash 286.6 583.8 0.073 0.87 1.69 928 560.9 1 all 1w
sh fit_features.bash 356.6 498.8 0.213 1.08 6.80 556 1140.8 6 burglary 1w
sh fit_features.bash 393.5 511.6 0.758 2.13 0.50 615 501.7 1 burglary 3m
sh fit_features.bash 558.8 530.5 0.481 1.87 9.24 794 1030.3 4 street 2m
sh fit_features.bash 404.4 459.9 0.135 3.03 1.07 483 1121.9 1 vehicle 1w
sh fit_features.bash 252.8 365.3 0.828 2.66 0.28 221 928.4 2 street 3m
sh fit_features.bash 266.2 279.2 0.099 2.75 1.10 1020 1126.7 6 all 2m
sh fit_features.bash 549.2 548.6 0.179 1.82 3.62 318 1114.7 7 burglary 2m
sh fit_features.bash 419.0 365.7 0.229 3.84 9.02 1082 997.0 5 street 2w
sh fit_features.bash 528.1 317.4 0.683 3.28 3.88 569 639.2 4 street 2w
sh fit_features.bash 481.8 331.2 0.462 0.14 11.75 719 944.7 3 burglary 3m
sh fit_features.bash 278.4 297.7 0.349 1.48 8.94 988 156.0 2 street 2w
sh fit_features.bash 580.5 317.6 0.053 1.34 10.59 959 623.4 1 all 1m
sh fit_features.bash 288.2 570.4 0.667 3.83 6.36 1196 988.9 6 street 3m
sh fit_features.bash 466.9 394.1 0.103 3.33 4.61 832 633.3 5 all 1w
sh fit_features.bash 534.6 495.8 0.879 1.55 2.75 1179 324.8 4 all 1w
sh fit_features.bash 431.6 450.3 0.545 0.63 4.09 862 146.2 7 street 3m
sh fit_features.bash 426.7 599.7 0.446 0.43 9.30 732 171.4 6 all 3m
sh fit_features.bash 537.6 381.7 0.900 2.74 1.03 370 761.6 7 vehicle 2w
sh fit_features.bash 302.4 473.2 0.375 1.38 1.77 783 254.0 7 street 1w
sh fit_features.bash 484.6 556.5 0.543 2.43 10.78 849 150.0 8 all 2w
sh fit_features.bash 589.9 440.3 0.883 0.35 4.41 160 388.5 4 burglary 1m
sh fit_features.bash 368.0 334.1 0.713 0.13 9.85 446 459.6 2 burglary 2m
sh fit_features.bash 454.0 348.1 0.273 3.49 9.17 92 963.5 1 street 2w
sh fit_features.bash 308.1 281.2 0.668 0.18 3.52 826 1157.8 5 street 1w
sh fit_features.bash 267.2 368.5 0.541 2.31 6.68 950 896.1 6 street 2m
sh fit_features.bash 587.0 401.2 0.090 1.95 5.06 437 657.6 6 street 1m
sh fit_features.bash 376.1 441.5 0.836 1.58 11.46 767 834.5 5 all 2m
sh fit_features.bash 292.2 504.8 0.300 1.75 4.43 94 529.7 1 all 3m
sh fit_features.bash 388.4 423.5 0.064 0.34 4.84 243 784.6 6 all 3m
