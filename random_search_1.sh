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

sh fit_features.bash 482.5 282.5 0.746 2.10 4.87 84 338.3 1 street 2w
sh fit_features.bash 296.7 263.8 0.623 1.10 4.40 1120 306.2 2 vehicle 2w
sh fit_features.bash 448.7 472.2 0.089 1.61 1.50 603 1076.2 3 burglary 1m
sh fit_features.bash 306.5 588.9 0.810 0.94 3.94 711 397.5 4 burglary 1w
sh fit_features.bash 251.9 420.8 0.326 3.57 8.81 348 512.8 6 all 2w
sh fit_features.bash 392.5 430.1 0.894 4.00 2.91 139 307.3 4 vehicle 1w
sh fit_features.bash 464.0 292.9 0.233 3.27 3.95 541 467.4 5 all 1w
sh fit_features.bash 311.6 281.5 0.065 2.79 6.26 182 446.6 1 street 2w
sh fit_features.bash 598.8 291.1 0.122 1.37 1.56 678 771.3 3 street 2w
sh fit_features.bash 506.9 290.8 0.689 1.92 8.12 308 651.9 1 burglary 1m
sh fit_features.bash 518.5 598.0 0.733 1.24 4.52 1020 391.4 4 street 2w
sh fit_features.bash 420.1 443.0 0.721 1.62 7.21 540 479.7 4 all 3m
sh fit_features.bash 358.2 492.1 0.252 2.66 2.45 725 705.2 4 vehicle 1m
sh fit_features.bash 528.9 549.0 0.031 2.10 4.65 136 773.2 2 street 3m
sh fit_features.bash 406.3 523.5 0.574 3.31 2.94 937 1156.3 6 burglary 1w
sh fit_features.bash 600.0 276.8 0.794 2.81 10.88 725 123.1 1 all 2m
sh fit_features.bash 567.6 250.9 0.529 2.01 1.12 235 666.6 6 burglary 2w
sh fit_features.bash 351.6 393.5 0.743 0.71 2.00 152 944.2 4 all 1m
sh fit_features.bash 349.8 525.0 0.393 1.17 8.58 500 822.3 6 burglary 1m
sh fit_features.bash 497.7 551.5 0.609 0.69 7.35 755 1159.3 5 all 2m
sh fit_features.bash 334.2 562.3 0.326 0.24 8.68 1113 720.5 1 street 1w
sh fit_features.bash 540.8 508.8 0.068 3.51 3.32 903 233.9 5 all 2m
sh fit_features.bash 293.3 584.9 0.788 0.29 8.36 322 726.1 4 burglary 2m
sh fit_features.bash 466.8 454.4 1.000 1.06 6.80 187 270.9 3 vehicle 3m
sh fit_features.bash 458.0 442.0 0.411 2.94 7.48 835 282.2 6 burglary 3m
sh fit_features.bash 547.2 318.0 0.011 0.30 0.39 325 529.1 1 street 2m
sh fit_features.bash 546.4 373.8 0.432 0.50 9.20 779 156.7 2 street 1w
sh fit_features.bash 338.3 372.1 0.883 2.09 1.90 1082 244.8 3 vehicle 2w
sh fit_features.bash 575.1 491.8 0.689 1.69 3.69 538 926.6 1 street 2w
sh fit_features.bash 420.7 565.2 0.399 3.78 11.15 216 1089.1 1 burglary 1w
sh fit_features.bash 535.3 555.4 0.260 2.57 2.26 1078 743.1 3 all 1m
sh fit_features.bash 432.6 592.8 0.186 1.90 2.45 530 978.8 1 burglary 2m
sh fit_features.bash 379.2 428.7 0.508 3.90 9.18 369 522.6 3 vehicle 2w
sh fit_features.bash 587.1 403.1 0.802 0.99 11.31 725 414.0 1 burglary 3m
sh fit_features.bash 467.9 318.6 0.759 2.73 9.39 974 894.2 4 vehicle 2w
sh fit_features.bash 264.2 250.5 0.675 1.06 5.69 613 428.5 4 street 1m
sh fit_features.bash 432.0 569.8 0.652 2.81 0.45 671 1050.7 3 burglary 2w
sh fit_features.bash 279.7 572.6 0.903 1.10 3.32 307 636.3 3 street 2m
sh fit_features.bash 567.3 356.5 0.488 3.28 9.73 831 608.8 4 street 1m
sh fit_features.bash 251.4 325.2 0.713 1.28 1.24 1173 270.5 6 vehicle 2w
sh fit_features.bash 535.8 539.8 0.945 2.76 8.50 342 472.8 3 vehicle 3m
sh fit_features.bash 584.3 375.7 0.831 3.17 6.99 735 1016.6 5 vehicle 1m
sh fit_features.bash 548.9 475.9 0.058 2.56 2.84 625 335.3 6 vehicle 2w
sh fit_features.bash 387.2 419.5 0.990 0.01 6.85 734 617.3 4 street 1m
sh fit_features.bash 513.7 488.5 0.703 1.77 8.60 131 1018.1 1 vehicle 1m
sh fit_features.bash 254.7 466.0 0.864 1.40 2.68 359 582.3 3 burglary 1w
sh fit_features.bash 302.8 384.8 0.320 1.42 1.66 1181 844.9 1 all 1w
sh fit_features.bash 399.2 464.5 0.035 1.96 6.56 114 854.7 1 vehicle 2w
sh fit_features.bash 513.6 426.3 0.164 1.28 5.08 967 890.6 2 burglary 3m
sh fit_features.bash 492.6 422.4 0.121 2.47 2.28 599 1130.6 4 street 2w
sh fit_features.bash 576.6 262.0 0.483 2.91 8.18 1005 360.0 1 all 1m
sh fit_features.bash 298.7 308.7 0.016 3.13 7.26 725 772.8 4 all 3m
sh fit_features.bash 253.9 527.9 0.546 4.00 9.32 927 166.0 4 street 2w
sh fit_features.bash 358.4 562.3 0.222 3.29 10.84 630 1167.5 3 vehicle 2m
sh fit_features.bash 562.7 461.2 0.543 1.94 1.66 54 915.8 2 all 2w
sh fit_features.bash 381.6 576.4 0.715 4.00 3.48 90 1137.2 5 all 1m
sh fit_features.bash 481.9 345.7 0.767 3.26 5.09 1108 298.3 3 vehicle 2m
sh fit_features.bash 295.9 379.6 0.761 0.72 3.46 577 945.0 1 burglary 3m
sh fit_features.bash 549.9 358.0 0.987 0.92 6.00 97 617.4 4 vehicle 1m
sh fit_features.bash 428.6 451.4 0.879 2.81 0.85 219 1122.9 5 vehicle 2w
sh fit_features.bash 557.1 292.2 0.495 0.61 7.44 877 906.5 3 vehicle 1w
sh fit_features.bash 470.3 369.5 0.987 2.18 1.91 817 869.6 5 burglary 3m
sh fit_features.bash 500.8 558.6 0.849 2.05 10.89 701 402.3 3 all 1m
sh fit_features.bash 264.2 355.4 0.249 3.68 9.81 254 635.7 3 street 2w
sh fit_features.bash 579.0 294.3 0.050 2.93 7.70 730 517.5 4 burglary 1m
sh fit_features.bash 351.3 426.3 0.342 1.05 11.68 928 531.3 6 vehicle 3m
sh fit_features.bash 306.7 466.1 0.417 3.72 9.12 402 345.2 4 vehicle 2w
sh fit_features.bash 369.2 554.1 0.358 1.20 1.91 556 604.0 4 street 2w
sh fit_features.bash 522.9 274.1 0.399 0.97 9.30 898 1001.8 3 vehicle 1m
sh fit_features.bash 446.6 355.1 0.190 0.27 2.89 1124 1072.9 6 burglary 2m
sh fit_features.bash 525.5 421.6 0.592 0.33 7.15 811 408.9 6 all 2m
sh fit_features.bash 279.7 419.0 0.972 0.94 0.50 858 304.3 4 street 1m
sh fit_features.bash 435.7 563.3 0.543 1.89 1.94 421 547.9 1 street 2m
sh fit_features.bash 306.9 591.2 0.802 0.42 1.47 393 198.5 2 burglary 1m
sh fit_features.bash 568.1 440.9 0.484 2.59 3.17 1149 516.1 4 all 2w
sh fit_features.bash 476.5 473.6 0.171 2.04 2.94 91 1027.0 2 street 2m
sh fit_features.bash 348.9 261.4 0.226 2.46 9.21 895 279.2 1 street 1w
sh fit_features.bash 277.0 598.6 0.203 0.58 1.83 166 429.9 5 burglary 2w
sh fit_features.bash 540.9 282.2 0.467 2.60 9.31 477 129.0 2 street 2m
sh fit_features.bash 362.7 448.1 0.554 0.24 2.47 676 496.8 2 burglary 2m
sh fit_features.bash 391.8 332.3 0.447 2.52 5.55 194 1001.6 2 all 3m
sh fit_features.bash 405.8 286.2 0.529 0.96 11.72 1059 1155.8 5 street 2m
sh fit_features.bash 455.9 386.8 0.365 1.01 7.59 74 808.9 3 burglary 3m
sh fit_features.bash 364.2 275.7 0.338 1.86 7.25 990 322.7 6 burglary 3m
sh fit_features.bash 583.0 565.9 0.358 3.25 7.77 788 134.8 5 street 1m
sh fit_features.bash 395.6 489.8 0.095 1.81 11.98 332 655.4 2 vehicle 1m
sh fit_features.bash 374.3 457.0 0.664 0.36 9.97 629 286.5 2 street 2w
sh fit_features.bash 276.3 498.2 0.693 2.76 11.68 363 1071.0 4 all 1m
sh fit_features.bash 439.6 268.5 0.764 1.34 5.06 1106 204.2 5 burglary 2w
sh fit_features.bash 387.2 461.9 0.410 1.53 7.12 723 154.1 6 all 2m
sh fit_features.bash 540.5 587.1 0.906 1.69 2.74 848 1064.6 2 vehicle 1w
sh fit_features.bash 472.4 574.0 0.094 2.11 7.69 204 465.8 3 street 2m
sh fit_features.bash 389.7 574.2 0.417 3.74 10.65 447 401.9 3 vehicle 3m
sh fit_features.bash 382.3 436.5 0.785 3.15 8.30 409 1132.5 4 street 2m
sh fit_features.bash 355.8 379.9 0.865 1.53 6.38 1164 195.6 6 vehicle 1m
sh fit_features.bash 445.2 459.6 0.031 2.14 9.07 596 579.7 3 vehicle 1m
sh fit_features.bash 330.8 390.8 0.473 1.98 9.42 469 338.4 1 all 3m
sh fit_features.bash 363.7 583.4 0.227 1.41 7.62 785 572.3 6 burglary 1w
sh fit_features.bash 599.6 362.0 0.480 0.01 4.01 52 456.8 5 all 1m
sh fit_features.bash 298.3 266.1 0.475 0.59 3.23 971 980.7 1 burglary 2m
