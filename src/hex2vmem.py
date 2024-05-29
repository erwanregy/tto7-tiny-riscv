import argparse

parser = argparse.ArgumentParser()
parser.add_argument("file", type=str)
args = parser.parse_args()

hex = open(args.file, "r").readlines()

vmem = []
address = 0
for line in hex:
    line = line.strip()
    if not line:
        continue
    vmem.append(f"assign memory[{address}] = 'h{line};\n")
    address += 1

open(args.file.replace(".hex", ".vmem"), "w").writelines(vmem)
