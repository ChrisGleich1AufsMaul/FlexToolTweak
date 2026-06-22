#!/usr/bin/env bash
set -euo pipefail

export THEOS_PACKAGE_SCHEME=rootless

rm -rf .theos packages
make clean package FINALPACKAGE=1

mkdir -p output
find packages -type f \( -name "*.deb" -o -name "*.dylib" \) -exec cp {} output/ \;
