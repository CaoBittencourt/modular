#!/bin/bash

# script path
script_path=$(
    cd -- "$(
        dirname -- "${BASH_SOURCE[0]}"
    )" &>/dev/null && pwd
)

cd $script_path

# repo name
echo Repo name:
read repo

# initial commit message
echo Initial commit message:
read initial_commit

# create master branch
git init --initial-branch master
git add .
git commit -m "$initial_commit"
git tag 1.0.0
git remote add origin "https://github.com/CaoBittencourt/$repo.git"
git push -u origin master

# create dev branch
git checkout -b dev master
git commit -m "$initial_commit"
git merge --no-ff dev
git push -u --tags origin master
git push -u --tags origin dev
