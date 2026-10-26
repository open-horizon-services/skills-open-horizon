# Spec Delta

## Purpose

Provide one canonical, maintainable collection of skills that can be discovered and used through each supported AI tool configuration folder and the repository installer.

## ADDED Requirements

### Requirement: Skills have one canonical source

The repository MUST maintain skill definitions in `.agents/skills` and expose the same skill collection through the `.agents`, `.bob`, and `.claude` configuration folders.

#### Scenario: A skill is added to the canonical collection

- **WHEN** a skill is added under `.agents/skills`
- **THEN** it is available through each supported skill entry point without creating separate skill-definition copies

#### Scenario: A canonical skill is updated

- **WHEN** a skill definition in `.agents/skills` is changed
- **THEN** each supported skill entry point exposes that updated definition

### Requirement: OpenSpec workflow skills stay synchronized with upstream

The OpenSpec workflow skills in `.agents/skills` MUST be refreshed from the `skills/` bundle on the `main` branch of `Fission-AI/OpenSpec` during migration and synchronized automatically every week afterward.

#### Scenario: Migration refreshes OpenSpec skills

- **WHEN** the migration imports the OpenSpec workflow skills
- **THEN** the imported skills match the upstream bundle available at that time while non-OpenSpec project skills are retained

#### Scenario: Weekly synchronization finds upstream changes

- **WHEN** the weekly synchronization detects upstream skill additions, updates, removals, or renames
- **THEN** it prepares a pull request containing the corresponding safe changes and describes the upstream changes and any cleanup in the pull request notes

#### Scenario: Weekly synchronization finds no changes

- **WHEN** the weekly synchronization finds no differences in the upstream bundle
- **THEN** it does not create an unnecessary pull request

#### Scenario: Synchronization encounters path or naming conflicts

- **WHEN** the synchronization cannot safely reconcile an upstream path or file-name change with local content
- **THEN** it preserves unrelated or ambiguous local content, performs safe cleanup of obsolete upstream-managed files, and records unresolved conflicts and cleanup results in the pull request notes

#### Scenario: Synchronization is triggered manually

- **WHEN** an authorized maintainer manually triggers synchronization
- **THEN** it uses the same comparison, cleanup, conflict-reporting, and pull-request behavior as the weekly run

### Requirement: Shared skill instructions support each configured tool

Shared skills MUST retain tool-specific invocation guidance needed to use them from `.agents`, `.bob`, and `.claude` without maintaining divergent skill copies.

#### Scenario: A shared skill references a tool command

- **WHEN** a user follows a command reference in a shared skill
- **THEN** the instructions identify the appropriate invocation for the supported tool in use

### Requirement: Installation provides the canonical skills to supported tools

The installer MUST install the canonical `.agents` configuration folder and make its skill collection available through `.agents`, `.bob`, and `.claude`.

#### Scenario: Skills are installed into a project

- **WHEN** the installer completes successfully
- **THEN** the destination contains the canonical `.agents/skills` and each supported skill entry point exposes the same collection

#### Scenario: Installation cannot establish a shared skill entry point

- **WHEN** the installer cannot safely create or update a supported tool's skill entry point
- **THEN** it reports the affected path and exits unsuccessfully rather than claiming installation succeeded
