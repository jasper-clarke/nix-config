#!/usr/bin/env sh

if [[ $(cmus-remote -C status) == "" ]]; then
    echo
else
    cmus-remote -C status | grep -m 1 "tag title" | cut -d ' ' -f3-
fi
