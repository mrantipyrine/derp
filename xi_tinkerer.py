import os
import struct
import yaml
import argparse
import sys

def rotate_right(byte, n):
    """Circular bit rotation to the right."""
    n %= 8
    return ((byte >> n) | (byte << (8 - n))) & 0xFF

def rotate_left(byte, n):
    """Circular bit rotation to the left."""
    n %= 8
    return ((byte << n) | (byte >> (8 - n))) & 0xFF

def popcount(x):
    """Count number of set bits in a byte."""
    return bin(x).count('1')

def get_variable_seed(block):
    """Calculate variable rotation seed from specific bytes in block."""
    # Seed logic for abilities/spells: (Bits in Byte 3) - (Bits in Byte 12) + (Bits in Byte 13)
    try:
        s = popcount(block[3]) - popcount(block[12]) + popcount(block[13])
        return s & 7
    except IndexError:
        return 0

class DATinkerer:
    def __init__(self, rotation_seed=5):
        self.rotation_seed = rotation_seed

    def decode_block(self, data):
        return bytearray([rotate_right(b, self.rotation_seed) for b in data])

    def encode_block(self, data):
        return bytearray([rotate_left(b, self.rotation_seed) for b in data])

    def decode_string(self, data):
        try:
            raw_str = data.split(b'\x00')[0]
            return raw_str.decode('shift-jis', errors='replace').strip()
        except Exception:
            return ""

    def encode_string(self, text, length):
        if not text:
            return b'\x00' * length
        encoded = text.encode('shift-jis', errors='replace')
        return encoded[:length].ljust(length, b'\x00')

class ItemRecord:
    SIZE = 0xC0  # 192 bytes

    def __init__(self, data=None):
        self.data = {
            "id": 0, "flags": 0, "stack": 0, "type": 0, "resource_id": 0,
            "targets": 0, "level": 0, "slots": 0, "jobs": 0,
            "damage": 0, "delay": 0, "skill": 0, "defense": 0,
            "name": "", "description": ""
        }
        if data: self.parse(data)

    def parse(self, data):
        self.data["id"] = struct.unpack_from("<I", data, 0x00)[0]
        self.data["flags"] = struct.unpack_from("<H", data, 0x04)[0]
        self.data["stack"] = struct.unpack_from("<H", data, 0x06)[0]
        self.data["type"] = struct.unpack_from("<H", data, 0x08)[0]
        self.data["resource_id"] = struct.unpack_from("<H", data, 0x0A)[0]
        self.data["targets"] = struct.unpack_from("<H", data, 0x0C)[0]
        self.data["level"] = struct.unpack_from("<H", data, 0x0E)[0]
        self.data["slots"] = struct.unpack_from("<H", data, 0x10)[0]
        self.data["jobs"] = struct.unpack_from("<I", data, 0x12)[0]
        self.data["damage"] = struct.unpack_from("<H", data, 0x16)[0]
        self.data["delay"] = struct.unpack_from("<H", data, 0x18)[0]
        self.data["skill"] = struct.unpack_from("<H", data, 0x1A)[0]
        self.data["defense"] = struct.unpack_from("<B", data, 0x1C)[0]
        tinker = DATinkerer()
        self.data["name"] = tinker.decode_string(data[0x30:0x50])
        self.data["description"] = tinker.decode_string(data[0x50:0xC0])

    def serialize(self):
        res = bytearray(self.SIZE)
        struct.pack_into("<I", res, 0x00, self.data["id"])
        struct.pack_into("<H", res, 0x04, self.data["flags"])
        struct.pack_into("<H", res, 0x06, self.data["stack"])
        struct.pack_into("<H", res, 0x08, self.data["type"])
        struct.pack_into("<H", res, 0x0A, self.data["resource_id"])
        struct.pack_into("<H", res, 0x0C, self.data["targets"])
        struct.pack_into("<H", res, 0x0E, self.data["level"])
        struct.pack_into("<H", res, 0x10, self.data["slots"])
        struct.pack_into("<I", res, 0x12, self.data["jobs"])
        struct.pack_into("<H", res, 0x16, self.data["damage"])
        struct.pack_into("<H", res, 0x18, self.data["delay"])
        struct.pack_into("<H", res, 0x1A, self.data["skill"])
        struct.pack_into("<B", res, 0x1C, self.data["defense"])
        tinker = DATinkerer()
        res[0x30:0x50] = tinker.encode_string(self.data["name"], 32)
        res[0x50:0xC0] = tinker.encode_string(self.data["description"], 112)
        # Items use fixed seed 5
        return tinker.encode_block(res)

