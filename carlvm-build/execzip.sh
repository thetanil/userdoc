#!/bin/sh
# Self-extracting archive script
# unzip -q ./carl.vm -d "$TMPDIR"
# echo "Extracting..."
TMPDIR=$(mktemp -d)
#
# THIS MAGIC NUMBER MUST MATCH FILE LENGTH FROM THE TAIL COMMAND
#
tail -n +$((LINENO + 6)) "$0" > "$TMPDIR/vm.zip"
cd "$TMPDIR"
unzip vm.zip
./qrun.sh
rm -rf "$TMPDIR"
exit
