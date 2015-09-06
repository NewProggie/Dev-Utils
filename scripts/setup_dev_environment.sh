#!/bin/bash
# Ask user for name and mail and setup dev environment

SCRIPT_DIR=$(readlink -f $(dirname ${BASH_SOURCE[0]}))

echo "==> Configure local GIT account"
printf 'Full name: '; read FULL_NAME
printf 'Mail: '; read MAIL_ADDRESS
git config --global user.name "$FULL_NAME"
git config --global user.email "$MAIL_ADDRESS"

echo "==> Configure GIT autocrlf line endings"
git config --global core.autocrlf input
git config --global core.safecrlf true

echo "==> Configure GIT push mode"
git config --global push.default simple

echo "==> Configure GIT commit template"
git config --global commit.template $SCRIPT_DIR/gitmessage.txt

echo "==> Prettify GIT log"
git config --global alias.lg "log --color --graph \
    --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset \
    %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

printf "==> Use VIM as editor for GIT commits? [y|n]: "
read yn
if [ $yn == "y" ]; then
    git config --global core.editor vim
fi

