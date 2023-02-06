import argparse
import os
import sys
import subprocess

parser = argparse.ArgumentParser()
parser.add_argument('--version', action='store_true')
parser.add_argument('--test-file', action='store')
parser.add_argument('--arg', action='append', default=[])
parser.add_argument('--env', action='append', default=[])
parser.add_argument('--dir', action='append', default=[])

args = parser.parse_args()

if args.version:
    version=subprocess.run(['wazero', 'version'], capture_output=True, text=True).stdout.strip()
    if version=='dev':
        version='0.0.0'
    print("wazero", version)
    sys.exit(0)

TEST_FILE=args.test_file
TEST_DIR=os.path.dirname(TEST_FILE)
PROG_ARGS=[]
if args.arg:
    PROG_ARGS=['--']+args.arg
ENV_ARGS=[j for i in args.env for j in ["-env", i]]
cwd=os.getcwd()
DIR_ARGS=[f"-mount={cwd}/{dir}:/{dir}" for dir in args.dir]

PROG=["wazero"] + ["run", "-hostlogging=filesystem"] + ENV_ARGS + DIR_ARGS + [TEST_FILE] + PROG_ARGS
print(PROG)
print(TEST_DIR)
subprocess.run(PROG, cwd=TEST_DIR)
