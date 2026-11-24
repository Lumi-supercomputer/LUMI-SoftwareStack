#! /bin/bash
#
# Script to clean up broken Brotli version and its dependencies
#
# The script takes no arguments.
#
# The root of the installation is derived from the place where the script is found.
# The script should be in <installroot>/${repo}/scripts with <installroot> the
# root for the installation.
#

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd "$(dirname $0)"
cd ../..
repo="${PWD##*/}"
cd ..
installroot="$(pwd)"

package_list=(
    Brotli
    freetype
    pixman
    cURL
    fontconfig
    PROJ
    libgeotiff
    libgd
    X11
    FFmpeg
    Tk
    cairo
    GObject-Introspection
    HarfBuzz
    Pango
    gnuplot
)

#
# Clear modules
#
cd $installroot/modules/easybuild/LUMI/26.03
for item in ${package_list[@]}
do 
    echo "Cleaning up $item module"
    find . -name $item
    find . -name $item -exec /bin/rm -rf '{}' \;
done


cd $installroot/mgmt/ebfiles_repo/LUMI-26.03
for item in ${package_list[@]}
do 
    echo "Cleaning up $item easyconfig in ebfiles_repo"
    find . -name "$item*.eb"
    find . -name "$item*.eb" -exec /bin/rm -rf '{}' \;
done



cd $installroot/SW/LUMI-26.03
for item in ${package_list[@]}
do 
    echo "Cleaning up $item software"
    find . -maxdepth 3 -name $item
    find . -maxdepth 3 -name $item -exec /bin/rm -rf '{}' \;
done



