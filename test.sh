#!/usr/bin/env bash

set -eu

echo ">>> TEST: payload.asm"
bash ./payload_test.sh

echo ""

echo ">>> TEST: exploit.py"
TEST=1 python exploit.py
