#!/usr/bin/env python3
"""Generate deterministic local-Git context for a future Codex session."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from pathlib import Path


TEXT_SUFFIXES = {".verse", ".py", ".json", ".ini", ".toml", ".yaml", ".yml", ".md"}
IMAGE_SUFFIXES = {".png", ".jpg", ".jpeg", ".webp"}
BINARY_SUFFIXES = {".uasset", ".umap"}


def run_git(repo: Path, *args: str) -> str:
    result = subprocess.run(
        ["git", *args],
        cwd=repo,
        text=True,
        encoding="utf-8",
        errors="replace",
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if result.returncode != 0:
        command = "git " + " ".join(args)
        raise SystemExit(f"{command} failed ({result.returncode}):\n{result.stderr.strip()}")
    return result.stdout.rstrip()


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def changed_records(repo: Path, base: str, head: str) -> list[tuple[str, str]]:
    output = run_git(repo, "diff", "--name-status", "--find-renames", f"{base}..{head}")
    records: list[tuple[str, str]] = []
    for line in output.splitlines():
        if not line.strip():
            continue
        parts = line.split("\t")
        status = parts[0]
        path = parts[-1]
        records.append((status, path))
    return records


def text_diff(repo: Path, base: str, head: str, path: str, limit: int) -> str:
    diff = run_git(repo, "diff", "--no-ext-diff", "--unified=4", f"{base}..{head}", "--", path)
    if len(diff) <= limit:
        return diff
    return diff[:limit] + f"\n\n[diff truncated after {limit} characters]"


def fenced(value: str) -> str:
    return "```text\n" + (value if value else "(none)") + "\n```"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    parser.add_argument("--base", required=True)
    parser.add_argument("--head", default="HEAD")
    parser.add_argument("--validation", type=Path)
    parser.add_argument("--output", type=Path, default=Path("CODEX_CONTINUATION_CONTEXT.md"))
    parser.add_argument("--diff-limit", type=int, default=30000)
    args = parser.parse_args()

    repo = args.repo.resolve()
    base = run_git(repo, "rev-parse", "--verify", f"{args.base}^{{commit}}")
    head = run_git(repo, "rev-parse", "--verify", f"{args.head}^{{commit}}")
    branch = run_git(repo, "branch", "--show-current") or "(detached)"
    commits = run_git(
        repo,
        "log",
        "--reverse",
        "--format=%H%x09%ad%x09%s",
        "--date=short",
        f"{base}..{head}",
    )
    stat = run_git(repo, "diff", "--stat", f"{base}..{head}")
    status = run_git(repo, "status", "--short")
    records = changed_records(repo, base, head)

    validation_text = "(not supplied)"
    if args.validation:
        validation_path = args.validation
        if not validation_path.is_absolute():
            validation_path = repo / validation_path
        try:
            validation = json.loads(validation_path.read_text(encoding="utf-8"))
        except (OSError, json.JSONDecodeError) as exc:
            raise SystemExit(f"Unable to read validation results {validation_path}: {exc}") from exc
        validation_text = json.dumps(validation, indent=2, sort_keys=True)

    binary_rows: list[str] = []
    screenshots: list[str] = []
    text_sections: list[str] = []
    for change_status, relative in records:
        path = repo / relative
        suffix = path.suffix.lower()
        if suffix in IMAGE_SUFFIXES:
            screenshots.append(f"- `{change_status}` `{relative}`")
        if suffix in BINARY_SUFFIXES:
            if path.exists():
                binary_rows.append(
                    f"- `{change_status}` `{relative}` — {path.stat().st_size} bytes — SHA-256 `{sha256(path)}`"
                )
            else:
                binary_rows.append(f"- `{change_status}` `{relative}` — absent at head")
        elif suffix in TEXT_SUFFIXES:
            text_sections.append(f"### {relative}\n\n{fenced(text_diff(repo, base, head, relative, args.diff_limit))}")

    changed = "\n".join(f"- `{change_status}` `{relative}`" for change_status, relative in records) or "- (none)"
    document = f"""# Codex continuation context

This file is generated only from local Git data and the supplied structured validation record.

## Repository range

- Branch: `{branch}`
- Base SHA: `{base}`
- Head SHA: `{head}`
- Range: `{base}..{head}`

## Commits, oldest first

{fenced(commits)}

## Diff stat

{fenced(stat)}

## Changed files

{changed}

## Important changed binary files

{chr(10).join(binary_rows) if binary_rows else "- (none)"}

## Screenshots added in this range

{chr(10).join(screenshots) if screenshots else "- (none)"}

## Structured validation

```json
{validation_text}
```

## Current worktree status at generation time

{fenced(status)}

## Relevant text diffs

{chr(10).join(text_sections) if text_sections else "(none)"}
"""

    output = args.output
    if not output.is_absolute():
        output = repo / output
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(document, encoding="utf-8", newline="\n")
    print(output)


if __name__ == "__main__":
    main()
