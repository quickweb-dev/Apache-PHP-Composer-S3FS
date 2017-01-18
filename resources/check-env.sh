#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INVALID_VARIABLE=0

function checkVariable(){
  variable=$1
  echo "Checking ${variable}";
  if [ -z  "${!variable}" ]
  then
	echo "Environment variable not set: ${variable}"
        INVALID_VARIABLE=1
  fi
}

! [ -f  ${DIR}/.env.example ] && echo "File not found: ${DIR}/.env.example" && exit 1

for variable in $(grep . ${DIR}/.env.example | cut -d= -f1)
do
	checkVariable ${variable}
done

exit ${INVALID_VARIABLE}

 
