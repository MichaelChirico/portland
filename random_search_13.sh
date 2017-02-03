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

sh fit_features.bash 582.9 394.8 0.825 0.30 2.58 130 1139.7 6 burglary 2w
sh fit_features.bash 266.5 367.1 0.250 1.41 7.63 988 696.4 2 vehicle 2m
sh fit_features.bash 585.2 260.8 0.397 0.18 2.81 501 508.0 6 burglary 2m
sh fit_features.bash 561.7 407.0 0.062 0.41 0.36 480 1076.5 3 burglary 2m
sh fit_features.bash 504.3 374.5 0.887 0.03 11.30 863 240.7 4 street 2w
sh fit_features.bash 549.1 540.2 0.675 3.30 2.07 168 378.4 3 street 2w
sh fit_features.bash 336.6 344.4 0.608 1.52 1.15 1064 739.8 6 vehicle 2m
sh fit_features.bash 293.3 312.1 0.345 1.03 6.95 1150 936.4 5 all 1m
sh fit_features.bash 477.9 591.2 0.333 2.07 10.37 527 586.8 1 vehicle 1w
sh fit_features.bash 378.0 354.5 0.606 0.52 0.11 311 936.7 1 burglary 2m
sh fit_features.bash 276.5 535.9 0.994 0.24 5.66 1120 1074.7 3 street 2w
sh fit_features.bash 430.5 433.5 0.050 1.99 8.77 1025 813.0 4 all 2w
sh fit_features.bash 268.3 462.2 0.298 2.50 8.54 90 512.5 3 street 1m
sh fit_features.bash 400.8 347.0 0.265 0.06 10.88 1160 283.3 2 street 1m
sh fit_features.bash 448.1 295.1 0.731 2.67 5.00 831 474.7 1 street 1w
sh fit_features.bash 316.8 347.7 0.385 0.34 11.33 232 566.4 5 street 3m
sh fit_features.bash 594.2 540.4 0.810 3.78 11.26 256 1022.3 2 burglary 2m
sh fit_features.bash 499.8 430.2 0.192 1.15 6.30 892 867.6 1 burglary 2m
sh fit_features.bash 558.2 491.7 0.109 3.35 3.36 534 287.8 1 all 1m
sh fit_features.bash 368.5 298.5 0.600 0.25 4.54 1104 1080.0 6 burglary 2w
sh fit_features.bash 546.8 358.3 0.672 2.73 4.42 404 792.2 2 vehicle 2w
sh fit_features.bash 502.4 322.5 0.684 0.12 0.22 592 568.6 2 burglary 1m
sh fit_features.bash 536.6 424.7 0.915 3.80 10.89 224 399.6 6 all 1w
sh fit_features.bash 523.8 535.0 0.740 3.73 6.64 117 116.4 6 burglary 3m
sh fit_features.bash 326.8 299.6 0.377 1.94 10.65 415 406.0 4 vehicle 3m
sh fit_features.bash 313.9 333.1 0.257 1.50 9.17 990 851.7 6 vehicle 1w
sh fit_features.bash 460.2 319.9 0.093 2.09 11.22 97 264.4 3 street 2m
sh fit_features.bash 473.1 282.1 0.048 3.63 5.52 50 912.4 3 vehicle 2w
sh fit_features.bash 507.5 433.7 0.779 2.28 3.76 1100 1072.0 5 street 2w
sh fit_features.bash 510.9 345.9 0.039 1.86 6.86 138 751.5 5 all 3m
sh fit_features.bash 480.8 559.8 0.751 0.42 3.94 440 494.4 6 burglary 1m
sh fit_features.bash 397.2 294.2 0.187 1.38 11.13 409 593.6 6 burglary 1m
sh fit_features.bash 507.4 570.1 0.092 3.67 6.70 1085 281.3 2 street 1w
sh fit_features.bash 355.6 488.8 0.416 2.03 8.20 692 761.3 6 burglary 3m
sh fit_features.bash 579.3 485.1 0.755 0.61 6.57 576 1146.6 6 vehicle 1m
sh fit_features.bash 446.2 429.2 0.676 3.51 9.69 57 350.6 2 all 2m
sh fit_features.bash 383.3 499.2 0.977 1.85 9.95 566 589.3 5 burglary 1m
sh fit_features.bash 566.2 283.6 0.548 0.31 10.57 597 921.7 6 burglary 2m
sh fit_features.bash 404.9 309.9 0.465 2.47 4.09 1199 489.1 2 vehicle 1m
sh fit_features.bash 277.7 290.2 0.657 2.04 3.97 820 860.1 5 burglary 2w
sh fit_features.bash 285.3 464.0 0.802 3.07 1.25 645 986.3 5 street 2w
sh fit_features.bash 269.0 427.5 0.687 2.24 7.94 212 693.8 1 all 1w
sh fit_features.bash 471.8 439.9 0.306 1.55 9.26 635 978.7 5 street 1w
sh fit_features.bash 427.1 443.3 0.716 1.98 9.62 1124 238.6 4 vehicle 1m
sh fit_features.bash 333.6 289.9 0.604 2.85 5.97 1016 1178.0 6 all 2m
sh fit_features.bash 377.2 320.3 0.737 0.29 7.35 414 224.9 6 all 2m
sh fit_features.bash 555.1 363.9 0.096 2.24 10.64 522 141.7 2 vehicle 2m
sh fit_features.bash 556.9 558.9 0.011 1.97 3.82 995 231.7 6 all 1m
sh fit_features.bash 469.6 380.3 0.911 3.43 8.14 748 238.0 1 burglary 2w
sh fit_features.bash 377.4 256.8 0.850 1.99 1.93 1020 418.7 2 burglary 2m
sh fit_features.bash 485.4 297.3 0.256 0.73 3.68 455 956.3 6 all 1m
sh fit_features.bash 494.7 424.8 0.016 2.99 0.91 123 735.1 5 all 1w
sh fit_features.bash 581.3 339.4 0.974 2.04 4.75 1168 189.2 3 vehicle 1m
sh fit_features.bash 486.6 368.6 0.255 2.84 0.07 341 561.2 3 burglary 2m
sh fit_features.bash 358.0 276.4 0.875 2.72 7.37 108 549.6 3 vehicle 2m
sh fit_features.bash 592.0 449.4 0.184 3.66 10.36 860 958.6 4 all 1m
sh fit_features.bash 590.1 597.7 0.049 1.27 9.86 636 587.2 1 vehicle 2m
sh fit_features.bash 440.0 471.0 0.441 3.90 10.15 259 1080.2 6 burglary 1m
sh fit_features.bash 592.0 569.9 0.045 0.54 9.44 263 703.4 2 burglary 1w
sh fit_features.bash 565.6 549.3 0.614 0.13 5.01 907 1186.8 4 all 1m
sh fit_features.bash 269.4 517.8 0.544 3.18 6.70 304 666.8 3 vehicle 2m
sh fit_features.bash 266.2 449.8 0.922 2.64 2.65 1058 354.7 1 all 1m
sh fit_features.bash 527.4 348.0 0.873 0.88 1.95 1073 655.7 1 burglary 2m
sh fit_features.bash 552.0 482.6 0.364 1.52 4.01 933 817.1 3 street 2m
sh fit_features.bash 304.6 282.9 0.702 0.22 5.73 676 913.3 1 street 2m
sh fit_features.bash 496.4 394.3 0.451 2.92 9.14 401 685.1 6 vehicle 2w
sh fit_features.bash 313.2 478.2 0.946 2.81 10.46 835 959.6 3 all 3m
sh fit_features.bash 598.5 402.8 0.483 2.54 9.28 1090 937.5 2 burglary 2w
sh fit_features.bash 255.1 280.7 0.994 2.22 3.63 938 929.5 6 street 1w
sh fit_features.bash 544.3 340.6 0.532 1.03 8.77 751 1197.8 1 street 2m
sh fit_features.bash 288.5 497.4 0.185 0.64 9.85 777 729.8 3 burglary 2m
sh fit_features.bash 462.1 485.1 0.477 1.58 4.96 155 231.6 4 vehicle 1m
sh fit_features.bash 456.6 437.2 0.313 3.04 1.66 956 806.0 4 vehicle 2m
sh fit_features.bash 395.2 261.6 0.847 1.08 6.15 422 529.7 1 street 1w
sh fit_features.bash 512.3 578.9 0.349 2.55 5.24 919 1057.4 4 all 2m
sh fit_features.bash 402.6 526.2 0.884 1.08 5.83 728 886.9 6 burglary 3m
sh fit_features.bash 479.3 282.4 0.601 2.62 2.74 949 1146.0 2 burglary 2m
sh fit_features.bash 271.4 574.6 0.539 3.84 8.01 210 638.9 2 burglary 2w
sh fit_features.bash 341.6 396.3 0.670 1.53 4.66 462 696.4 5 vehicle 2w
sh fit_features.bash 506.8 501.3 0.706 0.66 5.37 244 1152.4 6 burglary 2m
sh fit_features.bash 419.7 515.7 0.068 2.19 7.26 252 483.7 2 street 1m
sh fit_features.bash 285.3 452.1 0.356 3.44 8.66 679 556.8 5 burglary 3m
sh fit_features.bash 470.1 596.6 0.307 3.97 8.00 603 341.1 1 all 1w
sh fit_features.bash 284.2 389.2 0.491 3.07 7.14 362 110.1 3 vehicle 3m
sh fit_features.bash 392.2 439.5 0.020 1.12 0.95 272 905.3 4 all 2m
sh fit_features.bash 370.0 343.4 0.223 1.69 8.53 1005 793.8 4 street 2m
sh fit_features.bash 306.6 294.4 0.555 3.57 8.04 1018 383.1 4 burglary 1w
sh fit_features.bash 368.2 582.2 0.734 3.80 10.97 657 125.7 2 street 1m
sh fit_features.bash 372.8 289.4 0.285 1.27 8.30 771 1066.7 2 vehicle 1w
sh fit_features.bash 381.5 289.1 0.383 1.72 7.96 1150 1135.4 2 street 2m
sh fit_features.bash 297.8 571.1 0.154 3.30 2.33 359 404.7 6 street 2w
sh fit_features.bash 271.4 436.8 0.923 3.91 11.05 287 1069.0 3 all 2m
sh fit_features.bash 536.0 407.2 0.872 3.29 0.89 1036 410.4 1 street 1w
sh fit_features.bash 487.4 345.1 0.542 3.30 6.85 55 878.0 4 all 2w
sh fit_features.bash 362.2 353.8 0.627 2.85 0.20 422 629.3 3 burglary 2m
sh fit_features.bash 358.5 432.5 0.970 1.96 5.33 64 1071.0 1 burglary 2w
sh fit_features.bash 287.8 560.7 0.915 1.06 7.58 537 632.1 5 street 1m
sh fit_features.bash 304.5 303.6 0.587 3.70 6.84 414 103.6 2 vehicle 2w
sh fit_features.bash 491.4 363.6 0.558 3.30 6.90 201 221.2 2 street 2w
sh fit_features.bash 382.9 573.1 0.589 2.10 3.05 708 1041.3 5 street 2w
