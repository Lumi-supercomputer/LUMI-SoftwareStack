# Fake 21.08 toolchain using 21.12 modules.
# Make sure CPEpackages_21.08.csv contains the list for 21.12 before sourcing
# this script from the directory where this script is located!

pushd ..

pushd ../../modules/Infrastructure/LUMI/21.12/partition
find . -name cpeGNU  -exec /bin/rm -rf '{}' \;
find . -name cpeCray -exec /bin/rm -rf '{}' \;
find . -name cpeAMD  -exec /bin/rm -rf '{}' \;
popd

pushd ../easybuild/easyconfigs/c
find . -name cpeGNU-21.08.eb  -exec /bin/rm -f '{}' \;
find . -name cpeCray-21.08.eb -exec /bin/rm -f '{}' \;
find . -name cpeAMD-21.08.eb  -exec /bin/rm -f '{}' \;
popd

/bin/rm -f ../../mgmt/LMOD/ModuleRC

./prepare_LUMI_stack.sh 21.08 4.4.2 $HOME/Work

popd
