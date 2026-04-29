#!/usr/bin/env python3
"""
FFXI Item DAT format probe.
Run on Windows to print the raw structure of known items so we can
verify the exact byte offsets before writing the patcher.

Usage: python dat_probe.py
"""

import os, struct

FFXI_PATH = r"C:\Program Files (x86)\PlayOnline\SquareEnix\FINAL FANTASY XI"

# Item DAT files with known item IDs we can use to verify parsing
# (file_path, base_id, label, sample_ids_to_dump)
ITEM_FILES = [
    (r"ROM\184\6.DAT",  0,      "General/Misc",   [1, 4, 13, 640, 1190]),   # crystals, basic items
    (r"ROM\104\71.DAT", 0x1000, "Armor",           [0x1000+100, 0x1000+200, 0x1000+500]),  # armor items
    (r"ROM\105\71.DAT", 0x2000, "Weapons",         [0x2000+1, 0x2000+50, 0x2000+200]),     # weapons
]

RECORD_SIZE = 0xC0  # 192 bytes

def read_dat(path):
    with open(path, "rb") as f:
        return f.read()

def dump_record(data, item_id, base_id):
    idx = item_id - base_id
    if idx < 0 or idx * RECORD_SIZE >= len(data):
        print(f"  Item {item_id}: out of range")
        return
    rec = data[idx * RECORD_SIZE : (idx+1) * RECORD_SIZE]

    print(f"\n  === Item ID {item_id} (record index {idx}) ===")
    # Print full hex dump in rows of 16
    for row in range(0, RECORD_SIZE, 16):
        hex_part = " ".join(f"{b:02x}" for b in rec[row:row+16])
        try:
            asc_part = "".join(chr(b) if 32 <= b < 127 else "." for b in rec[row:row+16])
        except:
            asc_part = "?"
        print(f"    {row:03x}: {hex_part:<48}  {asc_part}")

    # Try to extract name at common offsets
    print(f"  Trying name at offset 0x16 (26): {rec[0x16:0x2E].split(b'\\x00')[0]}")
    print(f"  Trying name at offset 0x10 (16): {rec[0x10:0x28].split(b'\\x00')[0]}")
    print(f"  Trying name at offset 0x08 (8):  {rec[0x08:0x20].split(b'\\x00')[0]}")

    # Print first 8 uint16 values (flags, type, etc.)
    vals = struct.unpack_from("<8H", rec, 0)
    print(f"  First 8 uint16: {[hex(v) for v in vals]}")

def scan_file(path, base_id, label, sample_ids):
    print(f"\n{'='*60}")
    print(f"FILE: {path}  ({label}, base_id=0x{base_id:X})")
    print(f"{'='*60}")
    full_path = os.path.join(FFXI_PATH, path)
    try:
        data = read_dat(full_path)
        print(f"File size: {len(data):,} bytes = {len(data)//RECORD_SIZE} records (at 0x{RECORD_SIZE:X} bytes each)")
        print(f"Max item ID in this file: {base_id + len(data)//RECORD_SIZE - 1}")

        for item_id in sample_ids:
            dump_record(data, item_id, base_id)
    except Exception as e:
        print(f"ERROR: {e}")

if __name__ == "__main__":
    for path, base_id, label, samples in ITEM_FILES:
        scan_file(path, base_id, label, samples)

    print("\n\nDone. Paste the output so we can verify the record format.")
