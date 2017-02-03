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

sh fit_features.bash 455.1 580.4 0.131 0.54 11.00 999 182.4 5 burglary 2m
sh fit_features.bash 441.7 260.8 0.106 2.32 8.51 1169 993.3 1 vehicle 1w
sh fit_features.bash 573.5 535.7 0.857 2.27 11.49 638 873.6 5 street 2w
sh fit_features.bash 428.2 304.4 0.555 0.15 10.70 287 1035.3 1 burglary 3m
sh fit_features.bash 330.7 329.1 0.835 2.43 6.56 536 597.2 1 vehicle 2w
sh fit_features.bash 384.8 354.8 0.572 2.93 11.64 494 856.7 5 street 3m
sh fit_features.bash 257.2 456.4 0.114 0.29 9.95 595 255.1 6 vehicle 2w
sh fit_features.bash 491.2 582.8 0.380 3.64 0.61 515 513.6 5 street 2m
sh fit_features.bash 509.0 419.4 0.827 2.41 9.06 129 187.4 5 street 2m
sh fit_features.bash 594.6 408.4 0.024 2.45 6.53 1185 1066.3 3 vehicle 1m
sh fit_features.bash 316.2 487.7 0.816 0.90 5.33 726 156.9 3 all 2w
sh fit_features.bash 488.5 554.6 0.801 1.57 5.20 1194 780.2 6 all 1m
sh fit_features.bash 451.0 587.9 0.520 0.77 8.91 842 1131.5 1 street 1w
sh fit_features.bash 583.7 568.3 0.184 1.86 2.12 589 1050.6 3 all 1w
sh fit_features.bash 368.1 456.8 0.154 0.29 5.87 815 804.7 6 all 2m
sh fit_features.bash 514.4 329.5 0.318 3.89 8.81 1094 692.4 5 vehicle 2w
sh fit_features.bash 505.3 477.6 0.201 2.82 2.25 443 207.6 6 burglary 2m
sh fit_features.bash 451.7 281.8 0.518 2.47 6.27 371 729.0 5 street 1w
sh fit_features.bash 475.1 488.3 0.287 3.96 6.06 1085 312.7 5 burglary 1w
sh fit_features.bash 471.6 311.0 0.296 0.44 11.05 488 815.6 6 all 2w
sh fit_features.bash 357.2 533.0 0.894 3.60 3.87 905 526.6 1 burglary 1m
sh fit_features.bash 376.1 332.7 0.989 1.06 0.69 573 652.0 3 vehicle 1w
sh fit_features.bash 382.6 497.0 0.735 3.23 10.29 842 528.5 2 all 1m
sh fit_features.bash 492.0 395.4 0.168 2.20 0.75 348 138.5 2 street 2w
sh fit_features.bash 592.8 514.5 0.031 3.27 4.52 761 802.7 3 vehicle 1m
sh fit_features.bash 426.7 413.3 0.467 3.45 11.93 1076 1031.9 2 street 1m
sh fit_features.bash 486.2 315.9 0.683 1.78 4.58 184 337.9 6 street 2m
sh fit_features.bash 587.1 503.1 0.394 1.85 1.83 399 455.4 4 vehicle 3m
sh fit_features.bash 524.3 365.8 0.769 2.42 3.85 718 1147.1 6 all 1m
sh fit_features.bash 369.5 455.5 0.072 0.12 6.61 228 342.4 5 all 2m
sh fit_features.bash 285.6 423.3 0.951 1.20 11.80 95 477.1 3 street 3m
sh fit_features.bash 311.6 250.2 0.917 0.90 5.37 799 650.3 6 burglary 2w
sh fit_features.bash 421.8 277.0 0.957 2.04 11.82 449 591.6 1 burglary 1m
sh fit_features.bash 515.1 291.2 0.390 2.35 4.95 920 537.7 6 vehicle 1m
sh fit_features.bash 443.6 408.9 0.433 1.49 6.23 696 519.8 2 burglary 1w
sh fit_features.bash 472.5 538.5 0.285 1.21 3.08 703 1008.5 5 all 1w
sh fit_features.bash 384.3 329.3 0.182 1.59 11.87 493 732.8 6 vehicle 1m
sh fit_features.bash 350.5 512.1 0.873 1.09 0.39 71 666.8 4 burglary 2m
sh fit_features.bash 492.2 567.4 0.422 3.67 2.86 1045 252.7 1 all 1m
sh fit_features.bash 510.7 392.7 0.145 3.05 10.25 853 1169.8 1 street 2w
sh fit_features.bash 368.0 582.5 0.045 3.46 3.84 988 236.8 3 street 1w
sh fit_features.bash 262.1 470.1 0.185 1.43 5.07 358 276.0 6 street 1w
sh fit_features.bash 389.9 275.8 0.369 2.62 3.80 1180 1125.6 6 vehicle 2w
sh fit_features.bash 562.7 497.9 0.404 3.88 6.09 208 646.7 1 street 2w
sh fit_features.bash 513.9 312.3 0.642 3.27 3.02 65 897.7 5 all 2m
sh fit_features.bash 346.0 519.3 0.641 0.58 3.46 272 601.5 6 vehicle 3m
sh fit_features.bash 367.8 293.3 0.072 0.39 3.60 1076 553.8 4 street 2m
sh fit_features.bash 530.4 406.3 0.932 0.96 8.86 250 157.5 2 street 2w
sh fit_features.bash 452.4 454.2 0.350 2.77 3.39 114 951.7 6 vehicle 1w
sh fit_features.bash 471.9 268.6 0.456 1.12 11.75 786 181.7 1 vehicle 2w
sh fit_features.bash 545.3 495.1 0.594 2.65 11.99 957 171.0 4 vehicle 3m
sh fit_features.bash 472.0 573.5 0.273 1.65 6.31 549 204.1 3 all 2w
sh fit_features.bash 333.0 430.7 0.093 3.04 0.64 356 596.3 1 burglary 2m
sh fit_features.bash 508.5 297.8 0.614 1.20 5.92 914 117.1 1 all 3m
sh fit_features.bash 474.7 501.7 0.033 0.57 9.41 1007 327.8 1 burglary 2m
sh fit_features.bash 367.8 482.7 0.296 0.03 3.80 754 180.1 6 street 2w
sh fit_features.bash 250.8 558.4 0.764 3.60 2.64 1066 735.2 3 burglary 2w
sh fit_features.bash 598.5 499.6 0.854 0.09 6.78 311 514.9 4 vehicle 1w
sh fit_features.bash 458.7 315.0 0.668 0.12 11.36 314 114.0 1 street 1m
sh fit_features.bash 372.5 415.5 0.815 3.66 2.48 735 213.1 3 street 3m
sh fit_features.bash 349.3 475.5 0.427 2.62 11.82 329 1149.6 5 vehicle 2w
sh fit_features.bash 442.5 350.0 0.011 3.57 5.48 142 1138.0 4 all 2m
sh fit_features.bash 362.7 303.3 0.098 0.12 11.32 1194 1093.0 4 vehicle 1m
sh fit_features.bash 397.5 477.3 0.293 1.30 6.90 567 1171.0 6 vehicle 3m
sh fit_features.bash 567.3 265.5 0.104 3.99 4.03 416 241.1 5 vehicle 3m
sh fit_features.bash 409.5 374.2 0.563 1.85 9.30 959 356.7 3 burglary 3m
sh fit_features.bash 250.7 250.8 0.114 2.18 2.59 818 220.4 2 street 1w
sh fit_features.bash 344.8 496.4 0.402 0.17 2.86 959 181.8 1 vehicle 3m
sh fit_features.bash 287.2 265.1 0.310 1.78 7.69 335 827.4 2 vehicle 1m
sh fit_features.bash 470.1 371.8 0.755 1.94 7.84 930 735.7 1 vehicle 3m
sh fit_features.bash 387.8 299.3 0.131 1.15 2.01 363 792.1 4 all 2w
sh fit_features.bash 285.3 534.7 0.801 0.21 0.48 58 225.9 2 all 1w
sh fit_features.bash 497.5 495.3 0.334 0.85 2.18 186 565.9 5 vehicle 1m
sh fit_features.bash 561.6 396.1 0.010 2.25 9.95 413 153.2 2 street 2w
sh fit_features.bash 426.0 371.5 0.200 0.82 3.36 445 722.9 3 vehicle 3m
sh fit_features.bash 459.9 460.0 0.815 3.20 10.01 148 893.3 3 burglary 2m
sh fit_features.bash 334.9 359.3 0.592 0.67 2.73 1186 1039.3 4 all 3m
sh fit_features.bash 536.7 384.5 0.048 1.02 10.41 731 189.6 1 burglary 2w
sh fit_features.bash 566.0 412.1 0.712 0.39 2.59 685 1038.5 2 street 2m
sh fit_features.bash 517.4 316.9 0.110 1.69 9.19 635 247.2 1 burglary 1m
sh fit_features.bash 529.2 415.2 0.717 3.09 6.75 1071 1194.7 6 street 3m
sh fit_features.bash 490.1 314.4 0.862 3.68 2.55 279 522.4 6 street 3m
sh fit_features.bash 569.2 287.1 0.689 3.54 4.16 936 750.1 5 all 2w
sh fit_features.bash 485.2 491.0 0.356 1.26 10.98 635 245.4 1 vehicle 2w
sh fit_features.bash 290.3 359.4 0.950 1.37 6.62 590 851.6 6 burglary 2m
sh fit_features.bash 348.4 360.8 0.908 2.51 8.14 525 707.4 1 all 3m
sh fit_features.bash 302.8 511.2 0.857 3.56 6.31 681 793.5 1 burglary 1w
sh fit_features.bash 495.3 280.9 0.341 3.84 5.95 393 974.8 3 burglary 2m
sh fit_features.bash 408.0 441.5 0.921 0.26 6.97 957 491.7 4 all 3m
sh fit_features.bash 269.8 432.4 0.986 1.70 0.79 386 601.3 1 vehicle 2m
sh fit_features.bash 484.7 371.0 0.765 2.64 5.96 535 160.6 3 all 1m
sh fit_features.bash 438.2 331.7 0.721 3.09 6.88 426 834.8 1 all 1m
sh fit_features.bash 457.8 314.8 0.383 2.51 10.54 1083 853.8 3 all 3m
sh fit_features.bash 325.3 553.2 0.632 1.32 1.34 310 809.2 5 all 2w
sh fit_features.bash 265.5 438.4 0.217 3.84 8.49 116 224.8 1 street 2w
sh fit_features.bash 552.8 432.4 0.640 2.68 9.10 941 653.0 1 all 1m
sh fit_features.bash 488.5 356.4 0.418 1.02 11.54 887 723.7 6 all 3m
sh fit_features.bash 254.5 583.6 0.594 3.95 8.00 613 242.5 4 burglary 2m
sh fit_features.bash 470.7 271.7 0.933 2.10 9.24 522 229.7 1 burglary 2w
sh fit_features.bash 431.2 352.9 0.881 0.43 11.55 196 804.4 5 burglary 2w
