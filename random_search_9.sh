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

sh fit_features.bash 488.3 562.3 0.153 1.77 8.47 959 974.8 2 all 3m
sh fit_features.bash 345.0 303.8 0.449 2.45 6.83 177 609.6 6 all 2m
sh fit_features.bash 516.9 374.3 0.044 1.53 7.22 88 1126.6 2 vehicle 3m
sh fit_features.bash 596.4 365.8 0.028 3.99 9.58 835 431.0 2 burglary 1w
sh fit_features.bash 432.1 309.6 0.501 2.29 9.86 1190 107.2 4 all 1m
sh fit_features.bash 543.3 379.8 0.123 1.97 7.46 290 338.7 1 all 2w
sh fit_features.bash 478.6 421.1 0.300 2.55 7.03 338 259.2 4 street 1m
sh fit_features.bash 280.4 526.0 0.362 2.66 8.81 190 468.7 5 street 2w
sh fit_features.bash 301.3 499.0 0.066 2.35 7.59 86 776.3 5 vehicle 2m
sh fit_features.bash 509.3 350.2 0.349 2.55 3.03 573 850.7 6 burglary 1m
sh fit_features.bash 392.6 309.3 0.008 0.53 7.68 1186 1087.7 3 all 3m
sh fit_features.bash 404.3 478.8 0.280 1.80 2.86 463 447.0 4 vehicle 2w
sh fit_features.bash 345.4 387.4 0.505 1.03 1.69 139 486.7 2 street 3m
sh fit_features.bash 420.9 342.1 0.190 0.68 4.00 702 545.2 1 burglary 3m
sh fit_features.bash 524.8 427.1 0.484 0.37 1.58 788 416.9 2 vehicle 3m
sh fit_features.bash 407.3 410.8 0.989 1.47 1.17 1193 852.3 6 street 3m
sh fit_features.bash 564.3 415.0 0.818 3.14 6.08 819 931.8 5 street 2w
sh fit_features.bash 527.1 284.1 0.267 1.24 6.77 133 1097.2 4 burglary 3m
sh fit_features.bash 394.4 424.1 0.397 2.21 7.22 437 705.2 2 street 3m
sh fit_features.bash 410.0 574.6 0.705 1.37 5.97 808 1082.2 1 all 2m
sh fit_features.bash 254.4 381.7 0.440 3.00 8.32 155 232.8 3 vehicle 2w
sh fit_features.bash 258.7 390.7 0.640 2.59 10.31 1100 878.3 5 street 1m
sh fit_features.bash 457.6 595.0 0.654 0.22 5.81 625 135.8 3 all 1m
sh fit_features.bash 583.6 524.4 0.145 0.72 4.53 64 338.8 6 all 1m
sh fit_features.bash 288.0 424.3 0.869 2.05 11.95 605 972.2 1 vehicle 2w
sh fit_features.bash 427.1 398.2 0.514 2.98 5.41 134 502.6 5 all 2w
sh fit_features.bash 566.0 398.9 0.665 0.99 3.53 182 386.1 6 vehicle 3m
sh fit_features.bash 476.7 449.4 0.058 0.53 9.44 159 125.1 3 burglary 3m
sh fit_features.bash 486.2 270.4 0.247 1.51 3.49 878 283.6 3 burglary 2m
sh fit_features.bash 292.5 283.0 0.397 1.21 5.69 717 582.5 6 burglary 2m
sh fit_features.bash 303.2 265.2 0.022 2.93 0.14 891 285.7 4 all 1m
sh fit_features.bash 592.2 459.9 0.357 2.79 11.86 872 495.6 6 street 3m
sh fit_features.bash 494.3 554.7 0.664 3.52 9.91 207 732.0 2 burglary 2m
sh fit_features.bash 283.5 282.3 0.409 3.12 6.79 802 904.1 2 vehicle 3m
sh fit_features.bash 319.4 454.3 0.910 2.02 10.34 74 465.1 6 vehicle 2w
sh fit_features.bash 322.7 353.3 0.930 3.70 4.65 1029 774.8 3 burglary 1m
sh fit_features.bash 533.8 374.9 0.837 1.26 3.54 654 732.4 2 burglary 3m
sh fit_features.bash 360.7 505.4 0.406 1.25 4.32 335 760.9 3 burglary 1m
sh fit_features.bash 414.8 269.4 0.262 1.99 5.40 60 863.7 2 street 2w
sh fit_features.bash 533.9 338.6 0.391 3.30 8.45 264 990.9 2 vehicle 1m
sh fit_features.bash 412.8 278.9 0.422 1.08 4.70 78 899.7 1 vehicle 1w
sh fit_features.bash 352.8 277.2 0.141 0.01 7.04 102 397.1 2 all 2w
sh fit_features.bash 535.9 424.0 0.495 0.79 6.46 966 1001.8 3 vehicle 2w
sh fit_features.bash 318.0 567.2 0.053 0.83 1.25 340 872.8 5 all 1w
sh fit_features.bash 510.1 331.2 0.681 0.12 4.94 56 149.3 2 vehicle 3m
sh fit_features.bash 555.9 333.8 0.710 2.20 8.59 897 400.0 2 all 1w
sh fit_features.bash 408.2 532.0 0.286 1.91 11.89 470 926.4 3 street 3m
sh fit_features.bash 518.9 466.8 0.491 3.54 1.89 661 630.4 1 burglary 3m
sh fit_features.bash 253.3 415.0 0.937 1.71 5.91 816 139.8 1 all 2w
sh fit_features.bash 323.1 528.6 0.631 2.92 3.72 781 582.6 4 street 2w
sh fit_features.bash 534.5 596.0 0.993 1.10 5.71 761 419.0 2 vehicle 2w
sh fit_features.bash 582.7 251.5 0.587 2.58 10.36 152 698.9 5 burglary 3m
sh fit_features.bash 411.9 351.2 0.280 1.17 6.75 387 568.0 3 burglary 3m
sh fit_features.bash 250.9 266.6 0.071 0.29 6.80 896 879.2 5 vehicle 1m
sh fit_features.bash 429.9 544.3 0.569 3.00 11.73 702 895.0 3 vehicle 1w
sh fit_features.bash 266.5 404.8 0.577 0.59 9.73 170 599.5 2 burglary 2m
sh fit_features.bash 588.1 553.0 0.285 1.00 9.60 695 1089.2 5 all 1w
sh fit_features.bash 318.4 389.2 0.686 1.35 2.58 451 954.8 3 vehicle 3m
sh fit_features.bash 543.7 330.7 0.056 1.12 8.41 1184 1109.6 2 all 3m
sh fit_features.bash 464.5 477.8 0.091 0.10 11.73 627 219.1 4 vehicle 3m
sh fit_features.bash 292.2 557.2 0.333 2.02 11.20 170 336.8 3 burglary 1w
sh fit_features.bash 313.1 597.8 0.812 1.25 6.93 59 1097.1 5 vehicle 1w
sh fit_features.bash 556.7 344.2 0.093 2.42 2.25 816 302.3 6 vehicle 3m
sh fit_features.bash 390.8 560.4 0.003 0.79 10.39 200 340.7 4 street 2w
sh fit_features.bash 435.1 489.1 0.491 3.42 11.44 442 1133.8 4 vehicle 1w
sh fit_features.bash 564.1 377.3 0.584 0.65 8.12 104 986.9 6 vehicle 2m
sh fit_features.bash 490.4 559.1 0.550 2.89 10.11 319 442.3 1 street 3m
sh fit_features.bash 275.9 309.0 0.270 1.49 5.00 865 268.0 5 street 2m
sh fit_features.bash 413.8 479.6 0.632 1.45 6.62 479 929.9 3 street 2m
sh fit_features.bash 556.6 559.4 0.309 2.36 5.55 816 682.3 4 vehicle 3m
sh fit_features.bash 446.8 356.4 0.268 2.28 9.25 676 531.4 6 vehicle 2w
sh fit_features.bash 258.9 316.8 0.465 3.70 0.95 321 431.5 1 vehicle 2m
sh fit_features.bash 529.3 432.5 0.801 2.97 0.50 801 943.0 3 all 1w
sh fit_features.bash 533.9 435.2 0.214 3.97 2.87 870 769.9 3 vehicle 1w
sh fit_features.bash 475.0 311.9 0.086 1.00 2.49 763 279.9 1 street 2m
sh fit_features.bash 458.9 569.2 0.515 2.27 5.60 526 862.1 5 burglary 1m
sh fit_features.bash 273.2 253.2 0.910 2.55 1.11 733 974.5 4 vehicle 2w
sh fit_features.bash 395.4 341.2 0.296 2.92 8.86 373 681.9 1 street 1m
sh fit_features.bash 261.9 262.3 0.721 2.39 11.15 594 1141.6 3 burglary 1m
sh fit_features.bash 367.1 303.1 0.822 1.34 10.96 471 1108.2 1 burglary 3m
sh fit_features.bash 535.6 405.8 0.066 1.90 10.48 749 615.8 1 vehicle 1w
sh fit_features.bash 503.1 394.2 0.607 3.64 6.39 1173 963.0 2 street 1w
sh fit_features.bash 489.4 529.3 0.805 1.83 7.38 105 870.5 1 burglary 1m
sh fit_features.bash 503.8 345.2 0.093 2.18 6.50 297 997.5 4 street 3m
sh fit_features.bash 516.4 470.5 0.425 3.50 9.58 1000 644.8 1 vehicle 3m
sh fit_features.bash 560.2 486.1 0.325 1.07 4.88 703 568.6 1 all 1w
sh fit_features.bash 523.5 547.0 0.508 0.03 6.97 1131 279.8 1 burglary 2m
sh fit_features.bash 528.3 457.2 0.388 1.50 3.85 573 1105.6 1 all 1w
sh fit_features.bash 360.2 268.4 0.462 1.19 3.44 426 713.3 2 vehicle 2m
sh fit_features.bash 293.6 284.8 0.629 1.83 8.87 288 319.2 3 burglary 2m
sh fit_features.bash 401.1 435.0 0.230 2.30 6.70 727 725.8 4 street 3m
sh fit_features.bash 490.0 268.7 0.076 2.56 0.36 997 919.6 4 all 2m
sh fit_features.bash 298.0 451.2 0.627 0.36 0.61 373 186.0 6 vehicle 3m
sh fit_features.bash 562.4 308.0 0.749 2.01 0.45 505 987.1 5 all 2w
sh fit_features.bash 414.3 442.3 0.495 2.94 9.02 913 1021.8 6 burglary 3m
sh fit_features.bash 464.0 379.9 0.947 1.67 1.94 476 236.7 3 burglary 2m
sh fit_features.bash 462.9 286.7 0.183 3.82 11.12 839 120.4 3 vehicle 2m
sh fit_features.bash 338.3 494.3 0.075 0.06 3.39 1056 954.9 5 vehicle 1w
sh fit_features.bash 563.3 523.7 0.615 1.78 1.00 586 408.7 5 burglary 3m
sh fit_features.bash 421.9 512.1 0.413 2.54 8.62 128 486.6 2 street 1w
