#!/bin/bash

TEST_DIR=${1-'./tests/install'}
TEST_DIR=$(realpath $TEST_DIR)
echo Removing test files from ${TEST_DIR}
rm -rf ${TEST_DIR}/.dockerizer
rm -rf ${TEST_DIR}/.env*
sed -i '/include .\/.dockerizer\/dockerizer.mk/d' ${TEST_DIR}/Makefile
[ -s ${TEST_DIR}/Makefile ] || rm -rf -- ${TEST_DIR}/Makefile
echo Done