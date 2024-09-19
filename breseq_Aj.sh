#!/bin/bash

# Set input directory for sequence files
INPUT_DIR="/pub/trosazza/Sequence/Aj_EE"

# Set output base directory for Breseq results
OUTPUT_BASE_DIR="/pub/trosazza/Breseq"

# Define reference genome paths
REFERENCE_GENOME1="/pub/trosazza/Sequence/Reference/AjC6_contigs/AjC6_combined.gbk"
#REFERENCE_GENOME2="/pub/trosazza/Sequence/Aj_EE/Aj_Anc_nR365-L2-G4-P017-TGCAGCTA-ACTCTAGG-READ2-Sequences.txt.gz"

# Find all READ1 files that start with 'Aj_BA_Mix' and loop through them
for READ1 in ${INPUT_DIR}/Aj_BA_Aj*READ1-Sequences.txt.gz; do
    # Get the corresponding READ2 filename
    READ2=${READ1/READ1/READ2}
    
    # Extract the base name (e.g., Pp_BA_Mix1_T14) for folder creation
    BASE_NAME=$(basename ${READ1} | cut -d'-' -f1-5)
    
    # Create output folder for this set of files
    OUTPUT_DIR=${OUTPUT_BASE_DIR}/${BASE_NAME}
    mkdir -p ${OUTPUT_DIR}

    # Create a temporary job script for each submission
    JOB_SCRIPT=$(mktemp)

    # Write the job script
    cat <<EOT > ${JOB_SCRIPT}
#!/bin/bash
#SBATCH --job-name=breseq_${BASE_NAME}   ## Name of the job.
#SBATCH -A alejanr1_lab      ## CHANGE account to charge 
#SBATCH --nodes=1            ## Number of nodes to use
#SBATCH --ntasks=1           ## Number of tasks to launch
#SBATCH --cpus-per-task=4    ## Number of cores the job needs
#SBATCH --mem-per-cpu=8G     ## Memory per CPU
#SBATCH --error=${OUTPUT_DIR}/breseq-%J.err  ## Error log file
#SBATCH --output=${OUTPUT_DIR}/breseq-%J.out ## Output log file

# Run Breseq with both reference genomes
breseq -j 8 -p -o ${OUTPUT_DIR} -r ${REFERENCE_GENOME1} ${READ1} ${READ2}

EOT

    # Submit the job to SLURM
    sbatch ${JOB_SCRIPT}

    # Clean up the temporary job script
    rm ${JOB_SCRIPT}

done
