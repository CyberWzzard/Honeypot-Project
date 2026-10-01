#!/usr/bin/env bash
# Lightweight fallback hook for anyone who can't install the `pre-commit`
# framework (preferred - see .pre-commit-config.yaml).
#
# Install (run once per clone, from the repo root; works in Git Bash on Windows):
#   cp scripts/pre-commit-secret-check.sh .git/hooks/pre-commit
#   chmod +x .git/hooks/pre-commit

# NUL-separated so file names with spaces are handled correctly.
mapfile -d '' STAGED_FILES < <(git diff --cached --name-only --diff-filter=ACM -z)

# 1. Block any real .env file (but allow .env.example)
for file in "${STAGED_FILES[@]}"; do
    base=$(basename "$file")
    if [[ "$base" == ".env" ]] || [[ "$base" == *.env ]]; then
        echo "BLOCKED: '$file' looks like a real .env file."
        echo "  git restore --staged \"$file\""
        exit 1
    fi
done

# 2. Warn on real-credential-shaped strings OUTSIDE the honeypot bait
# directory (bait is expected to look real, and is gitignored anyway).
SUSPECT_PATTERN='AKIA[0-9A-Z]{16}|sk_live_[0-9a-zA-Z]{10,}|ghp_[0-9a-zA-Z]{30,}|npm_[0-9a-zA-Z]{30,}|mongodb(\+srv)?://[^:@/ ]+:[^@/ ]+@|-----BEGIN ([A-Z]+ )?PRIVATE KEY-----'

for file in "${STAGED_FILES[@]}"; do
    [[ "$file" == *cowrie-honeyfs/* ]] && continue
    if git diff --cached -- "$file" 2>/dev/null | grep '^+' | grep -E -q "$SUSPECT_PATTERN"; then
        echo "WARNING: '$file' contains something that looks like a real credential."
        echo "If it's a real secret, stop and remove it now."
        # Git hooks get no keyboard on stdin; read from the terminal instead.
        confirm="n"
        if { exec 3</dev/tty; } 2>/dev/null; then
            read -r -p "Continue with this commit anyway? (y/N) " confirm <&3
            exec 3<&-
        else
            echo "(No terminal available to confirm - commit blocked.)"
        fi
        [[ "$confirm" == "y" ]] || exit 1
    fi
done

exit 0
