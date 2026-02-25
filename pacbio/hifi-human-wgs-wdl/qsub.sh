#!/bin/bash
#PBS -P project
#PBS -N pacbio-wdl-singleton
#PBS -l walltime=20:00:00,ncpus=32,mem=160GB,wd
#PBS -l jobfs=20GB
#PBS -q normal
#PBS -l storage=scratch/if89+scratch/project+gdata/project+gdata/if89

module purge
module load singularity python3/3.9.2

# Use Singularity runtime
export MINIWDL__SCHEDULER__CONTAINER_BACKEND=singularity
export MINIWDL__SINGULARITY__EXE=singularity

# Point MiniWDL to your pre-pulled image cache
export SINGULARITY_CACHEDIR="/g/data/if89/shpcroot/containers/quay.io/pacbio"
export MINIWDL__SINGULARITY__IMAGE_CACHE="$SINGULARITY_CACHEDIR"

# Allow the workflow to read files referenced by TSV maps
export MINIWDL__FILE_IO__ALLOW_ANY_INPUT=true

# CRITICAL: drop --fakeroot to avoid sandbox extraction
export MINIWDL__SINGULARITY__RUN_OPTIONS='["--containall","--no-mount","hostfs"]'

#  Pipeline root (clone a supported release with submodules)
PIPE_ROOT="/g/data/if89/testdir/pacbio_workflows/HiFi-human-WGS-WDL/HiFi-human-WGS-WDL-v3.2.0"
source /g/data/if89/testdir/pacbio_workflows/venv_miniwdl/bin/activate

# Inputs (edit to match your cohort and reference bundle locations)
INPUTS_JSON="/g/data/kr68/hiruna/workflow/pacbio/inputs/singleton.hpc.inputs.json"
OUTDIR=/g/data/$PROJECT/$(whoami)/pacbio/HiFi-human-WGS-WDL/${SAMPLE}
mkdir -p "$OUTDIR"

# Optional: activate a Python venv with miniwdl installed, if miniwdl is not a module
# python -m venv venv_miniwdl
# source venv_miniwdl/bin/activate
# pip install --upgrade pip
# pip install miniwdl

#  Run WDL (family workflow for joint calling)
# cd "$PIPE_ROOT"
miniwdl run --verbose $PIPE_ROOT/workflows/singleton.wdl -i "$INPUTS_JSON" --dir "$OUTDIR"

echo "Workflow completed. Outputs are in: $OUTDIR"
