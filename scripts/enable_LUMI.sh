#! /bin/bash

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
cd ..
repo=${PWD##*/}
cd ..
installroot=$(pwd)

#
# Print the commands that should be executed via eval to initialise
# the LUMI module system from the location based on the location of this
# script.
#
# - Clear LMOD. We will restart it.
#   This is essential as otherwise restore will reset the MODULEPATH that
#   we build here,
echo "clearLmod ; "
echo "unset _LUMI_INIT_FIRST_LOAD ; "

# - Resource the program environment initialisation
echo "source /appl/lumi/LUMI-SoftwareStack/Setup/cray-pe-configuration.sh ; "

# - Correct the path in some variables read from the system file.
#echo "installroot=$installroot ; "
#echo "sysroot='/appl/lumi' ; "
installroot=${installroot//\//\\\/}
sysroot='\/appl\/lumi'
echo "mpaths=\"\${mpaths//$sysroot/$installroot}\" ; "
echo "LMOD_PACKAGE_PATH=\"\${LMOD_PACKAGE_PATH/$sysroot/$installroot}\" ; "
echo "LMOD_RC=\"\${LMOD_RC/$sysroot/$installroot}\" ; "
echo "LMOD_ADMIN_FILE=\"\${LMOD_ADMIN_FILE/$sysroot/$installroot}\" ; "

# - Initialise LMOD
echo "source /usr/share/lmod/lmod/init/profile ; "

# - Build MODULEPATH
echo "mod_paths=\"/opt/cray/pe/lmod/modulefiles/core " \
               "/opt/cray/pe/lmod/modulefiles/craype-targets/default " \
               "\$mpaths " \
               "/opt/cray/modulefiles " \
               "/opt/modulefiles\" ; "
echo "MODULEPATH='' ; "
echo "for p in \$(echo \$mod_paths) ; do " \
     "    if [ -d \$p ] ; then " \
     "        MODULEPATH=\$MODULEPATH:\$p ; " \
     "    fi ; " \
     "done ; "
echo "MODULEPATH=\"\${MODULEPATH/:/}\" ; "
echo "export MODULEPATH ; "

# - Build LMOD_SYSTEM_DEFAULT_MODULES
echo "LMOD_SYSTEM_DEFAULT_MODULES=\$(echo \${init_module_list:-PrgEnv-\$default_prgenv} | /usr/bin/sed 's|[ ][ ]*|:|g') ; "
echo "export LMOD_SYSTEM_DEFAULT_MODULES ; "

# - Re-initialize LMOD but
echo "module --initial_load --no_redirect restore ; "
