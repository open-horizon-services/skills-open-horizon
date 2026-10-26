# Design

## Context

The repository currently stores distinct skills in `.agent/skills`, `.bob/skills`, and `.claude/skills`. The Bob and Claude OpenSpec skill sets share names but differ in command syntax; `.agent` contains a separate collection and workflows. The official OpenSpec workflow bundle is published in `Fission-AI/OpenSpec` under `skills/` on `main`. Tool-specific commands and workflows must remain tool-specific, while the `.agent` directory is renamed to `.agents` before skill consolidation begins.

See [proposal.md](./proposal.md) for the motivation and [the shared-skill-discovery spec](./specs/shared-skill-discovery/spec.md) for the behavior contract.

## Goals / Non-Goals

**Goals:**

- Rename `.agent` to `.agents` as the first migration step, preserving all directory contents.
- Refresh the bundled OpenSpec workflow skills from the upstream `Fission-AI/OpenSpec` `main` branch during migration and keep the bundle synchronized weekly afterward.
- Maintain each skill definition once under `.agents/skills`.
- Keep skills usable through `.agents`, `.bob`, and `.claude`.
- Preserve tool-specific commands and workflows and the installer's ability to install them.
- Avoid silently deleting target-project skill content during installation.

**Non-Goals:**

- Consolidate tool-specific commands or workflows.
- Add support for AI tools beyond `.agents`, `.bob`, and `.claude`.
- Change the content or behavior of skills beyond making shared instructions usable across the supported tools.

## Decisions

### Use relative symbolic links for tool skill entry points

Rename `.agent` to `.agents` before making other layout changes. This preserves the existing skills and workflows as the basis for the new canonical configuration folder. After consolidating skills, `.bob/skills` and `.claude/skills` will be relative symbolic links to `.agents/skills`; `.agents/skills` itself remains a real directory.

**Alternatives considered:** Keeping `.agent` and creating a separate `.agents` tree would leave two competing sources. Maintaining synchronized tool-specific copies would continue to allow drift. Moving Bob and Claude commands or workflows into `.agents` is outside this change.

### Refresh and continuously synchronize OpenSpec workflow skills

At migration time, import the latest OpenSpec workflow skill files from `Fission-AI/OpenSpec`'s `main` branch `skills/` directory, replacing the existing OpenSpec bundle copies while preserving unrelated repository skills. Add a GitHub Actions workflow that runs weekly and supports manual triggering. Each run fetches the upstream bundle, compares it with the managed OpenSpec skills, applies safe additions, updates, removals, and renames, and creates or updates a pull request only when there are changes. The pull request description summarizes the upstream source/revision, changed paths, cleanup performed, and any unresolved conflicts.

Track which files are upstream-managed so cleanup can remove stale upstream files without deleting unrelated local skills. When a path or name change collides with locally customized or unrelated content, preserve ambiguous local files, complete safe cleanup, and explicitly report what remains unresolved in the pull request rather than silently overwriting content.

**Alternatives considered:** Keeping only the migration-time snapshot would allow the bundle to become stale. Updating the default branch directly would bypass review; a pull request keeps upstream changes reviewable. Synchronizing during every installation would make installation depend on network availability and couple downstream projects to upstream changes.

### Reconcile existing skill content into a portable shared collection

After refreshing the upstream OpenSpec bundle, merge remaining skills currently present under `.bob` and `.claude` into `.agents/skills`. Preserve project-specific skills and reconcile tool-specific guidance without overwriting the current upstream OpenSpec content with stale copies. Keep only one skill definition per skill name.

**Alternatives considered:** Keeping divergent variants in each tool folder would violate the single-source requirement. Choosing one variant unchanged would leave one tool with inaccurate invocation guidance.

### Have the installer establish links at the destination

The installer will install the canonical `.agents` content, continue installing tool-specific configuration content, and create relative links from `.bob/skills` and `.claude/skills` to `.agents/skills`. It must detect existing non-link skill directories and handle them without silently discarding user content; unsafe conflicts must produce an actionable error.

**Alternatives considered:** Copying the repository's links as-is risks links that resolve to the wrong relative location in the destination. Copying independent skill trees would recreate the divergence this change addresses.

## Risks / Trade-offs

- [A supported tool or target filesystem may not follow symbolic links] → Validate link-based discovery for each supported configuration and make installer failures explicit rather than reporting success with unavailable skills.
- [Existing installations may contain user-edited or conflicting skill files] → Preserve unrelated configuration content and do not replace non-link skill directories without safe reconciliation; report conflicts with their paths.
- [Upstream renames or removes files that have local edits] → Track upstream-managed paths, perform only safe cleanup, and include unresolved collisions in the synchronization pull request notes.
- [Upstream changes may be incompatible with local conventions] → Route all automated updates through a reviewable pull request rather than merging them automatically.
- [One portable OpenSpec skill may be less tailored than separate Bob and Claude variants] → Retain both tools' exact command forms in the shared instruction and verify references during migration.

## Migration Plan

1. Rename `.agent` to `.agents` and verify its existing skills, workflows, and other contents are preserved.
2. Fetch the latest `Fission-AI/OpenSpec` `main` branch `skills/` bundle and refresh the OpenSpec workflow skills in `.agents/skills`; verify the imported files match that upstream snapshot and unrelated project skills remain.
3. Reconcile any remaining Bob and Claude skill definitions into `.agents/skills`, then replace `.bob/skills` and `.claude/skills` with relative links to the canonical directory.
4. Update repository guidance and the installer to document and establish the canonical layout.
5. Add and test a weekly/manual GitHub Actions synchronization workflow that proposes upstream updates through pull requests and documents path conflicts and cleanup.
6. Verify that each link resolves to the canonical skills, the OpenSpec bundle matches the imported upstream snapshot, and installation and ongoing synchronization handle existing content safely.

Rollback consists of restoring the previous skill files/directories and installer/documentation. Keep the migration in version control so this can be done without removing user project content.
