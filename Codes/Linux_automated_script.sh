#!/bin/bash
# Full Script to run Auxiliary_Algorithm_PartA, Auxiliary_Algorithm_PartB, and Conventional Algorithm models using PRISM 4.8 on Linux

# =============================
# Step 1: Run Auxiliary_Algorithm_PartA
# =============================
echo "Running Auxiliary_Algorithm_PartA models..."
cd "/path/to/your/codes/Auxiliary_Algorithm_PartA" || exit 1

for Z in 1 2 3 4; do
    echo "Running Part A - Zone $Z"
    prism MAS_AUX_Zone${Z}.pm MAS_AUX_Zone${Z}.pctl -const IED=0.1,COM=0.1,BRK=0.1 -javamaxmem 8g -ex > MAS_AUX_Zone${Z}_PartA_results.txt
done

echo "Finished running Auxiliary_Algorithm_PartA models."

# =============================
# Step 2: Run Auxiliary_Algorithm_PartB
# =============================
echo "Running Auxiliary_Algorithm_PartB models..."
cd "/path/to/your/codes/Auxiliary_Algorithm_PartB" || exit 1

for Z in 1 2 3 4; do
    echo "Running Part B - Zone $Z"
    prism MAS_AUX_Zone${Z}.pm MAS_AUX_Zone${Z}.pctl -const IED=0.1,COM=0.1,BRK=0.1 -javamaxmem 8g -ex > MAS_AUX_Zone${Z}_PartB_results.txt
done

echo "Finished running Auxiliary_Algorithm_PartB models."

# =============================
# Step 3: Run Conventional Algorithm
# =============================
echo "Running Conventional_Algorithm models..."
cd "/path/to/your/codes/Conventional Algorithm" || exit 1

for Z in 1 2 3 4; do
    echo "Running Conventional Algorithm - Zone $Z"
    prism Conventional_Zone${Z}.pm Conventional_Zone${Z}.pctl -const IED=0.1,COM=0.1,BRK=0.1 -javamaxmem 8g -ex > Conventional_Zone${Z}_results.txt
done

echo "Finished running Conventional Algorithm models."

# =============================
# End
# =============================
echo "All models for Auxiliary_Algorithm_PartA, Auxiliary_Algorithm_PartB, and Conventional Algorithm completed successfully!"
