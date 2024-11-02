#!/bin/bash
set -e

# dev tools bindir id $HOME/.local/bin
# change to something which is on your $PATH
BINDIR=$HOME/.local/bin

ensure_act() {
    # check if command act is in path
    if ! which act > /dev/null 2>&1
    then
        echo "installing act"
        curl https://raw.githubusercontent.com/nektos/act/master/install.sh | BINDIR=${BINDIR} bash
    fi
}

ensure_act

# actrc is already configured to use this dir
mkdir -p /tmp/act_artifacts

# suppresses log messages
act | grep --color=always -v '::'
# act