class SpellRecord:
    SIZE = 400

    def __init__(self, data=None):
        self.data = {
            "id": 0, "magic_type": 0, "element": 0, "targets": 0, "skill": 0,
            "mp_cost": 0, "cast_time": 0, "recast_time": 0, "job_levels": [],
            "name": "", "description": ""
        }
        if data: self.parse(data)

    def parse(self, data):
        self.data["id"] = struct.unpack_from("<H", data, 0x00)[0]
        self.data["magic_type"] = struct.unpack_from("<H", data, 0x02)[0]
        self.data["element"] = struct.unpack_from("<H", data, 0x04)[0]
        self.data["targets"] = struct.unpack_from("<H", data, 0x06)[0]
        self.data["skill"] = struct.unpack_from("<H", data, 0x08)[0]
        self.data["mp_cost"] = struct.unpack_from("<H", data, 0x0A)[0]
        self.data["cast_time"] = struct.unpack_from("<B", data, 0x0C)[0]
        self.data["recast_time"] = struct.unpack_from("<B", data, 0x0D)[0]
        self.data["job_levels"] = list(struct.unpack_from("<24B", data, 0x0E))
        tinker = DATinkerer()
        self.data["name"] = tinker.decode_string(data[0x30:0x44])
        self.data["description"] = tinker.decode_string(data[0x50:0x190])

    def serialize(self):
        res = bytearray(self.SIZE)
        struct.pack_into("<H", res, 0x00, self.data["id"])
        struct.pack_into("<H", res, 0x02, self.data["magic_type"])
        struct.pack_into("<H", res, 0x04, self.data["element"])
        struct.pack_into("<H", res, 0x06, self.data["targets"])
        struct.pack_into("<H", res, 0x08, self.data["skill"])
        struct.pack_into("<H", res, 0x0A, self.data["mp_cost"])
        struct.pack_into("<B", res, 0x0C, self.data["cast_time"])
        struct.pack_into("<B", res, 0x0D, self.data["recast_time"])
        struct.pack_into("<24B", res, 0x0E, *self.data["job_levels"])
        tinker = DATinkerer()
        res[0x30:0x44] = tinker.encode_string(self.data["name"], 20)
        res[0x50:0x190] = tinker.encode_string(self.data["description"], 320)
        # Spells use variable seed
        tinker.rotation_seed = get_variable_seed(res)
        return tinker.encode_block(res)

class AbilityRecord:
    SIZE = 64

    def __init__(self, data=None):
        self.data = {
            "id": 0, "type": 0, "element": 0, "targets": 0, "skill_level": 0,
            "job_level": 0, "main_job": 0, "recast": 0, "animation": 0, "name": ""
        }
        if data: self.parse(data)

    def parse(self, data):
        self.data["id"] = struct.unpack_from("<H", data, 0x00)[0]
        self.data["type"] = struct.unpack_from("<B", data, 0x02)[0]
        self.data["element"] = struct.unpack_from("<B", data, 0x03)[0]
        self.data["targets"] = struct.unpack_from("<H", data, 0x04)[0]
        self.data["skill_level"] = struct.unpack_from("<H", data, 0x06)[0]
        self.data["job_level"] = struct.unpack_from("<B", data, 0x08)[0]
        self.data["main_job"] = struct.unpack_from("<B", data, 0x09)[0]
        self.data["recast"] = struct.unpack_from("<H", data, 0x0A)[0]
        self.data["animation"] = struct.unpack_from("<H", data, 0x0C)[0]
        tinker = DATinkerer()
        self.data["name"] = tinker.decode_string(data[0x10:0x30])

    def serialize(self):
        res = bytearray(self.SIZE)
        struct.pack_into("<H", res, 0x00, self.data["id"])
        struct.pack_into("<B", res, 0x02, self.data["type"])
        struct.pack_into("<B", res, 0x03, self.data["element"])
        struct.pack_into("<H", res, 0x04, self.data["targets"])
        struct.pack_into("<H", res, 0x06, self.data["skill_level"])
        struct.pack_into("<B", res, 0x08, self.data["job_level"])
        struct.pack_into("<B", res, 0x09, self.data["main_job"])
        struct.pack_into("<H", res, 0x0A, self.data["recast"])
        struct.pack_into("<H", res, 0x0C, self.data["animation"])
        tinker = DATinkerer()
        res[0x10:0x30] = tinker.encode_string(self.data["name"], 32)
        # Abilities use variable seed
        tinker.rotation_seed = get_variable_seed(res)
        return tinker.encode_block(res)

def export_dat(dat_path, yaml_path, record_type):
    if record_type == "item": cls = ItemRecord
    elif record_type == "spell": cls = SpellRecord
    else: cls = AbilityRecord

    with open(dat_path, "rb") as f:
        raw = f.read()

    records = []
    tinker = DATinkerer()
    for i in range(len(raw) // cls.SIZE):
        block = raw[i * cls.SIZE : (i + 1) * cls.SIZE]
        tinker.rotation_seed = 5 if record_type == "item" else get_variable_seed(block)
        decoded = tinker.decode_block(block)
        rec = cls(decoded)
        if rec.data.get("id", 0) != 0 or rec.data.get("name"):
            records.append(rec.data)

    with open(yaml_path, "w", encoding="utf-8") as f:
        yaml.dump(records, f, allow_unicode=True, sort_keys=False)
    print(f"Exported {len(records)} records to {yaml_path}")

def import_yaml(yaml_path, dat_path, record_type):
    if record_type == "item": cls = ItemRecord
    elif record_type == "spell": cls = SpellRecord
    else: cls = AbilityRecord

    with open(yaml_path, "r", encoding="utf-8") as f:
        data_list = yaml.safe_load(f)

    with open(dat_path, "wb") as f:
        for d in data_list:
            rec = cls()
            rec.data = d
            f.write(rec.serialize())
    print(f"Imported {len(data_list)} records to {dat_path}")

def main():
    parser = argparse.ArgumentParser(description="Python FFXI DAT Tinkerer.")
    parser.add_argument("command", choices=["export", "import"])
    parser.add_argument("--dat", required=True)
    parser.add_argument("--yaml", required=True)
    parser.add_argument("--type", choices=["item", "spell", "ability"], default="item")
    args = parser.parse_args()
    if args.command == "export": export_dat(args.dat, args.yaml, args.type)
    else: import_yaml(args.yaml, args.dat, args.type)

if __name__ == "__main__":
    main()
