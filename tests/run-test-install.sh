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
# Ensure run-test-install.sh is run from project root path
[[ ! -d $DIR/install ]] && echo "Cannot find 'install' folder in $DIR" && exit 1
"$DIR"/clean-test-install.sh
printf 'Copying test files... '; cp -r "$DIR"/files/* "$DIR"/install; [[ $? -eq 0 ]] && echo -e "${GREEN}Done${NC}" || exit 1
printf 'Installing dockerizer... '; curl -s https://raw.githubusercontent.com/OleksiiBulba/php-dockerizer/"$branch"/bin/onlinesetup | bash -s -- https://github.com/OleksiiBulba/php-dockerizer "$branch" "$DIR"/install; echo -e "${GREEN}Done${NC}"
echo 'Running tests:'
[[ -f $DIR/install/Makefile ]] && echo -e "${GREEN}${CHECK}${NC} - Makefile created." || echo -e "${RED}${CROSS}${NC} - Cannot find Makefile."
grep -qxF 'include ./.dockerizer/dockerizer.mk' "$DIR"/install/Makefile && echo -e "${GREEN}${CHECK}${NC} - Makefile contains include directive" || echo -e "${RED}${CROSS}${NC} - Cannot find dockerizer include directive"
make init > /dev/null && [[ -f $DIR/install/.env && -f $DIR/install/.env.local ]] && echo -e "${GREEN}${CHECK}${NC} - Env files are generated" || echo -e "${RED}${CROSS}${NC} - Cannot find env files"
[[ $(find . -maxdepth 1 -name '.env*' | wc -l) -eq 4 ]] && echo -e "${GREEN}${CHECK}${NC} - Env files are generated correctly (4 files)" || echo -e "${RED}${CROSS}${NC} - Env files are not generated correctly"
if [[ "$CLEAN_ON_EXIT" == "0" ]]; then
    printf "Cleaning after tests... " && "$DIR"/clean-test-install.sh -q && echo -e "${GREEN}Done${NC}" || exit 1
fi
