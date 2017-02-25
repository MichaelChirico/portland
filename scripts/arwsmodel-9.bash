
                 #!/bin/bash
                 module load R
                 module load vowpal_wabbit
                 cd /home/ubuntu/scratch/portland
                 Rscript ar_ws_evaluate_params.R  250 250 0 1 1 0 250 125 4 8 street 3m 
