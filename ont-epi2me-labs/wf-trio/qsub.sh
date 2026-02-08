#!/bin/bash
#PBS -P project
#PBS -N wf-trio
#PBS -l walltime=15:00:00,ncpus=32,mem=128GB,wd
#PBS -q normal
#PBS -l storage=scratch/if89+gdata/if89+scratch/project+gdata/project

module purge
module load nextflow singularity

# Workflow details (don't change)
VERSION=0.9.2
PIPE=/g/data/if89/testdir/epi2me-labs/wf-trio/wf-trio-${VERSION}
# Shared Singularity cache (don't change)
export SINGULARITY_CACHEDIR=/scratch/if89/hm4078/singularity/cache
export SINGULARITY_TMPDIR=/scratch/$PROJECT/$(whoami)/singularity/tmp
export NXF_SINGULARITY_CACHEDIR=${SINGULARITY_CACHEDIR}
mkdir -p "$SINGULARITY_TMPDIR"
# Per-user Nextflow internals (no need to change)
export NXF_HOME=/g/data/$PROJECT/$(whoami)/workflow/ont/nextflow
export NXF_TEMP=/scratch/$PROJECT/$(whoami)/nextflow/tmp
mkdir -p "$NXF_HOME" "$NXF_TEMP"

# Inputs (change)
SAMPLE="sample_name"
PROBAND_BAM=/path/to/reads.bam
PROBAND_SAMPLE_NAME="proband"
PAT_BAM=/path/to/paternal_reads.bam
PAT_SAMPLE_NAME="father"
MAT_BAM=/path/to/maternal_reads.bam
MAT_SAMPLE_NAME="mother"
PEDIGREE_FILE=/path/to/pedigree.ped
FAMILY_ID="family1"
REF=/path/to/hg38.analysisSet.fa
TR_BED="/path/to/hg38.trf.bed"
# Outputs (may change)
OUTDIR=/g/data/$PROJECT/$(whoami)/ont/wf-human-variation/${SAMPLE}
mkdir -p "$OUTDIR"

nextflow run "$PIPE" \
  -profile singularity \
  -work-dir /scratch/$PROJECT/$(whoami)/nxf_work \
  --out_dir "$OUTDIR" \
  --family_id "$FAMILY_ID" \
  --proband_bam "$PROBAND_BAM" \
  --proband_sample_name "$PROBAND_SAMPLE_NAME" \
  --mat_bam "$MAT_BAM" \
  --mat_sample_name "$MAT_SAMPLE_NAME" \
  --pat_bam "$PAT_BAM" \
  --pat_sample_name "$PAT_SAMPLE_NAME" \
  --pedigree_file "$PEDIGREE_FILE" \
  --phased \
  --ref "$REF" \
  --snp --sv --phased --include_all_ctgs \
	--tr_bed "$TR_BED"

  echo "Workflow complete. Results in: $OUTDIR"
