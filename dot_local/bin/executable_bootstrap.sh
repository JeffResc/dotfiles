#!/bin/bash

chezmoi apply
brew bundle --file=~/.Brewfile
exec zsh
