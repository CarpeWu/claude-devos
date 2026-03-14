---
description: "[MANUAL] Validate DevOS setup — invoke explicitly with /validate-setup"
---

Check that all template placeholders have been replaced with real project values and that the DevOS configuration is internally consistent.

## Step 1: Check for Unresolved Placeholders
Scan all files in `.claude/` and `CLAUDE.md` for placeholder patterns

```bash
grep -r "\[PROJECT_NAME\]\|\[e\.g\.\,\]\|\[One-line\]\|\[your-\]\|TODO_REPLACE\|PLACEHOLDER" \
  CLAUDE.md .claude/ --include="*.md" --include="*.json"
```

Any matches indicate the template has not been fully customized.

## Step 2: Validate Key Commands
Check that the commands in CLAUDE.md actually work

- Extract the test command from CLAUDE.md and verify the script exists in package.json (or equivalent)
- Extract the lint command and verify it exists
- Do NOT run the commands — just verify they are defined

## Step 3: Validate Hook Scripts
Check that all hook scripts referenced in `.claude/settings.json` exist and are executable

```bash
# Parse settings.json for hook commands and verify each script exists
jq -r '.hooks[][] | .command' .claude/settings.json 2>/dev/null | while read cmd; do
    # Extract the .sh file path from the command string
    script=$(echo "$cmd" | grep -oE '[^ ]+\.sh' | head -1)
    if [ -z "$script" ]; then
        echo "WARNING: Could not extract script path from command: $cmd"
    elif [ ! -f "$script" ]; then
        echo "MISSING: $script (referenced in settings.json)"
    elif [ ! -x "$script" ]; then
        echo "NOT EXECUTABLE: $script (run: chmod +x $script)"
    else
        echo "OK: $script"
    fi
done
```

## Step 4: Validate Rule Globs
For rules with `globs:` frontmatter, verify that matching files exist

```bash
# Check that glob patterns in rules match at least one file
for rule in .claude/rules/*.md; do
    glob=$(grep "^globs:" "$rule" | sed 's/globs: *//' | tr -d '"')
    if [ -n "$glob" ]; then
        # Use find with the glob pattern to check for matches
        matches=$(find . -path "./$glob" 2>/dev/null | head -1)
        if [ -z "$matches" ]; then
            echo "WARNING: Rule $rule has glob '$glob' but no matching files found"
        fi
    fi
done
```

## Step 5: Report
Output a validation report

```
## DevOS Setup Validation

### ✅ Passed
- [checks that passed]

### ❌ Issues Found
- [placeholder still present in FILE at LINE]
- [command X referenced but not defined]
- [hook script missing or not executable]

### ⚠️ Warnings
- [rule glob matches no files — may be intentional for new projects]
```
