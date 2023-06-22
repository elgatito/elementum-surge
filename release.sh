#!/bin/bash

set -e

export GOPATH=$HOME/go
unset GOROOT

sudo -S true

# Run generator that is generating static files and then pushing them to surge and github.
./generate.sh