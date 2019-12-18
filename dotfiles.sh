#!/usr/bin/env bash

home="$HOME/."
device=

device_paths=(
)

paths=(
)

echo "Backing up $device dotfiles" && sleep 1

for f in "${device_paths[@]}"; do
    rsync ARGS SOURCE --no-links \
        DEST \
        | grep -vi "skipping non-regular file"
done

echo "Backing up universal dotfiles" && sleep 1

for f in "${paths[@]}"; do
    rsync ARGS \
        SOURCE \
        DEST
done

echo "Done"
