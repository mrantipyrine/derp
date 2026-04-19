#!/usr/bin/env python3
"""
Extend ROM/184/6.DAT to add null item slots for custom item IDs.

Run on the machine where FFXI client is installed:
  python3 extend_item_dat.py

This appends empty (null) 192-byte records to the end of the DAT,
making IDs 336–850 available for server-defined custom items.
The client treats null records as generic items; the server sends
actual item data via packets.

BACK UP the DAT BEFORE RUNNING.
"""

import os, shutil, struct

RECORD_SIZE = 0xC0  # 192 bytes

# Adjust path to your FFXI installation
FFXI_PATH = r"/Users/michael/Documents/Claude/derp/"
DAT_PATH = os.path.join(FFXI_PATH, "ROM/184/6.DAT")
BACKUP_PATH = DAT_PATH + ".bak"

TARGET_MIN_ID = 336  # first new ID to create
TARGET_MAX_ID = 850  # last new ID to create (515 new IDs)

def main():
    if not os.path.exists(DAT_PATH):
        print(f"ERROR: DAT not found at {DAT_PATH}")
        print("Update FFXI_PATH in this script to your FFXI installation.")
        return

    file_size = os.path.getsize(DAT_PATH)
    current_records = file_size // RECORD_SIZE
    print(f"Current DAT size: {file_size} bytes = {current_records} records (IDs 0-{current_records-1})")

    if current_records >= TARGET_MAX_ID + 1:
        print(f"DAT already covers up to ID {current_records-1}, nothing to do.")
        return

    # Back up
    if not os.path.exists(BACKUP_PATH):
        shutil.copy2(DAT_PATH, BACKUP_PATH)
        print(f"Backed up to {BACKUP_PATH}")
    else:
        print(f"Backup already exists at {BACKUP_PATH}")

    # Append null records to reach TARGET_MAX_ID
    records_to_add = (TARGET_MAX_ID + 1) - current_records
    print(f"Appending {records_to_add} null records (IDs {current_records}–{TARGET_MAX_ID})...")

    with open(DAT_PATH, 'ab') as f:
        f.write(b'\x00' * RECORD_SIZE * records_to_add)

    new_size = os.path.getsize(DAT_PATH)
    print(f"Done. New DAT size: {new_size} bytes = {new_size // RECORD_SIZE} records")
    print(f"IDs {TARGET_MIN_ID}–{TARGET_MAX_ID} are now available for custom items.")

if __name__ == '__main__':
    main()
