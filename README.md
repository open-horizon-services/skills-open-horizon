# skills-open-horizon

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE.md)
[![Open Horizon](https://img.shields.io/badge/Open%20Horizon-Project-0081CB)](https://lfedge.org/projects/open-horizon/)
[![GitHub contributors](https://img.shields.io/github/contributors/open-horizon-services/skills-open-horizon)](https://github.com/open-horizon-services/skills-open-horizon/graphs/contributors)

AI-assisted skills for bootstrapping and managing [Open Horizon](https://lfedge.org/projects/open-horizon/) service repositories. Drop these into any project to let your ML-assisted IDE scaffold license files, `.gitignore`, `MAINTAINERS.md`, `Makefile`, and `README.md` using conversational commands.

## Table of Contents

- [Install](#install-skills-into-your-project)
- [Prerequisites](#prerequisites)
- [Skills](#skills)
- [Initialize a Repository](#initialize-the-repository)
- [Contributing](#contributing)
- [License](#license)

## Install skills into your project

Run this one-liner from the root of your target repository to download and execute the installer script. It clones this repository into a temporary directory, copies the `.agent` folder into your project, then removes the temporary directory.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/open-horizon-services/skills-open-horizon/main/install-skills.sh)
```

> **Tip:** The script creates `.agent/` in your current working directory, so run it from your repository root.

## Prerequisites

### Install [Open Spec](https://openspec.dev/)

Requires NodeJS 20.19.0+ to install globally, which is recommended.

```bash
# To install globally
npm install -g @fission-ai/openspec@latest

# To verify
openspec --version
```

Note: It can also be run from a Docker container instead of installed.

### (Fork and) clone your repository

```bash
cd your-repository-folder
openspec init
# choose your editor and [Enter]
```

### Optionally install Obsidian

Install the Obsidian desktop app and activate the CLI, then run the `init-obsidian` skill to set up an Obsidian vault for managing memories and keeping your context clean.

For full instructions refer to [`.agent/skills/init-obsidian/SKILL.md`](.agent/skills/init-obsidian/SKILL.md).

## Skills

| Skill | Description |
|---|---|
| `init-license` | Create or replace a `LICENSE.md` (Apache 2.0, MIT, MPL, ISC) with copyright placeholders populated from git config |
| `init-gitignore` | Scan the codebase, detect languages and frameworks, and compose a `.gitignore` with user approval |
| `init-readme` | Create a `README.md` with standard Open Horizon sections or audit an existing one for missing sections |
| `init-maintainers` | Create or update `MAINTAINERS.md` in the canonical Open Horizon table format |
| `init-makefile` | Stub a `Makefile` with standard Open Horizon targets for services using third-party containers |
| `init-obsidian` | Set up Obsidian CLI and install skills for memory management |
| `gitignore-snippets` | Reference library of `.gitignore` snippets for common stacks (Node, Python, Java, Go, etc.) |

## Initialize the repository

Ask your ML-assisted IDE to `init repo`.  It will then go through all the skills listed above.  If that doesn't work, reference the `@init-repo.md` workflow file and instruct the tool to read the contents and follow the guidance.  If you do not want to run all of the skills at one go, manually run each skill that you do want to execute.

### LICENSE.md

Ask your ML-assisted IDE to `init license`.  It will create a license file if one does not exist, populate the contents with a preferred license of your choice if the file is empty, and it will fill in license placeholders if they are not populated.

### .gitignore

Ask your ML-assisted IDE to `init gitignore`.  It will scan the codebase and propose to populate the `.gitignore` file with sane defaults per best practices.

### README.md

Ask your ML-assisted IDE to `init readme` to create a new README.md with standard Open Horizon sections (shields, prerequisites, installation, usage, debugging, Makefile targets), or to audit an existing one and recommend missing sections.

### MAINTAINERS.md

Ask your ML-assisted IDE to `init maintainers`.  It will extract your name, github ID, and email address from git defaults and populate the structure.  It will give you the option of adding more maintainers, and adding an emeritus section.

### Makefile stub

Ask your ML-assisted IDE to `init makefile`. It will stub out the makefile based on the current repository information and create default targets.  Test each target to confirm correct functionality.

### Optionals

When you're ready to begin working on the code, start in a terminal at the root directory of your repository and initialize the project plan with the editor of your choice.  For example, if you're using `bob`, then type:

```bash
openspec init --tools bob
```

Then start your editor:

```bash
bob
```

And then describe the work you'd like to begin as an Open Spec proposal using the `/opsx-propose` slash command.  This could be text straight from an issue, or a short feature description.  If needed, paste the URL of the github issue or description.  For example:

```bash
/opsx-propose “Work on adding the optional section to the documentation described in the GitHub issue https://github.com/open-horizon-services/skills-open-horizon/issues/5”
```

Review what was created.  When you're satisfied with the results, begin development with the Open Spec apply slash command:

```bash
/opsx-apply
```

## Contributing

Contributions are welcome. Open an issue at [github.com/open-horizon-services/skills-open-horizon](https://github.com/open-horizon-services/skills-open-horizon).

New skills should follow the existing conventions: a directory under `.agent/skills/{skill-name}/` containing a `SKILL.md` with YAML frontmatter (`name`, `description`), step-by-step instructions, guardrails, and example output. Workflows live in `.agent/workflows/*.md`.

## License

[Apache 2.0](LICENSE.md)