#!/usr/bin/env bash

device=
user=
remote=

paths=(
)

echo "Restoring directories"

for f in "${paths[@]}"; do
    rsync ARGS \
        --no-perms --no-owner --no-group \
        SOURCE \
        DEST
done

