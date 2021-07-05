#! /bin/bash

tmpdir="$XDG_RUNTIME_DIR/EBtesting"

mkdir -p "$tmpdir/modules"
mkdir -p "$tmpdir/software"
mkdir -p "$tmpdir/repo"

export EASYBUILD_INSTALLPATH_MODULES=$tmpdir/modules
export EASYBUILD_INSTALLPATH_SOFTWARE="$tmpdir/software"
export EASYBUILD_REPOSITORYPATH="$tmpdir/repo"
unset EASYBUILD_HOOKS

echo -e "\n##\n##\n## EasyBuild config\n##\n##\n"
eb --show-config

for file in $(find . -name "cpe*.eb" | sed -e 's|\./||')
do

    basename=${file%.eb}
    name=${basename%%-*}
    version=${basename#*-}

    mkdir -p "$tmpdir/modules-good/$name"
    mkdir -p "$tmpdir/modules-test/$name"

	echo -e "\n##\n##\n## TESTCASE $name/$version ($file)\n##\n##\n"

    eb $file -f

    sed -e '/local root.*/d' -e '/setenv.*EBROOT.*/d' "Results/$name/$version.lua"         >"$tmpdir/modules-good/$name/$version.lua"
    sed -e '/local root.*/d' -e '/setenv.*EBROOT.*/d' "$tmpdir/modules/$name/$version.lua" >"$tmpdir/modules-test/$name/$version.lua"

    echo -e "\n## Comparing module files:\n"

    diff "$tmpdir/modules-good/$name/$version.lua" "$tmpdir/modules-test/$name/$version.lua"

done

