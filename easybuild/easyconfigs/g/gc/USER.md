# gc user instructions

The [Böhm-Demers-Weiser conservative garbage collector](https://hboehm.info/gc/) can be used as a 
garbage collecting replacement for C malloc or C++ new. 
It allows you to allocate memory basically as you normally would, 
without explicitly deallocating memory that is no longer useful. 
The collector automatically recycles memory when it determines that 
it can no longer be otherwise accessed.

The collector is also used by a number of programming language implementations that 
either use C as intermediate code, want to facilitate easier interoperation with C libraries, 
or just prefer the simple collector interface. 
Alternatively, the garbage collector may be used as a leak detector for C or C++ programs, 
though that is not its primary goal.

