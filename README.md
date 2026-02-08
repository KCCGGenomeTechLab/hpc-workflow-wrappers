# hpc-workflow-wrappers
Collection of HPC job submission wrappers for bioinformatics workflows. Includes PBS/qsub scripts for both Oxford Nanopore (ONT) Nextflow pipelines and PacBio WDL workflows, enabling reproducible execution on HPC clusters.

# dir structure

```

hpc-workflow-wrappers/
├── README.md
├── ont-epi2me-labs/               # Oxford Nanopore workflows
│   ├── wf-human-variation/
│   │   ├── qsub.sh                # PBS/qsub submission script
│   │   └── prepull_images.sh      # Optional: pre-download Singularity images
│   └── wf-trio/
│       ├── qsub.sh
│       └── prepull_images.sh
└── pacbio/                         # PacBio WDL workflows
    └── pacbio-hifi-human-wgs-wdl/
        ├── qsub.sh
        └── prepull_images.sh

```


# NCI-Gadi if89 users

NCI Gadi if89 users can just qsubmit the `qsub.sh` after modifying the input files. No need to run `prepull_images.sh` scripts.

