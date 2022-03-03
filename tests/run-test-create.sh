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

CLEAN_ON_EXIT=1
while getopts 'c' flag; do
    case "${flag}" in
      c) CLEAN_ON_EXIT=0; shift ;; # redirect stdout to /dev/null
      *) ;;
    esac
done

source "$DIR"/lib/colors.sh
current_branch=$(git branch --show-current)
branch=${1:-$current_branch}
echo -e "Branch ${YELLOW}$branch${NC} will be used for test"
# Ensure run-test-create.sh is run from project root path
if [[ -d $DIR/create ]]; then
    rm -r "$DIR/create" || exit 1
fi
mkdir "$DIR/create" || exit 1
[[ ! -d $DIR/create ]] && echo -e "${RED}${CROSS}${NC} Cannot find 'create' folder in $DIR" && exit 1
printf "Creating symfony project in '%s/create' folder... " "${DIR}"
cd "$DIR/create" || exit 1
curl -s https://raw.githubusercontent.com/OleksiiBulba/php-dockerizer/"$branch"/bin/create | bash -s -- symfony/skeleton "$branch" || exit 1
echo 'Running tests:'
echo -e "${RED}${CROSS}${NC} - No tests created yet"
if [[ "$CLEAN_ON_EXIT" == "0" ]]; then
    printf "Cleaning after tests... " && "$DIR"/clean-test-install.sh -q && echo -e "${GREEN}Done${NC}" || exit 1
fi