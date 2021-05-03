#! /bin/bash

version="0.3"
testroot="$HOME/appltest/design_$version/partition_stack"

partition='L'

echo "module --force purge ; "
echo "export MODULEPATH=$testroot/modules/SystemPartition ; "
echo "export LMOD_MODULE_ROOT=$testroot ; "
echo "export LMOD_PACKAGE_PATH=$testroot/github/prototypes/design_$version/LMOD ; "
echo "export LMOD_RC=$testroot/github/prototypes/design_$version/LMOD/lmodrc.lua ; "
echo "export LMOD_ADMIN_FILE=$testroot/github/prototypes/design_$version/LMOD/admin.list ; "
echo "export LMOD_AVAIL_STYLE=ps_labeled:system ; "
echo "export LUMI_PARTITION=$partition ; "
echo "module load partition/auto ; "
