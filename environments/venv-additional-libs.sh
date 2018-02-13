#!/usr/bin/env bash

#Script install additional python libs using pip

#Script takes a value: env_name, lib_name
#As default value use pattern: venv_[a-z]*

#Example: 
#venv-additional-lib.sh venv_projectname django-resized

VENV_FOLDER=$1
PYTHON_LIB=$2

if [[ $VENV_FOLDER = "" ]]; then
    exit 1
fi

venv_path="/home/hotdog/$VENV_FOLDER"

source $venv_path/bin/activate

pip install $PYTHON_LIB
