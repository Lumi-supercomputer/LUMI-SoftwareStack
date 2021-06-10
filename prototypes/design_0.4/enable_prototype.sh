#! /bin/bash

version="0.4"
testroot="$HOME/appltest/design_$version"

partition='L'

$testroot/SystemRepo/scripts/enable_LUMI.sh
echo "export LUMI_PARTITION=$partition ; "
