#!/bin/sh
if [[ $1 == "pure" ]]; then
	nixos-rebuild switch --flake .\#envious --use-remote-sudo
else
IMPURITY_PATH=$(pwd) sudo --preserve-env=IMPURITY_PATH nixos-rebuild switch --impure --flake .#envious-impure
fi
