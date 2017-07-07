#!/bin/bash
############################################################################
#Skeleton of nagios-like plugin using /bin/bash
################################################################################
#Nagios Constants
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
SCRIPTPATH=`echo $0 | sed -e 's,[\\/][^\\/][^\\/]*$,,'`
if [[ -f ${SCRIPTPATH}/utils.sh ]]; then
	. ${SCRIPTPATH}/utils.sh # use nagios utils to set real STATE_* return values
fi

#Useful functions
printversion(){
	echo "$0 $VERSION"
	echo
}

printusage() {
	printversion
	echo "Usage:"
	echo "  $0 [-w <warnlevel>] [-c <critlevel>] [-v]"
	echo "    checks blablabla"
	echo "    add -v for verbose (debugging purpose)"
	echo "  $0 -V"
	echo "    prints version"
	echo "  $0 -x"
        echo "    enables debugging (bash set -x)"
	echo "  $0 -h"
	echo "    prints help (this message)"
}

printvariables() {
	echo "Variables:"
	#Add all your variables at the end of the "for" line to display them in verbose
	for i in WARNING_THRESHOLD CRITICAL_THRESHOLD FINAL_STATE FINAL_COMMENT ENABLE_PERFDATA VERSION
	do
		echo -n "$i : "
		eval echo \$${i}
	done
	echo
}

#Set to unknown in case of unplanned exit
FINAL_STATE=$STATE_UNKNOWN
FINAL_COMMENT="UNKNOWN: Unplanned exit. You should check that everything is OK"

#Default values (should be changed according to context)
WARNING_THRESHOLD=1
CRITICAL_THRESHOLD=1
ENABLE_PERFDATA=0
VERSION="1.0"

#Process arguments. Add proper options and processing
while getopts ":c:hvVw:x" opt; do
	case $opt in
		c)
			CRITICAL_THRESHOLD=$OPTARG
			;;
		h)
			printusage
			exit $STATE_OK
			;;
		v)
			echo "Verbose mode ON"
			echo
			VERBOSE=1
			;;
		V)
			printversion
			exit $STATE_UNKNOWN
			;;
		w)
			WARNING_THRESHOLD=$OPTARG
			;;
		x)
			set -x
			;;
		\?)
			echo "UNKNOWN: Invalid option: -$OPTARG"
			exit $STATE_UNKNOWN
			;;
		:)
			echo "UNKNOWN: Option -$OPTARG requires an argument."
			exit $STATE_UNKNOWN
			;;
	esac
done

#Check all the mandatory arguments, adapt to your case
if [[ -z $CRITICAL_THRESHOLD || -z $WARNING_THRESHOLD ]]; then
echo "UNKNOWN: No warning or critical threshold given"
        printusage
        exit $STATE_UNKNOWN
fi

#Real check goes here. Write your own code according to context
#####REAL CHECK GOES HERE
#At the end of this, you should
# - Put check status in $FINAL_STATE
# - Put check output in $FINAL_COMMENT
# - Put numbered values in $CHECK_VALUE, used for perfdata

#Perfdata processing, if applicable
if [[ $ENABLE_PERFDATA -eq 1 ]] ; then
	PERFDATA=" | $CHECK_VALUE;$WARNING_THRESHOLD;$CRITICAL_THRESHOLD;"
fi

#Script end, display verbose information
if [[ $VERBOSE -eq 1 ]] ; then
	printvariables
fi

echo ${FINAL_COMMENT}${PERFDATA}
exit $FINAL_STATE
