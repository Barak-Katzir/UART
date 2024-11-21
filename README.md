
# UART Communication Project

## Overview
This project implements a Universal Asynchronous Receiver-Transmitter (UART) for serial communication, designed using VHDL. It includes modules for the receiver, transmitter, and their respective testbenches. The project has been verified through simulation scripts and pin constraints to ensure proper hardware deployment.

---

## Project Features
- **Transmitter Module**: Handles data serialization and transmission.
- **Receiver Module**: Decodes incoming serial data into parallel form.
- **Testbenches**: Comprehensive test environments for both the transmitter and receiver modules.
- **Configurable Parameters**: Baud rate, data bits.
- **Scripts**:
  - `.do` files for simulation automation.
  - `.tcl` file for pin constraints in FPGA tools.

---

## Project Structure
```
UART_Project/
├── src/
│   ├── uart.vhd          # Top-level UART design
│   ├── receiver.vhd      # Receiver module
│   ├── transmitter.vhd   # Transmitter module
├── testbench/
│   ├── tb_receiver.vhd   # Testbench for receiver
│   ├── tb_transmitter.vhd# Testbench for transmitter
├── scripts/
│   ├── receiver.do       # Simulation script for receiver
│   ├── transmitter.do    # Simulation script for transmitter
│   ├── uart_test_pins.tcl# Pin constraint file
├── uart_test.vhd         # Integration and testing module using a loopback
└── README.md             # Project documentation
```

---

## Requirements
- **HDL Design Tools**: [e.g., ModelSim for simulation, Vivado/Quartus for synthesis]
- **Hardware**: [e.g., Nexys A7 FPGA or similar development board]

---

## How to Use
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yourusername/UART_Project.git
   ```
2. **Simulate the Design**:
   - Use the `.do` files in the `scripts/` directory to automate testing in your simulator.
   - Example for ModelSim:
     ```bash
     do receiver.do
     ```
3. **Synthesize and Deploy**:
   - Use your preferred FPGA toolchain (e.g., Vivado, Quartus) to synthesize the design.
   - Apply the `uart_test_pins.tcl` for pin assignment and constraints.
4. **Test Hardware**:
   - Connect the FPGA to a serial terminal (e.g., Tera Term, Putty) and verify communication.

---

## Testing
- **Simulation**: Testbenches for the transmitter and receiver verify functional correctness.
- **Hardware**: The design has been tested on an FPGA board using a loopback configuration.

---

## Future Improvements
- Add error-checking mechanisms (e.g., parity error detection).
- Support for flow control (RTS/CTS).
- Extend to higher data rates with clock scaling.

---
