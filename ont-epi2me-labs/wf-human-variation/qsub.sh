#!/bin/bash
#PBS -P project
#PBS -N wf-human-variation-local
#PBS -l walltime=10:00:00,ncpus=32,mem=160GB,wd
#PBS -q normal
#PBS -l storage=scratch/if89+gdata/if89+scratch/project+gdata/project

module purge
module load nextflow singularity

# Workflow details (don't change)
VERSION=2.8.0
PIPE=/g/data/if89/testdir/epi2me-labs/wf-human-variation/wf-human-variation-${VERSION}
# Shared Singularity cache (don't change)
export SINGULARITY_CACHEDIR=/g/data/if89/shpcroot/containers/ontresearch
export SINGULARITY_TMPDIR=/scratch/$PROJECT/$(whoami)/singularity/tmp
export NXF_SINGULARITY_CACHEDIR=${SINGULARITY_CACHEDIR}
mkdir -p "$SINGULARITY_TMPDIR"
# Per-user Nextflow internals (no need to change)
export NXF_HOME=/g/data/$PROJECT/$(whoami)/workflow/ont/nextflow
export NXF_TEMP=/scratch/$PROJECT/$(whoami)/nextflow/tmp
mkdir -p "$NXF_HOME" "$NXF_TEMP"

# Inputs (change)
SAMPLE="sample"
BAM=/path/to/reads.bam
REF=/path/to/hg38.analysisSet.fa
TR_BED="/path/to/hg38.trf.bed"
# Outputs (may change)
OUTDIR=/g/data/$PROJECT/$(whoami)/ont/wf-human-variation/${SAMPLE}
mkdir -p "$OUTDIR"

nextflow run "$PIPE" \
	-profile singularity \
	-work-dir /scratch/$PROJECT/$(whoami)/nxf_work \
	--out_dir "$OUTDIR" \
	--ref "$REF" \
	--sample_name ${SAMPLE} \
	--bam "$BAM" \
	--sv --snp --cnv --str --mod --phased --include_all_ctgs \
	--tr_bed "$TR_BED"

echo "Workflow complete. Results in: $OUTDIR"

