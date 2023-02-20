#!/bin/bash --norc
## Original script was using -l but this has been deleted to make it less dependent on /user.

if [ -f /var/lib/user_info/users/$USER/$USER.json ]
then
    /usr/bin/jq -j -r 'if .home_quota.block_quota_used >= .home_quota.block_quota_soft then "\u001b[31mWARNING: home directory space quota exceeded\u001b[0m\n" else "" end, if .home_quota.inode_quota_used >= .home_quota.inode_quota_soft then "\u001b[31mWARNING: home directory file count quota exceeded\u001b[0m\n" else "" end' < /var/lib/user_info/users/$USER/$USER.json
fi

for group in $(/usr/bin/groups)
do
    if [ -f /var/lib/project_info/users/$group/$group.json ]
    then
        /usr/bin/jq 'if .billing.storage_hours.alloc == 0 then "1" else "" end' < /var/lib/project_info/users/$group/$group.json | grep -q 1 && continue
        /usr/bin/jq -j -r 'if .storage_quotas.directories.scratch.block_quota_used >= .storage_quotas.directories.scratch.block_quota_soft then "\u001b[31mWARNING: "+.name+" scratch directory space quota exceeded\u001b[0m\n" else "" end, if .storage_quotas.directories.scratch.inode_quota_used >= .storage_quotas.directories.scratch.inode_quota_soft then "\u001b[31mWARNING: "+.name+" scratch directory file count quota exceeded\u001b[0m\n" else "" end' < /var/lib/project_info/users/$group/$group.json
        /usr/bin/jq -j -r 'if .billing.storage_hours.remaining < 0 then "\u001b[31mWARNING: "+.name+" is out of storage hours\u001b[0m\n" else "" end' < /var/lib/project_info/users/$group/$group.json
    fi
done
