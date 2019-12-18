#!/usr/bin/env bash

function restore {
    echo "Restoring $1 to $2"
    rsync ARGS \
        DEST \
        "$2/./"
}

device=

remote=
dotfiles=

paths=(
)

device_paths=(
)

sublimetext=

echo "Restoring universal dotfiles" && sleep 1

for f in "${paths[@]}"; do
    restore "$dotfiles/./$f" "$HOME"
done

echo "Restoring $device dotfiles" && sleep 1

for f in "${device_paths[@]}"; do
    restore "$dotfiles/$device/./$f" "$HOME"
done

echo "Restoring Sublime Text 3 configuration" && sleep 1

restore "$sublimetext" "$HOME/.config"

echo "Done"
