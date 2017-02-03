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

sh fit_features.bash 262.8 289.8 0.928 3.45 11.50 761 753.5 4 burglary 1m
sh fit_features.bash 574.6 319.7 0.338 3.03 11.06 1196 515.0 2 vehicle 1w
sh fit_features.bash 414.5 538.0 0.601 0.27 11.58 87 635.8 3 all 1w
sh fit_features.bash 457.5 315.1 0.184 2.10 0.67 429 911.0 4 street 2m
sh fit_features.bash 295.9 374.4 0.792 2.11 8.35 1176 779.9 2 vehicle 1m
sh fit_features.bash 507.3 424.5 0.569 2.15 9.58 981 191.0 3 burglary 1m
sh fit_features.bash 560.1 275.2 0.606 0.61 8.56 320 942.5 2 vehicle 1m
sh fit_features.bash 387.2 279.8 0.993 1.57 6.63 448 538.1 6 burglary 1m
sh fit_features.bash 376.2 398.5 0.557 3.32 1.98 685 384.9 3 burglary 3m
sh fit_features.bash 581.8 290.9 0.095 0.69 7.93 871 762.3 1 vehicle 2m
sh fit_features.bash 275.7 335.5 0.987 0.50 2.18 740 893.2 5 burglary 1m
sh fit_features.bash 324.3 488.7 0.081 0.60 8.51 723 214.1 6 street 1m
sh fit_features.bash 275.8 288.2 0.846 2.48 3.65 880 844.6 6 burglary 3m
sh fit_features.bash 278.9 369.4 0.302 1.32 7.03 1049 284.8 6 burglary 1w
sh fit_features.bash 488.0 444.1 0.933 1.15 8.93 975 692.5 5 burglary 1m
sh fit_features.bash 355.6 434.7 0.340 2.40 4.34 878 272.1 3 street 1m
sh fit_features.bash 513.6 378.2 0.678 3.23 3.16 794 126.6 6 vehicle 3m
sh fit_features.bash 482.3 314.3 0.998 3.36 3.18 942 580.4 6 street 2w
sh fit_features.bash 420.9 408.5 0.154 3.79 1.40 1128 388.0 1 all 1m
sh fit_features.bash 568.3 284.5 0.819 1.19 11.24 437 153.4 1 burglary 1m
sh fit_features.bash 536.8 431.3 0.770 1.75 7.13 815 220.7 6 vehicle 1m
sh fit_features.bash 381.4 298.2 0.639 1.08 9.77 818 1057.6 1 burglary 2m
sh fit_features.bash 413.8 456.1 0.289 0.90 9.94 218 867.5 3 street 3m
sh fit_features.bash 503.2 431.8 0.852 0.32 10.19 417 396.1 5 street 3m
sh fit_features.bash 406.4 576.0 0.067 3.68 9.40 495 793.4 1 vehicle 1w
sh fit_features.bash 376.0 467.6 0.549 2.25 9.84 886 344.1 5 vehicle 2w
sh fit_features.bash 552.6 465.0 0.405 2.73 3.46 936 1148.2 2 burglary 2m
sh fit_features.bash 494.6 364.1 0.668 0.85 3.33 1188 147.2 3 all 1w
sh fit_features.bash 291.0 519.8 0.043 2.99 9.44 1028 192.8 2 vehicle 1m
sh fit_features.bash 367.5 520.7 0.003 0.30 6.88 832 990.3 6 all 2m
sh fit_features.bash 509.2 346.4 0.132 2.37 1.95 972 1180.0 3 burglary 1w
sh fit_features.bash 274.2 589.2 0.927 2.82 9.88 762 1037.0 2 street 2m
sh fit_features.bash 473.2 282.0 0.341 2.96 1.81 969 1177.9 3 street 3m
sh fit_features.bash 498.2 591.5 0.011 0.16 10.30 116 530.7 5 street 2m
sh fit_features.bash 371.5 258.7 0.448 3.80 8.49 952 1119.7 4 all 2m
sh fit_features.bash 347.5 359.7 0.695 2.28 0.23 764 883.7 3 burglary 1m
sh fit_features.bash 547.3 366.4 0.587 1.08 7.83 802 188.9 6 vehicle 3m
sh fit_features.bash 400.1 494.5 0.419 1.77 5.05 1122 934.0 6 vehicle 2w
sh fit_features.bash 400.5 376.5 0.829 3.87 1.72 1109 704.0 4 all 1w
sh fit_features.bash 585.3 307.9 0.183 0.88 3.19 444 960.0 2 burglary 2w
sh fit_features.bash 320.0 557.3 0.006 0.94 10.52 326 134.4 4 burglary 2w
sh fit_features.bash 301.2 264.0 0.265 1.14 8.52 497 639.4 6 all 1m
sh fit_features.bash 263.2 407.1 0.052 1.58 1.24 1154 725.6 2 vehicle 1m
sh fit_features.bash 524.9 299.4 0.230 0.66 10.80 110 914.1 6 all 2w
sh fit_features.bash 454.7 368.1 0.569 0.16 1.49 515 1180.0 3 burglary 2m
sh fit_features.bash 562.1 268.3 0.260 1.90 5.00 554 958.0 4 all 1w
sh fit_features.bash 536.1 414.0 0.902 3.73 2.61 329 756.0 3 burglary 2w
sh fit_features.bash 449.0 343.3 0.554 0.48 6.88 961 684.0 3 all 2m
sh fit_features.bash 348.0 503.0 0.150 1.22 5.89 255 744.0 1 all 2w
sh fit_features.bash 432.4 520.4 0.276 0.90 11.82 588 798.6 3 street 1w
sh fit_features.bash 387.1 253.0 0.995 3.65 9.00 972 876.6 5 burglary 1w
sh fit_features.bash 373.7 535.0 0.780 2.59 3.27 648 305.8 1 vehicle 1m
sh fit_features.bash 392.9 335.6 0.930 2.13 0.69 1036 470.4 1 vehicle 2m
sh fit_features.bash 377.1 317.7 0.851 3.47 3.04 1162 787.8 4 vehicle 2w
sh fit_features.bash 269.8 451.1 0.989 2.81 2.42 295 364.4 4 burglary 2m
sh fit_features.bash 362.9 440.4 0.716 0.37 0.83 666 647.3 3 all 1w
sh fit_features.bash 416.0 525.0 0.516 0.33 0.61 785 338.9 4 burglary 1w
sh fit_features.bash 449.0 523.4 0.050 3.91 7.81 122 1132.1 6 vehicle 2w
sh fit_features.bash 412.6 522.3 1.000 1.48 6.13 594 1144.8 5 street 3m
sh fit_features.bash 553.6 580.2 0.871 3.98 8.57 604 1145.4 4 vehicle 2w
sh fit_features.bash 539.1 405.3 0.561 3.04 2.05 206 347.7 3 all 2w
sh fit_features.bash 395.5 423.4 0.739 0.13 1.62 1194 330.8 5 all 2w
sh fit_features.bash 434.7 422.7 0.695 3.01 0.91 639 185.1 2 all 3m
sh fit_features.bash 565.2 322.1 0.437 2.77 8.91 935 529.5 6 street 3m
sh fit_features.bash 385.7 361.9 0.348 3.58 6.33 915 274.0 6 vehicle 1w
sh fit_features.bash 599.1 534.6 0.343 2.07 2.64 231 390.0 6 all 3m
sh fit_features.bash 527.9 547.9 0.682 1.40 3.14 1181 863.1 5 vehicle 2w
sh fit_features.bash 349.7 268.2 0.681 1.56 11.93 621 335.2 5 burglary 1m
sh fit_features.bash 526.4 461.6 0.849 0.53 2.99 1032 974.9 5 all 2m
sh fit_features.bash 325.0 254.5 0.317 1.22 2.60 118 234.3 1 all 3m
sh fit_features.bash 515.1 325.8 0.963 2.26 8.16 180 515.0 6 vehicle 3m
sh fit_features.bash 458.3 572.5 0.720 3.20 4.78 957 951.4 2 burglary 1m
sh fit_features.bash 432.2 286.1 0.633 2.47 5.53 224 120.9 2 burglary 3m
sh fit_features.bash 317.8 501.6 0.505 1.72 5.63 543 584.7 2 burglary 2m
sh fit_features.bash 557.0 498.4 0.280 1.77 10.15 126 118.8 6 street 2w
sh fit_features.bash 316.9 581.7 0.708 1.96 10.33 786 114.9 5 vehicle 1m
sh fit_features.bash 332.9 296.3 0.675 0.78 4.54 867 932.5 5 vehicle 2m
sh fit_features.bash 537.6 532.8 0.460 2.92 10.35 95 1113.8 5 all 2m
sh fit_features.bash 279.8 413.3 0.344 2.90 11.18 482 346.6 3 vehicle 1w
sh fit_features.bash 483.0 375.5 0.808 1.68 11.72 976 1125.6 3 burglary 2m
sh fit_features.bash 480.0 410.1 0.282 2.57 8.27 588 187.2 1 street 3m
sh fit_features.bash 334.3 551.6 0.032 1.25 8.16 125 1092.9 5 street 2m
sh fit_features.bash 559.7 541.1 0.630 3.15 2.29 686 633.5 4 burglary 1w
sh fit_features.bash 363.2 484.5 0.773 3.76 5.50 1121 952.6 2 burglary 2w
sh fit_features.bash 464.2 486.1 0.939 1.69 4.44 659 776.9 1 vehicle 2w
sh fit_features.bash 462.3 468.6 0.436 0.34 0.05 236 551.7 1 vehicle 2w
sh fit_features.bash 582.6 409.0 0.844 2.70 5.11 82 1062.8 1 vehicle 2w
sh fit_features.bash 325.2 516.8 0.119 0.16 8.58 82 450.5 6 vehicle 3m
sh fit_features.bash 454.4 295.1 0.103 2.86 2.34 590 1164.2 5 street 2w
sh fit_features.bash 594.8 251.6 0.873 0.81 7.55 75 524.5 3 burglary 2w
sh fit_features.bash 297.6 546.1 0.959 1.20 7.16 964 332.8 1 street 2m
sh fit_features.bash 493.4 261.5 0.682 1.96 1.83 876 722.7 6 burglary 2w
sh fit_features.bash 445.0 288.9 0.603 0.10 1.85 162 749.8 6 street 1w
sh fit_features.bash 531.3 356.2 0.807 1.00 11.19 620 1004.4 6 all 3m
sh fit_features.bash 562.5 372.0 0.629 2.19 11.14 1124 464.0 6 all 2w
sh fit_features.bash 481.3 437.1 0.425 2.99 4.26 104 409.6 1 vehicle 2w
sh fit_features.bash 481.4 302.1 0.414 2.99 2.17 980 131.4 4 all 3m
sh fit_features.bash 569.9 255.4 0.986 0.21 7.87 80 539.4 5 vehicle 2w
sh fit_features.bash 338.4 345.6 0.376 0.21 7.67 74 948.2 6 all 3m
sh fit_features.bash 474.9 416.7 0.335 3.72 10.30 1179 1042.7 1 street 1m
