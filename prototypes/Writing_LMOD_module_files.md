# Writing LMOD module files

LMOD sometimes has unexpected behaviour that may look evident when you think about
implementation issues, but seems very unlogical.

In particular, the sequence of module loading and unloading is sometimes very strange.

  * Modules are often unloaded in the same order as they were loaded rather than in
    the opposite order which one would often expect.

  * The way in which conflicts are detected and then resolved between modules of the
    same family is also strange. This results in a long sequence of module loads and
    unloads which is different from the sequence when a different version of a module
    with the same name as an already loaded module is loaded.

The result of this is that a module may be unloaded in a different environment then
when it was loaded, even when a user does not screw up their environment.

  * Environment variables may be undefined because the module that defined them
    has already been unloaded, because the order of unloading may be the same as the
    order of loading the modules.

  * Environment variables may have a different value than the one they had when the
    module was loaded. One very likely scenario for this is in a module hierarchy
    where a level in the hierarchy corresponds to a family of modules rather than
    different versions of the same module, due to the strange sequence of loading and
    unloading modules in such a hierarchy when one module of a family gets replaced
    by another through ``module load``.

    Maybe a load hook that forces ``module switch`` can exclude that case, but even
    then the first problem with the undefined environment variable still exists.

Now module unload works by running the module file again but reversing the action
of many LMOD functions. In particular:

  * ``prepend_path`` and ``append_path`` can only undo their action when they are
    called with the same directory when unloading as when loading. This may be a
    problem if that directory is the result of a calculation relying on, e.g.,
    environment variables but even on other properties of the node as in a Slurm
    job script, the unload may happen on a different node as where the load was
    done since a Slurm batch script inherits the environment, including loaded
    modules, from the shell that called ``sbatch``, ``salloc`` or ``srun``.

  * As far as we understand so far, ``setenv`` is safe as it only needs the name
    of the environment variable to unset that environment variable. It doesn't try
    to restore the value that was there before ``module load`` was called.

    It would be unsafe though if the name of the variable that is set is itself the
    result of a computation, but this is extremely rare.

  * TO DO: Study how ``pushenv`` works and check when this is safe or unsafe.

Hence some good practices:

  * Minimize use of the environment by relying on the place of a module in the module
    tree as much as possible instead. This means that some modules will have to stored in
    or linked from multiple locations instead.

    Moreover, path parsing of a module file is harder than it seems as LMOD doesn't
    seem to have a function to return the full path of a module file. Instead, there
    is the ``hierarchyA`` function that does some parsing already for you, but we have
    run into strange bugs with that, and the behaviour of the function also depends
    on the naming scheme of the current module (e.g., just name or name/version).

  * Be aware that you cannot even rely on environment variables set by the system
    itself outside the module system, in particular in combination with Slurm. Slurm
    will start the job in an environment inhereted from when the job was submitted,
    which is on a different node of the cluster. Hence even a ``module purge`` in
    a job script may fail to, e.g., remove some directories from a path variable when the
    module was loaded if you cannot reproduce the exact directories that were used
    as the argument for ``prepend_path`` and ``append_path``.

  * If you rely on environment variables to compute arguments to, e.g., ``prepend_path``,
    you'll need a different code path for ``module unload`` that reconstructs that exact
    argument.

      * You may be able to recover that from the path-style variable, but that may not
        always work, in particular when loading a module of the same family. In that case
        it turns out the new module may be loaded before the old one is unloaded. If both
        add almost the same directory to the path except for the part of the name that you
        are interested in, it may screw up your detection algorithm. Specifically, assume
        A and B are two modules of the same family, module A is loaded and now the user
        loads module B. Then the sequence of loads and unloads will be:

          1. *Load module B*. This is when LMOD detects it is of the same family as the
             already loaded module A. At this point both modules of the same family
             are loaded.
          2. *Unload module A*. Note that module B was already loaded so anything it does
             to the path is done already!
          3. *Unload module B*.
          4. *Load module B*.

      * You can consider storing the information about the state in an environment variable.
        However: the name of that variable should be unique except for other modules with the
        same name (as there as far as we can see the unload always happens before the load of
        a new module). Using the same variable isn't safe within modules of the same family
        if they can have a different name, see the scenario of the previous bullet where
        there are two points where it would go wrong:
          1. *Load module B*: This would overwrite the memory variable, but the load would
             proceed correctly.
          2. *Unload module A*: The memory variable now has the wrong value so the unload
             wouldn't work the way one expects. It would also unset the memory variable.
          3. *Unload module B*: Now even reading the memory variable would fail as it has been
             unset already.
          4. *Load module B*: This would likely work as it should and set the memory variable
             again.

