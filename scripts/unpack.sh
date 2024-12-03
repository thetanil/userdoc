#!/bin/sh
set -e

OLDPWD=$(pwd)
TMPDIR=$(mktemp -d)
trap 'rm -rf $TMPDIR' EXIT

cd "$TMPDIR"
unzip /tmp/act_artifacts/1/userdoc-vm/userdoc-vm.zip

mkdir -pv ./input
mkdir -pv ./output

./launch.sh ./input ./output