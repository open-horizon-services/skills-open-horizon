# skills-open-horizon
SKILLS.md file for AI-assisted management of nodes

## Install skills into your project

Run this one-liner from the root of your target repository to download and execute the installer script. It clones this repository into a temporary directory, copies the `.agent` folder into your project, then removes the temporary directory.

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/open-horizon-services/skills-open-horizon/main/install-skills.sh)
```

> **Tip:** The script creates `.agent/` in your current working directory, so run it from your repository root.

## Pre-requisites

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

Install the Obsidian desktop app and activate the CLI.

Then install the Obsidian skills with the `init-obsidian` skill.

This will give you the ability to create an obsidian-vault for managing memories and keeping your context clean.

## Initialize the repository

Ask your AI-assisted editor to initialize the repository.  If that's too ambiguous, reference the `@init-repo.md` workflow file and instruct the tool to read the contents and follow the guidance.

### LICENSE.md

### .gitignore

### README.md

Use the `init-readme` skill to create a new README.md with standard Open Horizon sections (shields, prerequisites, installation, usage, debugging, Makefile targets), or to audit an existing one and recommend missing sections.

### MAINTAINERS.md

### Makefile stub

### Optionals

