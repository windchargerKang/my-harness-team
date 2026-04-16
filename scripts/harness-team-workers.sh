#!/usr/bin/env bash
set -euo pipefail

ACTION="${1:-status}"
CHANGE_ID="${2:-default}"
SESSION="harness-${CHANGE_ID}"

require_tmux() {
  if ! command -v tmux >/dev/null 2>&1; then
    echo "[ERROR] tmux 未安装，请先安装 tmux" >&2
    exit 1
  fi
}

start_session() {
  require_tmux
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "[INFO] session 已存在: $SESSION"
    return
  fi

  tmux new-session -d -s "$SESSION" -n workers
  tmux send-keys -t "$SESSION":0.0 "echo '[planner] ready for ${CHANGE_ID}'" C-m

  tmux split-window -h -t "$SESSION":0
  tmux send-keys -t "$SESSION":0.1 "echo '[executor] ready for ${CHANGE_ID}'" C-m

  tmux split-window -v -t "$SESSION":0.0
  tmux send-keys -t "$SESSION":0.2 "echo '[verifier] ready for ${CHANGE_ID}'" C-m

  tmux split-window -v -t "$SESSION":0.1
  tmux send-keys -t "$SESSION":0.3 "echo '[reviewer] ready for ${CHANGE_ID}'" C-m

  tmux select-layout -t "$SESSION":0 tiled
  echo "[SUCCESS] tmux workers started: $SESSION"
  echo "Attach: tmux attach -t $SESSION"
}

status_session() {
  require_tmux
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "[INFO] session running: $SESSION"
    tmux list-panes -t "$SESSION":0 -F "pane #{pane_index}: #{pane_title} #{pane_current_command}"
  else
    echo "[INFO] session not found: $SESSION"
  fi
}

attach_session() {
  require_tmux
  tmux attach -t "$SESSION"
}

stop_session() {
  require_tmux
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux kill-session -t "$SESSION"
    echo "[SUCCESS] session stopped: $SESSION"
  else
    echo "[INFO] session not found: $SESSION"
  fi
}

case "$ACTION" in
  start) start_session ;;
  status) status_session ;;
  attach) attach_session ;;
  stop) stop_session ;;
  *)
    echo "Usage: $0 {start|status|attach|stop} <change-id>"
    exit 1
    ;;
esac