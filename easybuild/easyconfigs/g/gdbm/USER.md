# gdbm User Documentation

[GNU dbm ](https://www.gnu.org.ua/software/gdbm/)
(or GDBM, for short) is a library of database functions that use
extensible hashing and work similar to the standard UNIX dbm. These routines
are provided to a programmer needing to create and manipulate a hashed
database.

The basic use of GDBM is to store key/data pairs in a data file. Each key
must be unique and each key is paired with only one data item.

The library provides primitives for storing key/data pairs, searching and
retrieving the data by its key and deleting a key along with its data. It
also support sequential iteration over all key/data pairs in a database.

For compatibility with programs using old UNIX dbm function, the package
also provides traditional dbm and ndbm interfaces.

There is a [web-based manual](https://www.gnu.org.ua/software/gdbm/manual/index.html).
