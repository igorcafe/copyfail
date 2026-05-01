#!/usr/bin/env bash

set -eu

echo "> remove payload.rebuilt.elf just in case"
rm payload.rebuilt.elf 2> /dev/null || true

echo "> assemble"
nasm -f bin payload.asm -o payload.rebuilt.elf

echo "> compare payloads"
cmp -s payload.original.elf payload.rebuilt.elf

echo "> payload is identical"
sha256sum payload.original.elf payload.rebuilt.elf
