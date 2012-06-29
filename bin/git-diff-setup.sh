#!/bin/sh

GIT_SETUP_HOME=`pwd`

echo git diff setup start ...

# setup packages
sudo apt-get install -y python-nautilus python-configobj python-gtk2 python-glade2 python-svn python-dbus meld
sudo apt-get install -y python-meld3
sudo apt-get install -y git-core

# setup git configure
git config --global user.name  "zhoujd"
git config --global user.email "zjd-405@163.com"
git config --global merge.tool "meld" 
git config --global color.ui   true

echo ===========git config start ===============
git config --list
echo ===========git config end =================

# setup diff setting
chmod +x $GIT_SETUP_HOME/git-diff-wrapper.sh 
git config --global diff.external $GIT_SETUP_HOME/git-diff-wrapper.sh

echo git diff setup end ...
