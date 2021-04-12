#! /bin/bash

# Just to be sure, add the binary directory to the PATH.
PATH=$HOME/appl/bin:$PATH

cd $HOME
mkdir -p work
cd work

wget https://sourceforge.net/projects/lmod/files/lua-5.1.4.9.tar.bz2
tar -xf lua-5.1.4.9.tar.bz2
cd lua-5.1.4.9
./configure --prefix=$HOME/appl
make ; make install

cd $HOME/work
wget https://prdownloads.sourceforge.net/tcl/tcl8.4.20-src.tar.gz
tar -xf tcl8.4.20-src.tar.gz
cd tcl8.4.20/unix
./configure --prefix=$HOME/appl
make ; make install
cd $HOME/appl/bin
ln -s tclsh8.4 tclsh

cd $HOME/work
wget https://github.com/TACC/Lmod/archive/refs/tags/8.4.28.tar.gz
tar -xf 8.4.28.tar.gz
cd Lmod-8.4.28
TCL_INCLUDE=$HOME/appl/include \
./configure --prefix=$HOME/appl/share \
            --with-lua_include=/$HOME/appl/include \
            --with-lua=$HOME/appl/bin/lua \
            --with-luac=$HOME/appl/bin/luac
make install

# Initialise:
# module purge
# source $HOME/appl/share/lmod/lmod/init/bash
