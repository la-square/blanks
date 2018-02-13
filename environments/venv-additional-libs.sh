#!/usr/bin/env bash

#Script install additional python libs using pip

#Script takes a value: -n app_name -v env_name, -p pkg_name

#Example: 
#venv-additional-lib.sh -n project -v .venv_projectname -p django-resized

#----------------------------------------------------------------------------
#Check options

while [[ $# -gt 1 ]]
do
	key="$1"
	case $key in
		-n|--name)
		APP_NAME=$2
		shift ;;
		-v|--venv)
		VENV_FOLDER=$2
		shift ;;
		-p|--pkg)
		PYTHON_PKG=$2
		shift ;;
	esac
	shift
done

if [[ $APP_NAME = "" ]]; then
	echo "ERR: forgot APP_NAME attr."
	exit 1
fi

if [[ $VENV_FOLDER = "" ]]; then
	echo "ERR: forgot VENV_FOLDER attr."
	exit 1
fi

if [[ $PYTHON_PKG = "" ]]; then
	echo "ERR: forgot PYTHON_PKG attr."
	exit 1
fi


#----------------------------------------------------------------------------
#Install pkg

venv_path="/home/hotdog/$APP_NAME/$VENV_FOLDER"

source $venv_path/bin/activate

pip install $PYTHON_PKG
