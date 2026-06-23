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

Ask your ML-assisted IDE to `init repo`.  It will then go through all the skills listed below.  If that doesn't work, reference the `@init-repo.md` workflow file and instruct the tool to read the contents and follow the guidance.  If you do not want to run all of the skills at one go, manually run each skill that you do want to execute.

### LICENSE.md

Ask your ML-assisted IDE to `init license`.  It will create a license file if one does not exist, populate the contents with a preferred license of your choice if the file is empty, and it will fill in license placeholders if they are not populated.

### .gitignore

Ask your ML-assisted IDE to `init gitignore`.  It will scan the codebase and propose to populate the `.gitignore` file with sane defaults per best practices.

### README.md

Use the `init-readme` skill to create a new README.md with standard Open Horizon sections (shields, prerequisites, installation, usage, debugging, Makefile targets), or to audit an existing one and recommend missing sections.

### MAINTAINERS.md

Ask your ML-assisted IDE to `init maintainers`.  It will extract your name, github ID, and email address from git defaults and populate the structure.  It will give you the option of adding more maintainers, and adding an emeritus section.  

### Makefile stub

Ask your ML-assisted IDE to `init makefile`. It will stub out the makefile based on the current repository information and create default targets.  Test each target to confirm correct functionality. 

### Optionals

