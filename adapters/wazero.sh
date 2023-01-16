#!/bin/bash

TEST_FILE=
ARGS=()
PROG_ARGS=("--")

while [[ $# -gt 0 ]]; do
    case $1 in
    --version)
        # The test runner expects a version printed out in two parts, the first
        # is the name of the runtime and the second is the version number.
        version=$(wazero version)
        if [ "$version" == "dev" ]; then
            version=0.0.0
        fi
        echo wazero $version
        exit 0
        ;;
    --test-file)
        TEST_FILE="$2"
        shift
        shift
        ;;
    --arg)
        PROG_ARGS+=("$2")
        shift
        shift
        ;;
    --env)
        ARGS+=("-env" "$2")
        shift
        shift
        ;;
    --dir)
	# TODO: the mount should only include $2 not the basedir of it.
        ARGS+=("-mount=${PWD}:/")
        shift
        shift
        ;;
    *)
        echo "Unknown option $1"
        exit 1
        ;;
    esac
done

# Do not inject the "--" separator if there are no arguments, or wazero errors.
if [ "${#PROG_ARGS[@]}" -eq 1 ]; then
    PROG_ARGS=()
fi

# Run the tests in the test directory because the --dir arguments are given as
# paths relative to the test file.
TEST_DIR=$(dirname "$TEST_FILE")

cd "$TEST_DIR"
set -x # echo the next line, useful for debugging to re-run failing tests
exec wazero run -hostlogging=filesystem "${ARGS[@]}" "$TEST_FILE" "${PROG_ARGS[@]}"

