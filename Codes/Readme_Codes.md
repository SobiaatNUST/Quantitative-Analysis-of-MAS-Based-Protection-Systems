# Probabilistic Verification of Protection Algorithms Using PRISM

[![PRISM Model Checker](https://img.shields.io/badge/PRISM-4.8-blue)](https://www.prismmodelchecker.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This repository contains PRISM models and properties used to evaluate and compare three protection algorithms for power distribution networks under different failure scenarios. All models are formalized using the PRISM 4.8 toolset.

## 1. Algorithms Overview

We analyze the following three algorithms:

1. **Auxiliary Algorithm - Part A**  
   Implements an extended protection strategy using watchdog, signal dispatching, and supervisory coordination (Part A).

2. **Auxiliary Algorithm - Part B**  
   Enhances the protection scheme by incorporating the communication system failure (Part B).

3. **Conventional Algorithm**  
   A baseline approach without auxiliary signaling or coordination logic, representing the traditional protection setup.

Each algorithm is modeled across four protection zones (Zone1 to Zone4).

## 2. Tool Requirements

To execute the model files and obtain results:

- **PRISM Model Checker**: Version 4.8  
  Download from: [https://www.prismmodelchecker.org](https://www.prismmodelchecker.org)
- **Java Runtime**: Required by PRISM (Java 8+)
- **Command Line**: Windows Command Prompt or a Bash-compatible shell (Linux/macOS)

## 3. Example: Running a Single PRISM Model

To manually run one PRISM model and property file from the command line:

```bash
prism MAS_AUX_Zone1.pm MAS_AUX_Zone1.pctl -const IED=0.1,COM=0.1,BRK=0.1 -javamaxmem 8g -ex > MAS_AUX_Zone1_results.txt
```

This command parses the model and property, evaluates the properties, and saves the results in a text file.

## 4. Raw Results and Post-Processing

Each model execution produces raw probabilistic results per zone and algorithm. To obtain the final comparison results presented in the paper, further aggregation and computation (e.g., subtraction, percentage difference) is required. These are detailed in the file `Compute_Final_Results.py`.

## 5. Automated Batch Scripts

To automate the analysis for each algorithm, we provide:

- **Linux Bash Script**: `Linux_automated_script.sh`
- **Windows Batch Script**: `Windows_automated_script.bat`

Each script executes all model-property pairs for the four zones under an algorithm and stores the raw output for each zone in a separate file.

Example: Running `Linux_automated_script.sh` will produce outputs such as `MAS_AUX_Zone1_PartA_results.txt`, `MAS_AUX_Zone1_PartB_results.txt`, etc.

## 6. Generating Graphical Results

To replicate the plots shown in the paper (e.g., Impact of varying failure probabilities on algorithm performance):

### Command Line Experiments

To run an experiment using command line, provide a range of values for one or more constants. Model checking will be performed for all combinations of the constant values provided.

Example: Varying COM (Communication failure probability) from 0 to 1 and keeping other constants fixed at 0.1:

```bash
prism MAS_AUX_Zone1.pm MAS_AUX_Zone1.pctl -const COM=0:0.1:1,IED=0.1,BRK=0.1 -javamaxmem 8g -ex > MAS_AUX_Zone1_PartA_COM_results.txt
```

### GUI Experiments

From the PRISM GUI:
1. Select a single property
2. Right-click and select "New experiment" (or use the popup menu in the "Experiments" panel)
3. Supply values or ranges for each undefined constant in the resulting dialog
4. Once the experiment has finished, right-click on the experiment to view or export results

## Contributing

Please feel free to submit issues or pull requests if you have suggestions for improvements or bug fixes.

## Citation

If you use these models in your research, please cite our work.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
