#!/usr/bin/env bash

path=

echo "Backing up Sublime Text 3 configuration" && sleep 1

rsync ARGS \
    SOURCE --no-links \
    DEST \
    | grep -vi "skipping non-regular file"

echo "Done"
