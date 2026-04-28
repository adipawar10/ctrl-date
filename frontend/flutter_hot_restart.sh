#!/bin/sh
# Sends SIGUSR2 to `flutter run` started with: --pid-file=.flutter_run.pid (hot restart).
cd "$(dirname "$0")" || exit 1
if [ ! -f .flutter_run.pid ]; then
  echo "No .flutter_run.pid — start the app with:"
  echo "  flutter run -d <device> --pid-file=.flutter_run.pid"
  exit 1
fi
if kill -USR2 "$(cat .flutter_run.pid)" 2>/dev/null; then
  echo "Hot restart sent."
else
  echo "Could not signal PID (process may have exited). Start flutter run again."
  exit 1
fi
