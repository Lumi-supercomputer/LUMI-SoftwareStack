#! /bin/bash

version="0.4"
testroot="$HOME/appltest/design_$version"
repo='SystemRepo'

partition='L'

$testroot/$repo/scripts/enable_LUMI.sh
echo "export LUMI_PARTITION=$partition ; "
