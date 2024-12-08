import os
import re
import subprocess
import time
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed
from github import Github
from googletrans import Translator

import changelog_utils


def check_env():
    """Check if the required environment variables are set."""
    required_vars = [
        "GITHUB_TOKEN",
        "TARGET_REPO",
        "TARGET_BRANCH",
        "UPSTREAM_REPO",
        "UPSTREAM_BRANCH",
        "MERGE_BRANCH"
    ]
    missing_vars = [var for var in required_vars if not os.getenv(var)]
    if missing_vars:
        raise EnvironmentError(f"Missing required environment variables: {', '.join(missing_vars)}")


# Environment variables
check_env()
GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
TARGET_REPO = os.getenv("TARGET_REPO")
TARGET_BRANCH = os.getenv("TARGET_BRANCH")
UPSTREAM_REPO = os.getenv("UPSTREAM_REPO")
UPSTREAM_BRANCH = os.getenv("UPSTREAM_BRANCH")
MERGE_BRANCH = os.getenv("MERGE_BRANCH")
TRANSLATE_CHANGES = os.getenv("TRANSLATE_CHANGES", "False").lower() in ("true", "yes", "1")


def run_command(command) -> str:
    """Run a shell command and return its output."""
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    result.check_returncode()
    return result.stdout.strip()


def setup_repo():
    """Clone the repository and set up the upstream remote."""
    print(f"Cloning repository: {TARGET_REPO}")
    run_command(f"git clone https://github.com/{TARGET_REPO}.git repo")
    os.chdir("repo")
    run_command(f"git remote add upstream https://github.com/{UPSTREAM_REPO}.git")


def update_merge_branch() -> bool:
    """Update the merge branch with the latest changes from upstream."""
    print(f"Fetching branch {UPSTREAM_BRANCH} from upstream...")
    run_command(f"git fetch upstream {UPSTREAM_BRANCH}")

    local_branches = run_command("git branch --list").split()

    if MERGE_BRANCH not in local_branches:
        print(f"Branch '{MERGE_BRANCH}' does not exist. Creating it from upstream/{UPSTREAM_BRANCH}...")
        run_command(f"git checkout -b {MERGE_BRANCH} upstream/{UPSTREAM_BRANCH}")
        run_command(f"git push -u origin {MERGE_BRANCH}")
        return True

    else:
        print(f"Rebasing {MERGE_BRANCH} onto upstream/{UPSTREAM_BRANCH}...")
        run_command(f"git checkout {MERGE_BRANCH}")
        result = run_command(f"git pull --rebase upstream {UPSTREAM_BRANCH}")

        if "Current branch is up to date" in result:
            print("No changes detected from upstream.")
            return False

        print("Pushing rebased changes to origin...")
        run_command(f"git push origin {MERGE_BRANCH} --force")
        return True


def detect_commits() -> list[str]:
    """Detect commits from upstream not yet in downstream."""
    print("Detecting new commits from upstream...")
    return run_command(f"git log {TARGET_BRANCH}..{MERGE_BRANCH} --pretty=format:'%h %s %b'").split("\n")


def fetch_pull_body(pull_id) -> str | None:
    """Fetch the pull request body from GitHub."""
    github = Github(GITHUB_TOKEN)
    repo = github.get_repo(UPSTREAM_REPO)

    max_retries = 3
    for attempt in range(max_retries):
        try:
            pr = repo.get_pull(int(pull_id))
            return pr.body
        except Exception as e:
            print(f"Error fetching PR #{pull_id}: {e}")
            if attempt + 1 < max_retries:
                time.sleep(2)
            else:
                return None


def build_changelog(commit_log: list[str]) -> dict:
    """Generate the changelog from parsed commits."""
    translator = Translator()
    changelog = {}

    with ThreadPoolExecutor() as executor:
        futures = {}
        for commit in commit_log:
            pull = re.search("#\d+", commit).group()
            if not pull:
                continue

            pull_id = pull[1:]
            futures[executor.submit(fetch_pull_body, pull_id)] = pull_id

        for future in as_completed(futures):
            pull_id = futures[future]
            pull_body = future.result()
            pull_url = f"https://github.com/{UPSTREAM_REPO}/pull/{pull_id}"
            pull_changes = []

            if not pull_body:
                continue

            parsed = changelog_utils.parse_changelog(pull_body)
            if parsed and parsed["changes"]:
                for change in parsed["changes"]:
                    tag = change["tag"]
                    message = change["message"]
                    if TRANSLATE_CHANGES:
                        translated_message = translator.translate(message, src="en", dest="ru").text
                        pull_changes.append(f"{tag}: {translated_message}")
                    else:
                        pull_changes.append(f"{tag}: {message}")
                    pull_changes.append(f"<!-- {tag}: {message} ({pull_url}) -->")

            if pull_changes:
                changelog[pull] = pull_changes

    return changelog


def prepare_pull_body(changelog: dict) -> str:
    """Build new pull request body from the generated changelog."""
    pull_body = (
        f"This pull request merges upstream/{UPSTREAM_BRANCH}. "
        f"Resolve possible conflicts manually and make sure all the changes applies correctly.\n"
    )

    if not changelog or not changelog.items():
        return pull_body

    pull_body += (
        f"\n## Changelog\n"
        f":cl:\n"
    )
    for change in changelog.values():
        pull_body += f"{change}\n"
    pull_body += f"/:cl:\n"

    return pull_body


def create_pr(pull_body: str):
    """Create a pull request with the processed changelog."""
    github = Github(GITHUB_TOKEN)
    repo = github.get_repo(TARGET_REPO)

    # Create the pull request
    repo.create_pull(
        title=f"Merge Upstream {datetime.today().strftime('%d.%m.%Y')}",
        body=pull_body,
        head=TARGET_BRANCH,
        base=MERGE_BRANCH
    )


if __name__ == "__main__":
    setup_repo()

    if update_merge_branch():
        commit_log = detect_commits()
        changelog = build_changelog(commit_log)
        pull_body = prepare_pull_body(changelog)
        create_pr(pull_body)
