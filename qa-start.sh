#!/usr/bin/env bash
set -e

PID_FILE=".qa-server.pid"
LOG_FILE=".qa-server.log"

# Check if already running
if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "⚠️  QA server already running (PID $(cat "$PID_FILE")). Run ./qa-stop.sh first."
  exit 1
fi

# Find a free port
PORT=$(python3 -c "import socket; s=socket.socket(); s.bind(('',0)); p=s.getsockname()[1]; s.close(); print(p)")

echo "Starting Kormans LTT QA server on port $PORT..."
npx --yes serve -p "$PORT" . > "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"

# Wait for server to be ready (up to 30 seconds)
for i in $(seq 1 30); do
  if nc -z localhost "$PORT" 2>/dev/null; then
    echo "✅ Ready at http://localhost:$PORT"
    echo "   Logs: tail -f $LOG_FILE"
    exit 0
  fi
  sleep 1
done

echo "⚠️  Server may still be starting. Check logs: tail -f $LOG_FILE"
echo "   http://localhost:$PORT"
