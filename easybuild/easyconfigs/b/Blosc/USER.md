# Blosc User Information

## What is Blosc?

Blosc is a high performance compressor optimized for binary data. It has been
designed to transmit data to the processor cache faster than the traditional,
non-compressed, direct memory fetch approach via a memcpy() OS call. Blosc is
the first compressor (that I'm aware of) that is meant not only to reduce the
size of large datasets on-disk or in-memory, but also to accelerate
memory-bound computations (which is typical in vector-vector operations).

It uses the blocking technique 
(as described in [this article](https://www.blosc.org/docs/StarvingCPUs-CISE-2010.pdf))
to reduce activity
on the memory bus as much as possible. In short, the blocking technique works
by dividing datasets in blocks that are small enough to fit in L1 cache of
modern processor and perform compression/decompression there. It also
leverages SIMD (SSE2) and multi-threading capabilities present in nowadays
multi-core processors so as to accelerate the compression/decompression
process to a maximum.
