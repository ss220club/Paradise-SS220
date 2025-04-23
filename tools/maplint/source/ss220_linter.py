import glob
import pathlib
import traceback
import yaml

from . import dmm, lint
from .error import MaplintError
from .__main__ import process_dmm, print_maplint_error, print_error, green, red

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--github", action="store_true")
    args = parser.parse_args()

    github_error_style = args.github
    any_failed = False

    lints: dict[str, lint.Lint] = {}

    lint_base = pathlib.Path(__file__).parent.parent / "ss220_lints"
    lint_filenames = lint_base.glob("*.yml")

    for lint_filename in lint_filenames:
        try:
            lints[lint_filename] = lint.Lint(yaml.safe_load(lint_filename.read_text()))
        except Exception:
            print_error("Error loading modular lint file.", str(lint_filename), 1, github_error_style)
            traceback.print_exc()
            any_failed = True

    for map_filename in glob.glob("_maps/map_files220/**/*.dmm", recursive = True):
        print(map_filename, end = " ")

        success = True
        try:
            problems = process_dmm(map_filename, lints)
            if problems:
                success = False
                for p in problems:
                    print_maplint_error(p, github_error_style)
        except Exception:
            success = False
            print_error("Exception occurred in maplint", map_filename, 1, github_error_style)
            traceback.print_exc()

        print(green("OK") if success else red("X"))
        any_failed = any_failed or not success

    if any_failed:
        exit(1)

if __name__ == "__main__":
    main()
