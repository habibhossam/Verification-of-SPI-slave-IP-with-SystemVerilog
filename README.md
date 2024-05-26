# Verification of SPI Slave IP with SystemVerilog

## Project Overview

This project involves the verification of an SPI slave IP using SystemVerilog. The goal is to test the SPI slave IP, either as an actual IP or an abstract model, using a black box approach. The project emphasizes the use of SystemVerilog features such as interfaces, classes, constrained-random stimulus generation, and coverage-driven verification methodologies. This project is part of the CND training program at AUC and was conducted under the supervision of Dr. Omar Eldash.

## Table of Contents

1. [Project Description](#project-description)
2. [Tasks Performed](#tasks-performed)
3. [Assessment Criteria](#assessment-criteria)
4. [Directory Structure](#directory-structure)
5. [Setup and Usage](#setup-and-usage)
6. [Contributors](#contributors)

## Project Description

The project aims to verify an SPI slave IP by creating a comprehensive testbench in SystemVerilog. The testbench will incorporate advanced features of SystemVerilog, including:

- **Interfaces**: For modular and reusable testbench components.
- **Classes**: For object-oriented verification components.
- **Constrained-Random Stimulus Generation**: To ensure thorough testing with a wide range of scenarios.
- **Coverage-Driven Verification**: To measure the completeness of the verification process.

The project involves creating different test scenarios to demonstrate the modularity and reusability of the test environment.

## Tasks Performed

1. **Testbench Development**:
   - Developed a modular testbench using SystemVerilog interfaces and classes.
   - Implemented constrained-random stimulus generation to create diverse test scenarios.
   - Utilized assertions to check for correct behavior during simulation.
   - Employed coverage-driven verification to ensure thorough testing.

2. **Test Scenarios**:
   - Created multiple test scenarios to verify the SPI slave IP under various conditions.
   - Ensured the testbench could handle different data transfer rates, data widths, and operating modes.

3. **Simulation and Coverage Analysis**:
   - Ran simulations to verify the functionality of the SPI slave IP.
   - Analyzed coverage metrics to identify untested parts of the design and improved test cases accordingly.

## Assessment Criteria

The project was assessed based on the following criteria:

- **Utilization of SystemVerilog Features**: Evaluation of the usage of SystemVerilog constructs like interfaces, classes, randomization, assertions, and coverage.
- **Testbench Completeness**: Assessing the comprehensiveness and effectiveness of the SystemVerilog testbench in verifying the functionality of the design.
- **Functional Verification**: How well the testbench verifies the functionality of the design under different scenarios.
- **Simulation Results and Coverage**: Analysis of simulation results and coverage metrics to ensure thorough testing.

## Directory Structure

```
.
├── docs/                 # Documentation files
├── src/                  # Source files for SPI slave IP
├── testbench/            # Testbench files and test scenarios
│   ├── interfaces/       # SystemVerilog interfaces
│   ├── classes/          # SystemVerilog classes for verification components
│   ├── tests/            # Test scenarios
│   └── coverage/         # Coverage reports and metrics
├── simulation/           # Simulation scripts and results
├── images/               # Images used in documentation
└── README.md             # This readme file
```

## Setup and Usage

1. **Clone the repository**:
   ```sh
   git clone https://github.com/habibhossam/Verification-of-SPI-slave-IP-with-SystemVerilog.git
   cd Verification-of-SPI-slave-IP-with-SystemVerilog
   ```

2. **Environment Setup**:
   Ensure you have a compatible SystemVerilog simulation tool installed (e.g., Synopsys VCS, Mentor Graphics Questa, Cadence Incisive). Consult the `docs/setup.md` for detailed setup instructions.

3. **Running the Testbench**:
   Each major step in the verification flow has corresponding scripts and instructions in its directory. Follow the README files within each directory for step-by-step instructions.

4. **Generating Simulation Results and Coverage Reports**:
   After completing the test scenarios, the simulation results and coverage reports can be found in the `simulation` and `coverage` directories.

## Contributors

- Habib Hossam - [GitHub](https://github.com/habibhossam)
- Adham Mohamed - [GitHub](https://github.com/Adham-M0)
- Mohamed Abouelhamd - [GitHub](https://github.com/Mohamed-Abouelhamd)
- Tarek Omara - [GitHub](https://github.com/tarekaboelmaged)
- Abdallah Yehia - [GitHub](https://github.com/Abdallah-Elbarkokry)
