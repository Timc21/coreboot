# PCIe Tools

This directory contains utilities for debugging and analyzing PCIe (PCI Express) configurations and error status.

## pcie_root_port_status.sh

A diagnostic script that displays PCIe Root Port error reporting configuration and status.

### Purpose

This script reads and displays the error handling configuration registers for all PCIe Root Ports on the system, including:
- **AER (Advanced Error Reporting)** registers:
  - Uncorrectable Error Mask
  - Uncorrectable Error Severity
  - Correctable Error Mask
- **DPC (Downstream Port Containment)** registers:
  - DPC Control
  - RP PIO (Root Port Programmed I/O) Error Mask
  - RP PIO Error Severity
  - RP PIO Error System Error
  - RP PIO Error Exception

### Requirements

- `lspci` - PCI utilities package (pciutils)
- `setpci` - PCI configuration space access utility (pciutils)
- Root/sudo privileges to access PCI configuration space

### Usage

```bash
sudo ./pcie_root_port_status.sh
```

### Output

The script displays a table with the following columns:
- `RootPort`: PCI address (domain:bus:device.function)
- `UCE_Mask`: Uncorrectable Error Mask register
- `UCE_Severity`: Uncorrectable Error Severity register
- `CE_Mask`: Correctable Error Mask register
- `DPC_Control`: DPC Control register
- `RPPIO_Mask`: Root Port PIO Error Mask
- `RPPIO_Severity`: Root Port PIO Error Severity
- `RPPIO_SysError`: Root Port PIO System Error
- `RPPIO_Exception`: Root Port PIO Exception

Register values are displayed in hexadecimal format. If a capability is not supported or not found, "N/A" is shown.
