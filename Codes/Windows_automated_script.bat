
@echo off
REM Full Script to run Auxiliary_Algorithm_PartA, Auxiliary_Algorithm_PartB, and Conventional Algorithm models using PRISM 4.8 on Windows

REM =============================
REM Step 1: Run Auxiliary_Algorithm_PartA
REM =============================
echo Running Auxiliary_Algorithm_PartA models...
cd /d "C:\Path\To\Your\codes\Auxiliary_Algorithm_PartA"

for %%Z in (1 2 3 4) do (
    echo Running Part A - Zone %%Z
    prism MAS_AUX_Zone%%Z.pm MAS_AUX_Zone%%Z.pctl -const IED=0.1,COM=0.1,BRK=0.1 -javamaxmem 8g -ex > MAS_AUX_Zone%%Z_PartA_results.txt
)

echo Finished running Auxiliary_Algorithm_PartA models.

REM =============================
REM Step 2: Run Auxiliary_Algorithm_PartB
REM =============================
echo Running Auxiliary_Algorithm_PartB models...
cd /d "C:\Path\To\Your\codes\Auxiliary_Algorithm_PartB"

for %%Z in (1 2 3 4) do (
    echo Running Part B - Zone %%Z
    prism MAS_AUX_Zone%%Z.pm MAS_AUX_Zone%%Z.pctl -const IED=0.1,COM=0.1,BRK=0.1 -javamaxmem 8g -ex > MAS_AUX_Zone%%Z_PartB_results.txt
)

echo Finished running Auxiliary_Algorithm_PartB models.

REM =============================
REM Step 3: Run Conventional Algorithm
REM =============================
echo Running Conventional Algorithm models...
cd /d "C:\Path\To\Your\codes\Conventional Algorithm"

for %%Z in (1 2 3 4) do (
    echo Running Conventional Algorithm - Zone %%Z
    prism  Conventional_Zone%%Z.pm  Conventional_Zone%%Z.pctl -const IED=0.1,COM=0.1,BRK=0.1 -javamaxmem 8g -ex > Conventional_Zone%%Z_results.txt

echo Finished running Conventional_Algorithm models.

REM =============================
REM End
REM =============================
echo All models for Auxiliary_Algorithm_PartA, Auxiliary_Algorithm_PartB, and Conventional Algorithm completed successfully!
pause
