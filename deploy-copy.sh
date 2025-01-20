#!/bin/bash
set -x
cp -r $(pwd)/emacs ~/.emacs.d
cp $(pwd)/dot-clang-format ~/.clang-format
cp $(pwd)/dot-zshrc ~/.zshrc
cp $(pwd)/dot-zsh-plugins-txt ~/.zsh_plugins.txt
