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
CHANGELOG_AUTHOR = os.getenv("CHANGELOG_AUTHOR", "")


def run_command(command) -> str:
    """Run a shell command and return its output."""
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        result.check_returncode()
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {command}\nExit code: {e.returncode}\nOutput: {e.output}\nError: {e.stderr}")
        raise


def setup_repo():
    """Clone the repository and set up the upstream remote."""
    print(f"Cloning repository: {TARGET_REPO}")
    run_command(f"git clone https://{GITHUB_TOKEN}@github.com/{TARGET_REPO}.git repo")
    os.chdir("repo")
    run_command(f"git remote add upstream https://{GITHUB_TOKEN}@github.com/{UPSTREAM_REPO}.git")
    print(run_command(f"git remote -v"))


def update_merge_branch():
    """Update the merge branch with the latest changes from upstream."""
    print(f"Fetching branch {UPSTREAM_BRANCH} from upstream...")
    run_command(f"git fetch upstream {UPSTREAM_BRANCH}")
    run_command(f"git fetch origin")
    all_branches = run_command("git branch -a").split()

    if f"remotes/origin/{MERGE_BRANCH}" not in all_branches:
        print(f"Branch '{MERGE_BRANCH}' does not exist. Creating it from upstream/{UPSTREAM_BRANCH}...")
        run_command(f"git checkout -b {MERGE_BRANCH} upstream/{UPSTREAM_BRANCH}")
        run_command(f"git push -u origin {MERGE_BRANCH}")
        return

    print(f"Rebasing {MERGE_BRANCH} onto upstream/{UPSTREAM_BRANCH}...")
    run_command(f"git checkout {MERGE_BRANCH}")
    result = run_command(f"git pull --rebase upstream {UPSTREAM_BRANCH}")

    if "Current branch is up to date" in result:
        print("No changes detected from upstream.")
        return

    print("Pushing rebased changes to origin...")
    run_command(f"git push origin {MERGE_BRANCH} --force")


def detect_commits() -> list[str]:
    """Detect commits from upstream not yet in downstream."""
    print("Detecting new commits from upstream...")
    commit_log = run_command(f"git log {TARGET_BRANCH}..{MERGE_BRANCH} --pretty=format:'%h %s'").split("\n")
    commit_log.reverse()
    return commit_log


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
    print("Building changelog...")
    translator = Translator()
    changelog = {}
    pull_cache = {}

    with ThreadPoolExecutor() as executor:
        futures = {}
        for commit in commit_log:
            pull_match = re.search("#\\d+", commit)
            if not pull_match:
                print(f"Skipping {commit}")
                continue

            pull_id = pull_match.group()[1:]

            if pull_id in pull_cache:
                print(
                    f"WARNING: pull duplicate found.\n"
                    f"1: {pull_cache[pull_id]}\n"
                    f"2: {commit}"
                )
                print(f"Skipping {commit}")
                continue

            pull_cache[pull_id] = commit
            futures[executor.submit(fetch_pull_body, pull_id)] = pull_id

        for future in as_completed(futures):
            pull_id = futures[future]
            pull_body = future.result()
            pull_url = f"https://github.com/{UPSTREAM_REPO}/pull/{pull_id}"
            pull_changes = []

            if not pull_body:
                continue

            try:
                parsed = changelog_utils.parse_changelog(pull_body)
                if parsed and parsed["changes"]:
                    for change in parsed["changes"]:
                        tag = change["tag"]
                        message = change["message"]
                        if TRANSLATE_CHANGES:
                            translated_message = translator.translate(message, src="en", dest="ru").text
                            change = f"{tag}: {translated_message} <!-- {tag}: {message} ({pull_url}) -->"
                        else:
                            change = f"{tag}: {message} <!-- ({pull_url}) -->"
                        pull_changes.append(change)

                if pull_changes:
                    changelog[pull_id] = pull_changes
            except Exception as e:
                print(
                    f"An error occurred while processing {commit}\n"
                    f"URL: {pull_url}\n"
                    f"Body: {pull_body}"
                )
                raise e

    return changelog


def prepare_pull_body(changelog: dict) -> str:
    """Build new pull request body from the generated changelog."""
    pull_body = (
        f"This pull request merges upstream/{UPSTREAM_BRANCH}. "
        f"Resolve possible conflicts manually and make sure all the changes are applied correctly.\n"
    )

    if not changelog or not changelog.items():
        return pull_body

    pull_body += f"\n## Changelog\n"
    pull_body += f":cl: {CHANGELOG_AUTHOR}\n" if CHANGELOG_AUTHOR else ":cl:\n"
    for pull_changes in changelog.values():
        pull_body += f"{'\n'.join(pull_changes)}\n"
    pull_body += "/:cl:\n"

    return pull_body


def create_pr(pull_body: str):
    """Create a pull request with the processed changelog."""
    print("Creating pull request...")
    github = Github(GITHUB_TOKEN)
    repo = github.get_repo(TARGET_REPO)

    # Create the pull request
    repo.create_pull(
        title=f"Merge Upstream {datetime.today().strftime('%d.%m.%Y')}",
        body=pull_body,
        head=MERGE_BRANCH,
        base=TARGET_BRANCH
    )
    print("Pull request created successfully.")


if __name__ == "__main__":
    setup_repo()

    update_merge_branch()
    commit_log = detect_commits()

    if commit_log:
        changelog = build_changelog(commit_log)
        pull_body = prepare_pull_body(changelog)
        create_pr(pull_body)
    else:
        print(f"No changes detected from {UPSTREAM_REPO}/{UPSTREAM_BRANCH}. Skipping pull request creation.")
