#!/bin/sh

programs=$(find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename '{}' \;)

for program in ${programs}; do
    stow -R "$program"
    echo "$program"
done

