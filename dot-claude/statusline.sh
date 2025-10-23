#!/usr/bin/env bash

INPUT=$(cat)

MODEL=$(echo "$INPUT" | jq -r '.model.display_name // "Unknown"')
BRANCH=$(git -c gc.autodetach=false -c advice.detachedHead=false rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-git")
COST_USD=$(echo "$INPUT" | jq -r '.cost.total_cost_usd // 0')
COST=$(printf "\$%.2f" "$COST_USD")
DIR=$(echo "$INPUT" | jq -r '.workspace.current_dir // "~"')
DIR="${DIR/#$HOME/~}"
echo "🤖 $MODEL | 🌿 $BRANCH | 💰 $COST | 📁 $DIR"
