#!/bin/bash

# Load asdf
. $HOME/.asdf/asdf.sh

# Set the specific Node.js version you want to use
asdf local nodejs 20.5.1

# Start tsserver
exec typescript-language-server "$@"

