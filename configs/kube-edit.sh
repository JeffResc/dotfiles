#!/bin/bash

if [ "$TERM_PROGRAM" = "vscode" ]; then
  code --wait "$@"
else
  code --wait --new-window "$@"
fi

