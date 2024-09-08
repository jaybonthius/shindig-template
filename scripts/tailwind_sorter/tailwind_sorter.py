import argparse
import os
import re
from typing import Dict

import yaml

from scripts.tailwind_sorter.utils.tailwind import tailwind_sort


def load_config(config_path: str) -> Dict:
    with open(config_path, "r") as file:
        return yaml.safe_load(file)


def get_regex_config(file_path: str, config: Dict) -> Dict:
    _, file_extension = os.path.splitext(file_path)
    full_extension = file_extension

    while file_extension:
        regex_config = next(
            (
                rc
                for rc in config.get("regexps", {}).values()
                if rc.get("file_extension") == full_extension
            ),
            None,
        )
        if regex_config:
            return regex_config

        # Remove the last extension and try again
        _, file_extension = os.path.splitext(file_path[: -len(file_extension)])
        full_extension = file_extension + full_extension

    return None


def process_file(file_path: str, config: Dict) -> None:
    regex_config = get_regex_config(file_path, config)

    if not regex_config:
        print(f"No regex configuration found for file: {file_path}")
        return

    regexp = regex_config["regexp"]
    pattern = re.compile(regexp)

    with open(file_path, "r") as file:
        content = file.read()

    def sort_classes(match):
        full_match = match.group(0)
        classes = match.group(1)
        sorted_classes = tailwind_sort(classes, config)
        return full_match.replace(classes, sorted_classes)

    new_content = pattern.sub(sort_classes, content)

    if new_content != content:
        with open(file_path, "w") as file:
            file.write(new_content)
        print(f"Sorted tailwind in {file_path}")


def main():
    parser = argparse.ArgumentParser(description="Sort Tailwind CSS classes in files.")
    parser.add_argument(
        "--file_path", required=True, help="Path to the file to process"
    )
    parser.add_argument(
        "--config_path",
        default="scripts/tailwind_sorter/config/default.yml",
        help="Path to the configuration file (default: config/default.yml)",
    )
    args = parser.parse_args()

    config = load_config(args.config_path)
    process_file(args.file_path, config)


if __name__ == "__main__":
    main()
