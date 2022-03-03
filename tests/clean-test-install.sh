#!/bin/bash

function resolve_dir() {
    SOURCE="${BASH_SOURCE[0]}"
    # resolve $SOURCE until the file is no longer a symlink
    while [ -h "$SOURCE" ]; do
      DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
    done
    DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
    export DIR
}

resolve_dir

exec 6>&1 # saves stdout
while getopts 'q' flag; do
    case "${flag}" in
      q) exec > /dev/null ;; # redirect stdout to /dev/null
      *) ;;
    esac
done

source "$DIR"/lib/colors.sh
TEST_DIR=$DIR/install
printf "Removing all test files from %s... " "${TEST_DIR}"
rm -rf "${TEST_DIR}"/.dockerizer
rm -rf "${TEST_DIR:?}"/*
rm -rf "${TEST_DIR}"/.env*
echo -e "${GREEN}Done${NC}"
exec 1>&6 6>&- # restore stdout
