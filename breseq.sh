#!/bin/bash
#SBATCH --job-name=breseq_${BASE_NAME}   ## Name of the job.
#SBATCH -A alejanr1_lab      ## CHANGE account to charge 
#SBATCH --nodes=1            ## Number of nodes to use
#SBATCH --ntasks=1           ## Number of tasks to launch
#SBATCH --cpus-per-task=4    ## Number of cores the job needs
#SBATCH --mem-per-cpu=8G     ## Memory per CPU
#SBATCH --error=breseq-%J.err  ## Error log file
#SBATCH --output=breseq-%J.out ## Output log file

# Run Breseq with both reference genomes
breseq -j 8 -p -o /pub/trosazza/Breseq/AjC6_to_AjAnc -r /pub/trosazza/Sequence/Reference/Aj_C6.gff /pub/trosazza/Sequence/Aj_EE/Aj_Anc_nR365-L2-G4-P017-TGCAGCTA-ACTCTAGG-READ1-Sequences.txt.gz /pub/trosazza/Sequence/Aj_EE/Aj_Anc_nR365-L2-G4-P017-TGCAGCTA-ACTCTAGG-READ2-Sequences.txt.gz

