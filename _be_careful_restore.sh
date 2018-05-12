#!/usr/bin/env bash

readonly LOC="$1"
readonly LINE="                        "

if [[ "$2" =~ "--print" ]]; then
  echo "PRINT ONLY MODE"
  readonly PRINT_ONLY="1"
else
  echo "RESTORE MODE, to see print only, pass --print as \$2"
  readonly PRINT_ONLY="0"
fi

cd "$1"

# ---- vars end

if ls $LOC/*tar* 1> /dev/null 2>&1; then
  echo "Found tar files as $LOC/*tar*"
else
  echo "No tar found in $LOC/, exiting..."
  exit
fi

function restore {
  if [ "$PRINT_ONLY" == "1" ]; then
    echo "docker run -it --rm -v $1:/volume -v $LOC:/backup alpine sh -c \"rm -rf /volume/* ; tar -C /volume/ -xf '/backup/$2'\""
  else
    printf "RESTORE %s %s from $LOC/$2\n" $1 "${LINE:${#1}}"
    confirm_or_quit
    docker run -it --rm -v $1:/volume -v $LOC:/backup alpine sh -c "rm -rf /volume/* ; tar -C /volume/ -xf '/backup/$2'"
  fi
}

function confirm_or_quit {
  read -p "Are you sure? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ ! $REPLY =~ ^[Yy]$ ]]
  then
      exit 1
  fi
}

function restore_by_file_name {
  file="$1"
  filename="${f##*\/}" # stripe out folder path
  volume="${filename//.*/}"
  restore $volume $filename
}

# Restore
for f in $LOC/*tar*; do
  restore_by_file_name $f
done

