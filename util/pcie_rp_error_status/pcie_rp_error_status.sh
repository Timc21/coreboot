#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-only

# Print header
printf "%-12s %-12s %-15s %-12s %-12s %-12s %-15s %-15s %-15s\n" \
"RootPort" "UCE_Mask" "UCE_Severity" "CE_Mask" "DPC_Control" "RPPIO_Mask" "RPPIO_Severity" "RPPIO_SysError" "RPPIO_Exception"
printf "================================================================================================================================\n"

# Find all Intel PCIe Root Ports (vendor ID 8086)
ROOT_PORTS=$(lspci -d 8086:: | grep "PCI bridge" | cut -d' ' -f1)

if [ -z "$ROOT_PORTS" ]; then
    echo "No PCIe Root Ports found."
    exit 1
fi

for dev in $ROOT_PORTS; do
    # Find AER Capability Base
    AER_BASE=$(lspci -s $dev -vvv | grep -i "Advanced Error Reporting" | grep -oP '\[\K[0-9a-fA-F]+')

    # Find DPC Capability Base
    DPC_BASE=$(lspci -s $dev -vvv | grep -i "Downstream Port Containment" | grep -oP '\[\K[0-9a-fA-F]+')

    #echo dev=$dev
    #echo AER_BASE=$AER_BASE
    #echo DPC_BASE=$DPC_BASE

    # Read registers, default to "N/A" if not found
    AER_UCE_MASK="N/A"
    AER_UCE_SEV="N/A"
    AER_CE_MASK="N/A"
    DPC_CTRL="N/A"
    RPPIO_MASK="N/A"
    RPPIO_SEV="N/A"
    RPPIO_SYSERR="N/A"
    RPPIO_EXC="N/A"

    if [ -n "$AER_BASE" ]; then
        AER_UCE_MASK=$(setpci -s "$dev" $(printf "%x" $((0x$AER_BASE + 0x08))).L)
        AER_UCE_SEV=$(setpci -s "$dev" $(printf "%x" $((0x$AER_BASE + 0x0c))).L)
        AER_CE_MASK=$(setpci -s "$dev" $(printf "%x" $((0x$AER_BASE + 0x14))).L)
    fi

    if [ -n "$DPC_BASE" ]; then
        DPC_CTRL=$(setpci -s "$dev" $(printf "%x" $((0x$DPC_BASE + 0x06))).w)
        RPPIO_MASK=$(setpci -s "$dev" $(printf "%x" $((0x$DPC_BASE + 0x10))).L)
        RPPIO_SEV=$(setpci -s "$dev" $(printf "%x" $((0x$DPC_BASE + 0x14))).L)
        RPPIO_SYSERR=$(setpci -s "$dev" $(printf "%x" $((0x$DPC_BASE + 0x18))).L)
        RPPIO_EXC=$(setpci -s "$dev" $(printf "%x" $((0x$DPC_BASE + 0x1C))).L)
    fi

    # Print row
    printf "%-12s %-12s %-15s %-12s %-12s %-12s %-15s %-15s %-15s\n" \
    "$dev" "$AER_UCE_MASK" "$AER_UCE_SEV" "$AER_CE_MASK" "$DPC_CTRL" "$RPPIO_MASK" "$RPPIO_SEV" "$RPPIO_SYSERR" "$RPPIO_EXC"
done
