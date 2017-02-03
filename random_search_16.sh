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

sh fit_features.bash 586.7 575.4 0.579 3.06 5.79 518 572.6 8 vehicle 2m
sh fit_features.bash 531.1 512.0 0.427 1.37 6.18 922 244.0 6 all 3m
sh fit_features.bash 594.6 257.3 0.354 3.96 9.12 911 904.0 4 street 3m
sh fit_features.bash 592.7 357.5 0.604 0.77 8.45 566 410.1 7 all 2w
sh fit_features.bash 507.3 287.0 0.586 3.80 0.09 247 319.8 5 street 3m
sh fit_features.bash 437.5 358.2 0.255 2.70 4.65 917 609.2 8 burglary 3m
sh fit_features.bash 585.0 262.9 0.773 2.38 3.85 892 378.6 6 vehicle 1m
sh fit_features.bash 576.5 345.7 0.190 2.89 3.14 1184 684.1 1 vehicle 1m
sh fit_features.bash 453.7 561.6 0.546 0.42 11.19 887 332.6 1 vehicle 1w
sh fit_features.bash 570.4 536.0 0.403 3.14 3.05 854 746.2 1 burglary 3m
sh fit_features.bash 566.0 563.3 0.345 0.77 11.24 967 191.5 1 burglary 1w
sh fit_features.bash 561.1 292.5 0.873 1.94 2.71 982 730.5 2 vehicle 3m
sh fit_features.bash 291.4 483.6 0.248 3.69 11.02 1075 224.8 3 vehicle 1w
sh fit_features.bash 358.4 388.0 0.115 3.42 8.16 662 1165.4 7 vehicle 1w
sh fit_features.bash 373.7 261.2 0.884 2.01 5.73 685 312.1 6 street 3m
sh fit_features.bash 499.1 519.2 0.510 0.10 3.55 373 278.5 1 all 1m
sh fit_features.bash 520.0 514.7 0.386 0.76 2.87 544 685.0 7 burglary 3m
sh fit_features.bash 552.8 353.8 0.501 2.12 6.12 688 380.1 2 burglary 2w
sh fit_features.bash 382.8 466.3 0.194 0.01 0.74 885 410.0 5 vehicle 3m
sh fit_features.bash 294.3 405.3 0.560 1.79 0.72 149 882.7 5 all 1w
sh fit_features.bash 340.9 496.1 0.537 0.43 2.29 275 1009.1 6 all 3m
sh fit_features.bash 562.8 483.5 0.440 1.49 3.78 351 542.0 6 all 1m
sh fit_features.bash 383.6 565.6 0.963 2.37 10.44 513 533.0 8 burglary 1m
sh fit_features.bash 327.8 419.0 0.113 2.39 8.30 276 1049.0 8 vehicle 3m
sh fit_features.bash 530.0 537.8 0.551 3.96 2.96 868 393.7 3 all 1w
sh fit_features.bash 541.1 437.5 0.011 2.21 0.45 958 451.0 3 all 3m
sh fit_features.bash 294.3 563.6 0.625 0.14 1.37 1025 419.7 8 street 1m
sh fit_features.bash 541.9 305.3 0.978 0.42 7.13 746 533.8 3 all 1m
sh fit_features.bash 276.0 507.2 0.841 2.62 11.38 235 1052.8 2 vehicle 2m
sh fit_features.bash 417.4 402.3 0.540 0.78 8.42 214 114.0 4 burglary 1m
sh fit_features.bash 491.3 525.2 0.074 0.02 5.77 395 1056.9 6 burglary 1w
sh fit_features.bash 308.0 393.8 0.465 2.09 2.81 1122 226.5 8 vehicle 1m
sh fit_features.bash 306.2 445.2 0.673 2.71 4.86 1080 235.6 4 vehicle 2m
sh fit_features.bash 300.8 379.6 0.116 1.74 4.52 431 334.3 2 burglary 2w
sh fit_features.bash 432.4 383.3 0.356 1.19 11.19 1160 793.1 4 street 1m
sh fit_features.bash 269.6 555.9 0.842 3.98 10.61 617 1041.5 7 burglary 1m
sh fit_features.bash 375.0 531.5 0.134 0.77 0.07 1175 312.5 6 street 2m
sh fit_features.bash 335.5 277.2 0.704 2.31 10.03 854 864.4 3 burglary 2m
sh fit_features.bash 489.8 468.4 0.623 3.18 4.68 331 818.4 4 all 3m
sh fit_features.bash 524.8 379.1 0.304 0.46 8.25 539 883.0 3 burglary 2m
sh fit_features.bash 369.9 477.2 0.553 3.60 0.10 947 883.1 1 vehicle 2w
sh fit_features.bash 543.7 252.1 0.995 2.09 2.57 364 1026.3 1 street 3m
sh fit_features.bash 448.9 503.2 0.525 1.84 6.43 163 1049.1 1 burglary 1w
sh fit_features.bash 406.0 489.0 0.658 0.60 7.76 370 986.4 5 all 3m
sh fit_features.bash 513.2 494.9 0.135 0.14 7.83 402 815.2 8 vehicle 3m
sh fit_features.bash 310.7 523.2 0.898 2.17 6.54 934 361.0 5 all 2m
sh fit_features.bash 317.5 260.0 0.686 2.28 4.96 598 964.2 4 all 1m
sh fit_features.bash 265.3 280.3 0.229 0.85 4.34 259 848.7 1 burglary 1m
sh fit_features.bash 271.2 367.2 0.110 2.61 8.69 418 688.6 1 burglary 1m
sh fit_features.bash 585.0 344.2 0.377 3.88 0.44 104 894.1 7 street 1m
sh fit_features.bash 579.3 567.0 0.687 3.97 2.37 163 468.3 5 street 1w
sh fit_features.bash 292.5 481.3 0.216 2.03 3.96 528 340.8 4 street 1w
sh fit_features.bash 328.9 309.7 0.978 0.05 2.09 898 983.4 3 street 2w
sh fit_features.bash 502.0 560.8 0.760 1.52 2.08 1111 372.6 6 street 3m
sh fit_features.bash 259.1 492.7 0.109 1.24 4.31 758 150.2 2 vehicle 1w
sh fit_features.bash 584.2 352.0 0.164 1.79 10.22 627 1038.2 2 burglary 1w
sh fit_features.bash 274.2 375.2 0.185 2.73 4.17 373 1034.6 3 all 1w
sh fit_features.bash 482.4 538.1 0.865 3.13 5.79 409 981.0 8 burglary 2w
sh fit_features.bash 410.0 364.4 0.598 3.37 0.73 1074 833.6 2 vehicle 1w
sh fit_features.bash 430.9 328.0 0.546 2.84 8.57 535 744.3 3 vehicle 3m
sh fit_features.bash 395.6 319.2 0.358 3.56 3.00 700 785.1 8 vehicle 2w
sh fit_features.bash 346.4 478.0 0.754 3.12 4.56 660 1150.1 2 burglary 1w
sh fit_features.bash 429.6 430.3 0.724 1.65 0.64 72 130.2 1 street 3m
sh fit_features.bash 370.2 260.3 0.957 0.46 8.47 719 416.8 3 vehicle 3m
sh fit_features.bash 288.0 539.3 0.612 1.08 1.61 1145 798.3 2 all 1m
sh fit_features.bash 564.5 418.8 0.406 0.50 2.66 565 486.3 8 all 2m
sh fit_features.bash 565.0 368.5 0.174 0.32 1.67 279 436.7 8 all 1w
sh fit_features.bash 400.3 565.6 0.815 3.95 6.29 658 537.4 6 all 1w
sh fit_features.bash 501.1 377.8 0.276 0.96 10.43 603 897.8 5 burglary 3m
sh fit_features.bash 537.2 584.3 0.873 1.79 6.90 95 504.8 2 street 2w
sh fit_features.bash 347.8 262.1 0.193 2.71 1.33 1023 302.6 6 all 3m
sh fit_features.bash 397.6 386.3 0.429 2.74 5.37 175 426.0 3 burglary 2w
sh fit_features.bash 420.7 588.6 0.327 0.15 8.61 442 1086.0 6 all 3m
sh fit_features.bash 437.7 522.1 0.338 1.61 4.94 267 613.9 6 burglary 1m
sh fit_features.bash 484.9 281.5 0.220 0.19 9.02 743 989.2 8 street 3m
sh fit_features.bash 261.9 270.8 0.467 1.74 2.53 766 618.2 8 burglary 1m
sh fit_features.bash 433.6 433.6 0.140 0.88 1.48 968 791.0 4 burglary 3m
sh fit_features.bash 591.4 340.0 0.347 1.75 7.78 387 684.2 2 street 2m
sh fit_features.bash 338.5 470.7 0.456 1.55 0.67 634 1144.0 3 burglary 1m
sh fit_features.bash 307.1 563.8 0.585 1.01 1.72 607 409.6 5 all 2m
sh fit_features.bash 425.2 588.1 0.871 2.70 2.18 768 811.5 4 all 3m
sh fit_features.bash 352.1 385.7 0.209 1.05 5.30 866 213.0 8 all 2w
sh fit_features.bash 312.1 496.7 0.737 0.86 4.92 852 333.7 8 street 2m
sh fit_features.bash 355.2 381.4 0.294 0.38 10.33 194 993.4 2 vehicle 2m
sh fit_features.bash 484.6 425.2 0.790 3.57 10.41 540 514.6 6 burglary 2w
sh fit_features.bash 534.9 280.1 0.604 1.49 9.42 269 678.6 7 all 3m
sh fit_features.bash 495.2 408.4 0.019 0.02 0.14 1090 793.3 3 street 2w
sh fit_features.bash 486.9 262.9 0.661 3.78 8.95 469 461.4 7 burglary 3m
sh fit_features.bash 476.0 544.8 0.418 0.41 10.84 178 638.2 7 vehicle 3m
sh fit_features.bash 554.1 272.6 0.477 1.33 10.81 631 685.8 8 burglary 1w
sh fit_features.bash 472.0 597.3 0.443 2.20 7.58 408 427.6 2 burglary 2m
sh fit_features.bash 331.4 376.3 0.111 0.16 8.81 235 655.8 5 vehicle 1w
sh fit_features.bash 550.5 442.3 0.140 3.73 2.81 363 265.4 2 burglary 2m
sh fit_features.bash 350.5 472.1 0.646 3.72 6.54 995 671.4 3 vehicle 2w
sh fit_features.bash 364.0 471.4 0.504 0.70 11.46 372 870.7 4 all 1m
sh fit_features.bash 458.0 251.3 0.230 3.99 0.52 1035 964.9 6 vehicle 1w
sh fit_features.bash 578.9 356.5 0.895 1.82 4.20 1047 933.3 8 burglary 1w
sh fit_features.bash 586.8 254.5 0.479 2.32 0.38 559 763.6 8 street 1w
sh fit_features.bash 468.4 554.8 0.237 3.75 5.16 685 923.6 8 street 2w
sh fit_features.bash 404.8 562.9 0.278 3.98 9.91 792 539.7 6 street 3m
