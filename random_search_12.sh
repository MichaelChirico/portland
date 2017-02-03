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

sh fit_features.bash 367.0 522.7 0.118 2.05 2.95 697 353.3 3 all 1w
sh fit_features.bash 548.0 512.7 0.018 2.48 10.37 932 1012.8 8 vehicle 3m
sh fit_features.bash 428.6 437.7 0.479 1.35 1.81 187 729.7 8 burglary 3m
sh fit_features.bash 452.9 436.0 0.870 0.49 4.10 136 904.2 1 street 3m
sh fit_features.bash 418.1 353.4 0.579 3.69 8.80 278 334.5 4 street 2m
sh fit_features.bash 276.4 412.2 0.595 0.42 7.89 482 449.4 6 vehicle 1w
sh fit_features.bash 283.1 517.8 0.173 1.55 1.16 998 1072.6 3 burglary 2m
sh fit_features.bash 396.2 496.0 0.596 2.17 2.82 172 1017.8 1 vehicle 1m
sh fit_features.bash 350.5 440.1 0.199 2.67 8.19 930 385.2 5 vehicle 2m
sh fit_features.bash 458.7 476.8 0.641 0.15 9.68 295 1143.6 1 street 1m
sh fit_features.bash 392.7 404.5 0.450 0.15 2.78 629 526.2 1 all 2m
sh fit_features.bash 415.7 299.4 0.310 3.47 4.33 1135 897.2 6 burglary 3m
sh fit_features.bash 488.8 599.2 0.258 1.39 1.43 902 678.8 1 all 2m
sh fit_features.bash 264.9 422.3 0.999 2.92 3.70 835 305.6 1 street 2w
sh fit_features.bash 565.0 466.9 0.295 3.13 2.61 255 623.4 2 street 2m
sh fit_features.bash 405.1 336.2 0.078 2.97 5.78 373 916.4 7 vehicle 3m
sh fit_features.bash 322.4 411.6 0.747 0.42 10.52 961 214.5 1 street 1m
sh fit_features.bash 488.7 539.1 0.052 0.89 2.84 452 465.7 7 all 1w
sh fit_features.bash 388.9 390.9 0.374 2.13 4.69 715 128.5 6 street 1m
sh fit_features.bash 494.7 379.6 0.701 2.11 3.77 1041 288.0 8 street 1w
sh fit_features.bash 403.4 433.8 0.909 1.40 0.94 770 819.2 6 street 3m
sh fit_features.bash 323.4 410.2 0.396 0.20 8.63 596 680.6 4 all 3m
sh fit_features.bash 321.5 379.9 0.607 1.89 9.98 989 334.3 4 burglary 1m
sh fit_features.bash 434.0 303.6 0.382 3.09 11.43 882 943.8 1 vehicle 3m
sh fit_features.bash 274.1 265.6 0.718 3.33 4.63 323 616.0 1 vehicle 1w
sh fit_features.bash 590.4 582.4 0.115 3.52 4.98 781 1010.2 4 burglary 2m
sh fit_features.bash 308.2 524.5 0.749 1.49 0.75 100 679.9 1 burglary 2m
sh fit_features.bash 566.8 587.4 0.263 1.90 5.60 182 1056.0 2 all 3m
sh fit_features.bash 544.9 445.3 0.495 1.50 10.40 50 1099.4 4 street 2w
sh fit_features.bash 430.8 334.1 0.956 0.46 7.94 722 615.2 5 street 2m
sh fit_features.bash 581.7 340.0 0.255 2.21 3.51 753 692.7 4 burglary 3m
sh fit_features.bash 594.9 501.1 0.277 2.03 6.37 705 318.6 5 vehicle 1m
sh fit_features.bash 436.6 532.5 0.385 0.99 4.59 1077 145.7 7 burglary 3m
sh fit_features.bash 255.2 597.9 0.731 1.18 9.10 278 170.1 2 all 1w
sh fit_features.bash 254.9 440.8 0.490 2.10 0.67 242 300.9 1 burglary 2w
sh fit_features.bash 286.9 316.3 0.786 1.36 7.29 160 1184.6 3 burglary 1w
sh fit_features.bash 457.0 289.4 0.497 2.62 3.93 549 129.8 1 street 3m
sh fit_features.bash 254.2 256.4 0.324 3.37 8.10 313 220.3 2 all 2w
sh fit_features.bash 358.8 554.2 0.488 2.40 7.06 504 510.2 7 vehicle 2w
sh fit_features.bash 529.7 461.1 0.484 3.43 11.68 413 1101.1 7 vehicle 2m
sh fit_features.bash 489.4 481.7 0.157 1.30 10.11 814 1122.3 7 burglary 1w
sh fit_features.bash 322.8 454.9 0.066 3.22 10.22 836 144.5 5 vehicle 1m
sh fit_features.bash 545.9 462.9 0.459 3.09 3.49 806 1099.1 2 street 2w
sh fit_features.bash 583.9 590.1 0.792 0.40 2.01 375 224.2 4 vehicle 2w
sh fit_features.bash 467.3 552.5 0.471 1.22 0.79 1122 1126.2 6 all 1w
sh fit_features.bash 298.7 492.7 0.296 3.84 4.89 898 584.3 1 all 1m
sh fit_features.bash 332.0 278.7 0.477 0.35 7.88 105 721.5 8 all 2m
sh fit_features.bash 454.4 288.1 0.733 2.75 7.77 441 842.4 4 street 1m
sh fit_features.bash 300.4 370.7 0.179 3.94 1.78 657 405.0 4 vehicle 3m
sh fit_features.bash 593.4 306.0 0.329 1.23 2.75 680 335.7 1 street 2w
sh fit_features.bash 497.5 326.8 0.844 0.81 1.45 933 745.3 8 burglary 1m
sh fit_features.bash 280.2 576.2 0.504 0.25 5.75 155 655.7 1 all 1m
sh fit_features.bash 256.9 545.3 0.772 2.17 3.86 415 181.4 5 burglary 3m
sh fit_features.bash 409.8 549.0 0.049 3.07 9.72 387 832.5 3 all 1w
sh fit_features.bash 536.0 408.9 0.283 1.14 2.22 86 1104.4 8 burglary 1m
sh fit_features.bash 435.0 511.2 0.322 3.30 5.75 116 565.2 1 street 2m
sh fit_features.bash 458.6 385.1 0.846 0.64 10.06 707 424.3 3 burglary 1w
sh fit_features.bash 321.2 553.6 0.575 1.61 3.13 1010 406.7 2 vehicle 2w
sh fit_features.bash 555.6 269.8 0.995 2.28 2.62 245 558.0 5 vehicle 2m
sh fit_features.bash 381.3 296.3 0.818 3.84 7.57 1104 449.3 2 vehicle 1w
sh fit_features.bash 562.3 513.2 0.570 0.69 11.53 723 281.2 6 street 3m
sh fit_features.bash 549.4 425.9 0.080 2.36 4.66 145 1191.9 6 street 2m
sh fit_features.bash 441.2 292.1 0.310 1.71 9.62 782 254.4 1 burglary 1m
sh fit_features.bash 480.3 357.6 0.012 2.32 7.93 447 976.1 3 street 2m
sh fit_features.bash 483.9 458.6 0.579 0.09 0.09 759 376.3 1 street 2w
sh fit_features.bash 593.1 275.8 0.221 0.45 4.66 529 157.1 2 street 2w
sh fit_features.bash 275.1 407.9 0.539 0.11 0.54 690 1021.9 1 street 2m
sh fit_features.bash 572.1 575.6 0.121 1.75 10.41 124 1031.2 3 vehicle 2m
sh fit_features.bash 307.8 506.4 0.077 1.69 2.02 645 1013.1 2 vehicle 2w
sh fit_features.bash 396.6 457.3 0.065 2.59 7.27 1058 562.6 4 burglary 2w
sh fit_features.bash 267.3 488.4 0.804 3.62 3.84 303 924.0 6 street 2w
sh fit_features.bash 299.0 276.6 0.916 0.94 6.63 365 814.0 7 all 3m
sh fit_features.bash 260.9 583.2 0.220 2.99 5.28 906 653.0 2 vehicle 2m
sh fit_features.bash 568.5 541.9 0.619 1.07 3.07 1132 1015.5 3 street 1w
sh fit_features.bash 408.8 484.7 0.640 1.08 5.44 103 772.3 1 street 3m
sh fit_features.bash 432.5 561.3 0.856 2.59 4.92 837 1195.2 6 street 2w
sh fit_features.bash 485.5 382.0 0.154 1.90 1.64 462 527.8 3 all 1w
sh fit_features.bash 254.4 432.4 0.840 3.51 1.41 655 1092.6 2 all 1m
sh fit_features.bash 536.5 493.9 0.359 0.84 11.88 79 388.9 6 all 2w
sh fit_features.bash 362.1 478.1 0.179 0.75 2.90 799 755.3 1 all 2m
sh fit_features.bash 406.8 345.6 0.131 0.42 6.20 615 418.2 8 street 2m
sh fit_features.bash 549.9 339.2 0.253 2.00 7.02 230 964.7 3 burglary 1w
sh fit_features.bash 376.5 277.3 0.962 3.29 10.95 1100 1042.6 8 all 2w
sh fit_features.bash 516.2 534.6 0.877 3.73 8.78 605 884.3 8 burglary 2m
sh fit_features.bash 523.1 265.8 0.754 0.61 1.02 1127 915.9 7 burglary 2m
sh fit_features.bash 333.1 404.0 0.885 3.09 4.88 110 790.3 8 all 2w
sh fit_features.bash 291.7 442.7 0.248 3.41 5.11 731 463.0 2 vehicle 3m
sh fit_features.bash 455.0 368.5 0.059 2.29 8.78 1008 143.8 4 street 2m
sh fit_features.bash 574.0 339.7 0.872 2.72 7.57 480 260.4 7 burglary 3m
sh fit_features.bash 253.5 346.4 0.185 0.96 5.20 1115 1046.0 4 vehicle 2w
sh fit_features.bash 332.7 269.3 0.039 3.71 6.79 448 224.2 6 street 2w
sh fit_features.bash 579.0 328.5 0.287 3.44 8.48 950 833.4 8 street 1w
sh fit_features.bash 456.5 449.2 0.289 0.79 11.97 763 1020.9 3 burglary 3m
sh fit_features.bash 526.6 470.5 0.507 0.50 7.81 233 193.8 7 all 3m
sh fit_features.bash 388.8 534.5 0.195 2.84 2.83 354 199.7 4 vehicle 2w
sh fit_features.bash 307.8 366.6 0.629 3.49 5.15 977 1189.8 6 all 2m
sh fit_features.bash 529.2 543.3 0.128 3.97 2.94 371 876.8 8 vehicle 1w
sh fit_features.bash 372.0 392.9 0.964 4.00 1.48 739 464.0 8 street 2m
sh fit_features.bash 261.6 304.2 0.824 2.96 4.29 213 778.1 8 burglary 2m
sh fit_features.bash 581.2 421.0 0.581 2.21 3.10 179 459.8 3 vehicle 1w
