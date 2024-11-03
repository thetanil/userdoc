#!/bin/sh
# Self-extracting archive script
echo "Extracting..."
TMPDIR=$(mktemp -d)
unzip -q ./carl.vm -d "$TMPDIR"
cd "$TMPDIR"
./qrun.sh
rm -rf "$TMPDIR"
exit 0