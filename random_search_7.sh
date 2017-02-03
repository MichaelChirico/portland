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

sh fit_features.bash 501.1 299.8 0.913 3.94 5.38 944 203.3 1 vehicle 1m
sh fit_features.bash 410.2 343.4 0.657 3.59 8.46 1079 232.3 5 burglary 3m
sh fit_features.bash 417.6 519.5 0.477 2.57 9.46 948 490.7 6 vehicle 1m
sh fit_features.bash 566.7 375.1 0.751 3.38 5.30 536 313.3 4 street 2w
sh fit_features.bash 507.0 511.4 0.036 2.58 6.86 1085 845.9 5 all 1m
sh fit_features.bash 328.0 510.8 0.658 3.60 9.31 826 291.3 1 vehicle 1m
sh fit_features.bash 358.3 512.7 0.311 1.64 7.50 157 682.6 4 burglary 2w
sh fit_features.bash 392.6 571.8 0.969 1.45 6.71 885 472.8 6 all 2w
sh fit_features.bash 551.1 398.9 0.157 1.95 1.85 1137 1056.2 3 street 2m
sh fit_features.bash 487.5 312.1 0.495 1.02 8.14 262 449.9 1 street 3m
sh fit_features.bash 312.8 506.5 0.421 2.62 8.42 906 1033.9 4 vehicle 2w
sh fit_features.bash 331.6 505.0 0.010 3.24 9.71 241 979.5 4 street 2w
sh fit_features.bash 338.7 429.1 0.788 2.72 0.75 462 898.8 6 burglary 2m
sh fit_features.bash 557.4 452.4 0.671 2.09 1.40 999 436.8 6 all 2m
sh fit_features.bash 396.2 261.8 0.201 0.26 0.05 171 448.7 2 all 3m
sh fit_features.bash 335.3 458.5 0.661 0.88 5.60 319 640.3 4 burglary 2w
sh fit_features.bash 572.8 311.0 0.902 1.08 7.47 341 367.4 4 street 2m
sh fit_features.bash 575.8 391.5 0.136 0.14 4.96 1062 795.6 6 vehicle 1w
sh fit_features.bash 266.8 359.9 0.456 2.15 4.84 456 677.8 3 burglary 1m
sh fit_features.bash 454.7 419.8 0.252 2.06 0.63 335 1003.9 2 burglary 1w
sh fit_features.bash 356.7 426.2 0.529 2.72 0.96 185 220.0 6 vehicle 2m
sh fit_features.bash 265.7 270.1 0.682 1.96 0.03 422 823.6 2 vehicle 2w
sh fit_features.bash 386.9 476.5 0.822 2.38 11.96 549 400.0 6 vehicle 2m
sh fit_features.bash 491.5 286.4 0.797 3.50 2.52 976 967.2 1 street 1w
sh fit_features.bash 293.6 265.1 0.094 0.95 5.37 1164 985.0 5 street 1m
sh fit_features.bash 353.2 389.2 0.839 0.83 6.00 968 854.3 5 all 1m
sh fit_features.bash 528.0 397.2 0.076 2.88 1.82 225 338.8 1 street 3m
sh fit_features.bash 479.8 369.1 0.430 3.76 3.81 57 223.0 6 street 3m
sh fit_features.bash 386.6 584.6 0.104 3.03 5.53 337 999.4 3 all 2m
sh fit_features.bash 569.8 340.1 0.044 1.21 6.01 97 223.5 6 all 3m
sh fit_features.bash 461.8 391.9 0.713 3.36 5.04 580 456.1 3 burglary 3m
sh fit_features.bash 490.4 271.9 0.792 2.23 7.41 638 491.0 2 vehicle 1w
sh fit_features.bash 426.3 598.5 0.484 0.96 3.89 287 1002.0 3 vehicle 1m
sh fit_features.bash 533.1 299.0 0.722 1.61 10.28 548 253.3 3 street 1w
sh fit_features.bash 362.9 305.1 0.891 1.43 8.63 429 556.7 2 street 2m
sh fit_features.bash 553.5 342.0 0.828 2.60 3.06 114 751.1 5 all 2w
sh fit_features.bash 338.9 262.6 0.583 0.27 1.19 395 390.4 4 vehicle 2w
sh fit_features.bash 509.8 489.4 0.728 0.05 6.89 411 681.0 6 burglary 3m
sh fit_features.bash 421.3 318.4 0.012 3.58 9.09 866 1030.2 1 burglary 1m
sh fit_features.bash 508.9 482.3 0.101 2.08 11.78 503 319.3 2 burglary 3m
sh fit_features.bash 457.2 511.9 0.325 3.43 3.59 506 665.9 3 all 1m
sh fit_features.bash 384.1 543.5 0.112 1.44 9.03 675 926.0 4 vehicle 1w
sh fit_features.bash 333.1 392.6 0.705 3.86 0.47 122 977.9 2 vehicle 1m
sh fit_features.bash 279.3 518.8 0.132 1.77 9.08 128 127.9 5 vehicle 1w
sh fit_features.bash 266.3 443.6 0.883 3.31 2.36 264 737.2 5 street 2m
sh fit_features.bash 497.9 560.5 0.620 0.36 2.30 802 155.2 1 burglary 1w
sh fit_features.bash 348.4 523.8 0.078 0.58 6.48 374 492.4 1 vehicle 2m
sh fit_features.bash 360.7 300.8 0.987 0.50 0.81 605 303.9 4 street 2m
sh fit_features.bash 280.3 341.8 0.305 3.57 1.12 1001 643.0 3 all 1w
sh fit_features.bash 517.7 375.6 0.535 0.33 0.95 290 208.3 2 burglary 2w
sh fit_features.bash 435.8 504.3 0.370 2.47 3.25 732 177.4 4 all 2w
sh fit_features.bash 461.2 412.6 0.211 2.88 11.92 199 986.6 4 all 1w
sh fit_features.bash 369.9 411.3 0.537 2.12 11.15 516 959.6 1 burglary 1w
sh fit_features.bash 337.8 305.3 0.913 0.20 7.89 940 987.7 5 burglary 3m
sh fit_features.bash 587.4 352.5 0.976 1.46 0.40 1177 1028.2 2 burglary 1m
sh fit_features.bash 532.4 390.6 0.464 3.00 9.31 293 694.5 4 all 2w
sh fit_features.bash 313.2 501.2 0.529 0.60 7.12 347 1055.0 3 street 1m
sh fit_features.bash 434.5 283.2 0.240 0.60 1.50 239 878.4 1 vehicle 3m
sh fit_features.bash 390.3 579.2 0.148 3.43 6.37 350 154.8 6 vehicle 2w
sh fit_features.bash 339.2 472.6 0.894 3.57 7.03 651 776.0 2 all 3m
sh fit_features.bash 564.6 341.6 0.167 3.26 2.51 242 346.9 4 all 2m
sh fit_features.bash 272.7 340.6 0.883 2.07 1.38 433 192.1 5 all 2m
sh fit_features.bash 318.2 463.7 0.212 0.18 4.64 792 546.6 2 all 1m
sh fit_features.bash 266.0 329.3 0.498 2.57 2.92 889 125.0 6 all 1m
sh fit_features.bash 382.5 353.5 0.196 3.26 3.94 1103 625.7 1 vehicle 1w
sh fit_features.bash 417.2 331.5 0.708 1.96 7.32 648 697.6 5 vehicle 3m
sh fit_features.bash 534.1 318.3 0.545 1.89 1.59 1150 873.3 4 vehicle 1w
sh fit_features.bash 391.5 501.4 0.241 3.87 2.83 460 535.0 3 burglary 2w
sh fit_features.bash 372.8 416.6 0.525 1.96 5.91 942 594.5 5 burglary 2m
sh fit_features.bash 578.9 425.3 0.999 1.48 7.14 1092 1038.7 5 all 1m
sh fit_features.bash 326.9 595.7 0.713 3.41 5.95 423 180.2 6 vehicle 1w
sh fit_features.bash 545.7 583.8 0.576 3.58 0.87 990 875.5 5 burglary 2w
sh fit_features.bash 338.5 345.2 0.074 2.60 4.67 404 106.1 2 street 3m
sh fit_features.bash 390.1 264.9 0.165 1.34 5.29 931 725.3 6 vehicle 1w
sh fit_features.bash 488.4 513.3 0.947 1.32 8.64 659 1194.4 1 all 1w
sh fit_features.bash 270.9 588.6 0.358 0.37 7.61 676 811.3 1 street 1w
sh fit_features.bash 592.6 538.1 0.288 2.08 7.91 1114 864.2 4 vehicle 1w
sh fit_features.bash 437.3 284.9 0.833 2.62 8.96 258 944.5 1 all 2m
sh fit_features.bash 413.3 546.9 0.286 0.24 8.45 1017 1118.2 6 all 1w
sh fit_features.bash 590.4 552.6 0.690 2.56 2.74 987 1179.0 6 vehicle 1m
sh fit_features.bash 515.7 437.3 0.881 3.03 3.59 626 825.8 5 vehicle 1m
sh fit_features.bash 582.1 457.5 0.716 0.55 4.07 625 692.5 3 all 2m
sh fit_features.bash 577.3 394.4 0.549 0.90 6.44 790 118.2 1 all 1m
sh fit_features.bash 519.8 553.8 0.260 2.15 5.91 220 126.4 6 burglary 1w
sh fit_features.bash 357.9 437.2 0.315 3.26 4.43 1028 1004.4 1 all 1m
sh fit_features.bash 336.8 423.8 0.209 1.36 1.13 865 1013.2 5 burglary 2w
sh fit_features.bash 418.3 594.1 0.023 2.79 5.58 825 854.8 1 street 1m
sh fit_features.bash 573.4 322.4 0.454 3.08 5.66 942 625.7 6 burglary 1w
sh fit_features.bash 375.3 599.8 0.766 0.78 11.54 867 215.6 4 street 3m
sh fit_features.bash 255.1 555.3 0.658 2.84 8.75 323 574.4 4 street 2w
sh fit_features.bash 415.0 303.0 0.340 2.56 8.55 254 839.4 4 street 3m
sh fit_features.bash 495.8 430.7 0.159 2.14 7.49 903 600.4 2 street 2w
sh fit_features.bash 315.2 345.5 0.555 1.68 10.81 673 1025.6 3 all 1w
sh fit_features.bash 553.3 511.6 0.542 1.95 3.33 356 800.6 6 burglary 2m
sh fit_features.bash 289.6 527.3 0.754 3.75 3.58 923 198.3 6 vehicle 2w
sh fit_features.bash 387.9 264.7 0.442 2.70 7.03 590 514.1 4 burglary 2w
sh fit_features.bash 420.2 261.6 0.087 3.25 5.51 1186 730.6 6 vehicle 2w
sh fit_features.bash 321.0 257.5 0.297 0.98 10.37 620 474.1 6 vehicle 2m
sh fit_features.bash 585.1 407.8 0.977 1.94 3.91 106 1005.1 1 vehicle 2w
sh fit_features.bash 500.6 428.9 0.039 2.28 8.70 672 1034.7 3 vehicle 1m
