# lzip-tools user information

## Content of the module

-   `lzip`: [Lzip](https://www.nongnu.org/lzip/) is a lossless data compressor with a user interface 
    similar to the one of gzip or bzip2. Lzip uses a simplified form of LZMA 
    (Lempel-Ziv-Markov chain-Algorithm) designed to achieve complete 
    interoperability between implementations. Decompression speed is 
    intermediate between gzip and bzip2.
  
-   `lunzip`: [Lunzip](https://www.nongnu.org/lzip/lunzip.html) is a decompressor for the lzip format written in C. Its small 
    size makes it well suited for embedded devices or software installers that 
    need to decompress files but don't need compression capabilities.
  
    Note that you can also decompress with "lzip -d" which is different code.
  
-   `plzip`: [Plzip](https://www.nongnu.org/lzip/plzip.html) is a massively parallel (multi-threaded) implementation 
    of lzip.
  
-   `lziprecover`: [Lziprecover](https://www.nongnu.org/lzip/lziprecover.html) is a data recovery tool and decompressor for 
    files in the lzip compressed data format (.lz). Lziprecover also provides 
    Forward Error Correction (FEC) able to repair any kind of file.

    Lziprecover can remove the damaged members from multimember files, for 
    example multimember tar.lz archives.
  
    Lziprecover provides random access to the data in multimember files; it 
    only decompresses the members containing the desired data.
  
    Lziprecover is not a replacement for regular backups, but a last line of 
    defense for the case where the backups are also damaged.

-   `tarlz`: [Tarlz](https://www.nongnu.org/lzip/tarlz.html) is a massively parallel (multi-threaded) combined implementation
    of the tar archiver and the lzip compressor.

    Keeping the alignment between tar members and lzip members has two 
    advantages. It adds an indexed lzip layer on top of the tar archive, 
    making it possible to decode the archive safely in parallel. It also 
    reduces the amount of data lost in case of corruption. Compressing a 
    tar archive with plzip may even double the amount of files lost for 
    each lzip member damaged because it does not keep the members aligned.

-   [Zutils](https://www.nongnu.org/zutils/zutils.html) is a collection of utilities able to process any combination 
    of compressed and uncompressed files transparently. If any file given, 
    including standard input, is compressed, its decompressed content is used. 
    Compressed files are decompressed on the fly; no temporary files are created. 
    Data format is detected by its identifier string (magic bytes), not by the 
    file name extension. Empty files are considered uncompressed.
    
    It provides more powerfull versions of the `zcat`, `zcmp`, `zdiff`, `zgrep`, 
    `zegrep` and `zfgrep` from gzip and additional `ztest`and `zupdate` commands 
