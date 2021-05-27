#! /bin/bash

version="0.4"
testroot="$HOME/appltest/design_$version/stack_partition"

partition='L'

echo "module --force purge ; "
echo "export MODULEPATH=$testroot/modules/SoftwareStack:$testroot/modules/StyleModifiers ; "
echo "export LMOD_MODULE_ROOT=$testroot ; "
echo "export LMOD_PACKAGE_PATH=$testroot/SystemRepo/LMOD ; "
echo "export LMOD_RC=$testroot/SystemRepo/LMOD/lmodrc.lua ; "
echo "export LMOD_ADMIN_FILE=$testroot/SystemRepo/LMOD/admin.list ; "
echo "export LMOD_AVAIL_STYLE=label:system ; "
echo "export LUMI_PARTITION=$partition ; "
