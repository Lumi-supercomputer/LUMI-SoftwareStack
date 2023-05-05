# lumi-CrayPath user information

The lumi-CrayPath module adds `CRAY_LD_LIBRARY_PATH` to the front of
`LD_LIBRARY_PATH` when the module is loaded
and removes the added directories again when unloading
the module (providing that the user did not manually change or clear the 
environment variable `_CRAYPATH_STORED_CRAY_LD_LIBRARY_PATH` which is essential
to the proper working of this module). 

After loading modules that have changed `CRAY_LD_LIBRARY_PATH` is is sufficient
to load the `lumi-CrayPath` module again to correct `LD_LIBRARY_PATH` as Lmod 
will automatically first unload `lumi-CrayPath` and then load it again, effectively
first resetting the operations done on `LD_LIBRARY_PATH` the previous time the
module was loaded and then applying the changes with the current `CRAY_LD_LIBRARY_PATH`,
ensuring that all those directories are at the front of the `LD_LIBRARY_PATH` again.
