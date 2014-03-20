#!/bin/sh

ZZEMACS_ROOT=`pwd`

echo install .emacs to HOME directory begin...


function Install_package() {
    # dectect OS version
    LINUX_DISTRO=`lsb_release -si`
    if [ "$LINUX_DISTRO" == "SUSE LINUX" ]; then
        LINUX_DISTRO="SuSE"
    else if [ "$LINUX_DISTRO" == "Ubuntu" ]; then
        LINUX_DISTRO="Ubuntu"
        
        sudo apt-get install -y emacs
        sudo apt-get install -y cscope
        sudo apt-get install -y texinfo
        
        ##install font
        FONT_HOME=/usr/share/fonts/truetype/
        sudo cp -f ${ZZEMACS_ROOT}/font/consola.ttf  ${FONT_HOME}
        sudo cp -f ${ZZEMACS_ROOT}/font/MSYHMONO.ttf ${FONT_HOME}
    else
        echo "You are about to install on a non supported linux distribution."
    fi
        
    echo "Install on $LINUX_DISTRO ..."
}


##install package for emacs
echo -n "Do you need install packages? (y/N): "
read answer
case "$answer" in
    "Y" | "y" )
        Install_package
        ;;
esac

exit 0

##setup .emacs
rm -f ~/.emacs
cat > ~/.emacs <<EOF
;;;this is .emacs for zhoujd.
(defvar zzemacs-path "${ZZEMACS_ROOT}/")
(if (file-exists-p (concat zzemacs-path ".emacs"))
    (load-file (concat zzemacs-path ".emacs"))
    (message "zzemacs has not install"))
EOF

##git setting
git config user.name  "zhoujd"
git config user.email "zjd-405@163.com"

##install pymacs
cd ${ZZEMACS_ROOT}/third-party/python
./install.sh
cd ${ZZEMACS_ROOT}

##install pde
cd ${ZZEMACS_ROOT}/site-lisp/pde
perl ./Build.PL
perl ./Build test
perl ./Build
perl ./Build install
cd ${ZZEMACS_ROOT}

##install EPL
cd ${ZZEMACS_ROOT}/third-party/perl/EPL
perl Makefile.PL
make
sudo make install
cd ${ZZEMACS_ROOT}

echo install .emacs to HOME directory end...

