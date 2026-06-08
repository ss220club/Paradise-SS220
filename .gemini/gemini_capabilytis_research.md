# Gemini Code Assist research

Temporary research notes for configuring Gemini Code Assist as a useful code review agent for this repository.

## Sources checked

- Google Cloud: [Review GitHub code using Gemini Code Assist](https://docs.cloud.google.com/gemini/docs/code-review/review-repo-code), last updated 2026-06-03.
- Google Cloud: [Set up Gemini Code Assist on GitHub](https://docs.cloud.google.com/gemini/docs/code-review/set-up-code-assist-github), last updated 2026-06-03.
- Google Cloud: [Use Gemini Code Assist on GitHub](https://docs.cloud.google.com/gemini/docs/code-review/use-code-assist-github), last updated 2026-06-03.
- Google Cloud: [Customize Gemini Code Assist behavior in GitHub](https://docs.cloud.google.com/gemini/docs/code-review/customize-repo-review), last updated 2026-06-03.
- Google Cloud: [Code review style guide](https://docs.cloud.google.com/gemini/docs/code-review/style-guide), last updated 2026-06-03.
- Google Cloud: [Configure local codebase awareness](https://docs.cloud.google.com/gemini/docs/codeassist/configure-local-codebase-awareness), last updated 2026-06-03.
- Google Cloud: [Code customization overview](https://docs.cloud.google.com/gemini/docs/codeassist/code-customization-overview), last updated 2026-06-03.
- Reference PR: [ss220club/BandaStation#1501](https://github.com/ss220club/BandaStation/pull/1501), merged 2025-06-09, added `.gemini/styleguide.md`.
- Local docs: `docs/coding/style_guidelines.md`, `docs/coding/coding_requirements.md`, `docs/coding/testing_requirements.md`, `docs/CONTRIBUTING.md`, `modular_ss220/README.md`.

## Practical conclusion

For this repository, the important work is not just "enable Gemini". We need repository-level instructions that teach the reviewer what this fork considers good code: DM/BYOND style, Paradise conventions, TGUI rules, testing expectations, and SS220-specific modularization.

The must-have setup is:

1. Gemini Code Assist on GitHub Enterprise.
2. `.gemini/styleguide.md` in the repository root.
3. `.gemini/config.yaml` in the repository root.
4. `.gemini/config.yaml: ignore_patterns` for generated, vendored, binary, map, or build files that should not be reviewed automatically.
5. Local project docs referenced from the style guide.
6. A calibration pass on real PRs before making the bot too strict.

## Required Google-side setup

Google now recommends the enterprise version for GitHub code review. The consumer version is scheduled to stop serving requests on 2026-07-17, so a new setup should not depend on it.

Enterprise setup requires:

- A GitHub organization or account with the target repositories.
- A Google Cloud project connected to billing.
- IAM permissions for setup, including `Service Usage Admin` and `geminicodeassistmanagement.scmConnectionAdmin`, or broad admin/owner rights.
- Developer Connect via the Code Assist Source Code Management card in Gemini Code Assist Agents & Tools.
- The GitHub App installed for selected repositories.

Important implementation detail: the Developer Connect connection for Gemini Code Assist on GitHub is created in `us-east1` and must be created through the Code Assist Source Code Management setup flow.

## Repository configuration files

### `.gemini/styleguide.md`

Google treats this as normal Markdown with no fixed schema. It expands the standard review prompt, so it should be written as direct review instructions, not as human-only documentation.

For SS220 it should include:

- Review language and tone.
- DM/BYOND style rules from `docs/coding/style_guidelines.md` and `docs/coding/coding_requirements.md`.
- TGUI expectations for UI changes.
- Testing expectations from `docs/coding/testing_requirements.md`.
- Fork policy: prefer new SS220 behavior in `modular_ss220`.
- Non-modular upstream edits must usually be marked with `// SS220 EDIT` or `// SS220 EDIT START` / `// SS220 EDIT END`.
- Review priority: correctness, runtime safety, fork maintainability, security, player-facing quality, then style. Standalone performance review stays with humans.

Reference PR #1501 is useful as a starting point because it shows the intended shape of a Gemini style guide, but it is too generic for this repo by itself. It should be adapted to our actual docs and fork rules.

### `.gemini/config.yaml`

This file controls review behavior. The relevant fields are:

- `code_review.disable`: keep `false`.
- `code_review.comment_severity_threshold`: controls noise. Google default is `MEDIUM`.
- `code_review.max_review_comments`: use a finite number if the bot gets too noisy; default is unlimited.
- `code_review.pull_request_opened.code_review`: default is `true`, so the bot reviews newly opened PRs.
- `code_review.pull_request_opened.summary`: default is `false`; enable if automatic summaries are useful.
- `code_review.pull_request_opened.include_drafts`: default is `true`; set `false` if draft PRs should stay quiet until they are ready.
- `ignore_patterns`: repository-level glob exclusions for files Gemini should ignore.
- `have_fun`: optional fun output in PR summaries. We currently set it to `true`; switch back to `false` if summaries become noisy.

Suggested initial config:

```yaml
have_fun: true
code_review:
  disable: false
  comment_severity_threshold: MEDIUM
  max_review_comments: 20
  pull_request_opened:
    help: false
    summary: true
    code_review: true
    include_drafts: false
ignore_patterns:
  - "modular_ss220/generated/**"
  - "modular_ss220/example/generated/**"
  - "**/*.dmi"
  - "**/*.ogg"
  - "**/*.dmm"
  - "rustlibs.dll"
  - "tgui/public/**/*.bundle.*"
  - "tgui/public/.tmp/**"
  - "tgui/.yarn/rspack/**"
```

`have_fun: true` enables optional fun features in Gemini output, such as a poem in the initial PR summary. It does not change the review severity threshold. If summaries become noisy, set it back to `false`.

This list is for Gemini Code Assist on GitHub code review. It should filter files that are too noisy or low-value for automated review: generated output, binary assets, maps, and build artifacts. Do not exclude broad source folders such as `code/`, `modular_ss220/`, `tgui/packages/`, or `docs/`.

### `.aiexclude`

Do not add `.aiexclude` for the initial setup. It affects Gemini Code Assist context outside GitHub PR review, including IDE code generation, chat, and Enterprise code customization. That is broader than we need right now.

For this repository, keep review exclusions in `.gemini/config.yaml: ignore_patterns` only. This keeps GitHub PR review quiet for generated, binary, map, and build files while avoiding accidental loss of useful context in interactive Gemini workflows.

## Code customization and local awareness

Local codebase awareness is useful for IDE work because Gemini can use open files, indexed local context, and agent tools to find relevant files.

Enterprise code customization can index organization repositories and refreshes roughly every 24 hours. This can help with private APIs, local docs, TypeScript, JavaScript, Rust, and Markdown documentation.

Limitation for this repository: Google lists supported code customization languages, and BYOND DM is not in that list. So code customization should be treated as optional support for surrounding code and docs, not as the main mechanism for DM review quality. The main mechanism for DM review quality is `.gemini/styleguide.md` plus local repository context.

## How reviewers invoke Gemini

Gemini automatically reviews new PRs when enabled. It can also be invoked in PR comments:

- `/gemini summary`
- `/gemini review`
- `/gemini`
- `/gemini help`

Review comments can include severity, feedback, suggestions, and references to the user-provided style guide. This means the style guide should be specific enough that Gemini can cite it when flagging SS220-specific issues.

## SS220-specific instructions to encode

The style guide should teach Gemini these local priorities:

- Prefer modular implementation in `modular_ss220` for SS220-specific behavior.
- Avoid editing upstream/core files when a modpack override, subtype, signal, component, config, or hook can solve the problem cleanly.
- When upstream/core edits are unavoidable, require `// SS220 EDIT` for small single-line changes or `// SS220 EDIT START` / `// SS220 EDIT END` around blocks.
- Ask for justification when a PR changes upstream/core files without modularization or SS220 edit markers.
- Preserve Paradise DM conventions: tabs, snake_case variables, absolute type paths, `to_chat()`/`visible_message()`, `TRUE`/`FALSE` for booleans, guard clauses, no `sleep()`/`spawn()` when `addtimer()` is feasible, no text type paths, no direct boolean comparisons to `TRUE`/`FALSE`.
- Prefer TGUI for new in-game UI.
- Require SQL parameterization and safe player input handling.
- Require compile/runtime/functional testing notes for PRs.

Existing examples are present in the current checkout. Useful references include:

- `code/__HELPERS/time.dm`: block markers like `// SS220 EDIT START - timestamp fix` and `// SS220 EDIT END`.
- `code/datums/datacore.dm`: both spaced and older compact forms, including `// SS220 EDIT START - SERPENTIDS` and `//SS220 EDIT START - SERPENTIDS`.
- `code/__HELPERS/text.dm`: single-line markers such as `// SS220 EDIT` and `// SS220 EDIT - ORIGINAL: copytext`.

The style guide should prefer the spaced modern form for new code, while recognizing older compact variants during review.

## Rollout plan

1. Keep `.gemini/styleguide.md` as the repository-specific SS220 review rules.
2. Keep `.gemini/config.yaml` as the primary GitHub review configuration.
3. Do not add `.aiexclude` until there is a concrete need to restrict IDE/chat/code-customization context.
4. Test on several real PRs with `/gemini review`.
5. Tune `comment_severity_threshold`, `max_review_comments`, and style guide wording based on false positives.
6. Once stable, consider organization-level Enterprise style guide settings only for rules shared by multiple repositories. Keep repo-specific SS220 fork rules in this repository.
