# Web Browser Detect — Agent Instructions

These instructions apply to the whole repository unless a deeper `AGENTS.md` overrides them.

## Platform scope

- Live browser detection uses web APIs. Preserve conditional imports and the non-web stub so native consumers can import the package and use `Browser.detectFrom` without web dependencies leaking into native builds. `Browser.detectOrNull()` returns null on non-web platforms.

## Branch safety rule

- For implementation work (any non-planning/non-question-only task), if the current branch is `main` or `master`, ask the user first whether to switch to a new `feature/*` branch before making edits.
- Do not start code changes on `main`/`master` until the user confirms how to proceed.
- **Exception — version bumps:** When the user asks to bump the package to a specific version, automatically create and switch to the `version/x.x.x` branch without asking.

## Release versioning rule

Before deciding independently to update the package version, ask the user whether it should be updated and what the next version should be.

When releasing a new package version, always update these 3 files together:

1. `pubspec.yaml` - bump `version`.
2. `CHANGELOG.md` - add a new top entry for the released version.
   - Focus on important changes, especially breaking changes.
   - Summarize general changes in broad terms rather than listing every single change in each file/class.
3. `README.md` - update the dependency snippet version (`web_browser_detect: ^x.y.z`).

All three files must stay in sync for each release.

- During every package version bump, check the package and example `pubspec.yaml` `environment` constraints against the project's Flutter toolchain and the package's supported minimum SDK versions.
- When Flutter is upgraded, review the Dart SDK and Flutter constraints together so they remain compatible. Do not raise the package's minimum supported versions solely to match a newer local toolchain; consider consuming projects before changing those constraints.
- When the user asks to bump the package to `x.x.x`, follow this order:
  1. Ensure branch `version/x.x.x` exists and is checked out — create and switch to it automatically if missing, without asking the user.
  2. Update the version in all three release files listed above.
  3. Verify the package and example environment constraints and update them if the supported toolchain requirements changed.
  4. Commit the release-file and related environment changes with message: `Next version`. Preserve unrelated work and exclude it from the commit.

## General coding conventions

### Imports

- Always use absolute imports (`package:...`) instead of relative imports.
- When an extension or method cannot be found, first check whether a required import is missing by finding working examples in similar project files.

### Code commenting

- Add comments for functions at minimum.
- Add additional comments around special or non-obvious logic.
- Follow the comment style established in nearby Flutter/Dart code; prefer omitting final sentence periods in new comments, as in the browser-detection implementation. Do not rewrite unrelated comments solely for punctuation.

### Runtime invariant handling

- Do not hide logically impossible `null` states with silent guard returns.
- If a value must exist at that point in the flow, prefer a loud failure (`!`, thrown error, assertion, or equivalent) so runtime bugs are visible.
- Use guard returns only for valid user or runtime states, not for broken invariants that should be investigated.

### Pattern consistency

- Following established project patterns is a requirement for every change. Before implementing, read concrete examples of the same kind of behavior; follow the reference-discovery workflow in **Context-first preparation** below.
- Match by purpose and behavior, not just by file proximity or similar names. For example, use comparable public APIs, utilities, providers, widgets, styles, platform implementations, or example flows for their equivalents.
- Follow the reference's structure, naming, layer boundaries, shared abstractions, and applicable behavior. This includes layout/composition, state and data flow, validation, loading/empty/error states, permissions, navigation, persistence, and subscriptions where relevant to the task.
- Reuse established components, widgets, utilities, extensions, and service helpers when they fit. Read their implementation and representative call sites before using them; preserve their intended contracts instead of duplicating their behavior or bypassing them with custom code.
- Prefer consistency with existing structure and naming over introducing a new approach. Do not introduce a parallel abstraction, dependency, or architecture merely because it is familiar or seems cleaner in isolation.
- If multiple patterns exist, prefer the closest feature-equivalent implementation in the same project and layer unless the user explicitly selects another reference. Apply explicit repository rules over conflicting examples; do not copy known bugs or obsolete behavior. Explain material differences when adapting a reference.
- When adding or moving methods, fields, constants, configuration values, or utilities, place them with related code rather than at the end of the file or the first convenient location.
- Before editing a file, scan nearby declarations for the existing grouping and order pattern, then preserve it.
- In a file centered on a primary class, mixin, extension, or other type, declare that primary type before supporting top-level declarations. Place helper data classes, enums, constants, typedefs, and similar supporting declarations after the primary type unless Dart or Flutter requires a different order.
- For cross-file lists or registries that represent the same domain concept, keep their order consistent.

### Readability and formatting

