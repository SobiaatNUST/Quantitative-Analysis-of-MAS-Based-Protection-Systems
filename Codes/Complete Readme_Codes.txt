# Probabilistic Verification of Protection Algorithms Using PRISM Codes

This repository contains the PRISM models and properties used to evaluate and compare three protection algorithms for 
power distribution networks analysis under different failure scenarios. All models are formalized using the PRISM 4.8 toolset.



-------------------------------------------------------------------------------------------------------------------------

## 1. Algorithms Overview

We consider the following three algorithms:

1. **Auxiliary Algorithm - Part A**  
   Implements an extended protection strategy using watchdog, signal dispatching, and supervisory coordination (Part A).

2. **Auxiliary Algorithm - Part B**  
   Enhances the protection scheme by incorporating the communication system failure (Part B).

3. **Conventional Algorithm**  
   A baseline approach without auxiliary signaling or coordination logic, representing the traditional protection setup.

Each algorithm is modeled across four protection zones (Zone1 to Zone4).


-------------------------------------------------------------------------------------------------------------------------

## 🛠 2. Tool Requirements

To execute the model files and obtain raw results:

- **PRISM Model Checker**: Version 4.8  
  Download from: [https://www.prismmodelchecker.org](https://www.prismmodelchecker.org)

- **Java Runtime**: Required by PRISM (e.g., Java 8+)
- **Command Line**: Windows Command Prompt or a Bash-compatible shell (Linux/macOS)


-------------------------------------------------------------------------------------------------------------------------

## 3. Example: Running a Single PRISM Model

To manually run one PRISM model and property file from the command line:

```bash
prism MAS_AUX_Zone1.pm MAS_AUX_Zone1.pctl -const IED=0.1,COM=0.1,BRK=0.1 -javamaxmem 8g -ex > MAS_AUX_Zone1_results.txt

This command parses the model and property, evaluates the properties, and saves the raw results in a text file.


-------------------------------------------------------------------------------------------------------------------------

## 4. Raw Results and Post-Processing
Each model execution produces raw probabilistic results per zone and algorithm.
To obtain the final comparison results presented in the paper, further aggregation and computation (e.g., subtraction, percentage difference) is required. 
These are detailed in the file "Compute_Final_Results.py".


-------------------------------------------------------------------------------------------------------------------------

## 5. Automated Batch Scripts
To automate the analysis for each algorithm, we provide:

Linux Bash Scripts: Linux_automated_script.sh

Windows Batch Scripts: Linux_automated_script.bat

Each script executes all model-property pairs for the four zones under an algorithm and stores the raw output for each zone in a separate file.

Example: Running Linux_automated_script.sh will produce outputs such as MAS_AUX_Zone1_PartA_results.txt, ..._PartB_results.txt, etc.



-------------------------------------------------------------------------------------------------------------------------

## 6. Generating Graphical Results (Using PRISM Experiments Feature)
To replicate the plots shown in the paper (e.g., Impact of varying failure probabilities on the performance of algorithms):

---- Running experiments using command line:
To run an experiment using command line, provide a range of values for one or more of the constants. 
Model checking will be performed for all combinations of the constant values provided. 
For example: Varying COM (Communication failure probability) from 0 to 1 and keeping all other constants fixed to 0.1:

prism MAS_AUX_Zone1.pm MAS_AUX_Zone1.pctl -const COM=0:0.1:1,IED=0.1,BRK=0.1 -javamaxmem 8g -ex > MAS_AUX_Zone1_PartA_COM_results.txt

---- Running experiments using GUI:
From the GUI, the same thing can be achieved by selecting a single property, right clicking on it and selecting "New experiment" (or alternatively using the popup menu in the "Experiments" panel). 
Values or ranges for each undefined constant can then be supplied in the resulting dialog. Details of the new experiment and its progress are shown in the panel.
Once the experiment has finished, right clicking on the experiment produces a pop-up menu, from which you can view the results of the experiment or export them to a file


-------------------------------------------------------------------------------------------------------------------------