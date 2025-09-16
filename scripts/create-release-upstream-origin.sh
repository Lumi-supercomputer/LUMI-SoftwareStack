#!/usr/bin/env bash

repo_origin='origin'
repo_upstream='upstream'

# That cd will work if the script is called by specifying the path or is simply
# found on PATH. It will not expand symbolic links.
cd $(dirname $0)
cd ../..
root=$(pwd)

if [ "$#" -ne 1 ]
then
    echo -e "This script expects 1 argument: The tag to be used for the release. It also" \
            "\nexpects a file <tag>.txt in ${root}/LUMI-SoftwareStack-tags" \
            "\nwith the message to use for the annotated tag.\n"

    exit 1
fi
tag="$1"

echo -e "Creating release $tag.\n\nRelease message:\n$(cat $root/LUMI-SoftwareStack-tags/$tag.txt)\n"

#
# LUMI-SoftwareStack
#
repo="LUMI-SoftwareStack"
cd "$root/$repo"
echo -e "\n\nProcessing $repo"
set -x
branch="$(git rev-parse --abbrev-ref HEAD)" ; git stash push
git checkout main
git pull $repo_upstream main
git push $repo_origin main
git tag -a "$tag" -F "$root/LUMI-SoftwareStack-tags/$tag.txt"
git push $repo_origin "$tag"
git push $repo_upstream "$tag"
git checkout $branch ; git stash pop
set +x

#
# LUMI-EasyBuild-contrib
#
repo="LUMI-EasyBuild-contrib"
cd "$root/$repo"
echo -e "\n\nProcessing $repo"
set -x
branch="$(git rev-parse --abbrev-ref HEAD)" ; git stash push
git checkout main
git pull $repo_upstream main
git push $repo_origin main
git tag -a "$tag" -F "$root/LUMI-SoftwareStack-tags/$tag.txt"
git push $repo_origin "$tag"
git push $repo_upstream "$tag"
git checkout $branch ; git stash pop
set +x

#
# LUMI-EasyBuild-containers
#
repo="LUMI-EasyBuild-containers"
cd "$root/$repo"
echo -e "\n\nProcessing $repo"
set -x
branch="$(git rev-parse --abbrev-ref HEAD)" ; git stash push
git checkout main
git pull $repo_upstream main
git push $repo_origin main
git tag -a "$tag" -F "$root/LUMI-SoftwareStack-tags/$tag.txt"
git push $repo_origin "$tag"
git push $repo_upstream "$tag"
git checkout $branch ; git stash pop
set +x

#
# LUMI-EasyBuild-docs
#
repo="LUMI-EasyBuild-docs"
cd "$root/$repo"
echo -e "\n\nProcessing $repo"
set -x
branch="$(git rev-parse --abbrev-ref HEAD)" ; git stash push
git checkout main
git pull $repo_upstream main
git push $repo_origin main
git tag -a "$tag" -F "$root/LUMI-SoftwareStack-tags/$tag.txt"
git push $repo_origin "$tag"
git checkout $branch ; git stash pop
set +x

echo -e "\nWhen finished installing on LUMI, execute:" \
        "\ncd $root/$repo && git push $repo_upstream $tag" \
        "\nto trigger the re-generation of the LUMI Software Library.\n"
