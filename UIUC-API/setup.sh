#!/bin/bash

command -v pip >/dev/null 2>&1 ||  { echo >&2 "I require pip but it's not installed.  Aborting."; exit 1; }

if ! [ -a bin/activate ]; then
        echo "virtualenv not setup yet. setting up virtualenv"; 
        virtualenv . ;
fi
source bin/activate ;
pip install -r requirements.txt ; 



