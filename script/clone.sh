#!/bin/sh
set -e -x

mkdir -p "`dirname "$1"`"
mkdir "$1"
cd "$1"
branch="${2:-master}"

git init
git remote add 3ofcoins/idk-repo git@github.com:3ofcoins/idk-repo.git
git fetch 3ofcoins/idk-repo
git commit --allow-empty -m '(init)'
git merge --no-ff --no-edit 3ofcoins/idk-repo/$branch

berks install
git add Berksfile.lock
git commit -m berks

vendor install
