#!/bin/bash

# flen - the function length counter
# counts the number of lines between two { } matching pairs
# arg 1: Numeric limit over which to report
# arg 2: where to look (path)
# This will look in *.c *.cpp *.h *.php files
#
# Written By: Matthew MacDonald
# Date: 02-Feb-2017

BLOCKSTART="{"
BLOCKEND="}"

# CountBraces
# Matches up pairs of { }
# arg 1: the file name
# arg 2: Optional numerical limit.  This will echo the function
# length when this limit is exceeded.  If no limit is provided
# then all function lengths will be printed.  You probably don't
# want to do that.
function CountBraces() {

theLineNumber=0
j=0
i=0
theFileName=$1

if [ -z $2 ]
then
	theOptionalLineLimit=0
else
	theOptionalLineLimit=$2
fi


while read line
do
	for (( i=0; i<${#line}; i++ )); do
		if [ "${line:$i:1}" = "$BLOCKSTART" ]
		then
			arr[$j]=$theLineNumber
			((j++))
		elif [ "${line:$i:1}" = "$BLOCKEND" ]
		then
			((j--))
			if [ $j -lt 0 ]
			then
				echo "$theFileName:$theLineNumber error"
				return
			fi
			x=${arr[$j]}
			theFunctionLength=$((theLineNumber-x))
			if [ $theFunctionLength -gt $theOptionalLineLimit ]
			then
				echo "$theFileName:$x $theFunctionLength"
			fi
		fi
	done
	((theLineNumber++))
done < $1
}


################################### MAIN #####################################
aFileType=$3
aPath=$2
aLimit=$1
aListOfFiles=`find $aPath -type f -name "$aFileType"`

if [ $# -lt 3 ]
then
	echo ""
	echo "flen - the function length counter"
	echo "usage: flen <length> <path> <file type>"
	echo "example: ./flen.sh 400 . *.c"
	echo ""
	echo "Sometimes you may wish to sort the output of flen:"
	echo "./flen.sh 400 . *.c | sort -k2nr" 
	exit 1
fi

for file in $aListOfFiles; do
	CountBraces $file $aLimit
done
################################### EOF ######################################
