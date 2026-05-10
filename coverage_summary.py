import re

lcov_file = "coverage/lcov.info"
lh_total = 0
lf_total = 0
files = []

with open(lcov_file, "r") as f:
    current_file = ""
    f_lh = 0
    f_lf = 0
    for line in f:
        line = line.strip()
        if line.startswith("SF:"):
            current_file = line[3:]
        elif line.startswith("LH:"):
            f_lh = int(line[3:])
            lh_total += f_lh
        elif line.startswith("LF:"):
            f_lf = int(line[3:])
            lf_total += f_lf
        elif line == "end_of_record":
            p = (f_lh / f_lf) if f_lf > 0 else 1.0
            files.append({"file": current_file, "lh": f_lh, "lf": f_lf, "p": p})

overall = (lh_total / lf_total) * 100 if lf_total > 0 else 0
print(f"Overall Coverage: {overall:.2f}% (LH: {lh_total} LF: {lf_total})")
print("-----------------------------------")
print("15 Lowest-Covered Files:")
files.sort(key=lambda x: x["p"])
for f in files[:15]:
    print(f"{f['p']*100:.2f}% ({f['lh']}/{f['lf']}) - {f['file']}")
