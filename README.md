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

flen - the function length counter
usage: flen -l <length> -d <depth> -p <path> -t <type>
Where:
	-l,--length	lines of code between opening and closing braces
	-d,--depth	Number of successive opening braces
	-p,--path	Path to files in which to search
	-t,--type	type of files in which to inspect

example: ./flen.sh -l 400 -d 10 -p . -t *.c

Sometimes you may wish to sort the output of flen:
./flen.sh -l 400 -d 10 -p . -t *.c | sort -k3nr
