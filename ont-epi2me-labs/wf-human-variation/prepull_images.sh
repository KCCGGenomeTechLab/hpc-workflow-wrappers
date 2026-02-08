#!/bin/bash
set -euo pipefail

module load singularity

PROJECT_="if89"
USER_="user"

umask 002

export SINGULARITY_CACHEDIR=/scratch/${PROJECT_}/${USER_}/singularity/cache
export SINGULARITY_TMPDIR=/scratch/${PROJECT_}/${USER_}/singularity/tmp

mkdir -p "$SINGULARITY_CACHEDIR" "$SINGULARITY_TMPDIR"
chgrp -R $PROJECT_ "$SINGULARITY_CACHEDIR" "$SINGULARITY_TMPDIR"
chmod -R g+rX "$SINGULARITY_CACHEDIR" "$SINGULARITY_TMPDIR"
chmod g+s "$SINGULARITY_CACHEDIR" "$SINGULARITY_TMPDIR"


# Pull with explicit names matching Nextflow’s cache naming
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-wf-common-shafdd79f8e4a6faad77513c36f623693977b92b08e.img docker://ontresearch/wf-common:shafdd79f8e4a6faad77513c36f623693977b92b08e
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-wf-human-variation-sv-sha8134f9fef5e19605c7fb4c1348961d6771f1af79.img docker://ontresearch/wf-human-variation-sv:sha8134f9fef5e19605c7fb4c1348961d6771f1af79
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-wf-human-variation-sha8ecee6d351b0c2609b452f3a368c390587f6662d.img docker://ontresearch/wf-human-variation:sha8ecee6d351b0c2609b452f3a368c390587f6662d
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-wf-human-variation-snp-sha8cc7e88ff71bf593d7852309a31d3adb29a7caeb.img docker://ontresearch/wf-human-variation-snp:sha8cc7e88ff71bf593d7852309a31d3adb29a7caeb
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-modkit-sha489d708a48c66368e5d1e118538e5dca68203a64.img docker://ontresearch/modkit:sha489d708a48c66368e5d1e118538e5dca68203a64
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-wf-cnv-sha428cb19e51370020ccf29ec2af4eead44c6a17c2.img docker://ontresearch/wf-cnv:sha428cb19e51370020ccf29ec2af4eead44c6a17c2
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-wf-human-variation-str-shadd2f2963fe39351d4e0d6fa3ca54e1064c6ec057.img docker://ontresearch/wf-human-variation-str:shadd2f2963fe39351d4e0d6fa3ca54e1064c6ec057
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-snpeff-sha367007eed5a09f992c2067f77776d9878806302a.img docker://ontresearch/snpeff:sha367007eed5a09f992c2067f77776d9878806302a
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-spectre-sha42472d37a5a992c3ee27894a23dce5e2fff66d27.img docker://ontresearch/spectre:sha42472d37a5a992c3ee27894a23dce5e2fff66d27
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-longphase-sha4ff1cd9a6eee338a414082cb24f943bcc4ce8e7c.img docker://ontresearch/longphase:sha4ff1cd9a6eee338a414082cb24f943bcc4ce8e7c

echo "Pulled images to: $SINGULARITY_CACHEDIR"
ls -ld "$SINGULARITY_CACHEDIR"
ls -l "$SINGULARITY_CACHEDIR" | head

