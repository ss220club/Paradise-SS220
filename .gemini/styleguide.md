# Gemini Code Review Style Guide for Paradise SS220

Use this guide when reviewing pull requests in this repository. Review only the
changed code unless a surrounding issue is directly caused by the change.

## Review Voice

- Write review comments in Russian.
- Be concise, concrete, and civil. Point to the exact problem and suggest a
  practical fix.
- Do not leave praise-only, joke-only, or generic comments.
- Do not block on minor style nits unless they affect readability,
  maintainability, mergeability with upstream, or consistency with nearby code.
- Prefer one short summary comment plus targeted inline comments for actionable
  issues.

## Review Priorities

1. Correctness: runtime crashes, bad type assumptions, broken game behavior,
   missing null checks, incorrect permissions, bad state transitions.
2. Fork maintainability: SS220 changes should be modular where possible, and
   non-modular edits must be clearly marked.
3. Player-facing quality: unclear messages, wrong language, bad span severity,
   missing feedback, balance-impacting changes without explanation.
4. Style: local code style, naming, formatting, comments, changelog, tests.

## SS220 Fork Rules

- This repository is a fork. Prefer implementing SS220-specific features in
  `modular_ss220/` instead of editing upstream/core files under `code/`,
  `_maps/`, `icons/`, `sound/`, `tgui/`, or other shared upstream areas.
- If a change in upstream/core code is only a hook or integration point needed
  by a module, keep that change minimal and ask whether the rest can live in
  `modular_ss220/`.
- New modular features should follow the modpack structure:
  `modular_ss220/<feature>/_<feature>.dm`,
  `modular_ss220/<feature>/_<feature>.dme`, and feature files included from the
  local `.dme`. The root `paradise.dme` already includes
  `modular_ss220/modular_ss220.dme`.
- Prefer module-local assets under the same module, such as
  `modular_ss220/<feature>/icons/` and `modular_ss220/<feature>/sound/`.
- Do not demand modularization for tiny unavoidable integration changes, map
  edits, config changes, generated files, or changes whose surrounding code is
  already explicitly non-modular by design. If unsure, phrase it as a question.

## Marking Non-Modular SS220 Edits

- Non-modular SS220 changes in upstream/core files should be marked with
  `// SS220 EDIT - <short reason>` on the changed line when the edit is small.
- For multi-line non-modular changes, use a block:

```dm
// SS220 EDIT START - <short reason>
...
// SS220 EDIT END
```

- Prefer the spaced form `// SS220 EDIT`; older code contains variants like
  `//SS220 EDIT`, but new comments should use the spaced form.
- If changing upstream behavior from an original value, include the original
  value when useful, for example `// SS220 EDIT - ORIGINAL: copytext`.
- Do not require `SS220 EDIT` comments inside `modular_ss220/`; the path already
  marks the code as SS220-specific.
- Do not require these comments for obvious repo metadata, pure documentation,
  generated files, or local module files unless the absence would make future
  upstream merges harder.
- Leave an actionable comment when a core edit lacks a marker:
  "Это SS220-изменение в upstream-файле. Пожалуйста, пометьте его
  `// SS220 EDIT - <reason>` или блоком START/END, чтобы упростить будущие
  апстрим-мержи."

## DM Style

- Use tabs for indentation in DM code, not spaces.
- Use descriptive `snake_case` for variables, arguments, and procs. Avoid
  single-letter names except for very small, conventional loops.
- Use American English spelling for identifiers that are not player-facing
  Russian text.
- Use `TRUE` and `FALSE` for booleans instead of `1` and `0`.
- Use double quotes for strings and single quotes for file references:
  `"message"` and `'icons/example.dmi'`.
- Break long strings or dense proc calls across lines for readability.
- Prefer `to_chat()`, `visible_message()`, and project span helpers over raw
  `<<` chat output.
- Choose message severity intentionally: notice for normal feedback, warning
  for failures, danger/userdanger for damage or immediate threat.
- Use Autodoc comments (`///`) before vars/procs that need API-level
  documentation. Use `//!` for single-line macro documentation.
- Do not leave commented-out code unless it is intentionally kept for a narrow
  debugging or compatibility reason and that reason is explained.

## DM Safety and Runtime Stability

- Check nullable values after `locate()`, list lookups, weak references, client
  access, `loc` changes, `QDELETED()` risk, or delayed callbacks.
- Use `istype()` or equivalent type guards before accessing type-specific vars
  or procs.
- Be careful with `sleep()` or delayed callbacks when object deletion, moved
  locations, or stale state can cause runtime bugs.
- Do not leave standalone performance comments. Humans will review performance
  tradeoffs unless the change creates an obvious correctness or runtime risk.
- Prefer named constants or defines over unexplained magic numbers, especially
  for timing, damage, probabilities, access, and balance values.
- For list formatting with many entries or likely churn, prefer one item per
  line with a trailing comma when local style supports it.

## TGUI, TypeScript, and UI

- Follow nearby TGUI patterns before introducing new abstractions.
- Keep components typed. Avoid `any` unless the surrounding API forces it.
- Prefer existing TGUI components, hooks, and utility functions over custom UI
  primitives.
- Keep player-facing text consistent with the rest of the interface. Russian
  text should be natural and typo-free; English admin/dev text should match the
  existing context.
- Do not suggest moving all strings to localization unless nearby code already
  uses that pattern.

## Tests, Changelog, and PR Hygiene

- A PR should be atomic: flag unrelated fixes, broad refactors, or bundled
  balance changes that should be split.
- Ask for a changelog when the change is player-facing and one is missing.
- Ask for tests when the change touches shared behavior, parsing, permissions,
  subsystem logic, TGUI data contracts, or bug fixes with clear regression risk.
- For map or asset changes, check that required includes, paths, icon states,
  sound paths, and licensing-sensitive folders remain consistent.
- Do not request tests for trivial comments, documentation-only edits, small
  data-only tweaks, or changes that cannot reasonably be covered by existing
  test infrastructure.

## How To Phrase Comments

Use this shape for actionable comments:

```text
Проблема: <what is wrong and why it matters>.
Предложение: <specific fix or direction>.
```

Examples:

- `code/__HELPERS/time.dm`: "Это SS220-изменение в core-файле. Оберните блок в
  `// SS220 EDIT START - timestamp fix` / `// SS220 EDIT END`, как сделано в
  соседних timestamp helpers."
- `code/datums/datacore.dm`: "Здесь используется SS220-ассет из
  `modular_ss220/species/...` внутри upstream-файла. Если вынести логику в
  модуль нельзя, оставьте `SS220 EDIT` блок с короткой причиной."
- `tgui/...`: "Компонент получает нетипизированные props. Добавьте interface или
  используйте существующий тип данных из backend payload, чтобы Gemini/TS могли
  поймать несовпадение контракта."

## When To Stay Silent

- The issue predates the PR and is not made worse by it.
- The code follows a local pattern even if a different style would be preferred
  in a greenfield file.
- The suggestion would be larger than the PR's scope and is not needed for
  correctness or maintainability.
- The only problem is personal taste.
