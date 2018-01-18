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

check_file() {
  FILE=$1
  TIP=$2
  if [[ -e "./${FILE}" ]]; then
    echo "CHECK FILE: ${FILE}"
  else
    echo "${FILE} does NOT exist, ${TIP}"
  fi
}

# - Checking ---------------------
check_command git 'apt install git'
check_command postcss 'npm i -g postcss-cli'

check_file .env "cp .env.sample .env && vi .env"
check_file nginx.tmpl "curl https://raw.githubusercontent.com/jwilder/nginx-proxy/master/nginx.tmpl > /path/to/nginx.tmpl"
