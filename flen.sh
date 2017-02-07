#!/bin/bash

# flen - the function length counter
# counts the number of lines between two { } matching pairs
# This can look in *.c *.cpp *.h *.php files, or any other language
# that uses braces for scope.  It is very primitive and will not
# detect #ifdefs, or commented code, so may give false positives in
# some situations, so proceed with caution
#
# Written By: Matthew MacDonald
# Date: 02-Feb-2017

COUNT=0
# CountBraces
# Matches up pairs of { }
# length when this limit is exceeded.  If no limit is provided
# then all function lengths will be printed.  You probably don't
# want to do that.
function CountBraces() {

j=0
i=0
theFileName=$1
theLengthLimit=$2
theDepthLimit=$3

aListOfBraces=`grep -on '\{\|\}' $theFileName`

for line in $aListOfBraces
do
	IFS=':' read -ra anArrayOfBraces <<< $line
	aLineNumber=${anArrayOfBraces[0]}
	aBraceCharacter=${anArrayOfBraces[1]}

	if [ "$aBraceCharacter" = "{" ]
	then
		arr[$j]=$aLineNumber
		((j++))
		if [ $j -gt $theDepthLimit ]
		then
			echo "(depth) $theFileName:$aLineNumber $j"
			((COUNT++))
		fi
	elif [ "$aBraceCharacter" = "}" ]
	then
		((j--))
		if [ $j -lt 0 ]
		then
			echo "(error) $theFileName:$aLineNumber"
			((COUNT++))
			return
		fi

		x=${arr[$j]}
		aFunctionLength=$((aLineNumber-x))

		if [ $aFunctionLength -gt $theLengthLimit ]
		then
			echo "(length) $theFileName:$x $aFunctionLength"
			((COUNT++))
		fi
	fi
done
}


function PrintHelp() {
        echo ""
	echo "flen - the function length counter"
	echo "usage: flen -l <length> -d <depth> -p <path> -t <type>"
	echo "Where:"
	echo "	-l,--length	lines of code between opening and closing braces"
	echo "	-d,--depth	Number of successive opening braces"
	echo "	-p,--path	Path to files in which to search"
	echo "	-t,--type	type of files in which to inspect"
	echo ""
	echo "example: ./flen.sh -l 400 -d 10 -p . -t \"*.c\""
	echo ""
	echo "Sometimes you may wish to sort the output of flen:"
	echo "./flen.sh -l 400 -d 10 -p . -t \"*.c\" | sort -k3nr" 
}

################################### MAIN #####################################


# flen -l <function length> -d <depth> -p <path> -t <file type>
DEPTH=999
LENGTH=999999

# Parse Command Line Arguments
while [[ $# -gt 1 ]]
do
	key="$1"

	case $key in
		-d|--depth)
		DEPTH="$2"
		shift # past argument
		;;
		-p|--path)
		SEARCHPATH="$2"
		shift # past argument
		;;
		-l|--length)
		LENGTH="$2"
		shift # past argument
		;;
		-t|--type)
		FILETYPE="$2"
		;;
		*)
		# unknown option
		PrintHelp
		exit 1
		;;
	esac
shift # past argument or value
done

if [ -z $SEARCHPATH ]
then
	echo "Please provide a path in which to search"
	PrintHelp
	exit 1
elif [ -z $FILETYPE ]
then
	echo "Please provide a file type to inspect"
	PrintHelp
	exit 1
fi


aListOfFiles=`find $SEARCHPATH -type f -name "$FILETYPE"`

for file in $aListOfFiles; do
	CountBraces $file $LENGTH $DEPTH
done

exit $COUNT
################################### EOF ######################################
