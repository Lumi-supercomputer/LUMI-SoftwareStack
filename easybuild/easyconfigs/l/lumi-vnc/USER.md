# lumi-vnc user instructions

VNC stands for Virtual Network Computing. It is a server running on the supercomputer and emulating an X11 server,
rendering the image on the supercomputer and making it available to a client either via a VNC client that needs
to be installed on your local machine, or via a web browser (using a web server included in the module and
working with the VNC server).

The module is available in all environments on LUMI, including the default login environment.

To know how to start the VNC server, check the help information included in the most
recent version of the module with `module help` command. The versions can be found
in the list further down this page.
E.g., assuming the most recent version is 20230110:

```bash
module help lumi-vnc/20230110
```

For most users, running `start-vnc` is sufficient and it will print information about how to connect
in the terminal. The VNC server should be cleaned up automatically if you leave the shell from which
it was started.


## Known issues

### Missing fonts

When testing with x11perf (included in the X11 modules on LUMI), certain tests fail
due to missing fonts:

font '8x13'
font '9x15'
font '-misc-fixed-medium-r-normal--14-130-75-75-c-140-jisx0208.1983-*'
font '-jis-fixed-medium-r-normal--24-230-75-75-c-240-jisx0208.1983-*'
font '-adobe-times-medium-r-normal--10-100-75-75-p-54-iso8859-1'
font '-adobe-times-medium-r-normal--24-240-75-75-p-124-iso8859-1'
font '-adobe-times-medium-r-normal--10-100-75-75-p-54-iso8859-1'