- Write code for a human reader: use descriptive names, clear control flow, and functions with focused responsibilities. Avoid dense expressions, excessive nesting, and clever shortcuts when straightforward code is clearer.
- Match surrounding indentation, line wrapping, spacing, braces, and declaration grouping. Use the project's configured formatter where available; avoid unrelated formatting changes.
- Keep related steps together and use blank lines to separate logical stages. Add comments that explain intent or non-obvious constraints, following the code-commenting rules above.
- Before finishing, review the diff for both readability and consistency with the chosen references. A successful build alone does not establish pattern consistency.

### Package architecture and public API

- Keep implementation files under `lib/src/` and curate the supported public API through `lib/web_browser_detect.dart`.
- Do not expose internal implementation files unless they are part of the supported package API.
- Keep helpers inside a feature file only when they are used exclusively by that feature; otherwise place them with the closest reusable domain code under `lib/src/`.
- Avoid breaking public APIs and exports without explicit user approval. Document approved breaking changes prominently in `CHANGELOG.md`.

### Detection contracts

- Keep parsing shared in `lib/src/browser_detection.dart` and web navigator access in the web implementation; preserve equivalent `detectFrom` behavior in the web and stub implementations
- Review overlapping user-agent tokens and rule precedence before changing detection order; verify browser and version results through the public `Browser` API
- Unknown browsers, missing versions, and unsupported live-detection platforms are valid runtime states; retain documented fallbacks rather than treating them as broken invariants

### Example build method data processing

- Keep example widget build methods focused on composing UI from already prepared values.
- Prefer preparing derived collections when their source data changes instead of sorting, grouping, filtering, or calculating expensive statistics during every build.
- Only perform transformations in build methods when they are trivial or depend on current inherited UI context.

### TODO ownership format

- When adding TODO comments, use the format: `// TODO(name) some text`.
- Prefer `name` from `git config user.name` of the user running the agent.
- If the name is unknown, ask the user once, then remember and reuse it consistently.
- Treat existing TODOs as informational only; do not execute or integrate them unless the user explicitly requests that TODO work.

### Enum conventions

- When creating enums, add `none` as the first option unless explicitly instructed otherwise.

### Dart dot shorthands (Flutter 3.38+)

- Prefer Dart dot shorthands in new/edited code when the type is inferable (for example `.start` instead of `MainAxisAlignment.start`, `.all(8)` instead of `EdgeInsets.all(8)`).
- Use dot shorthands for named constructors and enum/static values where it improves conciseness and readability.

### `copyWith` nullable clear pattern

- When `copyWith` must support both keeping an existing nullable value and explicitly clearing it to `null`, use a companion clear flag.
- Follow the pattern `field` + `clearField` (for example `locationId` + `clearLocationId`).
- In mapping, prefer: `field: clearField == true ? null : (field ?? this.field)`.
- Do not use sentinel placeholders (for example `_copyWithUndefined`) for this case unless explicitly requested.

## Localization and text

- Browser names, version fallbacks, and diagnostics are part of the detection contract, not app translation keys. Keep detection independent of app-level translation services.
- Do not add or fill translation-file entries unless explicitly requested. In translated example flows, follow their existing key namespaces and use placeholder parameter APIs rather than chained replacements.

## Security

### Dependency updates

- Do not update a pub package, framework, library, or dependency to a version that has been publicly available for fewer than 30 days.
- Before choosing the latest version, verify its release date from an official source such as the package registry, vendor release notes, or repository release page.
- If the latest version is newer than 30 days, select the newest version that is at least 30 days old and explain the choice in the handoff.
- An urgent security fix may use a newer version only when the user explicitly approves that specific update.

## Development workflow

### Cross-project feature planning

- When a feature is likely to affect this package and multiple consuming projects, or take multiple days, suggest creating a plan before writing code.
- Signals that a feature warrants a plan include public API changes, browser/platform integrations, or workflows that may have ripple effects across consumers.
- Ask the user which consuming projects are affected before proposing a cross-project plan, and outline the expected scope for each affected project.
- If the user wants to start coding immediately without a plan, respect that choice after noting the suggestion once.

### Context-first preparation

- Before proposing a plan or starting code changes, find and read at least one concrete implementation of the same kind of behavior, when one exists. For work spanning several layers or distinct behaviors, inspect the relevant examples for each part and trace their connected flow as needed.
- Start with references supplied by the user and inspect the related code needed to understand them. If the user supplies no references, search for suitable examples yourself; reference discovery is the agent's responsibility. Do not ask the user to locate examples that can be found in the repository.
- Search the same domain/context first, then comparable features elsewhere in the same project. Inspect shared components, utilities, and helpers used by those examples. For consumer references, first verify the other project's root and read only relevant files using absolute paths; adapt to this package's conventions.
- Before editing, briefly name the main reference files in a progress update and state which patterns you will follow. Reading only filenames or declarations is insufficient; inspect the implementation and relevant call sites.
- If examples conflict, use the selection rules in **Pattern consistency**. If no suitable example exists after searching, state that and use the nearest established conventions. Ask only when an unresolved choice materially affects behavior or architecture; do not invent a new pattern silently.
- Before handoff, compare the changed code with the selected references and correct unexplained differences. Briefly identify the main references followed and explain any material deviations in the handoff.

