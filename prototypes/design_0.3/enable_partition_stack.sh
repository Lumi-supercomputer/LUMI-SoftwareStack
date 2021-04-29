#! /bin/bash

version="0.3"
testroot="$HOME/appltest/design_$version/partition_stack"

partition='L'

echo "export MODULEPATH=$testroot/modules/SystemPartition ; "
echo "export LMOD_MODULE_ROOT=$testroot ; "
echo "export LMOD_PACKAGE_PATH=$testroot/github/prototypes/design_$version/LMOD ; "
echo "export LMOD_ADMIN_FILE=$testroot/github/prototypes/design_$version/LMOD/admin.list ; "
echo "export LMOD_AVAIL_STYLE=sp_labeled:system ; "
echo "export LUMI_PARTITION=LUMI-$partitition ; "
echo "module load partition/$partition; "
