import os
import re
import subprocess
import time
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed
from github import Github
from github.PullRequest import PullRequest
from googletrans import Translator

import changelog_utils

CHANGELOG = "changelog"
MERGE_ORDER = "merge_order"
UPSTREAM_CONFIG_CHANGE_LABEL = "Configuration Change"
UPSTREAM_SQL_CHANGE_LABEL = "SQL Change"
UPSTREAM_WIKI_CHANGE_LABEL = "Requires Wiki Update"
DOWNSTREAM_WIKI_CHANGE_LABEL = ":page_with_curl: Требуется изменение WIKI"

TRACKED_LABELS = {
    UPSTREAM_CONFIG_CHANGE_LABEL,
    UPSTREAM_SQL_CHANGE_LABEL,
    UPSTREAM_WIKI_CHANGE_LABEL,
}

LABEL_BLOCK_STYLE = {
    UPSTREAM_CONFIG_CHANGE_LABEL: "IMPORTANT",
    UPSTREAM_SQL_CHANGE_LABEL: "IMPORTANT",
    UPSTREAM_WIKI_CHANGE_LABEL: "NOTE",
}


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


def fetch_pull(pull_id) -> PullRequest | None:
    """Fetch the pull request from GitHub."""
    github = Github(GITHUB_TOKEN)
    repo = github.get_repo(UPSTREAM_REPO)

    max_retries = 3
    for attempt in range(max_retries):
        try:
            return repo.get_pull(int(pull_id))
        except Exception as e:
            print(f"Error fetching PR #{pull_id}: {e}")
            if attempt + 1 < max_retries:
                time.sleep(2)
            else:
                return None


def build_details(commit_log: list[str]) -> dict:
    """Generate data from parsed commits."""
    print("Building details...")
    details = {
        CHANGELOG: {},
        MERGE_ORDER: [match.group()[1:] for c in commit_log if (match := re.search("#\\d+", c))],
        **{label: {} for label in TRACKED_LABELS}
    }
    pull_cache = {}
    translator = Translator()

    with ThreadPoolExecutor() as executor:
        futures = {}
        for commit in commit_log:
            match = re.search("#\\d+", commit)
            if not match:
                print(f"Skipping {commit}")
                continue

            pull_id = match.group()[1:]

            if pull_id in pull_cache:
                print(
                    f"WARNING: pull duplicate found.\n"
                    f"1: {pull_cache[pull_id]}\n"
                    f"2: {commit}"
                )
                print(f"Skipping {commit}")
                continue

            pull_cache[pull_id] = commit
            futures[executor.submit(fetch_pull, pull_id)] = pull_id

        for future in as_completed(futures):
            pull_id = futures[future]
            pull: PullRequest | None = future.result()
            labels = [label.name for label in pull.get_labels()]
            pull_changes = []

            if not pull:
                continue

            try:
                for label in labels:
                    if label in TRACKED_LABELS:
                        details[label][pull_id] = pull

                parsed = changelog_utils.parse_changelog(pull.body)
                if parsed and parsed["changes"]:
                    for change in parsed["changes"]:
                        tag = change["tag"]
                        message = change["message"]
                        if TRANSLATE_CHANGES:
                            translated_message = translator.translate(message, src="en", dest="ru").text
                            change = f"{tag}: {translated_message} <!-- {tag}: {message} ({pull.html_url}) -->"
                        else:
                            change = f"{tag}: {message} <!-- ({pull.html_url}) -->"
                        pull_changes.append(change)

                if pull_changes:
                    details[CHANGELOG][pull_id] = pull_changes
            except Exception as e:
                print(
                    f"An error occurred while processing {commit}\n"
                    f"URL: {pull.html_url}\n"
                    f"Body: {pull.body}"
                )
                raise e

    return details


def prepare_pull_body(details: dict) -> str:
    """Build new pull request body from the generated changelog."""
    pull_body = (
        f"This pull request merges upstream/{UPSTREAM_BRANCH}. "
        f"Resolve possible conflicts manually and make sure all the changes are applied correctly.\n"
    )

    if not details:
        return pull_body

    for label in TRACKED_LABELS:
        if not details[label]:
            continue

        pull_body += (
            f"\n> [!{LABEL_BLOCK_STYLE[label]}]\n"
            f"> {label}:\n"
        )
        for _, pull in sorted(details[label].items()):
            pull_body += f"> {pull.html_url}\n"

    if not details[CHANGELOG]:
        return pull_body

    pull_body += f"\n## Changelog\n"
    pull_body += f":cl: {CHANGELOG_AUTHOR}\n" if CHANGELOG_AUTHOR else ":cl:\n"
    for pull_id in details[MERGE_ORDER]:
        if pull_id not in details[CHANGELOG]:
            continue
        pull_body += f"{'\n'.join(details[CHANGELOG][pull_id])}\n"
    pull_body += "/:cl:\n"

    return pull_body


def create_pr(details: dict):
    """Create a pull request with the processed changelog."""
    pull_body = prepare_pull_body(details)

    print("Creating pull request...")
    github = Github(GITHUB_TOKEN)
    repo = github.get_repo(TARGET_REPO)

    # Create the pull request
    pull = repo.create_pull(
        title=f"Merge Upstream {datetime.today().strftime('%d.%m.%Y')}",
        body=pull_body,
        head=MERGE_BRANCH,
        base=TARGET_BRANCH
    )

    if details[UPSTREAM_WIKI_CHANGE_LABEL]:
        pull.add_to_labels(DOWNSTREAM_WIKI_CHANGE_LABEL)

    print("Pull request created successfully.")


if __name__ == "__main__":
    setup_repo()

    update_merge_branch()
    commit_log = detect_commits()

    if commit_log:
        details = build_details(commit_log)
        create_pr(details)
    else:
        print(f"No changes detected from {UPSTREAM_REPO}/{UPSTREAM_BRANCH}. Skipping pull request creation.")
