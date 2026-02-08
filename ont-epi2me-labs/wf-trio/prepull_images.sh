
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

# wf-trio images (names aligned to Nextflow’s cache naming)
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-modkit-shaa7bf2b62946eeb7646b9b9d60b892edfc3b3a52c.img docker://ontresearch/modkit:shaa7bf2b62946eeb7646b9b9d60b892edfc3b3a52c
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-snpeff-shaff5aecfe85e945f49215fa3d43b9ed4ae352bd5c.img docker://ontresearch/snpeff:shaff5aecfe85e945f49215fa3d43b9ed4ae352bd5c
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-wf-common-sha72f3517dd994984e0e2da0b97cb3f23f8540be4b.img docker://ontresearch/wf-common:sha72f3517dd994984e0e2da0b97cb3f23f8540be4b
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-clair3-nova-sha4eaceafc4c438377909cdb083e0ba80299dc6831.img docker://ontresearch/clair3-nova:sha4eaceafc4c438377909cdb083e0ba80299dc6831
singularity pull --dir "$SINGULARITY_CACHEDIR" --name ontresearch-wf-trio-sha83fff54c604e95a2402ffa68d3468b82979923b2.img docker://ontresearch/wf-trio:sha83fff54c604e95a2402ffa68d3468b82979923b2


echo "Pulled wf-trio images to: $SINGULARITY_CACHEDIR"
ls -ld "$SINGULARITY_CACHEDIR"
ls -l "$SINGULARITY_CACHEDIR" | head

