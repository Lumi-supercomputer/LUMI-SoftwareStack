# lumi-tools user information

## lumi-workspaces

The `lumi-workspaces` command can be used to check your file quota on the 
system.

The command comes in three different forms:
  * `lumi-workspaces`         : Shows your workspaces
  * `lumi-workspaces -v`      : Detailed quota information
  * `lumi-workspaces -p prj`  : Show quota of project prj


## lumi-allocations

The `lumi-allocations` command can be used to check the status of your
allocations on LUMI.

-   To check all your remaining allocations, simply run
    `lumi-allocations`. (Does not yet work)
-   To check your allocation in your project_465000000 (replace with your project 
    number): `lumi-allocations -p project_465000000`
-   Use `lumi-allocations --help`
    for more informations.
