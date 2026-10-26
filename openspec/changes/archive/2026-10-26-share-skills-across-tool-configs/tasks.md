# Tasks

## 1. Create the canonical shared skill layout

- [x] 1.1 Rename `.agent` to `.agents` as the first layout change, preserving its skills, workflows, and other contents; verify the renamed directory contains every original file and `.agent` is no longer a separate directory.
- [x] 1.2 Refresh the OpenSpec workflow skills in `.agents/skills` from the latest `Fission-AI/OpenSpec` `main` branch `skills/` bundle; verify imported OpenSpec skill files match the fetched upstream snapshot and non-OpenSpec project skills are retained.
- [x] 1.3 Consolidate remaining skills from `.bob/skills` and `.claude/skills` under `.agents/skills`, reconciling tool-specific command guidance without replacing refreshed upstream OpenSpec content with stale copies; verify each skill is represented once and supported invocation guidance remains.
- [x] 1.4 Replace `.bob/skills` and `.claude/skills` with relative links to `.agents/skills` and update `AGENTS.md` to name the canonical source; verify both links resolve and expose the same skill files.

## 2. Update installation and user documentation

- [x] 2.1 Update `install-skills.sh` to install canonical skills and create destination-relative tool links while preserving unrelated tool configuration and reporting unsafe skill-directory conflicts; add a shell-level installer test using an isolated fixture and verify clean installation and conflict handling.
- [x] 2.2 Update `README.md` installation and contribution guidance to describe `.agents/skills` and the shared tool entry points; verify referenced paths and documented installation behavior match the installer.

## 3. Automate ongoing OpenSpec skill synchronization

- [x] 3.1 Add a weekly and manually triggerable GitHub Actions workflow to compare the `Fission-AI/OpenSpec` `main/skills/` bundle with managed OpenSpec skills in `.agents/skills`; verify a no-change run creates no pull request and a changed bundle opens or updates a pull request.
- [x] 3.2 Implement and test safe synchronization of upstream additions, updates, removals, and renames; verify unrelated/local skills are preserved, stale upstream-managed files are cleaned up when safe, and ambiguous path/name conflicts are described along with cleanup results in the pull request notes.

## 4. Verify integrated behavior

- [x] 4.1 Run the installer and synchronization tests and validate the repository layout from a fresh checkout; verify all supported entry points resolve to `.agents/skills`, the OpenSpec skill files match the imported upstream snapshot, no-change synchronization creates no pull request, and OpenSpec validation passes.
