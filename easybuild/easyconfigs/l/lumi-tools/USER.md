# lumi-tools user information

## lumi-workspaces

The `lumi-workspaces` command combines the `lumi-quota` and `lumi-allocations`
commands shown below, but is currently only capable to show the output for
all your workspaces/projects (user workspace on `/user`and the various project-related
workspaces on `/project`, `/scratch` and `/flash`).

Note that currently no output is displayed about storage use on the object file 
system as that one is still under development.

The check of the allocations in `lumi-workspaces` and `lumi-allocations` 
is currently done based on pre-stored data. That
data is refreshed periodically, but the data can be out-of-date, especially
if the scripts that build up the cache fail. Currently the tool is not
able to show when the data was collected, so the results may be wrong without
warning.


## lumi-quota

The `lumi-quota` command can be used to check your file quota on the 
system.

The command comes in three different forms:
  * `lumi-quota`         : Shows quota for all your workspaces (user and project)
  * `lumi-quota -v`      : Detailed quota information
  * `lumi-quota -p prj`  : Show quota of project prj

This tool only produces output about the Lustre file systems, so directories in
`/user`, `/project` (or the old name `/projappl`), `/scratch` and `/flash`.


## lumi-allocations

The `lumi-allocations` command can be used to check the status of your
allocations on LUMI.

-   To check all your remaining allocations, simply run
    `lumi-allocations`. 
-   Use `lumi-allocations --help`
    for more informations. This command will be extended with more features in the
    future that will be shown through this flag.


## lumi-check-quota (version 23.02 and higher)

The `lumi-check-quota` command is equivalent to the script run at login that prints
a warning when you are running out of quota or out of billing units.

Note that this is fully based on cached data gathered from time to time in the background.
The command will in no way show 100% correct instantaneous numbers.


## lumi-ldap-projectinfo (version 23.04 and higher)

`lumi-ldap-projectinfo` shows information about projects as it is kept in the 
LDAP system. The amount of information that is shown depends on your privileges
on the system as not all information is available to regular users and as 
regular users can only see data from their own projects. The information includes
information about the allocation and quota. That is not live information but
computed periodically. The tool also shows the members of the project.

This tool shows more information than `lumi-allocations`, `lumi-quota` or
`lumi-workspaces`. However, `lumi-quota` and `lumi-workspaces` show quota
information almost in real time. It is complementary to the
`lumi-ldap-userinfo` tool that shows user information from the LDAP.


## lumi-ldap-userinfo (version 23.04 and higher)

`lumi-allocations` shows information about projects as it is kept in the 
LDAP system. The amount of information that is shown depends on your privileges
on the system as regular users can only see data from themselves. 
The information includes information about the quota. That is not live information but
computed periodically. The tool also shows a list of projects 
found on the system (in the group database) for the given user(s).

This tool shows more information than `lumi-quota` or
`lumi-workspaces`. However, `lumi-quota` and `lumi-workspaces` show quota
information almost in real time. It is complementary to the
`lumi-ldap-projectinfo` tool that shows project information from the LDAP.
