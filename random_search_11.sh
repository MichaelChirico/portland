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

sh fit_features.bash 442.4 516.8 0.220 1.18 7.96 604 1047.2 3 burglary 2w
sh fit_features.bash 597.0 266.1 0.420 2.14 8.67 165 943.2 4 all 2m
sh fit_features.bash 261.0 353.0 0.744 1.41 7.32 973 1021.8 5 all 2m
sh fit_features.bash 258.7 499.0 0.129 1.64 4.54 366 505.3 6 all 1w
sh fit_features.bash 251.5 449.4 0.957 1.89 9.03 98 454.6 7 street 1w
sh fit_features.bash 325.2 399.3 0.076 2.13 10.36 1150 134.3 4 all 3m
sh fit_features.bash 431.1 368.6 0.195 0.72 3.15 492 1032.8 1 vehicle 3m
sh fit_features.bash 359.6 385.0 0.502 3.99 1.08 348 617.9 5 street 2m
sh fit_features.bash 474.4 472.2 0.469 2.67 1.95 656 556.6 1 street 1w
sh fit_features.bash 395.4 449.7 0.491 2.42 0.16 1134 339.7 1 street 1w
sh fit_features.bash 470.3 316.6 0.543 3.32 6.21 693 942.6 5 burglary 1w
sh fit_features.bash 274.6 270.5 0.921 3.53 2.67 246 1171.1 4 all 1w
sh fit_features.bash 431.9 266.1 0.301 3.17 7.14 469 519.9 8 all 1w
sh fit_features.bash 411.9 336.2 0.408 2.95 10.99 78 147.2 5 vehicle 2m
sh fit_features.bash 503.2 542.3 0.308 2.16 8.22 248 277.7 7 all 1w
sh fit_features.bash 580.6 434.4 0.309 3.76 3.95 516 1064.0 4 all 2m
sh fit_features.bash 279.5 543.4 0.287 0.73 5.25 186 320.5 3 street 1m
sh fit_features.bash 503.7 524.0 0.731 1.35 8.92 283 920.0 2 street 2m
sh fit_features.bash 293.4 570.4 0.256 0.49 1.58 551 986.4 3 vehicle 1w
sh fit_features.bash 519.4 512.8 0.684 2.10 7.27 859 1086.3 8 burglary 1w
sh fit_features.bash 359.7 276.1 0.330 2.31 3.52 913 664.9 1 vehicle 1m
sh fit_features.bash 252.8 309.3 0.360 2.63 3.67 506 905.5 5 all 1m
sh fit_features.bash 532.8 326.8 0.517 3.68 5.59 1049 1118.1 7 vehicle 2w
sh fit_features.bash 269.6 528.8 0.619 0.89 10.42 672 644.7 8 all 1m
sh fit_features.bash 463.0 260.3 0.838 0.85 2.31 452 381.2 6 vehicle 3m
sh fit_features.bash 504.4 297.0 0.179 0.15 9.09 943 287.6 5 all 1m
sh fit_features.bash 516.4 475.6 0.600 0.52 1.10 802 927.2 4 burglary 3m
sh fit_features.bash 510.6 291.4 0.943 2.95 4.28 108 293.8 2 burglary 3m
sh fit_features.bash 559.2 309.7 0.357 3.65 10.16 870 611.4 5 street 2w
sh fit_features.bash 577.2 385.0 0.837 3.00 2.23 300 271.1 6 burglary 2w
sh fit_features.bash 361.1 362.2 0.594 3.79 11.99 825 166.8 5 street 2m
sh fit_features.bash 579.8 528.1 0.074 3.64 11.22 695 1145.7 2 vehicle 2m
sh fit_features.bash 527.1 540.3 0.143 1.80 6.75 647 1146.5 5 all 2w
sh fit_features.bash 359.7 407.1 0.574 2.58 4.55 957 205.0 4 all 1w
sh fit_features.bash 553.6 376.6 0.814 3.79 1.62 190 1142.2 1 vehicle 2w
sh fit_features.bash 256.9 529.6 0.148 0.97 2.51 576 443.0 5 burglary 1m
sh fit_features.bash 569.6 346.1 0.809 2.51 8.52 292 509.6 7 burglary 1w
sh fit_features.bash 390.9 409.3 0.564 2.19 2.42 191 361.7 3 all 2m
sh fit_features.bash 532.8 485.6 0.707 1.56 8.85 1181 307.4 7 street 1w
sh fit_features.bash 253.8 547.0 0.221 1.82 9.13 900 1013.5 2 vehicle 1m
sh fit_features.bash 558.0 337.5 0.645 3.26 8.43 1061 1068.4 7 all 2m
sh fit_features.bash 408.5 276.9 0.179 1.37 8.78 516 988.7 6 all 2m
sh fit_features.bash 500.5 252.2 0.587 3.43 0.81 560 498.7 5 street 1w
sh fit_features.bash 429.8 536.6 0.225 3.00 11.11 291 364.0 4 street 2w
sh fit_features.bash 420.7 574.5 0.797 0.45 1.11 224 362.4 8 vehicle 3m
sh fit_features.bash 309.8 570.0 0.907 3.85 7.09 251 768.2 4 street 2w
sh fit_features.bash 379.5 417.0 0.676 1.84 7.99 827 955.0 8 burglary 1m
sh fit_features.bash 351.8 412.8 0.327 0.51 8.78 156 416.1 4 burglary 1w
sh fit_features.bash 503.5 536.8 0.650 3.68 9.51 785 254.4 1 vehicle 2m
sh fit_features.bash 406.3 333.9 0.041 1.66 0.95 379 972.2 7 vehicle 3m
sh fit_features.bash 434.3 479.8 0.572 0.39 11.05 253 362.6 1 vehicle 1w
sh fit_features.bash 454.4 339.7 0.102 3.57 1.26 1008 968.1 8 vehicle 3m
sh fit_features.bash 353.2 418.7 0.992 1.36 8.69 1135 801.1 5 vehicle 1m
sh fit_features.bash 487.8 291.2 0.291 3.02 3.55 874 497.4 1 vehicle 1m
sh fit_features.bash 347.8 392.6 0.202 0.11 5.63 360 649.3 8 all 2w
sh fit_features.bash 265.5 403.5 0.873 3.40 9.77 505 1004.1 8 all 1m
sh fit_features.bash 347.8 405.3 0.654 3.66 8.11 1038 348.1 1 burglary 1m
sh fit_features.bash 482.9 596.4 0.038 3.59 2.59 1108 429.5 3 all 3m
sh fit_features.bash 338.5 577.5 0.005 0.67 2.53 587 1173.7 3 all 1w
sh fit_features.bash 526.2 255.0 0.656 2.44 2.52 1001 912.9 1 all 1m
sh fit_features.bash 274.1 558.3 0.868 0.00 8.13 314 611.2 3 burglary 3m
sh fit_features.bash 562.7 492.5 0.287 1.51 11.42 68 747.3 1 burglary 2m
sh fit_features.bash 533.9 274.2 0.981 1.86 4.33 301 237.2 7 burglary 1w
sh fit_features.bash 461.1 252.0 0.281 3.73 1.45 640 341.6 6 street 3m
sh fit_features.bash 251.9 509.1 0.415 1.65 3.37 1057 198.7 1 burglary 2m
sh fit_features.bash 588.8 462.4 0.914 2.41 2.38 849 134.7 2 street 2m
sh fit_features.bash 317.1 473.3 0.519 3.68 0.99 135 792.7 6 all 1w
sh fit_features.bash 485.9 421.2 0.343 2.87 1.85 768 701.1 7 street 3m
sh fit_features.bash 527.8 368.2 0.890 2.86 6.60 192 461.3 8 vehicle 1m
sh fit_features.bash 461.3 311.8 0.740 1.42 6.81 538 386.6 2 street 1w
sh fit_features.bash 432.7 278.5 0.472 2.66 11.73 309 695.1 7 all 1w
sh fit_features.bash 566.5 387.5 0.185 1.26 0.49 683 1079.5 3 street 1w
sh fit_features.bash 474.3 540.5 0.641 3.06 1.42 1198 733.6 1 all 1w
sh fit_features.bash 362.8 353.7 0.178 0.95 7.28 567 891.9 7 vehicle 2w
sh fit_features.bash 318.2 449.0 0.988 2.73 9.85 1198 984.2 4 vehicle 1w
sh fit_features.bash 488.6 335.6 0.673 3.08 3.16 233 822.4 1 burglary 1m
sh fit_features.bash 394.0 485.2 0.766 1.99 7.69 560 809.5 6 street 2m
sh fit_features.bash 521.7 512.3 0.923 0.56 2.48 863 613.5 5 all 1w
sh fit_features.bash 335.2 299.9 0.225 3.44 0.25 197 861.7 8 burglary 2w
sh fit_features.bash 393.2 369.2 0.768 2.25 11.51 451 698.2 6 all 2w
sh fit_features.bash 415.1 555.9 0.732 1.02 11.19 924 1065.5 5 all 1m
sh fit_features.bash 416.5 433.2 0.987 1.96 10.23 331 470.7 1 burglary 2w
sh fit_features.bash 382.7 554.9 0.978 0.99 1.98 396 743.1 4 vehicle 3m
sh fit_features.bash 467.3 505.5 0.934 3.48 7.05 229 604.5 8 burglary 2m
sh fit_features.bash 547.1 341.9 0.805 2.05 6.92 718 425.4 3 vehicle 3m
sh fit_features.bash 280.6 454.4 0.193 2.65 5.50 294 556.1 6 vehicle 3m
sh fit_features.bash 314.3 509.4 0.899 1.10 9.78 345 133.7 8 burglary 2m
sh fit_features.bash 599.8 455.8 0.117 2.23 1.56 943 280.6 8 vehicle 2w
sh fit_features.bash 405.3 496.5 0.284 1.60 10.91 262 247.4 6 all 2m
sh fit_features.bash 576.2 335.9 0.512 3.63 6.29 1125 466.7 2 all 1w
sh fit_features.bash 548.4 395.4 0.005 0.52 1.53 436 439.6 3 street 2m
sh fit_features.bash 293.8 462.2 0.192 1.43 11.60 107 929.8 5 all 1w
sh fit_features.bash 250.7 294.4 0.050 2.86 10.93 157 734.8 6 burglary 1m
sh fit_features.bash 540.5 325.3 0.737 1.29 9.88 1055 1171.1 8 street 2w
sh fit_features.bash 534.0 473.6 0.446 1.97 8.87 123 994.5 2 vehicle 1w
sh fit_features.bash 549.8 397.7 0.794 0.86 10.36 766 471.2 6 all 2w
sh fit_features.bash 269.6 262.8 0.752 0.33 5.83 600 739.8 7 all 1m
sh fit_features.bash 434.2 590.2 0.987 2.63 3.66 626 148.6 1 burglary 2m
sh fit_features.bash 365.5 259.6 0.116 0.92 1.84 334 763.3 4 vehicle 2m
sh fit_features.bash 288.4 415.1 0.317 3.12 11.03 568 1065.0 5 street 1w
