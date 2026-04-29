#!/usr/bin/env python3
"""
FFXI Item DAT Scanner
Run this directly on your Windows machine:
  python scan_item_dats.py

It reads the item DAT files locally and outputs unused_item_ids.txt
which you can then drop in your derp folder.
"""

import os, struct, sys

# Adjust this if your FFXI is installed elsewhere
#FFXI_PATH = r"C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI"

FFXI_PATH = r"/Users/michael/Documents/Claude/derp/"

# Item DAT files: (path relative to FFXI_PATH, label, item_id_base)
# Each file covers a range of item IDs. Records are 0xC0 (192) bytes each.
# Item ID within file = file_base + record_index
ITEM_FILES = [
    (r"ROM/184/6.DAT",   "General items",       0),
    (r"ROM/48/7.DAT",    "Usable items",         0xA000),  # ~40960
    (r"ROM/49/7.DAT",    "Puppet items",         0xB000),
    (r"ROM/104/71.DAT",  "Armor",                0x1000),  # ~4096
    (r"ROM/105/71.DAT",  "Weapons",              0x2000),  # ~8192
    (r"ROM/50/7.DAT",    "Expansion armor",      0xC000),
    (r"ROM/51/7.DAT",    "Expansion weapons",    0xD000),
]

RECORD_SIZE = 0xC0  # 192 bytes per item record

def is_empty_record(data):
    """A record is 'empty' if the name field (bytes 0x16 to 0x2E) is all zeros."""
    name_bytes = data[0x16:0x2E]
    return all(b == 0 for b in name_bytes)

def get_name(data):
    """Extract item name from record (starts at offset 0x16, null-terminated)."""
    name_bytes = data[0x16:0x2E]
    try:
        return name_bytes.split(b'\x00')[0].decode('shift-jis', errors='replace').strip()
    except:
        return ""

def scan_file(filepath, label, id_base):
    results = []
    try:
        with open(filepath, "rb") as f:
            raw = f.read()
    except Exception as e:
        print(f"  ERROR reading {filepath}: {e}")
        return results

    num_records = len(raw) // RECORD_SIZE
    empty_count = 0
    for i in range(num_records):
        record = raw[i * RECORD_SIZE:(i + 1) * RECORD_SIZE]
        item_id = id_base + i
        if is_empty_record(record):
            results.append(item_id)
            empty_count += 1

    print(f"  {label}: {num_records} total records, {empty_count} empty (unused)")
    return results

def main():
    print("FFXI Item DAT Scanner")
    print("=" * 50)
    print(f"FFXI path: {FFXI_PATH}\n")

    all_unused = []

    for rel_path, label, id_base in ITEM_FILES:
        full_path = os.path.join(FFXI_PATH, rel_path)
        print(f"Scanning {rel_path} ({label})...")
        if not os.path.exists(full_path):
            print(f"  FILE NOT FOUND: {full_path}")
            continue
        unused = scan_file(full_path, label, id_base)
        all_unused.extend(unused)

    # Sort and find consecutive runs
    all_unused.sort()

    # Build runs of consecutive IDs
    runs = []
    if all_unused:
        run_start = all_unused[0]
        run_end = all_unused[0]
        for uid in all_unused[1:]:
            if uid == run_end + 1:
                run_end = uid
            else:
                runs.append((run_start, run_end, run_end - run_start + 1))
                run_start = uid
                run_end = uid
        runs.append((run_start, run_end, run_end - run_start + 1))

    # Write output file
    out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "unused_item_ids.txt")
    with open(out_path, "w") as f:
        f.write(f"Total unused item slots: {len(all_unused)}\n")
        f.write(f"Total consecutive runs: {len(runs)}\n\n")

        f.write("=== RUNS OF 10+ CONSECUTIVE UNUSED IDs ===\n")
        f.write(f"{'Start':>8}  {'End':>8}  {'Count':>8}\n")
        f.write("-" * 32 + "\n")
        usable_runs = [(s,e,c) for s,e,c in runs if c >= 10]
        for start, end, count in sorted(usable_runs, key=lambda x: -x[2]):
            f.write(f"{start:>8}  {end:>8}  {count:>8}\n")

        f.write(f"\nTotal IDs in runs of 10+: {sum(c for _,_,c in usable_runs)}\n")

        f.write("\n\n=== ALL UNUSED IDs (raw list) ===\n")
        f.write(",".join(str(x) for x in all_unused) + "\n")

    print(f"\nDone! Results written to: {out_path}")
    print(f"Total unused slots found: {len(all_unused)}")
    print(f"\nTop 10 largest unused runs:")
    for start, end, count in sorted(runs, key=lambda x: -x[2])[:10]:
        print(f"  {start:>6} - {end:>6}  ({count} slots)")

if __name__ == "__main__":
    main()
