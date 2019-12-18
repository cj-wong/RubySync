#!/usr/bin/env bash

device=

path=

echo "Backing up $device:$path to remote" && sleep 1

rsync ARGS \
    SOURCE \
    DEST \
    | grep -vi "skipping non-regular file"

echo "Done"
