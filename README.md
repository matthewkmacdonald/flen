# flen
Function Line-Length Calculator

Introduction

For various reasons it may be advantageous to determine if any functions
within a source file exceed a specified line-length.  This can be useful
when searching for code smells, or to encforce coding standards on a CI
system through automated tests.

flen is a bash script which recursively searches directories for specified
file types and seeks out long functions by matching up pairs of curly-braces,
while counting the lines between matched pairs.

usage: flen <length> <path> <file type>
example: ./flen.sh 400 . *.c

Sometimes you may wish to sort the output of flen:
./flen.sh 400 . *.c | sort -k2nr
