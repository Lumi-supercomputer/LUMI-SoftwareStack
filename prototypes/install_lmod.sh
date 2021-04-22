#! /bin/bash

lua_version=5.1.4.9
tcl_version=8.4.20
lmod_version=8.4.30

# Just to be sure, add the binary directory to the PATH.
PATH=$HOME/appl/bin:$PATH

cd $HOME
mkdir -p work
cd work

wget https://sourceforge.net/projects/lmod/files/lua-$lua_version.tar.bz2
tar -xf lua-$lua_version.tar.bz2
cd lua-$lua_version
./configure --prefix=$HOME/appl
make ; make install

cd $HOME/work
wget https://prdownloads.sourceforge.net/tcl/tcl$tcl_version-src.tar.gz
tar -xf tcl$tcl_version-src.tar.gz
cd tcl$tcl_version/unix
./configure --prefix=$HOME/appl
make ; make install
cd $HOME/appl/bin
ln -s tclsh8.4 tclsh

cd $HOME/work
wget https://github.com/TACC/Lmod/archive/refs/tags/$lmod_version.tar.gz
mv $lmod_version.tar.gz lmod-$lmod_version.tar.gz
tar -xf lmod-$lmod_version.tar.gz
cd Lmod-$lmod_version
TCL_INCLUDE=$HOME/appl/include \
./configure --prefix=$HOME/appl/share \
            --with-lua_include=/$HOME/appl/include \
            --with-lua=$HOME/appl/bin/lua \
            --with-luac=$HOME/appl/bin/luac
make install

# Initialise:
# module purge
# source $HOME/appl/share/lmod/lmod/init/bash
