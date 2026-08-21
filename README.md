# QM Skills

This private repository is the Git source of truth for skills published to the QM Skill Market.

Each skill lives under `skills/<name>/SKILL.md`. Merging a valid change to `main` makes it eligible for the configured QM Skill Pack mirror. Removing a skill directory causes its Market listing to be delisted while installed copies remain available.

Do not store tokens, passwords, signing secrets, private keys, or customer data in this repository.

## Structure

```text
skills/
  <name>/
    SKILL.md
    references/
    scripts/
```

Skill assets must be UTF-8 text files. The validation workflow rejects binary files, duplicate names, unsafe paths, empty instructions, and common secret formats.
