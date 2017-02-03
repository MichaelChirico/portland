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

sh fit_features.bash 446.2 529.4 0.661 1.38 5.69 487 918.6 5 all 1w
sh fit_features.bash 525.9 446.4 0.079 3.21 7.55 741 399.6 6 vehicle 1m
sh fit_features.bash 378.9 482.7 0.067 3.71 0.35 210 775.1 6 burglary 3m
sh fit_features.bash 511.9 568.8 0.150 0.52 3.02 606 985.7 3 all 3m
sh fit_features.bash 567.4 592.1 0.104 0.90 11.56 416 811.3 6 burglary 1w
sh fit_features.bash 401.7 390.8 0.634 1.61 4.51 735 725.0 5 burglary 2w
sh fit_features.bash 387.8 281.3 0.205 3.39 9.02 630 772.7 6 vehicle 1m
sh fit_features.bash 314.1 357.0 0.534 2.81 2.08 679 1155.2 2 burglary 1m
sh fit_features.bash 276.7 509.7 0.335 0.94 9.87 159 938.5 4 street 2m
sh fit_features.bash 421.6 314.7 0.545 1.57 9.85 129 221.1 6 street 1w
sh fit_features.bash 359.3 537.6 0.973 1.50 7.62 69 358.3 4 burglary 3m
sh fit_features.bash 386.6 420.6 0.864 3.80 10.08 321 515.4 1 street 2w
sh fit_features.bash 450.0 285.6 0.003 1.55 8.18 720 1029.6 4 burglary 2w
sh fit_features.bash 548.6 522.0 0.208 2.69 4.32 1179 620.0 5 burglary 2m
sh fit_features.bash 531.0 390.9 0.178 2.00 3.25 1064 1199.8 2 burglary 2m
sh fit_features.bash 570.6 403.0 0.252 0.81 2.23 295 331.6 2 all 3m
sh fit_features.bash 373.0 436.2 0.014 2.74 1.94 925 1135.6 6 vehicle 3m
sh fit_features.bash 370.5 313.8 0.032 0.20 7.89 452 1035.5 4 burglary 3m
sh fit_features.bash 322.1 377.6 0.012 3.43 11.98 611 1070.8 6 street 3m
sh fit_features.bash 468.2 392.0 0.237 0.82 6.93 849 1079.2 1 vehicle 2m
sh fit_features.bash 394.2 488.8 0.154 3.54 1.73 665 509.2 3 all 1w
sh fit_features.bash 299.3 466.7 0.823 3.45 5.83 461 888.7 3 all 2m
sh fit_features.bash 569.4 598.3 0.102 3.84 4.23 319 315.7 3 burglary 3m
sh fit_features.bash 456.5 300.9 0.867 3.59 0.96 307 208.4 1 street 1w
sh fit_features.bash 424.9 568.2 0.268 3.53 6.24 441 1174.1 5 all 2w
sh fit_features.bash 429.0 377.8 0.415 1.67 5.08 797 1147.2 6 burglary 3m
sh fit_features.bash 598.8 419.7 0.446 3.98 3.23 792 899.3 3 burglary 2m
sh fit_features.bash 370.2 365.4 0.191 2.73 8.23 268 782.1 4 burglary 2m
sh fit_features.bash 592.2 260.1 0.326 1.92 5.11 1167 142.8 3 vehicle 1w
sh fit_features.bash 486.3 381.0 0.872 3.53 3.59 641 280.0 5 vehicle 3m
sh fit_features.bash 313.2 297.6 0.802 0.58 7.12 701 478.4 5 all 3m
sh fit_features.bash 475.7 361.6 0.088 1.01 4.03 882 710.3 6 burglary 3m
sh fit_features.bash 311.2 466.9 0.085 1.66 2.82 1090 1070.2 5 burglary 1m
sh fit_features.bash 344.2 519.4 0.624 3.32 5.77 904 727.0 2 burglary 2w
sh fit_features.bash 592.1 503.2 0.607 2.25 5.69 1094 301.2 4 vehicle 1w
sh fit_features.bash 251.9 575.5 0.926 0.13 6.68 1147 104.1 3 burglary 2m
sh fit_features.bash 474.8 273.4 0.409 3.61 3.97 226 655.2 4 all 1m
sh fit_features.bash 502.1 331.8 0.424 2.90 2.23 695 435.5 6 street 2m
sh fit_features.bash 552.3 521.3 0.535 3.04 7.57 827 578.1 5 burglary 2w
sh fit_features.bash 332.4 496.2 0.513 3.03 5.90 541 1108.5 6 vehicle 3m
sh fit_features.bash 340.8 449.8 0.393 3.65 9.46 142 582.8 1 burglary 2w
sh fit_features.bash 538.7 447.1 0.148 0.51 0.45 679 652.7 5 all 3m
sh fit_features.bash 531.3 418.2 0.296 1.49 8.36 348 751.9 1 all 3m
sh fit_features.bash 517.7 269.2 0.511 0.37 1.79 528 291.4 4 vehicle 1m
sh fit_features.bash 405.1 507.4 0.344 2.94 9.46 1074 343.4 1 vehicle 1w
sh fit_features.bash 567.7 493.2 0.390 3.16 0.21 1037 817.9 1 all 1m
sh fit_features.bash 351.9 392.6 0.168 0.52 10.16 900 1033.2 2 burglary 1m
sh fit_features.bash 298.9 419.3 0.843 2.44 11.94 969 494.0 2 vehicle 2m
sh fit_features.bash 254.9 458.4 0.045 0.57 10.45 819 935.2 3 all 2w
sh fit_features.bash 251.9 555.9 0.804 2.48 3.13 385 899.9 3 all 2m
sh fit_features.bash 593.2 491.7 0.418 2.25 0.04 906 681.1 3 street 2w
sh fit_features.bash 598.7 306.4 0.334 2.74 1.84 343 838.4 3 street 3m
sh fit_features.bash 451.1 487.1 0.842 2.78 6.33 1047 574.9 5 vehicle 1w
sh fit_features.bash 337.2 565.2 0.599 0.79 9.04 660 122.6 2 burglary 3m
sh fit_features.bash 340.8 595.7 0.760 0.81 10.27 228 409.9 5 all 1w
sh fit_features.bash 431.1 311.8 0.221 0.15 5.84 710 621.7 2 burglary 2m
sh fit_features.bash 300.9 310.8 0.759 0.90 5.47 400 232.8 1 street 1m
sh fit_features.bash 292.1 363.2 0.396 0.16 3.45 536 1003.4 2 all 2m
sh fit_features.bash 489.1 286.9 0.764 0.97 8.19 796 418.8 5 all 3m
sh fit_features.bash 314.4 575.2 0.400 2.01 6.07 539 965.5 4 all 1m
sh fit_features.bash 513.3 528.6 0.568 3.41 8.58 912 806.1 2 vehicle 2w
sh fit_features.bash 282.5 435.7 0.676 0.59 7.47 1159 698.6 5 street 3m
sh fit_features.bash 291.1 532.5 0.120 0.56 4.05 839 106.5 5 street 1w
sh fit_features.bash 483.4 298.5 0.519 2.25 6.61 180 133.0 3 burglary 3m
sh fit_features.bash 501.2 343.5 0.551 0.33 9.62 415 385.2 4 burglary 2w
sh fit_features.bash 544.0 413.7 0.948 3.98 11.90 930 946.2 1 burglary 3m
sh fit_features.bash 263.7 446.7 0.290 3.01 9.59 829 330.4 3 burglary 2w
sh fit_features.bash 596.5 469.2 0.164 0.05 8.62 701 293.7 1 all 1w
sh fit_features.bash 519.8 345.5 0.633 1.36 2.62 812 720.5 3 street 1w
sh fit_features.bash 511.7 506.5 0.189 0.13 7.17 267 1111.6 2 all 3m
sh fit_features.bash 314.5 403.4 0.228 1.61 2.17 679 640.4 1 vehicle 3m
sh fit_features.bash 280.7 552.2 0.923 0.31 0.87 123 803.7 1 street 2w
sh fit_features.bash 464.9 348.8 0.415 0.32 2.67 940 208.0 3 vehicle 1m
sh fit_features.bash 537.2 323.3 0.997 1.35 8.42 1139 111.4 6 all 3m
sh fit_features.bash 508.4 349.4 0.426 3.16 3.55 98 156.7 6 all 1w
sh fit_features.bash 257.5 340.2 0.222 3.26 4.84 1154 192.9 2 burglary 1w
sh fit_features.bash 289.2 464.8 0.392 0.28 9.92 650 177.5 5 vehicle 2m
sh fit_features.bash 588.9 336.4 0.463 0.74 3.01 1120 394.0 1 street 1m
sh fit_features.bash 444.7 556.0 0.834 2.87 4.28 816 702.2 5 vehicle 2m
sh fit_features.bash 283.6 440.1 0.966 2.11 7.68 810 805.1 1 burglary 1w
sh fit_features.bash 476.4 464.3 0.183 1.18 4.32 790 1135.6 6 all 3m
sh fit_features.bash 408.1 544.1 0.725 1.21 10.50 810 885.8 3 vehicle 1m
sh fit_features.bash 360.9 528.6 0.784 2.59 1.54 382 156.2 6 all 1m
sh fit_features.bash 539.7 370.7 0.510 0.23 8.05 238 202.6 4 vehicle 2w
sh fit_features.bash 336.1 283.8 0.185 2.56 11.93 1063 677.5 4 vehicle 2m
sh fit_features.bash 555.0 342.3 0.886 1.09 11.89 786 890.7 1 vehicle 2m
sh fit_features.bash 294.6 277.1 0.947 0.81 7.41 544 972.5 1 burglary 1w
sh fit_features.bash 495.3 563.1 0.747 3.86 5.93 1056 221.0 3 street 2m
sh fit_features.bash 411.6 392.6 0.108 0.71 0.65 505 359.4 1 street 2m
sh fit_features.bash 426.0 486.2 0.556 0.73 3.44 712 106.1 2 vehicle 2w
sh fit_features.bash 496.3 552.5 0.705 1.64 2.23 1032 632.9 6 all 3m
sh fit_features.bash 436.5 522.0 0.345 1.89 8.60 1005 498.9 3 burglary 1m
sh fit_features.bash 510.3 414.7 0.749 3.43 10.89 878 634.4 4 vehicle 1m
sh fit_features.bash 382.2 569.1 0.290 1.98 3.99 889 500.9 6 all 2m
sh fit_features.bash 377.3 496.9 0.412 2.20 2.34 600 1120.2 2 street 2w
sh fit_features.bash 429.2 535.5 0.906 3.62 2.94 955 1191.0 3 burglary 1m
sh fit_features.bash 286.6 415.7 0.517 3.33 4.27 774 310.1 4 vehicle 2w
sh fit_features.bash 294.6 443.3 0.703 1.39 3.84 140 487.2 4 burglary 2m
sh fit_features.bash 598.4 472.8 0.552 2.17 1.37 669 228.5 6 burglary 3m
sh fit_features.bash 365.0 312.5 0.173 2.24 9.07 625 938.3 6 all 1m
