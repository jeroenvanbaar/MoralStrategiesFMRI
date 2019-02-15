#!/bin/sh
# install torque prologue and epilogue scripts 
# to /bin and set correct file permissions
# scripts are based on: 
# http://docs.adaptivecomputing.com/torque/3-0-5/a.gprologueepilogue.php

# create ~/bin folder if it doesn't exist yet
[ -d ~/bin ] || mkdir ~/bin

# copy scripts
cp torque_prologue.sh ~/bin
cp torque_epilogue.sh ~/bin

# set proper access rights - torque expects these
chmod 700 ~/bin/torque_prologue.sh
chmod 700 ~/bin/torque_epilogue.sh

echo "torque prologue and epilogue scripts copied to ~/bin"