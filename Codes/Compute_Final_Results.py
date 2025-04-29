import os
import re

# Config
ALGORITHMS = ['PartA', 'PartB', 'Conventional']
ZONES = [1, 2, 3, 4]
BASE_PATH = "C:/Path/To/Your/codes"  # Change for Linux if needed

# Helper: extract float after 'Result:'
def extract_probabilities(filepath):
    with open(filepath, 'r') as f:
        lines = f.readlines()
    return [float(re.search(r'Result:\s*([0-9.]+)', line).group(1)) for line in lines if "Result" in line]

# Helper: compute final metrics
def compute_metrics(raw_vals):
    failure, aux_invoked, success, risk, false_trip = raw_vals

    # Normalize all by Auxiliary Algorithm Invocation
    if aux_invoked == 0:
        return {"error": "Auxiliary Invocation = 0, cannot divide."}

    failure_norm = failure / aux_invoked
    success_norm = success / aux_invoked
    risk_norm = risk / aux_invoked
    false_trip_norm = false_trip / aux_invoked

    final_success = success_norm - false_trip_norm
    final_failure = failure_norm - risk_norm

    return {
        "Final Success": round(final_success, 6),
        "Final Failure": round(final_failure, 6),
        "Risk": round(risk_norm, 6),
        "False Tripping": round(false_trip_norm, 6)
    }

# Main
def main():
    print(f"{'Algorithm':<15} {'Zone':<6} {'Final Success':<15} {'Final Failure':<15} {'Risk':<12} {'False Tripping':<16}")
    print("=" * 80)

    for algo in ALGORITHMS:
        folder = os.path.join(BASE_PATH, f"Auxiliary_Algorithm_{algo}") if algo != 'Conventional' else os.path.join(BASE_PATH, "Conventional_Algorithm")

        for zone in ZONES:
            result_file = os.path.join(folder, f"MAS_AUX_Zone{zone}_{algo}_results.txt")
            if not os.path.exists(result_file):
                print(f"{algo:<15} Zone{zone:<6} Missing file: {result_file}")
                continue

            try:
                raw_values = extract_probabilities(result_file)
                if len(raw_values) != 5:
                    print(f"{algo:<15} Zone{zone:<6} Invalid number of results")
                    continue

                final = compute_metrics(raw_values)
                if "error" in final:
                    print(f"{algo:<15} Zone{zone:<6} {final['error']}")
                    continue

                print(f"{algo:<15} Zone{zone:<6} {final['Final Success']:<15} {final['Final Failure']:<15} {final['Risk']:<12} {final['False Tripping']:<16}")

            except Exception as e:
                print(f"{algo:<15} Zone{zone:<6} Error: {e}")

if __name__ == "__main__":
    main()
