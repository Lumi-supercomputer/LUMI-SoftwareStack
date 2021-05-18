#! /bin/bash

# Just to be sure, add the binary directory to the PATH.
PATH=$HOME/appl/bin:$PATH

cd $HOME
mkdir -p work
cd work

version='2.27'
[[ -f gpp-$version.tar.bz2 ]] || wget https://github.com/logological/gpp/releases/download/$version/gpp-$version.tar.bz2
tar -xf gpp-$version.tar.bz2
cd $HOME/work/gpp-$version
./configure --prefix=$HOME/appl
make ; make install

cd $HOME/work
rm -rf gpp-$version

