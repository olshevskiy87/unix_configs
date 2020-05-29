#!/usr/bin/env bash

if pidof -q -x "xidlehook" >/dev/null 2>&1; then
    echo "xidlehook is already running"
    exit 1
fi

xidlehook --version > /dev/null 2>&1
if [ "$?" != "0" ]; then
    echo "error: xidlehook not found"
    exit 1;
fi
i3lock --version > /dev/null 2>&1
if [ "$?" != "0" ]; then
    echo "error: i3lock not found"
    exit 1;
fi

xidlehook --timer 120 \
    "i3lock --ignore-empty-password --show-failed-attempts --color 333333" \
    "" &
