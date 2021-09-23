#! /bin/bash

#
# Latest versions
# - LUA: http://www.lua.org/download.html
# - LuaRocks: https://github.com/luarocks/luarocks/wiki/Download
# - TCL: https://www.tcl.tk/software/tcltk/
# - LMOD: https://github.com/TACC/Lmod/releases
#
lua_version=5.4.3
luarocks_version=3.7.0
tcl_version=8.6.11
lmod_version=8.5.14

# Just to be sure, add the binary directory to the PATH.
PATH=$HOME/appl/bin:$PATH

cd $HOME
mkdir -p work
cd work

#
# Lua installation
#
# - Lua itself
#
cd $HOME/work
# https://www.lua.org/ftp/lua-5.4.3.tar.gz
[[ -f lua-$lua_version.tar.gz ]] || wget https://www.lua.org/ftp/lua-$lua_version.tar.gz
tar -xf lua-$lua_version.tar.gz
cd $HOME/work/lua-$lua_version
# Patch src/luaconf.h to use the correct value for LUA_ROOT
# as otherwise packages will not be found
sed -i -e "s/\/usr\/local\//${HOME//\//\\\/}\/appl\//" src/luaconf.h
# Build
make linux install INSTALL_TOP=$HOME/appl
#
# - LuaRocks
#
cd $HOME/work
[[ -f luarocks-$luarocks_version.tar.gz ]] || wget https://luarocks.org/releases/luarocks-$luarocks_version.tar.gz
tar -xf luarocks-$luarocks_version.tar.gz
cd $HOME/work/luarocks-$luarocks_version
./configure --with-lua=$HOME/appl --prefix=$HOME/appl
make ; make install
#
# - posix and filesystem packages
#
cd $HOME/work
luarocks --lua-dir $HOME/appl install luaposix
luarocks --lua-dir $HOME/appl install luafilesystem

#
# Install Tcl
#
cd $HOME/work
# https://prdownloads.sourceforge.net/tcl/tcl8.6.11-src.tar.gz
[[ -f tcl$tcl_version-src.tar.gz ]] || wget https://prdownloads.sourceforge.net/tcl/tcl$tcl_version-src.tar.gz
tar -xf tcl$tcl_version-src.tar.gz
cd $HOME/work/tcl$tcl_version/unix
./configure --prefix=$HOME/appl
make ; make install
cd $HOME/appl/bin
ln -s tclsh8.6 tclsh

#
# Install Lmod
#
cd $HOME/work
[[ -f lmod-$lmod_version.tar.gz ]] || eval "wget https://github.com/TACC/Lmod/archive/refs/tags/$lmod_version.tar.gz ; mv $lmod_version.tar.gz lmod-$lmod_version.tar.gz"
tar -xf lmod-$lmod_version.tar.gz
cd $HOME/work/Lmod-$lmod_version
TCL_INCLUDE=-I$HOME/appl/include \
PATH_TO_TCLSH=$HOME/appl/bin/tclsh8.6 \
./configure --prefix=$HOME/appl/share \
            --with-lua_include=/$HOME/appl/include \
            --with-lua=$HOME/appl/bin/lua \
            --with-luac=$HOME/appl/bin/luac
make install

#
# Clean up
#
cd $HOME/work
rm -rf lua-$lua_version
rm -rf luarocks-$luarocks_version
rm -rf tcl$tcl_version
rm -rf Lmod-$lmod_version

# Initialise:
# module purge
# source $HOME/appl/share/lmod/lmod/init/bash
