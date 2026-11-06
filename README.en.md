# Agent Delivery Playbook

English | [简体中文](README.md)

Engineering delivery playbook and reusable skills for multi-agent collaboration, supporting built-in subagents and local agent CLIs.

## Installation

Requires Git, curl, and a POSIX shell on macOS, Linux, or Windows through WSL / Git Bash:

```sh
curl -fsSL https://raw.githubusercontent.com/yinghuzhu/agent-delivery-playbook/main/scripts/bootstrap.sh -o /tmp/agent-delivery-playbook-bootstrap.sh && sh /tmp/agent-delivery-playbook-bootstrap.sh install --agent shared
```

Use `--agent shared|codex|claude` to select the shared skills directory or a tool-specific directory. For other tools that support SKILL.md, provide `--dest`. Automatic discovery depends on the target tool. The installer clones into `${XDG_DATA_HOME:-~/.local/share}/agent-delivery-playbook` and creates symbolic links for all five complete skills. Existing entries from another source stop installation; they are not overwritten.

By default, installation selects the latest annotated `YYYYMMDDNN` release tag. It stops if no release exists, without falling back to a branch. The bootstrap downloads the installer from the latest release tag. Use `--ref` to pin a tag or commit; pinned installations do not update automatically. Use `--ref develop` to follow development. `--source` reuses a local repository, and `--checkout` sets the clone location. Moving or deleting the checkout breaks its links.

## Configuration and updates

Personal configuration lives in `${XDG_CONFIG_HOME:-~/.config}/agent-playbook/agents.yaml`. The installer creates it only if absent. Set CLI commands, models, primary choices, and ordered fallbacks there. A project-root `agent-playbook.yaml` can override it. Precedence: current explicit user instructions → project configuration → personal configuration → the skill's default `agents.yaml`. Merge rules are documented in `skills/delivery-workflow/references/agent-selection.md`.

Development, testing, and research share `skills/delivery-workflow/agents.yaml`. `selection.development`, `selection.testing`, `selection.search`, and `selection.review` configure separate primary agents, models, and fallbacks for development, testing, investigation, and independent review. Search and review use separate selections and sessions without inheriting each other's choices. evidence-research has no separate configuration file. Missing research roles in older personal configurations remain unselected and do not affect development or testing.

```sh
sh "${XDG_DATA_HOME:-$HOME/.local/share}/agent-delivery-playbook/scripts/install.sh" update
```

The release channel advances to a newer release tag only when its history descends from the installed commit. The develop channel uses fast-forward updates; pinned versions stay fixed. Local changes or divergent history stop updates. Personal configuration is preserved, and skill links read the updated checkout. Active sessions may need to reload instructions or restart. With a custom checkout location, pass `--checkout` to update.

## Rules and skills

- `AGENTS.md`: review and merge into the target project manually; the installer does not overwrite global rules.
- `delivery-workflow`: design, development, review, independent testing, and human acceptance.
- `acceptance-qa`: business acceptance and related regression testing.
- `bug-record`: traceable defect records.
- `root-cause-investigation`: evidence-based troubleshooting.
- `release-delivery`: artifacts, releases, verification, and rollback.

Research skill draft: [evidence-research](skills/evidence-research/SKILL.md), with exploration and targeted research modes; see the [review report and test cases](docs/skill-reviews/2026-11-06-evidence-research/review-report.md). This draft is not in the installer list and is not one of the five skills installed by default.

All roles follow project authorization. Installation does not authorize commits, pushes, deployments, or external notifications. Model availability must still be verified during actual task execution.

## Branches and releases

Develop on `develop`, then merge validated changes into `main`. Publish an annotated `YYYYMMDDNN` tag on a verified commit. Creating and pushing release tags requires explicit human authorization. Published tags must not be moved or overwritten. Record the tag, commit SHA, changes, and verification results. Default installation and updates follow release tags rather than main HEAD.
