import re

# 1. Load custom weapons
custom_items = []
with open('custom_weapons.yml', 'r') as f:
    custom_content = f.read()

custom_blocks = re.split(r'\n- id: ', custom_content)
for block in custom_blocks:
    if not block.strip(): continue
    
    def get_field(name, b):
        m = re.search(rf'{name}:\s*([^\n]*)', b)
        return m.group(1).strip() if m else ""

    def get_multiline(name, b):
        m = re.search(rf'{name}:\s*([\s\S]*?)(?=\n\s{{0,4}}\w+:|$)', b)
        if not m: return ""
        val = m.group(1).strip()
        val = re.sub(r'^\|-?\s*', '', val)
        return val

    name = get_field('name', block)
    if not name: continue
    
    custom_items.append({
        'name': name,
        'art': get_field('article_type', block),
        'sing': get_field('singular_name', block),
        'plur': get_field('plural_name', block),
        'desc': get_multiline('description', block),
        'dmg': get_field('damage', block) or "0",
        'dly': get_field('delay', block) or "0",
        'dps': get_field('dps', block) or "0",
        'lvl': get_field('level', block) or "1",
        'jobs': get_multiline('jobs', block) or "- All",
        'skill_type': get_field('skill_type', block)
    })

custom_by_type = {}
for item in custom_items:
    st = item['skill_type'] or "None"
    if st not in custom_by_type: custom_by_type[st] = []
    custom_by_type[st].append(item)

print(f"Loaded {len(custom_items)} custom weapons.")

# 2. Process weapons.yml item by item
with open('weapons.yml', 'r') as fin, open('weapons_3.yml', 'w') as fout:
    content = fin.read()
    # Ensure consistent newlines
    content = content.replace('\r\n', '\n')
    
    items = re.split(r'\n- id: ', content)
    fout.write(items[0]) # Header
    
    state = {'mapped_count': 0}

    for i in range(1, len(items)):
        block = "- id: " + items[i]
        
        # 2a. Map custom weapon if target
        lv_match = re.search(r'level:\s*(\d+)', block)
        st_match = re.search(r'skill_type:\s*(\w+)', block)
        
        if lv_match and st_match:
            lv = int(lv_match.group(1))
            st = st_match.group(1)
            
            if 76 <= lv <= 98:
                custom = None
                if st in custom_by_type and custom_by_type[st]:
                    custom = custom_by_type[st].pop(0)
                elif "None" in custom_by_type and custom_by_type["None"]:
                    custom = custom_by_type["None"].pop(0)
                
                if custom:
                    # Strings
                    block = re.sub(r'(?m)^(\s+)name:.*', rf'\1name: {custom["name"]}', block)
                    block = re.sub(r'(?m)^(\s+)article_type:.*', rf'\1article_type: {custom["art"]}', block)
                    block = re.sub(r'(?m)^(\s+)singular_name:.*', rf'\1singular_name: {custom["sing"]}', block)
                    block = re.sub(r'(?m)^(\s+)plural_name:.*', rf'\1plural_name: {custom["plur"]}', block)
                    
                    # Description
                    new_desc = "\n".join([("      " + l) for l in custom['desc'].split('\n')])
                    desc_pattern = r'description:[\s\S]*?(?=\n\s{0,4}\w+:|$)'
                    block = re.sub(desc_pattern, f'description: |-\n{new_desc}', block, count=1)
                    
                    # Weapon stats
                    block = re.sub(r'(?m)^(\s+)damage: \d+', rf'\1damage: {custom["dmg"]}', block)
                    block = re.sub(r'(?m)^(\s+)delay: \d+', rf'\1delay: {custom["dly"]}', block)
                    block = re.sub(r'(?m)^(\s+)dps: \d+', rf'\1dps: {custom["dps"]}', block)
                    
                    # Equipment stats
                    block = re.sub(r'(?m)^(\s+)level: \d+', rf'\1level: {custom["lvl"]}', block)
                    
                    jobs = "\n".join([("    " + l.strip()) for l in custom['jobs'].split('\n') if l.strip()])
                    jobs_pattern = r'jobs:[\s\S]*?(?=\n\s{0,4}\w+:|$)'
                    block = re.sub(jobs_pattern, f"jobs:\n{jobs}", block, count=1)
                    
                    state['mapped_count'] += 1

        # 2b. Clean icon_bytes - VERY ROBUSTLY
        # Find the icon_bytes key and everything until the next key or end of block
        lines = block.split('\n')
        new_lines = []
        in_icon = False
        icon_indent = ""
        icon_accumulator = []

        for line in lines:
            if re.match(r'^\s+icon_bytes:', line):
                in_icon = True
                icon_indent = re.match(r'^(\s+)', line).group(1)
                # Capture any value on the same line
                val = line.split('icon_bytes:', 1)[1]
                icon_accumulator.append(val)
                continue
            
            if in_icon:
                # Check if this line is the start of a new key or next item
                # New keys are indented the same as icon_bytes
                if re.match(r'^\s{0,' + str(len(icon_indent)) + r'}\w+:', line) or line.startswith('- id:'):
                    # Icon block ended. Process it.
                    combined = "".join(icon_accumulator)
                    cleaned = re.sub(r'[\s\(\)"]', '', combined)
                    if not cleaned:
                        new_lines.append(f"{icon_indent}icon_bytes: \"\"")
                    else:
                        new_lines.append(f"{icon_indent}icon_bytes: |-\n{icon_indent}  {cleaned}")
                    
                    in_icon = False
                    new_lines.append(line)
                else:
                    # Still in icon value
                    icon_accumulator.append(line)
            else:
                new_lines.append(line)
        
        if in_icon:
            # Handle end of block
            combined = "".join(icon_accumulator)
            cleaned = re.sub(r'[\s\(\)"]', '', combined)
            if not cleaned:
                new_lines.append(f"{icon_indent}icon_bytes: \"\"")
            else:
                new_lines.append(f"{icon_indent}icon_bytes: |-\n{icon_indent}  {cleaned}")

        fout.write("\n" + "\n".join(new_lines).strip())

print(f"Final Mapped Count: {state['mapped_count']}")
