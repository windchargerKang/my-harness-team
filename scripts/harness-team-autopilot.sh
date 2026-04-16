#!/usr/bin/env bash
set -euo pipefail

TASK="${1:-}"
MODE="${2:---default}"

if [ -z "$TASK" ]; then
  echo "Usage: $0 \"<task or change-id>\" [--quick|--strict]"
  exit 1
fi

if [ "$MODE" != "--default" ] && [ "$MODE" != "--quick" ] && [ "$MODE" != "--strict" ]; then
  echo "[ERROR] unsupported mode: $MODE"
  exit 1
fi

echo "[AUTOPILOT] start task: $TASK"
echo "[AUTOPILOT] mode: ${MODE#--}"

echo "[AUTOPILOT] phase 1/9: propose"
echo "[AUTOPILOT] phase 2/9: plan"
echo "[AUTOPILOT] phase 3/9: prd"
echo "[AUTOPILOT] phase 4/9: apply"
echo "[AUTOPILOT] phase 5/9: verify"
echo "[AUTOPILOT] phase 6/9: fix-loop (if needed)"
echo "[AUTOPILOT] phase 7/9: review"
echo "[AUTOPILOT] phase 8/9: archive"
echo "[AUTOPILOT] phase 9/9: knowledge"

echo "[AUTOPILOT] done (skeleton). integrate with slash-command orchestrator next."