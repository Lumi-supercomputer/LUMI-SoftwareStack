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
