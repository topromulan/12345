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

WIDTH=1		#The character position we are testing at

CURRENT=0	#Set this to 1 after we catch up to current.

XLOGOS=0	#The number of xlogos we have popped up

while [ $WIDTH -le ${#GOAL} ]
do
	TIME=`date +%s`

	if [ $TIME -gt $GOAL ]
	then
		echo $0: Error. Time $TIME is greater than goal. > /dev/stderr
		break
	fi

	if [ ${GOAL:0:WIDTH} == ${TIME:0:WIDTH} ]
	then
		#We matched at $WIDTH characters.
		MATCHES=$((MATCHES+1))

		#Increment $WIDTH
		WIDTH=$((WIDTH + 1))

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
			echo $0: Time is $TIME. Goal is $GOAL.
			echo $0: $((GOAL - TIME)) time units until goal.
			echo $0: Currently checking at $WIDTH characters.
			CURRENT=1
		fi

		#Create a pad of an appropriate amount of zeros:
		ZEROS=`echo $GOAL | sed s/./0/g`

		#Fill in the current matches:
		NEXTEVENT=`echo $ZEROS | sed 's/^.\{'$((MATCHES+1))'\}/'${GOAL:0:MATCHES+1}'/'`

		#Calculate how long until the next match:
		OFFSET=$((NEXTEVENT - TIME))

		#Sleep for half the time, if it is more than
		# ten seconds away. If it is sooner than ten 
		# seconds away then monitor closely so we can
		# pop up the next xlogo right on goal.

		if [ $OFFSET -gt 10 ]
		then
			echo $0: Next event occurs in $OFFSET time units.
			sleep $((OFFSET / 2))
		else
			sleep 1
		fi
	fi
	
done

###############################################
# Final report and 
#  Issue congratulations (if warranted by 1 or more xlogos popping up).

echo $0: Time $TIME equals $GOAL.

echo -n "$0: "

if [ $XLOGOS -gt 0 ]
then
	#Congratulations are in order
	echo -n "Congratulations! "
fi

echo You have been observing for $XLOGOS xlogos.

#
###############################################
# Return an error code for success or failure
#  

if [ $XLOGOS == 0 ]
then
	exit 1
fi

exit 0

