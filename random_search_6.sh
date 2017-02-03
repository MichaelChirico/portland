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

sh fit_features.bash 535.6 382.1 0.325 3.93 9.69 972 814.7 3 vehicle 1m
sh fit_features.bash 326.5 521.7 0.219 1.51 0.60 144 581.2 4 all 1m
sh fit_features.bash 286.0 499.6 0.304 2.32 10.90 677 221.8 2 vehicle 1w
sh fit_features.bash 519.9 588.9 0.954 2.71 11.83 1027 725.9 5 all 1w
sh fit_features.bash 506.0 538.2 0.075 3.00 1.36 270 183.7 5 all 3m
sh fit_features.bash 467.1 570.9 0.699 2.77 2.21 412 386.0 6 vehicle 2w
sh fit_features.bash 460.4 507.4 0.514 0.98 5.12 475 188.3 5 vehicle 2m
sh fit_features.bash 520.1 474.5 0.769 0.51 10.46 824 1004.2 6 burglary 1m
sh fit_features.bash 494.3 409.0 0.055 1.32 1.92 946 686.7 2 all 2w
sh fit_features.bash 421.8 584.6 0.597 1.95 11.57 307 1196.1 2 burglary 2m
sh fit_features.bash 475.4 422.4 0.231 3.97 10.77 621 546.2 5 street 2m
sh fit_features.bash 356.6 544.3 0.163 2.17 3.50 531 1039.8 4 vehicle 2m
sh fit_features.bash 343.0 561.4 0.452 1.14 9.23 950 660.8 6 all 3m
sh fit_features.bash 310.2 389.5 0.550 2.32 8.57 783 276.1 2 street 2m
sh fit_features.bash 256.7 486.4 0.831 3.32 0.16 81 163.1 1 vehicle 3m
sh fit_features.bash 319.9 258.7 0.285 0.00 5.69 230 818.8 2 street 3m
sh fit_features.bash 523.7 268.6 0.361 0.28 9.12 446 415.9 3 burglary 2m
sh fit_features.bash 336.6 263.0 0.455 2.09 11.69 809 290.2 6 burglary 1w
sh fit_features.bash 569.0 331.2 0.817 0.43 1.47 1170 834.8 2 vehicle 1m
sh fit_features.bash 412.1 573.5 0.610 0.97 3.02 71 568.5 3 vehicle 3m
sh fit_features.bash 592.9 587.4 0.419 3.56 0.92 126 577.9 2 vehicle 1m
sh fit_features.bash 367.7 529.1 0.217 0.15 3.75 637 756.1 1 burglary 1m
sh fit_features.bash 411.0 500.5 0.274 0.33 1.45 769 994.8 2 vehicle 1m
sh fit_features.bash 440.5 462.8 0.321 1.41 11.94 454 775.2 2 vehicle 1w
sh fit_features.bash 321.0 545.1 0.198 1.67 8.27 279 816.3 3 vehicle 2w
sh fit_features.bash 256.1 446.4 0.202 1.80 11.04 1177 687.6 6 all 2m
sh fit_features.bash 469.1 376.0 0.307 0.38 9.99 454 880.5 1 street 2m
sh fit_features.bash 437.7 515.0 0.379 0.04 3.40 405 421.4 6 burglary 1w
sh fit_features.bash 562.3 455.8 0.535 0.18 1.15 407 531.7 2 burglary 1m
sh fit_features.bash 495.7 569.6 0.137 2.76 11.06 89 810.7 4 vehicle 2m
sh fit_features.bash 358.0 269.6 0.841 1.24 1.29 516 783.4 5 vehicle 3m
sh fit_features.bash 318.2 407.5 0.587 1.39 0.96 822 802.4 2 all 2m
sh fit_features.bash 578.2 296.1 0.741 0.87 2.16 562 406.3 6 burglary 3m
sh fit_features.bash 278.4 286.4 0.540 3.79 1.93 842 182.7 6 burglary 2m
sh fit_features.bash 568.5 551.4 0.688 0.65 5.32 1145 1130.5 4 burglary 1m
sh fit_features.bash 292.5 349.7 0.604 2.80 7.78 50 531.2 1 street 3m
sh fit_features.bash 402.1 378.9 0.381 3.54 1.17 490 774.2 5 street 3m
sh fit_features.bash 362.5 394.0 0.715 1.97 4.69 1128 766.8 1 vehicle 3m
sh fit_features.bash 274.7 477.8 0.473 1.85 5.11 1032 690.4 6 vehicle 1m
sh fit_features.bash 599.8 313.5 0.450 1.02 8.36 426 173.7 5 burglary 1m
sh fit_features.bash 262.8 541.1 0.414 0.35 3.91 881 701.8 3 street 1w
sh fit_features.bash 452.1 542.7 0.366 3.41 11.04 332 799.6 5 burglary 2m
sh fit_features.bash 359.7 253.3 0.739 0.84 11.70 517 262.8 3 all 3m
sh fit_features.bash 481.6 383.5 0.418 0.17 6.55 683 504.1 5 street 2m
sh fit_features.bash 495.1 329.9 0.111 2.93 5.23 633 1139.6 4 vehicle 3m
sh fit_features.bash 564.9 585.2 0.837 2.01 8.53 511 117.6 1 burglary 1m
sh fit_features.bash 437.8 442.3 0.645 0.37 1.17 471 556.6 3 vehicle 2m
sh fit_features.bash 498.2 584.9 0.208 1.02 8.48 125 321.1 3 street 2m
sh fit_features.bash 552.8 451.0 0.275 1.30 11.23 553 1069.7 6 all 3m
sh fit_features.bash 500.2 443.5 0.315 3.35 6.74 907 963.2 4 street 2m
sh fit_features.bash 519.5 525.8 0.871 2.50 10.03 747 249.7 3 street 2m
sh fit_features.bash 539.0 384.9 0.420 3.26 6.85 940 959.8 3 street 1w
sh fit_features.bash 483.0 277.8 0.511 2.46 0.45 656 842.1 5 vehicle 2w
sh fit_features.bash 278.6 510.4 0.353 1.65 1.65 1120 519.6 4 vehicle 1w
sh fit_features.bash 350.8 439.4 0.414 0.07 1.85 616 1003.4 3 street 3m
sh fit_features.bash 508.4 450.8 0.548 0.81 10.19 609 594.7 1 all 1w
sh fit_features.bash 418.9 358.5 0.712 2.66 1.85 793 900.8 2 burglary 3m
sh fit_features.bash 250.9 479.7 0.343 1.19 2.09 1119 620.6 6 burglary 1m
sh fit_features.bash 454.5 415.8 0.176 0.22 6.38 1052 401.6 5 burglary 1w
sh fit_features.bash 482.6 545.5 0.720 2.29 11.89 1135 1097.1 4 all 3m
sh fit_features.bash 558.8 446.8 0.656 3.83 10.12 356 457.3 6 burglary 1w
sh fit_features.bash 589.8 309.4 0.476 1.25 9.07 955 878.7 1 street 1m
sh fit_features.bash 556.1 404.0 0.551 2.53 2.18 1097 339.5 5 street 3m
sh fit_features.bash 345.5 336.1 0.714 0.76 4.35 675 836.4 2 vehicle 1w
sh fit_features.bash 289.8 546.1 0.086 0.58 2.35 97 838.3 1 vehicle 1w
sh fit_features.bash 545.6 544.9 0.222 2.41 7.16 1091 952.9 6 burglary 2w
sh fit_features.bash 410.3 549.6 0.496 0.56 10.32 1139 743.9 5 all 2m
sh fit_features.bash 594.8 284.9 0.954 0.66 1.02 63 536.9 1 street 1m
sh fit_features.bash 504.6 277.3 0.955 3.63 9.92 1142 230.0 6 all 1m
sh fit_features.bash 375.2 506.4 0.889 2.33 7.62 687 993.4 3 vehicle 2w
sh fit_features.bash 310.9 598.7 0.354 3.84 11.49 1021 734.3 4 street 3m
sh fit_features.bash 271.9 304.7 0.484 2.81 4.78 256 251.2 6 vehicle 1m
sh fit_features.bash 463.6 280.6 0.846 1.44 9.63 543 1059.6 2 all 2w
sh fit_features.bash 370.9 488.4 0.612 2.61 5.43 302 566.4 6 street 2w
sh fit_features.bash 570.9 490.6 0.927 0.92 0.26 710 637.6 4 street 2w
sh fit_features.bash 469.8 307.2 0.373 2.04 2.38 493 864.5 3 street 2m
sh fit_features.bash 586.6 260.8 0.304 0.10 2.71 1146 268.2 4 street 1m
sh fit_features.bash 442.6 313.8 0.461 3.57 3.41 1117 686.5 6 vehicle 2w
sh fit_features.bash 303.8 357.4 0.497 1.97 1.53 902 1146.9 6 street 1m
sh fit_features.bash 394.1 386.2 0.657 2.51 11.15 253 684.3 3 vehicle 3m
sh fit_features.bash 324.1 588.1 0.701 2.87 4.54 178 1016.3 4 burglary 3m
sh fit_features.bash 477.2 425.3 0.753 3.76 10.32 1006 1063.6 2 all 2w
sh fit_features.bash 325.8 296.5 0.441 3.37 8.26 294 1107.5 1 vehicle 1m
sh fit_features.bash 581.2 560.7 0.278 1.22 6.76 674 863.2 6 vehicle 1w
sh fit_features.bash 335.0 455.7 0.514 0.28 11.76 551 449.2 5 burglary 1m
sh fit_features.bash 358.6 417.2 0.210 2.23 4.66 1046 665.9 3 street 2w
sh fit_features.bash 431.7 330.5 0.508 2.92 5.39 166 1086.6 5 street 2m
sh fit_features.bash 593.1 346.4 0.477 0.46 1.45 732 447.7 3 burglary 1w
sh fit_features.bash 569.2 468.3 0.291 0.78 8.21 949 255.6 6 vehicle 2w
sh fit_features.bash 395.0 424.9 0.427 2.35 5.07 961 776.9 5 street 2m
sh fit_features.bash 252.2 512.8 0.772 2.82 3.78 1182 199.5 6 vehicle 3m
sh fit_features.bash 535.5 337.2 0.659 0.89 6.30 91 932.2 2 burglary 1m
sh fit_features.bash 254.2 308.7 0.023 2.48 4.76 809 429.3 6 all 1m
sh fit_features.bash 356.9 378.9 0.118 0.08 4.79 587 367.3 4 vehicle 2w
sh fit_features.bash 592.1 286.9 0.776 2.99 6.21 486 572.3 5 burglary 2m
sh fit_features.bash 538.9 553.0 0.812 2.19 4.74 879 402.0 4 all 1m
sh fit_features.bash 379.2 361.6 0.508 0.43 10.46 954 1027.3 6 vehicle 1w
sh fit_features.bash 366.9 251.5 0.789 2.43 5.18 396 1043.4 4 vehicle 1m
sh fit_features.bash 344.8 431.5 0.524 2.94 8.68 446 660.3 5 vehicle 1w
sh fit_features.bash 326.3 399.4 0.793 0.27 6.59 795 453.7 4 burglary 3m
