#!/bin/bash

#A handy shell script to pop up an xlogo each time another digit
# in the decimal seconds since the epoch lines up with 1234567890
# (10 X 123456789!)
#
# 8 February 2009 by Dale Anderson
# dra@redevised.net
#

GOAL=1234567890		# 10 X 123456789

SYNTAX="$0"			#Script takes no arguments

###############################################
# Validate the user syntax

if [ "$1" != "" ]
then

	if [ "$1" == "--help" ]
	then
		#OK, they asked for it..
		echo $SYNTAX
		exit 0
	fi

	#Now they really asked for it!
	echo $SYNTAX > /dev/stderr
	exit 1
fi

###############################################
# Begin popping up xlogos as the time aligns

n=1		#The character position we are testing at

CURRENT=0	#Set this to 1 after we catch up to current.

XLOGOS=0	#The number of xlogos we have popped up

while [ $n -le ${#GOAL} ]
do
	TIME=`date +%s`

	if [ $TIME -gt $GOAL ]
	then
		echo $0: Error. Time $TIME is greater than goal. > /dev/stderr
		exit 1
	fi

	if [ ${GOAL:0:n} == ${TIME:0:n} ]
	then
		#We matched at $n characters.
		MATCHES=$((MATCHES+1))

		#Increment $n
		n=$((n + 1))

		#Pass until we are current
		if [ $CURRENT != 0 ]
		then
			#Yay!
			echo $0: The time is $TIME. Popping up an xlogo.
			xlogo &
			XLOGOS=$((XLOGOS + 1))
		fi
	else
		#We didn't match. If we weren't current
		# then now we are. 
		if [ $CURRENT == 0 ]
		then
			echo $0: Time is $TIME.
			echo $0: Currently checking at $n characters.
			CURRENT=1
		fi

		#Hold 1 second.
		sleep 1
	fi
	
done

###############################################
# Issue congratulations

echo $0: Time $TIME equals $GOAL.
echo $0: Congratulations. You have been observing for $XLOGOS xlogos.


