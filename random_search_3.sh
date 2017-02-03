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

sh fit_features.bash 537.3 484.9 0.965 0.98 9.82 350 440.7 1 burglary 3m
sh fit_features.bash 340.7 466.6 0.722 0.77 5.60 777 1108.8 5 vehicle 1m
sh fit_features.bash 371.3 529.8 0.648 2.67 6.60 513 1090.9 8 street 3m
sh fit_features.bash 537.0 287.9 0.878 2.47 9.60 332 174.0 4 all 3m
sh fit_features.bash 529.6 283.6 0.282 1.01 11.98 763 623.8 3 all 2m
sh fit_features.bash 395.4 479.2 0.775 2.72 9.27 553 1078.3 7 street 1w
sh fit_features.bash 461.7 490.8 0.772 0.02 0.35 256 373.2 4 all 2m
sh fit_features.bash 484.7 549.6 0.083 0.92 2.32 172 564.3 1 burglary 2m
sh fit_features.bash 256.2 595.9 0.497 2.07 10.27 216 1033.5 8 burglary 2m
sh fit_features.bash 476.2 297.6 0.313 1.15 9.39 412 936.3 6 burglary 2w
sh fit_features.bash 268.6 540.3 0.825 2.81 11.22 386 502.2 8 vehicle 3m
sh fit_features.bash 438.5 305.6 0.192 3.29 7.83 840 133.6 2 burglary 2w
sh fit_features.bash 529.3 566.3 0.416 3.02 11.67 124 532.6 8 all 2m
sh fit_features.bash 287.2 524.7 0.225 2.19 2.83 245 1001.4 2 street 2w
sh fit_features.bash 498.7 277.6 0.056 0.79 7.73 1117 129.1 4 burglary 1m
sh fit_features.bash 408.5 547.0 0.498 0.20 6.40 367 974.1 8 street 2w
sh fit_features.bash 507.1 366.4 0.501 3.40 9.17 849 857.1 1 vehicle 2m
sh fit_features.bash 495.3 439.2 0.668 2.75 2.10 208 799.3 3 vehicle 2w
sh fit_features.bash 278.6 493.1 0.369 1.84 2.76 799 170.4 6 vehicle 3m
sh fit_features.bash 456.2 288.4 0.633 1.07 7.48 170 755.3 8 all 1w
sh fit_features.bash 335.1 470.5 0.986 3.98 4.95 553 282.3 2 burglary 1w
sh fit_features.bash 254.1 473.8 0.421 3.38 4.46 517 164.2 8 burglary 1m
sh fit_features.bash 403.6 453.7 0.783 1.92 8.49 1017 941.6 5 all 2m
sh fit_features.bash 399.4 373.2 0.184 1.35 4.01 972 829.8 5 street 2w
sh fit_features.bash 488.4 342.0 0.657 0.71 9.61 387 942.6 6 vehicle 1m
sh fit_features.bash 517.8 559.5 0.756 0.40 9.80 506 1191.8 4 vehicle 2m
sh fit_features.bash 402.0 515.2 0.448 2.78 8.98 153 1019.7 6 vehicle 3m
sh fit_features.bash 377.1 417.7 0.649 3.30 5.16 532 268.9 7 all 3m
sh fit_features.bash 486.4 327.9 0.998 2.55 4.01 330 799.3 2 vehicle 3m
sh fit_features.bash 516.1 584.6 0.318 3.40 5.21 859 525.7 5 all 3m
sh fit_features.bash 363.3 359.8 0.721 2.67 2.31 590 413.5 1 burglary 3m
sh fit_features.bash 447.0 443.6 0.558 2.96 6.54 993 885.7 2 vehicle 2m
sh fit_features.bash 552.7 459.6 0.504 2.16 7.05 785 1054.7 6 street 2m
sh fit_features.bash 367.4 334.3 0.712 2.32 8.21 153 1010.0 5 vehicle 2w
sh fit_features.bash 409.8 339.8 0.962 0.13 11.31 60 870.5 2 all 1m
sh fit_features.bash 264.1 421.9 0.659 3.26 7.54 437 173.1 4 all 2m
sh fit_features.bash 263.5 462.9 0.887 3.86 11.98 1156 596.6 8 all 2w
sh fit_features.bash 368.2 400.8 0.391 3.16 2.95 103 1068.3 6 all 1w
sh fit_features.bash 502.1 473.4 0.471 2.52 11.64 918 606.1 6 burglary 2w
sh fit_features.bash 445.3 489.3 0.827 0.08 8.46 646 664.3 2 burglary 1m
sh fit_features.bash 516.5 414.1 0.495 3.06 3.78 433 886.3 1 vehicle 1m
sh fit_features.bash 435.2 403.6 0.235 3.05 6.69 364 689.6 6 all 1w
sh fit_features.bash 267.8 304.1 0.446 0.98 1.38 175 953.2 3 all 3m
sh fit_features.bash 447.0 332.3 0.340 2.33 11.83 678 441.4 2 burglary 2m
sh fit_features.bash 490.8 329.0 0.251 3.30 10.08 704 130.6 7 all 1m
sh fit_features.bash 523.0 445.5 0.637 0.92 9.94 214 318.9 5 street 3m
sh fit_features.bash 312.0 343.2 0.922 3.10 1.60 1049 444.9 4 all 1m
sh fit_features.bash 272.0 332.4 0.699 3.11 0.51 153 1197.0 2 street 2w
sh fit_features.bash 325.8 586.2 0.961 1.16 1.10 600 989.0 1 all 3m
sh fit_features.bash 488.4 525.8 0.552 0.59 1.90 154 106.3 6 vehicle 1w
sh fit_features.bash 291.5 494.2 0.776 3.40 4.41 113 868.3 4 all 2w
sh fit_features.bash 439.4 542.3 0.991 1.61 7.02 458 846.9 7 burglary 1m
sh fit_features.bash 302.7 522.1 0.262 1.78 11.79 271 900.9 7 burglary 2m
sh fit_features.bash 262.7 360.3 0.104 0.44 7.19 594 960.2 2 street 1m
sh fit_features.bash 362.9 559.6 0.658 2.55 1.60 457 1036.6 5 vehicle 2w
sh fit_features.bash 261.5 350.1 0.195 3.24 11.54 123 351.4 2 burglary 1m
sh fit_features.bash 468.2 536.1 0.385 3.55 11.19 78 935.5 6 all 1m
sh fit_features.bash 454.1 354.6 0.716 2.43 0.99 850 679.0 5 burglary 1w
sh fit_features.bash 279.9 588.9 0.523 1.18 8.70 458 546.3 2 vehicle 1w
sh fit_features.bash 486.7 439.5 0.863 0.68 10.35 826 176.5 5 vehicle 1w
sh fit_features.bash 300.5 466.4 0.661 1.40 4.68 861 876.3 8 vehicle 3m
sh fit_features.bash 433.1 546.3 0.820 3.19 5.52 468 576.0 7 vehicle 1w
sh fit_features.bash 519.4 430.9 0.384 2.51 8.69 871 1050.7 6 all 1w
sh fit_features.bash 318.2 415.5 0.293 0.61 10.43 1142 830.5 3 street 2w
sh fit_features.bash 313.3 519.9 0.936 1.81 0.27 559 259.2 4 all 1w
sh fit_features.bash 349.2 575.5 0.070 1.29 9.55 510 879.6 5 vehicle 3m
sh fit_features.bash 268.5 333.6 0.132 0.34 9.80 680 107.4 5 all 3m
sh fit_features.bash 274.9 336.9 0.664 3.67 1.32 404 692.5 6 street 3m
sh fit_features.bash 557.3 474.9 0.731 3.14 10.01 1033 258.4 8 burglary 1m
sh fit_features.bash 353.5 294.7 0.871 2.69 8.82 1129 349.2 7 burglary 3m
sh fit_features.bash 508.0 250.1 0.563 3.53 7.00 124 618.3 4 burglary 1w
sh fit_features.bash 534.3 482.6 0.813 3.02 6.66 906 1113.3 8 burglary 2w
sh fit_features.bash 418.3 354.4 0.423 1.79 8.56 471 414.1 5 burglary 2w
sh fit_features.bash 408.5 388.1 0.081 2.57 8.79 135 612.3 7 all 2m
sh fit_features.bash 513.9 483.8 0.602 2.25 7.22 135 1002.9 2 burglary 2w
sh fit_features.bash 599.7 464.0 0.147 3.52 11.45 733 402.2 6 street 1w
sh fit_features.bash 554.6 597.0 0.874 3.62 4.72 438 1013.1 2 all 2m
sh fit_features.bash 393.4 581.2 0.477 0.88 3.15 125 1106.8 3 street 1w
sh fit_features.bash 421.4 302.5 0.528 0.28 7.43 485 915.4 1 burglary 1m
sh fit_features.bash 430.4 283.0 0.702 1.78 8.25 967 1197.8 5 all 1w
sh fit_features.bash 400.3 394.1 0.610 3.79 10.45 639 970.4 7 street 2w
sh fit_features.bash 366.4 412.1 0.358 2.25 9.68 589 1081.7 6 street 1m
sh fit_features.bash 320.7 486.9 0.061 1.50 4.76 913 357.4 3 all 1w
sh fit_features.bash 359.4 351.8 0.059 3.40 10.89 501 486.9 7 street 3m
sh fit_features.bash 295.9 258.7 0.666 1.78 2.10 1188 472.3 5 vehicle 2w
sh fit_features.bash 466.7 483.3 0.486 1.71 9.57 89 979.1 2 burglary 2w
sh fit_features.bash 591.8 333.8 0.949 2.63 7.92 275 209.7 7 vehicle 3m
sh fit_features.bash 444.7 461.6 0.371 3.71 7.91 683 102.5 1 burglary 3m
sh fit_features.bash 525.1 550.4 0.253 2.89 6.35 857 100.6 4 all 1m
sh fit_features.bash 323.4 294.4 0.657 1.83 5.07 221 557.8 6 all 1w
sh fit_features.bash 293.1 532.2 0.396 0.63 3.33 147 402.7 2 burglary 3m
sh fit_features.bash 255.5 577.5 0.257 3.03 10.42 818 218.6 1 burglary 3m
sh fit_features.bash 338.6 341.5 0.542 4.00 0.93 221 916.8 7 vehicle 2m
sh fit_features.bash 590.8 460.4 0.981 2.40 7.59 451 105.9 5 burglary 2m
sh fit_features.bash 377.4 377.1 0.159 2.46 1.79 652 152.6 8 vehicle 3m
sh fit_features.bash 476.4 379.9 0.630 1.52 7.32 1050 927.2 6 street 2m
sh fit_features.bash 429.4 427.8 0.823 1.77 3.67 813 219.4 4 vehicle 1w
sh fit_features.bash 321.6 555.9 0.288 1.64 5.93 679 307.9 2 all 2m
sh fit_features.bash 292.9 429.1 0.724 0.92 4.49 636 819.3 6 vehicle 1m
sh fit_features.bash 414.8 316.8 0.161 3.70 9.04 130 1131.9 7 vehicle 2m
