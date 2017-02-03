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

sh fit_features.bash 396.5 454.0 0.190 3.08 9.39 966 208.7 1 burglary 2w
sh fit_features.bash 516.8 541.2 0.969 2.40 3.24 756 763.1 1 burglary 1m
sh fit_features.bash 365.7 316.8 0.300 1.91 6.38 453 690.3 2 all 2w
sh fit_features.bash 494.8 569.8 0.286 2.47 11.62 484 178.0 1 burglary 1w
sh fit_features.bash 372.1 410.1 0.130 1.11 5.22 525 931.6 8 vehicle 2w
sh fit_features.bash 291.1 383.5 0.834 1.78 1.88 334 759.8 8 vehicle 1w
sh fit_features.bash 400.5 404.3 0.616 3.25 10.95 553 966.5 2 all 1w
sh fit_features.bash 393.0 352.2 0.964 3.81 4.41 793 854.0 6 burglary 1m
sh fit_features.bash 322.1 559.1 0.236 2.59 6.08 1044 856.9 2 street 2w
sh fit_features.bash 393.9 512.0 0.422 3.03 7.97 70 711.5 1 all 1m
sh fit_features.bash 284.2 314.7 0.146 2.89 7.30 556 840.4 6 street 2w
sh fit_features.bash 373.7 526.3 0.132 0.32 4.30 227 458.2 4 all 3m
sh fit_features.bash 425.5 344.0 0.498 3.83 5.60 250 203.7 5 vehicle 1m
sh fit_features.bash 566.3 489.0 0.001 0.40 4.63 74 1096.3 3 burglary 1w
sh fit_features.bash 265.7 595.1 0.738 0.80 1.66 97 764.7 3 street 1m
sh fit_features.bash 372.5 511.0 0.639 3.67 3.43 767 1137.1 3 street 2m
sh fit_features.bash 486.1 343.1 0.838 1.49 3.86 717 228.6 1 all 1w
sh fit_features.bash 571.4 489.2 0.555 0.40 5.17 858 370.1 5 all 1w
sh fit_features.bash 556.1 396.7 0.318 1.19 6.49 987 673.9 7 burglary 1m
sh fit_features.bash 571.0 515.4 0.290 1.05 6.26 96 345.3 8 burglary 2w
sh fit_features.bash 574.3 465.4 0.386 0.56 3.99 1038 957.9 3 burglary 2m
sh fit_features.bash 464.7 286.9 0.451 2.87 10.55 270 1083.2 5 vehicle 2w
sh fit_features.bash 502.9 583.5 0.927 3.91 2.26 879 984.6 6 all 3m
sh fit_features.bash 456.1 493.9 0.781 3.55 3.95 753 383.1 6 street 2w
sh fit_features.bash 355.2 407.2 0.823 1.69 9.49 950 140.3 2 vehicle 2w
sh fit_features.bash 419.6 594.6 0.514 1.69 9.06 152 1010.1 1 street 1w
sh fit_features.bash 458.5 488.2 0.233 3.61 2.72 1086 1177.0 1 all 1w
sh fit_features.bash 466.9 261.5 0.793 0.30 9.34 330 122.7 6 burglary 2w
sh fit_features.bash 395.3 516.9 0.317 0.96 0.63 1085 186.4 4 burglary 1m
sh fit_features.bash 400.6 469.7 0.676 2.51 9.86 442 1123.3 1 all 1m
sh fit_features.bash 297.5 350.6 0.303 1.73 5.39 401 1071.6 2 vehicle 3m
sh fit_features.bash 272.1 309.9 0.323 3.95 1.96 494 314.6 8 vehicle 2w
sh fit_features.bash 574.0 405.1 0.214 0.35 11.01 689 692.2 3 all 1w
sh fit_features.bash 548.0 303.6 0.506 2.12 7.17 271 667.1 7 burglary 2m
sh fit_features.bash 491.0 584.5 0.714 2.92 2.13 337 820.7 6 all 3m
sh fit_features.bash 288.1 505.5 0.816 3.10 9.68 804 1148.4 8 burglary 1w
sh fit_features.bash 473.6 266.3 0.301 3.75 6.19 254 263.8 4 all 1w
sh fit_features.bash 390.6 542.5 0.763 2.90 6.67 661 763.0 6 burglary 3m
sh fit_features.bash 258.1 588.9 0.404 3.12 9.83 124 529.0 6 all 2m
sh fit_features.bash 430.8 310.2 0.552 2.28 7.26 949 255.2 8 all 2w
sh fit_features.bash 434.2 416.1 0.327 1.24 9.65 903 574.4 8 street 2m
sh fit_features.bash 572.0 519.9 0.853 0.39 1.42 87 798.4 2 all 1w
sh fit_features.bash 490.5 379.0 0.839 0.25 1.31 116 301.0 6 all 1m
sh fit_features.bash 549.3 475.9 0.007 1.80 6.21 248 794.5 3 burglary 3m
sh fit_features.bash 597.2 345.7 0.469 0.08 2.71 508 622.0 7 all 1m
sh fit_features.bash 406.0 539.8 0.702 1.52 2.48 199 166.0 2 vehicle 2m
sh fit_features.bash 513.9 501.9 0.470 0.69 1.33 635 1011.9 1 street 2w
sh fit_features.bash 346.5 286.5 0.077 2.15 8.34 513 1123.6 4 street 1m
sh fit_features.bash 264.1 367.1 0.970 3.87 11.01 173 302.5 5 street 1w
sh fit_features.bash 580.6 501.3 0.648 3.42 0.43 1128 634.2 3 vehicle 2w
sh fit_features.bash 547.2 325.0 0.227 0.10 5.45 1055 643.1 3 vehicle 1m
sh fit_features.bash 576.8 469.9 0.190 0.14 0.14 756 489.1 2 all 2w
sh fit_features.bash 403.1 502.0 0.431 0.21 10.24 337 734.4 2 vehicle 1w
sh fit_features.bash 313.0 543.6 0.486 1.30 3.56 1132 240.6 8 all 2w
sh fit_features.bash 362.3 539.0 0.005 3.12 1.31 478 279.8 7 vehicle 2m
sh fit_features.bash 377.5 519.8 0.626 1.92 0.94 894 529.6 2 all 2m
sh fit_features.bash 408.6 353.0 0.540 0.87 7.08 863 1049.9 8 burglary 1w
sh fit_features.bash 434.3 269.9 0.261 1.86 9.63 509 600.8 2 all 3m
sh fit_features.bash 386.7 489.3 0.332 1.98 4.17 323 304.7 5 all 2w
sh fit_features.bash 419.5 558.1 0.677 2.77 9.71 495 388.4 4 street 2m
sh fit_features.bash 348.9 427.8 0.516 2.47 11.74 1074 708.2 8 burglary 2m
sh fit_features.bash 435.0 489.0 0.538 2.98 10.75 379 170.4 7 burglary 2m
sh fit_features.bash 400.0 486.6 0.000 1.38 9.20 1070 1027.4 3 burglary 3m
sh fit_features.bash 253.3 569.3 0.542 2.66 7.74 748 1160.4 3 street 1w
sh fit_features.bash 250.7 330.0 0.325 3.75 8.85 236 683.7 1 street 1m
sh fit_features.bash 303.8 502.1 0.404 1.36 10.45 1066 351.4 3 burglary 3m
sh fit_features.bash 384.5 324.5 0.940 2.69 4.74 952 633.6 7 vehicle 3m
sh fit_features.bash 269.7 583.8 0.003 2.75 1.64 806 297.2 3 all 1w
sh fit_features.bash 558.5 474.1 0.688 0.38 8.22 538 194.0 3 burglary 3m
sh fit_features.bash 525.1 427.7 0.828 1.36 2.52 376 464.3 3 burglary 1w
sh fit_features.bash 436.2 460.7 0.744 1.67 11.05 424 225.9 5 vehicle 1w
sh fit_features.bash 412.9 373.0 0.344 0.63 9.67 1049 289.2 5 vehicle 1m
sh fit_features.bash 446.6 435.1 0.900 0.07 7.51 573 700.1 8 vehicle 2m
sh fit_features.bash 443.2 392.6 0.495 0.77 0.28 782 199.3 5 vehicle 2m
sh fit_features.bash 570.1 286.0 0.131 1.55 4.43 848 508.6 2 vehicle 2w
sh fit_features.bash 466.7 530.0 0.060 1.92 8.19 246 103.2 4 burglary 1m
sh fit_features.bash 404.1 379.8 0.329 3.90 7.93 735 858.6 4 burglary 1m
sh fit_features.bash 507.0 250.4 0.079 3.82 5.27 993 970.9 1 street 3m
sh fit_features.bash 270.5 422.5 0.746 0.85 11.26 739 255.0 6 vehicle 2w
sh fit_features.bash 508.7 270.6 0.243 1.55 9.33 814 1020.4 5 vehicle 2m
sh fit_features.bash 396.9 300.5 0.580 0.60 9.31 1115 677.6 6 vehicle 3m
sh fit_features.bash 405.6 519.8 0.773 2.85 0.58 1200 1134.7 5 vehicle 1m
sh fit_features.bash 472.1 359.3 0.420 1.53 11.13 1189 648.5 4 vehicle 3m
sh fit_features.bash 551.8 522.9 0.601 2.58 0.09 1020 1165.2 2 burglary 3m
sh fit_features.bash 283.5 381.5 0.803 1.12 5.20 328 1166.9 8 street 2m
sh fit_features.bash 431.0 512.4 0.074 3.21 4.50 1107 862.8 3 all 1w
sh fit_features.bash 277.8 498.5 0.498 1.23 11.84 1126 677.5 5 all 2m
sh fit_features.bash 446.8 320.4 0.255 0.63 9.72 318 205.7 3 burglary 2w
sh fit_features.bash 386.2 441.6 0.540 2.49 9.32 488 925.5 2 vehicle 1w
sh fit_features.bash 383.0 383.0 0.897 1.35 8.21 488 1134.6 7 all 2w
sh fit_features.bash 448.2 416.5 0.328 2.56 9.46 341 213.2 4 burglary 1m
sh fit_features.bash 381.7 471.7 0.537 2.73 5.73 1037 733.3 4 all 1w
sh fit_features.bash 419.6 524.3 0.406 2.17 11.06 670 1011.4 4 street 1m
sh fit_features.bash 394.4 581.3 0.036 2.58 8.33 76 1026.8 4 street 1w
sh fit_features.bash 456.4 538.9 0.400 0.80 4.38 571 539.7 3 burglary 2w
sh fit_features.bash 419.2 430.6 0.864 3.98 8.36 935 349.0 8 all 2w
sh fit_features.bash 295.2 402.6 0.482 1.36 1.13 156 361.0 8 vehicle 1m
sh fit_features.bash 348.2 329.5 0.472 1.47 1.70 173 1153.9 4 burglary 1w
sh fit_features.bash 370.3 413.7 0.975 3.76 7.10 976 214.2 7 all 2m
sh fit_features.bash 391.8 504.8 0.013 3.97 4.95 736 173.8 4 vehicle 3m
