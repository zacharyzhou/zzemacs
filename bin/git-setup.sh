#!/usr/bin/env bash

GIT_SETUP_HOME=`pwd`

echo git diff setup start ...

## clear ~/.gitconfig
echo "remove ~/.gitconfig and setting git configure ..."
rm -f ~/.gitconfig

## setup git configure
git config --global user.name    "zhoujd"
git config --global user.email   "zjd-405@163.com"
git config --global color.ui     true
 
### fatal: index-pack failed for win7
#git config --global pack.windowMemory  10m
#git config --global pack.packSizeLimit 20m

### win7 git server (gitblit)
### http://code.google.com/p/gitblit/downloads/detail?name=gitblit-1.0.0.zip
### error: RPC failed; result=18, HTTP code = 0
#git config --global http.postBuffer 524288000

### git diff is called by git with 7 parameters:
### path old-file old-hex old-mode new-file new-hex new-mode

## git default diff using external
#chmod +x $GIT_SETUP_HOME/git-diff-default.sh
#git config --global diff.external $GIT_SETUP_HOME/git-diff-default.sh

## git difftool setting
chmod +x $GIT_SETUP_HOME/git-diff-wrapper.sh
git config --global diff.tool extdiff
git config --global difftool.extdiff.cmd "$GIT_SETUP_HOME/git-diff-wrapper.sh \"\$LOCAL\" \"\$REMOTE\""
git config --global difftool.prompt false

## setup merge setting
chmod +x $GIT_SETUP_HOME/git-merge-wrapper.sh
git config --global merge.tool extmerge
git config --global mergetool.extmerge.cmd "$GIT_SETUP_HOME/git-merge-wrapper.sh \"\$BASE\" \"\$LOCAL\" \"\$REMOTE\" \"\$MERGED\""
git config --global mergetool.extmerge.trustExitCode true
git config --global mergetool.keepBackup false

echo ===========git config start ===============
git config --list
echo ===========git config end =================


echo git diff setup end ...
