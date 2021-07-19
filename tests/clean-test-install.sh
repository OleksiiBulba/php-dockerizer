#!/bin/bash

TEST_DIR=${1-'./tests/install'}
TEST_DIR=$(realpath $TEST_DIR)
echo Removing test files from ${TEST_DIR}
rm -rf ${TEST_DIR}/.docker
rm -rf ${TEST_DIR}/.make
rm -rf ${TEST_DIR}/Makefile
echo Done