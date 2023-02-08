#! /bin/bash
#
# Script to do a single synchronization of the /appl/lumi subdirectories
#

main_appl='/pfs/lustref1/appl/lumi'
destinations=( '/pfs/lustrep1/appl/lumi' '/pfs/lustrep2/appl/lumi' '/pfs/lustrep3/appl/lumi' '/pfs/lustrep4/appl/lumi' )
dest_short=(   'lustrep1'                'lustrep2'                'lustrep3'                'lustrep4' )
destinations_git=( '/pfs/lustrep1/appl/lumi' )
dest_git_short=(   'lustrep1' )

logdir="$HOME/appl_sync_logs"
mkdir -p $logdir
logfile="$(date --iso-8601=seconds).txt"

#
# Ask for confirmation. We may want to remove this once we have a more final solution.
#
echo -e "\nCopying LUMI-SoftwareStack and LUMI-EasyBuild-contrib from $main_appl, are you sure?"
select yn in "Yes" "No"; do
    case $yn in
        No ) exit  ;;
        * )  break ;;
    esac
done

#
# Now we assume we're only using this for adding software at the moment.
# Removing can always be postponed to a moment when there are no users on the
# system. Hence we make sure that we only update the modules after all other
# directories are updated to avoid problems with modules being available on
# a node without the software.
#
# In a final setup we may even want to go further:
#  * First sync everything on all volumes except the modules
#  * Then quickly synch the modules on all volumes.
#
# This would avoid the problem that software may already be available on some nodes
# but not on others.
#

# --archive = --recursive --links --perms --times --group --owner --devices --specials
# Note that --group and --owner may not work depending on the rights of the account
# running the rsync:
#  * --owner: Only a superuser can change owners
#  * --group: A regular user can only change the group to one of their groups
# The --devices --specials (or -D) implied by --archive make no sense in our case.
#

#
# Update the LUMI-EasyBuild-contrib repo but don't copy the git structures
# to save some space.
#
directory='LUMI-EasyBuild-contrib'
printf "\nPushing the $directory directory...\n"
for i in "${!destinations[@]}"
do
    destination="${destinations[$i]}"
    echo "- Starting the sync of $directory from $main_appl to $destination."
    mkdir -p $destination/$directory
    rsync --archive --delete --exclude '.git*' $main_appl/$directory/ $destination/$directory/ >& "$logdir/${dest_short[$i]}_$logfile" &
done
wait
echo "Done"

#
# Update the LUMI-SoftwareStack repo but don't copy the git structures
# to save some space.
#
directory='LUMI-SoftwareStack'
printf "\nPushing the $directory directory...\n"
for i in "${!destinations[@]}"
do
    destination="${destinations[$i]}"
    echo "- Starting the sync of $directory from $main_appl to $destination."
    mkdir -p $destination/$directory
    rsync --archive --delete --exclude '.git*' $main_appl/$directory/ $destination/$directory/ >& "$logdir/${dest_short[$i]}_$logfile" &
done
wait
echo "Done"

#
# Update the git repository LUMI-EasyBuild-contrib repo
#
directory='LUMI-EasyBuild-contrib/.git'
printf "\nPushing the $directory directory...\n"
for i in "${!destinations_git[@]}"
do
    destination="${destinations_git[$i]}"
    echo "- Starting the sync of $directory from $main_appl to $destination."
    mkdir -p $destination/$directory
    rsync --archive --delete $main_appl/$directory/ $destination/$directory/ >& "$logdir/${dest_git_short[$i]}_$logfile" &
done
wait
echo "Done"

#
# Update the git repository in LUMI-SoftwareStack repo
#
directory='LUMI-SoftwareStack/.git'
printf "\nPushing the $directory directory...\n"
for i in "${!destinations_git[@]}"
do
    destination="${destinations_git[$i]}"
    echo "- Starting the sync of $directory from $main_appl to $destination."
    mkdir -p $destination/$directory
    rsync --archive --delete $main_appl/$directory/ $destination/$directory/ >& "$logdir/${dest_git_short[$i]}_$logfile" &
done
wait
echo "Done"

