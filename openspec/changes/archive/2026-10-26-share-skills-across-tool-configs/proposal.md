# Proposal

## Why

The repository keeps separate skill trees under `.agent`, `.bob`, and `.claude`, which can drift and make the same skill unavailable or inconsistent across AI-assisted tools. Establishing `.agents/skills` as the canonical source gives every supported tool one shared set of skills to discover and maintain.

## What Changes

- First rename the repository's `.agent` directory to `.agents`, preserving its contents and making `.agents/skills` the canonical source.
- Refresh the bundled OpenSpec workflow skills from `Fission-AI/OpenSpec`'s `main` branch `skills/` bundle during migration, then keep them synchronized weekly through an automated workflow that proposes updates as pull requests.
- Consolidate skills from `.bob/skills` and `.claude/skills` into `.agents/skills`, then make those tool-specific skill paths expose the canonical collection without maintaining separate copies.
- Update the installer, repository guidance, and user-facing documentation to use `.agents` as the canonical configuration folder and explain the shared skill entry points.
- Preserve tool-specific commands and workflows in their current configuration folders.

## Capabilities

### New Capabilities

- `shared-skill-discovery`: Provide one canonical set of skills that is available through each supported AI tool configuration folder and through installation.

### Modified Capabilities

None.

## Impact

Affected repository content includes the `.agent`-to-`.agents` directory rename, the OpenSpec skill bundle sourced from `Fission-AI/OpenSpec` (`main` branch, `skills/` directory), skills under `.bob/skills` and `.claude/skills`, the `install-skills.sh` installer, skill-location guidance in `AGENTS.md` and `README.md`, and an automated weekly synchronization workflow. Skills are exposed through `.agents`, `.bob`, and `.claude`; `.agent` is not retained as a separate entry point. Tool-specific commands and workflows remain in their existing tool folders, with the renamed `.agents/workflows` preserved.
