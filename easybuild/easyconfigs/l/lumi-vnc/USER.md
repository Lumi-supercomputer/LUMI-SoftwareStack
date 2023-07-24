# lumi-vnc user instructions

VNC (Virtual Network Computing) is a type of client application that can be used for interacting with graphical applications.

The lumi-VNC modules are pre-installed on LUMI. You don't need to load any modules prior to loading a lumi-vnc module. The lumi-vnc modules only require the `init-lumi/0.2` module to be present, which is there by default when you log into LUMI. 

To know how to start the VNC server, check the help information included in the most
recent version of the module returned by the above `module spider` command. E.g., assuming
that version is 20230110:
```bash
module spider lumi-vnc/20230110
```


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