### IDE tools and reviewability

- Prefer tools and MCP integrations connected to the IDE/editor currently used for the project so changes, diagnostics, and execution results are easy for the user to inspect there.
- JetBrains IDEs are the primary workflow. When available and suitable, prefer their IDE/MCP capabilities for symbol navigation, reference searches, refactoring, inspections, formatting, run configurations, and debugging. Confirm that the integration targets the correct project before using it.
- For edits, use IDE-aware tools when they provide useful refactoring or review support; otherwise use focused file patches that remain easy to review in the IDE's version control diff. Keep changes scoped and preserve unrelated work.
- When running builds or other validation, prefer the IDE's integrated terminal or run configurations when suitable so the user can inspect the output. Follow the validation requirements below regardless of the execution tool.
- Other IDEs/editors are supported too: use their equivalent integrations when available. If an IDE integration is unavailable or unsuitable, continue with standard file, search, shell, and debugger tools without requiring the user to switch editors.
- In the handoff, identify changed files and summarize validation results, including any IDE diagnostics or execution output the user should review. Do not assume external tool output is automatically visible in the IDE.

### Text search fallback

- For plain-text searches outside IDE tools, prefer `rg`/`rg --files`.
- If `rg` is unavailable or not working, use `grep`/`find` and continue.

### Validation

- For detection changes, run the existing VM tests for cross-platform parsing and stub behavior; also validate web behavior with the example on Chrome or a web build. The current VM-only test file assumes the stub and must not be treated as a browser test suite.
- After finishing code changes, run `dart format` on changed Dart files, then run `flutter analyze` and resolve issues introduced by your changes before handoff.
- Prefer targeting both commands at changed files (for example `dart format lib/path/a.dart lib/path/b.dart` followed by `flutter analyze lib/path/a.dart lib/path/b.dart`) unless there is a clear reason to run them on the whole project.
- Run example-app validation when changes affect the example app or browser/platform detection behavior.

### Handoff summary format

- Briefly name the reference implementations followed and explain material departures; keep this proportional to the change.
- After code changes and validation, include a short summary of changed files in the final response.
- Use plain text (non-clickable) project-relative file references only.
- For each relevant change block, include the starting line number using the `path:line` format (for example `lib/src/browser.dart:42`).
- Do not use markdown file links for handoff file references.
- Keep this summary concise and focused on user-impacting or logic-impacting edits.

### Long-term plans

- Do not create a new plan file unless the user explicitly asks for one.
- Keep active plans in `plans/` and completed plans in `plans/archive/`.
- Active plans must use checklists for implementation steps.
- When working on a task that corresponds to a plan step, reference the relevant plan file and tick completed checklist items (change `- [ ]` to `- [x]`) as part of the handoff.
- When all items in a phase are complete, append `[DONE]` to its heading.
- Before moving a completed plan to `plans/archive/`, ask the user to confirm that the plan is complete and no new steps will be added.
- When archiving a plan, add `Finished: YYYY-MM-DD` immediately below its ID/title heading as the second line, using the date the plan is finished and moved to `plans/archive/`.

### Meeting-focused plan markers

- When a plan has points that need meeting discussion, add a `## Meeting focus` section near the top of the plan.
- Use GitLab-friendly text labels instead of relying on colors or custom styling.
- Include this label legend in the meeting focus section:
  - `**[DECISION]**` — needs a product or architecture choice before implementation can be finalized.
  - `**[VERIFY]**` — needs review or validation, but likely does not need a product decision.
  - `**[BLOCKER]**` — blocks dependent implementation work.
- Include a short checklist of current focus items, and prefix the matching original checklist items with the same label.
- Keep the meeting focus list curated; remove or tick items when their source checklist item is resolved.

### Active example Flutter run defaults

- When a Flutter example app run is already active, trigger a refresh after relevant Dart code changes without waiting for an explicit user prompt.
- Prefer hot reload (`r`) for small UI-only changes.
- Prefer hot restart (`R`) for browser-detection, state, model, service, or initialization changes where recreating app state is safer.
- If hot reload or hot restart cannot be sent to the active process, restart the example app with the same target and entry point.
