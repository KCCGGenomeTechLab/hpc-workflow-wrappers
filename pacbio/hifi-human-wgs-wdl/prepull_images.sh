#!/bin/bash
set -euo pipefail

# Modules
module load singularity

PROJECT_="if89"
USER_="user"

# Group-friendly permissions
umask 002

# Shared IF89 caches (adjust user/group paths if you prefer a different shared location)
export SINGULARITY_CACHEDIR=/scratch/${PROJECT_}/${USER_}/singularity/pacbio/cache
export SINGULARITY_TMPDIR=/scratch/${PROJECT_}/${USER_}/singularity/pacbio/tmp

mkdir -p "$SINGULARITY_CACHEDIR" "$SINGULARITY_TMPDIR"
chgrp -R $PROJECT_ "$SINGULARITY_CACHEDIR" "$SINGULARITY_TMPDIR"
chmod -R g+rX "$SINGULARITY_CACHEDIR" "$SINGULARITY_TMPDIR"
chmod g+s "$SINGULARITY_CACHEDIR" "$SINGULARITY_TMPDIR"

PIPE_ROOT="/g/data/if89/testdir/pacbio_workflows/HiFi-human-WGS-WDL/HiFi-human-WGS-WDL-v3.2.0"
cd "$PIPE_ROOT"

# Generate the list of Docker images referenced by WDL
bash scripts/create_image_manifest.sh

echo "Processing $(wc -l < image_manifest.txt) images listed in image_manifest.txt ..."

# Helper: MiniWDL-expected cache filename for a Docker ref (no docker:// prefix)
# Examples:
#   quay.io/pacbio/pb_wdl_base@sha256:abcd -> docker___quay.io_pacbio_pb_wdl_base@sha256_abcd.sif
#   docker.io/google/deepvariant:1.9.0     -> docker___docker.io_google_deepvariant_1.9.0.sif
expected_name() {
    local ref="$1"
    # Preserve '@'; convert '/' to '_', and ':' to '_'
    echo "docker___$(echo "$ref" | sed 's#/#_#g; s#:#_#g').sif"
}

# Ensure each ref has an explicit registry; if missing, default to docker.io
ensure_registry() {
    local ref="$1"
    if [[ "$ref" != */*/* ]]; then
        echo "docker.io/${ref}"
    else
        echo "$ref"
    fi
}

# Pull each image as a Singularity SIF into the shared cache with the MiniWDL naming
while read -r docker_ref; do
    # Skip GPU DeepVariant if present in manifest
    if [[ "$docker_ref" == "google/deepvariant:1.9.0-gpu" ]]; then
        echo "Skipping (GPU image not required): $docker_ref"
        continue
    fi

    docker_ref="$(ensure_registry "$docker_ref")"
    sif_name="$(expected_name "$docker_ref")"
    sif_path="$SINGULARITY_CACHEDIR/$sif_name"

    if [[ -f "$sif_path" ]]; then
        echo "Skipping (already exists): $sif_name"
        continue
    fi

    echo "Pulling: docker://$docker_ref -> $sif_name"
    for attempt in 1 2 3; do
        echo "Attempt $attempt: $docker_ref"
        if singularity pull --disable-cache \
                --dir "$SINGULARITY_CACHEDIR" \
                --name "$sif_name" \
                "docker://$docker_ref"; then
            break
        fi
        sleep 20
    done
done < image_manifest.txt

echo "Pulled images to: $SINGULARITY_CACHEDIR"
ls -ld "$SINGULARITY_CACHEDIR"
ls -l "$SINGULARITY_CACHEDIR" | head
