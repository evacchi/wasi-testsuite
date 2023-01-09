#!/bin/bash

TEST_FILE=
ARGS=()
PROG_ARGS=()

while [[ $# -gt 0 ]]; do
    case $1 in
    --version)
        exec wazero version
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
        ARGS+=("-mount" "$2")
        shift
        shift
        ;;
    *)
        echo "Unknown option $1"
        exit 1
        ;;
    esac
done

TEST_DIR=$(dirname "$TEST_FILE")
TEST_FILE=$(basename "$TEST_FILE")

cd "$TEST_DIR"
exec wazero run -hostlogging filesystem "${ARGS[@]}" "$TEST_FILE" -- "${PROG_ARGS[@]}"
