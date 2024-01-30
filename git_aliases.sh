#!/bin/bash

echo "alias ga='git add .'" >> ~/.bashrc
echo "alias gd='git diff'" >> ~/.bashrc
echo "alias gs='git status'" >> ~/.bashrc
echo "alias gfs='git diff --staged'" >> ~/.bashrc
echo "alias gcm='git commit -m'" >> ~/.bashrc
echo "alias sga='grep git ~/.bashrc'" >> ~/.bashrc
echo -e "\033[32mok, you need to use command below:\nsource ~/.bashrc"
