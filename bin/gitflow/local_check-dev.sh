#!/usr/bin/env bash
# Check local dev

check_command() {
  WHERE=`whereis $1`
  TIP=$2

  if [[ -z "${WHERE}" ]]; then
    echo "$1 is required, ${TIP}"
  else
    return
  fi
}

check_command git 'apt install git'
check_command postcss 'npm i -g postcss-cli'
