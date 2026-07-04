import sys
import tomllib
import re
from pathlib import Path

def clean_code_name(name):
    cleaned = re.sub(r'^\\improper\s*', '', name)
    return cleaned.strip()

def unescape_toml_key(key):
    return key.replace('\\"', '"')

def find_toml_entries(toml_dir):
    all_keys = set()
    toml_path = Path(toml_dir)

    if not toml_path.exists():
        print(f"Error: Directory not found at {toml_path}", file=sys.stderr)
        sys.exit(1)

    for toml_file in toml_path.glob("*.toml"):
        try:
            with open(toml_file, "rb") as f:
                data = tomllib.load(f)
                for key in data.keys():
                    all_keys.add(key)
        except Exception:
            pass

    return all_keys

def find_code_names(code_dirs):
    names = set()
    name_pattern = re.compile(r'name\s*=\s*"([^"]+)"')

    for code_dir in code_dirs:
        code_path = Path(code_dir)
        if not code_path.exists():
            continue

        for dm_file in code_path.rglob("*.dm"):
            try:
                with open(dm_file, 'r', encoding='utf-8') as f:
                    content = f.read()

                for match in name_pattern.finditer(content):
                    raw_name = match.group(1)
                    cleaned = clean_code_name(raw_name)
                    if cleaned:
                        names.add(cleaned)
            except Exception:
                pass

    return names

def main():
    toml_dir = Path("modular_ss220/translations/code/translation_data/ru_names")
    code_dirs = ["code", "modular_ss220"]

    if not toml_dir.exists():
        print(f"Error: TOML directory not found at {toml_dir}", file=sys.stderr)
        sys.exit(1)

    toml_keys = find_toml_entries(toml_dir)
    code_names = find_code_names(code_dirs)

    missing_in_code = set()
    for key in toml_keys:
        decoded_key = unescape_toml_key(key)
        if decoded_key not in code_names:
            missing_in_code.add(decoded_key)

    if missing_in_code:
        print(f"❌ Found {len(missing_in_code)} entries in TOML but not in code:")
        for name in sorted(missing_in_code):
            print(f"  - \"{name}\"")
        sys.exit(1)
    else:
        print(f"✅ All {len(toml_keys)} TOML entries found in code")
        sys.exit(0)

if __name__ == "__main__":
    main()
