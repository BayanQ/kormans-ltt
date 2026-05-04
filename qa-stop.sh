#!/usr/bin/env bash

PID_FILE=".qa-server.pid"

if [ ! -f "$PID_FILE" ]; then
  echo "No running QA server found (.qa-server.pid missing)."
  exit 0
fi

PID=$(cat "$PID_FILE")
if kill -0 "$PID" 2>/dev/null; then
  kill "$PID"
  echo "✅ QA server (PID $PID) stopped."
else
  echo "⚠️  No process found with PID $PID — already stopped."
fi

rm -f "$PID_FILE"
