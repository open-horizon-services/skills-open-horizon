Skills live in `.agent/skills/{skill-name}/SKILL.md`
Workflows or tasks live in `.agent/workflows/*.md`

Open Horizon-specific skills should use the `oh-` prefix in their skill directory (for example: `.agent/skills/oh-init-service/SKILL.md`). The `oh-` prefix helps discovery and tooling filters. To further aid discovery, include `oh` or `open-horizon` in the SKILL.md tags/frontmatter.

Read from those folders and create new files following a similar pattern in those folders.  Do not read, modify, or otherwise write skills and workflows elsewhere if intended to be used by this codebase.

If you find a skill or workflow anywhere else, recommend moving it to the correct location, using the right naming conventions, and formatting the contents appropriately.

## Security Guidelines

**CRITICAL: Credential Protection**

When working with Open Horizon credentials, especially `HZN_EXCHANGE_USER_AUTH`:
- **NEVER** print or display the actual value of `HZN_EXCHANGE_USER_AUTH` to the screen
- **ALWAYS** mask credential values when displaying commands or output
- Use `${HZN_EXCHANGE_USER_AUTH}` in examples and documentation
- When showing command output that includes credentials, replace with `***MASKED***` or similar
- This applies to all skills, workflows, and documentation

Example of proper credential handling:
```bash
# CORRECT - uses variable reference
hzn exchange user list -u "${HZN_EXCHANGE_USER_AUTH}"

# CORRECT - masked in output
HZN_EXCHANGE_USER_AUTH=***MASKED***

# INCORRECT - never do this
HZN_EXCHANGE_USER_AUTH=admin:actualpassword123
```

