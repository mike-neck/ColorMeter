#!/usr/bin/env bash

if [[ ! -e "build" ]]; then
    mkdir -p build
fi
cp .build/release/ColorMeter build/color-meter

