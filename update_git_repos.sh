#!/usr/bin/env bash

# update_git_repos.sh old_org_name new_org_name directory
#
# Update the default git remote (origin) for all git repositories
# directly inside the directory you are.  The git remotes are
# updated by replacing instances of old_org_name with new_org_name.

set -o nounset
set -o errexit
set -o pipefail

HELP_INFORMATION="update_git_repos.sh old_org_name new_org_name"

if [[ $# -ne 2 ]]
then
    echo "$HELP_INFORMATION"
else
    old_org_name=$1
    new_org_name=$2
    
    echo Renaming from "$old_org_name" to "$new_org_name"...
    
    for dir in */
    do
        pushd "$dir" > /dev/null 2>&1
        
        echo Checking "$dir" ...
           
        # The git rev-parse command gives a return code of 0 if and
        # only if the current directory is a git repo.
        #
        # The git remote show origin catches the unlikely case that
        # the current directory is a git repo but does not have a
        # remote named origin.
        if git rev-parse --git-dir > /dev/null 2>&1 && git remote show origin > /dev/null 2>&1
        then
            old_url=$(git remote get-url origin)
            new_url=${old_url//$old_org_name/$new_org_name}

            if [[ $new_url != "$old_url" ]]
            then
                echo Updating origin URL from "$old_url" to "$new_url" for "$dir"
                git remote set-url origin "$new_url"
            fi
        fi
        popd > /dev/null 2>&1
    done
fi
