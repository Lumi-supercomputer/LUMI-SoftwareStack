#! /bin/bash

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
reporoot="$(pwd)"

partition='L'

$reporoot/scripts/enable_LUMI.sh
echo "export LUMI_OVERWRITE_PARTITION=$partition ; "
