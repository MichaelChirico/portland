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

sh fit_features.bash 471.8 557.6 0.155 0.58 3.02 253 632.7 5 all 1m
sh fit_features.bash 571.5 437.2 0.129 1.22 10.35 96 1126.9 3 street 1w
sh fit_features.bash 512.5 589.3 0.497 3.32 4.40 1048 156.1 2 all 3m
sh fit_features.bash 264.0 262.2 0.120 3.24 9.73 606 457.6 4 burglary 3m
sh fit_features.bash 370.8 460.7 0.074 2.46 4.14 934 278.5 6 vehicle 3m
sh fit_features.bash 278.3 531.9 0.062 3.00 2.27 1064 273.7 4 street 1w
sh fit_features.bash 551.3 320.2 0.177 2.61 5.79 250 1038.7 3 burglary 2m
sh fit_features.bash 425.6 424.4 0.584 0.76 10.51 1024 799.5 3 all 1w
sh fit_features.bash 283.1 569.0 0.615 3.61 5.21 706 327.8 6 street 2m
sh fit_features.bash 392.7 459.2 0.655 1.80 2.15 784 395.9 3 vehicle 1m
sh fit_features.bash 341.7 482.6 0.874 0.23 8.55 521 1048.5 3 vehicle 3m
sh fit_features.bash 319.3 373.8 0.773 3.72 7.11 134 697.5 3 burglary 3m
sh fit_features.bash 589.9 437.5 0.808 1.74 11.54 896 125.8 2 street 2w
sh fit_features.bash 253.2 534.5 0.263 0.59 3.80 555 1081.5 1 street 2m
sh fit_features.bash 449.9 474.5 0.484 3.59 5.66 234 804.9 3 street 1m
sh fit_features.bash 557.9 517.0 0.694 1.78 7.83 69 884.9 4 burglary 2w
sh fit_features.bash 262.5 471.0 0.539 0.77 6.36 56 960.1 4 vehicle 3m
sh fit_features.bash 348.8 567.3 0.263 2.90 5.44 943 634.3 1 vehicle 2w
sh fit_features.bash 579.6 408.8 0.306 0.43 6.11 919 103.6 5 all 3m
sh fit_features.bash 338.9 333.3 0.878 2.90 0.18 414 362.6 4 all 2w
sh fit_features.bash 592.2 555.8 0.313 2.97 0.54 1017 534.4 1 burglary 2w
sh fit_features.bash 389.8 558.6 0.471 1.26 3.62 330 596.2 1 burglary 2w
sh fit_features.bash 415.2 429.9 0.627 1.00 0.39 1083 489.0 5 street 3m
sh fit_features.bash 393.9 490.6 0.538 3.70 7.93 402 215.6 1 all 1m
sh fit_features.bash 463.8 339.3 0.639 3.55 11.80 921 385.0 6 street 1m
sh fit_features.bash 505.2 439.0 0.489 0.23 6.96 451 896.1 1 all 2w
sh fit_features.bash 419.2 388.4 0.142 3.72 9.03 422 210.8 5 vehicle 2m
sh fit_features.bash 306.9 287.7 0.242 3.89 8.63 1020 883.2 3 burglary 1m
sh fit_features.bash 393.7 397.0 0.540 2.01 0.01 1134 1117.9 5 vehicle 1w
sh fit_features.bash 448.6 430.6 0.730 2.45 6.33 228 502.4 5 all 2m
sh fit_features.bash 422.4 486.7 0.400 1.54 9.84 924 900.7 3 vehicle 3m
sh fit_features.bash 275.9 362.3 0.136 1.87 10.70 381 1105.1 2 street 1m
sh fit_features.bash 564.0 575.2 0.471 0.38 7.84 130 698.1 3 vehicle 1w
sh fit_features.bash 371.8 445.5 0.616 2.99 8.90 233 1034.7 1 all 3m
sh fit_features.bash 509.4 403.3 0.736 1.45 8.43 1094 1062.0 6 all 2w
sh fit_features.bash 418.3 565.3 0.718 2.93 2.74 923 924.5 2 vehicle 1w
sh fit_features.bash 526.0 575.7 0.796 2.24 2.77 590 557.7 1 street 2w
sh fit_features.bash 446.4 299.7 0.263 2.16 3.14 52 586.1 5 street 1m
sh fit_features.bash 526.8 355.3 0.775 1.91 5.53 1160 819.9 1 burglary 3m
sh fit_features.bash 505.4 390.4 0.630 1.00 3.46 541 576.6 4 vehicle 2m
sh fit_features.bash 265.0 322.8 0.969 2.45 3.16 625 1175.5 2 all 1m
sh fit_features.bash 278.3 554.6 0.808 1.27 4.19 164 666.3 1 all 1w
sh fit_features.bash 389.7 375.8 0.954 1.21 10.40 294 1145.2 3 all 1m
sh fit_features.bash 406.1 371.6 0.370 1.26 9.68 606 382.4 6 burglary 3m
sh fit_features.bash 467.1 381.3 0.485 3.87 5.39 1143 304.1 4 vehicle 2m
sh fit_features.bash 258.1 475.8 0.891 3.69 3.37 928 957.0 1 all 2m
sh fit_features.bash 417.9 386.9 0.701 1.84 2.10 456 612.0 2 burglary 1w
sh fit_features.bash 553.6 479.5 0.293 0.56 8.83 128 797.0 6 vehicle 1w
sh fit_features.bash 311.6 436.1 0.926 0.37 6.24 1152 1022.7 2 burglary 1m
sh fit_features.bash 282.7 379.3 0.421 3.96 11.53 833 876.8 3 all 2w
sh fit_features.bash 401.8 431.8 0.507 2.51 2.91 1164 1145.0 3 street 2w
sh fit_features.bash 490.1 452.1 0.165 3.25 11.87 287 337.1 6 street 2w
sh fit_features.bash 402.6 467.5 0.618 0.90 1.66 736 558.3 5 street 3m
sh fit_features.bash 408.9 379.7 0.912 3.48 9.71 199 456.2 6 all 2m
sh fit_features.bash 382.5 501.1 0.771 3.78 10.49 359 1096.3 6 vehicle 2m
sh fit_features.bash 388.3 523.1 0.493 3.91 6.37 678 782.9 6 all 2m
sh fit_features.bash 516.9 285.8 0.746 0.58 1.67 730 1049.2 1 street 1w
sh fit_features.bash 286.3 538.0 0.562 3.33 6.97 1000 620.2 4 vehicle 1m
sh fit_features.bash 560.3 489.9 0.562 2.51 4.87 608 249.1 1 burglary 2m
sh fit_features.bash 585.7 492.1 0.100 2.26 3.06 378 493.9 3 all 1m
sh fit_features.bash 469.9 259.2 0.501 2.74 0.20 1034 761.3 4 all 1m
sh fit_features.bash 254.4 567.7 0.412 1.12 10.40 622 1001.1 2 vehicle 3m
sh fit_features.bash 566.1 442.8 0.613 2.53 11.73 711 880.0 1 all 2w
sh fit_features.bash 293.5 262.1 0.861 0.15 9.91 440 1037.9 3 burglary 3m
sh fit_features.bash 381.2 542.9 0.414 3.82 11.43 1200 227.0 1 street 1m
sh fit_features.bash 537.4 448.7 0.961 3.96 0.99 471 1094.2 2 vehicle 1m
sh fit_features.bash 351.3 257.6 0.366 2.86 1.56 1046 1008.2 2 all 3m
sh fit_features.bash 349.8 427.1 0.026 0.47 3.92 430 514.0 3 street 2m
sh fit_features.bash 365.2 478.9 0.768 1.01 7.44 1034 127.3 2 all 1m
sh fit_features.bash 295.9 550.7 0.157 0.35 10.65 357 343.7 3 burglary 3m
sh fit_features.bash 453.5 566.0 0.629 2.12 10.56 184 844.9 4 burglary 3m
sh fit_features.bash 578.6 355.0 0.737 0.92 0.65 671 830.9 1 burglary 2w
sh fit_features.bash 286.6 271.0 0.724 0.15 6.08 960 560.6 6 burglary 3m
sh fit_features.bash 359.5 471.2 0.474 1.13 10.72 1181 1016.8 6 street 2w
sh fit_features.bash 495.3 521.7 0.479 2.54 8.63 159 739.2 6 burglary 2w
sh fit_features.bash 370.4 327.9 0.731 2.81 6.72 1107 997.6 2 burglary 3m
sh fit_features.bash 396.5 588.3 0.399 2.24 1.73 352 1113.5 2 all 1m
sh fit_features.bash 368.9 545.1 0.294 0.20 7.62 801 770.1 6 street 3m
sh fit_features.bash 588.6 262.2 0.541 0.12 8.87 806 568.7 1 street 2w
sh fit_features.bash 255.3 540.8 0.849 3.95 7.72 687 747.3 2 all 2w
sh fit_features.bash 523.9 507.9 0.553 1.55 0.61 338 856.3 3 vehicle 1w
sh fit_features.bash 527.8 361.6 0.802 2.30 7.88 703 255.3 5 street 1w
sh fit_features.bash 442.4 391.5 0.043 0.15 6.76 715 156.5 3 all 2m
sh fit_features.bash 395.6 524.2 0.527 2.89 7.46 538 955.3 6 street 2w
sh fit_features.bash 316.7 424.5 0.404 0.23 2.09 1113 378.2 4 all 3m
sh fit_features.bash 577.9 458.2 0.817 3.35 6.62 378 343.9 3 all 2w
sh fit_features.bash 561.8 480.4 0.343 1.54 6.18 512 826.1 6 burglary 2w
sh fit_features.bash 536.1 597.0 0.137 3.78 2.44 1200 770.8 1 burglary 1w
sh fit_features.bash 581.1 557.3 0.224 1.75 6.48 153 679.5 5 street 3m
sh fit_features.bash 574.1 519.4 0.574 2.23 8.90 341 814.9 3 vehicle 1m
sh fit_features.bash 512.4 262.5 0.078 1.03 11.69 1020 708.9 4 street 3m
sh fit_features.bash 599.2 290.3 0.538 0.84 11.21 83 685.0 4 burglary 2m
sh fit_features.bash 429.6 304.7 0.011 0.55 3.49 879 697.5 3 vehicle 1m
sh fit_features.bash 340.4 438.4 0.401 0.15 8.13 331 405.6 3 street 1w
sh fit_features.bash 316.5 316.9 0.833 0.90 8.49 735 529.2 2 vehicle 2m
sh fit_features.bash 537.1 382.2 0.622 0.33 4.45 410 795.6 4 all 1w
sh fit_features.bash 287.0 282.4 0.274 1.70 0.61 907 798.4 3 all 3m
sh fit_features.bash 421.4 337.3 0.184 1.47 10.97 834 907.6 6 all 1w
sh fit_features.bash 574.3 372.9 0.466 3.30 3.02 910 1014.8 6 vehicle 1w
sh fit_features.bash 599.6 523.0 0.557 3.24 2.21 1047 791.1 5 vehicle 1m
