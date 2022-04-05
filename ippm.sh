#!/bin/bash
set -e

ACPI_CALL_PATH=/proc/acpi/call
CONSERVATION_MODE_PATH="/sys/bus/platform/drivers/ideapad_acpi/VPC*/conservation_mode"

check_conservation() {
    cat $CONSERVATION_MODE_PATH
}

set_conservation() {
    case $1 in
        0)
            echo "Turn OFF conservation mode"
            echo 0 | tee $CONSERVATION_MODE_PATH > /dev/null
            ;;
        1)
            echo "Turn ON conservation mode"
            echo 1 | tee $CONSERVATION_MODE_PATH > /dev/null
            ;;
        *)
            >&2 echo "0 or 1 expected"
            exit 1
            ;;
    esac
}

check_rapid_charge() {
	# Check if rapid charge is on
	echo '\_SB.PCI0.LPC0.EC0.FCGM' | tee $ACPI_CALL_PATH > /dev/null 2>&1
	BYTE0=$(tr -d '\0' < $ACPI_CALL_PATH  | grep -o "0x.")

	if [[ $BYTE0 == "0x0" ]]
	then
		echo 0
	else
		echo 1
	fi
}

set_rapid_charge() {
	case $1 in
	    0)
            echo "Turn OFF rapid charge"
            echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x08' | tee $ACPI_CALL_PATH > /dev/null 2>&1
            ;;
        1)
            echo "Turn ON rapid charge"
		    echo '\_SB.PCI0.LPC0.EC0.VPC0.SBMC 0x07' | tee $ACPI_CALL_PATH > /dev/null 2>&1
            ;;
        *)
            >&2 echo "0 or 1 expected"
            exit 1
            ;;
	esac
}

check_perf_mode() {
	# Check status of BIOS POWER MODE
	echo '\_SB.PCI0.LPC0.EC0.STMD' | tee $ACPI_CALL_PATH > /dev/null 2>&1
	BYTE0=$(tr -d '\0' < $ACPI_CALL_PATH  | grep -o "0x.")
	echo '\_SB.PCI0.LPC0.EC0.QTMD' | tee $ACPI_CALL_PATH > /dev/null 2>&1
	BYTE1=$(tr -d '\0' < $ACPI_CALL_PATH  | grep -o "0x.")

	case "$BYTE0 $BYTE1" in
		"0x0 0x0" )
			echo 0
			;;
		"0x0 0x1" )
			echo 1
			;;
		"0x1 0x0" )
			echo 2
			;;
	esac
}

set_perf_mode() {
	case $1 in
		0)
			echo "Turning on Extreme Performance mode in BIOS"
			echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0012B001' | tee $ACPI_CALL_PATH > /dev/null 2>&1
			;;
		1)
			echo "Turning on Battery Saving mode in BIOS"
			echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x0013B001' | tee $ACPI_CALL_PATH > /dev/null 2>&1
			;;
		2)
			echo "Turning on Intelligent Cooling mode in BIOS"
			echo '\_SB.PCI0.LPC0.EC0.VPC0.DYTC 0x000FB001' | tee $ACPI_CALL_PATH > /dev/null 2>&1
			;;
		*) 
			>&2 echo "Choose one of [ 0=EXTREME_PERFORMANCE , 2=INTELLIGENT_COOLING , 1=BATTERY_SAVING ]"
			exit 1
			;;
	esac
}



if [[ $1 == "get" ]]
then
    if [[ $2 == "cm" ]]
    then
        check_conservation
        exit 0
    elif [[ $2 == "rc" ]]
    then
        check_rapid_charge
        exit 0
    elif [[ $2 == "perf" ]]
    then
        check_perf_mode
        exit 0
    fi
elif [[ $1 == "set" ]]
then
    if [[ $2 == "cm" ]]
    then
        set_conservation $3
        exit 0
    elif [[ $2 == "rc" ]]
    then
        set_rapid_charge $3
        exit 0
    elif [[ $2 == "perf" ]]
    then
        set_perf_mode $3
        exit 0
    fi
fi

echo "Usage: ippm [set/get] [cm/rc/perf] [num]"
