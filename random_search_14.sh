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

sh fit_features.bash 562.9 454.6 0.399 0.37 6.13 147 368.3 3 all 1w
sh fit_features.bash 396.0 529.6 0.165 2.14 9.51 936 733.6 8 street 3m
sh fit_features.bash 347.1 384.5 0.406 3.74 4.31 398 577.6 3 vehicle 1m
sh fit_features.bash 455.4 349.9 0.058 2.98 11.74 582 960.9 2 all 3m
sh fit_features.bash 531.2 502.7 0.526 3.25 3.90 981 444.6 3 all 1m
sh fit_features.bash 421.3 354.5 0.640 1.68 6.13 527 787.4 1 vehicle 1w
sh fit_features.bash 439.1 552.5 0.390 2.69 3.36 261 121.6 7 vehicle 3m
sh fit_features.bash 328.4 420.6 0.440 1.38 7.57 202 556.0 1 vehicle 2w
sh fit_features.bash 487.8 411.9 0.527 1.90 5.87 815 185.6 5 burglary 3m
sh fit_features.bash 591.6 304.3 0.967 3.78 2.75 432 588.9 2 street 2w
sh fit_features.bash 339.0 368.6 0.467 3.05 11.77 511 194.6 8 all 2m
sh fit_features.bash 458.5 541.6 0.772 3.96 5.21 180 801.7 2 vehicle 1m
sh fit_features.bash 425.1 324.9 0.970 3.26 2.57 953 489.3 5 all 2m
sh fit_features.bash 458.3 414.6 0.608 1.08 5.23 839 528.9 5 street 1m
sh fit_features.bash 274.9 542.1 0.014 3.03 4.84 1067 605.6 6 street 1w
sh fit_features.bash 344.0 403.5 0.368 2.48 0.70 666 239.1 5 burglary 3m
sh fit_features.bash 594.0 487.0 0.097 0.79 1.81 1173 157.7 7 street 2m
sh fit_features.bash 269.5 490.1 0.060 3.52 3.65 273 1185.0 2 burglary 2m
sh fit_features.bash 529.0 501.6 0.281 2.38 11.19 1135 675.3 8 burglary 3m
sh fit_features.bash 417.1 577.9 0.664 1.82 2.94 579 385.6 1 vehicle 1m
sh fit_features.bash 540.4 332.7 0.165 0.79 6.68 254 530.2 4 vehicle 1w
sh fit_features.bash 455.4 464.1 0.651 0.57 11.11 229 1149.4 5 street 1w
sh fit_features.bash 516.9 271.0 0.569 1.06 3.56 200 808.1 4 street 1w
sh fit_features.bash 426.6 589.6 0.344 3.49 7.92 347 1027.3 8 burglary 2w
sh fit_features.bash 251.4 509.6 0.172 0.91 3.33 1109 948.7 8 street 2m
sh fit_features.bash 262.4 580.0 0.679 0.75 5.59 394 752.1 5 vehicle 3m
sh fit_features.bash 572.0 313.1 0.497 3.30 8.74 237 488.1 7 burglary 1w
sh fit_features.bash 410.4 518.9 0.143 2.59 11.00 334 921.0 8 all 2m
sh fit_features.bash 264.3 414.6 0.590 3.32 6.62 714 1169.7 6 all 3m
sh fit_features.bash 301.7 575.5 0.752 3.61 2.53 782 921.9 8 all 2w
sh fit_features.bash 501.6 506.6 0.421 3.96 2.23 391 327.7 2 street 3m
sh fit_features.bash 483.5 494.9 0.808 2.10 10.12 535 318.3 1 burglary 2w
sh fit_features.bash 448.1 346.2 0.414 0.79 4.80 349 998.9 7 burglary 1w
sh fit_features.bash 312.2 420.4 0.390 1.75 4.17 1108 346.0 6 burglary 3m
sh fit_features.bash 457.1 382.8 0.509 2.54 5.64 735 1066.0 4 all 1m
sh fit_features.bash 517.1 387.2 0.876 3.44 11.77 537 1058.5 5 all 2m
sh fit_features.bash 357.3 328.0 0.651 3.92 2.88 897 1168.6 4 vehicle 1m
sh fit_features.bash 404.0 410.4 0.547 1.69 4.61 314 841.6 3 all 1m
sh fit_features.bash 508.1 536.9 0.484 3.29 5.57 1070 888.1 3 street 2m
sh fit_features.bash 576.7 559.6 0.939 2.06 8.60 51 1151.1 2 all 3m
sh fit_features.bash 481.7 348.3 0.957 0.67 8.62 681 637.9 1 burglary 2w
sh fit_features.bash 495.7 315.0 0.655 1.82 5.78 1188 915.7 4 street 2m
sh fit_features.bash 363.0 392.5 0.012 1.28 9.11 781 710.4 3 burglary 2w
sh fit_features.bash 354.6 281.3 0.297 2.87 6.16 337 470.8 1 street 2w
sh fit_features.bash 584.4 382.4 0.604 0.66 3.83 172 653.6 1 all 1m
sh fit_features.bash 262.6 544.9 0.242 1.71 8.36 951 482.6 3 burglary 1m
sh fit_features.bash 507.2 307.0 0.069 1.44 0.03 910 654.6 4 all 2m
sh fit_features.bash 285.5 355.0 0.765 2.81 4.19 265 772.0 5 all 1w
sh fit_features.bash 379.9 259.2 0.197 1.74 9.26 786 899.9 6 burglary 1m
sh fit_features.bash 440.6 376.3 0.190 2.17 7.64 570 487.2 5 burglary 2m
sh fit_features.bash 293.9 536.9 0.186 0.56 11.53 1052 1076.1 8 burglary 2w
sh fit_features.bash 556.8 585.9 0.698 1.29 7.58 1154 1062.1 8 street 1m
sh fit_features.bash 257.5 475.6 0.476 2.02 9.98 791 838.3 3 burglary 3m
sh fit_features.bash 536.1 320.9 0.991 2.24 11.00 534 494.3 8 burglary 1m
sh fit_features.bash 474.6 261.1 0.769 1.75 5.78 248 806.2 1 vehicle 2m
sh fit_features.bash 335.8 426.7 0.201 3.84 5.20 321 876.2 1 burglary 1m
sh fit_features.bash 426.3 309.3 0.196 1.73 4.50 1010 760.1 5 vehicle 2w
sh fit_features.bash 345.3 558.9 0.526 0.69 5.16 182 341.8 5 burglary 1w
sh fit_features.bash 571.2 283.2 0.734 2.70 4.11 733 347.9 4 burglary 1m
sh fit_features.bash 454.9 267.2 0.836 0.87 8.14 704 845.2 6 street 1m
sh fit_features.bash 492.8 556.9 0.227 3.40 0.74 431 409.1 5 all 2m
sh fit_features.bash 296.9 366.4 0.453 1.79 7.87 361 543.2 2 all 3m
sh fit_features.bash 370.9 346.1 0.478 3.89 11.04 160 188.7 5 burglary 3m
sh fit_features.bash 359.3 578.5 0.648 1.73 7.30 1042 305.5 4 all 1w
sh fit_features.bash 588.9 280.4 0.896 3.14 6.45 292 1141.3 8 all 2m
sh fit_features.bash 416.3 402.6 0.489 3.40 6.47 315 949.0 1 burglary 1w
sh fit_features.bash 377.5 325.9 0.117 0.30 11.99 716 259.3 4 street 1w
sh fit_features.bash 473.6 400.3 0.973 2.31 0.74 837 845.1 2 vehicle 1m
sh fit_features.bash 250.6 363.5 0.676 0.26 5.33 804 473.2 8 street 3m
sh fit_features.bash 530.2 530.2 0.126 2.60 7.60 984 555.0 3 all 1m
sh fit_features.bash 325.8 278.8 0.487 1.11 10.71 507 1014.1 6 street 1m
sh fit_features.bash 315.6 315.2 0.867 1.32 0.56 217 479.2 1 all 1m
sh fit_features.bash 560.6 420.4 0.526 2.36 8.79 1179 458.6 7 burglary 2m
sh fit_features.bash 344.6 450.1 0.671 0.69 10.65 153 270.5 3 burglary 2w
sh fit_features.bash 381.3 591.0 0.215 1.42 7.17 116 1065.8 5 street 2w
sh fit_features.bash 315.9 483.1 0.830 0.05 4.12 509 632.7 7 all 1m
sh fit_features.bash 366.9 485.9 0.094 0.63 6.33 992 509.8 5 vehicle 2m
sh fit_features.bash 360.3 289.4 0.355 1.17 11.48 225 734.1 3 all 1w
sh fit_features.bash 463.6 400.7 0.457 1.19 4.34 813 209.6 1 burglary 1m
sh fit_features.bash 425.6 254.4 0.723 2.03 2.44 452 556.3 3 burglary 2w
sh fit_features.bash 342.7 466.7 0.337 0.82 4.03 879 538.2 8 all 2m
sh fit_features.bash 370.8 479.2 0.189 3.69 4.28 186 692.5 5 street 1w
sh fit_features.bash 442.6 443.2 0.989 2.33 7.34 856 899.9 3 burglary 2m
sh fit_features.bash 464.2 342.9 0.346 3.72 6.69 259 269.5 1 burglary 1m
sh fit_features.bash 586.1 599.3 0.579 0.16 11.46 425 859.7 1 all 2w
sh fit_features.bash 257.3 291.7 0.156 2.75 6.05 971 152.1 5 burglary 1m
sh fit_features.bash 430.3 598.2 0.718 0.82 1.16 885 704.6 4 vehicle 3m
sh fit_features.bash 518.6 480.7 0.147 2.15 6.99 1083 656.8 3 burglary 1w
sh fit_features.bash 479.8 575.8 0.511 2.32 7.05 568 1062.0 7 street 2m
sh fit_features.bash 587.0 483.7 0.200 2.77 4.70 362 427.5 1 burglary 3m
sh fit_features.bash 447.4 275.5 0.381 0.58 2.42 583 547.5 2 burglary 1w
sh fit_features.bash 292.6 483.6 0.080 2.50 11.10 92 734.5 2 street 2m
sh fit_features.bash 449.2 459.8 0.631 2.48 1.43 974 200.0 7 burglary 2m
sh fit_features.bash 304.4 384.4 0.891 3.89 0.35 597 689.8 1 street 2w
sh fit_features.bash 308.0 570.6 0.646 3.64 10.09 122 1117.4 8 all 2m
sh fit_features.bash 386.5 253.4 0.257 2.93 10.76 560 439.5 3 vehicle 1w
sh fit_features.bash 268.1 334.2 0.344 0.75 1.90 1060 640.5 8 street 2w
sh fit_features.bash 296.1 388.3 0.923 0.92 9.61 635 452.5 8 all 2m
sh fit_features.bash 513.0 282.8 0.297 1.42 2.47 357 422.6 5 street 1w
sh fit_features.bash 564.7 252.3 0.715 0.07 7.00 830 600.2 1 vehicle 2w
