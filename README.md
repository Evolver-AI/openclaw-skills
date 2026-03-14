# OpenClaw Skills

Open source skills for [OpenClaw](https://github.com/openclaw/openclaw) agents.

## Available Skills

| Skill | Description |
|-------|-------------|
| [browser-cleanup](./browser-cleanup/) | Detect and kill orphaned browser processes left behind by automation |

## Installation

```bash
openclaw skill install path/to/skill-name
```

Or download the `.skill` file from [Releases](https://github.com/Evolver-AI/openclaw-skills/releases).

## What Are Skills?

Skills are modular packages that extend OpenClaw agents with specialized knowledge, workflows, and tools. They're self-contained — each skill has a `SKILL.md` with instructions and optional scripts/assets.

Learn more: [OpenClaw Docs](https://docs.openclaw.ai)

## Contributing

Have a skill that could help others? PRs welcome.

1. Create a folder with your skill name
2. Add a `SKILL.md` with YAML frontmatter (`name`, `description`)
3. Include any scripts in a `scripts/` subfolder
4. Open a PR

## License

MIT
